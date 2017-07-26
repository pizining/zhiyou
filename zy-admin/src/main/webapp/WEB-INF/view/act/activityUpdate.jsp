<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
<%@ include file="/WEB-INF/view/include/editor.jsp" %>
<!-- BEGIN JAVASCRIPTS -->
<style>
  #img {
    cursor: pointer;
  }
</style>
<script>

  var ue;
  var content = '${activity.detail}';

  function onLocation(loc) {
    $('#latitude').val(loc.latlng.lat);
    $('#longitude').val(loc.latlng.lng);
  }

  $(function () {

    var area = new areaInit('province', 'city', 'district', '${activity.areaId}');

    ue = UE.getEditor('editor', {
      serverUrl: '${ctx}/editor',
      catchRemoteImageEnable: false,
      textarea: 'detail',
      enableAutoSave: false,
      contextMenu: [],
      saveInterval: 3600000,
      toolbars: [[
        'bold', 'italic', 'underline', '|',
        'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|',
        'insertorderedlist', 'insertunorderedlist', 'link', '|',
        'simpleupload', 'insertimage'
      ]],
      'insertorderedlist': {'num': '1,2,3...'},
      'insertunorderedlist': {'disc': ''},
      elementPathEnabled: false,     //去掉元素路径
      pasteplain: true,   //是否默认为纯文本粘贴。false为不使用纯文本粘贴，true为使用纯文本粘贴
      iframeCssUrl: '${ctx}/css/editor/default.css'
    });

    ue.addListener("ready", function () {
      ue.setContent(content);
    });

    $('#form').validate({
      rules: {
        title: {
          required: true,
          maxlength: 60
        },
        'amount': {
	        required: true
        },
        areaId: {
          required: true
        },
        address: {
          required: true,
          maxlength: 100
        },
        image: {
          required: true
        },
        detail: {
          required: true,
        },
        startTime: {
          required: true,
        },
        endTime: {
          required: true
        },
        applyDeadline: {
          required: true
        },
        ticketType: {
          required: true
        },
        level: {
          required: true
        },
        maxCount:{
          required: true,
          number : true
        }
      },
      messages: {
        maxCount: {
          required: '请输入限制人数',
          number : '只能输入数字'
        }
      },
      submitHandler: function (form) {
        var content = ue.getContent();
        if (!content) {
          layer.alert('请填写活动详情')
          return false;
        }
        if (!$('#latitude').val() || !$('#longitude').val()) {
          layer.alert('请地图选址')
          return false;
        }
        if ($('#lessonType').val()==0){
          $('#sleLesson').val("");

        }
        $(form).find(':submit').prop('disabled', true);
        Layout.postForm(form);
      }
    });

    var uploader = new ss.SimpleUpload({
      button: $.makeArray($('.product-image')),
      url: '${ctx}/image/upload',
      name: 'file',
      maxSize: 4096,
      responseType: 'json',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
      onSubmit: function (filename, extension, uploadBtn, fileSize) {
        $(uploadBtn).data('origin', $(uploadBtn).attr('src'));
        $(uploadBtn).attr('src', 'http://static.thsuan.com/image/loading_image.gif');
      },
      onComplete: function (filename, response, uploadBtn, fileSize) {
        if (response.code == 0) {
          $(uploadBtn).attr('src', response.data + '@150h_240w_1e_1c.jpg');
          $('input[name="' + $(uploadBtn).data('target') + '"]').val(response.data);
        } else {
          $(uploadBtn).attr('src', $(uploadBtn).data('origin'));
          layer.alert('上传失败' + response.message);
        }
      },
      onError: function (filename, errorType, status, statusText, response, uploadBtn, fileSize) {
        $(uploadBtn).attr('src', $(uploadBtn).data('origin'));
        layer.alert('上传失败' + errorType);
      },
      onSizeError: function (filename, fileSize) {
        layer.alert('图片大小超过4MB限制');
      },
      onExtError: function (filename, extension) {
        layer.alert('图片文件格式错误, 仅限*.jpg, *.jpeg, *.png, *.gif, *.webp');
      }
    });

  });
  function selectValue(obj) {
    $("#ticketType").html("");
    if($(obj).val()==1){
      var op = '<option value="1">自购</option>';
      $("#ticketType").html(op);
      $('#lesson').show();
    }else{
      var op = '<option value="1">自购</option> <option value="2">团购</option>';
      $("#ticketType").html(op);
      $('#lesson').hide();
      $("#sleLesson").val("");
    }

  }
