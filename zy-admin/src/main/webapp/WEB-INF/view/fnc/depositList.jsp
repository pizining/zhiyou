<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
<style>
  .imageview {
    cursor: pointer;
    width: 80px;
    height: 80px;
  }

  .mr-10 {
    margin-left: 10px;
  }

  .text {
    width: 320px;
    height: 100px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    cursor: pointer;
  }
</style>
<!-- BEGIN JAVASCRIPTS -->
<script id="confirmTmpl" type="text/x-handlebars-template">
  <form id="confirmForm{{id}}" action="" data-action="" class="form-horizontal" method="post" style="width: 95%; margin: 10px;">
    <input type="hidden" name="id" value="{{id}}"/>
    <div class="form-body">
      <div class="alert alert-danger display-hide">
        <i class="fa fa-exclamation-circle"></i>
        <button class="close" data-close="alert"></button>
        <span class="form-errors">您填写的信息有误，请检查。</span>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4">审核结果<span class="required"> * </span></label>
        <div class="col-md-6">
          <select name="isSuccess" class="form-control">
            <option value="">--请选择--</option>
            <option value="true">通过</option>
            <option value="false">拒绝</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4">审核备注<span class="required"> * </span>
        </label>
        <div class="col-md-6">
          <textarea type="text" class="form-control" name="remark"></textarea>
        </div>
      </div>
    </div>
    <div class="form-actions fluid">
      <div class="col-md-offset-5 col-md-7">
        <button id="depositConfirmSubmit{{id}}" type="button" class="btn green">
          <i class="fa fa-save"></i> 保存
        </button>
        <button id="depositConfirmCancel{{id}}" class="btn default" data-href="">
          <i class="fa fa-chevron-left"></i> 返回
        </button>
      </div>
    </div>
  </form>
</script>
<script>

  function sum() {
    $.post("${ctx}/deposit/sum", $('#searchForm').serialize(), function(result) {
      if(result.code == 0) {
        var data = result.data;
        $('#count').text(data.count + '笔');
        $('#sumAmount').text(data.sumAmount == null? 0.00 + '元' : data.sumAmount.toFixed(2) + '元');
      }
    });
  }

  $(function () {
    
	sum();
    
    $('.filter-submit').click(function(){
      sum();
    })
    
    var grid = new Datatable();
    var template = Handlebars.compile($('#confirmTmpl').html());

    $('#dataTable').on('click', '.deposit-confirm', function () {
      var id = $(this).data('id');
      var data = {
        id: id
      };
      var html = template(data);
      var index = layer.open({
        type: 1,
        //skin: 'layui-layer-rim', //加上边框
        area: ['600px', '360px'], //宽高
        content: html
      });

      $form = $('#confirmForm' + id);
      $form.validate({
        rules: {
          isSuccess: {
            required: true
          },
          confirmRemark: {
            required: true
          }
        },
        messages: {}
      });

      $('#depositConfirmSubmit' + id).bind('click', function () {
        var result = $form.validate().form();
        if (result) {
          var url = '${ctx}/deposit/confirmPaid';
          $.post(url, $form.serialize(), function (data) {
            if (data.code === 0) {
              layer.close(index);
              grid.getDataTable().ajax.reload(null, false);
            } else {
              layer.alert('审核失败,原因' + data.message);
            }
          });
        }
      })

      $('#depositConfirmCancel' + id).bind('click', function () {
        layer.close(index);
      })

    });

    grid.init({
      src: $('#dataTable'),
      onSuccess: function (grid) {
        // execute some code after table records loaded
      },
      onError: function (grid) {
        // execute some code on network or other general error  
      },
      dataTable: {
        //"sDom" : "<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'<'table-group-actions pull-right'>>r>t<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'>r>>", 
        lengthMenu : [ [ 10, 20, 50, 100 ], [ 10, 20, 50, 100 ] ],// change per page values here
        pageLength: 20, // default record count per page
        order: [], // set first column as a default sort by desc
        ajax: {
          url: '${ctx}/deposit', // ajax source
        },
        columns: [
         /* {
            data: 'id',
            title: 'id'
          },*/
          {
            data: 'sn',
            title: '充值单号',
            orderable: false,
            render: function (data, type, full) {
              return full.sn;
            }
          },
          {
            data: 'payType',
            title: '支付方式',
            orderable: false
          },
          {
            data: 'depositStatus',
            title: '充值状态',
            orderable: false,
            render: function (data, type, full) {
              return '<label class="label label-' + full.depositStatusStyle + '">' + data + '</label>';
            }
          },
          {
            data: '',
            title: '用户信息',
            orderable: false,
            render: function (data, type, full) {
              return formatUser(full.user);
            }
          },
/*          {
            data: 'currencyType1',
            title: '货币类型',
            orderable: false
          },*/
          {
            data: 'amount1Label',
            title: '金额',
            orderable: false
          },
          {
            data: 'createdTime',
            title: '提交时间',
            orderable: true
          },
          {
            data: 'paidTime',
            title: '支付时间',
            orderable: true
          },
          {
            data: 'offlineImage',
            title: '银行汇款截图',
            orderable: false,
            render: function (data, type, full) {
              var offlineImages = full.offlineImages;
              if (offlineImages) {
                var html = '';
                for (var i in offlineImages) {
                  var image = offlineImages[i];
                  html += '<img class="imageview mr-10" data-url="' + image.image + '" src="' + image.imageThumbnail + '" >';
                }
                return html;
              } else {
                return '';
              }
            }
          },
          {
            data: 'offlineMemo',
            title: '银行汇款备注',
            orderable: false
          },
          {
            data: 'outerSn',
            title: '外部sn',
            orderable: true
          },
          {
            data: '',
            title: '操作',
            orderable: false,
            render: function (data, type, full) {
              var optionHtml = '';
              <shiro:hasPermission name="deposit:confirmPaid">
              if (full.payType == '银行汇款' && full.depositStatus == '待确认') {
                optionHtml += '<a class="btn btn-xs default yellow-stripe deposit-confirm" href="javascript:;" data-id="' + full.id + '"><i class="fa fa-edit"></i> 确认已支付</a>';
              }
              </shiro:hasPermission>
              return optionHtml;
            }
          }]
      }
    });

    $('#dataTable').on('click', '.imageview', function () {
      var url = $(this).attr('data-url');
      $.imageview({
        url: url,
        title: '支付凭证图片'
      });
    });
    
  });

  <shiro:hasPermission name="deposit:export">
  function depositExport() {
    location.href = '${ctx}/deposit/export?' + $('#searchForm').serialize();
  }
  </shiro:hasPermission>
