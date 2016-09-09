package com.zy.vo;

import io.gd.generator.annotation.Field;
import com.zy.entity.fnc.CurrencyType;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Getter
@Setter
public class ProfitAdminVo implements Serializable {
	/* 原生 */
	@Field(label = "id")
	private Long id;
	@Field(label = "用户id")
	private Long userId;
	@Field(label = "收益单号")
	private String sn;
	@Field(label = "收益标题")
	private String title;
	@Field(label = "币种")
	private CurrencyType currencyType;
	@Field(label = "金额")
	private BigDecimal amount;
	@Field(label = "创建时间")
	private Date createdTime;
	@Field(label = "业务名")
	private String bizName;
	@Field(label = "业务sn")
	private String bizSn;
	@Field(label = "备注")
	private String remark;

	/* 扩展 */
	@Field(label = "用户id")
	private UserAdminSimpleVo user;

}