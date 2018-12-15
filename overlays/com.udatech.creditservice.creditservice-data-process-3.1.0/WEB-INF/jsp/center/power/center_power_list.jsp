<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>行政权力目录管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-cogs"></i>行政权力目录
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<button class="btn btn-default btn-sm" id="export">
							<i class="glyphicon glyphicon-export"></i> 导出
						</button>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form id="form-search" class="form-inline">
								<input id="powerCodeCon"
									class="form-control input-md form-search" placeholder="权力编码">
								<input id="powerNameCon"
									class="form-control input-md form-search" placeholder="权力名称">
								 <select id="powerTypeCon"
									class="form-control input-md form-search" style="width: 200px;">
									<option value=""></option>
								</select> 
								<select id="deptCon"
								class="form-control input-md form-search" style="width: 200px;">
								<option value=""></option></select>
								<button type="button" class="btn btn-info btn-md form-search"
									onclick="power.conditionSearch();">
									<i class="fa fa-search"></i> 查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search"
									onclick="power.conditionReset();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>
							</form>
						</div>
					</div>
					<table id="dataTable"
						class="table table-striped table-bordered table-hover">
						<thead>
							<tr role="row" class="heading">
								<th class="table-checkbox">
									<input type="checkbox" class="icheck checkall">
								</th>
								<th width="15%">权力编码</th>
								<th width="20%">权力名称</th>
								<th width="15%">权力类别</th>
								<th width="15%">实施主体</th>
								<th width="10%">实施依据</th>
								<th width="25%">行政相对人类别</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<input type="hidden" id="ownerDeptId" value="${deptId}" />

	<div id="accordingDiv"
		style="display: none; margin: 30px 40px; height: 220px;">
		<textarea style="width: 100%; height: 100%;" id="accordingText" readonly></textarea>
	</div>
	
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/power/center_power_list.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>