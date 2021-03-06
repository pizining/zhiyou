package com.zy.model.query;

import java.util.Set;
import java.util.HashSet;
import java.io.Serializable;

import io.gd.generator.api.query.Direction;

import lombok.Getter;
import lombok.Setter;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;
import com.zy.entity.usr.User.UserRank;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MergeUserQueryModel implements Serializable {

	private Long[] idIN;

	private Long userIdEQ;

	private Long[] userIdIN;

	private Long inviterIdEQ;

	private Long[] inviterIdIN;

	private Long parentIdEQ;

	private Long[] parentIdIN;

	private UserRank userRankEQ;

	private Integer productTypeEQ;

	private Date registerTimeGTE;

	private Date registerTimeLT;

	private Boolean isFrozenEQ;

	private Boolean isDirectorEQ;

	private Boolean isHonorDirectorEQ;

	private Boolean isDeletedEQ;

	private Boolean isToV4EQ;

	private Long v4IdEQ;

	private Long[] v4IdIN;

	private Boolean isShareholderEQ;

	private Integer largeareaEQ;

	private Boolean isPresidentEQ;

	private Long presidentIdEQ;

	private Integer largeareaDirectorEQ;

	private Integer pageNumber;

	private Integer pageSize;

	private String orderBy;

	private Direction direction;

	public void setOrderBy(String orderBy) {
		if (orderBy != null && !fieldNames.contains(orderBy)) {
			throw new IllegalArgumentException("order by is invalid");
		}
		this.orderBy = orderBy;
	}

	public Long getOffset() {
		if (pageNumber == null || pageSize == null) {
			return null;
		}
		return ((long) pageNumber) * pageSize;
	}

	public String getOrderByAndDirection() {
		if (orderBy == null) {
			return null;
		}
		String orderByStr = camelToUnderline(orderBy);
		String directionStr = direction == null ? "desc" : direction.toString().toLowerCase();
		return orderByStr + " " + directionStr;
	}

	private String camelToUnderline(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (Character.isUpperCase(c)) {
				sb.append("_");
				sb.append(Character.toLowerCase(c));
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

	private static Set<String> fieldNames = new HashSet<>();

	static {
		fieldNames.add("code");
		fieldNames.add("presidentId");
		fieldNames.add("registerTime");
		fieldNames.add("lastUpgradedTime");
		fieldNames.add("isToV4");
		fieldNames.add("userRank");
		fieldNames.add("isPresident");
		fieldNames.add("userId");
		fieldNames.add("parentId");
		fieldNames.add("v4Id");
		fieldNames.add("largeareaDirector");
		fieldNames.add("isDeleted");
		fieldNames.add("inviterId");
		fieldNames.add("isShareholder");
		fieldNames.add("isDirector");
		fieldNames.add("isHonorDirector");
		fieldNames.add("id");
		fieldNames.add("isFrozen");
		fieldNames.add("productType");
		fieldNames.add("setlargearearemark");
		fieldNames.add("largearea");
	}

}