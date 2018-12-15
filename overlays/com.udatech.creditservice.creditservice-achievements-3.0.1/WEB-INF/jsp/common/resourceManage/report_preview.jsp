<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>法人信用报告打印页面</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditReport/printCommon.css">
</head>
<body>
	<div class="printbg">
<!-- 		<div> -->
<!-- 			<a id="print_button" href="javascript:printDetail();" style="padding-left: 8px;" class="printbtn"> -->
<!-- 				<i class="fa fa-print" style="padding-right: 5px; font-size: 17px;"></i>打印 -->
<!-- 			</a> -->
<!-- 		</div> -->
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
				<c:if test="${not empty qyxx.KSSJ and not empty qyxx.JSSJ}">
					<p class="f_16">根据${qyxx.QYMC}提出查询信用信息的申请，我中心在社会法人信用基础数据库进行查询，统计数据时间段为${qyxx.KSSJ}到${qyxx.JSSJ}，结果如下：</p>
				</c:if>
				<c:if test="${empty qyxx.KSSJ and empty qyxx.JSSJ}">
					<p class="f_16">根据${qyxx.QYMC}提出查询信用信息的申请，我中心在社会法人信用基础数据库进行查询，截止${queryDate}，结果如下：</p>
				</c:if>

				<div class="tit1">一、基本信息</div>
				<div class="tit2">1、注册登记信息</div>
				<table class="tablePrint">
					<tbody>
						<tr>
							<th class="right" width="170">企业名称</th>
							<td>${qyxx.QYMC}</td>
						</tr>
						<tr>
							<th class="right">工商注册号</th>
							<td>${qyxx.GSZCH}</td>
						</tr>
						<tr>
							<th class="right">组织机构代码</th>
							<td>${qyxx.ZZJGDM}</td>
						</tr>
						<tr>
							<th class="right">社会信用代码</th>
							<td>${qyxx.SHXYDM}</td>
						</tr>
						<tr>
							<th class="right">注册资本</th>
							<td>${qyxx.ZCZJ}万</td>
						</tr>
						<tr>
							<th class="right">注册日期</th>
							<td>${qyxx.ZCRQ}</td>
						</tr>
						<tr>
							<th class="right">法定代表人</th>
							<td>${qyxx.FDDBR}</td>
						</tr>
						<tr>
							<th class="right">登记机关</th>
							<td>${qyxx.FZJGMC}</td>
						</tr>
						<tr>
							<th class="right">所属行业名称</th>
							<td>${qyxx.SSHYMC}</td>
						</tr>
						<tr>
							<th class="right">企业类型</th>
							<td>${qyxx.QYLX}</td>
						</tr>
						<tr>
							<th class="right">经营范围</th>
							<td>${qyxx.JYFW}</td>
						</tr>
						<tr>
							<th class="right">企业地址</th>
							<td>${qyxx.QYDZ}</td>
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
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/resourceManage/report_preview.js"></script>

</body>
</html>