<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/view/include/head.jsp"%>
<%@ include file="/WEB-INF/view/include/form.jsp"%>
<!-- BEGIN JAVASCRIPTS -->

 <script>
	$(function() {

		$('#createForm').validate({
			rules : {
				phone : {
					required : true
				},
				targetCount : {
					required : true
				}
			},
			messages : {
				'phone': {
				  required: '请输入手机号',
				  number : '只能输入数字'
				},
				'targetCount': {
					required: '请输入目标销量',
					number : '只能输入数字'
				},
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
		<!-- BEGIN VALIDATION STATES-->
		<div class="portlet light bordered">
			<div class="portlet-title">
				<div class="caption">
					<i class="icon-speech"></i><span> 新增用户目标销量</span>
				</div>
				<div class="tools">
					<a href="javascript:;" class="collapse"> </a> <a href="javascript:;" class="reload"> </a>
				</div>
			</div>
			<div class="portlet-body form">
				<!-- BEGIN FORM-->
				<form id="createForm" action="" data-action="${ctx}/userTargetSales/create" class="form-horizontal" method="post">
					<div class="form-body">
						<div class="alert alert-danger display-hide">
							<i class="fa fa-exclamation-circle"></i>
							<button class="close" data-close="alert"></button>
							<span class="form-errors">您填写的信息有误，请检查。</span>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3">用户手机号<span class="required"> * </span></label>
							<div class="col-md-5">
								<input type="number" class="form-control" name="phone" id="phone" value="${userTargetSales.user.phone}" placeholder="请输入设置目标销量用户的手机号"/>
							</div>
						</div>
						
						<div class="form-group">
							<label class="control-label col-md-3">目标销量<span class="required"> * </span>
							</label>
							<div class="col-md-5">
								<input type="number" class="form-control" name="targetCount" id="targetCount" value="${userTargetSales.targetCount}" placeholder="请输入目标销量" />
							</div>
						</div>
					</div>
					
                    <div class="form-actions fluid">
                      <div class="col-md-offset-3 col-md-9">
                        <button type="submit" class="btn green">
                          <i class="fa fa-save"></i> 保存
                        </button>
                        <button class="btn default" data-href="${ctx}/userTargetSales">
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
