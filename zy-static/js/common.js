/**
 * Common js
 */

window.messageShow = function(message, icon) {
  $.message('message', icon || 'info');
};

window.messageFlash = function(message, time) {
  layer.open({
    content : message,
    skin : 'msg',
    time : time || 2 // 自动关闭
  });
};

window.messageAlert = function(message, button) {
  layer.open({
    content : message,
    btn : button || '确定'
  });
};

$(function() {
  
  /* 处理移动端click事件 */
  if(typeof(FastClick) != 'undefined') {
    FastClick.attach(document.body);
  }
  
  /* 全局的ajax访问，处理ajax清求时sesion超时 */
  $(document).ajaxComplete(function(event, XMLHttpRequest, textStatus) {
    //alert("XMLHttpRequest.status=" + XMLHttpRequest.status);
    switch (XMLHttpRequest.status) {
      case 401:
        messageFlash('您还没有登录, 请先登录');
        break;
      case 403:
        messageShow('您没有权限执行该操作', 'error');
        break;
      case 500:
        messageFlash('操作失败, 请稍后再试');
        break;
      default:
        break;
    }
  });
  
  /* 回到顶部按钮 */
  if($('.go-top').length > 0) {
    
    $('.go-top').click(function() {
      $("html, body").animate({
        scrollTop : 0
      }, 200);
    });
    
    var showTopButton = function() {
      h = $(window).height();
      t = $(document).scrollTop();
      if (t >= 200) {
        $('.go-top').show();
      } else {
        $('.go-top').hide();
      }
    };
    showTopButton();
    $(window).scroll(function(e) {
      showTopButton();
    });
  }
  
});

/**
 * Debug print
 * @param map
 */
function printMap(map) {
  var s = '{';
  for ( var k in map) {
    s += '\n\t' + k + ': \'' + map[k] + '\'';
  }
  s += '\n}';
  alert(s);
}
