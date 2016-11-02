package com.zy.mobile.controller;

import com.zy.Config;
import com.zy.component.ProductComponent;
import com.zy.entity.mal.Product;
import com.zy.entity.sys.ConfirmStatus;
import com.zy.entity.usr.User;
import com.zy.entity.usr.User.UserRank;
import com.zy.entity.usr.UserInfo;
import com.zy.model.Principal;
import com.zy.model.query.ProductQueryModel;
import com.zy.service.ProductService;
import com.zy.service.UserInfoService;
import com.zy.service.UserService;
import com.zy.util.GcUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.List;
import java.util.stream.Collectors;

import static com.zy.common.util.ValidateUtils.NOT_NULL;
import static com.zy.common.util.ValidateUtils.validate;

@RequestMapping("/product")
@Controller
public class ProductController {

	@Autowired
	private ProductService productService;

	@Autowired
	private UserService userService;

	@Autowired
	private UserInfoService userInfoService;    
	
	@Autowired
	private ProductComponent productComponent;

	@Autowired
	private Config config;
	
	@RequestMapping
	public String list(Model model) {
		ProductQueryModel productQueryModel = new ProductQueryModel();
		productQueryModel.setIsOnEQ(true);
		List<Product> products = productService.findAll(productQueryModel);
		model.addAttribute("products", products.stream().map(productComponent::buildListVo).collect(Collectors.toList()));
		return "product/productList";
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public String detail(@PathVariable Long id, boolean isAgent, Model model) {
		Product product = productService.findOne(id);
		Principal principal = GcUtils.getPrincipal();
		if(principal == null) {
			model.addAttribute("isFirst", true);
		}
		if(principal != null) {
			User user = userService.findOne(principal.getUserId());
			UserRank userRank = user.getUserRank();
			model.addAttribute("userRank", userRank);
			UserInfo userInfo = userInfoService.findByUserId(principal.getUserId());
			if(userInfo != null && userInfo.getConfirmStatus() == ConfirmStatus.已通过) {
				model.addAttribute("hasUserInfo", true);
			}
			product.setPrice(productService.getPrice(product.getId(), user.getUserRank(), 1L));
			if(user.getUserRank() == UserRank.V0){
				model.addAttribute("isFirst", true);
			} else if((user.getUserRank() != UserRank.V1 || user.getUserRank() != UserRank.V2)&& isAgent){
				model.addAttribute("isUpgrade", true);
			}

			int minQuantity = 1;
			if (userRank == UserRank.V3 || userRank == UserRank.V4) {
				if (config.isOld(id)) {
					minQuantity = 100;
				} else {
					minQuantity = 80;
				}
			}
			model.addAttribute("minQuantity", minQuantity);

		}
		validate(product, NOT_NULL, "product id" + id + " not found");
		validate(product.getIsOn(), v -> true, "product is not on");
		model.addAttribute("product", productComponent.buildDetailVo(product));



		return "product/productDetail";
	}

}
