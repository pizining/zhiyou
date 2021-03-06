package com.zy.entity.usr;

import io.gd.generator.annotation.Field;
import io.gd.generator.annotation.Type;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.NotBlank;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "usr_user_log")
@Getter
@Setter
@Type(label = "用户日志")
public class UserLog implements Serializable {

	@Id
	@Field(label = "id")
	private Long id;

	@NotNull
	@Field(label = "用户id")
	private Long userId;

	@NotBlank
	@Field(label = "操作",description = "加VIP,冻结,解冻,回访 等")
	private String operation;

	@NotNull
	@Field(label = "操作者id")
	private Long operatorId;

	@NotNull
	@Field(label = "操作时间")
	private Date operatedTime;

	@Column(length = 1000)
	@Field(label = "备注")
	private String remark;

}
