package com.zy.service;

import java.util.List;

import com.zy.common.model.query.Page;
import com.zy.entity.mal.Order;
import com.zy.model.dto.OrderCreateDto;
import com.zy.model.dto.OrderDeliverDto;
import com.zy.model.dto.OrderSumDto;
import com.zy.model.query.OrderQueryModel;

public interface OrderService {

	Order create(OrderCreateDto orderCreateDto);
	
	void cancel(Long id);
	
	Page<Order> findPage(OrderQueryModel orderQueryModel);
	
	Order findOne(Long id);
	
	Order findBySn(String sn);
	
	void confirmPay(Long id); // 确认支付

	void deliver(OrderDeliverDto orderDeliverDto); // 发货

	void platformDeliver(OrderDeliverDto orderDeliverDto); // 平台发货
	
	void receive(Long id); // 确认收货

	void modifyIsPlatformDeliver(Long orderId, boolean isPlatformDeliver); // 设置是否平台发货

	void modifySellerId(Long orderId, Long sellerId); // 设置卖家

	void settleUp(Long orderId); // 在订单完成时结算
	
	void settleUpProfit(Long orderId); // 在订单支付成功后结算

	List<Order> findAll(OrderQueryModel build);
	
	long count(OrderQueryModel build);
	
	OrderSumDto sum(OrderQueryModel orderQueryModel);
	
	void offlinePay(Long orderId, String offlineImage, String offlineMemo);
	
	void delete(Long orderId);
	
	void undelete(Long orderId);
}
