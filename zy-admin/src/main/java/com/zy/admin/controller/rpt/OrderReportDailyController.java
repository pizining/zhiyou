package com.zy.admin.controller.rpt;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zy.common.model.query.Page;
import com.zy.common.model.ui.Grid;
import com.zy.component.LocalCacheComponent;
import com.zy.entity.mal.Order;
import com.zy.entity.mal.Order.OrderStatus;
import com.zy.entity.usr.User;
import com.zy.entity.usr.User.UserRank;
import com.zy.model.OrderReportVo;
import com.zy.util.GcUtils;
import com.zy.vo.UserReportVo;

@Controller
@RequestMapping("/report/order/daily")
public class OrderReportDailyController {

	@Autowired
	private LocalCacheComponent localCacheComponent;
	
	@RequiresPermissions("orderReport:view")
	@RequestMapping(method = RequestMethod.GET)
	public String list(Model model, String queryDate) throws ParseException {
		Date date = new Date();
		if(StringUtils.isNotBlank(queryDate)) {
			date = new SimpleDateFormat("yyyy/MM").parse(queryDate);
		}
		model.addAttribute("queryDate", GcUtils.formatDate(date, "yyyy/MM"));
		model.addAttribute("timeLabels", getTimeLabels(date));
		model.addAttribute("queryTimeLabels", getQueryTimeLabels());
		model.addAttribute("userRankMap", Arrays.asList(User.UserRank.values()).stream().collect(Collectors.toMap(v->v, v-> GcUtils.getUserRankLabel(v),(u, v) -> { throw new IllegalStateException(String.format("Duplicate key %s", u)); }, LinkedHashMap::new)) );
		model.addAttribute("rootNames", localCacheComponent.getRootNames());
		return "rpt/orderDailyReport";
	}
	
