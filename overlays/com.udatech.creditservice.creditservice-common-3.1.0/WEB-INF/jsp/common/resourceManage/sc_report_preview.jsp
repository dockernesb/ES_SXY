<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>审查报告预览页面</title>
<style type="text/css">
@charset "utf-8";

.printbg * {
	margin: 0;
	padding: 0
}

.printbg img {
	border: 0px;
	padding: 0px;
	margin: 0px;
	display: inline;
}

.printbg table {
	border-collapse: collapse;
	border-spacing: 0
}

.printbg h1 {
	font-size: 38px;
	line-height: 80px
}

.printbg h2 {
	font-size: 16px;
	line-height: 50px;
}

.printbg h3 {
	font-size: 14px;
}

.printbg .pad_t20 {
	padding-top: 20px
}

.printbg .pad_t100 {
	padding-top: 100px !important;
}

.printbg .pad_t200 {
	padding-top: 200px !important;
}

.printbg .pad_t300 {
	padding-top: 300px !important;
}

.printbg .pad_b100 {
	padding-bottom: 100px !important;
}

.printbg .f_16 {
	font-size: 16px;
	line-height: 30px
}

.printbg .tc {
	text-align: center !important;
}

.printbg .tablePrint .right {
	text-align: right !important
}

.printbg .all {
	margin: 0 auto;
	padding: 30px 80px;
	overflow: hidden
}

.printbg {
	background: url(../../images/creditReport/defaultbj.png) repeat-y #fff
		top center;
}

@media print {
	.printbg {
		background: url(../../images/creditReport/defaultbj.png) repeat-y #fff
			top center;
	}
}

.printbg .cover {
	padding-bottom: 20px
}

.printbg .content {
	padding-top: 20px;
}

.printbg .content p {
	text-indent: 20px;
}

.printbg .tit1 {
	margin: 50px 0px 20px 0;
	font-size: 16px;
	font-weight: bold;
}

.printbg .tit2 {
	font-size: 16px;
	line-height: 30px;
	margin-bottom: 10px;
	margin-top: 10px;
}

.printbg .tablePrint {
	width: 50%
}

.printbg .tablePrint th {
	font-weight: bold;
	font-size: 14px;
	min-width: 100px
}

.printbg .tablePrint th, .printbg .tablePrint td {
	border: 1px solid #666 !important;
	height: 24px;
	padding: 5px;
}

.printbg .remark {
	text-indent: 20px;
	margin: 30px 0;
}

.printbg .tablePrint2 {
	width: 100%
}

.printbg .tablePrint2 th {
	font-weight: bold;
	font-size: 14px;
	min-width: 100px
}

.printbg .tablePrint2 th, .printbg .tablePrint2 td {
	border: 1px solid #666 !important;
	height: 24px;
	padding: 5px;
}
</style>
</head>
<body>
	<c:if test="${template.category eq 0 }">
		<c:set var="category" value="社会法人"></c:set>
	</c:if>
	<c:if test="${template.category eq 1 }">
		<c:set var="category" value="社会自然人"></c:set>
	</c:if>

	<div class="printbg">
		<div class="all">
			<!--cover begin-->
			<div class="cover">
				<table class="tablePrint">
					<tbody>
						<tr>
							<th width="110">报告编号</th>
							<td>SC0000000001</td>
						</tr>
						<tr>
							<th>审查名称</th>
							<td>审查名称001</td>
						</tr>
						<tr>
							<th>审查部门</th>
							<td>信用中心</td>
						</tr>
						<tr>
							<th>审查类别</th>
							<td>审查类别1、审查类别1、审查类别2、审查类别3、审查类别4、审查类别5</td>
						</tr>
					</tbody>
				</table>
				<h1 class="tc pad_t300 pad_b100">${template.title }</h1>
				<h2 class="tc pad_t200">${template.reportSource }（签章）</h2>
				<h3 class="tc pad_b100">查询日期： ${queryDate}</h3>
			</div>
			<!--cover over-->

			<!--content begin-->
			<div class="content">
				<div class="tit1">信用中心：</div>
				<div class="tit2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;按照你单位的要求，我中心对申请表中1家企业在${template.dataFrom }中进行查询。在2011年1月1日至2014年1月1日期间，共查得审查类别存在信息记录企业1家，查询结果情况见下表（审查详细信息见附件）：</div>
				<table class="tablePrint2">
					<thead>
						<th>编号</th>
						<th>企业名称</th>
						<th>工商注册号</th>
						<th>组织机构代码</th>
						<th>统一社会信用代码</th>
						<th>审查信息结果</th>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>常熟市东成旧机动车经纪有限公司1</td>
							<td>A32058100017011</td>
							<td>A67201221</td>
							<td>A91320509MA1MFNGL1</td>
							<td>许可资质信息0条失信信息1条</td>
						</tr>
					</tbody>
				</table>
				<div class="tit2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;其中在苏州市${category }信用基础数据库没有查到信息记录的企业共1家，其结果如下：</div>
				<table class="tablePrint2">
					<thead>
						<th>编号</th>
						<th>企业名称</th>
						<th>工商注册号</th>
						<th>组织机构代码</th>
						<th>统一社会信用代码</th>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>常熟市东成旧机动车经纪有限公司2</td>
							<td>B32058100017011</td>
							<td>B67201221</td>
							<td>B91320509MA1MFNGL1</td>
						</tr>
					</tbody>
				</table>
				<div class="tit2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;对在${template.dataFrom}没有查到信息记录的企业，请进一步核实企业名称、工商注册号、组织机构代码、统一社会信用代码后，再进行审查。</div>
				<div class="tit2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${template.dataFrom}来源于省、市有关政府部门，本报告仅供参考。</div>
				<br>

				<div class="tit2">联系地址：${template.address}</div>
				<div class="tit2">联系电话：${template.contactPhone}</div>
				<div class="tit2">附件一：申请审查名单</div>
				<div class="tit2">附件二：${category }信用审查结果</div>
				<br>
				<div class="tit2 right">${template.reportSource}</div>
				<div class="tit2 right">${queryDate}</div>
				<br>
				<div class="tit1">附件一：申请审查名单</div>
				<table class="tablePrint2">
					<thead>
						<th>编号</th>
						<th>企业名称</th>
						<th>工商注册号</th>
						<th>组织机构代码</th>
						<th>统一社会信用代码</th>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>常熟市东成旧机动车经纪有限公司1</td>
							<td>A32058100017011</td>
							<td>A67201221</td>
							<td>A91320509MA1MFNGL1</td>
						</tr>
					</tbody>
				</table>
				<div class="tit1">附件二：${category }信用审查结果</div>
				<table class="tablePrint2">
					<thead>
						<th>编号</th>
						<th>企业名称</th>
						<th>工商注册号</th>
						<th>组织机构代码</th>
						<th>统一社会信用代码</th>
						<th>审查信息结果</th>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>常熟市东成旧机动车经纪有限公司2</td>
							<td>B32058100017011</td>
							<td>B67201221</td>
							<td>B91320509MA1MFNGL1</td>
							<td>许可资质信息0条失信信息1条</td>
						</tr>
					</tbody>
				</table>

			</div>
		</div>
	</div>

	<script type="text/javascript">
		var template = '${templateJson}';
	</script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/resourceManage/sc_report_preview.js"></script>

</body>
</html>