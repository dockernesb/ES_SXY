<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>部门管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-globe"></i>部门管理
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" onclick="dept.addRootDepartment();" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 增加部门
						</a>
						<a href="javascript:void(0);" onclick="dept.editDepartment();" class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i> 修改部门
						</a>
						<a href="javascript:void(0);" onclick="dept.deleteConfirm();" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除部门
						</a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<input id="deptCode" class="form-control input-md" placeholder="部门编码" /> &nbsp; <input id="deptName" class="form-control input-md" placeholder="部门名称" /> &nbsp;
								<button type="button" class="btn btn-info btn-md" onclick="dept.conditionSearch(1);">
									<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md" onclick="dept.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="departmentGrid">
						<thead>
							<tr class="heading">
								<th>部门编码</th>
								<th>部门名称</th>
								<th width="20%">描述</th>
								<th>创建者</th>
								<th>创建时间</th>
								<th>最后更新者</th>
								<th>最后更新时间</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 30px 40px">
		<form id="addDepartmentForm" method="post" class="form-horizontal">
			<input type="hidden" name="parentId" id="parentId" value="ROOT">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 部门编码:</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="code" name="code" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 部门名称:</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="departmentName" name="departmentName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">描述:</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="description" name="description" rows="4"></textarea>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="winEdit" style="display: none; margin: 30px 40px;">
		<form id="editDepartmentForm" method="post" class="form-horizontal">
			<input type="hidden" name="id" id="departmentId_edit" value="">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 部门编码:</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="code_edit" name="code" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 部门名称:</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="departmentName_edit" name="departmentName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">描述:</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="description_edit" name="description" rows="4"></textarea>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/user/department_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>