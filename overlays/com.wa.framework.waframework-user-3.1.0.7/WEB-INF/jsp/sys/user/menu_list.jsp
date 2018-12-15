<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>菜单管理</title>
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>菜单列表
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
					    <shiro:hasPermission name="system.user.menu.add">
						<a href="javascript:void(0);" id="addMenuBtn" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 新增子菜单
						</a>
						<shiro:hasPermission name="system.user.menu.edit">
						</shiro:hasPermission>
						<a href="javascript:void(0);" id="editMenuBtn" class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i> 修改菜单
						</a>
						<shiro:hasPermission name="system.user.menu.delete">
						</shiro:hasPermission>
						<a href="javascript:void(0);" id="delMenuBtn" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除菜单
						</a>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="portlet-body">
					<div style="display: block; margin: 10px 15px;">
						<div class="row">
							<div class="col-sm-3">
								<div style="border: 1px solid #dedede; margin-top: 6px; background-color: #f9f9f9;overflow-x:hidden">
									<div style="margin: 15px 15px 0px 15px;">
										<input type="text" id="searchTree" class="form-control" placeholder="菜单搜索" />
										<div id="searchTreeMsg" style="margin-top: 15px; color: red;display: none;">暂无相关数据！</div>
									</div>
									<div id="menuTree" class="ztree" style="margin: 10px;overflow:auto"></div>
								</div>
							</div>
							<div class="col-sm-9">
								<table id="dataTable" class="table table-striped table-bordered table-hover">
									<thead>
										<tr role="row" class="heading">
											<th width="20%">菜单名称</th>
											<th width="40%">菜单URL</th>
											<th width="20%">图标</th>
											<th width="20%">优先级</th>
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
	</div>

	<div id="menuAddDiv" style="display: none; margin: 20px 40px;">
		<form id="menuAddForm" method="post" action="addMenu.action" class="form-horizontal">
			<input type="hidden" name="id" id="idAdd" />
			<input type="hidden" name="parentId" id="parentIdAdd" />
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label">父菜单名称</label>
					<div class="col-sm-9">
						<input class="form-control" id="currentNameAdd" name="currentName" readonly="readonly" />
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						子菜单名称
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="menuNameAdd" name="menuName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">子菜单URL</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="menuUrlAdd" name="menuUrl" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">图标样式</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="menuIconAdd" name="menuIcon" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						排列优先级
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="displayOrderAdd" name="displayOrder" />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div id="menuEditDiv" style="display: none; margin: 50px 40px;">
		<form id="menuEditForm" method="post" action="editMenu.action" class="form-horizontal">
			<input type="hidden" name="id" id="idEdit" />
			<input type="hidden" name="parentId" id="parentIdEdit" />
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						菜单名称
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="menuNameEdit" name="menuName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">菜单URL</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="menuUrlEdit" name="menuUrl" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">图标样式</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="menuIconEdit" name="menuIcon" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						排列优先级
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="displayOrderEdit" name="displayOrder" />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/sys/user/menu_list.js"></script>
</body>
</html>