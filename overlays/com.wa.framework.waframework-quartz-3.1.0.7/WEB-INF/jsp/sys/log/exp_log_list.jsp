<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>异常日志管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-globe"></i>异常日志列表
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<input id="conditionType" class="form-control form-search input-md" placeholder="类型" /> &nbsp;
								<input id="conditionMethodName" class="form-control form-search input-md" placeholder="错误方法" /> &nbsp;
							    <input type="text" class="form-control date-icon  form-search input-md" id="startDate" readonly="readonly" placeholder="开始时间"/> &nbsp;
							    <input type="text" class="form-control date-icon  form-search input-md" id="endDate" readonly="readonly" placeholder="结束时间"/> &nbsp;
								<button type="button" class="btn btn-info btn-md form-search" onclick="expLogger.conditionSearch();">
									<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="expLogger.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="logGrid">
						<thead>
							<tr class="heading">
								<th>类型</th>
								<th>错误方法</th>
								<th>记录时间</th>
								<th>详细信息</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
    <div id="infoDetail" style="display: none; margin: 10px 40px;">
         <p id="info"></p>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/log/exp_log_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>