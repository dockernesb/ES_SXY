<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>权限管理</title>
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>权限列表
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
					    <shiro:hasPermission name="system.user.access.add">
						<a href="javascript:void(0);" id="addAccessBtn" class="btn btn-default btn-sm"> <i class="fa fa-plus"></i> 新增功能权限</a> 
						</shiro:hasPermission>
						<shiro:hasPermission name="system.user.access.edit">
						<a href="javascript:void(0);" id="editAccessBtn" class="btn btn-default btn-sm"> <i class="fa fa-edit"></i> 修改功能权限</a> 
						</shiro:hasPermission>
						<shiro:hasPermission name="system.user.access.delete">
						<a href="javascript:void(0);" id="delAccessBtn" class="btn btn-default btn-sm"> <i class="fa fa-minus"></i> 删除功能权限</a>
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
										<div id="searchTreeMsg" style="margin-top: 15px; color: red; display: none;">暂无相关数据！</div>
									</div>
									<div id="menuTree" class="ztree" style="margin: 10px;overflow:auto"></div>
								</div>
							</div>
							<div class="col-sm-9">
								<table id="dataTable" class="table table-striped table-bordered table-hover">
									<thead>
										<tr role="row" class="heading">
											<th width="30%">功能权限名称</th>
											<th width="30%">功能权限编码</th>
											<th width="35%">说明</th>
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

	<div id="accessAddDiv" style="display: none; margin: 10px 40px;">
		<form id="accessAddForm" method="post" action="addAccess.action" class="form-horizontal">
			<input type="hidden" name="menuId" id="menuIdAdd">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"> <span class="required">*</span> 功能权限编码
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="privilegeCodeAdd" name="privilegeCode" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"> <span class="required">*</span> 功能权限名称
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="privilegeNameAdd" name="privilegeName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"> 说明描述 </label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="descriptionAdd" name="description" rows="4"></textarea>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div id="accessEditDiv" style="display: none; margin: 10px 40px;">
		<form id="accessEditForm" method="post" action="editAccess.action" class="form-horizontal">
			<input type="hidden" name="privilegeId" id="privilegeIdEdit" /> <input type="hidden"
				name="editMenuId" id="menuIdEdit" />
			<input type="hidden" name="privilegeOldName" id="privilegeOldName"></input>
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"> <span class="required">*</span> 功能权限编码
					</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="privilegeCodeEdit" name="privilegeCode" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"> <span class="required">*</span>功能权限名称</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="privilegeNameEdit" name="privilegeName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"> 说明描述 </label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="descriptionEdit" name="description" rows="4"></textarea>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/sys/user/access_list.js"></script>
</body>
</html>