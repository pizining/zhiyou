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

import static com.zy.entity.fnc.Transfer.VO_ADMIN;
import static com.zy.entity.fnc.Transfer.VO_LIST;
import static io.gd.generator.api.query.Predicate.*;

@Entity
@Table(name = "fnc_transfer")
@Getter
@Setter
@QueryModel
@Type(label = "转账单")
@ViewObject(groups = {VO_LIST, VO_ADMIN})
public class Transfer implements Serializable {

	public static final String VO_LIST = "TransferListVo";
	public static final String VO_ADMIN = "TransferAdminVo";

	public enum TransferType {
		历史收益,
		一级平级奖,
		一级越级奖,
		邮费,
		平级推荐奖,  //2.0
		推荐奖,  //2.0  特级推荐奖 -> 推荐奖
		U币转账,
		业绩奖,  //2.0
	}

	public enum TransferStatus {
		待转账, 已转账, 已取消, 已线下转账
	}

	@Id
	@Field(label = "id")
	@View(groups = {VO_LIST, VO_ADMIN})
	private Long id;

	@NotNull
	@Field(label = "转账状态")
	@Query({EQ, IN})
	@View(groups = {VO_LIST, VO_ADMIN})
	@View(name = "transferStatusStyle", type = String.class, groups = {VO_ADMIN})
	private TransferStatus transferStatus;

	@NotNull
	@Query({EQ,IN})
	@Field(label = "转出用户id")
	@View(groups = VO_ADMIN)
	@AssociationView(name = "fromUser", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	@AssociationView(name = "fromUser", groups = VO_LIST, associationGroup = User.VO_LIST)
	private Long fromUserId;

	@NotNull
	@Query({EQ,IN})
	@Field(label = "转入用户id")
	@View(groups = VO_ADMIN)
	@AssociationView(name = "toUser", groups = {VO_ADMIN}, associationGroup = User.VO_ADMIN_SIMPLE)
	@AssociationView(name = "toUser", groups = VO_LIST, associationGroup = User.VO_LIST)
	private Long toUserId;

	@Column(length = 60, unique = true)
	@NotBlank
	@Field(label = "转账单号")
	@Query(EQ)
	@View(groups = {VO_LIST, VO_ADMIN})
	private String sn;

	@NotBlank
	@Field(label = "转账标题")
	@View(groups = {VO_LIST, VO_ADMIN})
	private String title;

	@NotNull
	@Field(label = "币种")
	@View(groups = VO_ADMIN)
	private CurrencyType currencyType;

	@NotNull
	@DecimalMin("0.01")
	@Field(label = "金额")
	@View(groups = VO_ADMIN)
	@View(name = "amountLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	private BigDecimal amount;

	@NotNull
	@Query({GTE,LT})
	@Field(label = "创建时间")
	@View(name = "createdTimeLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	@View(groups = VO_ADMIN)
	private Date createdTime;

	@Query({GTE,LT})
	@Field(label = "转账时间")
	@View(name = "transferredTimeLabel", type = String.class, groups = {VO_LIST, VO_ADMIN})
	@View(groups = VO_ADMIN)
	private Date transferredTime;

	@Query({Predicate.EQ, Predicate.IN})
	@Field(label = "转账类型")
	@View(groups = VO_ADMIN)
	@NotNull
	private TransferType transferType;

	@Field(label = "关联业务id", description = "可以不填写")
	@View(groups = VO_ADMIN)
	@Query(Predicate.EQ)
	private Long refId;

	@Field(label = "转账备注")
	@View(groups = VO_ADMIN)
	private String transferRemark;

	@Field(label = "备注")
	@View(groups = VO_ADMIN)
	private String remark;

	@NotNull
	@Version
	@Field(label = "乐观锁")
	private Integer version;
}
