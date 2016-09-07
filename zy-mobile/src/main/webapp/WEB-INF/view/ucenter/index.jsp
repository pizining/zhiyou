<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/include/taglib.jsp"%>
<c:set var="nav" value="3" />

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
<meta name="keywords" content="微信分销">

<title>微信分销-我的</title>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<link rel="stylesheet" href="${stccdn}/css/ucenter/index.css" />
<script type="text/javascript">

	$(function() {
		<%--
		$.message({
			content: '测试测试',
			type: 'info',
			callback: function() {
			}
		});
        --%>
	});

</script>
</head>
<body class="header-fixed footer-fixed">

  <header class="header">
    <h1>我的</h1>
    <a href="${ctx}/u/message" class="button-left">
      <i class="fa fa-bell-o"></i>
      <c:if test="${unreadMessageCount > 0}">
      <em class="badge badge-success">${unreadMessageCount}</em>
      </c:if>
    </a>
    <a href="${ctx}/u/userSetting" class="button-right"><i class="fa fa-cog"></i></a>
  </header>
  
  <div class="list-group mb-0">
    <a class="list-item user-profile bd-0" href="${ctx}/u/userInfo">
      <img class="avatar round mr-20 ml-10" src="${userAvatarSmall}">
      <div class="list-text font-white lh-30">
        <div class="fs-18 bold">${user.nickname}</div>
        <c:if test="${user.userRank == 'V1'}"><label class="label purple">三级代理</label></c:if>
        <c:if test="${user.userRank == 'V2'}"><label class="label blue">二级代理</label></c:if>
        <c:if test="${user.userRank == 'V3'}"><label class="label orange">一级代理</label></c:if>
        <c:if test="${user.userRank == 'V4'}"><label class="label red">特级代理</label></c:if>
      </div>
      <i class="list-arrow"></i>
    </a>
  </div>
  
  <aside class="water">
    <div class="water-1"></div>
    <div class="water-2"></div>
  </aside>
  
  <div class="user-currency flex">
    <a class="flex-1 bd-r" href="${ctx}/u/money">
      <i class="icon icon-money icon-2x"></i>
      <em>余额</em>
      <span>¥ 0.00</span>
    </a>
    <a class="flex-1 bd-r" href="${ctx}/u/order/in">
      <i class="icon icon-coin icon-2x"></i>
      <em>进货</em>
      <span>0件</span>
    </a>
    <a class="flex-1" href="${ctx}/u/order/out">
      <i class="icon icon-point icon-2x"></i>
      <em>出货</em>
      <span>0件</span>
    </a>
  </div>
  
  <article>
    <div class="list-group">
      <c:if test="${user.userRank == 'V0'}">
      <a class="list-item" href="${ctx}/product/1">
        <i class="list-icon icon icon-account"></i>
        <div class="list-text">成为代理</div>
        <i class="list-arrow"></i>
      </a>
      </c:if>
      <c:if test="${user.userRank != 'V0'}">
      <a class="list-item list-item-icon" href="${ctx}/u/invite">
        <i class="list-icon icon icon-account"></i>
        <div class="list-text">我的团队</div>
        <i class="list-arrow"></i>
      </a>
      </c:if>
    </div>
    
    <div class="list-group">
      <a class="list-item list-item-icon" href="${ctx}/u/activity/applyList">
        <i class="list-icon icon icon-task"></i>
        <div class="list-text">我参与的活动</div>
        <i class="list-arrow"></i>
      </a>
      <a class="list-item list-item-icon" href="${ctx}/u/activity/collectList">
        <i class="list-icon icon icon-task"></i>
        <div class="list-text">我关注的活动</div>
        <i class="list-arrow"></i>
      </a>
    </div>
    
    <div class="list-group">
      <a class="list-item list-item-icon" href="${ctx}/u/report">
        <i class="list-icon icon icon-achievement"></i>
        <div class="list-text">检测报告</div>
        <i class="list-arrow"></i>
      </a>
    </div>
    
    <div class="list-group">
      <a class="list-item list-item-icon" href="${ctx}/help">
        <i class="list-icon icon icon-service"></i>
        <div class="list-text">服务中心</div>
        <i class="list-arrow"></i>
      </a>
      <a class="list-item list-item-icon" href="${ctx}/about">
        <i class="list-icon icon icon-about"></i>
        <div class="list-text">关于优检一生</div>
        <i class="list-arrow"></i>
      </a>
    </div>
    
  </article>

  <%@ include file="/WEB-INF/view/include/footer.jsp"%>
</body>
</html>
