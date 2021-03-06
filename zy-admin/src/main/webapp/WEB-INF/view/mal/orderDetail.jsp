<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
<!-- BEGIN JAVASCRIPTS -->
<style>
  .imageview {
    cursor: pointer;
    width: 80px;
    height: 80px;
  }
</style>
<script>
  $(function () {

    $('.imageview').click(function () {
      var url = $(this).attr('data-url');
      $.imageview({
        url: url,
        title: '支付凭证图片'
      });
    });

  });
</script>
<!-- END JAVASCRIPTS -->

<!-- BEGIN PAGE HEADER-->
<c:if test="${not isPure}">
<div class="page-bar">
  <ul class="page-breadcrumb">
    <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
    <li><a href="javascript:;" data-href="${ctx}/order">订单管理</a></li>
  </ul>
</div>
</c:if>
<!-- END PAGE HEADER-->

<div class="row">
  <div class="col-md-12">
    <div class="portlet light bordered">
      <div class="portlet-title">
        <div class="caption">
          <i class="icon-docs"></i> 查看订单
        </div>
        <c:if test="${not isPure}">
        <div class="actions">
          <a class="btn btn-circle default" data-href="${ctx}/order">
            <i class="fa fa-chevron-left"></i> 返回
          </a>
        </div>
        </c:if>
      </div>

      <div class="portlet-body form">
        <form class="form-horizontal">
          <div class="form-body">

            <h4 class="form-section">基本信息:</h4>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">订单号:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.sn}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">标题:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.title}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">订单状态:</label>
                  <div class="col-md-9">
                    <p class="form-control-static"><label class="label label-${order.orderStatusStyle}">${order.orderStatus}</label></p>
                  </div>
                </div>
              </div>

            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">单价:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.price}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">数量:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.quantity}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">应付总金额:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.amount}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">下单时间:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.createdTimeLabel}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">过期时间:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.expiredTimeLabel}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">买家留言:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.buyerMemo}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">是否平台收款:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.isPayToPlatform ? '是' : '否'}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">货款已结算:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.isSettledUp ? '是' : '否'}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">奖励已结算:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.isProfitSettledUp ? '是' : '否'}</p>
                  </div>
                </div>
              </div>
            </div>
            <c:if test="${order.isCopied}">
              <div class="row">
                <div class="col-md-4">
                  <div class="form-group">
                    <label class="control-label col-md-3">是否转订单:</label>
                    <div class="col-md-9">
                      <p class="form-control-static">${order.isCopied ? '是' : '否'}</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-4">
                  <div class="form-group">
                    <label class="control-label col-md-3">转订单ID:</label>
                    <div class="col-md-9">
                      <p class="form-control-static">${order.refId}</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-4">
                  <div class="form-group">
                    <label class="control-label col-md-3">转订单时间:</label>
                    <div class="col-md-9">
                      <p class="form-control-static">${order.copiedTimeLabel}</p>
                    </div>
                  </div>
                </div>
            </c:if>

            <h4 class="form-section">买家卖家:</h4>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">买家昵称:</label>
                  <div class="col-md-9">
                    <p class="form-control-static"><img src="${order.user.avatarThumbnail}" width="30" height="30"
                                                        style="border-radius:40px !important;margin-right:5px"/>${order.user.nickname}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">买家手机:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.user.phone}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">买家等级:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.buyerUserRankLabel}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">卖家昵称:</label>
                  <div class="col-md-9">
                    <p class="form-control-static"><img src="${order.seller.avatarThumbnail}" width="30" height="30"
                                                        style="border-radius:40px !important;margin-right:5px"/>${order.seller.nickname}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">卖家手机:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.seller.phone}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">卖家等级:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.sellerUserRankLabel}</p>
                  </div>
                </div>
              </div>
            </div>

            <h4 class="form-section">发货信息:</h4>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">收件人姓名:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.receiverRealname}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">收件人电话:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.receiverPhone}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">收件人省市区:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.receiverProvince} ${order.receiverCity} ${order.receiverDistrict}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">收件人地址:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.receiverAddress}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">是否平台发货:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.isPlatformDeliver ? '是': '否'}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">发货方式:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.isUseLogisticsLabel}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">发货时间:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.deliveredTimeLabel}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">物流公司名:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.logisticsName}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">物流单号:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.logisticsSn}</p>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">物流费用:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.logisticsFee}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label class="control-label col-md-3">买家付物流费:</label>
                  <div class="col-md-9">
                    <p class="form-control-static">${order.isBuyerPayLogisticsFee ? '是' : '否'}</p>
                  </div>
                </div>
              </div>
            </div>

          </div>

        </form>

        <ul class="nav nav-tabs">
          <li class="active"><a href="#applies" data-toggle="tab" aria-expanded="false"> 支付单 <span class="badge badge-primary"> ${order.payments.size()} </span></a></li>
          <li class=""><a href="#signIns" data-toggle="tab" aria-expanded="false"> 收益单 <span class="badge badge-primary"> ${order.profits.size()} </span></a></li>
          <li class=""><a href="#collects" data-toggle="tab" aria-expanded="false"> 转账单 <span class="badge badge-primary"> ${order.transfers.size()} </span></a></li>
        </ul>

        <div class="tab-content">

          <div class="tab-pane fade active in" id="applies">
            <table class="table table-hover table-bordered">
              <thead>
              <tr>
                <th>sn</th>
                <th>标题</th>
                <th>支付方式</th>
                <th>支付单类型</th>
                <th>下单时间</th>
                <th>过期时间</th>
                <th>支付时间</th>
                <th>支付状态</th>
                <th>货币1</th>
                <th>货币1支付金额</th>
                <th>货币2</th>
                <th>货币2支付金额</th>
                <th>退款时间</th>
                <th>退款备注</th>
                <th>取消备注</th>
                <th>备注</th>
                <th>外部sn</th>
                <th>银行汇款截图</th>
                <th>银行汇款备注</th>
                <th>操作</th>
              </tr>
              </thead>
              <tbody>
              <c:if test="${empty order.payments}">
                <tr>
                  <td colspan="18">暂无数据</td>
                </tr>
              </c:if>
              <c:if test="${not empty order.payments}">
                <c:forEach items="${order.payments}" var="payment">
                  <tr>
                    <td>${payment.sn}</td>
                    <td>${payment.title}</td>
                    <td>${payment.payType}</td>
                    <td>${payment.paymentType}</td>
                    <td>${payment.createdTimeLabel}</td>
                    <td>${payment.expiredTimeLabel}</td>
                    <td>${payment.paidTimeLabel}</td>
                    <td><label class="label label-${payment.paymentStatusStyle}">${payment.paymentStatus}</label></td>
                    <td>${payment.currencyType1}</td>
                    <td>${payment.amount1}</td>
                    <td>${payment.currencyType2}</td>
                    <td>${payment.amount2}</td>
                    <td>${payment.refundedTimeLabel}</td>
                    <td>${payment.refundRemark}</td>
                    <td>${payment.cancelRemark}</td>
                    <td>${payment.remark}</td>
                    <td>${payment.outerSn}</td>
                    <td><c:if test="${not empty payment.offlineImage}"><img class="imageview" data-url="${payment.offlineImage}" src="${payment.offlineImage}"/></c:if></td>
                    <td>${payment.offlineMemo}</td>
                    <td>
                    <shiro:hasPermission name="order:refund">
                    <c:if test="${payment.paymentStatus == '已支付' && count > 1}">
                    <a class="btn btn-xs default yellow-stripe" href="javascript:;" data-href="${ctx}/order/refund?paymentId=${payment.id}" data-confirm="您确定要执行退款操作么？"><i class="fa fa-sign-out"></i> 退款 </a>
                    </c:if>
                    </shiro:hasPermission>
                    </td>
                  </tr>
                </c:forEach>
              </c:if>
              </tbody>
            </table>
          </div>
          <div class="tab-pane fade" id="signIns">
            <table class="table table-hover table-bordered">
              <thead>
              <tr>
                <th>单号</th>
                <th>标题</th>
                <th>币种</th>
                <th>金额</th>
                <th>用户</th>
                <th>创建时间</th>
                <th>收益时间</th>
                <th>收益单类型</th>
              </tr>
              </thead>
              <tbody>
              <c:if test="${empty order.profits}">
                <tr>
                  <td colspan="7">暂无数据</td>
                </tr>
              </c:if>
              <c:if test="${not empty order.profits}">
                <c:forEach items="${order.profits}" var="profit">
                  <tr>
                    <td>${profit.sn}</td>
                    <td>${profit.title}</td>
                    <td>${profit.currencyType}</td>
                    <td>${profit.amountLabel}</td>
                    <td><p><img src="${profit.user.avatarThumbnail}" width="30" height="30" style="border-radius: 40px !important; margin-right:5px"/>: ${profit.user.nickname}</p>
                      <p>手机号: ${profit.user.phone}</p>
                      <p>等级: ${profit.user.userRankLabel}</p></td>
                    <td>${profit.createdTimeLabel}</td>
                    <td>${profit.grantedTimeLabel}</td>
                    <td>${profit.profitType}</td>
                  </tr>
                </c:forEach>
              </c:if>
              </tbody>
            </table>
          </div>
          <div class="tab-pane fade" id="collects">
            <table class="table table-hover table-bordered">
              <thead>
              <tr>
                <th>单号</th>
                <th>标题</th>
                <th>状态</th>
                <th>币种</th>
                <th>金额</th>
                <th>转出用户</th>
                <th>转入用户</th>
                <th>创建时间</th>
                <th>转账时间</th>
                <th>转账类型</th>
                <th>转账备注</th>
                <th>备注</th>
              </tr>
              </thead>
              <tbody>
              <c:if test="${empty order.transfers}">
                <tr>
                  <td colspan="12">暂无数据</td>
                </tr>
              </c:if>
              <c:if test="${not empty order.transfers}">
                <c:forEach items="${order.transfers}" var="transfer">
                  <tr>
                    <td>${transfer.sn}</td>
                    <td>${transfer.title}</td>
                    <td><label class="label label-${transfer.transferStatusStyle}">${transfer.transferStatus}</label></td>
                    <td>${transfer.currencyType}</td>
                    <td>${transfer.amount}</td>
                    <td><p><img src="${transfer.fromUser.avatarThumbnail}" width="30" height="30"
                                style="border-radius: 40px !important; margin-right:5px"/>: ${transfer.fromUser.nickname}</p>
                      <p>手机号: ${transfer.fromUser.phone}</p>
                      <p>等级: ${transfer.fromUser.userRankLabel}</p></td>
                    <td><p><img src="${transfer.toUser.avatarThumbnail}" width="30" height="30"
                                style="border-radius: 40px !important; margin-right:5px"/>: ${transfer.toUser.nickname}</p>
                      <p>手机号: ${transfer.toUser.phone}</p>
                      <p>等级: ${transfer.toUser.userRankLabel}</p></td>
                    <td>${transfer.createdTimeLabel}</td>
                    <td>${transfer.transferredTimeLabel}</td>
                    <td>${transfer.transferType}</td>
                    <td>${transfer.transferRemark}</td>
                    <td>${transfer.remark}</td>
                  </tr>
                </c:forEach>
              </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>