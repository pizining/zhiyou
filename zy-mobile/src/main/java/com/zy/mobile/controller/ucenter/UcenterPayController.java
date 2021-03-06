package com.zy.mobile.controller.ucenter;

import com.zy.common.exception.BizException;
import com.zy.common.extend.BigDecimalBinder;
import com.zy.common.extend.StringBinder;
import com.zy.common.model.result.ResultBuilder;
import com.zy.common.support.fuiou.FuiouClient;
import com.zy.common.support.fuiou.req.FuiouWeixinPayReq;
import com.zy.common.support.fuiou.res.FuiouWeixinPayRes;
import com.zy.common.support.shengpay.PayCreateMobile;
import com.zy.common.support.shengpay.ShengPayClient;
import com.zy.common.support.shengpay.ShengPayMobileClient;
import com.zy.common.util.Identities;
import com.zy.common.util.JsonUtils;
import com.zy.entity.act.Activity;
import com.zy.entity.act.ActivityApply;
import com.zy.entity.act.ActivityTeamApply;
import com.zy.entity.fnc.*;
import com.zy.entity.fnc.Deposit.DepositStatus;
import com.zy.entity.fnc.Payment.PaymentType;
import com.zy.entity.mal.Order;
import com.zy.entity.mal.Order.OrderStatus;
import com.zy.entity.mal.Product;
import com.zy.entity.usr.User;
import com.zy.model.BizCode;
import com.zy.model.Constants;
import com.zy.model.Principal;
import com.zy.model.query.DepositQueryModel;
import com.zy.model.query.PaymentQueryModel;
import com.zy.service.*;
import com.zy.util.GcUtils;
import io.gd.generator.api.query.Direction;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import static com.zy.common.util.ValidateUtils.*;

@Controller
@RequestMapping("/u/pay")
public class UcenterPayController {

	final Logger logger = LoggerFactory.getLogger(UcenterPayController.class);

	@Autowired
	private DepositService depositService;

	@Autowired
	private OrderService orderService;

	@Autowired
	private PaymentService paymentService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private UserService userService;

	@Autowired
	private ActivityService activityService;

	@Autowired
	private ActivityApplyService activityApplyService;

	@Autowired
	private ShengPayClient shengPayClient;

	@Autowired
	private ShengPayMobileClient shengPayMobileClient;

	@Autowired
	private FuiouClient fuiouClient;

	@Autowired
	private ActivityTeamApplyService activityTeamApplyService;

	public static final String URL_SHENGPAY = "https://api.shengpay.com/html5-gateway/express.htm?page=mobile";

