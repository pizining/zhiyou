<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/view/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text; charset=utf-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <title>我的团队</title>
    <%@ include file="/WEB-INF/view/include/head.jsp"%>
    <script type="text/javascript">
        $(function() {

        });
    </script>
</head>
<body>
<header class="header">
    <h1>我的团队</h1>
    <a href="${ctx}/u" class="button-left"><i class="fa fa-angle-left"></i></a>
</header>

<article>
    <c:if test="${empty list}">
        <div class="page-empty">
            <i class="fa fa-user"></i>
            <span>您还没有团队成员</span>
        </div>
    </c:if>

    <div class="list-group">
        <div class="list-item">
            <i class="list-icon fa fa-users"></i>
            <div class="list-text">直接下级服务商数</div>
            <div class="list-unit">${agentsCount}</div>
        </div>
        <div class="list-item">
            <i class="list-icon fa fa-users"></i>
            <div class="list-text">下级服务商总数</div>
            <div class="list-unit">${allAgentsCount}</div>
        </div>
    </div>

    <c:if test="${not empty list}">
        <div class="list-group">
            <div class="list-title">我的直接下级服务商</div>
            <c:forEach items="${list}" var="inviteUser" varStatus="varStatus">
                <a class="list-item invite" href="${ctx}/u/team/${inviteUser.id}">
                    <div class="avatar">
                        <img class="image-40 round mr-10" src="${inviteUser.avatarThumbnail}">
                    </div>
                    <div class="list-text">
                        <div class="fs-15">
                            <c:if test="${inviteUser.isFrozen}">
                                <label style="color: #d9d9d9;">${inviteUser.nickname}(已冻结)</label>
                            </c:if>
                            <c:if test="${!inviteUser.isFrozen}">
                                ${inviteUser.nickname}
                            </c:if>
                        </div>
                        <div class="font-777 fs-14"><i class="fa fa-phone font-999"> ${inviteUser.phone}</i></div>
                    </div>
                    <div class="list-unit">
                        <c:if test="${inviteUser.userRank == 'V1'}"><label class="label purple">VIP</label></c:if>
                        <c:if test="${inviteUser.userRank == 'V2'}"><label class="label blue">市级服务商</label></c:if>
                        <c:if test="${inviteUser.userRank == 'V3'}"><label class="label orange">省级服务商</label></c:if>
                        <c:if test="${inviteUser.userRank == 'V4'}"><label class="label red">特级服务商</label></c:if>
                    </div>
                    <i class="list-arrow"></i>
                </a>
            </c:forEach>
        </div>
    </c:if>

</article>
<%@ include file="/WEB-INF/view/include/footer.jsp"%>
</body>
</html>
