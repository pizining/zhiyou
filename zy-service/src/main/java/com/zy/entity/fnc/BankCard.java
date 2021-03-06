package com.zy.entity.fnc;

import com.zy.common.extend.StringBinder;
import com.zy.entity.sys.ConfirmStatus;
import com.zy.entity.usr.User;
import io.gd.generator.annotation.Field;
import io.gd.generator.annotation.Type;
import io.gd.generator.annotation.query.Query;
import io.gd.generator.annotation.query.QueryModel;
import io.gd.generator.annotation.view.AssociationView;
import io.gd.generator.annotation.view.View;
import io.gd.generator.annotation.view.ViewObject;
import io.gd.generator.api.query.Predicate;
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

import static com.zy.entity.fnc.BankCard.VO;
import static com.zy.entity.fnc.BankCard.VO_ADMIN;

@Entity
@Table(name = "fnc_bank_card")
@Getter
@Setter
@QueryModel
@Type(label = "银行卡信息")
// 工商银行，建设银行，农业银行，招商银行，交通银行, 平安银行，广发银行，光大银行，民生银行，中信银行，浦东发展银行，北京银行
//	交通银行，建设银行，招商银行
//	光大银行，民生银行
@ViewObject(groups = {VO, VO_ADMIN})
public class BankCard implements Serializable {

	public static final String VO = "BankCardVo";
	public static final String VO_ADMIN = "BankCardAdminVo";

	@Id
	@Field(label = "id")
	@View
	private Long id;

	@NotNull
	@Column(unique = true)
	@Query(Predicate.EQ)
	@Field(label = "用户id")
	@View
	@AssociationView(name = "user", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	private Long userId;

	@NotBlank
	@StringBinder
	@Query(Predicate.LK)
	@Field(label = "开户名")
	@View
	private String realname;

	@NotBlank
	@StringBinder
	@Field(label = "银行卡号")
	@View
	@View(name = "cardNumberLabel", groups = VO, field = @Field(label = "银行卡号密文"))
	private String cardNumber;

	@NotNull
	@StringBinder
	@Field(label = "开户行id")
	@View
	@View(name = "bankCode", type=String.class, field = @Field(label = "开户行code"))
	private Long bankId;

	//@NotNull
	@Field(label = "是否企业银行", description = "新增字段")
	@View
	private Boolean isEnterprise;

	//@NotBlank
	@View
	@Field(label = "省", description = "新增字段")
	private String province;

	//@NotBlank
	@View
	@Field(label = "市", description = "新增字段")
	private String city;

	@NotBlank
	@StringBinder
	@Field(label = "开户行名")
	@View
	private String bankName;

	@NotBlank
	@StringBinder
	@Field(label = "开户支行")
	@View
	private String bankBranchName;

	@NotNull
	@Field(label = "是否默认银行卡")
	@View
	private Boolean isDefault;
	
	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "是否删除")
	private Boolean isDeleted;
	
	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "审核状态")
	@View(groups = "BankCardAdminVo")
	private ConfirmStatus confirmStatus;

	@Field(label = "审核备注")
	@View(groups = "BankCardAdminVo")
	private String confirmRemark;

	@Field(label = "审核通过时间")
	@View(groups = "BankCardAdminVo")
	private Date confirmedTime;

	@NotNull
	@Field(label = "申请时间")
	@View(groups = "BankCardAdminVo")
	private Date appliedTime;

	@Query({Predicate.GTE, Predicate.LT})
	private Long confirmId;

}
