<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<!-- 浏览器的网页title图标 -->
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico" type="image/x-icon" />

<title>信用报告申请反馈单</title>
<link rel="stylesheet" type="text/css" href="${rsa}/global/css/fonts-googleapis.css" />
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/font-awesome/css/font-awesome.min.css" />

<style type="text/css">
html, body {
	margin: 0px;
	padding: 0px;
	background-color: #525659;
}

div.main {
	width: 756px;
	border: 1px solid #dedede;
	margin: auto;
	position: relative;
	padding: 40px 100px 100px 100px;
	background-color: #fff;
	margin-top: 30px;
	margin-bottom: 30px;
}

div.head {
	text-align: center;
}

table {
	width: 100%;
}

td {
	height: 50px;
}

div.tips {
	margin: 30px 0px;
}

div.sign {
	text-align: right;
	padding-right: 50px;
	padding-bottom: 5px;
}

div.printDiv {
	height: 30px;
	line-height: 30px;
	background-color: #323639;
	text-align: right;
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
<script type="text/javascript">
	function printSomething() {
		var div = document.getElementById("printDiv");
		div.style.display = "none";
		window.print();
		div.style.display = "block";
	}
</script>
</head>
<body>
	<div id="printDiv" class="printDiv">
		<i class="fa fa-print printBtn" onclick="printSomething();"></i>
	</div>

	<div class="main">
		<div class="head">
			<h1>公共信用中心业务反馈单</h1>
		</div>
		<div>
			<table>
				<tr>
					<td width="17%">申请人：</td>
					<td width="33%">${sqr}</td>
					<td width="17%">申请日期：</td>
					<td width="33%">${sqrq}</td>
				</tr>
				<tr>
					<td>受件编号：</td>
					<td>${slbh}</td>
					<td>业务类别：</td>
					<td>${ywlx}</td>
				</tr>
				<tr>
					<td>经办人：</td>
					<td>${jbr}</td>
					<td>受理人：</td>
					<td>${slr}</td>
				</tr>
			</table>
		</div>
		<c:if test="${isHasBasic == 0 }">
			<div class="tips">本次业务已受理，但暂未匹配到您申请的相关自然人信息。</div>
		</c:if>
		<c:if test="${isHasBasic == 1 }">
			<div class="tips">本次业务已成功受理，预计在5个工作日内办结。</div>
		</c:if>
		<div class="sign">公共信用服务中心</div>
		<div class="sign">${date}</div>
	</div>

</body>
</html>