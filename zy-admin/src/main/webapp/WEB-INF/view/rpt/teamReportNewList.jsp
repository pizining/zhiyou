<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
<!-- BEGIN JAVASCRIPTS -->
<script>
    var grid = new Datatable();

    $(function () {

        grid.init({
            src: $('#dataTable'),
            onSuccess: function (grid) {
            },
            onError: function (grid) {
            },
            dataTable: {
                lengthMenu: [
                    [10, 20, 50, 100],
                    [10, 20, 50, 100]
                ],

                order: [], // set first column as a default sort by desc
                ajax: {
                    url: '${ctx}/report/teamReportNew?queryDate=${queryDate}',
                },
                columns: [
                    {
                        data: 'userName',
                        title: '姓名',
                        orderable: false,
                    },
                    {
                        data: 'phone',
                        title: '手机号',
                        orderable: false,
                    },
                    {
                        data: 'districtName',
                        title: '所属大区',
                        orderable: false,
                    },
                    {
                        data: 'extraNumber',
                        title: '特级人数',
                        orderable: true,
                    },
                    {
                        data: 'newextraNumber',
                        title: '新晋特级人数',
                        orderable: true,
                    },
                    {
                        data: 'changNewextraNumber',
                        title: '新晋特级人数变化',
                        orderable: false,
                        render: function (data, type, full) {
                            if (data >0){
                                return '<span style="color: red;">↑</span>' + data;
                            }else if (data == 0){
                                return '—';
                            }else if (data<0){
                                return '<span style="color: blue">↓</span>'  +data;
                            }

                        }
                    },

                    {
                        data: 'newextraRate',
                        title: '新晋特级占比',
                        orderable: true,
                        render: function (data, type, full) {
                            var f = Math.round(data*100)/100;
                            var s = f.toString();
                            var rs = s.indexOf('.');
                            if (rs < 0) {
                                rs = s.length;
                                s += '.';
                            }
                            while (s.length <= rs + 2) {
                                s += '0';
                            }
                            return s +"%";
                        }
                    },
                    {
                        data: 'sleepextraNumber',
                        title: '沉睡特级人数',
                        orderable: true,
                    },
                    {
                        data: 'provinceNumber',
                        title: '省级人数',
                        orderable: true,
                    },
                    {
                        data: 'newprovinceNumber',
                        title: '新晋省级人数',
                        orderable: true,
                    },
                    {
                        data: 'newprovinceRate',
                        title: '新晋省级占比',
                        orderable: true,
                        render: function (data, type, full) {
                            var f = Math.round(data*100)/100;
                            var s = f.toString();
                            var rs = s.indexOf('.');
                            if (rs < 0) {
                                rs = s.length;
                                s += '.';
                            }
                            while (s.length <= rs + 2) {
                                s += '0';
                            }
                            return s +"%";
                        }
                    },
                    {
                        data: 'ranking',
                        title: '排名',
                        orderable: true,
                    },
                    {
                        data: 'changRanking',
                        title: '排名升降情况',
                        orderable: false,
                        render: function (data, type, full) {
                                if (data >0){
                                    return '<span style="color: red;">↑</span>' + data;
                                }else if (data == 0){
                                    return '—';
                                }else if (data<0){
                                    return '<span style="color: blue">↓</span>'  +data;
                                }

                        }
                    },
                    {
                        data: 'id',
                        title: '操作',
                        orderable: false,
                        render: function (data, type, full) {
                            var optionHtml = '';
                            <shiro:hasPermission name="tour:edit">
                            optionHtml += '<a class="btn btn-xs default green-stripe" href="javascript:;" data-href="${ctx}/report/teamReportNew/reportEdit?teamReportNewId=' + data + '"><i class="fa fa-search"></i> 查看详情 </a>';
                            </shiro:hasPermission>
                            return optionHtml;
                        }
                    }
                ]
            }
        });

    });
 function filtersubmit() {
     var year =  $('#yearEQ').val();
     var month =  $('#monthEQ').val();
     if ((year!=""||year!=null)||(month!=""||month!=null)){
         if (!((year!=""&&year!=null)&&(month!=""&&month!=null))){
             if(year==""||year==null){
                 layer.alert('请选择年份');
                 return false;
             }
             if(month==""||month==null){
                 layer.alert('请选择月份');
                 return false;
             }
         }else {
             $('#team').text("团队报表("+year+"/"+month+")");
         }
     }else{
         return false;
     }

 }
    <shiro:hasPermission name="teamReportNew:export">
    function reportExport(data) {
        location.href = '${ctx}/report/teamReportNew/export?' + $('#searchForm').serialize()+'&queryDate='+data;
    }
    </shiro:hasPermission>

</script>
<!-- END JAVASCRIPTS -->

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
    <ul class="page-breadcrumb">
        <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
        <li><a href="javascript:;" data-href="${ctx}/report/teamReportNew" id="team">团队报表</a></li>
    </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
    <div class="col-md-12">
        <div class="portlet light bordered">
        <div class="portlet-title">
            <div class="caption">
                <i class="icon-bar-chart"></i><span>团队报表(${queryDate})</span>
            </div>
            <div class="actions">
                <div class="btn-group">
                    <a href="" class="btn dark btn-outline btn-circle btn-sm dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true" aria-expanded="false">查询月份
                        <span class="fa fa-angle-down"> </span>
                    </a>
                    <ul class="dropdown-menu pull-right">
                        <c:forEach items="${queryDateLabels}" var="queryDateLabel">
                            <li>
                                <a data-href="${ctx}/report/teamReportNew?queryDate=${queryDateLabel}"> ${queryDateLabel}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
        <!-- BEGIN ALERTS PORTLET-->
        <div class="portlet light bordered">
            <div class="portlet-body clearfix">
                <div class="table-container">
                    <div class="table-toolbar">
                        <form class="filter-form form-inline" id="searchForm">
                            <input id="_orderBy" name="orderBy" type="hidden" value=""/>
                            <input id="_direction" name="direction" type="hidden" value=""/>
                            <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/>
                            <input id="_pageSize" name="pageSize" type="hidden" value="20"/>


                            <div class="form-group">
                                <select name="districtIdEQ" class="form-control">
                                    <option value="">-- 选择大区--</option>
                                    <c:forEach items="${type}" var="code" >
                                      <option value="${code.systemValue}"> ${code.systemName} </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <select name="isBossEQ" class="form-control">
                                    <option value="">-- 是否是大区总裁--</option>
                                        <option value="0"> 否 </option>
                                        <option value="1"> 是 </option>
                                </select>
                            </div>
                            <div class="form-group">
                                <input type="text" name="userNameLK" class="form-control" placeholder="姓名"/>
                            </div>
                            <div class="form-group">
                                <input type="text" name="phoneEQ" class="form-control" placeholder="手机号"/>
                            </div>

                            <div class="form-group input-inline">
                                <button class="btn blue filter-submit">
                                    <i class="fa fa-search"></i> 查询
                                </button>
                            </div>
                            <shiro:hasPermission name="teamReportNew:export">
                                <div class="form-group">
                                    <button type="button" class="btn yellow" onClick="reportExport('${queryDate}')">
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
</div>
