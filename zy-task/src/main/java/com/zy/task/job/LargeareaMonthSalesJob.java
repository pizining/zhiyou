package com.zy.task.job;

import com.zy.common.exception.ConcurrentException;
import com.zy.common.util.DateUtil;
import com.zy.entity.mal.Order;
import com.zy.entity.report.LargeareaMonthSales;
import com.zy.entity.sys.SystemCode;
import com.zy.entity.usr.User;
import com.zy.model.query.LargeareaMonthSalesQueryModel;
import com.zy.model.query.OrderQueryModel;
import com.zy.model.query.UserQueryModel;
import com.zy.model.query.UserTargetSalesQueryModel;
import com.zy.service.*;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Created by liang on 2017/9/26.处理大区月销量报表
 */
public class LargeareaMonthSalesJob implements Job {

    private Logger logger = LoggerFactory.getLogger(LargeareaMonthSalesJob.class);

    @Autowired
    private LargeareaMonthSalesService largeareaMonthSalesService;

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private SystemCodeService systemCodeService;

    @Autowired
    private UserTargetSalesService userTargetSalesService;


    /**
     * job 开始
     * @param jobExecutionContext
     * @throws JobExecutionException
     */

    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        logger.info("LargeareaMonthSalesJob begin.......................................................................");
           this.disposeLargeareaMonthSales();
        logger.info("LargeareaMonthSalesJob end.........................................................................");
    }

    private void disposeLargeareaMonthSales(){
        try {
            Date now = new Date();
            List<Order> orders = orderService.findAll(OrderQueryModel.builder().paidTimeGTE(DateUtil.getMonthData(now, -1, 0)).paidTimeLT(now).build());
            //过滤订单
            List<Order> filterOrders = orders.stream().filter(order -> order.getOrderStatus() == Order.OrderStatus.已完成
                    || order.getOrderStatus() == Order.OrderStatus.已支付 || order.getOrderStatus() == Order.OrderStatus.已发货)
                    .filter(order -> order.getSellerId()==1).collect(Collectors.toList());
            Map<Long, List<Order>> orderMap = filterOrders.stream().collect(Collectors.groupingBy(Order::getUserId));

            //过滤大区非空特级
            List<User> v4Users = userService.findAll(UserQueryModel.builder().userRankEQ(User.UserRank.V4).build()).stream().filter(v -> v.getLargearea() != null).collect(Collectors.toList());
            //过滤所有大区总裁
            List<User> allPresidentList = v4Users.stream().filter(u -> u.getIsPresident() != null && u.getIsPresident()).collect(Collectors.toList());
            Map<Integer, List<User>> presidentMap = allPresidentList.stream().collect(Collectors.groupingBy(User::getLargearea));
            List<SystemCode> largeAreaTypes = systemCodeService.findByType("LargeAreaType");
            //处理公司
            Map<String, LargeareaMonthSales> map = largeAreaTypes.stream().collect(Collectors.toMap(v -> v.getSystemValue(), v -> {
                LargeareaMonthSales largeareaMonthSales = new LargeareaMonthSales();
                largeareaMonthSales.setCreateTime(new Date());
                largeareaMonthSales.setMonth(DateUtil.getMothNum(DateUtil.getMonthData(now,-1,0)));
                largeareaMonthSales.setYear(DateUtil.getYear(DateUtil.getMonthData(now,-1,0)));
                largeareaMonthSales.setLargeareaName(v.getSystemName());
                largeareaMonthSales.setLargeareaValue(Integer.parseInt(v.getSystemValue()));
                largeareaMonthSales.setSales(0);
                largeareaMonthSales.setRelativeRate(0.00);
                largeareaMonthSales.setSameRate(0.00);
                largeareaMonthSales.setTargetCount(0);
                largeareaMonthSales.setRegion(0);
                return largeareaMonthSales;
            }));
            //处理逻辑，计算各区销量
            for (User user : v4Users){
                LargeareaMonthSales largeareaMonthSales = map.get(user.getLargearea()+"");
                if(largeareaMonthSales != null){
                    List<Order> orderList = orderMap.get(user.getId());
                    if(orderList != null ){
                        for (Order order: orderList ) {
                            largeareaMonthSales.setSales(largeareaMonthSales.getSales() + order.getQuantity().intValue());
                        }
                    }
                }
            }
            List<LargeareaMonthSales> las = new ArrayList<>(map.values());
            //计算环比、同比
            for (LargeareaMonthSales la : las) {
                List<LargeareaMonthSales> all = largeareaMonthSalesService.findAll(LargeareaMonthSalesQueryModel.builder().largeareaValueEQ(la.getLargeareaValue()).yearEQ(DateUtil.getYear(DateUtil.getMonthData(now, -2, 0))).monthEQ(DateUtil.getMothNum(DateUtil.getMonthData(now, -2, 0))).regionEQ(0).build());
                List<LargeareaMonthSales> all2 = largeareaMonthSalesService.findAll(LargeareaMonthSalesQueryModel.builder().largeareaValueEQ(la.getLargeareaValue()).yearEQ(DateUtil.getYear(DateUtil.getMonthData(now, -12, 0))).monthEQ(DateUtil.getMothNum(DateUtil.getMonthData(now, -12, 0))).regionEQ(0).build());
                //环比
                if( all != null && (all.size() > 0 && all.get(0).getSales() > 0)){
                    la.setRelativeRate(DateUtil.formatDouble((la.getSales() - all.get(0).getSales()) / all.get(0).getSales() * 100));
                }else {
                    if(la.getSales() == 0){
                        la.setRelativeRate(0.00);
                    }else {
                        la.setRelativeRate(100.00);
                    }
                }
                //同比
                if( all2 != null && (all2.size()>0 && all2.get(0).getSales() > 0) ){
                    la.setSameRate(DateUtil.formatDouble((la.getSales() - all2.get(0).getSales()) / all2.get(0).getSales() * 100));
                }else {
                    if(la.getSales() == 0){
                        la.setSameRate(0.00);
                    }else {
                        la.setSameRate(100.00);
                    }
                }
                largeareaMonthSalesService.insert(la);
            }
            //处理大区
            for (Integer key : presidentMap.keySet()) {
                List<User> presidentList = presidentMap.get(key);
                for (User u: presidentList) {
                    List<Order> newOrderList = new ArrayList<>();
                    LargeareaMonthSales largeareaMonthSales = new LargeareaMonthSales();
                    largeareaMonthSales.setCreateTime(new Date());
                    largeareaMonthSales.setMonth(DateUtil.getMothNum(DateUtil.getMonthData(now,-1,0)));
                    largeareaMonthSales.setYear(DateUtil.getYear(DateUtil.getMonthData(now,-1,0)));
                    largeareaMonthSales.setLargeareaName(u.getNickname());
                    largeareaMonthSales.setLargeareaValue(u.getId().intValue());
                    largeareaMonthSales.setSales(0);
                    largeareaMonthSales.setRelativeRate(0.00);
                    largeareaMonthSales.setSameRate(0.00);
                    largeareaMonthSales.setTargetCount(0);
                    largeareaMonthSales.setRegion(u.getLargearea());
                    List<Order> orderList = orderMap.get(u.getId());
                    if(orderList != null ){
                        newOrderList.addAll(orderList);
                    }
                    List<User> team = userService.findAll(UserQueryModel.builder().presidentId(u.getId()).build());
                    if(team != null && !team.isEmpty()){
                        for (User t: team) {
                            List<Order> o = orderMap.get(t.getId());
                            if(o != null && !o.isEmpty()){
                                newOrderList.addAll(o);
                            }
                        }
                    }
                    if(!newOrderList.isEmpty()){
                        Long sum = newOrderList.parallelStream().mapToLong(Order::getQuantity).sum();
                        largeareaMonthSales.setSales(sum.intValue());
                    }
                    List<LargeareaMonthSales> all = largeareaMonthSalesService.findAll(LargeareaMonthSalesQueryModel.builder().largeareaValueEQ(u.getId().intValue()).yearEQ(DateUtil.getYear(DateUtil.getMonthData(now, -2, 0))).monthEQ(DateUtil.getMothNum(DateUtil.getMonthData(now, -2, 0))).regionEQ(key).build());
                    List<LargeareaMonthSales> all2 = largeareaMonthSalesService.findAll(LargeareaMonthSalesQueryModel.builder().largeareaValueEQ(u.getId().intValue()).yearEQ(DateUtil.getYear(DateUtil.getMonthData(now, -12, 0))).monthEQ(DateUtil.getMothNum(DateUtil.getMonthData(now, -12, 0))).regionEQ(key).build());
                    //环比
                    if( all != null && (all.size() > 0 && all.get(0).getSales() > 0)){
                        largeareaMonthSales.setRelativeRate(DateUtil.formatDouble((largeareaMonthSales.getSales() - all.get(0).getSales()) / all.get(0).getSales() * 100));
                    }else {
                        if(largeareaMonthSales.getSales() == 0){
                            largeareaMonthSales.setRelativeRate(0.00);
                        }else {
                            largeareaMonthSales.setRelativeRate(100.00);
                        }
                    }
                    //同比
                    if( all2 != null && (all2.size()>0 && all2.get(0).getSales() > 0) ){
                        largeareaMonthSales.setSameRate(DateUtil.formatDouble((largeareaMonthSales.getSales() - all2.get(0).getSales()) / all2.get(0).getSales() * 100));
                    }else {
                        if(largeareaMonthSales.getSales() == 0){
                            largeareaMonthSales.setSameRate(0.00);
                        }else {
                            largeareaMonthSales.setSameRate(100.00);
                        }
                    }
                    largeareaMonthSalesService.insert(largeareaMonthSales);
                }
            }
            //未设置目标销量的大区总裁，按平均值设置本月目标销量
            userTargetSalesService.avgUserTargetSales(DateUtil.getYear(now),DateUtil.getMothNum(now));
        } catch (ConcurrentException e) {
                try {
                    TimeUnit.SECONDS.sleep(2);} catch (InterruptedException e1) {}
                    this.disposeLargeareaMonthSales();
        }catch (Exception e){
            e.printStackTrace();
            logger.error(e.getMessage(), e);
        }
    }

    private  void checkTargetSales(){
        Date now = new Date();
        UserTargetSalesQueryModel userTargetSalesQueryModel = new UserTargetSalesQueryModel();
        userTargetSalesQueryModel.setYearEQ(DateUtil.getYear(now));
        userTargetSalesQueryModel.setMonthEQ(DateUtil.getMothNum(now));
        long count = userTargetSalesService.count(userTargetSalesQueryModel);
        long avg = userTargetSalesService.totalTargetSales(userTargetSalesQueryModel);
    }
}
