<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>自然人信用报告</title>
<!-- 浏览器的网页title图标 -->
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico" type="image/x-icon" />

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditReport/printCommon.css">
<link rel="stylesheet" type="text/css" href="${rsa}/global/css/fonts-googleapis.css" />
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/font-awesome/css/font-awesome.min.css" />
<style type="text/css">
html, body {
	margin: 0px;
	padding: 0px;
	background-color: #525659;
}
div.printDiv {
	height: 30px;
	line-height: 30px;
	background-color: #323639;
	text-align: right;
	position: fixed;
	width: 100%;
}

i.printBtn {
	color: #F1F1F1;
	font-size: 22px;
	margin-right: 220px;
	cursor: pointer;
}

i.printBtn:hover {
	color: #fff;
}
</style>
</head>
<body>
	<div id="printDiv" class="printDiv">
		<i class="fa fa-print printBtn" onclick="printDetail();"></i>
	</div>
	<div class="printbg">
		<div class="all">
			<!--cover begin-->
			<div class="cover">
				<h3>编号:${bgbh}</h3>
				<h1 class="tc pad_t200 pad_b100">
					${template.title } <br />查询报告
				</h1>
				<h2 class="tc pad_t300">${template.reportSource }（签章）</h2>
				<h3 class="tc pad_t20"></h3>
				<h3 class="tc pad_t20"></h3>
				<h3 class="tc pad_b100">查询日期： ${queryDate}</h3>
			</div>
			<!--cover over-->

			<!--content begin-->
			<div class="content">
				<c:if test="${not empty grxx.kssj and not empty grxx.jssj}">
					<p class="f_16">根据${grxx.name}提出查询信用信息的申请，我中心在社会自然人信用基础数据库进行查询，统计数据时间段为${grxx.kssj}到${grxx.jssj}，结果如下：</p>
				</c:if>
				<c:if test="${empty grxx.kssj and empty grxx.jssj}">
					<p class="f_16">根据${grxx.name}提出查询信用信息的申请，我中心在社会自然人信用基础数据库进行查询，截止${queryDate}，结果如下：</p>
				</c:if>

				<div class="tit1">一、基本信息</div>
				<div class="tit2">1、个人信息</div>
				<table class="tablePrint">
					<tbody>
						<tr>
							<th class="right" width="170">姓名</th>
							<td>${grxx.name}</td>
						</tr>
						<tr>
							<th class="right">身份证号</th>
							<td>${grxx.idCard}</td>
						</tr>
					</tbody>
				</table>

			</div>
		</div>
	</div>

	<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/base.js"></script>
	<script type="text/javascript">
		var themeInfo = '${themeInfo}';
		var template = '${templateJson}';
		var ctx = '${pageContext.request.contextPath}';
	</script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/creditReportQuery/p_report_print_template.js"></script>

</body>
</html>