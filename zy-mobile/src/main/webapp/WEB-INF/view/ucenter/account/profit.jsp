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

<title>收入 - ${type}</title>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<%@ include file="/WEB-INF/view/include/pageload.jsp"%>
<script type="text/javascript">
  function getUrl() {
    return '${ctx}/u/account/profit?type=${type.ordinal()}';
  }
  
  function buildRow(row) {
    var html = '<div class="list-item">' 
             +   '<div class="list-text pl-5">' 
             +     '<div class="fs-14">' + row.title + '</div>'
             +     '<div class="fs-12 font-999">' + row.createdTimeLabel + '</div>' 
             +   '</div>' 
             +   '<div class="list-unit width-100 text-right">' 
             +     '<div class="currency-in">' + row.amountLabel + '</div>' 
             +     '<div class="fs-12 font-999">状态：' + row.profitStatus + '</div>' 
             +   '</div>' 
             + '</div>';
    return html;
  }
</script>
</head>
 
<body class="account-list">
  <article class="page-wrap">
    <header class="header">
      <h1>收入 - ${type}</h1>
      <a href="${ctx}/u/account" class="button-left"><i class="fa fa-angle-left"></i></a>
    </header>
  
    <div class="page-inner">
      <div class="page-list list-group mb-0">
      </div>
    </div>
  </article>
  <%@ include file="/WEB-INF/view/include/footer.jsp"%>
</body>
</html>
