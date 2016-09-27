package com.zy.service.impl;

import static com.zy.common.util.ValidateUtils.NOT_NULL;
import static com.zy.common.util.ValidateUtils.validate;
import static com.zy.entity.fnc.AccountLog.InOut.支出;
import static com.zy.entity.fnc.AccountLog.InOut.收入;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import com.zy.common.exception.BizException;
import com.zy.common.exception.ConcurrentException;
import com.zy.common.model.query.Page;
import com.zy.component.FncComponent;
import com.zy.entity.fnc.CurrencyType;
import com.zy.entity.fnc.Transfer;
import com.zy.entity.fnc.Transfer.TransferStatus;
import com.zy.mapper.TransferMapper;
import com.zy.model.BizCode;
import com.zy.model.query.TransferQueryModel;
import com.zy.service.TransferService;

@Service
@Validated
public class TransferServiceImpl implements TransferService {

	@Autowired
	private TransferMapper transferMapper;
	
	@Autowired
	private FncComponent fncComponent;
	
	@Override
	public void transfer(@NotNull Long id, String transferRemark) {
		Transfer transfer = transferMapper.findOne(id);
		validate(transfer, NOT_NULL, "transfer id" + id + " not found");
		TransferStatus transferStatus = transfer.getTransferStatus();
		if(transferStatus == TransferStatus.已转账) {
			return ;
		}
		if(transferStatus != TransferStatus.待转账) {
			throw new BizException(BizCode.ERROR, "转账单状态不匹配");
		}
		
		transfer.setTransferStatus(TransferStatus.已转账);
		transfer.setTransferredTime(new Date());
		transfer.setTransferRemark(transferRemark);
		if(transferMapper.update(transfer) == 0) {
			throw new ConcurrentException();
		}
		
		String title = transfer.getTitle();
		CurrencyType currencyType = transfer.getCurrencyType();
		BigDecimal amount = transfer.getAmount();
		Long fromUserId = transfer.getFromUserId();
		Long toUserId = transfer.getToUserId();
		fncComponent.recordAccountLog(fromUserId, title, currencyType, amount, 支出, transfer, toUserId);
		fncComponent.recordAccountLog(toUserId, title, currencyType, amount, 收入, transfer, fromUserId);
	}

	@Override
	public Transfer findOne(@NotNull Long id) {
		return transferMapper.findOne(id);
	}

	@Override
	public Page<Transfer> findPage(@NotNull TransferQueryModel transferQueryModel) {
		if (transferQueryModel.getPageNumber() == null)
			transferQueryModel.setPageNumber(0);
		if (transferQueryModel.getPageSize() == null)
			transferQueryModel.setPageSize(20);
		long total = transferMapper.count(transferQueryModel);
		List<Transfer> data = transferMapper.findAll(transferQueryModel);
		Page<Transfer> page = new Page<>();
		page.setPageNumber(transferQueryModel.getPageNumber());
		page.setPageSize(transferQueryModel.getPageSize());
		page.setData(data);
		page.setTotal(total);
		return page;
	}

	@Override
	public List<Transfer> findAll(@NotNull TransferQueryModel transferQueryModel) {
		return transferMapper.findAll(transferQueryModel);
	}

	@Override
	public long count(@NotNull TransferQueryModel transferQueryModel) {
		return transferMapper.count(transferQueryModel);
	}

	@Override
	public void offlineTransfer(Long id, String transferRemark) {
		Transfer transfer = transferMapper.findOne(id);
		validate(transfer, NOT_NULL, "transfer id" + id + " not found");
		TransferStatus transferStatus = transfer.getTransferStatus();
		if(transferStatus == TransferStatus.已转账) {
			return ;
		}
		if(transferStatus != TransferStatus.待转账) {
			throw new BizException(BizCode.ERROR, "转账单状态不匹配");
		}
		
		transfer.setTransferStatus(TransferStatus.已线下转账);
		transfer.setTransferredTime(new Date());
		transfer.setTransferRemark(transferRemark);
		if(transferMapper.update(transfer) == 0) {
			throw new ConcurrentException();
		}
		
	}

}
