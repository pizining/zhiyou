package com.zy.service.impl;

import com.zy.common.model.query.Page;
import com.zy.entity.report.SalesVolume;
import com.zy.entity.usr.User;
import com.zy.entity.usr.UserInfo;
import com.zy.mapper.OrderMapper;
import com.zy.mapper.SalesVolumeMapper;
import com.zy.model.query.OrderQueryModel;
import com.zy.model.query.SalesVolumeQueryModel;
import com.zy.service.SalesVolumeService;
import com.zy.service.UserInfoService;
import io.gd.generator.api.query.Direction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
@Validated
public class SalesVolumeServiceImpl implements SalesVolumeService {

	@Autowired
	private SalesVolumeMapper salesVolumeMapper;

	@Autowired
	private UserInfoService userInfoService;

	@Autowired
	private OrderMapper orderMapper;

	@Override
	public SalesVolume create(SalesVolume salesVolume) {
		return null;
	}

	@Override
	public void modify(SalesVolume salesVolume) {

	}

	@Override
	public SalesVolume findOne(Long salesVolumeId) {
		return null;
	}

	@Override
	public Page<SalesVolume> findPage(SalesVolumeQueryModel salesVolumeQueryModel) {
		if (salesVolumeQueryModel.getPageNumber() == null)
			salesVolumeQueryModel.setPageNumber(0);
		if (salesVolumeQueryModel.getPageSize() == null)
			salesVolumeQueryModel.setPageSize(20);
		long total = salesVolumeMapper.count(salesVolumeQueryModel);
		List<SalesVolume> data = salesVolumeMapper.findAll(salesVolumeQueryModel);
		Page<SalesVolume> page = new Page<>();
		page.setPageNumber(salesVolumeQueryModel.getPageNumber());
		page.setPageSize(salesVolumeQueryModel.getPageSize());
		page.setData(data);
		page.setTotal(total);
		return page;
	}

	@Override
	public long countNumber(SalesVolumeQueryModel salesVolumeQueryModel) {
		return salesVolumeMapper.countNumber(salesVolumeQueryModel);
	}

	@Override
	public long sumQuantity(SalesVolumeQueryModel salesVolumeQueryModel) {
		return salesVolumeMapper.sumQuantity(salesVolumeQueryModel);
	}

	@Override
	public long sumAmount(SalesVolumeQueryModel salesVolumeQueryModel) {
		return salesVolumeMapper.sumAmount(salesVolumeQueryModel);
	}

	@Override
	public List<SalesVolume> findExReport(SalesVolumeQueryModel salesVolumeQueryModel) {
		return salesVolumeMapper.findAll(salesVolumeQueryModel);
	}