	@RequestMapping
	public String pay(@BigDecimalBinder BigDecimal money, @RequestParam PayType payType, @StringBinder String paymentSn, Model model, Principal principal) {
		if (StringUtils.isBlank(paymentSn)) {
			final BigDecimal zero = new BigDecimal("0.00");
			String title = "U币余额充值";
			Long userId = principal.getUserId();
			validate(money, v -> v.compareTo(zero) > 0, "money must be more than 0.00");
			final BigDecimal amount = money;
			DepositQueryModel depositQueryModel = new DepositQueryModel();
			depositQueryModel.setUserIdEQ(principal.getUserId());
			depositQueryModel.setDepositStatusIN(new DepositStatus[] {DepositStatus.待充值});
			depositQueryModel.setOrderBy("createdTime");
			depositQueryModel.setDirection(Direction.DESC);
			List<Deposit> deposits = depositService.findAll(depositQueryModel);
			Deposit deposit = deposits.stream().filter(v -> v.getPayType() == payType)
					.filter(v -> (v.getDepositStatus() == DepositStatus.待充值))
					.filter(v -> v.getExpiredTime() == null || v.getExpiredTime().after(new Date()))
					.filter(v -> v.getAmount1().equals(amount) && v.getCurrencyType1() == CurrencyType.U币
							&& v.getCurrencyType2() == null)
					.findFirst().orElse(null);

			if (deposit == null) {
				deposit = new Deposit();
				deposit.setPayType(payType);
				deposit.setCurrencyType1(CurrencyType.U币);
				deposit.setTitle(title);
				deposit.setAmount1(money);
				deposit.setUserId(userId);
				deposit.setExpiredTime(DateUtils.addMinutes(new Date(), Constants.SETTING_DEPOSIT_OFFLINE_EXPIRE_IN_MINUTES));
				deposit = depositService.create(deposit);
			}

			if (payType == PayType.银行汇款) {
				model.addAttribute("title", deposit.getTitle());
				model.addAttribute("sn", deposit.getSn());
				model.addAttribute("amount", deposit.getAmount1());
				model.addAttribute("refId", deposit.getId());
				model.addAttribute("offlineImage", deposit.getOfflineImage());
				model.addAttribute("offlineMemo", deposit.getOfflineMemo());
				return "ucenter/account/moneyDepositOffline";
			} else if(payType == PayType.盛付通) {
				String payUrl = shengPayClient.getPayCreateUrl(deposit.getTitle(), deposit.getSn(), deposit.getAmount1(), new Date(), GcUtils.getHost(), Constants.SHENGPAY_RETURN, Constants.SHENGPAY_NOTIFY, Constants.URL_MOBILE);
				return "redirect:" + payUrl;
			} else {
				return null;
			}
		} else if (StringUtils.isNotBlank(paymentSn) && paymentSn.startsWith("ZF")) {
			Payment payment = paymentService.findBySn(paymentSn);
			validate(payment, NOT_NULL, "payment is null!");
			validate(payment, v -> v.getPayType() == PayType.富友支付, "payment payType is not fuiouPay!");
			User user = userService.findOne(payment.getUserId());

			String sn = payment.getSn();
			Date expiredTime = DateUtils.addMinutes(new Date(), Constants.WEIXIN_PAY_EXPIRE_IN_MINUTES);
			int weixinAmount = (payment.getAmount1().multiply(new BigDecimal("100"))).intValue();
			String remark = payment.getRemark();
			if (StringUtils.isBlank(remark)) {
				remark = Identities.uuid2();
			}
			FuiouWeixinPayReq fuiouWeixinPayReq = buildFuiouWeixinPayReq(user.getPhone(), user.getOpenId(), sn, weixinAmount + "", remark);
			FuiouWeixinPayRes fuiouWeixinPayRes = fuiouClient.getWeixinPayInfo(fuiouWeixinPayReq);
			model.addAttribute("fuiouWeixinPayRes", fuiouWeixinPayRes);
			logger.error("fuiouWeixinPayReq:" + JsonUtils.toJson(fuiouWeixinPayReq));
			logger.error("fuiouWeixinPayRes:" + JsonUtils.toJson(fuiouWeixinPayRes));

			payment.setRemark(remark);
			payment.setExpiredTime(expiredTime);
			payment.setOuterSn(fuiouWeixinPayRes.getMchnt_order_no());
			payment.setIsOuterCreated(true);
			paymentService.update(payment);

			model.addAttribute("title", payment.getTitle());
			model.addAttribute("amount", payment.getAmount1());
			return "ucenter/pay/weixinPay";
		} else {
			return null;
		}

	}

	private FuiouWeixinPayReq buildFuiouWeixinPayReq(String userPhone, String userOpenId, String sn, String amount, String remark) {
		FuiouWeixinPayReq fuiouWeixinPayReq = new FuiouWeixinPayReq();
		fuiouWeixinPayReq.setPhone(userPhone);
		fuiouWeixinPayReq.setMchCreateIp(GcUtils.getHost());
		fuiouWeixinPayReq.setNotifyUrl(Constants.FY_WEIXIN_PAY_NOTIFY);
		fuiouWeixinPayReq.setOpenid(userOpenId);
		fuiouWeixinPayReq.setOutOrderNum(sn);
		fuiouWeixinPayReq.setTranAmt(amount);
		fuiouWeixinPayReq.setTerm_id(Constants.FY_TERM_ID);
		fuiouWeixinPayReq.setRemark(remark);
		return fuiouWeixinPayReq;
	}

	@RequestMapping(path = "/deposit", method = RequestMethod.GET)
	public String depositPay(Model model, Principal principal) {
		User user = userService.findOne(principal.getUserId());
		User.UserRank userRank = user.getUserRank();
		boolean useShengPay = false;
		if(userRank == User.UserRank.V3 || userRank == User.UserRank.V4) {
			useShengPay = true;
		}
		model.addAttribute("useShengPay", useShengPay);
		return "ucenter/account/moneyDeposit";
	}

