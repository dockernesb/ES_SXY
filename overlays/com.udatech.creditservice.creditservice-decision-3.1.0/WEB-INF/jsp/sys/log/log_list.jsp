<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>日志管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-globe"></i><c:if test='${logType == 1}'>操作日志列表</c:if><c:if test='${logType == 0}'>登录日志列表</c:if>
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<input id="conditionUsername" class="form-control form-search input-md" placeholder="用户名" />
								&nbsp;
								<input id="conditionIp" class="form-control form-search input-md" placeholder="IP" />
								&nbsp;
								<input id="conditionAccessUrl" class="form-control form-search input-md" placeholder="URL" />
								&nbsp;
							    <input id="conditionAccessName" class="form-control form-search input-md" placeholder="功能名称" />
							    <br />
							    <input type="text" class="form-control date-icon  form-search input-md" id="startDate" readonly="readonly" placeholder="开始时间"/>
							    &nbsp;
							    <input type="text" class="form-control date-icon  form-search input-md" id="endDate" readonly="readonly" placeholder="结束时间"/>
							    &nbsp;
								<button type="button" class="btn btn-info btn-md form-search" onclick="logger.conditionSearch();">
									<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="logger.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="logGrid">
						<thead>
							<tr class="heading">
								<th>用户名</th>
								<th>IP</th>
								<th>URL</th>
								<th>功能名称</th>
								<th>记录时间</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	    var logType = '${logType}';
	</script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/log/log_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>