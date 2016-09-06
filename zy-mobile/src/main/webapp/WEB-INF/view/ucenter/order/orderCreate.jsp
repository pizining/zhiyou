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

<link href="${stccdn}/css/ucenter/order.css" rel="stylesheet"> 
<link href="${stccdn}/css/ucenter/address.css" rel="stylesheet" />
<script src="${stccdn}/plugin/laytpl-1.1/laytpl.js"></script>

<title>确认订单信息</title>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<script src="${stccdn}/js/area.js"></script>

<script>
  $(function() {
  	//选择收货地址
  	$('.receiver-info').click(function(){
  		if($(this).find('.btn-add-address').length){
  			return;
  		}
  		toSetAddress();
  	});
  
    $('body').on('click', '.btn-add-address', function() {
      toCreateAddress();
    });

    function toCreateAddress() {
      closeAddress();
      var addressCreateHtml = document.getElementById('addressCreateTpl').innerHTML;
      $('article > .list-item').hide();
      $('body').css({
        'overflow' : 'hidden'
      }).append(addressCreateHtml);
      var area = new areaInit('province', 'city', 'district');
    }

    function toSetAddress() {
      $.ajax({
        url : '${ctx}/u/address/listAjax',
        type : 'POST',
        dataType : 'json',
        success : function(result) {
          var addressTpl = document.getElementById('addressTpl').innerHTML;
          laytpl(addressTpl).render(result.data, function(html) {
            closeAddress();
            $('article > .list-item').hide();
            $('body').css({
              'overflow' : 'hidden'
            }).append(html);
          });
        }
      });
    }

    $('body').on('click', '.address', function() {
      var $this = $(this);
      var address = {};
      address.id = $this.attr('data-id');
      address.name = $this.find('.address-name').text();
      address.phone = $this.find('.address-phone').text();
      address.addressText = $this.find('.address-text').text();

      var layerIndex = layer.open({
        content : '您确定要设置收货地址吗？<br>' + '收件人：' + address.name + '<br>' + '手机号：' + address.phone + '<br>' + '地址：' + address.addressText,
        btn : [ '确认', '取消' ],
        shadeClose : false,
        yes : function() {
          closeAddress();
          layer.close(layerIndex);
          setAddress(address);
        },
        no : function() {
          layer.close(layerIndex);
        }
      });
    });

    $('body').on('click', '.btn-create', function() {
      var realname = $('#realname').val();
      var phone = $('#phone').val();
      var address = $('#address').val();
      var areaId = $('#district option:selected').val();
      if (!realname) {
        messageFlash('请填写收件人名');
        return;
      }
      if (!phone) {
        messageFlash('请填写收件人电话');
        return;
      }
      if (!areaId) {
        messageFlash('请选择收件人省市区');
        return;
      }
      if (!address) {
        messageFlash('请填写收件人详细地址');
        return;
      }

      $.ajax({
        url : '${ctx}/u/address/createAjax',
        data : {
          realname : $('#realname').val(),
          phone : $('#phone').val(),
          address : $('#address').val(),
          areaId : $('#district option:selected').val()
        },
        type : 'POST',
        dataType : 'json',
        success : function(result) {
          if (result.code == 0) {
            var address = result.data;
            setAddress(address);
          }
        }
      });
    });

  });
  
  function setAddress(address) {
    closeAddress();
    $('#addressId').val(address.id);
    var addressText = address.addressText ? address.addressText 
        : address.province + ' ' + address.city + ' ' + address.district + ' ' + address.address
    $('.receiver-info').html('<div>' + address.realname + '<span class="right">' + address.phone + '</span></div>' 
        + '<div class="fs-14 font-777">' + addressText+ '</div>')
  }
  
  function closeAddress() {
    $('body').css({
      'overflow' : 'auto'
    });
    $('.aside-address-create').remove();
    $('.aside-address').remove();
    $('article > .list-item').show();
  }
</script>

<script id="addressCreateTpl" type="text/html">
<aside class="aside-address-create abs-lt size-100p bg-white" style="z-index: 9999">
  <header class="header">
    <h1>新增收货地址</h1>
    <a href="javascript:closeAddress();" class="button-left"><i class="fa fa-angle-left"></i></a>
  </header>
  <article class="address-create">
      <div class="form-message note note-warning mb-0 hide">
        <p>输入信息有误，请先更正。</p>
      </div>
      <div class="list-group">
        <div class="list-item">
          <label class="list-label" for="realname">收件人</label>
          <div class="list-text">
            <input type="text" id="realname" name="realname" class="form-input" value="" placeholder="填写收件人姓名">
          </div>
        </div>
        <div class="list-item">
          <label class="list-label" for="phone">手机号码</label>
          <div class="list-text">
            <input type="tel" id="phone" name="phone" class="form-input" value="" placeholder="填写收件人手机号码">
          </div>
        </div>
        <div class="list-item">
          <label class="list-label">省份</label>
          <div class="list-text form-select">
            <select name="province" id="province">
              <option value="">请选择</option>
            </select>
          </div>
        </div>
        <div class="list-item">
          <label class="list-label">城市</label>
          <div class="list-text form-select">
            <select name="city" id="city">
              <option value="">请选择</option>
            </select>
          </div>
        </div>
        <div class="list-item">
          <label class="list-label">地区</label>
          <div class="list-text form-select">
            <select name="areaId" id="district">
              <option value="">请选择</option>
            </select>
          </div>
        </div>
        <div class="list-item">
          <div class="list-text">
            <textarea id="address" name="address" class="form-input" rows="3" placeholder="填写详细地址，例如街道名称，楼层和门牌号等信息"></textarea>
          </div>
        </div>
        <div class="list-item">
          <div class="list-text">设为默认地址</div>
          <div class="list-unit form-switch">
            <input type="hidden" name="_isDefault" value="false">
            <input type="checkbox" id="isDefault" name="isDefault" value="true">
            <label class="radius" for="isDefault"></label>
          </div>
        </div>
      </div>

      <div class="form-btn">
        <input class="btn-create btn green btn-block" type="button" value="保 存">
      </div>
  </article>