	@RequiresPermissions("orderReport:view")
	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	public Grid<OrderReportVo> listMonth(OrderReportVo.OrderReportVoQueryModel orderReportVoQueryModel, @RequestParam String queryDate) throws ParseException {
		
		List<UserReportVo> data = new ArrayList<>();
		List<UserReportVo> all = localCacheComponent.getuserReportVos();
		List<UserReportVo> filtered = all.stream()
			.filter(v -> v.getUserRank() == UserRank.V4)
			.filter(userReportVo -> {
			boolean result = true;
			Long provinceIdEQ = orderReportVoQueryModel.getProvinceIdEQ();
			Long cityIdEQ = orderReportVoQueryModel.getCityIdEQ();
			Long districtIdEQ = orderReportVoQueryModel.getDistrictIdEQ();
			String nicknameLK = orderReportVoQueryModel.getNicknameLK();
			String phoneEQ = orderReportVoQueryModel.getPhoneEQ();
			String rootRootNameLK = orderReportVoQueryModel.getRootRootNameLK();
			UserRank userRankEQ = orderReportVoQueryModel.getUserRankEQ();
			String v4UserNicknameLK = orderReportVoQueryModel.getV4UserNicknameLK();
			
			if (provinceIdEQ != null) {
				result = result && provinceIdEQ.equals(userReportVo.getProvinceId());
			}
			if (cityIdEQ != null) {
				result = result && cityIdEQ.equals(userReportVo.getCityId());
			}
			if (districtIdEQ != null) {
				result = result && districtIdEQ.equals(userReportVo.getDistrictId());
			}
			if (nicknameLK != null) {
				result = result && StringUtils.contains(userReportVo.getNickname(), nicknameLK);
			}
			if (phoneEQ != null) {
				result = result && phoneEQ.equals(userReportVo.getPhone());
			}
			if (v4UserNicknameLK != null) {
				result = result && StringUtils.contains(userReportVo.getV4UserNickname(), v4UserNicknameLK);
			}
			if (rootRootNameLK != null) {
				result = result && StringUtils.contains(userReportVo.getRootRootName(), rootRootNameLK);
			}
			if (userRankEQ != null) {
				result = result && userRankEQ.equals(userReportVo.getUserRank());
			}
			return result;
		}).collect(Collectors.toList());
		
		int totalCount = filtered.size();
		Integer pageSize = orderReportVoQueryModel.getPageSize();
		Integer pageNumber = orderReportVoQueryModel.getPageNumber();
		if (pageSize == null) {
			pageSize = 20;
		}
		if (pageNumber == null) {
			pageNumber = 0;
		}
		int from = pageNumber * pageSize;
		if (from < totalCount) {
			int to = (from + pageSize) > totalCount ? totalCount : from + pageSize;
			for (int index = from; index < to; index++) {
				data.add(filtered.get(index));
			}
		}
		Date date = new SimpleDateFormat("yyyy/MM").parse(queryDate);
		List<String> timeLabels = getTimeLabels(date);
		List<Order> allOrders = localCacheComponent.getOrders();
		List<OrderReportVo> result =  data.stream().map( v -> {
			Map<String, Long> map = timeLabels.stream().collect(Collectors.toMap(t -> t, t -> 0L ,(u, e)-> { throw new IllegalStateException(String.format("Duplicate key %s", u)); }, LinkedHashMap::new));
			List<Order> os = allOrders.stream().filter(order -> order.getUserId().equals(v.getId()) & order.getOrderStatus() == OrderStatus.已完成).collect(Collectors.toList());
			for(Order order : os) {
				Date createdTime = order.getCreatedTime();
				String formatDate = GcUtils.formatDate(createdTime, "yy/M/d");
				Long quantity  = map.get(formatDate);
				if(quantity != null) {
					quantity += order.getQuantity();
					map.put(formatDate, quantity);
				}
			}
			OrderReportVo orderReportVo = new OrderReportVo();
			orderReportVo.setNickname(v.getNickname());
			orderReportVo.setRootName(v.getRootName());
			orderReportVo.setPhone(v.getPhone());
			orderReportVo.setV4UserNickname(v.getV4UserNickname());
			
			List<OrderReportVo.OrderReportVoItem> orderReportVoItems = new ArrayList<>();
		    for(Map.Entry<String, Long> entry : map.entrySet()) {   
		    	OrderReportVo.OrderReportVoItem orderReportVoItem = new OrderReportVo.OrderReportVoItem();
		    	orderReportVoItem.setTimeLabel(entry.getKey());
		    	orderReportVoItem.setQuantity(entry.getValue());
		    	orderReportVoItems.add(orderReportVoItem);
		    }
		    orderReportVo.setOrderReportVoItems(orderReportVoItems);
			return orderReportVo;
		}).collect(Collectors.toList());
		
		Page<OrderReportVo> page = new Page<>();
		page.setPageNumber(pageNumber);
		page.setPageSize(pageSize);
		page.setData(result);
		page.setTotal(Long.valueOf(result.size()));
		return new Grid<>(page);
	}
	
	private List<String> getTimeLabels(Date date) {
		Instant instant = date.toInstant();
		ZoneId zone = ZoneId.systemDefault();
		LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, zone);
		LocalDate begin = localDateTime.toLocalDate().with(TemporalAdjusters.firstDayOfMonth());
		LocalDate end = begin.with(TemporalAdjusters.lastDayOfMonth());
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yy/M/d");
		List<String> timeLabels = new ArrayList<>();
		for (LocalDate itDate = begin; itDate.isEqual(end) || itDate.isBefore(end); itDate = itDate.plusDays(1)) {
			timeLabels.add(dateTimeFormatter.format(itDate));
		}
		return timeLabels;
	}
	
	private List<String> getQueryTimeLabels() {
		LocalDate begin = LocalDate.of(2015, 9, 1);
		LocalDate today = LocalDate.now();
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy/MM");
		List<String> timeLabels = new ArrayList<>();
		for (LocalDate itDate = begin; itDate.isEqual(today) || itDate.isBefore(today); itDate = itDate.plusMonths(1)) {
			timeLabels.add(dateTimeFormatter.format(itDate));
		}
		return timeLabels;
	}
}
