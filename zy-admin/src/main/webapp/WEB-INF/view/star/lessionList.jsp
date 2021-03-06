<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
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
                lengthMenu: [[10, 20, 50, 100], [10, 20, 50, 100]],// change per page values here
                pageLength: 20, // default record count per page
                order: [], // set first column as a default sort by desc
                ajax: {
                    url: '${ctx}/lesson', // ajax source
                },
                columns: [
                    {
                        data: 'title',
                        title: '课程名称',
                        orderable: false
                    },
                    /*{
                        data: '',
                        title: '是否使用',
                        orderable: false,
                        render: function (data, type, full) {
                            return data?'<i class="fa fa-check"></i> 已使用':'';
                        }
                    },*/
                    {
                        data: 'createLable',
                        title: '创建人',
                        orderable: false
                    },
                    {
                        data: 'lessonAllnameLable',
                        title: '前期课程',
                        width:'40%',
                        orderable: false
                    },
                    {
                        data: 'createDate',
                        title: '创建时间',
                        orderable: true,
                        render: function (data, type, full) {
                            return full.createDateLable;
                        }
                    },
                    {
                   data: 'id',
                    title: '操作',
                    orderable: false,
                    render: function (data, type, full) {
                    var optionHtml = '';
                    <shiro:hasPermission name="lesson:edit">
                     optionHtml += '<a class="btn btn-xs default blue-stripe user-info-update" href="javascript:;"  onclick="updateAjax(' + full.id +')"><i class="fa fa-edit"></i> 编辑 </a>';
                     optionHtml += '<a class="btn btn-xs default green-stripe" href="javascript:;" onclick="deleteAjax(' + full.id +')"><i class="fa fa-trash-o"></i> 删除 </a>';
                    </shiro:hasPermission>
                    return optionHtml;
            }
        }
                ]
            }
        });

    });
    <shiro:hasPermission name="lesson:edit">
    function policyCodeExport() {
        location.href = '${ctx}/policyCode/export?' + $('#searchForm').serialize();
    }
    </shiro:hasPermission>
var addLesson;
function  addlesson() {
    $.ajax({
        url: '${ctx}/lesson/tocreate',
        dataType: 'html',
        success: function(data) {
            addLesson= layer.open({
                type: 1,
                skin: 'layui-layer-rim', //加上边框
                area: ['760px', '440px'], //宽高
                content: data
            });
        }
    })
}

function  closeaddLesson() {
    layer.close(addLesson);
}
    /**
     * 删除 数据
     */
<shiro:hasPermission name="lesson:edit">
function deleteAjax(id) {
        layer.confirm('删除课程会影响课程结构', {
            btn: ['确认删除','取消'] //按钮
        }, function(){
            $.post('${ctx}/lesson/delete', {lessonId: id}, function (result) {
              grid.getDataTable().ajax.reload(null, false);
            });
           layer.msg('删除成功！');
        }, function(){
        });
  }

    var updateLesson;
   function updateAjax(id) {
       $.ajax({
           url: '${ctx}/lesson/update?lessonId='+id,
           dataType: 'html',
           success: function(data) {
               updateLesson= layer.open({
                   type: 1,
                   skin: 'layui-layer-rim', //加上边框
                   area: ['760px', '440px'], //宽高
                   content: data
               });
           }
       });
   }
    function closeupdateLesson() {
        layer.close(updateLesson);
    }
    </shiro:hasPermission>

</script>
<!-- END JAVASCRIPTS -->


<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
    <ul class="page-breadcrumb">
        <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
        <li><a href="javascript:;" data-href="${ctx}/lesson">课程管理</a></li>
    </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
    <div class="col-md-12">
        <!-- BEGIN ALERTS PORTLET-->
        <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                    <i class="icon-wallet"></i> 课程管理
                </div>
                <shiro:hasPermission name="lesson:edit">
                    <div class="actions">
                        <a class="btn btn-circle green"  href="javascript:;" onclick="addlesson()">
                            <i class="fa fa-plus"></i> 新增
                        </a>
                    </div>
                </shiro:hasPermission>
            </div>
            <div class="portlet-body clearfix">
                <div class="table-container">
                    <div class="table-toolbar">
                        <form id="searchForm" class="filter-form form-inline">
                            <input id="_orderBy" name="orderBy" type="hidden" value=""/> <input id="_direction" name="direction" type="hidden" value=""/>
                            <input id="_pageNumber" name="pageNumber" type="hidden" value="0"/> <input id="_pageSize" name="pageSize" type="hidden" value="20"/>

                            <div class="form-group">
                                <input type="text" name="titleLK" class="form-control" placeholder="课程名称"/>
                            </div>

                            <div class="form-group">
                                <input class="Wdate form-control" type="text" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                                       name="createDateGTE" value="" placeholder="创建时间"/>
                            </div>


                            <div class="form-group">
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
        </div>
        <!-- END ALERTS PORTLET-->
    </div>
</div>