package com.zy.entity.mal;

import com.zy.common.extend.StringBinder;
import com.zy.entity.fnc.CurrencyType;
import io.gd.generator.annotation.Field;
import io.gd.generator.annotation.Type;
import io.gd.generator.annotation.query.Query;
import io.gd.generator.annotation.query.QueryModel;
import io.gd.generator.annotation.view.CollectionView;
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
import java.util.ArrayList;
import java.util.Date;

@Entity
@Table(name = "mal_order")
@Getter
@Setter
@QueryModel
@ViewObject(groups = { "OrderListVo", "OrderDetailVo", "OrderAdminVo" },
	collectionViews = {
			@CollectionView(name = "orderItems", type = ArrayList.class, groups = {"OrderAdminVo"}, elementGroup = "OrderItemAdminVo"),
			@CollectionView(name = "orderItems", type = ArrayList.class, groups = {"OrderListVo", "OrderDetailVo"}, elementGroup = "OrderItemVo")
	}
)
@Type(label = "订单")
public class Order implements Serializable {

	@Type(label = "订单状态")
	public enum OrderStatus {
		待支付, 已支付, 已发货, 已完成, 已退款, 已取消
	}

	@Type(label = "物流费支付方式")
	public enum LogisticsFeePayType {
		买家付, 卖家付, 线下支付;
	}

	@Id
	@Field(label = "id")
	@View
	private Long id;

	@NotBlank
	@Column(length = 60, unique = true)
	@Query(Predicate.LK)
	@Field(label = "订单编号")
	@View
	private String sn;

	@NotNull
	@Query({Predicate.EQ, Predicate.IN})
	@Field(label = "用户id")
	@View
	private Long userId;
	
	@NotNull
	@Query({Predicate.EQ, Predicate.IN})
	@Field(label = "卖家id")
	@View
	private Long sellerId;

	@NotBlank
	@Field(label = "标题")
	@View
	private String title;

	@NotNull
	@View(name = "createdTimeLabel", type = String.class)
	@Field(label = "下单时间")
	private Date createdTime;

	@Field(label = "过期时间")
	@View(name = "expiredTimeLabel", type = String.class)
	private Date expiredTime;

	@View(name = "paidTimeLabel", type = String.class, groups = { "OrderDetailVo", "OrderAdminVo" })
	@Field(label = "支付时间")
	private Date paidTime;

	@View(name = "refundedTimeLabel", type = String.class, groups = { "OrderDetailVo", "OrderAdminVo" })
	@Field(label = "退款时间")
	private Date refundedTime;

	@NotNull
	@Field(label = "货币类型")
	@View(groups = "OrderAdminVo")
	private CurrencyType currencyType;

	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "订单状态")
	@View
	private OrderStatus orderStatus;

	@NotNull
	@DecimalMin("0.00")
	@Field(label = "优惠金额")
	@View(groups = "OrderAdminVo")
	private BigDecimal discountFee;

	@NotNull
	@DecimalMin("0.00")
	@View(name = "amountLabel", type = String.class, groups = { "OrderDetailVo", "OrderListVo"})
	@View(groups = { "OrderAdminVo" })
	@Field(label = "应付总金额", description = "应付总金额 = Σ订单子项金额 - 优惠金额")
	private BigDecimal amount;

	@DecimalMin("0.00")
	@View(name = "refundLabel", type = String.class, groups = { "OrderDetailVo"})
	@View(groups = { "OrderAdminVo" })
	@Field(label = "退款金额")
	private BigDecimal refund;

	@View(type = String.class, groups = { "OrderDetailVo"})
	@View(groups = { "OrderAdminVo" })
	@Field(label = "退款备注")
	private String refundRemark;

	@View(groups = { "OrderDetailVo", "OrderAdminVo" })
	@Field(label = "买家留言")
	private String buyerMemo;
	
	@View(groups = { "OrderDetailVo", "OrderAdminVo" })
	@Field(label = "卖家留言")
	private String sellerMemo;
	
	@View(groups = { "OrderDetailVo", "OrderAdminVo" })
	@Field(label = "备注")
	private String remark;

	@NotNull
	@Version
	@Field(label = "乐观锁")
	private Integer version;
	
	@Field(label = "是否已结算")
	@View(groups = {"OrderAdminVo"})
	@NotNull
	private Boolean isSettledUp;

	@Field(label = "是否物流发货")
	@View(name = "useLogisticsLabel", groups = {"OrderAdminVo"})
	@View(groups = {"OrderAdminVo"})
	private Boolean useLogistics;

	@Field(label = "物流费支付类型")
	@View(groups = {"OrderAdminVo"})
	private LogisticsFeePayType logisticsFeePayType;

	@Query(Predicate.LK)
	@Field(label = "物流公司名")
	@StringBinder
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String logisticsName;

	@Query(Predicate.LK)
	@Field(label = "物流单号")
	@StringBinder
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String logisticsSn;

	@DecimalMin("0.00")
	@Field(label = "物流费")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private BigDecimal logisticsFee;

	@NotNull
	@Field(label = "收件人区域")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private Long receiverAreaId;

	@NotBlank
	@StringBinder
	@Field(label = "收件人姓名")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String receiverRealname;

	@NotBlank
	@StringBinder
	@Field(label = "收件人电话")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String receiverPhone;

	@NotBlank
	@Field(label = "收件人省份")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String receiverProvince;

	@NotBlank
	@Field(label = "收件人城市")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String receiverCity;

	@NotBlank
	@Field(label = "收件人地区")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String receiverDistrict;

	@NotBlank
	@StringBinder
	@Field(label = "收件人详细地址")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private String receiverAddress;

	@View(name = "deliveredTimeLabel", type = String.class)
	@Field(label = "发货时间")
	@View(groups = {"OrderDetailVo", "OrderAdminVo"})
	private Date deliveredTime;

}
