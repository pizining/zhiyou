<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>

<!-- BEGIN JAVASCRIPTS -->
<script>
    var grid = new Datatable();

    $(function () {
        grid.init({
            src: $('#dataTable'),
            onSuccess: function (grid) {
                // execute some code after table records loaded
            },
            onError: function (grid) {
                // execute some code on network or other general error
            },
            dataTable: {
                //"sDom": "<'table-responsive't><'row'>",
                 lengthMenu : [ [ 10, 20, 50, 100 ], [ 10, 20, 50, 100 ] ],// change per page values here
                pageLength: 20, // default record count per page
                order: [], // set first column as a default sort by desc
                ajax: {
                    url: '${ctx}/userTargetSales', // ajax source
                },
                columns: [
                    {
                        data: '',
                        title: '用户信息',
                        render: function (data, type, full) {
                            return '<p><img src="' + full.user.avatarThumbnail + '" width="30" height="30" style="border-radius: 40px !important; margin-right:5px"/>' + full.user.nickname + '</p>'
                                    + '<p>手机：' + full.user.phone + '</p><p>用户等级：' + full.user.userRankLabel + '</p>';
                        }
                    },
                    {
                        data: '',
                        title: '所属大区',
                        orderable: false,
                        render: function (data, type, full) {
                            return full.user.largeareaLabel;
                        }

                    },
                    {
                        data: 'targetCount',
                        title: '目标销量',
                        orderable: false
                    },
                    {
                        data: 'year',
                        title: '年份'
                    },
                    {
                        data: 'month',
                        title: '月份'
                    },
                    {
                        data: 'createTime',
                        title: '创建时间'
                    },
                    {
                        data: 'id',
                        title: '操作',
                        orderable: false,
                        render: function (data, type, full) {
                            <shiro:hasPermission name="userTargetSales:edit">
                            var optionHtml = '<a class="btn btn-xs default yellow-stripe" href="javascript:;" data-href="${ctx}/userTargetSales/update/' + data + '"><i class="fa fa-edit"></i> 编辑 </a>';
                            optionHtml += '<a class="btn btn-xs default red-stripe" href="javascript:;" data-href="${ctx}/userTargetSales/delete/' + data + '" data-confirm="您确定要删除选中数据吗?"><i class="fa fa-trash-o"></i> 删除 </a>';
                            </shiro:hasPermission>
                            return optionHtml;
                        }
                    }]
            }
        });

    });
</script>
<!-- END JAVASCRIPTS -->

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
    <ul class="page-breadcrumb">
        <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
        <li><a href="javascript:;" data-href="${ctx}/userTargetSales">用户目标销量管理</a></li>
    </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
    <div class="col-md-12">
        <!-- BEGIN ALERTS PORTLET-->
        <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                    <i class="icon-speech"></i> 用户目标销量管理
                </div>
                <shiro:hasPermission name="userTargetSales:edit">
                <div class="actions">
                    <a class="btn btn-circle green" data-href="${ctx}/userTargetSales/create">
                        <i class="fa fa-plus"></i> 新增
                    </a>
                </div>
                </shiro:hasPermission>
            </div>
            <div class="portlet-body clearfix">
                <div class="table-container">
                    <div class="table-toolbar">
                        <form class="filter-form form-inline">
                            <input id="_orderBy" name="orderBy" type="hidden" value=""/>
                            <input id="_direction" name="direction" type="hidden" value=""/>
                            <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/>
                            <input id="_pageSize" name="pageSize" type="hidden" value="20"/>

                            <div class="form-group">
                                <input type="text" name="nicknameLK" class="form-control" placeholder="昵称"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="phoneEQ" class="form-control" placeholder="手机"/>
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