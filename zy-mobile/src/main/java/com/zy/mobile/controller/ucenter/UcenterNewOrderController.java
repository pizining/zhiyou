package com.zy.mobile.controller.ucenter;

import com.zy.Config;
import com.zy.common.exception.BizException;
import com.zy.common.model.query.Page;
import com.zy.common.model.tree.TreeHelper;
import com.zy.common.model.tree.TreeNode;
import com.zy.component.LocalCacheComponent;
import com.zy.component.ProductComponent;
import com.zy.component.UserComponent;
import com.zy.entity.mal.OrderFillUser;
import com.zy.entity.mal.Product;
import com.zy.entity.mergeusr.MergeUser;
import com.zy.entity.sys.ConfirmStatus;
import com.zy.entity.usr.Address;
import com.zy.entity.usr.User;
import com.zy.entity.usr.UserInfo;
import com.zy.model.BizCode;
import com.zy.model.Principal;
import com.zy.model.query.OrderFillUserQueryModel;
import com.zy.model.query.UserQueryModel;
import com.zy.service.*;
import com.zy.util.GcUtils;
import com.zy.vo.ProductListVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static com.zy.common.util.ValidateUtils.NOT_NULL;
import static com.zy.common.util.ValidateUtils.validate;
import static com.zy.model.Constants.*;

/**
 * Author: Xuwq
 * Date: 2017/10/31.
 */
@RequestMapping("/u/newOrder")
@Controller
public class UcenterNewOrderController {

    Logger logger = LoggerFactory.getLogger(UcenterOrderCreateController.class);

    @Autowired
    private AddressService addressService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderFillUserService orderFillUserService;

    @Autowired
    private UserInfoService userInfoService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private Config config;

    @Autowired
    private MergeUserService mergeUserService;

    @Autowired
    private ProductComponent productComponent;

    @Autowired
    private LocalCacheComponent localCacheComponent;

    @Autowired
    private UserComponent userComponent;

    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String detail(@PathVariable Long id, Model model) {

        Product product = productService.findOne(id);
        Principal principal = GcUtils.getPrincipal();
        User user = userService.findOne(principal.getUserId());
        User.UserRank userRank = user.getUserRank();
        model.addAttribute("userRank", userRank);

        int isUse = 0;
        Long parentId = user.getParentId();
        if (userRank == User.UserRank.V4){
            //判断时间小于11 11 23 59 59
            Date expiredTime = null;
            Date date = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.set(2017, 10, 11, 23, 59, 59);
            expiredTime = calendar.getTime();
            if (date.getTime() < expiredTime.getTime()){
                isUse = 1;
            }else {
                isUse = 0;
            }
        }
        //判断团队人数
        if (userRank == User.UserRank.V3){
            int whileTimes = 0;
            while (parentId != null) {
                if (whileTimes > 1000) {
                    throw new BizException(BizCode.ERROR, "循环引用错误, user id is " + user.getId());
                }
                User parent = userService.findOne(parentId);
                if (parent.getUserRank() == User.UserRank.V4) {
                    parentId = parent.getId();
                   break;
                }else {
                    parentId = parent.getParentId();
                }
                whileTimes ++;
            }

            //判断特级是否是直升特级
            User parent = userService.findOne(parentId);
            if (parent.getIsToV4() == true){

                //根据id查询团队省级人数
                List<User> list = userComponent.sortBreadthV3(localCacheComponent.getUsers(), parentId.toString());

                //找出第一个特级是parentId
                List<User> uses = new ArrayList<>();
                for (User use: list) {
                    Long pId = this.calculateV4UserId(use);
                    if (pId != null && pId.toString().equals(parentId.toString())){
                        uses.add(use);
                    }
                }
                if (uses.size() >= 8 ){
                    //判断时间小于11 11 23 59 59
                    Date expiredTime = null;
                    Date date = new Date();
                    Calendar calendar = Calendar.getInstance();
                    calendar.set(2017, 10, 11, 23, 59 ,59);
                    expiredTime = calendar.getTime();
                    if (date.getTime() < expiredTime.getTime()){
                        isUse = 1;
                    }else {
                        isUse = 0;
                    }
                }else if (uses.size() < 8  && uses.size() > 0){
                    //判断时间小于11 31 23 59 59
                    Date expiredTime = null;
                    Date date = new Date();
                    Calendar calendar = Calendar.getInstance();
                    calendar.set(2017, 11, 31, 23, 59 ,59);
                    expiredTime = calendar.getTime();
                    if (date.getTime() < expiredTime.getTime()){
                        isUse = 1;
                    }else {
                        isUse = 0;
                    }
                }
            }else {
                isUse = 0;
            }
        }

        validate(product, NOT_NULL, "product id" + id + " not found");
        validate(product.getIsOn(), v -> true, "product is not on");
        model.addAttribute("isUse", isUse);
        model.addAttribute("product", productComponent.buildDetailVo(product));
        return "product/productDetailNew";
    }

