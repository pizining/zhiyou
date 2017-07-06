<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>

<!-- BEGIN JAVASCRIPTS -->
</script>
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
                //"sDom" : "<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'<'table-group-actions pull-right'>>r>t<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'>r>>",
                lengthMenu : [ [ 10, 20, 50, 100 ], [ 10, 20, 50, 100 ] ],// change per page values here
                pageLength: 20, // default record count per page
                order: [
                ], // set first column as a default sort by desc
                ajax: {
                    url: '${ctx}/tourJoinUser', // ajax source
                },
                columns: [
                    {
                        data: 'imageThumbnail',
                        title: '票务照片',
                        orderable: false,
                        render: function (data, type, full) {
                            return '<a target="_blank" href="' + data + '"><img style="width:160px;height:80px;"  src="' +data+ '"/></a>';
                        }
                    },
                    {
                        data: 'sequenceId',
                        title: '旅行申请单号',
                        orderable: false
                    },
                    {
                        data: 'reportId',
                        title: '检测报告编号',
                        orderable: false
                    },
                    {
                        data: 'userName',
                        title: '用户',
                        orderable: false,
                    },
                    {
                        data: 'userPhone',
                        title: '用户电话',
                        orderable: false,
                    },
                    {
                        data: 'tourTitle',
                        title: '线路',
                        orderable: false
                    },
                    {
                        data: 'tourTime',
                        title: '出游时间',
                        orderable: false
                    },
                    {
                        data: 'parentName',
                        title: '推荐人',
                        orderable: false
                    },
                    {
                        data: 'parentPhone',
                        title: '推荐人电话',
                        orderable: false
                    },
                    {
                        data: 'auditStatus',
                        title: '审核状态',
                        orderable: false,
                        render: function (data, type, full) {
                            if(data == 1){
                                return '<label class="label label-danger">审核中</label>';
                            }else if(data == 2){
                                return '<label class="label label-warning">待补充</label>';
                            }else if(data == 3){
                                return '<label class="label label-info">已生效</label>';
                            }else if(data == 4){
                                return '<label class="label label-success">已完成</label>';
                            }else if(data == 5){
                                return '<label class="label label-default">审核失败</label>';
                            }
                        }
                    },
                    {
                        data: 'updateDateLabel',
                        title: '状态时间',
                        orderable: false
                    },
                    {
                        data: 'houseType',
                        title: '房型需求',
                        orderable: false,
                        render: function (data, type, full) {
                            if(data == 1){
                                return '标准间';
                            }else if(data == 2){
                                return '三人间';
                            }
                        }
                    },
                    {
                        data: 'isAddBed',
                        title: '是否加床',
                        orderable: false,
                        render: function (data, type, full) {
                            if(data == 0){
                                return '否';
                            }else if(data == 1){
                                return '是';
                            }
                        }
                    },
                    {
                        data: 'isTransfers',
                        title: '是否接车',
                        orderable: false,
                        render: function (data, type, full) {
                            if(data == 0){
                                return '否';
                            }else if(data == 1){
                                return '是';
                            }
                        }
                    },
                    {
                        data: 'carNumber',
                        title: '班号',
                        orderable: false
                    },
                    {
                        data: 'planTimeLabel',
                        title: '预计到达时间',
                        orderable: false
                    },
                    {
                        data: 'userRemark',
                        title: '用户备注',
                        orderable: false
                    },
                    {
                        data: 'updateName',
                        title: '审核员',
                        orderable: false
                    },
                    {
                        data: 'revieweRemark',
                        title: '审核备注',
                        orderable: false
                    },
                    {
                        data: 'isJoin',
                        title: '是否参游',
                        orderable: false,
                        render: function (data, type, full) {
                            if(data == 0){
                            return '否';
                        }else if(data == 1){
                            return '是';
                            }
                        }
                    },
                    {
                        data: 'amount',
                        title: '消费金额(元)',
                        orderable: false
                    },
                    {
                        data: 'isEffect',
                        title: '是否有效',
                        orderable: false,
                        render: function (data, type, full) {
                            if(data == 0){
                                return '否';
                            }else if(data == 1){
                                return '是';
                            }
                        }
                    },
                    {
                        data: 'id',
                        title: '操作',
                        orderable: false,
                        render: function (data, type, full) {
                            var optionHtml = '';
                            optionHtml += '<a class="btn btn-xs default blue-stripe user-detail" onclick="userDetail(this)" href="javascript:;" data-id="' + full.userId + '"><i class="fa fa-search"></i> 查看</a>';
                            return optionHtml;
                        }
                    }]
            }
        });

    });
    <shiro:hasPermission name="tourJoinUser:edit">

    <shiro:hasPermission name="tourJoinUser:export">
    function tourUserExport() {
        location.href = '${ctx}/tourJoinUser/tourJoinUserExport?' + $('#searchForm').serialize();
    }
    </shiro:hasPermission>

    </shiro:hasPermission>
</script>
<!-- END JAVASCRIPTS -->
<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
    <ul class="page-breadcrumb">
        <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
        <li><a href="javascript:;" data-href="${ctx}/touJoinrUser">参游旅客信息管理</a></li>
    </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
    <div class="col-md-12">
        <!-- BEGIN ALERTS PORTLET-->
        <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                    <i class="icon-book-open"></i> 参游旅客信息管理
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
                                <input type="text" name="sequenceId" class="form-control" placeholder="旅行申请单号"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="tourTitle" class="form-control" placeholder="旅行线路"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="userName" class="form-control" placeholder="用户名"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="userPhone" class="form-control" placeholder="用户电话"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="parentName" class="form-control" placeholder="推荐人"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="parentPhone" class="form-control" placeholder="推荐人电话"/>
                            </div>
                            <div class="form-group input-inline">
                                <input class="Wdate form-control" type="text" id="beginTime" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                                       name="beginTime" value="" placeholder="出游开始时间"/>
                            </div>
                            <div class="form-group input-inline">
                                <input class="Wdate form-control" type="text" id="endTime" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                                       name="endTime" value="" placeholder="出游结束时间"/>
                            </div>
                            <div class="form-group">
                                <select name="auditStatus" class="form-control">
                                    <option value="">-- 审核状态 --</option>
                                    <option value="1">审核中</option>
                                    <option value="2">待补充</option>
                                    <option value="3">已生效</option>
                                    <option value="4">已完成</option>
                                    <option value="5">审核失败</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <select name="isEffect" class="form-control">
                                    <option value="">-- 是否有效 --</option>
                                    <option value="1">是</option>
                                    <option value="0">否</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <button class="btn blue filter-submit">
                                    <i class="fa fa-search"></i> 查询
                                </button>
                            </div>
                            <shiro:hasPermission name="tourUser:export">
                                <div class="form-group">
                                    <button type="button" class="btn yellow" onClick="tourUserExport()">
                                        <i class="fa fa-file-excel-o"></i> 导出Excel
                                    </button>
                                </div>
                            </shiro:hasPermission>
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
