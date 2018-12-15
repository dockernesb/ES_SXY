<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>信用报告申请反馈单</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/global/css/fonts-googleapis.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/global/plugins/font-awesome/css/font-awesome.min.css" />

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

.tableService th, .tableService td {
	line-height: 30px;
	height: 30px;
}

.tableService th {
	text-align: center;
	font-size: 20px
}

.tableService td {
	text-align: left;
	font-size: 14px
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
		<i class="fa fa-print printBtn" onclick="printSomething();">苏州市公共信用服务大厅</i>
	</div>

	<div class="main">
		<div class="head">
			<h1>苏州市公共信用中心业务反馈单</h1>
		</div>
		<div>
			<table>
				<tr>
					<td width="13%"><span class="bold">申请人：</span></td>
					<td width="37%">${sqr}</td>
					<td width="13%"><span class="bold">申请日期：</span></td>
					<td width="37%">${sqrq}</td>
				</tr>
				<tr>
					<td><span class="bold">受件编号：</span></td>
					<td>${slbh}</td>
					<td><span class="bold">业务类别：</span></td>
					<td>${ywlx}</td>
				</tr>
				<tr>
					<td><span class="bold">经办人：</span></td>
					<td>${jbr}</td>
					<td><span class="bold">受理人：</span></td>
					<td>${slr}</td>
				</tr>
			</table>
		</div>
		<c:if test="${isHasBasic == 0 }">
			<div class="tips" style="text-indent:2em;">本次业务已受理，但暂未匹配到您申请的相关企业信息。</div>
		</c:if>
		<c:if test="${isHasBasic == 1 }">
			<div class="tips" style="text-indent:2em;line-height:30px;">本次业务已成功受理，预计在5个工作日内办结。可通过诚信苏州网或关注官方微信查询办理进度。</div>
		</c:if>
		<!-- 		<div class="sign">公共信用服务中心</div> -->
		<%-- 		<div class="sign">${date}</div> --%>

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
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="tableService">
			<tr>
				<th width="32%" nowrap="nowrap">信用服务地区</th>
				<th width="70%" nowrap="nowrap">信用服务地址</th>
				<th width="14%" nowrap="nowrap">信用服务电话</th>
			</tr>
			<tr>
				<td>苏州市公共信用信息服务大厅</td>
				<td>苏州市姑苏区十梓街338号</td>
				<td style="text-align:center;vertical-align:middle;">0512-65221006</td>
			</tr>
			<tr>
				<td>常熟市信用服务窗口</td>
				<td>常熟市海虞北路51号(市民卡中心8号柜台)</td>
				<td style="text-align:center;vertical-align:middle;">0512-52009009</td>
			</tr>
			<tr>
				<td>昆山市信用服务窗口</td>
				<td>昆山市东新路8号(社会管理中心304)</td>
				<td style="text-align:center;vertical-align:middle;">0512-57266159</td>
			</tr>
			<tr>
				<td>太仓市信用服务窗口</td>
				<td>太仓市县府东街99号3号楼(便民服务中心118号窗口)</td>
				<td style="text-align:center;vertical-align:middle;">0512-53890035</td>
			</tr>
			<tr>
				<td>苏州市吴江区信用服务窗口</td>
				<td>吴江区开平路998号(行政服务中心)</td>
				<td style="text-align:center;vertical-align:middle;">0512-63989308</td>
			</tr>
			<tr>
				<td>苏州市相城区信用服务窗口</td>
				<td>相城区庆元路168号(市民服务中心二楼 经信局窗口)</td>
				<td style="text-align:center;vertical-align:middle;">0512-67591835</td>
			</tr>
			<tr>
				<td>苏州市工业园区信用服务窗口</td>
				<td>苏州市苏州大道东351号工商大厦一楼(园区一站式服务中心商务区)</td>
				<td style="text-align:center;vertical-align:middle;">0512-68636052</td>
			</tr>
			<tr>
				<td>苏州市姑苏区信用服务窗口</td>
				<td>平川路510号姑苏区政府一号楼609</td>
				<td style="text-align:center;vertical-align:middle;">0512-68727609</td>
			</tr>
			<tr>
				<td>苏州市吴中区信用服务窗口</td>
				<td>吴中区越溪苏街198号(吴中区行政服务中心3楼信用办6号窗口)</td>
				<td style="text-align:center;vertical-align:middle;">0512-65273630</td>
			</tr>
			<tr>
				<td>张家港市信用服务窗口</td>
				<td>张家港市华昌路3号港城大厦经信委1306室</td>
				<td style="text-align:center;vertical-align:middle;">0512-56729017</td>
			</tr>
		</table>
	</div>

</body>
</html>