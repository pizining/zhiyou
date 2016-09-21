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

import static com.zy.entity.fnc.Deposit.VO_ADMIN;

@Entity
@Table(name = "fnc_deposit")
@Getter
@Setter
@QueryModel
@Type(label = "充值单")
@ViewObject(groups = VO_ADMIN)
public class Deposit implements Serializable {

	public static final String VO_ADMIN = "DepositAdminVo";

	public enum DepositStatus {
		待充值, 充值成功, 已取消, 待确认
	}

	@Id
	@Field(label = "id")
	@View
	private Long id;

	@NotNull
	@Query({Predicate.EQ, Predicate.IN})
	@Field(label = "用户id")
	@View
	@AssociationView(name = "user", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	private Long userId;

	@NotBlank
	@Field(label = "标题")
	@View
	private String title;

	@Column(length = 60, unique = true)
	@NotBlank
	@Field(label = "充值单号")
	@View
	@Query(Predicate.EQ)
	private String sn;

	@NotNull
	@Field(label = "充值货币1")
	@View
	private CurrencyType currencyType1;

	@NotNull
	@DecimalMin("0.01")
	@Field(label = "充值货币1金额")
	@View
	@View(name = "amount1Label", type = String.class, groups = VO_ADMIN)
	private BigDecimal amount1;

	@Field(label = "充值货币2")
	@View
	private CurrencyType currencyType2;

	@DecimalMin("0.01")
	@Field(label = "充值货币2金额")
	@View
	@View(name = "amount2Label", type = String.class, groups = VO_ADMIN)
	private BigDecimal amount2;

	@NotNull
	@DecimalMin("0.01")
	@Field(label = "充值总金额")
	@View
	@View(name = "totalAmountLabel", type = String.class, groups = VO_ADMIN)
	private BigDecimal totalAmount;

	@NotNull
	@Field(label = "外部单据是否已经创建")
	@View
	private Boolean isOuterCreated;

	@Field(label = "外部sn")
	@View
	private String outerSn;

	@Field(label = "二维码")
	@View
	private String qrCodeUrl;

	@Field(label = "微信openid", description = "微信支付专用")
	@View
	private String weixinOpenId;

	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "支付方式", description = "不能为余额支付")
	@View
	private PayType payType;

	@Query({Predicate.GTE, Predicate.LT})
	@Field(label = "支付成功时间")
	@View
	private Date paidTime;

	@NotNull
	@Field(label = "创建时间")
	@View
	@Query({Predicate.LT, Predicate.GTE})
	private Date createdTime;

	@Field(label = "过期时间")
	@View
	@Query(Predicate.LT)
	@NotNull
	private Date expiredTime;

	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "提现单状态")
	@View
	@View(name = "depositStatusStyle", type = String.class, groups = {VO_ADMIN})
	private DepositStatus depositStatus;

	@View(groups = "DepositAdminVo")
	@Field(label = "备注")
	@Column(length = 1000)
	private String remark;

	@Field(label = "银行汇款截图")
	@View
	@View(name = "offlineImageThumbnail")
	private String offlineImage;
	
	@Field(label = "银行汇款备注")
	@View
	private String offlineMemo;
	
	@NotNull
	@Version
	@Field(label = "乐观锁")
	private Integer version;

	@Field(label = "操作者id")
	private Long operatorId;


}
