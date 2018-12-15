<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>信用报告审核</title>
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/ystep-master/css/ystep.css" />
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i> 信用报告审核
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" class="btn backBtn btn-default btn-sm">
							<i class="fa fa-rotate-left"></i> 返回
						</a>
					</div>
				</div>
				<div class="portlet-body form">
					<div style="height: 25px;"></div>
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<div class="form-wizard">
							<div class="form-body">
								<div class="form-group">
									<label class="control-label col-md-3">办件编号：</label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.bjbh}" readonly="readonly" />
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
										<input class="form-control" value="${eo.gszch}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">组织机构代码：</label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.zzjgdm}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">统一社会信用代码：</label>
									<div class="col-md-6">
										<input class="form-control" value="${eo.tyshxydm}" readonly="readonly" />
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
								<c:if test="${eo.type == 1 }">
									<div class="form-group">
										<label class="control-label col-md-3"> 授权法人名称： </label>
										<div class="col-md-6">
											<input class="form-control" value="${eo.sqqymc}" readonly="readonly" />
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3"> 授权法人工商注册号： </label>
										<div class="col-md-6">
											<input class="form-control" value="${eo.sqgszch}" readonly="readonly" />
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3"> 授权法人组织机构代码： </label>
										<div class="col-md-6">
											<input class="form-control" value="${eo.sqzzjgdm}" readonly="readonly" />
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3"> 授权法人统一社会信用代码： </label>
										<div class="col-md-6">
											<input class="form-control" value="${eo.sqtyshxydm}" readonly="readonly" />
										</div>
									</div>
								</c:if>
								<div class="form-group">
									<label class="control-label col-md-3"> 申请报告用途： </label>
									<div class="col-md-6">
										<input class="form-control" id="purposeView" value="${eo.purpose }" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 区域部门： </label>
									<div class="col-md-6">
										<input class="form-control" id="areaDeptsView" value="${eo.areaDepts }" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 项目名称： </label>
									<div class="col-md-6">
										<input class="form-control" id="projectNameView" value="${eo.projectName }" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 项目细类： </label>
									<div class="col-md-6">
										<input class="form-control" id="projectXLView" value="${eo.projectXL }" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 报告起止时间： </label>
									<div class="col-md-3">
										<input id="sqbgqssjView" class="form-control input-md " value="<fmt:formatDate value="${eo.sqbgqssj }" pattern="yyyy-MM" />"
											readonly="readonly">
									</div>
									<div class="col-md-3">
										<input id="sqbgjzsjView" class="form-control input-md " value="<fmt:formatDate value="${eo.sqbgjzsj }" pattern="yyyy-MM" />"
											readonly="readonly">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 备注： </label>
									<div class="col-md-6">
										<textarea class="form-control" readonly="readonly" rows="6">${eo.bz}</textarea>
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
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
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
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
								</div>
								<c:if test="${eo.type == 0 }">
									<div class="form-group">
										<label class="control-label col-md-3">企业授权书：</label>
										<div class="col-md-2">
											<c:if test="${eo.qysqs != null}">
												<div class="preview-img-panel">
													<c:forEach var="t" items="${eo.qysqs}">
														<div class="preview-img">
															<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
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
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
														</div>
													</c:forEach>
												</div>
											</c:if>
										</div>
									</div>
								</c:if>
								<c:if test="${eo.type == 1 }">
									<div class="form-group">
										<label class="control-label col-md-3">企业授权书：</label>
										<div class="col-md-2">
											<c:if test="${eo.sqqysqs != null}">
												<div class="preview-img-panel">
													<c:forEach var="t" items="${eo.sqqysqs}">
														<div class="preview-img">
															<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
														</div>
													</c:forEach>
												</div>
											</c:if>
										</div>
										<label class="control-label col-md-2">身份证：</label>
										<div class="col-md-4">
											<c:if test="${eo.sqsfz != null}">
												<div class="preview-img-panel">
													<c:forEach var="t" items="${eo.sqsfz}">
														<div class="preview-img">
															<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
														</div>
													</c:forEach>
												</div>
											</c:if>
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3">授权法人证明文件：</label>
										<div class="col-md-2">
											<c:if test="${eo.sqfrzmwj != null}">
												<div class="preview-img-panel">
													<c:forEach var="t" items="${eo.sqfrzmwj}">
														<div class="preview-img">
															<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
														</div>
													</c:forEach>
												</div>
											</c:if>
										</div>
									</div>
								</c:if>
								<div class="form-group">
									<label class="control-label col-md-3">
										<span class="required">*</span> 中心审核意见：
									</label>
									<div class="col-md-6">
										<div class="input-icon right">
											<i class="fa"></i>
											<textarea id="zxshyj" name="zxshyj" rows="4" class="form-control">${eo.zxshyj}</textarea>
										</div>
									</div>
								</div>
							</div>
							<div class="form-actions" style="text-align: center;">
								<a href="javascript:" class="btn backBtn default"> 返回 </a>
								<a href="javascript:" id="nextStepBtn" class="btn blue"> 审核通过 </a>
								<a href="javascript:" id="shbtgBtn" class="btn red"> 驳回 </a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<input type="hidden" id="businessId" value="${eo.id}" />

	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditReport/center_report_audit.js"></script>
</body>
</html>