<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditReport/creditReport.css" />
<title>法人信用报告</title>
<script type="text/javascript">
	var themeInfo = '${themeInfoJson}';
	var params = '${params}';
	var businessId = '${businessId}';
	var templateId = '${templateId}';
	var zxshyj = '${zxshyj}';
	$(function() {
		if (isNull('${message}')) {
			$('#shtgBtn').enable();
		} else {
			$('#shtgBtn').disable();
		}
	});
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/creditReportQuery/credit_report.js"></script>
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

					<table class="tablelist tablelist0">
						<tbody>
							<tr>
								<th width="10%">企业名称</th>
								<td width="20%">${qyxx.JGQC }</td>
								<th width="10%">工商注册号</th>
								<td width="20%">${qyxx.GSZCH}</td>
							</tr>
							<tr>
								<th>组织机构代码</th>
								<td>${qyxx.ZZJGDM}</td>
								<th>统一社会信用代码</th>
								<td>${qyxx.TYSHXYDM}</td>
							</tr>
							<tr>
								<th>注册资本</th>
								<td>${qyxx.ZCZJ}万</td>
								<th>注册日期</th>
								<td>${qyxx.FZRQ}</td>
							</tr>
							<tr>
								<th>法定代表人</th>
								<td>${qyxx.FDDBRXM}</td>
								<th>登记机关</th>
								<td>${qyxx.FZJGMC}</td>
							</tr>
							<tr>
								<th>所属行业名称</th>
								<td>${qyxx.SSHYMC}</td>
								<th>企业类型</th>
								<td>${qyxx.QYLXMC}</td>
							</tr>
							<tr>
								<th>经营范围</th>
								<td colspan="3">${qyxx.JYFW}</td>
							</tr>
							<tr>
								<th>企业地址</th>
								<td colspan="3">${qyxx.JGDZ}</td>
							</tr>
						</tbody>
					</table>

					<p>
						<span style="color: #e02222; font-size: 14px;">
							<b>注：</b>
						</span><br>
						<span style="color: #e02222; font-size: 12px;">
									&nbsp;&nbsp;&nbsp;&nbsp;1.列表中红色背景的数据，表示该信用数据已完成信用修复。
								</span><br>
						<span style="color: #e02222; font-size: 12px;">
									&nbsp;&nbsp;&nbsp;&nbsp;2.列表中黄色背景的数据，表示该信用数据已发起异议申诉申请但尚未处理完成。
								</span><br>
						<span style="color: #e02222; font-size: 12px;">
									&nbsp;&nbsp;&nbsp;&nbsp;3.列表中紫色背景的数据，表示该信用数据已发起信用修复申请但尚未处理完成。
								</span>
					</p>

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