<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>异议申诉查看</title>
<link rel="stylesheet" type="text/css"
	href="${rsa}/global/plugins/ystep-master/css/ystep.css" />
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						异议申诉查看
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" id="backBtn2" class="btn btn-default btn-sm">
							<i class="fa fa-rotate-left"></i> 返回
						</a>
					</div>
				</div>
				<div class="portlet-body form">
					<div style="height: 50px;"></div>
					<div style="text-align: center;">
						<div id="stepDiv"></div>
					</div>
					<div style="height: 10px;"></div>
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<div class="form-wizard">
							<div class="form-body">
								<div class="form-group">
									<label class="control-label col-md-3">办件编号：</label>
									<div class="col-md-6">
										<input class="form-control" value="${oc.bjbh}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">申请类型：</label>
									<div class="col-md-6">
										<c:if test="${oc.complaintType == '0'}">
											<input class="form-control" value="文明交通异议申诉" readonly="readonly" />
										</c:if>
										<c:if test="${oc.complaintType == '1'}">
											<input class="form-control" value="其他" readonly="readonly" />
										</c:if>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">申诉人姓名：</label>
									<div class="col-md-6">
										<input class="form-control" value="${oc.name}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">驾驶证号：</label>
									<div class="col-md-6">
										<input class="form-control" value="${oc.jsz}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 申诉内容： </label>
									<div class="col-md-6">
										<table id="nrzs" class="nr-table">
											<tr>
												<c:if test="${oc.type == '1'}">
													<td class="title" colspan="2">申诉失信等级</td>
												</c:if>
												<c:if test="${oc.type == '2'}">
													<td class="title" colspan="2">申诉失信记录</td>
												</c:if>
											</tr>
										</table>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 申诉备注： </label>
									<div class="col-md-6">
										<textarea class="form-control" readonly="readonly" rows="6">${oc.ssbz}</textarea>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">证明材料：</label>
									<div class="col-md-6">
										<c:if test="${zmcl != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${zmcl}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.FILE_PATH}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.FILE_PATH}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
								</div>
							</div>
							<div class="form-actions" style="text-align: center;">
								<a href="javascript:;" id="backBtn" class="btn default"> 返回 </a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<input type="hidden" id="status" value="${oc.state}" />
	<input type="hidden" id="type" value="${oc.type}" />
	<input type="hidden" id="dataTable" value="${oc.dataTable}" />
	<input type="hidden" id="thirdId" value="${oc.linkId}" />
	<script type="text/javascript"
			src="${rsa}/global/plugins/ystep-master/js/ystep.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/objectionComplaint/objection_complaint.js"></script>

</body>
</html>