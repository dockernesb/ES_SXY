<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditReport/creditReport.css" />
<title>自然人信用报告</title>
<script type="text/javascript">
	var themeInfo = '${themeInfoJson}';
	var params = '${params}';
	var businessId = '${businessId}';
	var templateId = '${templateId}';
	var zxshyj = '${zxshyj}';
	$(function() {
		if (isNull('${message}')) {
			$('#print-btn').enable();
		} else {
			$('#print-btn').disable();
		}
	});
</script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/app/js/common/creditReportQuery/p_credit_report.js"></script>
</head>

<body>
	<input type="hidden" id="jgqc" value="${name}" />
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

					<table class="tablelist tablelist0">
						<tbody>
							<tr>
								<th width="10%">姓名</th>
								<td width="20%">${zrrxx.XM }</td>
								<th width="10%">身份证号</th>
								<td width="20%">${zrrxx.SFZH }</td>
							</tr>
							<tr>
								<th>性别</th>
								<td>${zrrxx.XB }</td>
								<th>民族</th>
								<td>${zrrxx.MZ }</td>
							</tr>
							<tr>
								<th>所属行业</th>
								<td>${zrrxx.SSHY }</td>
								<th>出生日期</th>
								<td>${zrrxx.CSRQ }</td>
							</tr>
							<tr>
								<th>户籍地址</th>
								<td colspan="3" >${zrrxx.HJDZ }</td>								
							</tr>
						</tbody>
					</table>


					<c:if test="${not empty message}">
						<div align="center" style="color: red; font-size: 14px;">${message }</div>
					</c:if>

					<c:if test="${empty message}">
						<div class="tabbable-custom">
							<ul class="nav nav-tabs">
								<!-- 一级资源 -->
								<c:forEach var="theme" items="${themeInfo}" varStatus="status">
									<c:if test="${status.index == 0 }">
										<li class="active">
									</c:if>
									<c:if test="${status.index > 0 }">
										<li>
									</c:if>
									<a href="#${theme.id }" data-toggle="tab" title="${theme.text }"> ${theme.text } </a>
									</li>
								</c:forEach>
							</ul>
							<div class="tab-content">
								<!-- 一级资源 -->
								<c:forEach var="themeOne" items="${themeInfo}" varStatus="i">
									<c:if test="${i.index == 0 }">
										<div class="tab-pane active" id="${themeOne.id }">
									</c:if>
									<c:if test="${i.index > 0 }">
										<div class="tab-pane fade" id="${themeOne.id }">
									</c:if>
									<div class="row">
										<div class="col-md-12">
											<div id="${themeOne.id }_detailDiv"></div>
										</div>
									</div>
							</div>
							</c:forEach>
						</div>
					</c:if>
					<br>
					<div class="form-actions" style="text-align: center;">
						<a href="javascript:void(0);" id="preStepBtn" class="btn blue">上一步</a>
						<a href="javascript:;" id="shtgBtn" class="btn blue"> 审核通过 </a>
						<a href="javascript:;" id="shbtgBtn" class="btn red"> 审核不通过 </a>
						<a href="javascript:;" class="btn backBtn default"> 返回 </a>
					</div>

				</div>
			</div>
		</div>
	</div>

</body>
</html>