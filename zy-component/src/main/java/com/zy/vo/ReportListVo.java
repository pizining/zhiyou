package com.zy.vo;

import java.io.Serializable;

import com.zy.entity.act.Report.ReportResult;
import com.zy.entity.sys.ConfirmStatus;
import com.zy.entity.usr.Portrait.Gender;

import io.gd.generator.annotation.Field;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReportListVo implements Serializable {
	/* 原生 */
	@Field(label = "id")
	private Long id;
	@Field(label = "用户id")
	private Long userId;
	@Field(label = "姓名")
	private String realname;
	@Field(label = "年龄")
	private Integer age;
	@Field(label = "性别")
	private Gender gender;
	@Field(label = "手机号")
	private String phone;
	@Field(label = "检测结果")
	private ReportResult reportResult;

	/* 扩展 */
	@Field(label = "职业")
	private String jobName;
	@Field(label = "所在地")
	private String province;
	@Field(label = "所在地")
	private String city;
	@Field(label = "所在地")
	private String district;
	@Field(label = "创建时间")
	private String createdTimeLabel;
	@Field(label = "审核状态")
	private ConfirmStatus confirmStatus;

}