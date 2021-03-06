<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>自然人信用报告申请</title>
	<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/bootstrap/css/bootstrap-datepicker.css" />
<style type="text/css">
div.report-apply i.fa-search {
	cursor: pointer;
}

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

.form-control-d {
	font-size: 14px;
	font-weight: normal;
	color: #333;
	border: 1px solid #e5e5e5;
	box-shadow: none;
	transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	display: block;
	width: 100%;
	padding: 6px 12px;
	line-height: 1.42857143;
	background-image: none;
}

.form-control-d[readonly] {
	cursor: not-allowed;
	background-color: #eeeeee;
}
</style>
</head>
<body>
	<!-- 信用报告申请是否审核开关：0不需要审核，1需要审核 -->
	<input type="hidden" id="audit" value="${audit }">
	<div class="row report-apply">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i> 自然人信用报告申请
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>

				<form id="form1" runat="server">
					<OBJECT
							id="CVR_IDCard"
							TYPE="application/xhanhan-activex"
							BORDER="0"
							WIDTH="0"
							HEIGHT="0"
							clsid="{10946843-7507-44FE-ACE8-2B3483D179B7}">
					</OBJECT>
				</form>

				<div class="portlet-body form">
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<div class="form-wizard">
							<div class="form-body">
								<ul class="nav nav-pills nav-justified steps">
									<li>
										<a href="#tab1" data-toggle="tab" class="step">
											<span class="number"> 1 </span> <span class="desc"> <i class="fa fa-check"></i> 查询人信息
											</span>
										</a>
									</li>
									<li>
										<a href="#tab2" data-toggle="tab" class="step">
											<span class="number"> 2 </span> <span class="desc"> <i class="fa fa-check"></i> 委托人信息
											</span>
										</a>
									</li>
									<li>
										<a href="#tab3" data-toggle="tab" class="step active">
											<span class="number"> 3 </span> <span class="desc"> <i class="fa fa-check"></i> 报告用途
											</span>
										</a>
									</li>
									<li>
										<a href="#tab4" data-toggle="tab" class="step">
											<span class="number"> 4 </span> <span class="desc"> <i class="fa fa-check"></i> 信息确认
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
											<label class="control-label col-md-3"> </label>
											<div class="col-md-6">
												<div class="radio-list">
													<div class="input-icon right">
														<i class="fa"></i>
														<div class="input-group">
															<div class="icheck-inline">
																<label> <input type="radio" name="type" value="0" class="icheck"> 本人查询
																</label> <label> <input type="radio" name="type" value="1" class="icheck"> 委托查询
																</label>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">查询本人信息：</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa fa-search" title="查询本人信息" style="width: 50px; color: #428BCA;" id="fasearch">&nbsp;搜索</i>
													<input class="form-control" id="searchInput" name="sfzh" style="padding-right: 63px;" placeholder="请输入查询人身份证号，按回车键搜索" />
												</div>
											</div>
											<div class="col-md-1">
												<div class="input-icon left">
													<button type="button" class="btn blue btn-md form-search" id= "dsfz">
														<i class="fa"></i> 读身份证
													</button>
												</div>
											</div>
										</div>
										<div id="brxx" class="hide">
											<div class="form-group">
												<label class="control-label col-md-3"><span class="required">*</span> 姓名：</label>
												<div class="col-md-6">
													<input class="form-control" id="cxrxm" name="cxrxm" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3"><span class="required">*</span> 身份证号：</label>
												<div class="col-md-6">
													<input class="form-control" id="cxrsfzh" name="cxrsfzh" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3"><span class="required">*</span> 身份证：</label>
												<div class="col-md-4">
													<button type="button" class="btn btn-success upload-img" id="cxrsfz">上传图片</button>
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3"></label>
												<div class="col-md-6">
													<span style="color: #e02222;">1. 图片格式支持jpg,jpeg,gif,bmp,png，上传的附件文件不能超过10M！<br>2. 身份证请上传正反面！
													</span>
												</div>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab2">
										<div id="sqdiv">
											<div class="form-group">
												<label class="control-label col-md-3">查询委托人信息：</label>
												<div class="col-md-6">
													<div class="input-icon right">
														<i class="fa fa-search" title="查询委托人信息" style="width: 50px; color: #428BCA;" id="wtfasearch">&nbsp;搜索</i>
														<input class="form-control" id="wtsearchInput" name="sfzh" style="padding-right: 55px;" placeholder="请输入委托人身份证号，按回车键搜索" />
													</div>
												</div>
												<div class="col-md-1">
													<div class="input-icon left">
														<button type="button" class="btn blue btn-md form-search" id= "dwtrsfz">
															<i class="fa"></i> 读身份证
														</button>
													</div>
												</div>
											</div>
											<div id="wtrxx" class="hide">
												<div class="form-group">
													<label class="control-label col-md-3"><span class="required">*</span> 委托人姓名：</label>
													<div class="col-md-6">
														<input class="form-control" id="wtrxm" name="wtrxm" />
													</div>
												</div>
												<div class="form-group">
													<label class="control-label col-md-3"><span class="required">*</span> 委托人身份证号：</label>
													<div class="col-md-6">
														<input class="form-control" id="wtrsfzh" name="wtrsfzh" readonly="readonly" />
													</div>
												</div>
												<div class="form-group">
													<label class="control-label col-md-3"><span class="required">*</span> 委托人联系电话：</label>
													<div class="col-md-6">
														<div class="input-icon right">
															<i class="fa"></i>
															<input class="form-control" id="wtrlxdh" name="wtrlxdh" readonly="readonly" />
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="control-label col-md-3"><span class="required">*</span> 委托人身份证：</label>
													<div class="col-md-2">
														<button type="button" class="btn btn-success upload-img" id="wtrsfz">上传图片</button>
													</div>
													<label class="control-label col-md-2"><span class="required">*</span> 委托授权书：</label>
													<div class="col-md-2">
														<button type="button" class="btn btn-success upload-img" id="wtsqs">上传图片</button>
													</div>
												</div>
												<div class="form-group">
													<label class="control-label col-md-3"></label>
													<div class="col-md-6">
														<span style="color: #e02222;">1. 图片格式支持jpg,jpeg,gif,bmp,png，上传的附件文件不能超过10M！<br>2. 身份证请上传正反面！
														</span>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab3">
										<div class="form-group">
											<label class="control-label col-md-3"> <span class="required">*</span> 申请报告用途：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i> <select class="form-control" name="purpose" id="purpose" style="width: 100%">
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> <span class="required">*</span> 报告起止时间：
											</label>
											<div class="col-md-3">
												<input id="sqbgqssj" name="sqbgqssj" class="form-control input-md date-icon" placeholder="起始时间" readonly="readonly">
											</div>
											<div class="col-md-3">
												<input id="sqbgjzsj" name="sqbgjzsj" class="form-control input-md date-icon" placeholder="截止时间" readonly="readonly">
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 备注：
											</label>
											<div class="col-md-6">
												<div class="input-icon right">
													<i class="fa"></i>
													<textarea class="form-control-d" id="bz" name="bz" rows="6"></textarea>
												</div>
											</div>
										</div>
									</div>
									<div class="tab-pane" id="tab4">
										<div class="form-group">
											<label class="control-label col-md-3">办件编号：</label>
											<div class="col-md-6">
												<input class="form-control" name="bjbh" value="${bjbh}" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">查询人姓名：</label>
											<div class="col-md-6">
												<input class="form-control" id="cxrxmView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">查询人身份证号：</label>
											<div class="col-md-6">
												<input class="form-control" id="cxrsfzhView" readonly="readonly" />
											</div>
										</div>
										<div id="wtdivtab4" class="hide">
											<div class="form-group">
												<label class="control-label col-md-3">委托人姓名：</label>
												<div class="col-md-6">
													<input class="form-control" id="wtrxmView" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3">委托人身份证号：</label>
												<div class="col-md-6">
													<input class="form-control" id="wtrsfzhView" readonly="readonly" />
												</div>
											</div>
											<div class="form-group">
												<label class="control-label col-md-3">委托人联系电话：</label>
												<div class="col-md-6">
													<input class="form-control" id="wtrlxdhView" readonly="readonly" />
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 申请报告用途： </label>
											<div class="col-md-6">
												<input class="form-control" id="purposeView" readonly="readonly" />
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 报告起止时间： </label>
											<div class="col-md-3">
												<input id="sqbgqssjView" class="form-control input-md " readonly="readonly">
											</div>
											<div class="col-md-3">
												<input id="sqbgjzsjView" class="form-control input-md " readonly="readonly">
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3"> 备注： </label>
											<div class="col-md-6">
												<textarea class="form-control-d" id="bzView" readonly="readonly" rows="6"></textarea>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">查询人身份证：</label>
											<div class="col-md-4" id="cxrsfzView"></div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-3">委托人身份证：</label>
											<div class="col-md-4" id="wtrsfzView"></div>
											<label class="control-label col-md-2">委托授权书：</label>
											<div class="col-md-2" id="wtsqsView"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12" style="text-align: center;">
										<a href="javascript:" class="btn default button_reset">
											<i class="fa fa-rotate-left"></i> 重置
										</a>
										<a href="javascript:" class="btn default button-previous">
											<i class="m-icon-swapleft"></i> 上一步
										</a>
										<a href="javascript:" class="btn blue button-next">
											下一步 <i class="m-icon-swapright m-icon-white"></i>
										</a>
										<a href="javascript:" class="btn green button-submit">
											<c:if test="${audit == 0 }">生成报告</c:if>
											<c:if test="${audit == 1 }">提交申请</c:if>
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

	<script type="text/javascript" src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.zh-CN.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/hall/creditReport/hall_p_report_apply.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/jquery-photo-gallery-master/jquery-photo-gallery/jquery.photo.gallery.js"></script>

</body>
</html>