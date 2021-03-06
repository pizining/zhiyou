package com.zy.entity.mergeusr;

import com.zy.entity.usr.User;
import com.zy.entity.usr.User.UserRank;
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

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;

import static com.zy.entity.mergeusr.MergeUser.VO_ADMIN;
import static io.gd.generator.api.query.Predicate.EQ;
import static io.gd.generator.api.query.Predicate.IN;

@Entity
@Table(name = "usr_merge_user")
@Getter
@Setter
@QueryModel
@Type(label = "用户")
@ViewObject(groups = { VO_ADMIN})
public class MergeUser implements Serializable {

	public static final String VO_ADMIN = "MergeUserAdminVo";

	@Id
	@Query(Predicate.IN)
		@Field(label = "id")
	@View(groups = { VO_ADMIN})
	private Long id;

	@NotNull
	@Query({EQ,IN})
	@Field(label = "用户id")
	@View
	@AssociationView(name = "user", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	private Long userId;

	@Query({EQ,IN})
	@Field(label = "原始上级id")
	@View
	@AssociationView(name = "inviter", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	private Long inviterId;

	@Query({EQ,IN})
	@Field(label = "上级id")
	@View
	@AssociationView(name = "parent", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	private Long parentId;

	@Query(Predicate.EQ)
	@Field(label = "用户等级")
	@View(groups = {VO_ADMIN})
	@View(name = "userRankLabel", type = String.class, groups = {VO_ADMIN})
	private UserRank userRank;

	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "产品类型")
	@View(groups = {VO_ADMIN})
	private Integer productType;

	@Field(label = "上次升级时间")
	private Date lastUpgradedTime;

	@Temporal(TemporalType.TIMESTAMP)
	@Query({Predicate.GTE, Predicate.LT})
	@Field(label = "注册时间")
	@View(groups = {VO_ADMIN})
	private Date registerTime;

	@Query(Predicate.EQ)
	@Field(label = "是否冻结")
	@View(groups = {VO_ADMIN})
	private Boolean isFrozen;

	@Field(label = "是否董事")
	@Query(Predicate.EQ)
	@View(groups = {VO_ADMIN})
	private Boolean isDirector;

	@Field(label = "是否荣誉董事")
	@Query(Predicate.EQ)
	@View(groups = {VO_ADMIN})
	private Boolean isHonorDirector;

	@Query(Predicate.EQ)
	@Field(label = "是否删除")
	@View(groups = {VO_ADMIN})
	private Boolean isDeleted;

	@Query(Predicate.EQ)
	@Field(label = "是否直升特级")
	@View(groups = {VO_ADMIN})
	private Boolean isToV4;

	@Query({EQ,IN})
	@Field(label = "直属v4Id")
	@View
	@AssociationView(name = "v4Parent", groups = VO_ADMIN, associationGroup = User.VO_ADMIN_SIMPLE)
	private Long v4Id;

	@Field(label = "授权码")
	@Column(length = 60)
	private String code;

	@Field(label = "是否股东")
	@Query(Predicate.EQ)
	@View(groups = {VO_ADMIN})
	private Boolean isShareholder;

	@Field(label = "所属大区")
	@Query(Predicate.EQ)
	@View(groups = {VO_ADMIN})
	private Integer largearea;

	@Field(label = "设置大区备注")
	@View(groups = {VO_ADMIN})
	private String setlargearearemark;

	@Query(Predicate.EQ)
	@Field(label = "是否大区总裁")
	@View(groups = {VO_ADMIN})
	private Boolean isPresident;

	@Query(Predicate.EQ)
	@Field(label = "所属大区总裁id")
	@View(groups = {VO_ADMIN})
	private Long presidentId;

	@Query(Predicate.EQ)
	@Field(label = "1：大区董事长  2：大区副董事长")
	@View(groups = {VO_ADMIN})
	private Integer largeareaDirector;

}
