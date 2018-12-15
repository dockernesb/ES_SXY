<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>自然人信用报告申请查看</title>
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/ystep-master/css/ystep.css" />
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i> 信用报告申请查看
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
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<div class="form-wizard">
							<div class="form-body">
								<div class="form-group">
									<label class="control-label col-md-3">办件编号：</label>
									<div class="col-md-6">
										<input class="form-control" value="${pi.bjbh}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">查询人姓名：</label>
									<div class="col-md-6">
										<input class="form-control" value="${pi.cxrxm}" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">查询人身份证号：</label>
									<div class="col-md-6">
										<input class="form-control" value="${pi.cxrsfzh}" readonly="readonly" />
									</div>
								</div>
								<c:if test="${pi.type == 1 }">
									<div class="form-group">
										<label class="control-label col-md-3">委托人姓名： </label>
										<div class="col-md-6">
											<input class="form-control" value="${pi.wtrxm}" readonly="readonly" />
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3">委托人身份证号： </label>
										<div class="col-md-6">
											<input class="form-control" value="${pi.wtrsfzh}" readonly="readonly" />
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3">委托人联系电话： </label>
										<div class="col-md-6">
											<input class="form-control" value="${pi.wtrlxdh}" readonly="readonly" />
										</div>
									</div>
								</c:if>
								<div class="form-group">
									<label class="control-label col-md-3"> 申请报告用途： </label>
									<div class="col-md-6">
										<input class="form-control" id="purposeView" value="${pi.purpose }" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 报告起止时间： </label>
									<div class="col-md-3">
										<input id="sqbgqssjView" class="form-control input-md " value="<fmt:formatDate value="${pi.sqbgqssj }" pattern="yyyy-MM-dd" />"
											readonly="readonly">
									</div>
									<div class="col-md-3">
										<input id="sqbgjzsjView" class="form-control input-md " value="<fmt:formatDate value="${pi.sqbgjzsj }" pattern="yyyy-MM-dd" />"
											readonly="readonly">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 备注： </label>
									<div class="col-md-6">
										<textarea class="form-control" readonly="readonly" rows="6">${pi.bz}</textarea>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">查询人身份证：</label>
									<div class="col-md-4">
										<c:if test="${pi.cxrsfz != null}">
											<div class="preview-img-panel">
												<c:forEach var="t" items="${pi.cxrsfz}">
													<div class="preview-img">
														<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
													</div>
												</c:forEach>
											</div>
										</c:if>
									</div>
								</div>
								<c:if test="${pi.type == 1 }">
									<div class="form-group">
										<label class="control-label col-md-3">委托人身份证：</label>
										<div class="col-md-4">
											<c:if test="${pi.wtrsfz != null}">
												<div class="preview-img-panel">
													<c:forEach var="t" items="${pi.wtrsfz}">
														<div class="preview-img">
															<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}"
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')" onerror="loadDefaultImg(this)" />
														</div>
													</c:forEach>
												</div>
											</c:if>
										</div>
										<label class="control-label col-md-2">委托授权书：</label>
										<div class="col-md-2">
											<c:if test="${pi.wtsqs != null}">
												<div class="preview-img-panel">
													<c:forEach var="t" items="${pi.wtsqs}">
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
									<label class="control-label col-md-3"> <span class="required">*</span>中心审核意见：
									</label>
									<div class="col-md-6">
										<div class="input-icon right">
											<i class="fa"></i>
											<textarea id="zxshyj" name="zxshyj" rows="4" class="form-control">${pi.zxshyj}</textarea>
										</div>
									</div>
								</div>
							</div>
							<div class="form-actions" style="text-align: center;">
								<a href="javascript:;" class="btn backBtn default">返回 </a>
								<a href="javascript:;" id="nextStepBtn" class="btn blue"> 下一步 </a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<input type="hidden" id="businessId" value="${pi.id}" />

	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditReport/center_p_report_audit.js"></script>
</body>
</html>