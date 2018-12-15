<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
	<style>
		.canvasClass{
			background-color: rgb(255,255,255);
		}
	</style>
<title>数据血缘</title>
</head>
<body style="background-color: #fff; width: 100%; overflow-x: hidden">
	<script type="text/javascript">
		parent.layer.load(1);
	</script>
	<input type="hidden" name="taskCode" id="tableCode" value="${tableCode}">
	<input type="hidden" name="showLog" id="showLog" value="${showLog}">
	<div class="row">
		<div class="col-md-12">
			<div class="portlet-body" style="margin: 15px;">
				<div class="tabbable-custom nav-justified">
					<ul class="nav nav-tabs nav-justified">
						<li class="active">
							<a href="#tab_1_1_1" data-toggle="tab">
								原始库到有效库 </a>
						</li>
						<li>
							<a href="#tab_1_1_2" data-toggle="tab">
								有效库到业务库 </a>
						</li>
					</ul>
					<div class="tab-content" style="padding: 5px !important;">
						<div class="tab-pane active" id="tab_1_1_1">
							<canvas id="canvas" class="canvasClass"></canvas>
						</div>
						<div class="tab-pane" id="tab_1_1_2">
							<canvas id="canvas2" class="canvasClass"></canvas>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/gov/dataReport/dataReportCetl.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/jtopo/jtopo-0.4.8-min.js"></script>
	
</body>
</html>