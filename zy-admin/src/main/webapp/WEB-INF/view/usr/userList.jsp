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
        //"sDom" : "<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'<'table-group-actions pull-right'>>r>t<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'>r>>",
        order: [], // set first column as a default sort by desc
        ajax: {
          url: '${ctx}/user', // ajax source
        },
        columns: [
          {
            data: 'nickname',
            title: '昵称',
            render: function (data, type, full) {
              return '<p><img src="' + full.avatarThumbnail + '" width="30" height="30" style="border-radius: 40px !important; margin-right:5px"/>' + full.nickname + '</p>';
            }
          },
          {
            data: 'phone',
            title: '手机'
          },
          {
            data: 'userRankLabel',
            title: '用户等级',
            orderable: false
          },
          {
            data: 'userType',
            title: '用户类型'
          },
          {
            data: 'registerTime',
            title: '注册时间',
            orderable: false
          },
          {
            data: '',
            title: '直属上级',
            orderable: false,
            render: function (data, type, full) {
              return formatUser(full.parent);
            }
          },
          {
            data: 'isFrozen',
            title: '是否冻结',
            orderable: false,
            render: function (data, type, full) {
              if (full.isFrozen) {
                return '<label class="badge badge-danger">已冻结</label>';
              } else {
                return '';
              }
            }
          },
          {
            data: 'id',
            title: '操作',
            orderable: false,
            render: function (data, type, full) {
              var optionHtml = '';
              if (full.userType != '平台') {
                <shiro:hasPermission name="user:edit">
                optionHtml += '<a class="btn btn-xs default yellow-stripe" href="javascript:;" data-href="${ctx}/user/update/' + data + '"><i class="fa fa-edit"></i> 编辑 </a>';
                </shiro:hasPermission>
                <shiro:hasPermission name="user:modifyParent">
                if(full.parent != null) {
                  optionHtml += '<a class="btn btn-xs default green-stripe" href="javascript:;" data-href="${ctx}/user/modifyParent?id=' + data + '"><i class="fa fa-edit"></i> 修改上级 </a>';
                }
                </shiro:hasPermission>
                <shiro:hasPermission name="user:addVip">
                optionHtml += '<a class="btn btn-xs default yellow-stripe" href="javascript:;" onclick="addVip(' + full.id + ')"><i class="fa fa-user"></i> 加VIP </a>';
                </shiro:hasPermission>
                <shiro:hasPermission name="user:freeze">
                if (full.isFrozen) {
                  optionHtml += '<a class="btn btn-xs default yellow-stripe" href="javascript:;" data-href="${ctx}/user/unFreeze/' + data + '" data-confirm="您确定要解冻用户[' + full.nickname + ']？"><i class="fa fa-smile-o"></i> 解冻 </a>';
                } else {
                  optionHtml += '<a class="btn btn-xs default yellow-stripe" href="javascript:;" data-href="${ctx}/user/freeze/' + data + '" data-confirm="您确定要冻结用户[' + full.nickname + ']？"><i class="fa fa-meh-o"></i> 冻结 </a>';
                }
                </shiro:hasPermission>
              }
              return optionHtml;
            }
          }]
      }
    });

  });

  var $addVipDialog;
  function addVip(id) {
    $addVipDialog = $.window({
      content: "<form action='' class='form-horizontal' style='margin-top: 20px;'>" + "<div class='form-body'>" + "<div class='form-group'>"
      + "<label class='control-label col-md-3'>加VIP等级:</label>" + "<div class='col-md-5'>"
      + "<select class='form-control' id='userRank'><option value=''>-- 用户等级 --</option><option value='V1'>三级服务商</option><option value='V2'>二级服务商</option><option value='V3'>一级服务商</option><option value='V4'>特级服务商</option></select></div></div>"
      + "<div class='form-group'>" + "<label class='control-label col-md-3'>备注信息:</label>"
      + "<div class='col-md-5'><textarea class='form-control' style='width: 220px;height: 120px;' id='remark'></textarea></div>" + "</div>" + "</div>"
      + "<div class='form-actions fluid'>" + "<div class='col-md-offset-3 col-md-9'>" + "<button type='button' class='btn green' onclick='submitBtn(" + id + ")'>"
      + "保存</button>" + "<button type='button' class='btn default' onclick='closeBtn()' style='margin-left: 20px;'>" + "取消</button>" + "</div>" + "</div>" + "</form>",
      title: '加VIP',
      width: 420,
      height: 320,
      button: false
    });
  }
  function submitBtn(id) {
    var remark = $('#remark').val();
    var userRank = $('#userRank').find("option:selected").val();
    if (remark == '' || remark == null) {
      alert('请输入备注信息');
      return;
    }
    $.post('${ctx}/user/addVip', {
      id: id,
      userRank: userRank,
      remark: remark
    }, function (result) {
      toastr.success(result.message, '提示信息');
      $addVipDialog.close();
      grid.getDataTable().ajax.reload(null, false);
    })

  }
  function closeBtn() {
    $addVipDialog.close();
  }
</script>
<script type="text/javascript">
  function exportUsers() {
    location.href = '${ctx}/user/export?' + $('#searchForm').serialize();
  }
</script>
<!-- END JAVASCRIPTS -->

<!-- BEGIN PAGE HEADER-->
<div class="page-bar">
  <ul class="page-breadcrumb">
    <li><i class="fa fa-home"></i> <a href="javascript:;" data-href="${ctx}/main">首页</a> <i class="fa fa-angle-right"></i></li>
    <li><a href="javascript:;" data-href="${ctx}/user">用户管理</a></li>
  </ul>
</div>
<!-- END PAGE HEADER-->

<div class="row">
  <div class="col-md-12">
    <!-- BEGIN ALERTS PORTLET-->
    <div class="portlet light bordered">
      <div class="portlet-title">
        <div class="caption">
          <i class="icon-user"></i><span>用户管理 </span>
        </div>
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
                <input class="Wdate form-control" type="text" id="beginDate"
                       onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" name="registerTimeGTE" value="" placeholder="注册时间起"/>
              </div>
              <div class="form-group input-inline">
                <input class="Wdate form-control" type="text" id="endDate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})"
                       name="registerTimeLT" value="" placeholder="注册时间止"/>
              </div>
              <div class="form-group">
                <input type="text" name="inviterNicknameLK" class="form-control" placeholder="邀请人昵称"/>
              </div>
              
              <div class="form-group">
                <select name="userRankEQ" class="form-control">
                  <option value="">-- 是否冻结 --</option>
                  <option value="1">是</option>
                  <option value="0">否</option>
                </select>
              </div>
              
              <div class="form-group">
                <select name="userRankEQ" class="form-control">
                  <option value="">-- 用户等级 --</option>
                  <c:forEach items="${userRankMap}" var="userRankMap">
                  <option value="${userRankMap.key}">${userRankMap.value}</option>
                  </c:forEach>
                </select>
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