</script>
<!-- END JAVASCRIPTS -->

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
  <ul class="page-breadcrumb">
    <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
    <li><a href="javascript:;" data-href="${ctx}/activity">活动管理</a></li>
  </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
  <div class="col-md-12">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet light bordered">
      <div class="portlet-title">
        <div class="caption">
          <i class="icon-social-dropbox"></i> 编辑活动
        </div>
      </div>
      <div class="portlet-body form">
        <!-- BEGIN FORM-->
        <form id="form" action="" data-action="${ctx}/activity/update" class="form-horizontal" method="post">
          <input type="hidden" name="id" value="${activity.id}" />
          <div class="form-body">
            <div class="alert alert-danger display-hide">
              <i class="fa fa-exclamation-circle"></i>
              <button class="close" data-close="alert"></button>
              <span class="form-errors">您填写的信息有误，请检查。</span>
            </div>

            <div class="form-group">
              <label class="control-label col-md-3">类型<span class="required"> * </span></label>
              <div class="col-md-5">
                <select style="display: block; width: 40%;" class="form-control pull-left" onchange="selectValue(this)" id="lessonType">
                  <option value="0">新经济财富风暴</option>
                  <option value="1" ${lessonId!=null?'selected':''} >商学院课程</option>
                </select>
              </div>
            </div>
            <div class="form-group" id ="lesson" style="display: ${lessonId!=null?'block':'none'}" >
              <label class="control-label col-md-3">课程名称<span class="required"> * </span></label>
              <div class="col-md-5">
                <select style="display: block; width: 40%;" class="form-control pull-left"  id="sleLesson" name="lessonId" >
                 <c:forEach items="${lessonList}" var="less">
                    <option value="${less.id}" ${less.id==lessonId?'selected':''}>${less.title}</option>
                 </c:forEach>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">标题<span class="required"> * </span></label>
              <div class="col-md-5">
                <input type="text" class="form-control" name="title" value="${activity.title}"/>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">报名费<span class="required"> * </span></label>
              <div class="col-md-5">
                <input type="text" class="form-control" name="amount" value="${activity.amount}"/>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">活动限制人数<span class="required"> * </span>
              </label>
              <div class="col-md-5">
                <input type="text" class="form-control" id="maxCount" name="maxCount" value="${activity.maxCount}" />
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">活动票务类型<span class="required"> * </span></label>
              <div class="col-md-5">
                <select style="display: block; width: 40%;" class="form-control pull-left" id="ticketType" name="ticketType">
                  <option value="1"<c:if test="${activity.ticketType == 1}"> selected="selected"</c:if>>自购</option>
                  <c:if test="${lessonId==null}">
                    <option value="2"<c:if test="${activity.ticketType == 2}"> selected="selected"</c:if>>团购</option>
                  </c:if>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">自购权限<span class="required"> * </span></label>
              <div class="col-md-5">
                <select style="display: block; width: 40%;" class="form-control pull-left" id="level" name="level">
                  <option value="4"<c:if test="${activity.level == 4}"> selected="selected"</c:if>>特级服务商及以上</option>
                  <option value="3"<c:if test="${activity.level == 3}"> selected="selected"</c:if>>省级服务商及以上</option>
                  <option value="2"<c:if test="${activity.level == 2}"> selected="selected"</c:if>>市级服务商及以上</option>
                  <option value="1"<c:if test="${activity.level == 1}"> selected="selected"</c:if>>VIP及以上</option>
                  <option value="0"<c:if test="${activity.level == 0}"> selected="selected"</c:if>>无限制</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">图片<span class="required"> * </span></label>
              <div class="col-md-5">
                <img data-target="image" class="product-image bd" src="<c:if test='${not empty activity.image}'>${activity.imageBig}</c:if><c:if test='${empty activity.image}'>${ctx}/image/upload_240_150.jpg</c:if>">
                <input type="hidden" name="image" value="${activity.image}"/>
                <p class="help-block">图片尺寸 750*450</p>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">省市区<span class="required"> * </span></label>
              <div class="col-md-5">
                <select style="display:block;width:32%;" class="form-control pull-left" id="province" name="province">
                  <option value="">-- 请选择省 --</option>
                </select>
                <select style="display:block;width:32%;margin-left:2%" class="form-control pull-left" id="city" name="city">
                  <option value="">-- 请选择市 --</option>
                </select>
                <select style="display:block;width:32%;margin-left:2%" class="form-control pull-left" id="district" name="areaId">
                  <option value="">-- 请选择区 --</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">地址<span class="required"> * </span></label>
              <div class="col-md-5">
                <input type="text" class="form-control" name="address" value="${activity.address}"/>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">地图选址<span class="required"> * </span></label>
              <div class="col-md-5">
                <iframe id="mapPage" width="750" height="750" frameborder=0
                        src="http://apis.map.qq.com/tools/locpicker?search=1&type=1&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=myapp<c:if test="${not empty activity.latitude && not empty activity.longitude}">&coord=${activity.latitude},${activity.longitude}</c:if>">
                </iframe>

                <input type="hidden" id="latitude" name="latitude" value="${activity.latitude}" />
                <input type="hidden" id="longitude" name="longitude" value="${activity.longitude}" />
              </div>
            </div>
            <div class="form-group">
              <label class="control-label col-md-3">开始时间<span class="required"> * </span></label>
              <div class="col-md-5">
                <div class="input-icon input-medium right">
                  <i class="fa fa-calendar"></i>
                  <input class="form-control" type="text" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                         name="startTime" value="${activity.startTimeFormatted}" placeholder="开始时间"/>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-md-3">结束时间<span class="required"> * </span></label>
              <div class="col-md-5">
                <div class="input-icon input-medium right">
                  <i class="fa fa-calendar"></i>
                  <input class="form-control" type="text" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                         name="endTime" value="${activity.endTimeFormatted}" placeholder="结束时间"/>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-md-3">报名截止时间<span class="required"> * </span></label>
              <div class="col-md-5">
                <div class="input-icon input-medium right">
                  <i class="fa fa-calendar"></i>
                  <input class="form-control" type="text" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                         name="applyDeadline" value="${activity.applyDeadlineFormatted}" placeholder="报名截止时间"/>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-md-3">活动详情<span class="required"> * </span></label>
              <div class="col-md-5">
                <div class="input-icon right">
                  <script id="editor" type="text/plain" style="width:750px;height:500px;"></script>
                </div>
              </div>
            </div>

          </div>
          <div class="form-actions fluid">
            <div class="col-md-offset-3 col-md-9">
              <button type="submit" class="btn green">
                <i class="fa fa-save"></i> 保存
              </button>
              <button class="btn default" data-href="${ctx}/activity">
                <i class="fa fa-chevron-left"></i> 返回
              </button>
            </div>
          </div>
        </form>
        <!-- END FORM-->
      </div>
    </div>
    <!-- END VALIDATION STATES-->
  </div>
</div>
