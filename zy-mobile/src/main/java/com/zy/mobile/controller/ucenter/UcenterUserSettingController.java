package com.zy.mobile.controller.ucenter;

import com.zy.common.model.result.Result;
import com.zy.common.model.result.ResultBuilder;
import com.zy.entity.usr.UserSetting;
import com.zy.model.Principal;
import com.zy.service.UserSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/u/userSetting")
@Controller
public class UcenterUserSettingController {

	@Autowired
	private UserSettingService userSettingService;

	@RequestMapping
	public String index(Principal principal, Model model) {
		Long userId = principal.getUserId();
		UserSetting userSetting = userSettingService.createIfAbsent(userId);
		model.addAttribute("userSetting", userSetting);
		return "ucenter/userSetting";
	}

	@ResponseBody
	@RequestMapping("/modifyIsReceiveTaskSms")
	public Result<?> modifyIsReceiveTaskSms(Principal principal, Model model, boolean isReceiveTaskSms) {
		Long userId = principal.getUserId();
		userSettingService.modifyIsReceiveTaskSms(userId, isReceiveTaskSms);
		return ResultBuilder.ok("修改成功");
	}

}