	@RequestMapping(path = "/order/{orderId}", method = RequestMethod.GET)
	public String orderPay(@PathVariable Long orderId, @RequestParam(required = true) PayType payType, Model model,
			Principal principal) {
		validate(payType, NOT_NULL, "order payType" + payType + " is null");
		Order order = orderService.findOne(orderId);
		validate(order, NOT_NULL, "order id" + orderId + " not found");
		if(!order.getUserId().equals(principal.getUserId())){
			throw new BizException(BizCode.ERROR, "非自己的订单不能操作");
		}
		if(order.getOrderStatus() != OrderStatus.待支付){
			return "redirect:/u/order/" + orderId;
		}


		model.addAttribute("title", order.getTitle());
		model.addAttribute("sn", order.getSn());
		model.addAttribute("amount", order.getAmount());
		model.addAttribute("payType", payType);
		model.addAttribute("orderId", orderId);
		Account account = accountService.findByUserIdAndCurrencyType(principal.getUserId(), CurrencyType.U币);
		model.addAttribute("amount1", account.getAmount());
		Account account1 = accountService.findByUserIdAndCurrencyType(principal.getUserId(), CurrencyType.积分);
		model.addAttribute("amount2", account1.getAmount());
		BigDecimal balance = account.getAmount().add(account1.getAmount());
		model.addAttribute("balance", balance);
		return "ucenter/pay/payBalance";

	}

