<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>异议申诉申请受理单</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css"
	href="${rsa}/global/css/fonts-googleapis.css" />
<link rel="stylesheet" type="text/css"
	href="${rsa}/global/plugins/font-awesome/css/font-awesome.min.css" />

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

div.date {
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
			<h1>文明交通信用业务受理单</h1>
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
					<td >驾驶证号：</td>
					<td >${jszh}</td>
					<td>业务类别：</td>
					<td>自然人异议申诉申请</td>
				</tr>
				<tr>
					<td>受件编号：</td>
					<td colspan="3">${bjbh}</td>
				</tr>
			</table>
		</div>
		<div class="tips">本次业务已成功受理，预计在5个工作日内办结。</div>
		<div class="date">公共信用服务中心</div>
		<div class="date">${date}</div>
	</div>
</body>
</html>