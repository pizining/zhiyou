package com.zy.component;

import com.zy.common.util.BeanUtils;
import com.zy.entity.act.ReportVisitedLog;
import com.zy.util.GcUtils;
import com.zy.vo.ReportVisitedLogAdminVo;
import com.zy.vo.ReportVisitedLogListVo;
import org.springframework.stereotype.Component;

@Component
public class ReportVisitedLogComponent {

	public ReportVisitedLogListVo buildListVo(ReportVisitedLog reportVisitedLog) {
		ReportVisitedLogListVo reportVisitedLogListVo = new ReportVisitedLogListVo();
		BeanUtils.copyProperties(reportVisitedLog, reportVisitedLogListVo);

		reportVisitedLogListVo.setVisitedTime1Label(GcUtils.formatDate(reportVisitedLog.getVisitedTime1(), "yyyy-MM-dd HH:mm"));
		reportVisitedLogListVo.setVisitedTime2Label(GcUtils.formatDate(reportVisitedLog.getVisitedTime2(), "yyyy-MM-dd HH:mm"));
		reportVisitedLogListVo.setVisitedTime3Label(GcUtils.formatDate(reportVisitedLog.getVisitedTime3(), "yyyy-MM-dd HH:mm"));
		return reportVisitedLogListVo;
	}

	public ReportVisitedLogAdminVo buildAdminVo(ReportVisitedLog reportVisitedLog) {
		ReportVisitedLogAdminVo reportVisitedLogAdminVo = new ReportVisitedLogAdminVo();
		BeanUtils.copyProperties(reportVisitedLog, reportVisitedLogAdminVo);

		reportVisitedLogAdminVo.setVisitedTime1Label(GcUtils.formatDate(reportVisitedLog.getVisitedTime1(), "yyyy-MM-dd HH:mm"));
		reportVisitedLogAdminVo.setVisitedTime2Label(GcUtils.formatDate(reportVisitedLog.getVisitedTime2(), "yyyy-MM-dd HH:mm"));
		reportVisitedLogAdminVo.setVisitedTime3Label(GcUtils.formatDate(reportVisitedLog.getVisitedTime3(), "yyyy-MM-dd HH:mm"));
		return reportVisitedLogAdminVo;
	}

}