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

<title>签到失败</title>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<link href="${stccdn}/css/signIn.css" rel="stylesheet">
<script type="text/javascript">
  $(function() {

  });
</script>
 
</head>
<body class="body-bg signInFail pb-15">
    
    <div style="margin-top: 5%;">
      <div class="width-100p text-center">
        <img class="user-head " src="http://image.zhi-you.net/avatar/ed673dc0-9e83-4e99-9206-1f33064dc099@240h_240w_1e_1c.jpg"/>
        <p class="width-100p fs-16 font-white mt-5">昵称昵称昵称</p>
      </div>
    </div>
    
    <img src="${stccdn}/image/tmp/failImg.png" class="width-50p block center" style="margin-top: 33%;" />
    
    <a href="#">
      <img src="${stccdn}/image/tmp/sign.png" class="width-25p block center" style="margin-top: 5%;"/>
    </a>
    
    <img src="${stccdn}/image/tmp/footer.png" class="block center" style="width: 40%; margin-top: 50px;" />
</body>
</html>
 
