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

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MergeV3ToV4QueryModel implements Serializable {

	private Long[] idIN;

	private String nameLK;

	private Long UserIdEQ;

	private Integer flageEQ;

	private Long create_byEQ;

	private Date create_dateGTE;

	private Date create_dateLT;

	private Long update_byEQ;

	private Date update_dateGTE;

	private Date update_dateLT;

	private Integer delFlageEQ;

	private String remarkLK;

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
		fieldNames.add("create_by");
		fieldNames.add("UserId");
		fieldNames.add("flage");
		fieldNames.add("name");
		fieldNames.add("remark");
		fieldNames.add("id");
		fieldNames.add("create_date");
		fieldNames.add("update_by");
		fieldNames.add("image1");
		fieldNames.add("image2");
		fieldNames.add("delFlage");
		fieldNames.add("update_date");
	}

}