<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>信用修复申请</title>
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

	<div class="row repair-apply">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						信用修复申请
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
										<a href="#tab1" data-toggle="tab" class="step">
											<span class="number"> 1 </span>
											<span class="desc">
												<i class="fa fa-check"></i>
												输入法人信息
											</span>
										</a>
									</li>
									<li>
										<a href="#tab2" data-toggle="tab" class="step">
											<span class="number"> 2 </span>
											<span class="desc">
												<i class="fa fa-check"></i>
												申请人信息
											</span>
										</a>
									</li>
									<li>
										<a href="#tab3" data-toggle="tab" class="step active">
											<span class="number"> 3 </span>
											<span class="desc">
												<i class="fa fa-check"></i>
												修复内容
											</span>
										</a>
									</li>
									<li>
										<a href="#tab4" data-toggle="tab" class="step">
											<span class="number"> 4 </span>
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
									<div class="tab-pane active" id="tab1">
										<div class="form-group">
											<label class="control-label col-md-3">查询企业信息：</label>
											<div class="col-md-6">
												<div class="input-icon input-icon-md right">
													<i id="searchBtn" class="fa fa-search"
														style="width: 50px; color: #428BCA; cursor: pointer;">&nbsp;搜索</i>
													<input class="form-control" id="searchInput" name="keyword"
														placeholder="请输入企业名称、工商注册号、组织机构代码或统一社会信用代码" style="padding-right: 63px;" />
												</div>
											</div>
										</div>
										<div id="qyxx" style="display: none;">
											<div class="form-group">
												<label class="control-label col-md-3">企业名称：</label>
												<div class="col-md-6">
													<input class="form-control" id="qymc" name="qymc" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3">工商注册号：</label>
												<div class="col-md-6">
													<input class="form-control" id="gszch" name="gszch" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3">组织机构代码：</label>
												<div class="col-md-6">
													<input class="form-control" id="zzjgdm" name="zzjgdm" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3">统一社会信用代码：</label>
												<div class="col-md-6">
													<input class="form-control" id="tyshxydm" name="tyshxydm" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3">
													<span class="required">*</span>
													营业执照：
												</label>
												<div class="col-md-2">
													<button type="button" class="btn btn-success upload-img" id="yyzz">上传图片</button>
												</div>
												<label class="control-label col-md-2">
													<span class="required">*</span>
													组织机构代码证：
												</label>
												<div class="col-md-4">
													<button type="button" class="btn btn-success upload-img" id="zzjgdmz">上传图片</button>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3"></label>
												<div class="col-md-6">
													<span style="color: #e02222;">
														1. 图片格式支持jpg,jpeg,gif,bmp,png，上传的附件文件不能超过10M！
														<br>
														2. 营业执照和组织机构代码证至少上传一个！
													</span>
												</div>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab2">
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												经办人姓名：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="jbrxm" name="jbrxm" />
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												经办人身份证号码：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="jbrsfzhm" name="jbrsfzhm" />
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												经办人联系电话：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<input class="form-control" id="jbrlxdh" name="jbrlxdh" />
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">企业授权书：</label>
											<div class="col-md-2">
												<button type="button" class="btn btn-success upload-img" id="qysqs">上传图片</button>
											</div>
											<label class="control-label col-md-2">
												<span class="required">*</span>
												身份证：
											</label>
											<div class="col-md-4">
												<button type="button" class="btn btn-success upload-img" id="sfz">上传图片</button>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"></label>
											<div class="col-md-6">
												<span style="color: #e02222;">图片格式支持jpg,jpeg,gif,bmp,png，上传的附件文件不能超过10M！</span>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab3">
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												修复主题：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<textarea class="form-control" id="xfzt" name="xfzt" rows="2"></textarea>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												修复内容：
											</label>
											<div class="col-md-6 nr-div"></div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												修复备注：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<textarea class="form-control" id="xfbz" name="xfbz" rows="5"></textarea>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">
												<span class="required">*</span>
												修复信息申请表：
											</label>
											<div class="col-md-2">
												<button type="button" class="btn btn-success upload-img" id="xfxxsqb">上传图片</button>
											</div>
											<label class="control-label col-md-2">证明材料：</label>
											<div class="col-md-4">
												<button type="button" class="btn btn-success upload-img" id="zmcl">上传图片</button>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"></label>
											<div class="col-md-6">
												<span style="color: #e02222;">图片格式支持jpg,jpeg,gif,bmp,png，上传的附件文件不能超过10M！</span>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab4">
										<div class="form-group">
											<label class="control-label col-md-3">企业名称：</label>
											<div class="col-md-6">
												<input class="form-control" id="qymcView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">工商注册号：</label>
											<div class="col-md-6">
												<input class="form-control" id="gszchView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">组织机构代码：</label>
											<div class="col-md-6">
												<input class="form-control" id="zzjgdmView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">统一社会信用代码：</label>
											<div class="col-md-6">
												<input class="form-control" id="tyshxydmView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 经办人姓名： </label>
											<div class="col-md-6">
												<input class="form-control" id="jbrxmView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 经办人身份证号码： </label>
											<div class="col-md-6">
												<input class="form-control" id="jbrsfzhmView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 经办人联系电话： </label>
											<div class="col-md-6">
												<input class="form-control" id="jbrlxdhView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 修复主题： </label>
											<div class="col-md-6">
												<textarea class="form-control" id="xfztView" readonly="readonly" rows="2"></textarea>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 修复内容： </label>
											<div class="col-md-6 nr-div"></div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 修复备注： </label>
											<div class="col-md-6">
												<textarea class="form-control" id="xfbzView" readonly="readonly" rows="5"></textarea>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">营业执照：</label>
											<div class="col-md-2" id="yyzzView"></div>
											<label class="control-label col-md-2">组织机构代码证：</label>
											<div class="col-md-4" id="zzjgdmzView"></div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">企业授权书：</label>
											<div class="col-md-2" id="qysqsView"></div>
											<label class="control-label col-md-2">身份证：</label>
											<div class="col-md-4" id="sfzView"></div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">修复信息申请表：</label>
											<div class="col-md-2" id="xfxxsqbView"></div>
											<label class="control-label col-md-2">证明材料：</label>
											<div class="col-md-4" id="zmclView"></div>
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
		src="${pageContext.request.contextPath}/app/js/hall/creditRepair/hall_repair_apply.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>