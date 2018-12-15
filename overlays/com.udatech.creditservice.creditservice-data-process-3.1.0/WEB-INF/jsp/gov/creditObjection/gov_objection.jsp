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
						<a href="javascript:void(0);" id="backBtn2" class="btn btn-default btn-sm"> 返回 </a>
					</div>
				</div>
				<div class="portlet-body form">
					<div style="height: 10px;"></div>
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<div class="form-wizard">
							<div class="form-body">
								<div class="form-group">
									<label class="control-label col-md-3">办件编号：</label>
									<div class="col-md-6">
										<input class="form-control" value="${ci.bjbh}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">企业名称：</label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.qymc}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">工商注册号：</label>
									<div class="col-md-6">
										<input class="form-control" id="gszch" value="${eo.gszch}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">组织机构代码：</label>
									<div class="col-md-6">
										<input class="form-control" id="zzjgdm" value="${eo.zzjgdm}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">统一社会信用代码：</label>
									<div class="col-md-6">
										<input class="form-control" id="tyshxydm" value="${eo.tyshxydm}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 经办人姓名： </label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.jbrxm}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 经办人身份证号码： </label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.jbrsfzhm}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 经办人联系电话： </label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.jbrlxdh}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 申诉内容： </label>
									<div class="col-md-6">
										<table id="nrzs" class="nr-table">
											<tr>
												<td class="title" colspan="2">
													<span>${ci.category}</span>
												</td>
											</tr>
										</table>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 申诉备注： </label>
									<div class="col-md-6">
										<textarea class="form-control" readonly="readonly" rows="6">${eo.ssbz}</textarea>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 数据提供部门： </label>
									<div class="col-md-6">
										<input class="form-control" value="${ci.deptName}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">营业执照：</label>
									<div class="col-md-2">
										<c:if test="${eo.yyzz != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${eo.yyzz}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
									<label class="control-label col-md-2">组织机构代码证：</label>
									<div class="col-md-4">
										<c:if test="${eo.zzjgdmz != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${eo.zzjgdmz}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">企业授权书：</label>
									<div class="col-md-2">
										<c:if test="${eo.qysqs != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${eo.qysqs}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
									<label class="control-label col-md-2">身份证：</label>
									<div class="col-md-4">
										<c:if test="${eo.sfz != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${eo.sfz}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">异议信息申请表：</label>
									<div class="col-md-2">
										<c:if test="${eo.yyxxsqb != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${eo.yyxxsqb}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
									<label class="control-label col-md-2">证明材料：</label>
									<div class="col-md-4">
										<c:if test="${eo.zmcl != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${eo.zmcl}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
								</div>
								<c:if test="${ci.zxshyj != null}">
									<div class="form-group">
										<label class="control-label col-md-3"> 中心审核意见： </label>
										<div class="col-md-6">
											<textarea class="form-control" rows="4" readonly="readonly">${ci.zxshyj}</textarea>
										</div>
									</div>
								</c:if>
								<c:if test="${ci.bmshyj != null}">
									<div class="form-group">
										<label class="control-label col-md-3"> 部门审核意见： </label>
										<div class="col-md-6">
											<textarea class="form-control" rows="4" readonly="readonly">${ci.bmshyj}</textarea>
										</div>
									</div>
								</c:if>
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

	<input type="hidden" id="businessId" value="${eo.id}" />
	<input type="hidden" id="detailId" value="${ci.id}" />
	<input type="hidden" id="status" value="${ci.status}" />
	<input type="hidden" id="dataTable" value="${ci.dataTable}" />
	<input type="hidden" id="thirdId" value="${ci.thirdId}" />

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/gov/creditObjection/gov_objection.js"></script>

</body>
</html>