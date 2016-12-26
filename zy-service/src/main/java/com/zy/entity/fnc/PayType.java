package com.zy.entity.fnc;

import io.gd.generator.annotation.Type;

@Type(label = "支付类型")
public enum PayType {
	余额,
	银行汇款,
	支付宝,
	微信,
	支付宝手机,
	微信公众号,
	盛付通
}