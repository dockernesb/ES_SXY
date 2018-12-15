<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>社会自然人</title>
<c:if test="${isOpen eq '1'}">
	<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
</c:if>
</head>
<body <c:if test="${isOpen eq '1'}">style="background:#fff"</c:if>>
	<input id="sfzh" name="sfzh" value="${grxx.SFZHSTR}" type="hidden" />
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-th-list"></i>自然人信用档案
					</div>
					<c:if test="${isOpen ne '1'}">
						<div class="tools">
							<a href="javascript:;" class="collapse"> </a>
						</div>
						<div class="actions">
							<a href="javascript:void(0);" onclick="sociaNaturalPerson.goBack();" class="btn btn-default">
								<i class="fa fa-rotate-left"></i> 返回
							</a>
						</div>
					</c:if>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<table class="table table-striped table-hover table-bordered">
								<tbody>
									<tr>
										<th width="10%">姓名</th>
										<td width="20%">${grxx.XM }</td>
										<th width="10%">身份证号</th>
										<td width="20%">${grxx.SFZH}</td>
									</tr>
									<tr>
										<th>性别</th>
										<td>${grxx.XB}</td>
										<th>民族</th>
										<td>${grxx.MZ}</td>
									</tr>
									<tr>
										<th>职业</th>
										<td>${grxx.ZYMC}</td>
										<th>出生日期</th>
										<td>${grxx.CSRQ}</td>
									</tr>
									<tr>
										<th>户籍地址</th>
										<td colspan="3">${grxx.HJDZ}</td>
									</tr>
								</tbody>
							</table>
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
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/socialNaturalPerson/socialNaturalPersonDetail.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>