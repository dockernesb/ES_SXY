<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>信用报告申请查看</title>
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/ystep-master/css/ystep.css" />
<style type="text/css">
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
					<div style="height: 25px;"></div>
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
									<label class="control-label col-md-3">申请报告用途： </label>
									<div class="col-md-6">
										<input class="form-control" id="purposeView" value="${pi.purpose }" readonly="readonly" />
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">报告起止时间： </label>
									<div class="col-md-3">
										<input id="sqbgqssjView" class="form-control input-md "
											value="<fmt:formatDate value="${pi.sqbgqssj }" pattern="yyyy年MM月dd日" />" readonly="readonly">
									</div>
									<div class="col-md-3">
										<input id="sqbgjzsjView" class="form-control input-md "
											value="<fmt:formatDate value="${pi.sqbgjzsj }" pattern="yyyy年MM月dd日" />" readonly="readonly">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3">备注： </label>
									<div class="col-md-6">
										<textarea class="form-control-d" readonly="readonly" rows="6">${pi.bz}</textarea>
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
															onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
															onerror="loadDefaultImg(this)" />
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
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
																onerror="loadDefaultImg(this)" />
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
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
																onerror="loadDefaultImg(this)" />
														</div>
													</c:forEach>
												</div>
											</c:if>
										</div>
									</div>
								</c:if>
								<c:if test="${audit == 1}">
									<div class="form-group">
										<label class="control-label col-md-3"> 中心审核意见： </label>
										<div class="col-md-6">
											<textarea class="form-control" rows="4" readonly="readonly">${pi.zxshyj}</textarea>
										</div>
									</div>
								</c:if>
							</div>
							<div class="form-actions" style="text-align: center;">
								<a href="javascript:;" class="btn backBtn default"> 返回 </a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript" src="${rsa}/global/plugins/ystep-master/js/ystep.js"></script>
	<script type="text/javascript">
		(function() {
			// 信用报告申请是否审核开关：0不需要审核，1需要审核
			var audit = '${audit}';
			if (audit == 1) {
				var steps = [ {
					title : "前台已受理",
					content : "前台已受理"
				}, {
					title : "待审核",
					content : "待中心审核"
				} ];

				if ("${pi.status}" == 2) { //	2:未通过
					steps.push({
						title : "审核不通过",
						content : "审核不通过"
					});
				} else {
					steps.push({
						title : "审核通过",
						content : "审核通过"
					});
				}

				steps.push({
					title : "流程结束",
					content : "流程结束"
				});

				$("#stepDiv").loadStep({
					//ystep的外观大小
					//可选值：small,large
					size : "large",
					//ystep配色方案
					//可选值：green,blue
					color : "blue",
					//ystep中包含的步骤
					steps : steps
				});

				if ("${pi.status}" == 0) { //	0:待审核
					$("#stepDiv").setStep(2);
				} else {
					$("#stepDiv").setStep(4);
				}
			}

			$(".backBtn").click(function() {
				$("#applyDetailDiv,#auditOneDiv,#auditTwoDiv").hide();
				$("div#mainListDiv").show();
				var selectArr = recordSelectNullEle();
				$("div#mainListDiv").prependTo('#topDiv');
				callbackSelectNull(selectArr);
				resetIEPlaceholder();
			});

		})();
	</script>

</body>
</html>