    private Long calculateV4UserId(User user) {
        Long parentId = user.getParentId();
        int whileTimes = 0;
        while (parentId != null) {
            if (whileTimes > 1000) {
                throw new BizException(BizCode.ERROR, "循环引用错误, user id is " + user.getId());
            }
            User parent = userService.findOne(parentId);
            if (parent.getUserRank() == User.UserRank.V4) {
                return parentId;
            }
            parentId = parent.getParentId();
            whileTimes ++;
        }
        return null;
    }


    @RequestMapping(value = "/newDetail/{id}", method = RequestMethod.GET)
    public String newDetail(@PathVariable Long id, Model model) {

        Product product = productService.findOne(id);
        Principal principal = GcUtils.getPrincipal();
        if(principal == null) {
            model.addAttribute("isFirst", true);
        }
        MergeUser mergeUser = mergeUserService.findByUserIdAndProductType(principal.getUserId(),2);
        int minQuantity = 1;
        User.UserRank userRank = null;
        if(principal != null) {
            if (mergeUser == null){
                userRank = User.UserRank.V0;
            }else {
                userRank = mergeUser.getUserRank();
            }
            model.addAttribute("userRank", userRank);
            product.setPrice(productService.getPrice(product.getId(), userRank, 1L));
            if (userRank == User.UserRank.V3 || userRank == User.UserRank.V4 || userRank == User.UserRank.V2) {
                minQuantity = NEW_SETTING_NEW_MIN_QUANTITY;
            }else if (userRank == User.UserRank.V1 || userRank == User.UserRank.V0){
                minQuantity = NEW_UP_SETTING_NEW_MIN_QUANTITY;
            }
        }
        model.addAttribute("minQuantity", minQuantity);
        validate(product, NOT_NULL, "product id" + id + " not found");
        validate(product.getIsOn(), v -> true, "product is not on");
        model.addAttribute("product", productComponent.buildDetailVo(product));
        return "product/productNewDetail";
    }


    /**
     * 下单
     * @return
     */
    @RequestMapping(value = "/create", method = RequestMethod.GET)
    public String create(@RequestParam Long productId,@RequestParam  Long quantity,@RequestParam BigDecimal price, Model model, Principal principal) {
        Product product = productService.findOne(productId);
        Long userId = principal.getUserId();
        User.UserRank userRank = null;
        MergeUser mergeUser = mergeUserService.findByUserIdAndProductType(userId,product.getProductType());
        if(mergeUser != null){
            userRank = mergeUser.getUserRank();
        }else {
            userRank = User.UserRank.V0;
        }
        product.setPrice(productService.getPrice(productId, userRank, quantity));

        Address address = addressService.findDefaultByUserId(userId);
        product.setPrice(price);
        validate(product, NOT_NULL, "product id:" + productId + " is not found !");
        ProductListVo productVo = productComponent.buildListVo(product);
        model.addAttribute("product", productVo);
        model.addAttribute("quantity", quantity);
        model.addAttribute("address", address);
        model.addAttribute("userRank", userRank);
        model.addAttribute("useOfflinePay", quantity <= 160L );

        boolean orderFill = config.isOpenOrderFill();
        if(orderFill) {
            List<OrderFillUser> all = orderFillUserService.findAll(OrderFillUserQueryModel.builder().userIdEQ(userId).build());
            if(all.isEmpty()) {
                orderFill = false;
            } else {
                orderFill = true;
            }
        }
        UserInfo userInfo = userInfoService.findByUserId(userId);
        if (userInfo!=null&&userInfo.getConfirmStatus() == ConfirmStatus.已通过){
            model.addAttribute("realFlage", true);
        }else{
            model.addAttribute("realFlage", false);
        }
        model.addAttribute("orderFill", orderFill);
        return "ucenter/order/orderCreate";
    }
}
