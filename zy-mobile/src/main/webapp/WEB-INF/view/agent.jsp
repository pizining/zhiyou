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

  <title>服务商套餐</title>
  <%@ include file="/WEB-INF/view/include/head.jsp"%>
  <style>
    .form-radio.current {
      background-color: #f1f1f1;
    }
    .form-radio img {
      opacity: .7;
    }
    .form-radio.current img {
      opacity: 1;
    }
    .form-radio.current h2 {
      color: #222 !important;
    }
    .form-radio.current div {
      font-weight: bold;
    }
  </style>

  <script>
		$(function() {

			$('.form-radio img, .form-radio .list-text').click(function(){
				$('[name="agentLevel"]').removeAttr('checked');
				$(this).parent().find('[name="agentLevel"]').click().attr('checked', 'checked');
			});

			$('[name="agentLevel"]').click(function(){
				var item = $(this).parents('.form-radio');
				item.addClass('current').siblings().removeClass('current');
				var quantity = item.find('.quantity').text();
				var productId = item.attr('data-id');
				$('[name="quantity"]').val(quantity);
				$('[name="productId"]').val(productId);
			});

			$('#btnSubmit').click(function(){
				if(!$('[name="quantity"]').val()) {
					messageFlash('请选择服务商套餐');
					return false;
				}
				$('#form').submit();
			});

		});
  </script>

</head>
<body>

<header class="header">
  <h1><c:if test="${userRank == 'V0'}">成为服务商</c:if><c:if test="${userRank != 'V0'}">升级服务商</c:if></h1>
  <a href="${ctx}/u" class="button-left"><i class="fa fa-angle-left"></i></a>
  <a class="button-right" href="${ctx}/help"><i class="fa fa-question-circle"></i></a>
</header>

<div class="note note-warning mb-0">
  <p><i class="fa fa-exclamation-circle"></i> 购买下列套餐产品即可<c:if test="${userRank != 'V0'}">升级</c:if>成为相应服务商。</p>
</div>