</aside>
</script>

<script id="addressTpl" type="text/html">
<aside class="aside-address abs-lt size-100p bg-white" style="z-index: 9999">
  <header class="header" style="position: none;">
    <h1>设置收货地址</h1>
    <a href="javascript:closeAddress();" class="button-left"><i class="fa fa-angle-left"></i></a>
    <a href="javascript:;" class="button-right btn-add-address">新增收货地址</a>
  </header>
  <div class="address-list clearfix">
  	{{# for(var i = 0, len = d.length; i < len; i++){ }}
      <a href="javascript:;" class="address" data-id="{{ d[i].id }}">
        <div class="address-wrap relative">
          <div class="fs-16 bold lh-24"><span class="address-name">{{ d[i].realname }}</span><span class="address-phone right">{{ d[i].phone }}</span></div>
          <div class="fs-12 address-text">{{ d[i].province }} {{ d[i].city }} {{ d[i].district }} {{ d[i].address }}</div>
        </div>
      </a>
      {{# } }}
  </div>
</aside>
</script>
</head>
<body>
  <header class="header">
    <h1>确认订单信息</h1>
    <a href="javascript:history.back();" class="button-left"><i class="fa fa-angle-left"></i></a>
  </header>
  
  <form id="orderForm" class="valid-form" action="${ctx}/u/order/create" method="post">
  
  <c:if test="${not empty parent}">
  <input type="hidden" name="parentId" value="${parent.id}">
  <div class="parent-alert alert alert-warning mb-10">
    <img class="image-40 round" src="${parent.avatarThumbnail}">
    <span class="ml-10">${parent.nickname} 将成为您的上级代理.</span>
  </div>
  </c:if>
  
  <article class="order order-detail">
    <div class="list-group">
      <div class="list-title">收件人信息</div>
      <div class="list-item">
        <div class="list-icon"><i class="fa fa-map-marker fs-24"></i></div>
        <div class="list-text fs-14 font-333 receiver-info">
          <c:if test="${empty address}">
            <span class="lh-30">您还未设置收货地址</span>
            <a class="btn-add-address btn orange btn-sm round-2 right width-180" href="javascript:;">设置收货地址</a>
          </c:if>
          <c:if test="${not empty address}">
            <div>${address.realname}<span class="right">${address.phone}</span></div>
            <div class="fs-14 font-777">${address.province} ${address.city} ${address.district} ${address.address}</div>
          </c:if>
        </div>
        <input type="hidden" name="addressId" value="${address.id}">
      </div>
    </div>
    
    <div class="list-group">
      <div class="list-title">商品信息</div>
      <div class="list-item">
        <div class="list-text relative font-333">
          <img class="product-image abs-lt" alt="" src="${product.image1Thumbnail}">
          <div class="product-title">${product.title}</div>
          <div class="product-price abs-rt text-right">
            <div class="lh-24 fs-14 font-orange">¥ ${product.price}</div>
            <div class="lh-24 fs-12 font-gray">x ${quantity}</div>
          </div>
          <input type="hidden" name="productId" value="${product.id}">
          <input type="hidden" name="quantity" value="${quantity}">
        </div>
      </div>
      <div class="list-item">
        <div class="list-text text-right">
          <%-- <div class="fs-12">合计：<span class="font-red">¥ ${product.price * quantity}</span></div> --%>
          <div class="fs-14">应付款： <span class="font-orange fs-16 bold">¥ ${product.price * quantity}</span></div>
        </div>
      </div>
    </div>
    
    <div class="list-group">
      <div class="list-title">请写下您的订单留言</div>
      <div class="list-item">
        <div class="list-text">
          <textarea name="buyerMemo" class="form-input" rows="2" placeholder="填写您的订单留言"></textarea>
        </div>
      </div>
    </div>
    
    <div class="form-btn">
      <input type="submit" value="确认订单" class="btn-submit btn btn-block orange">
    </div>
    
  </article>
  </form>
  
</body>
</html>