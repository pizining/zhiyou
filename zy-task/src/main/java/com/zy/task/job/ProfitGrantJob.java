package com.zy.task.job;

import com.zy.common.exception.ConcurrentException;
import com.zy.service.ProfitService;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

;

/**
 * Created by freeman on 16/9/13.
 */
@Deprecated
public class ProfitGrantJob implements Job {

	private Logger logger = LoggerFactory.getLogger(ProfitGrantJob.class);

	@Autowired
	private ProfitService profitService;

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		logger.info("begin...{}", LocalDateTime.now());
//		profitService.findAll(builder().profitStatusEQ(待发放).build())
//				.stream()
//				.map(profit -> profit.getId())
//				.forEach(this::gant);
		logger.info("end...{}", LocalDateTime.now());

	}

	private void gant(Long profitId) {
		try {
			this.profitService.grant(profitId, profitId);
			logger.info("profitId  {} success", profitId);
		} catch (ConcurrentException e) {
			try {TimeUnit.SECONDS.sleep(2);} catch (InterruptedException e1) {}
			gant(profitId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
}
