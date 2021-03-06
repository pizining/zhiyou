package com.zy.service;

import com.zy.common.model.query.Page;
import com.zy.entity.act.ActivityApply;
import com.zy.entity.act.ActivityTicket;
import com.zy.model.query.ActivityApplyQueryModel;
import com.zy.model.query.ActivityReportQueryModel;

import java.util.List;
import java.util.Map;

public interface ActivityApplyService {

	Page<ActivityApply> findPage(ActivityApplyQueryModel activityApplyQueryModel);

	List<ActivityApply> findAll(ActivityApplyQueryModel activityApplyQueryModel);
	
	ActivityApply findByActivityIdAndUserId(Long activityId, Long userId);

	ActivityApply findOne(Long id);

	void createAndPaid(Long activityId, Long userId);

	void useTicket(Long activityId, Long userId, Long inviterId,ActivityTicket activityTicket);

	void success(Long id, String outerSn);

	void modifyPayerUserId(Long activityApplyId, Long payerUserId);

	int update(ActivityApply activityApply);

	void editApplyAndTicket(ActivityApply activityApply , ActivityTicket activityTicket);

	Long queryCount(Long activityId);

	Long queryNoPayCount(Long id);

	Map<String,Object> findPageByReport(ActivityReportQueryModel activityReportQueryModel);

	Long queryAppliedCount(Long id);
}