	@RequestMapping(path = "/payment", method = RequestMethod.POST)
	public String paymentPay(Long orderId, boolean useCurrency2, BigDecimal amount2, RedirectAttributes redirectAttributes,
			Principal principal) {
		validate(orderId, NOT_NULL, "order id " + orderId + " is null");
		Order order = orderService.findOne(orderId);
		validate(order, NOT_NULL, "order id" + orderId + " not found");

		//校验库存
		if (order.getBuyerUserRank() != User.UserRank.V4 && order.getQuantity() < 2000){
			if (order.getProductType() == 2){
				Boolean  flag = orderService.checkOrderStore(order.getSellerId(), 2, order.getQuantity());
				if (flag == false){
					throw new BizException(BizCode.ERROR, "卖家库存不足，请提醒卖家进货");
				}
			}
		}
		if(!order.getUserId().equals(principal.getUserId())){
			throw new BizException(BizCode.ERROR, "非自己的订单不能操作");
		}
		if(order.getOrderStatus() != OrderStatus.待支付){
			return "redirect:/u/order/" + orderId;
		}

		if(useCurrency2) {
			if(amount2 == null) {
				redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.error("使用积分余额支付, 积分余额为空"));
				return "redirect:/u/order/" + orderId;
			}
			Account account = accountService.findByUserIdAndCurrencyType(principal.getUserId(), CurrencyType.积分);
			if(account.getAmount().compareTo(amount2) < 0) {
				redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.error( CurrencyType.积分 + "余额为空"));
				return "redirect:/u/order/" + orderId;
			}
		} else {
			amount2 = null;
		}
		Payment payment =createPayment(order, amount2);

		paymentService.balancePay(payment.getId(), true, principal.getUserId());

		redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.ok("积分余额支付成功"));
		return "redirect:/u/order/" + orderId;
	}

	private Payment createPayment(Order order, BigDecimal amount2) {
		PayType payType = PayType.余额;
		BigDecimal orderAmount = order.getAmount();
		BigDecimal amount1 = orderAmount;
		boolean useAllCoin = false;
		if(amount2 != null) {
			if (orderAmount.compareTo(amount2) < 0) {
				useAllCoin = true;
				amount1 = orderAmount;
			} else {
				amount1 =  orderAmount.subtract(amount2);
			}
		}
//		List<Payment> payments = paymentService.findAll(PaymentQueryModel.builder().refIdEQ(order.getId()).paymentTypeEQ(PaymentType.订单支付).build());
//		Payment payment = payments.stream().filter(v -> v.getPayType() == payType)
//				.filter(v -> (v.getPaymentStatus() == PaymentStatus.待支付 || v.getPaymentStatus() == PaymentStatus.待确认))
//				.filter(v -> v.getExpiredTime() == null || v.getExpiredTime().after(new Date()))
//				.filter(v -> v.getAmount1().equals(amount1))
//				.filter(v -> v.getAmount2().equals(amount2))
//				.filter(v -> v.getCurrencyType2() == null)
//				.findFirst().orElse(null);

		Payment payment = new Payment();
		payment.setExpiredTime(DateUtils.addMinutes(new Date(), Constants.SETTING_PAYMENT_EXPIRE_IN_MINUTES));
		payment.setAmount1(amount1);
		if (useAllCoin) {
			payment.setCurrencyType1(CurrencyType.积分);
		} else {
			payment.setCurrencyType1(CurrencyType.U币);
			if(amount2 != null) {
				payment.setCurrencyType2(CurrencyType.积分);
				payment.setAmount2(amount2);
			}
		}
		payment.setPaymentType(PaymentType.订单支付);
		payment.setRefId(order.getId());
		payment.setUserId(order.getUserId());
		payment.setTitle(order.getTitle());
		payment.setPayType(payType);
		payment = paymentService.create(payment);
		return payment;
	}
	
	@RequestMapping(path = "/deposit", method = RequestMethod.POST)
	public String depositPay(Long depositId, String offlineImage, String offlineMemo, RedirectAttributes redirectAttributes,
			Principal principal) {
		validate(depositId, NOT_NULL, "deposit id " + depositId + " is null");
		Deposit deposit = depositService.findOne(depositId);
		validate(deposit, NOT_NULL, "deposit id" + depositId + " not found");
		if(!deposit.getUserId().equals(principal.getUserId())){
			throw new BizException(BizCode.ERROR, "非自己的充值单不能操作");
		}
		if (deposit.getPayType() == PayType.银行汇款) {
			validate(offlineImage, NOT_BLANK, "deposit offlineImage is blank");
			validate(offlineMemo, NOT_BLANK, "deposit offlineMemo is blank");
			deposit.setOfflineImage(offlineImage);
			deposit.setOfflineMemo(offlineMemo);
			depositService.modifyOffline(depositId, offlineImage, offlineMemo);
			redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT,
					ResultBuilder.ok("转账汇款信息提交成功，请等待工作人员确认"));
			return "redirect:/u";
		} else {
			throw new BizException(BizCode.ERROR, "不支持的付款方式");
		}
	}

	@RequestMapping(path = "/activityApply/payment", method = RequestMethod.POST)
	public String paymentPay(@RequestParam Long activityApplyId, PayType payType, Model model, RedirectAttributes redirectAttributes,
	                         Principal principal) {

		validate(payType, NOT_NULL, "pay type is null");

		ActivityApply activityApply = activityApplyService.findOne(activityApplyId);
		validate(activityApply, NOT_NULL, "activity apply id" + activityApplyId + " not found");
		Activity activity = activityService.findOne(activityApply.getActivityId());
		Long activityId = activity.getId();
		if (activityApply.getActivityApplyStatus() == ActivityApply.ActivityApplyStatus.已支付) {
			return "redirect:/activity/" + activity.getId();
		}

		Long userId = principal.getUserId();
		if (payType == PayType.富友支付) {
			return "redirect:/u/pay/activity/weixin?activityApplyId=" + activityApplyId;
		} else if (payType == PayType.余额) {
			try {
				Payment payment = createPayment(activityApply, userId, activity.getTitle(), CurrencyType.积分, PayType.余额);
				paymentService.balancePay(payment.getId(), true, principal.getUserId());
				if (userId.equals(activityApply.getPayerUserId())) {
					redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.ok("代付：积分支付成功"));
					return "redirect:/u/activity/payer";
				}
				redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.ok("积分支付成功"));
				return "redirect:/activity/" + activityId;
			} catch (Exception e) {
				model.addAttribute("title", activity.getTitle());
				model.addAttribute("activityApplyId", activityApply.getId());
				model.addAttribute("amount", activityApply.getAmount());
				model.addAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.error(e.getMessage()));
				return "ucenter/pay/activityPay";
			}
		} else if (payType == PayType.盛付通) {
			model.addAttribute("payCreateMobile", shengPay(activityApply, userId, activity.getTitle()));
			model.addAttribute("payUrl", URL_SHENGPAY);
			return "shengpay/mobilePost";
		} else {
			throw new BizException(BizCode.ERROR, "不存在的情况");
		}

	}

	@RequestMapping(path = "/activity/weixin", method = RequestMethod.GET)
	public String activityWXPay(@RequestParam Long activityApplyId, Principal principal) {
		ActivityApply activityApply = activityApplyService.findOne(activityApplyId);
		validate(activityApply, NOT_NULL, "activity apply id" + activityApplyId + " not found");
		Long activityId = activityApply.getActivityId();
		Activity activity = activityService.findOne(activityId);
		validate(activity, NOT_NULL, "activity id " + activityId + " not found");

		if(activityApply.getActivityApplyStatus() != ActivityApply.ActivityApplyStatus.已报名){
			return "redirect:/activity/" + activityId;
		}

		PayType payType = PayType.富友支付;
		Payment payment = createPayment(activityApply, principal.getUserId(), activity.getTitle(), CurrencyType.人民币, payType);

		return "redirect:/u/pay?paymentSn=" + payment.getSn() + "&payType=" + payType.ordinal();
	}

	private PayCreateMobile shengPay(ActivityApply activityApply, Long userId, String title) {
		Payment payment = createPayment(activityApply, userId, title, CurrencyType.人民币, PayType.盛付通);

		User user = userService.findOne(userId);
		String registerIp = StringUtils.isBlank(user.getRegisterIp())? "127.0.0.1" : user.getRegisterIp();

		PayCreateMobile payCreateMobile = shengPayMobileClient.getPayCreateUrl(new Date(), userId, user.getRegisterTime(), registerIp, "0"
				, user.getNickname(), user.getPhone(), payment.getId(), title
				, payment.getAmount1(), Constants.SHENGPAY_RETURN_MOBILE, Constants.SHENGPAY_NOTIFY_MOBILE, GcUtils.getHost());
		return payCreateMobile;
	}

	private Payment createPayment(ActivityApply activityApply, Long userId, String title, CurrencyType currencyType, PayType payType) {
		List<Payment> payments = paymentService.findAll(PaymentQueryModel.builder().refIdEQ(activityApply.getId()).paymentTypeEQ(PaymentType.活动报名).build());
		Payment payment = payments.stream()
				.filter(v -> (v.getPaymentStatus() == Payment.PaymentStatus.待支付 || v.getPaymentStatus() == Payment.PaymentStatus.待确认))
				.filter(v -> v.getExpiredTime() == null || v.getExpiredTime().after(new Date()))
				.filter(v -> v.getAmount1().equals(activityApply.getAmount()))
				.filter(v -> v.getCurrencyType1() == currencyType)
				.filter(v -> v.getAmount2() == null)
				.filter(v -> v.getCurrencyType2() == null)
				.filter(v -> v.getPayType() == payType)
				.findFirst()
				.orElse(null);

		if (payment == null) {
			payment = new Payment();
			payment.setExpiredTime(DateUtils.addMinutes(new Date(), Constants.SETTING_PAYMENT_EXPIRE_IN_MINUTES));
			payment.setAmount1(activityApply.getAmount());
			payment.setCurrencyType1(currencyType);
			payment.setPaymentType(PaymentType.活动报名);
			payment.setRefId(activityApply.getId());
			payment.setUserId(userId);
			payment.setTitle(title);
			payment.setPayType(payType);
			payment = paymentService.create(payment);
		}
		return payment;
	}

	/**
	 *团对支付
	 * @param activityTeamApplyId
	 * @param payType
	 * @param model
	 * @param redirectAttributes
	 * @param principal
     * @return
     */
	@RequestMapping(path = "/activityTeamApply/payment", method = RequestMethod.POST)
	public String paymentTeamPay(@RequestParam Long activityTeamApplyId, PayType payType, Model model, RedirectAttributes redirectAttributes,
							 Principal principal) {

		validate(payType, NOT_NULL, "pay type is null");

		ActivityTeamApply activityTeamApply = activityTeamApplyService.findOne(activityTeamApplyId);
		validate(activityTeamApply, NOT_NULL, "activity team apply id" + activityTeamApplyId + " not found");
		Long activityId = activityTeamApply.getActivityId();
		Activity activity = activityService.findOne(activityId);
		if (activityTeamApply.getPaidStatus() == ActivityTeamApply.PaidStatus.已支付) {
			return "redirect:/activity/" + activityTeamApply.getActivityId();
		}

		Long userId = principal.getUserId();
		if (payType == PayType.富友支付) {
			return "redirect:/u/pay/activityTeam/weixin?activityTeamApplyId=" + activityTeamApplyId;
		} else if (payType == PayType.余额) {
			try {
				Payment payment = createTeamPayment(activityTeamApply, userId, activity.getTitle(), CurrencyType.积分, PayType.余额);
				paymentService.balancePay(payment.getId(), true, principal.getUserId());
				redirectAttributes.addFlashAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.ok("积分支付成功"));
				return "redirect:/activity/" + activityId;
			} catch (Exception e) {
				model.addAttribute("title", activity.getTitle());
				model.addAttribute("activityTeamApplyId", activityTeamApply.getId());
				model.addAttribute("amount", activityTeamApply.getAmount());
				model.addAttribute(Constants.MODEL_ATTRIBUTE_RESULT, ResultBuilder.error(e.getMessage()));
				return "ucenter/pay/activityTeamPay";
			}
		} else if (payType == PayType.盛付通) {
			model.addAttribute("payCreateMobile", shengTeamPay(activityTeamApply, userId, activity.getTitle()));
			model.addAttribute("payUrl", URL_SHENGPAY);
			return "shengpay/mobilePost";
		} else {
			throw new BizException(BizCode.ERROR, "不存在的情况");
		}

	}

	private Payment createTeamPayment(ActivityTeamApply activityTeamApply, Long userId, String title, CurrencyType currencyType, PayType payType) {
		List<Payment> payments = paymentService.findAll(PaymentQueryModel.builder().refIdEQ(activityTeamApply.getId()).paymentTypeEQ(PaymentType.团队报名).build());
		Payment payment = payments.stream()
				.filter(v -> (v.getPaymentStatus() == Payment.PaymentStatus.待支付 || v.getPaymentStatus() == Payment.PaymentStatus.待确认))
				.filter(v -> v.getExpiredTime() == null || v.getExpiredTime().after(new Date()))
				.filter(v -> v.getAmount1().equals(activityTeamApply.getAmount()))
				.filter(v -> v.getCurrencyType1() == currencyType)
				.filter(v -> v.getAmount2() == null)
				.filter(v -> v.getCurrencyType2() == null)
				.filter(v -> v.getPayType() == payType)
				.findFirst()
				.orElse(null);

		if (payment == null) {
			payment = new Payment();
			payment.setExpiredTime(DateUtils.addMinutes(new Date(), Constants.SETTING_PAYMENT_EXPIRE_IN_MINUTES));
			payment.setAmount1(activityTeamApply.getAmount());
			payment.setCurrencyType1(currencyType);
			payment.setPaymentType(PaymentType.团队报名);
			payment.setRefId(activityTeamApply.getId());
			payment.setUserId(userId);
			payment.setTitle(title);
			payment.setPayType(payType);
			payment = paymentService.create(payment);
		}
		return payment;
	}

	private PayCreateMobile shengTeamPay(ActivityTeamApply activityTeamApply, Long userId, String title) {
		Payment payment = createTeamPayment(activityTeamApply, userId, title, CurrencyType.人民币, PayType.盛付通);

		User user = userService.findOne(userId);
		String registerIp = StringUtils.isBlank(user.getRegisterIp())? "127.0.0.1" : user.getRegisterIp();

		PayCreateMobile payCreateMobile = shengPayMobileClient.getPayCreateUrl(new Date(), userId, user.getRegisterTime(), registerIp, "0"
				, user.getNickname(), user.getPhone(), payment.getId(), title
				, payment.getAmount1(), Constants.SHENGPAY_RETURN_MOBILE, Constants.SHENGPAY_NOTIFY_MOBILE, GcUtils.getHost());
		return payCreateMobile;
	}

	@RequestMapping(path = "/activityTeam/weixin", method = RequestMethod.GET)
	public String activityTeamWXPay(@RequestParam Long activityTeamApplyId, Principal principal) {
		ActivityTeamApply activityTeamApply = activityTeamApplyService.findOne(activityTeamApplyId);
		validate(activityTeamApply, NOT_NULL, "activity team apply id" + activityTeamApplyId + " not found");
		Long activityId = activityTeamApply.getActivityId();
		Activity activity = activityService.findOne(activityId);
		validate(activity, NOT_NULL, "activity id " + activityId + " not found");

		if(activityTeamApply.getPaidStatus() != ActivityTeamApply.PaidStatus.未支付){
			return "redirect:/activity/" + activityId;
		}

		PayType payType = PayType.富友支付;
		Payment payment = createTeamPayment(activityTeamApply, principal.getUserId(), activity.getTitle(), CurrencyType.人民币, payType);

		return "redirect:/u/pay?paymentSn=" + payment.getSn() + "&payType=" + payType.ordinal();
	}

}
