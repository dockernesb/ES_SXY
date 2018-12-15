<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>信用报告操作记录</title>
</head>
<body>
	<!-- 跳转到本页面的来源页面：1法人报告查询，2自然人报告查询 -->
	<input type="hidden" id="skipType" value="${skipType }">
	
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i> 信用报告操作记录
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
				<button type="button" class="btn btn-default"  onclick="reportOperationLog.goBack();">
					<i class="fa fa-rotate-left"></i> 返回
				</button>
			</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12 col-sm-12">
							<table id="dataTable" class="table table-striped table-bordered table-hover ">
								<thead>
									<tr role="row" class="heading">
										<th>序号</th>
										<th>业务类型</th>
										<th>业务办理人</th>
										<th>业务办理时间</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

   <script type="text/javascript" >
	var applyId = '${applyId}';
	</script>

	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/creditReportQuery/report_operation_log.js"></script>
</body>
</html>