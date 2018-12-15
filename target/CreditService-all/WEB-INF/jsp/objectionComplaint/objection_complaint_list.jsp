<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>异议申诉查询</title>
</head>
<body>
<div id="topDiv">
<div id="mainListDiv">

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						异议申诉查询
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form id="form-search" class="form-inline">
								<input id="bjbh" class="form-control input-md form-search" placeholder="办件编号">
								<input id="name" class="form-control input-md form-search" placeholder="申诉人姓名">
								<input id="jsz" class="form-control input-md form-search" placeholder="驾驶证号">
								<input id="beginDate" class="form-control input-md form-search date-icon"
									placeholder="申诉时间始" readonly="readonly">
								<input id="endDate" class="form-control input-md form-search date-icon" placeholder="申诉时间止"
									readonly="readonly">
								<button type="button" class="btn btn-info btn-md form-search"
									onclick="hol.conditionSearch();">
									<i class="fa fa-search"></i>
									查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search"
									onclick="hol.conditionReset();">
									<i class="fa fa-rotate-left"></i>
									重置
								</button>
							</form>
						</div>
					</div>
					<table id="dataTable" class="table table-striped table-bordered table-hover">
						<thead>
							<tr role="row" class="heading">
								<th>办件编号</th>
								<th>申诉人姓名</th>
								<th>驾驶证号</th>
								<th>联系手机</th>
								<th>申诉时间</th>
								<th>状态</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="columnTogglerContent" class="btn-group hide pull-right">
		<a class="btn green" href="javascript:;" data-toggle="dropdown">
			列信息
			<i class="fa fa-angle-down"></i>
		</a>
		<div id="dataTable_column_toggler"
			class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
			<label>
				<input type="checkbox" class="icheck" checked data-column="0">
				办件编号
			</label>
			<label>
				<input type="checkbox" class="icheck" checked data-column="1">
				申诉人姓名
			</label>
			<label>
				<input type="checkbox" class="icheck" checked data-column="2">
				驾驶证号
			</label>
			<label>
				<input type="checkbox" class="icheck" checked data-column="3">
				联系手机
			</label>
			<label>
				<input type="checkbox" class="icheck" checked data-column="4">
				申诉时间
			</label>
			<label>
				<input type="checkbox" class="icheck" checked data-column="5">
				状态
			</label>
		</div>
	</div>

</div>
<div id="applyDetailDiv" style="display:none">
</div>
</div>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/objectionComplaint/objection_complaint_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>