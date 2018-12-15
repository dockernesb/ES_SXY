<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>资源库管理</title>
<style type="text/css">
.ztree li a.level0 {
	/* 	width: 200px; */
	height: 34px;
	text-align: left;
	padding-left: 20px;
	display: block;
	background-color: #eee;
	border: 1px solid #ddd;
	text-decoration: none;
	margin-bottom: 2px;
}

.ztree li ul.level0 {
	display: block;
	padding: 5px 0 5px 18px;
}

.ztree li a.level0.cur {
	background-color: #ddd;
}

.ztree li a.level0 span {
	display: block;
	padding: 9px 0;
	font-size: 14px;
	line-height: 1em;
	word-spacing: 2px;
}

.ztree li a.level0 span.button {
	float: right;
	margin-left: 10px;
	visibility: visible;
	display: none;
}

.ztree li span.button.switch.level0 {
	display: none;
}
</style>
</head>
<body>
	<div class="row" id="templateRow">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">资源库管理</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" onclick="creditTheme.addTheme();" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 新建资源
						</a>
						<a href="javascript:void(0);" onclick="creditTheme.editTheme();" id="btn_edit" class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i> 编辑资源
						</a>
						<a href="javascript:void(0);" onclick="creditTheme.deleteConfirm();" id="btn_del" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除资源
						</a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-3 col-sm-3">
							<div style="min-height: 400px;">
								<div id="themeTree" class="ztree"></div>
							</div>
						</div>
						<div class="col-md-9 col-sm-9">
							<div class="row">
								<div class="col-md-12" style="padding-bottom: 5px;">
									<button type="button" class="btn blue" style="position: relative; top: 4px;"
										onclick="creditTheme.saveColumns();">保存字段</button>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<table class="table table-striped table-hover table-bordered" id="themeColumnGrid">
										<thead>
											<tr class="heading">
												<th class="table-checkbox"><input type="checkbox" id="checkall" class="icheck"></th>
												<th width="15%">字段名称</th>
												<th>字段描述</th>
												<th width="15%">字段别名</th>
												<th style="width: 60px;">显示顺序</th>
												<th style="width: 130px;">选择排序字段</th>
												<th style="width: 90px;">操作</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
	</div>

	<div id="addDiv" style="display: none; margin: 20px 40px;">
		<form id="addForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 资源名称:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="typeName" name="typeName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 资源类型:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<div class="radio-list">
								<div class="input-icon right">
									<i class="fa"></i>
									<div class="input-group">
										<div class="icheck-inline">
											<label> <input type="radio" name="type" id="first" value="1" class="icheck"> 一级
											</label> <label> <input type="radio" name="type" value="2" class="icheck"> 二级
											</label>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 资源用途:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="zyyt" name="zyyt" style="width: 100%;"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"> 父级资源:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="parentTheme" name="parentId" style="width: 100%;" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"> 数据源:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="dataSource" name="dataSource" style="width: 100%;" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"> 数据表:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="dataTable" name="dataTable" style="width: 100%;" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 顺序:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="displayOrder" name="displayOrder" />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div id="editDiv" style="display: none; margin: 20px 40px;">
		<form id="editForm" method="post" class="form-horizontal">
			<input type="hidden" id="id" name="id"> <input type="hidden" id="parentId_edit" name="parentId">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 资源名称:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="typeName_edit" name="typeName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 资源类型:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<div class="radio-list">
								<div class="input-icon right">
									<i class="fa"></i>
									<div class="input-group">
										<div class="icheck-inline">
											<label> <input type="radio" id="first_edit" name="type" value="1" class="icheck"> 一级
											</label> <label> <input type="radio" id="second_edit" name="type" value="2" class="icheck"> 二级
											</label>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 资源用途:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="zyyt_edit" name="zyyt" style="width: 100%;"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"> 父级资源:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="parentTheme_edit" name="parentTheme" style="width: 100%;" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"> 数据源:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="dataSource_edit" name="dataSource" style="width: 100%;" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"> 数据表:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" id="dataTable_edit" name="dataTable" style="width: 100%;" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 顺序:</label>
					<div class="col-md-8 col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="displayOrder_edit" name="displayOrder" />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/resourceManage/theme.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>