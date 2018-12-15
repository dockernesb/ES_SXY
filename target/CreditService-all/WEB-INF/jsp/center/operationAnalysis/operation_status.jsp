<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>数据质量统计</title>
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						数据质量统计
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class=""
						style="margin: 5px 60px 10px 60px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline">
							开始日期：
							<input type="text" class="form-control date-icon" id="startDate" readonly="readonly" />
							&nbsp;结束日期：
							<input type="text" class="form-control date-icon" id="endDate" readonly="readonly" />
							&nbsp;
							<button type="button" id="searchBtn" class="btn btn-info btn-md">查询</button>
						</form>
					</div>
					<div class="col-md-6">
						<div class="dataQualityPie" id="dataQualityPie" style="width: 100%; height: 450px;"></div>
					</div>
					<div class="col-md-6">
						<div class="dataTypePie" id="dataTypePie" style="width: 100%; height: 450px;"></div>
					</div>
					<div style="height: 50px; clear: both;"></div>
					<div class="dataQualityBar" id="dataQualityBar"
						style="width: 100%; height: 450px; margin-bottom: 20px;"></div>
					<div style="margin: 0px 60px 60px 60px;">
						<table id="dataTable" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
									<th>部门名称</th>
									<th>处理数据量</th>
									<th>正确数据量</th>
									<th>错误数据量</th>
									<th>正确率</th>
									<th>错误率</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/statisAnalyze/data_quality.js"></script>

</body>
</html>