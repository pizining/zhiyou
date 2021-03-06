package com.zy.entity.fnc;

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

import javax.persistence.*;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "fnc_withdraw")
@Getter
@Setter
@QueryModel
@Type(label = "提现")
@ViewObject(groups = {Withdraw.VO_ADMIN, Withdraw.VO_LIST})
public class Withdraw implements Serializable {

	public static final String VO_ADMIN = "WithdrawAdminVo";
	public static final String VO_LIST = "WithdrawListVo";

	public enum WithdrawStatus {
		已申请, 提现成功, 已取消,

		已推送, 处理失败 // 新增
	}

	@Id
	@Field(label = "id")
	@View
	private Long id;

	@NotNull
	@Field(label = "用户id")
	@AssociationView(name = "user", associationGroup = User.VO_ADMIN_SIMPLE, groups = {VO_ADMIN})
	@Query({Predicate.EQ, Predicate.IN})
	private Long userId;

	@NotNull
	@Field(label = "货币类型")
	@View
	private CurrencyType currencyType;

	@NotBlank
	@Field(label = "标题")
	@View
	private String title;

	@Column(length = 60, unique = true)
	@NotBlank
	@Field(label = "提现单号")
	@View
	private String sn;

	@NotNull
	@DecimalMin("0.01")
	@Field(label = "提现金额")
	@View
	@View(name = "amountLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	private BigDecimal amount;

	@NotNull
	@Field(label = "提现手续费率")
	@View
	private BigDecimal feeRate;

	@NotNull
	@Field(label = "提现手续费")
	@View
	@View(name = "feeLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	private BigDecimal fee;

	@NotNull
	@Field(label = "实际到账总金额", description = "实际到账总金额 = 提现金额 - 提现手续费")
	@View
	@View(name = "realAmountLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	private BigDecimal realAmount;

	@DecimalMin("0.00")
	@Field(label = " 外部手续费", description = "银行打款手续费 需要另外记")
	@View
	private BigDecimal outerFee;

	@NotNull
	@Field(label = "创建时间")
	@View
	@View(name = "createdTimeLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	@Query({Predicate.LT, Predicate.GTE})
	private Date createdTime;

	@Field(label = "提现成功时间")
	@View
	@View(name = "withdrawedTimeLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	private Date withdrawedTime;

	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "提现单状态")
	@View
	@View(name = "withdrawStatusStyle", type = String.class, groups = {VO_ADMIN})
	private WithdrawStatus withdrawStatus;

	@Field(label = "操作者id")
	private Long operatorId;

	@NotNull
	@Field(label = "是否提现到银行卡")
	@View(groups = VO_ADMIN)
	private Boolean isToBankCard;

	@Field(label = "银行卡id", description = "如果提现到银行卡必填")
	@View(groups = VO_ADMIN)
	@AssociationView(name = "bankCard", groups = VO_ADMIN, associationGroup = "BankCardAdminVo")
	private Long bankCardId;

	@Field(label = "微信openId", description = "如果提现到微信必填")
	@View(groups = VO_ADMIN)
	private String openId;

	@Column(length = 2000)
	@Field(label = "备注")
	@View(groups = VO_ADMIN)
	private String remark;

	@NotNull
	@Version
	@Field(label = "乐观锁")
	private Integer version;

}
