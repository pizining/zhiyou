/**
 * @description my UI
 * @required jQuery
 * @author Yoki
 */

;
(function() {

  var _myui_dialog_index = 0; // 弹出窗口id

  /**
   * 弹出窗口
   */
  $.dialog = function(options) {
    options = $.extend({}, $.dialog.defaults, options || {});

    if (!options.btn) {
      alert('[缺少参数]btn不能为空!');
      return;
    }

    options.id = 'mui_dialog_' + (_myui_dialog_index++);
    var html = '<aside id="' + options.id + '" class="mui-dialog" data-index="' + _myui_dialog_index++ + '">'
      +   '<div class="mui-dialog-mask"></div>'
      +   '<div class="mui-dialog-wrap">'
      +     '<div class="mui-dialog-content mui-dialog-bottom mui-animation-up">';
    if(options.title){
      html += '<div class="mui-dialog-title">' + options.title + '</div>';
    }
    html +=   '<div class="mui-dialog-buttons">';
    $.each(options.btn, function(index){
      html +=   '<div class="mui-dialog-button" data-index="' + (index + 1) + '">' + options.btn[index] + '</div>';
    });
    if(options.cancleBtn){
      html +=   '<div class="mui-dialog-button mui-dialog-button-cancle" data-index="0">取消</div>';
    }
    html +=   '</div>'
      +     '</div>'
      +   '</div>'
      + '</aside>';
    var $dialog = $(html);
    $('body').addClass('o-hidden').append($dialog);
    //$dialogContent = $dialog.find('.mui-dialog-content');
    var onClose = function(){
      $('body').removeClass('o-hidden');
      $('.mui-dialog').remove();
    }
    $dialog.find('.mui-dialog-mask').click(function(){
      onClose();
    });
    $dialog.find('.mui-dialog-button').click(function(){
      var index = $(this).attr('data-index');
      if ($.isFunction(options.callback)) {
        options.callback.call($dialog, index);
      }
      onClose();
    });
    return $dialog;
  };

  $.dialog.defaults = $.extend({}, {
    title : '',
    btn : ['确定'],
    skin: 'footer',
    cancleBtn : true,
    callback : function(index) {
      //alert(index);
    }
  });

  /**
   * 信息提示
   */
  $.message = function(options) {
    if (typeof (options) == 'string') {
      options = {
        content : options
      };
      if (arguments.length > 1) {
        options.type = arguments[1];
      }
      if (arguments.length > 2) {
        options.timeout = arguments[2];
      }
    }
    options = $.extend({}, $.message.defaults, options || {});
    if (options.content == null) {
      options.content = '';
    }

    var html = '<div class="header-message ';
    if (options.type == 'success') {
    	html += 'header-message-success';
    } else if (options.type == 'error') {
    	html += 'header-message-error';
    } else {
    	html += 'header-message-info';
    }
    html += '">';
    html += '<i class="message-icon"></i>';
    if (options.closable){
      html += '<i class="message-close fa fa-times"></i>';
    }
    html += '<div class="message-text">' + options.content + '</div>';
    html += '</div>';
    var $message = $(html);
    
    var onClose = function() {
      if ($.isFunction(options.callback)) {
        if (options.callback.call($message, window.jQuery || window.Zepto) != false) {
          $message.slideUp(300);
        }
      } else {
        $message.slideUp(300);
      }
    };
    
    if (options.closable){
      var $messageClose = $message.find(".message-close");
      $messageClose.click(onClose);
    }
    
    $message.appendTo('body').slideDown(300);
    if (options.timeout) {
      setTimeout(function() {
        $message.slideUp(300, onClose);
      }, options.timeout);
    }
    return $message;
  };

  $.message.defaults = $.extend({}, {
    type : 'info', // info, success, error
    content : '',
    closable : true,
    timeout : 3000,
    callback : function(message) {
    }
  });

  $.messageSuccess = function(message) {
    $.message({
    	type : 'success',
      content : message,
      timeout : 2000
    });
  };

  $.messageInfo = function(message) {
    $.message({
    	type : 'info',
      content : message,
      timeout : 2000
    });
  };

  $.messageError = function(message) {
    $.message({
    	type : 'error',
      content : message,
      timeout : 3000
    });
  };
  
  /**
   * Image view
   */
  $.imageview = function(options) {
  	if(typeof(options) == 'string') {
      options = {url: options};
    } else if(typeof(options) == 'Array') {
      options = {url: options};
    }
    options = $.extend({}, $.imageview.defaults, options || {});
    if (options.url == null) {
      alert('缺少参数[图片URL]!');
      return;
    }
    
    var str = '<aside class="myui-imageview">'
    	+ '<a href="javascript:;" class="btn-close button-right"><i class="fa fa-times-circle"></i></a>'
    	+ '<header class="header">'
      + '<h2>' + options.title + '</h2>'
      + '</header>'
      + '<div class="myui-imageview-wrap"><div class="loading"></div></div>';
      + '</aside>';
    $imageview = $(str);
    $('body').css({'overflow': 'hidden'}).append($imageview);
    $imageWrap = $imageview.find(".myui-imageview-wrap");
    $loading = $imageview.find(".loading");
    
    var onClose = function(){
    	$imageview.animate({opacity: 0}, 300, function(){
    		$imageview.remove();
    	})
    	$('body').css({'overflow': 'auto'});
    };
    $imageWrap.click(function(){
    	$imageview.find(".header").slideToggle(300);
    });
    $imageview.find(".btn-close").click(onClose);;
    
    var scrWidth = $(window).width(), scrHeight = $(window).height();
    $image = $('<div class="myui-imageview-inner"><img src="' + options.url + '"></div>');
    $image.appendTo($imageWrap);
    // $image.css({'position': 'relative', 'top': '50%', 'margin-top': '-' +
    // $image.height() / 2 + 'px'});
    $image.find('img').bind('load', function(){
    	$loading.remove();
    });
    
  }
  
  $.imageview.defaults = $.extend({}, {
    url : '',
    title : '',
  });

  $.fn.placeholder = function (config) {
  	if (('placeholder' in document.createElement('input'))) {
  		return;
  	}
    return this.each(function (n) {
        var that = $(this), pl = that.attr('placeholder');
        if (this.type == 'password') {
            var wrap = that.wrap('<div class="placeholder" style="width:' + that.outerWidth(true) + 'px;height:' + that.outerHeight(true) + 'px"></div>').parent();
            var placeholderText = wrap.append('<span class="placeholder-text" style="line-height:' + that.outerHeight(true) + 'px;left:' + that.css('padding-left') + ';font-size:' + that.css('font-size') + '">' + pl + '</span>').find('span.placeholder-text');
            wrap.click(function () {
                wrap.find('span.placeholder-text').hide();
                that.focus();
            });
            that.blur(function () {
                if (that.val() == '') placeholderText.show();
            });
        } else {
            that.focus(function () {
                if (this.value == pl) that.val('').removeClass('placeholder');
            }).blur(function () {
                if (this.value == '') that.val(pl).addClass('placeholder');
            }).trigger('blur').closest('form').submit(function () {
                if (that.val() == pl) that.val('');
            });
        }
    });
  };
  // 扩展方法clearPlaceholderValue：提交数据前执行一下，清空和placeholder值一样的控件内容。防止提交placeholder的值。
  // 用于输入控件不在表单中或者使用其他代码进行提交的，不会触发form的submit事件，记得一定要执行此方法
  // 是否要执行这个方法，可以判断是否存在此扩展
  // DMEO:if($.fn.clearPlaceholderValue)$('input[placeholder],textarea[placeholder]').clearPlaceholderValue()
  $.fn.clearPlaceholderValue = function () {
    return this.each(function () {
        if (this.value == this.getAttribute('placeholder')) this.value = '';
    });
  }

  $.fn.tabs = function(tabContent, eventName) {
  	eventName = !eventName ? 'click' : eventName;
    var $tabs = $(this);
    var $tabContent = $(tabContent);
    $tabs.each(function() {
      var $this = $(this);
      var index = $tabs.index($this);
      if ($this.hasClass('current')) {
        $tabContent.eq(index).show();
      } else {
        $tabContent.eq(index).hide();
      }
    });
    $tabs.bind(eventName, function() {
      var $this = $(this);
      var index = $tabs.index($this);
      $this.addClass('current').siblings().removeClass('current');
      $tabContent.hide().eq(index).show();
    });
    var interval;
    if (interval) {
    	var showPanel = function(index) {
      	var count = $tabs.size();
        if (index < 0) {
          index = count - 1;
        } else if (index >= count) {
          index = 0;
        }
        $tabs.removeClass('current').eq(index).addClass('current');
        $tabContent.hide().eq(index).show();
      };
      
    	var index = 0;
    	var autoInterval = setInterval(function() {
        showPanel(index++);
      }, interval);
    }
  };

  $.fn.timer = function(options) {
    if (typeof (options) == 'string') {
      options = {
        beginText : options
      };
      if (arguments.length > 1) {
        options.endText = arguments[1];
      }
    }
    options = $.extend({}, $.fn.timer.defaults, options || {});
    $(this).each(function() {
      var $this = $(this);
      var beginTime = $this.attr('data-begin-time');
      if(beginTime){
        beginTime = strToDate(beginTime);
      }
      var endTime = strToDate($this.attr('data-end-time'));
      var nowTime = new Date().getTime();
      var timerInterval = function() {
        nowTime = new Date().getTime();
        var bal = endTime - nowTime;
        
        bal_day = Math.floor(bal / (60*60*24*1000));
        bal_hour = Math.floor((bal - (bal_day*60*60*24*1000)) / (60*60*1000));
        bal_minute = Math.floor((bal - (bal_day*60*60*24*1000) - (bal_hour*60*60*1000)) / (60*1000));
        bal_second = Math.floor((bal - (bal_day*60*60*24*1000) - (bal_hour*60*60*1000) - (bal_minute*60*1000)) / 1000);
        var html = '';
        if(bal_day > 0) {
          html += bal_day + '<em>' + options.unit[0] + '</em>';
        }
        html += (bal_hour < 10 ? '0' + bal_hour : bal_hour) + '<em>' + options.unit[1] + '</em>';
        html += (bal_minute < 10 ? '0' + bal_minute : bal_minute) + '<em>' + options.unit[2] + '</em>';
        html += (bal_second < 10 ? '0' + bal_second : bal_second) + '<em>' + options.unit[3] + '</em>';
        
        $this.html(html);
      };
      if (beginTime && beginTime > nowTime) { // 未开始
        $this.html(options.beginText);
      } else if (endTime > nowTime) { // 进行中
        timerInterval();
        setInterval(timerInterval, 1000);
      } else if (endTime < nowTime) { // 已结束
        $this.html(options.endText);
        clearInterval(timerInterval);
      }
    });

    // 字符串转换成日期对象函数yyyy-MM-dd HH:mm:ss
    function strToDate(dateStr) {
      var arr = dateStr.split(' ');
      arr[0] = arr[0].split('-');
      arr[1] = arr[1].split(':');
      var theDate = new Date(arr[0][0], (arr[0][1] - 1), arr[0][2], arr[1][0], arr[1][1], arr[1][2]);
      return theDate.getTime();
    }
  };
  
  $.fn.timer.defaults = $.extend({}, {
  	beginText : '未开始',
    endText : '已结束',
    units: ['天', '时', '分', '秒']
  });

})(jQuery);
