package com.zy.entity.usr;

import io.gd.generator.annotation.Field;
import io.gd.generator.annotation.Type;
import io.gd.generator.annotation.query.Query;
import io.gd.generator.annotation.query.QueryModel;
import io.gd.generator.annotation.view.View;
import io.gd.generator.annotation.view.ViewObject;
import io.gd.generator.api.query.Predicate;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import java.io.Serializable;
import java.util.Date;

import static com.zy.entity.usr.UserUpgrade.VO_ADMIN;

@Entity
@Table(name = "usr_user_upgrade")
@Getter
@Setter
@Type(label = "用户升级")
@ViewObject(groups = VO_ADMIN)
@QueryModel
public class UserUpgrade implements Serializable {

	public static final String VO_ADMIN = "UserUpgradeAdminVo";

	@Id
	@Field(label = "id")
	@View(groups = VO_ADMIN)
	private Long id;

	@NotNull
	@Query(Predicate.EQ)
	@Field(label = "用户")
	@View(groups = VO_ADMIN)
	private Long userId;

	@NotNull
	@Field(label = "升级前等级")
	@View(groups = VO_ADMIN)
	@View(name = "fromUserRankLabel", type = String.class, groups = {VO_ADMIN})
	private User.UserRank fromUserRank;

	@NotNull
	@Field(label = "升级后等级")
	@View(groups = VO_ADMIN)
	@View(name = "toUserRankLabel", type = String.class, groups = {VO_ADMIN})
	private User.UserRank toUserRank;

	@NotNull
	@Field(label = "升级时间")
	@View(groups = VO_ADMIN)
	@View(name = "upgradedTimeLabel", type = String.class)
	@View(name = "upgradedTimeFormatted", type = String.class, groups = VO_ADMIN)
	@Query({Predicate.GTE, Predicate.LT})
	private Date upgradedTime;

}