	@Override
	public void salesvolume(List<User> userList) {
		List<Long> amountTargetList = new ArrayList();
		SalesVolume salesVolume = null;

		//上月日期
		Date date = new Date();
		Calendar ca = Calendar.getInstance();// 得到一个Calendar的实例
		ca.setTime(date); // 设置时间为当前时间
		ca.add(Calendar.MONTH, -1);// 月份减1

		//没有设置目标的统计平均值
		SalesVolumeQueryModel sQueryModel = new SalesVolumeQueryModel();
		sQueryModel.setCreateTime(ca.getTime());
		List<SalesVolume> data = salesVolumeMapper.findAll(sQueryModel);
		Long avgNum = 0l;
		if (data != null && data.size() > 0){
			for (SalesVolume sa: data) {
				if (sa.getAmountTarget() != null){
					amountTargetList.add(sa.getAmountTarget());
				}
			}
			long sum = 0 ;
			for(int i = 0 ;i < amountTargetList.size(); i++){
				long number = amountTargetList.get(i);
				sum += number;
			}
			double avg = new BigDecimal((sum / amountTargetList.size())).setScale(0 , RoundingMode.HALF_UP).doubleValue();
			avgNum = (long)avg;
		}

		//没有设置目标量的新插入
		for (User user : userList) {

			//查询上月月进货量
			OrderQueryModel orderQueryModel = new OrderQueryModel();
			orderQueryModel.setUserIdEQ(user.getId());
			orderQueryModel.setPaidTime(ca.getTime());
			Long salesVolumes  = orderMapper.queryRetailPurchases(orderQueryModel);

			SalesVolumeQueryModel s = new SalesVolumeQueryModel();
			s.setUserPhoneLK(user.getPhone());
			s.setCreateTime(ca.getTime());
			salesVolume = salesVolumeMapper.findOneByPhone(s);
			if (salesVolume == null){
				salesVolume = new SalesVolume();
				salesVolume.setUserPhone(user.getPhone());
				salesVolume.setUserRank(user.getUserRank().getLevel());
				if (user.getLargearea() != null){
					salesVolume.setAreaType(user.getLargearea().toString());
				}
				if (user.getIsBoss() != null){
					if (user.getIsBoss() == true){
						salesVolume.setIsBoss(1);
					}else {
						salesVolume.setIsBoss(0);
					}
				}else {
					salesVolume.setIsBoss(0);
				}
				UserInfo userInfo = userInfoService.findByUserIdandFlage(user.getId());
				if (userInfo != null){
					salesVolume.setUserName(userInfo.getRealname());
				}

				salesVolume.setAmountTarget(avgNum);

				salesVolume.setAmountReached(salesVolumes);
				if (salesVolume.getAmountTarget() != null && salesVolume.getAmountTarget() == 0 && salesVolumes > 0){
					salesVolume.setAchievement(100d);
				}
				if (salesVolume.getAmountTarget() != null && salesVolume.getAmountTarget() == 0){
					salesVolume.setAchievement(0.00);
				}
				if (salesVolume.getAmountTarget() != null && salesVolume.getAmountTarget() != 0){
					salesVolume.setAchievement(new BigDecimal((salesVolumes.doubleValue() / salesVolume.getAmountTarget().doubleValue()) * 100).setScale(2 , RoundingMode.HALF_UP).doubleValue());
				}

				salesVolume.setCreateTime(ca.getTime());
				salesVolumeMapper.insert(salesVolume);
			}else {
				salesVolume.setAmountReached(salesVolumes);
				if (salesVolume.getAmountTarget() != null && salesVolume.getAmountTarget() == 0 && salesVolumes > 0){
					salesVolume.setAchievement(100d);
				}
				if (salesVolume.getAmountTarget() != null && salesVolume.getAmountTarget() == 0l){
					salesVolume.setAchievement(0.00);
				}
				if (salesVolume.getAmountTarget() != null && salesVolume.getAmountTarget() != 0){
					salesVolume.setAchievement(new BigDecimal((salesVolumes.doubleValue() / salesVolume.getAmountTarget().doubleValue()) * 100).setScale(2 , RoundingMode.HALF_UP).doubleValue());
				}
				salesVolumeMapper.update(salesVolume);
			}
		}

		//重新查询排序进行排名和排序升降
		SalesVolumeQueryModel salesVolumeQueryModel = new SalesVolumeQueryModel();
		salesVolumeQueryModel.setOrderBy("amountReached");
		salesVolumeQueryModel.setDirection(Direction.DESC);
		salesVolumeQueryModel.setCreateTime(ca.getTime());
		List<SalesVolume> list = salesVolumeMapper.findAll(salesVolumeQueryModel);
		if (list != null && list.size() > 0){
			int i = 0 ;
			for (SalesVolume sa: list) {
				i = i + 1;
				sa.setRanking(i);
				Calendar da = Calendar.getInstance();// 得到一个Calendar的实例
				da.setTime(date); // 设置时间为当前时间
				da.add(Calendar.MONTH, -2);// 月份减2
				SalesVolumeQueryModel sQueryM = new SalesVolumeQueryModel();
				sQueryM.setUserPhoneLK(sa.getUserPhone());
				sQueryM.setCreateTime(da.getTime());
				List<SalesVolume> saList = salesVolumeMapper.findAll(sQueryM);
				if (saList != null && saList.size() > 0){
					SalesVolume s = saList.get(0);
					if (sa.getRanking() > s.getRanking()){
						sa.setType(1);
						sa.setNumber(sa.getRanking() - s.getRanking());
					}else if (sa.getRanking() == s.getRanking()){
						sa.setType(2);
						sa.setNumber(0);
					}else if (sa.getRanking() < s.getRanking()){
						sa.setType(3);
						sa.setNumber(s.getRanking() - sa.getRanking());
					}
				}else {
					sa.setType(1);
					sa.setNumber(sa.getRanking());
				}
				salesVolumeMapper.update(sa);
			}
		}

	}

}