<article class="mb-15 clearfix">
  <form id="form" action="${ctx}/u/order/create" method="get">
    <input type="hidden" name="productId" value="">
    <input type="hidden" name="quantity" value="">

    <div class="list-group">
      <!-- form-radio -->
      <c:if test="${userRank == 'V0' || userRank == 'V1' || userRank == 'V2'}">

        <div class="list-item form-radio" data-id="${productNew.id}">
          <div class="list-icon">
            <input id="agentLevel1New" type="radio" name="agentLevel" value="V3">
            <label class="i-checked" for="agentLevel1New"></label>
          </div>
          <img class="image-80 block mr-10" src="${productNew.image1Thumbnail}">
          <div class="list-text">
            <h2 class="font-777 fs-15 lh-24">${productNewd.title}服务商套餐 <span class="quantity">${quantity1New}</span>次</h2>
            <div class="lh-30"><label class="label red">省级服务商</label></div>
            <div class="font-orange lh-24">¥ ${amount1New}</div>
          </div>
        </div>

        <%--<div class="list-item form-radio" data-id="${productOld.id}">--%>
          <%--<div class="list-icon">--%>
            <%--<input id="agentLevel1Old" type="radio" name="agentLevel" value="V3">--%>
            <%--<label class="i-checked" for="agentLevel1Old"></label>--%>
          <%--</div>--%>
          <%--<img class="image-80 block mr-10" src="${productOld.image1Thumbnail}">--%>
          <%--<div class="list-text">--%>
            <%--<h2 class="font-777 fs-15 lh-24">${productOld.title}服务商套餐 <span class="quantity">${quantity1Old}</span>次</h2>--%>
            <%--<div class="lh-30"><label class="label red">一级服务商</label></div>--%>
            <%--<div class="font-orange lh-24">¥ ${amount1Old}</div>--%>
          <%--</div>--%>
        <%--</div>--%>

      </c:if>
      <c:if test="${userRank == 'V0' || userRank == 'V1'}">

        <div class="list-item form-radio" data-id="${productNew.id}">
          <div class="list-icon">
            <input id="agentLevel2New" type="radio" name="agentLevel" value="V2">
            <label class="i-checked" for="agentLevel2New"></label>
          </div>
          <img class="image-80 block mr-10" src="${productNew.image1Thumbnail}">
          <div class="list-text">
            <h2 class="font-777 fs-15 lh-24">${productNew.title}服务商套餐 <span class="quantity">${quantity2New}</span>次</h2>
            <div class="lh-30"><label class="label yellow">市级服务商</label></div>
            <div class="font-orange lh-24">¥ ${amount2New}</div>
          </div>
        </div>

        <%--<div class="list-item form-radio" data-id="${productOld.id}">--%>
          <%--<div class="list-icon">--%>
            <%--<input id="agentLevel2Old" type="radio" name="agentLevel" value="V2">--%>
            <%--<label class="i-checked" for="agentLevel2Old"></label>--%>
          <%--</div>--%>
          <%--<img class="image-80 block mr-10" src="${productOld.image1Thumbnail}">--%>
          <%--<div class="list-text">--%>
            <%--<h2 class="font-777 fs-15 lh-24">${productOld.title}服务商套餐 <span class="quantity">${quantity2Old}</span>次</h2>--%>
            <%--<div class="lh-30"><label class="label yellow">市级服务商</label></div>--%>
            <%--<div class="font-orange lh-24">¥ ${amount2Old}</div>--%>
          <%--</div>--%>
        <%--</div>--%>
      </c:if>
      <c:if test="${userRank == 'V0'}">

        <div class="list-item form-radio" data-id="${productNew.id}">
          <div class="list-icon">
            <input id="agentLevel3New" type="radio" name="agentLevel" value="V1">
            <label class="i-checked" for="agentLevel3New"></label>
          </div>
          <img class="image-80 block mr-10" src="${productNew.image1Thumbnail}">
          <div class="list-text">
            <h2 class="font-777 fs-15 lh-24">${productNew.title}服务商套餐 <span class="quantity">${quantity3New}</span>次</h2>
            <div class="lh-30"><label class="label green">VIP服务商</label></div>
            <div class="font-orange lh-24">¥ ${amount3New}</div>
          </div>
        </div>
        <%--<div class="list-item form-radio" data-id="${productOld.id}">--%>
          <%--<div class="list-icon">--%>
            <%--<input id="agentLevel3Old" type="radio" name="agentLevel" value="V1">--%>
            <%--<label class="i-checked" for="agentLevel3Old"></label>--%>
          <%--</div>--%>
          <%--<img class="image-80 block mr-10" src="${productOld.image1Thumbnail}">--%>
          <%--<div class="list-text">--%>
            <%--<h2 class="font-777 fs-15 lh-24">${productOld.title}服务商套餐 <span class="quantity">${quantity3Old}</span>次</h2>--%>
            <%--<div class="lh-30"><label class="label green">市级服务商</label></div>--%>
            <%--<div class="font-orange lh-24">¥ ${amount3Old}</div>--%>
          <%--</div>--%>
        <%--</div>--%>
      </c:if>
        <div class="list-item form-radio" data-id="${productNew.id}">
          <div class="list-icon">
            <input id="agentLevel4New" type="radio" name="agentLevel" value="V1">
            <label class="i-checked" for="agentLevel4New"></label>
          </div>
          <img class="image-80 block mr-10" src="${productNew.image1Thumbnail}">
          <div class="list-text">
            <h2 class="font-777 fs-15 lh-24">${productNew.title}服务商套餐 <span class="quantity">${quantity4New}</span>次</h2>
            <div class="lh-30"><label class="label blue">特级服务商</label></div>
            <div class="font-orange lh-24">¥ ${amount4New}</div>
          </div>
        </div>
    </div>

    <div class="form-btn">
      <a id="btnSubmit" class="btn orange btn-block" href="javascript:;">购买套餐</a>
    </div>

  </form>
</article>

</body>
</html>
