<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>自然人信用报告打印页面</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditReport/printCommon.css">
</head>
<body>
	<div class="printbg">
		<div class="all">
			<!--cover begin-->
			<div class="cover">
				<h3>编号:${bgbh}</h3>
				<h1 class="tc pad_t300 pad_b100">
					${template.title } <br />信用报告
				</h1>
				<h2 class="tc pad_t200">${template.reportSource }（签章）</h2>
				<h3 class="tc pad_b100">查询日期： ${queryDate}</h3>
			</div>
			<!--cover over-->

			<!--content begin-->
			<div class="content">
				<c:if test="${not empty grxx.kssj and not empty grxx.jssj}">
					<p class="f_16">根据${grxx.qymc}提出查询信用信息的申请，我中心在社会自然人信用基础数据库进行查询，统计数据时间段为${grxx.kssj}到${grxx.jssj}，结果如下：</p>
				</c:if>
				<c:if test="${empty grxx.kssj and empty grxx.jssj}">
					<p class="f_16">根据${grxx.qymc}提出查询信用信息的申请，我中心在社会自然人信用基础数据库进行查询，截止${queryDate}，结果如下：</p>
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

	<script type="text/javascript">
		var themeInfo = '${themeInfo}';
		var template = '${templateJson}';
	</script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/resourceManage/p_report_preview.js"></script>

</body>
</html>