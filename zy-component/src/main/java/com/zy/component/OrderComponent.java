package com.zy.component;

import static com.zy.util.GcUtils.formatDate;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.zy.common.util.BeanUtils;
import com.zy.entity.mal.Order;
import com.zy.entity.mal.OrderItem;
import com.zy.service.OrderItemService;
import com.zy.util.GcUtils;
import com.zy.vo.OrderAdminVo;
import com.zy.vo.OrderDetailVo;
import com.zy.vo.OrderItemVo;
import com.zy.vo.OrderListVo;

@Component
public class OrderComponent {
	
	@Autowired
	private OrderItemService orderItemService;
	
	private static final String TIME_LABEL = "yyyy-MM-dd HH:mm:ss";
	
	public OrderAdminVo buildAdminVo(Order order) {
		OrderAdminVo orderAdminVo = new OrderAdminVo();
		BeanUtils.copyProperties(order, orderAdminVo);
		
		orderAdminVo.setCreatedTimeLabel(formatDate(order.getCreatedTime(), TIME_LABEL));
		orderAdminVo.setExpiredTimeLabel(formatDate(order.getExpiredTime(), TIME_LABEL));
		orderAdminVo.setPaidTimeLabel(formatDate(order.getPaidTime(), TIME_LABEL));
		orderAdminVo.setRefundedTimeLabel(formatDate(order.getRefundedTime(), TIME_LABEL));
		
		OrderItem orderItem = orderItemService.findByOrderId(order.getId()).get(0);
		if (orderItem != null) {
			orderAdminVo.setImageThumbnail(GcUtils.getThumbnail(orderItem.getImage()));
			orderAdminVo.setPrice(orderItem.getPrice());
			orderAdminVo.setQuantity(orderItem.getQuantity());
		}
		return orderAdminVo;
	}
	
	
	public OrderListVo buildListVo(Order order) {
		OrderListVo orderListVo = new OrderListVo();
		BeanUtils.copyProperties(order, orderListVo);
		
		orderListVo.setCreatedTimeLabel(formatDate(order.getCreatedTime(), TIME_LABEL));
		orderListVo.setExpiredTimeLabel(formatDate(order.getExpiredTime(), TIME_LABEL));
		orderListVo.setAmount(order.getAmount());
		
		List<OrderItem> orderItems = orderItemService.findByOrderId(order.getId());
		List<OrderItemVo> orderItemVos = orderItems.stream().map(v ->{
			OrderItemVo orderItemVo = new OrderItemVo();
			BeanUtils.copyProperties(v, orderItemVo);
			
			orderItemVo.setImageThumbnail(GcUtils.getThumbnail(v.getImage()));
			orderItemVo.setPrice(v.getPrice());
			orderItemVo.setAmount(v.getAmount());
			return orderItemVo;
		}).collect(Collectors.toList());
		orderListVo.setOrderItems((ArrayList<OrderItemVo>) orderItemVos);
		
		return orderListVo;
	}
	
	public OrderDetailVo buildDetailVo(Order order) {
		OrderDetailVo orderDetailVo = new OrderDetailVo();
		BeanUtils.copyProperties(order, orderDetailVo);
		
		orderDetailVo.setCreatedTimeLabel(formatDate(order.getCreatedTime(), TIME_LABEL));
		if(order.getExpiredTime() != null){
			orderDetailVo.setExpiredTimeLabel(formatDate(order.getExpiredTime(), TIME_LABEL));
		}
		if(order.getExpiredTime() != null){
			orderDetailVo.setPaidTimeLabel(formatDate(order.getPaidTime(), TIME_LABEL));
		}
		if(order.getExpiredTime() != null){
		orderDetailVo.setRefundedTimeLabel(formatDate(order.getRefundedTime(), TIME_LABEL));
		}
		orderDetailVo.setAmount(order.getAmount());
		orderDetailVo.setRefund(order.getAmount());
		
		List<OrderItem> orderItems = orderItemService.findByOrderId(order.getId());
		List<OrderItemVo> orderItemVos = orderItems.stream().map(v ->{
			OrderItemVo orderItemVo = new OrderItemVo();
			BeanUtils.copyProperties(v, orderItemVo);
			
			orderItemVo.setImageThumbnail(GcUtils.getThumbnail(v.getImage()));
			orderItemVo.setPrice(v.getPrice());
			orderItemVo.setAmount(v.getAmount());
			return orderItemVo;
		}).collect(Collectors.toList());
		orderDetailVo.setOrderItems((ArrayList<OrderItemVo>) orderItemVos);
		
		return orderDetailVo;
	}
}
