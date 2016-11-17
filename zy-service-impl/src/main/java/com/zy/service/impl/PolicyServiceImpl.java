package com.zy.service.impl;

import static com.zy.common.util.ValidateUtils.NOT_BLANK;
import static com.zy.common.util.ValidateUtils.NOT_NULL;
import static com.zy.common.util.ValidateUtils.validate;

import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import com.zy.common.exception.BizException;
import com.zy.common.model.query.Page;
import com.zy.entity.act.Policy;
import com.zy.entity.act.PolicyCode;
import com.zy.entity.act.Report;
import com.zy.entity.usr.User;
import com.zy.mapper.PolicyCodeMapper;
import com.zy.mapper.PolicyMapper;
import com.zy.mapper.ReportMapper;
import com.zy.mapper.UserMapper;
import com.zy.model.BizCode;
import com.zy.model.query.PolicyQueryModel;
import com.zy.service.PolicyService;

@Service
@Validated
public class PolicyServiceImpl implements PolicyService {

	@Autowired
	private PolicyMapper policyMapper;
	
	@Autowired
	private PolicyCodeMapper policyCodeMapper;
	
	@Autowired
	private ReportMapper ReportMapper;
	
	@Autowired
	private UserMapper userMapper;
	
	@Override
	public Policy create(@NotNull Policy policy) {
		Long reportId = policy.getReportId();
		validate(reportId, NOT_NULL, "policy -> report id is null");
		Report report = ReportMapper.findOne(reportId);
		validate(report, NOT_NULL, "report id" + reportId +  " not found");
		
		Long userId = policy.getUserId();
		validate(userId, NOT_NULL, "policy -> user id is null");
		validate(userId, v -> v.equals(report.getUserId()), "policy user id not equals report user id");
		User user = userMapper.findOne(userId);
		validate(user, NOT_NULL, "policy -> user id " + userId + " not found");
		
		String code = policy.getCode();
		validate(code, NOT_BLANK, "code is null");
		PolicyCode policyCode = policyCodeMapper.findByCode(policy.getCode());
		if(policyCode == null) {
			throw new BizException(BizCode.ERROR, "保险单号[" + policy.getCode() + "]不存在");
		}
		if(policyCode.getIsUsed()) {
			throw new BizException(BizCode.ERROR, "保险单号[" + policy.getCode() + "]已被使用");
		}
		
		long count = policyMapper.count(PolicyQueryModel.builder().reportIdEQ(reportId).build());
		if(count > 0) {
			throw new BizException(BizCode.ERROR, "检测报告已被投保"); 
		}
		
		policy.setGender(report.getGender());
		policy.setPhone(report.getPhone());
		policy.setRealname(report.getRealname());
		policy.setUserId(report.getUserId());
		policy.setReportId(reportId);
		policy.setVersion(0);
		validate(policy);
		if(policyMapper.insert(policy) > 0) {
			policyCode.setIsUsed(true);
			policyCode.setUsedTime(new Date());
			policyCodeMapper.update(policyCode);
		}

		return policy;
	}

	@Override
	public List<Policy> findAll(@NotNull PolicyQueryModel policyQueryModel) {
		return policyMapper.findAll(policyQueryModel);
	}

	@Override
	public Page<Policy> findPage(@NotNull PolicyQueryModel policyQueryModel) {
		if (policyQueryModel.getPageNumber() == null)
			policyQueryModel.setPageNumber(0);
		if (policyQueryModel.getPageSize() == null)
			policyQueryModel.setPageSize(20);
		long total = policyMapper.count(policyQueryModel);
		List<Policy> data = policyMapper.findAll(policyQueryModel);
		Page<Policy> page = new Page<>();
		page.setPageNumber(policyQueryModel.getPageNumber());
		page.setPageSize(policyQueryModel.getPageSize());
		page.setData(data);
		page.setTotal(total);
		return page;
	}

	@Override
	public Policy findOne(@NotNull Long id) {
		return policyMapper.findOne(id);
	}

}
