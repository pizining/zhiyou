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
        <button id="paymentConfirmSubmit{{id}}" type="button" class="btn green">
          <i class="fa fa-save"></i> 保存
        </button>
        <button id="paymentConfirmCancel{{id}}" class="btn default" data-href="">
          <i class="fa fa-chevron-left"></i> 返回
        </button>
      </div>
    </div>
  </form>
</script>
<script>

  function sum() {
    $.post("${ctx}/payment/sum", $('#searchForm').serialize(), function(result) {
      if(result.code == 0) {
        var data = result.data;
        $('#sumAmount').text(data + '元');
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

    $('#dataTable').on('click', '.order-view', function() {
      var id = $(this).data('id');
      $.ajax({
        url: '${ctx}/order/detail?id=' + id +　'&isPure=true',
        dataType: 'html',
        success: function(data) {
          layer.open({
            type: 1,
            skin: 'layui-layer-rim', //加上边框
            area: ['1080px', '720px'], //宽高
            content: data
          });
        }
      });


    });

    $('#dataTable').on('click', '.payment-confirm', function () {
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

      $('#paymentConfirmSubmit' + id).bind('click', function () {
        var result = $form.validate().form();
        if (result) {
          var url = '${ctx}/payment/confirmPaid';
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

      $('#paymentConfirmCancel' + id).bind('click', function () {
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
        lengthMenu: [[10, 20, 50, 100], [10, 20, 50, 100] // change per page values here
        ],
        pageLength: 20, // default record count per page
        order: [], // set first column as a default sort by desc
        ajax: {
          url: '${ctx}/payment', // ajax source
        },
        columns: [
         /* {
            data: 'id',
            title: 'id'
          },*/
          {
            data: 'sn',
            title: '支付单信息',
            orderable: false,
            render: function (data, type, full) {
              return '<p>支付单号:' + full.sn +'</p>'
                + '<p>标题:' + full.title +'</p>';
            }
          },
          {
            data: '',
            title: '用户信息',
            orderable: true,
            render: function (data, type, full) {
              return formatUser(full.user);
            }
          },
          {
            data: '',
            title: '应付金额',
            orderable: false,
	          render: function (data, type, full) {
            	var html = '<p>' + full.currencyType1 + ': ' + full.amount1Label + '</p>';
            	if(full.currencyType2 != null) {
            		html += '<p>' + full.currencyType2 + ': ' + full.amount2Label + '</p>';
              }
		          return html;
	          }
          },
          {
            data: 'payType',
            title: '支付方式',
            orderable: false
          },
          {
            data: 'createdTime',
            title: '创建时间',
            orderable: true
          },
          {
            data: 'paymentStatus',
            title: '支付单状态',
            orderable: false,
            render: function (data, type, full) {
              return '<label class="label label-' + full.paymentStatusStyle + '">' + data + '</label>';
            }
          },
          {
            data: '',
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
            data: 'paidTime',
            title: '支付时间',
            orderable: true
          },
          {
            data: 'remark',
            title: '备注',
            orderable: false
          },
          {
            data: '',
            title: '操作',
            orderable: false,
            render: function (data, type, full) {
              var optionHtml = '<a class="btn btn-xs default blue-stripe order-view" href="javascript:;" data-id="' + full.refId + '"><i class="fa icon-control-forward "></i> 查看订单</a>';
              <shiro:hasPermission name="payment:confirmPaid">
              if (full.payType == '银行汇款' && full.paymentStatus == '待确认' && full.offlineImages) {
                optionHtml += '<a class="btn btn-xs default yellow-stripe payment-confirm" href="javascript:;" data-id="' + full.id + '"><i class="fa fa-edit"></i> 确认已支付</a>';
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
</script>

<!-- END JAVASCRIPTS -->

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
  <ul class="page-breadcrumb">
    <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
    <li><a href="javascript:;" data-href="${ctx}/payment">支付单管理</a></li>
  </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
  <div class="col-md-12">
    <!-- BEGIN ALERTS PORTLET-->
    <div class="portlet light bordered">
      <div class="portlet-title">
        <div class="caption">
          <i class="icon-doc"></i><span>支付单管理 </span>
        </div>
      </div>
      <div class="row">
        <div class="col-md-4">
          <div class="note note-danger">
            <h4 class="block">支付总额</h4>
            <p id="sumAmount">0.00 元</p>
          </div>
        </div>
      </div>
      <div class="portlet-body clearfix">
        <div class="table-container">
          <div class="table-toolbar">
            <form class="filter-form form-inline" id="searchForm">
              <input id="_orderBy" name="orderBy" type="hidden" value=""/>
              <input id="_direction" name="direction" type="hidden" value=""/>
              <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/>
              <input id="_pageSize" name="pageSize" type="hidden" value="20"/>

              <div class="form-group">
                <input type="text" name="snEQ"class="form-control" placeholder="支付单号" />
              </div>

              <div class="form-group">
                <input type="text" name="titleEQ"class="form-control" placeholder="标题" />
              </div>
              
              <div class="form-group">
                <select name="paymentStatusEQ" id="paymentStatus" class="form-control">
                  <option value="">-- 支付单状态 --</option>
                  <c:forEach items="${paymentStatuses}" var="paymentStatus">
                    <option value="${paymentStatus}">${paymentStatus}</option>
                  </c:forEach>
                </select>
              </div>

              <div class="form-group">
                <select name="paymentTypeEQ" class="form-control">
                  <option value="">-- 支付单类型 --</option>
                  <c:forEach items="${paymentTypes}" var="paymentType">
                    <option value="${paymentType}">${paymentType}</option>
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
                <input class="Wdate form-control" type="text" id="beginDate"
                  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" name="paidTimeGTE" value="" placeholder="支付时间起" />
              </div>
              <div class="form-group">
                <input class="Wdate form-control" type="text" id="endDate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                  name="paidTimeLT" value="" placeholder="支付时间止" />
              </div>

              <div class="form-group input-inline">
                <button class="btn blue filter-submit">
                  <i class="fa fa-search"></i> 查询
                </button>
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