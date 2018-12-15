<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>社会法人</title>
<c:if test="${isOpen eq '1'}">
	<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
</c:if>
<!--[if IE 9]>
<style>
/*解决ie9下点击头部会导致增加空白的问题 */
.dataTables_wrapper > div{ overflow:visible;}
#winAdd table{min-width: 1700px;}
</style>
<![endif]-->

<style>

#winAdd th, #winAdd td {
    white-space: nowrap;
}

#winAdd .bgInfo th, #winAdd .bgInfo td {
	white-space: unset;
}
</style>
</head>
<body <c:if test="${isOpen eq '1'}">style="background:#fff"</c:if>>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-th-list"></i>法人信用档案
					</div>
					<c:if test="${isOpen ne '1'}">
						<div class="tools">
							<a href="javascript:;" class="collapse"> </a>
						</div>
						<div class="actions">
						    <button type="button" class="btn btn-default" onclick="sociaLegalPerson.onBusinessTrace();">数据追溯</button>
						    
							<button type="button" class="btn btn-default" onclick="sociaLegalPerson.goBack();">
								<i class="fa fa-rotate-left"></i> 返回
							</button>
						</div>
					</c:if>
				</div>
				<div class="portlet-body">
					<input id="qymc" name="qymc" value="${qyxx.JGQC}" type="hidden" />
					<input id="gszch" name="gszch" value="${qyxx.GSZCH}" type="hidden" />
					<input id="zzjgdm" name="zzjgdm" value="${qyxx.ZZJGDM}" type="hidden" />
					<input id="tyshxydm" name="tyshxydm" value="${qyxx.TYSHXYDM}" type="hidden" />
					<input id="qyid" name="qyid" value="${qyxx.ID}" type="hidden" />
					<div class="row">
						<div class="col-md-12">
							<table class="table table-striped table-hover table-bordered">
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
										<td><c:if test="${not empty qyxx.ZCZJ}">${qyxx.ZCZJ}万</c:if></td>
										<th>注册时间</th>
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
						</div>
					</div>
					<div class="row">
						<div class="col-md-12" id="winAdd">
							<div class="tabbable-custom">
								<ul class="nav nav-tabs">
								</ul>
								<div class="tab-content">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 是否是信用地图上的点击事件，跳转过来的页面，是的话，需要在新窗口打开，增加整体样式，页面上处理 -->
	<c:if test="${isOpen eq '1'}">
		<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
	</c:if>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/socialLegalPerson/socialLegalPersonDetail.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>