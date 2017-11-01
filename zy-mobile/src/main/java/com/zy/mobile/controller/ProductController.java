package com.zy.mobile.controller;

import com.zy.Config;
import com.zy.common.exception.BizException;
import com.zy.common.model.query.Page;
import com.zy.component.ProductComponent;
import com.zy.entity.mal.Product;
import com.zy.entity.usr.User;
import com.zy.entity.usr.User.UserRank;
import com.zy.model.BizCode;
import com.zy.model.Principal;
import com.zy.model.query.ProductQueryModel;
import com.zy.model.query.UserQueryModel;
import com.zy.service.ProductService;
import com.zy.service.UserService;
import com.zy.util.GcUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static com.zy.common.util.ValidateUtils.NOT_NULL;
import static com.zy.common.util.ValidateUtils.validate;
import static com.zy.model.Constants.SETTING_NEW_MIN_QUANTITY;
import static com.zy.model.Constants.SETTING_OLD_MIN_QUANTITY;

@RequestMapping("/product")
@Controller
public class ProductController {

	@Autowired
	private ProductService productService;

	@Autowired
	private UserService userService;

	@Autowired
	private ProductComponent productComponent;

	@Autowired
	private Config config;
	
	@RequestMapping
	public String list(Model model, String orderFill, Principal principal) {
		int isUse = 0;
		Long userId = principal.getUserId();
		User user = userService.findOne(userId);
		User.UserRank userRank = user.getUserRank();
		Long parentId = user.getParentId();
		//判断团队人数
		if (userRank == User.UserRank.V3){
			int whileTimes = 0;
			while (parentId != null) {
				if (whileTimes > 1000) {
					throw new BizException(BizCode.ERROR, "循环引用错误, user id is " + user.getId());
				}
				User parent = userService.findOne(parentId);
				if (parent.getUserRank() == UserRank.V4) {
					parentId = user.getParentId();
				}
				parentId = parent.getParentId();
				whileTimes ++;
			}

			//根据id查询团队省级人数
			UserQueryModel userQueryModel = new UserQueryModel();
			userQueryModel.setParentIdEQ(parentId);
			Page<User> page= userService.findPage(userQueryModel);

			List<User> list = page.getData().stream().filter(v -> v.getUserRank() == User.UserRank.V3).collect(Collectors.toList());
			if (list.size() > 8 ){
				//判断时间小于11 11 23 59 59
				Date expiredTime = null;
				Date date = new Date();
				Calendar calendar = Calendar.getInstance();
				calendar.set(2017, 11, 11, 23, 59 ,59);
				expiredTime = calendar.getTime();
				if (date.getTime() < expiredTime.getTime()){
					isUse = 1;
				}else {
					isUse = 0;
				}
			}else if (list.size() <= 8  && list.size() > 0){
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
		}

		ProductQueryModel productQueryModel = new ProductQueryModel();
		productQueryModel.setIsOnEQ(true);
		List<Product> products = productService.findAll(productQueryModel);
		model.addAttribute("products", products.stream().map(productComponent::buildListVo).collect(Collectors.toList()));
		model.addAttribute("orderFill", orderFill);
		model.addAttribute("userRank", userRank);
		model.addAttribute("isUse", isUse);
		return "product/productList";
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public String detail(@PathVariable Long id, boolean isAgent, String orderFill, Model model) {
		Product product = productService.findOne(id);
		Principal principal = GcUtils.getPrincipal();
		if(principal == null) {
			model.addAttribute("isFirst", true);
		}
		int minQuantity = 1;
		if(principal != null) {
			User user = userService.findOne(principal.getUserId());
			UserRank userRank = user.getUserRank();
			model.addAttribute("userRank", userRank);
			product.setPrice(productService.getPrice(product.getId(), user.getUserRank(), 1L));
			/*
			if(user.getUserRank() == UserRank.V0){
				model.addAttribute("isFirst", true);
			} else if((user.getUserRank() != UserRank.V1 || user.getUserRank() != UserRank.V2) && isAgent){
				model.addAttribute("isUpgrade", true);
			}
			*/
			if (userRank == UserRank.V3 || userRank == UserRank.V4) {
				if (config.isOld(id)) {
					minQuantity = SETTING_OLD_MIN_QUANTITY;
				} else {
					minQuantity = SETTING_NEW_MIN_QUANTITY;
				}
			}

		}
		model.addAttribute("minQuantity", minQuantity);
		validate(product, NOT_NULL, "product id" + id + " not found");
		validate(product.getIsOn(), v -> true, "product is not on");
		model.addAttribute("product", productComponent.buildDetailVo(product));
		model.addAttribute("orderFill", orderFill);
		return "product/productDetail";
	}

}
