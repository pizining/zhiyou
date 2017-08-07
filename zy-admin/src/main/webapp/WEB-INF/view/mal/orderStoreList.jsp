<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
<!-- BEGIN JAVASCRIPTS -->
<script>

  $(function () {

    var grid = new Datatable();

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
        lengthMenu: [[10, 20, 50, 100], [10, 20, 50, 100]],// change per page values here
        pageLength: 20, // default record count per page
        order: [], // set first column as a default sort by desc
        ajax: {
          url: '${ctx}/orderStore', // ajax source
        },
        columns: [
//          {
//            data: 'orderId',
//            title: '订单编号',
//            orderable: false
//          },
          {
            data: 'userName',
            title: '用户名',
            orderable: false
          },
          {
            data: 'phone',
            title: '手机号',
            orderable: false
          },
//          {
//            data: 'type',
//            title: '出入库类型',
//            orderable: false,
//            render: function (data, type, full) {
//              if(data == 1){
//                return '出库';
//              }else if(data == 2){
//                return '入库';
//              }
//            }
//          },
//          {
//            data: 'number',
//            title: '订单数量',
//            orderable: false
//          },
//          {
//            data: 'beforeNumber',
//            title: '下单前数量',
//            orderable: false
//          },
          {
            data: 'afterNumber',
            title: '当前数量',
            orderable: false
          },
//          {
//            data: 'createDate',
//            title: '创建时间',
//            orderable: false
//          },
          {
            data: 'id',
            title: '操作',
            orderable: false,
            render: function (data, type, full) {
              var optionHtml = '<a class="btn btn-xs default green-stripe" href="javascript:;" data-href="${ctx}/orderStore/detailList?userId=' + full.userId + '"><i class="fa fa-search"></i> 查看 </a>';
              return optionHtml;
            }
          }]
      }
    });

  });
</script>

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
  <ul class="page-breadcrumb">
    <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
    <li><a href="javascript:;" data-href="${ctx}/orderStore">U库管理</a></li>
  </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
  <div class="col-md-12">
    <!-- BEGIN ALERTS PORTLET-->
    <div class="portlet light bordered">
      <div class="portlet-title">
        <div class="caption">
          <i class="icon-docs"></i><span>U库管理 </span>
        </div>
        <div class="tools"></div>
      </div>
      <div class="portlet-body clearfix">
        <div class="table-container">
          <div class="table-toolbar">
            <form class="filter-form form-inline" id="searchForm">

              <input id="_orderBy" name="orderBy" type="hidden" value=""/> <input id="_direction" name="direction" type="hidden" value=""/>
              <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/>
              <input id="_pageSize" name="pageSize" type="hidden" value="20"/>
              <input type="hidden" name="orderStatusEQ" value=""/>
              <input type="hidden" name="isPlatformDeliver" value="true"/>


              <div class="form-group">
                <input type="text" name="phone" class="form-control" placeholder="用户手机号"/>
              </div>

              <div class="form-group input-inline">
                <input type="text" name="realName" class="form-control" placeholder="用户名"/>
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