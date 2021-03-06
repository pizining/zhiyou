package com.zy.model.dto;

import com.zy.entity.mal.Order;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Getter
@Setter
public class OrderCreateDto implements Serializable {

	@Length(max = 100)
	private String title;

	@NotNull
	private Long userId;

	@NotNull
	private Long productId;

	@Min(1)
	private long quantity;

	private long sendQuantity;

	@NotNull
	private Long addressId;

	@Length(max = 100)
	private String buyerMemo;

	private Long parentId;
	
	@NotNull
	private Boolean isPayToPlatform;

	private Order.OrderType orderType;

}
