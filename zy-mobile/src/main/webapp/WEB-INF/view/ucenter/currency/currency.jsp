<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-store" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<title>钱包</title>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<link  rel="stylesheet" href="${stccdn}/css/ucenter/currency.css">
</head>

<body class="currency">
  <header class="header">
    <a href="${ctx}/u" class="button-left"><i class="fa fa-angle-left"></i></a>
  </header>
  <article>
    <nav class="flex currency-nav pb-30 mb-10">
      <a class="flex-1 text-center" href="${ctx}/u/money">
        <div class="mb-10"><i class="icon icon-cny-money"></i></div>
        <div class="fs-16 lh-24">余额</div>
        <div class="fs-12 lh-20 font-ccc">¥ 1240.00</div>
      </a>
      <a class="flex-1 text-center" href="${ctx}/u/bankCard">
        <div class="mb-10"><i class="icon icon-cny-card"></i></div>
        <div class="fs-16 lh-24">银行卡</div>
      </a>
    </nav>
    
    <div class="list-group mb-10">
      <div class="list-title">我的收入</div>
      <div class="list-item p-0">
        <div class="list-text currency-link">
          <a class="bd-r bd-b" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-order"></i></div>
           <div class="fs-14 font-333">订单收款</div>
          </a>
          <a class="bd-r bd-b" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-data"></i></div>
           <div class="fs-14 font-333">数据奖</div>
          </a>
          <a class="bd-b" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-sale"></i></div>
           <div class="fs-14 font-333">销量奖</div>
          </a>
          <a class="bd-r" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-teping"></i></div>
           <div class="fs-14 font-333">特级平级奖</div>
          </a>
        </div>
      </div>
    </div>
    
    <div class="list-group mb-0">
      <div class="list-title">我的支出</div>
      <div class="list-item p-0">
        <div class="list-text currency-link">
          <a class="bd-r bd-b" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-data"></i></div>
           <div class="fs-14 font-333">数据奖</div>
          </a>
          <a class="bd-r bd-b" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-yiping"></i></div>
           <div class="fs-14 font-333">一级平级奖</div>
          </a>
          <a class="bd-b" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-yiyue"></i></div>
           <div class="fs-14 font-333">一级越级奖</div>
          </a>
          <a class="bd-r" href="${ctx}/u/currency/">
           <div><i class="icon icon-cny-post"></i></div>
           <div class="fs-14 font-333">邮费</div>
          </a>
        </div>
      </div>
    </div>
  </article>
</body>

</html>