</script>

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
  <ul class="page-breadcrumb">
    <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
    <li><a href="javascript:;" data-href="${ctx}/deposit">充值管理</a></li>
  </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
  <div class="col-md-12">
    <!-- BEGIN ALERTS PORTLET-->
    <div class="portlet light bordered">
    <div class="portlet-title">
      <div class="caption">
        <i class="icon-docs"></i><span>充值管理 </span>
      </div>
      <div class="tools"></div>
      </div>
      <div class="row">
        <div class="col-md-4">
            <div class="note note-info">
                <h4 class="block">总笔数</h4>
                <p id="count">0 笔</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="note note-danger">
                <h4 class="block">总金额</h4>
                <p id="sumAmount">0.00 元</p>
            </div>
        </div>
      </div>
      <div class="portlet-title">
        <div class="caption">
          <i class="icon-login"></i><span>充值管理 </span>
        </div>
      </div>
      <div class="portlet-body clearfix">
        <div class="table-container">
          <div class="table-toolbar">
            <form id="searchForm" class="filter-form form-inline">
              <input id="_orderBy" name="orderBy" type="hidden" value=""/>
              <input id="_direction" name="direction" type="hidden" value=""/>
              <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/>
              <input id="_pageSize" name="pageSize" type="hidden" value="20"/>

              <div class="form-group">
                <input type="text" name="phoneEQ" class="form-control" placeholder="手机号"/>
              </div>

              <div class="form-group">
                <input type="text" name="nicknameLK" class="form-control" placeholder="昵称"/>
              </div>

              <div class="form-group">
                <input type="text" name="snEQ" class="form-control" placeholder="充值单号"/>
              </div>

              <div class="form-group">
                <select name="depositStatusEQ" class="form-control">
                  <option value="">-- 充值单状态 --</option>
                  <c:forEach items="${depositStatuses}" var="depositStatus">
                    <option value="${depositStatus}">${depositStatus}</option>
                  </c:forEach>
                </select>
              </div>

              <div class="form-group">
                <select name="payTypeEQ" class="form-control">
                  <option value="">-- 支付类型 --</option>
                  <c:forEach items="${payTypes}" var="payType">
                    <option value="${payType}">${payType}</option>
                  </c:forEach>
                </select>
              </div>

              <div class="form-group">
                <label class="sr-only">支付时间起</label>
                <input class="Wdate form-control" type="text"
                       onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" name="paidTimeGTE" value="" placeholder="支付时间起"/>
              </div>

              <div class="form-group">
                <label class="sr-only">支付时间止</label>
                <input class="Wdate form-control" type="text"
                       onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" name="paidTimeLT" value="" placeholder="支付时间止"/>
              </div>

              <div class="form-group">
                <button class="btn blue filter-submit">
                  <i class="fa fa-search"></i> 查询
                </button>
              </div>

              <div class="form-group">
                <a class="btn yellow" onClick="depositExport()">
                  <i class="fa fa-file-excel-o"></i> 导出Excel
                </a>
              </div>
            </form>
          </div>
          <table class="table table-striped table-bordered table-hover" id="dataTable">
          </table>
        </div>
      </div>
      <!-- END ALERTS PORTLET-->
    </div>
  </div>
</div>
