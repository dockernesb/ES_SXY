<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>异议申诉申请</title>
<style type="text/css">
#tab1 span.phTips {
	margin-left: 13px !important;
	margin-top: -35px;
}

#tab2 span.phTips {
	margin-left: 13px !important;
	margin-top: -40px;
}

#tab3 span.phTips {
	margin-left: 13px !important;
	margin-top: -40px;
}
</style>
</head>
<body>

	<div class="row objection-apply">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						异议申诉申请
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body form">
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<div class="form-wizard">
							<div class="form-body">
								<ul class="nav nav-pills nav-justified steps">
									<li>
										<a href="#tab2" data-toggle="tab" class="step">
											<span class="number"> 1 </span>
											<span class="desc">
												<i class="fa fa-check"></i>
												申请人信息
											</span>
										</a>
									</li>
									<li>
										<a href="#tab3" data-toggle="tab" class="step">
											<span class="number"> 2 </span>
											<span class="desc">
												<i class="fa fa-check"></i>
												异议内容
											</span>
										</a>
									</li>
									<li>
										<a href="#tab4" data-toggle="tab" class="step">
											<span class="number"> 3 </span>
											<span class="desc">
												<i class="fa fa-check"></i>
												信息审核
											</span>
										</a>
									</li>
								</ul>
								<div id="bar" class="progress progress-striped" role="progressbar">
									<div class="progress-bar progress-bar-success"></div>
								</div>
								<div class="tab-content">
									<div class="tab-pane active" id="tab2">
										<div class="form-group">
											<label class="control-label col-md-3">申请类型：</label>
											<div class="col-md-6">
												<div class="input-icon input-icon-md right">
													<select id="applyKind" name="complaintType" style="width: 200px;">
														<option value="0">文明交通异议申诉</option>
														<option value="1">其他</option>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												申诉人信息：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="searchStr" name="searchStr" placeholder="请输入申诉人姓名或驾驶证号"/>
												</div>
											</div>
											<div class="col-md-3">
												<button type="button" id="searchBtn" class="btn btn-success">搜索</button>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												申诉人姓名：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="name" name="name" readonly/>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												驾驶证号：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="jsz" name="jsz" readonly/>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												手机号码：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="sjhm" name="sjhm"/>
												</div>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab3">
										<div class="form-group" style="margin-bottom: 5px;">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												申诉内容：
											</label>
											<div class="col-md-6 nr-div">
												<button type="button" class="btn btn-success" >一般失信<span class="count1"></span></button>
												<button type="button" class="btn btn-success" >较重失信<span class="count2"></span></button>
												<button type="button" class="btn btn-success" >严重失信<span class="count3"></span></button>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												申诉备注：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<textarea class="form-control" id="ssbz" name="ssbz" rows="6"></textarea>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">证明材料：</label>
											<div class="col-md-6">
												<button type="button" class="btn btn-success upload-img" id="zmcl">上传图片</button>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"></label>
											<div class="col-md-6">
												<%--<span style="color: #e02222;">图片格式支持jpg,jpeg,gif,bmp,png，上传的附件文件不能超过10M！</span>--%>
												<span style="color: #e02222;">图片格式支持jpg,jpeg,gif,bmp,png,上传的附件文件不能超过2M，证明材料最多为3个！</span>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab4">
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												 办件编号：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="bjbhView" name="bjbh" readonly/>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">申请类型：</label>
											<div class="col-md-6">
												<div class="input-icon input-icon-md right">
													<select name="" id="applyKindView" style="width: 200px;" disabled>
														<option value="0">文明交通异议申诉</option>
														<option value="1">其他</option>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												申诉人姓名：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="nameView"  readonly/>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												驾驶证号：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="jszView"  readonly/>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												手机号码：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="sjhmView"  readonly/>
												</div>
											</div>
										</div>

										<div class="form-group" style="margin-bottom: 5px;">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												申诉内容：
											</label>
											<div class="col-md-6 nr-div">
												<button type="button" class="btn btn-success" >一般失信<span class="count1"></span></button>
												<button type="button" class="btn btn-success" >较重失信<span class="count2"></span></button>
												<button type="button" class="btn btn-success" >严重失信<span class="count3"></span></button>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												申诉备注：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<textarea class="form-control" id="ssbzView" rows="6" readonly></textarea>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">证明材料：</label>
											<div class="col-md-6" id="zmclView">

											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12 center">
										<a href="javascript:;" class="btn default button_reset">
											<i class="fa fa-rotate-left"></i>
											重置
										</a>
										<a href="javascript:;" class="btn default button-previous">
											<i class="m-icon-swapleft"></i>
											上一步
										</a>
										<a href="javascript:;" class="btn blue button-next">
											下一步
											<i class="m-icon-swapright m-icon-white"></i>
										</a>
										<a href="javascript:;" class="btn green button-submit">
											提交申请
											<i class="m-icon-swapright m-icon-white"></i>
										</a>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<div id="nrSelectDiv" style="display: none;">
		<div class="tabbable-custom">
			<ul class="nav nav-tabs" style="position: fixed; z-index: 60;"></ul>
			<div class="tab-content"
				style="position: absolute; z-index: 50; left: 0px; top: 43px; bottom: 0px; width: 100%; overflow: auto;">
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/objectionComplaint/objection_complaint_apply.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>