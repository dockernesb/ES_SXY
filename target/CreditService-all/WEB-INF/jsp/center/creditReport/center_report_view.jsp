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
								<%-- <c:if test="${eo.type == 0 }"> --%>
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
								<%-- </c:if> --%>
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
										<input id="sqbgqssjView" class="form-control input-md "
											value="<fmt:formatDate value="${eo.sqbgqssj }" pattern="yyyy-MM" />" readonly="readonly">
									</div>
									<div class="col-md-3">
										<input id="sqbgjzsjView" class="form-control input-md "
											value="<fmt:formatDate value="${eo.sqbgjzsj }" pattern="yyyy-MM" />" readonly="readonly">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-3"> 备注： </label>
									<div class="col-md-6">
										<textarea class="form-control-d" readonly="readonly" rows="6">${eo.bz}</textarea>
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
								<c:if test="${eo.type == 0 }">
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
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
																onerror="loadDefaultImg(this)" />
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
																onclick="openPhoto('${pageContext.request.contextPath}/common/viewImg.action?path=${t.filePath}')"
																onerror="loadDefaultImg(this)" />
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
											<textarea class="form-control" rows="4" readonly="readonly">${eo.zxshyj}</textarea>
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-md-3"> 报告下发意见： </label>
										<div class="col-md-6">
											<textarea class="form-control" rows="4" readonly="readonly">${eo.issueOpition}</textarea>
										</div>
									</div>
								</c:if>
							</div>
							<div class="form-actions" style="text-align: center;">
								<a href="javascript:" class="btn backBtn default"> 返回 </a>
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

				if ("${eo.status}" == 2) { //	2:未通过
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

                if ("${eo.isIssue}" == 0) {
                    if ("${eo.status}" == 0) {// 待审核, 显示正常流程
                        steps.push({
                            title : "报告已下发",
                            content : "报告已下发"
                        });
                    } else if ("${eo.status}" == 1 || "${eo.status}" == 2) {// 审核通过
                        steps.push({
                            title : "报告未下发",
                            content : "报告未下发"
                        });
                    }
                } else {
                    steps.push({
                        title : "报告已下发",
                        content : "报告已下发"
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

				if ("${eo.status}" == 0) { //	0:待审核
					$("#stepDiv").setStep(2);
				} else {
                    if ("${eo.isIssue}" == 1 || "${eo.status}" == 2) {
                        $("#stepDiv").setStep(5);// 报告已下发或审核不通过，则流程结束
                    } else {
                        $("#stepDiv").setStep(4);
                    }
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