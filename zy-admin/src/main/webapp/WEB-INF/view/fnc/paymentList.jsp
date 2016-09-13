<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<script type="text/javascript" src="${ctx}/plugin/My97DatePicker/WdatePicker.js"></script>
<style>
  .imagescan {
    cursor: pointer;
    width : 80px; height: 80px;
  }
  .mr-10 {
    margin-left: 10px;
  }
  .text {
    width: 320px; height: 100px;
    overflow: hidden; 
    text-overflow:ellipsis; 
    white-space:nowrap;
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
$(function() {
  var grid = new Datatable();
  var template = Handlebars.compile($('#confirmTmpl').html());
  
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
        src : $('#dataTable'),
        onSuccess : function(grid) {
          // execute some code after table records loaded
        },
        onError : function(grid) {
          // execute some code on network or other general error  
        },
        dataTable : {
          //"sDom" : "<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'<'table-group-actions pull-right'>>r>t<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'>r>>", 
          lengthMenu: [
                         [10, 20, 50, 100, -1],
                         [10, 20, 50, 100, 'All'] // change per page values here
                         ],
          pageLength: 20, // default record count per page
          order: [], // set first column as a default sort by desc
        	  ajax: {
                  url: '${ctx}/payment', // ajax source
                },
				columns : [
						{
							data : 'sn',
							title : '支付单sn',
							orderable : false,
							width : '100px'
						},
						{
							data : 'title',
							title : '标题',
							orderable : false,
							width : '50px'
						},
						{
							data : 'createdTime',
							title : '创建时间',
							orderable : true,
							width : '50px'
						},
						{
							data : 'paidTime',
							title : '支付时间',
							orderable : true,
							width : '50px'
						},
						{
							data : 'payType',
							title : '支付方式',
							orderable : false,
							width : '50px'
						},
						{
							data : 'paymentStatus',
							title : '支付状态',
							orderable : false,
							width : '50px',
			                render : function(data, type, full) {
			                	if(data == '待支付'){
			                		return '<label class="label label-danger">待支付</label>';	
			                	}else if(data == '已支付'){
			                		return '<label class="label label-success">已支付</label>';	
			                	}else if(data == '已退款'){
			                		return '<label class="label label-primary">已退款</label>';
			                	}else if(data == '已取消'){
			                		return '<label class="label label-default">已取消</label>';
			                	}
			                  }
						},
						{
							data : 'amount1',
							title : '应付金额',
							orderable : false,
							width : '50px'
						}, 
						{
							data : 'offlineImage',
							title : '银行汇款截图',
							orderable : false,
							width : '50px',
							render : function(data, type, full) {
							  if(full.offlineImage){
							    return '<img class="imagescan mr-10" data-url="' + full.offlineImage + '" src="' + full.offlineImageThumbnail + '" >';
							  } else {
							    return '';
							  }
							  
          		            }
						},
						{
							data : 'offlineMemo',
							title : '银行汇款备注',
							orderable : false,
							width : '50px'
						}, 
						{
          		            data : '',
          		            title : '昵称',
          		            width : '100px',
          		            render : function(data, type, full) {
          		              if (full.user) {
          		                return '<img src="' + full.user.avatarThumbnail + '" width="30" height="30" style="border-radius: 40px !important; margin-right:5px"/>' + full.user.nickname + '<br/>手机：' + full.user.phone;
          		              } else {
          		                return '-';
          		              }
          		          }
          		        },
			              {
			                data : '',
			                title: '操作',
			                width: '10%',
			                orderable : false,
			                render : function(data, type, full) {
			                	var optionHtml = '';
			                	<shiro:hasPermission name="payment:confirmPaid">
			                	if(full.payType == '银行汇款' && full.paymentStatus == '待支付' && full.offlineImage){
			                		optionHtml += '<a class="btn btn-xs default yellow-stripe payment-confirm" href="javascript:;" data-id="' + full.id + '"><i class="fa fa-edit"></i> 确认已支付</a>';	
			                	}
			                	</shiro:hasPermission>
			                  return optionHtml;
			                }
			              } ]
          }
        });

        $('#dataTable').on('click', '.imagescan', function () {
          var url = $(this).attr('data-url');
          $.imagescan({
            url: url
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
          <i class="fa fa-list"></i><span>支付单管理 </span>
        </div>
        <div class="tools">
          <a class="collapse" href="javascript:;"> </a> <a class="reload" href="javascript:;"> </a>
        </div>
      </div>
      <div class="portlet-body clearfix">
        <div class="table-container">
          <div class="table-toolbar">
            <div class="btn-group">
              <%-- <button id="" class="btn green" data-href="${ctx}/order/create">
                新增 <i class="fa fa-plus"></i>
              </button> --%>
            </div>
            <!-- <div class="btn-group pull-right">
              <button class="btn dropdown-toggle" data-toggle="dropdown">
                工具 <i class="fa fa-angle-down"></i>
              </button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#"> 打印 </a></li>
                <li><a href="javascript:void(0)" onClick="" class="easyui-linkbutton" data-options="iconCls:'icon-xls',plain:true">导出支付单数据</a></li>
              </ul>
            </div> -->
          </div>

          <div class="row">
            <div class="col-md-3 table-actions">
              <span class="table-row-checked"></span>
            </div>
            <div class="col-md-9">
              <form class="filter-form pull-right" id="searchForm">
                <input id="_orderBy" name="orderBy" type="hidden" value=""/>
                <input id="_direction" name="direction" type="hidden" value=""/>
                <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/>
                <input id="_pageSize" name="pageSize" type="hidden" value="20"/>
                <div class="form-group input-inline">
                
              	  <label class="sr-only">支付状态</label>
                   <select name="paymentStatusEQ" class="form-control">
               		<option value="">--请选择支付状态-- </option>
           			<option value="待支付">待支付</option>
           			<option value="已支付">已支付</option>
           			<option value="已退款">已退款</option>
                    <option value="已取消">已取消</option>
                   </select>
                </div>
                <div class="form-group input-inline">
                  <button class="btn blue filter-submit">
                     <i class="fa fa-check"></i> 查询
                  </button>
                </div>
              </form>
            </div>
          </div>
          <table class="table table-striped table-bordered table-hover" id="dataTable">
          </table>
        </div>
      </div>
      <!-- END ALERTS PORTLET-->
    </div>
  </div>
</div>