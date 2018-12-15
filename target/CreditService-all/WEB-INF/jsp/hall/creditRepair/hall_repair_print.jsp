<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>信用修复申请受理单</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css"
	href="${rsa}/global/css/fonts-googleapis.css" />
<link rel="stylesheet" type="text/css"
	href="${rsa}/global/plugins/font-awesome/css/font-awesome.min.css" />

<style type="text/css">
	* {
		margin: 0px;
		padding: 0px;
	}

	html, body {
		background-color: /* #525659 */ #3e3e3e;
		font-family: "宋体";
		font-size:17px;
	}

	.mar20_0 {
		margin: 20px 0px;
	}

	.main {
		width: 756px;
		border: 0px solid #dedede;
		margin: auto;
		position: relative;
		padding: 80px 20px 0 20px;
		background-color: #fff;
		/* margin-top: 30px;
        margin-bottom: 60px; */
		overflow: hidden;
	}

	.head {
		text-align: center;
	}

	.head h1 {
		margin: 20px 0 50px;
		font-size: 1.7em;
	}

	table {
		width: 100%;
	}

	th {
		text-align: left;
	}

	td {
		height: 30px;
		text-align: left;
	}

	.tips {
		margin: 15px 0px 60px;
	}

	.tips p {
		text-indent: 2em;
	}

	.floatL {
		display: inline-block;
		float: left;
	}

	.floatR {
		display: inline-block;
		float: right;
	}

	.push {
		clear: both;
	}

	.bold {
		font-weight: bold;
	}

	.date {
		padding-right: 50px;
		position: relative;
		top: 100px;
	}

	.date span {
		text-align: right;
		margin-top: 22px;
		display: block;
	}

	.date span:first-child {
		margin-top: 0;
	}

	.printDiv {
		height: /* 30px */ 32px;
		line-height: /* 30px */ 34px;
		background-color: /* #323639 */ #474747;
		text-align: left;
		box-shadow: 2px 2px 2px #303030;
		position: fixed;
		top: 0;
		width: 100%;
		z-index: 1;
	}

	i.printBtn {
		color: #F1F1F1;
		font-size: 20px;
		margin-right: 220px;
		cursor: pointer;
	}

	i.printBtn:hover {
		color: #fff;
	}

	dl.QRbox, dl.QRbox dt, dl.QRbox dd {
		text-align: left;
		overflow: hidden;
	}

	dl.QRbox dt {
		margin-bottom: 22px;
	}

	dl.QRbox dd .img1 {
		display: block;
		width: 142px;
	}

	.weixinPic {
		display: block;
		width: 25px;
		height: 25px;
		position: relative;
		left: 9px;
		top: -2px;
	}

	.QRtext {
		height: 24px;
		line-height: 24px;
		padding-right: 9px;
		font-size: 14px;
	}

	.height50 {
		height: 100px;
		width: 100%;
	}

	.textRight {
		text-align: right;
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
			<h1>公共信用中心业务受理单</h1>
		</div>
		<div>
			<table>
				<tr>
					<td width="17%" class="bold">申请人：</td>
					<td width="33%">${sqr}</td>
					<td width="17%" class="bold">申请日期：</td>
					<td width="33%">${sqrq}</td>
				</tr>
				<tr>
					<td class="bold">受件编号：</td>
					<td>
						<c:if test="${ bjbhList != null }">
							<c:forEach items="${ bjbhList }" var="bjbh">
								${ bjbh } <br />
							</c:forEach>
						</c:if>
					</td>
					<td class="bold">业务类别：</td>
					<td>信用修复申请</td>
				</tr>
				<tr>
					<td class="bold">经办人：</td>
					<td>${jbr}</td>
					<td class="bold">受理人：</td>
					<td>${slr}</td>
				</tr>
			</table>
		</div>
		<div class="tips">本次业务已成功受理，预计在5个工作日内办结。</div>
		<dl class="QRbox floatL">
			<dt>网址：<a href="">http://www.szcredit.gov.cn/</a></dt>
			<dd class="floatL">微信二维码：</dd>
			<dd class="floatR">
				<img class="img1" src="${pageContext.request.contextPath}/app/images/creditReport/cxszQR.jpg" />
				<div>
					<img class="floatL weixinPic" src="${pageContext.request.contextPath}/app/images/creditReport/weixin.png" /> <span
						class="floatR QRtext">微信|公众平台</span>
				</div>
			</dd>
		</dl>
		<div class="date floatR">
			<span> <!-- 公共信用服务中心 -->苏州市公共信用信息服务中心
			</span> <span>日期：${date}</span>
		</div>
		<div class="height50 push"></div>
		<div class="push floatR">
			<table>
				<tr>
					<th class="textRight">地址：</th>
					<td>苏州市姑苏区十梓街338号</td>
				</tr>
				<tr>
					<th class="textRight">信用服务电话：</th>
					<td>0512-65221006</td>
				</tr>
			</table>
		</div>
		<%--<div class="date">公共信用服务中心</div>
		<div class="date">${date}</div>--%>
	</div>

</body>
</html>