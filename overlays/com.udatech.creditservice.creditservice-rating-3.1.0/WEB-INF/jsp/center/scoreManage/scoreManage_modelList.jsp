<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>评分模型模板</title>
</head>
<body>
<div id="fatherDiv">

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						评分模型模板
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" id="addBtn"
							class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i>
							新增模型
						</a>
						<a href="javascript:void(0);" id="editBtn"
							class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i>
							编辑模型
						</a>
						<a href="javascript:void(0);" id="delBtn"
							class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i>
							删除模型
						</a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form id="form-search" class="form-inline">
								<input id="mxbh" class="form-control input-md form-search" style="width: 160px;"
									placeholder="模型编号">
								&nbsp;
								<input id="mxmc" class="form-control input-md form-search" style="width: 160px;"
									placeholder="模型名称">
								&nbsp;
								<input id="cjr" class="form-control input-md form-search" style="width: 160px;"
									placeholder="创建人" style="text-transform: uppercase;">
								&nbsp;
								<input id="cjsjs"
									class="form-control input-md form-search date-icon" style="width: 160px;"
									placeholder="创建时间始" readonly="readonly">
								&nbsp;
								<input id="cjsjz"
									class="form-control input-md form-search date-icon" style="width: 160px;"
									placeholder="创建时间止" readonly="readonly">
								&nbsp;
								<button type="button" class="btn btn-info btn-md form-search"
									onclick="smml.conditionSearch();">
									<i class="fa fa-search"></i>
									查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search"
									onclick="smml.conditionReset();">
									<i class="fa fa-rotate-left"></i>
									重置
								</button>
							</form>
						</div>
					</div>
					<table id="dataTable"
						class="table table-striped table-bordered table-hover">
						<thead>
							<tr role="row" class="heading">
								<th>模型编号</th>
								<th>模型名称</th>
								<th>创建人</th>
								<th>创建时间</th>
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
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/scoreManage/scoreManage_modelList.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</div>
<div id="childDiv" style="display:none">
</div>
</body>
</html>