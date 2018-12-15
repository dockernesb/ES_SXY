<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title>
<script type="text/javascript">
var hasEditPerm = 0;
var hasDeletePerm = 0;
</script>
</head>
<style type="text/css">
table {table-layout:fixed;}
th{overflow:hidden;word-break:keep-all;text-align: center;}
td{white-space:nowrap;overflow:hidden;word-break:keep-all;text-overflow: ellipsis;text-align: center;}
</style>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="icon-user"></i>角色列表
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
					    <shiro:hasPermission name="system.user.role.add">
						<a href="javascript:void(0);" onclick="role.onAddRole();" class="btn btn-default btn-sm"><i class="fa fa-plus"></i>  新增角色</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.user.user.grant">
						    <script type="text/javascript">
						    	hasEditPerm = 1;
						    </script>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.user.role.delete">
						    <script type="text/javascript">
						    	hasDeletePerm = 1;
						    </script>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="portlet-body">
					<table class="table table-striped table-hover table-bordered" id="roleGrid" style="width: 100%;">
						<thead>
							<tr class="heading">
								<th>角色名称</th>
								<th>描述</th>
								<th>创建者</th>
								<th>创建时间</th>
								<th>更新者</th>
								<th>更新时间</th>
								<th>操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 10px 40px;">
		<form id="roleAddForm" method="post" class="form-horizontal">
        	<input type="hidden" name="privilegeIds" id="addPrivilegeIds" value="">
			<div class="form-group">
					<label class="control-label col-md-2"><span class="required"> * </span>角色</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="roleName" />
						</div>
					</div>
				</div>
			<div class="form-group">
					<label class="control-label col-md-2"><span class="required">   </span>描述</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" name="description" rows="3" ></textarea>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-2">角色权限</label>
					<div class="col-sm-9" >
						<div style="border: 1px solid #dedede; margin-top: 6px; background-color: #f9f9f9;">
						<div id="addPrivilegeTree" class="ztree" style="margin: 10px"></div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="winEdit" style="display: none; margin: 10px 40px;">
		<form id="roleEditForm" method="post" class="form-horizontal">
        	<input type="hidden" name="privilegeIds" id="editPrivilegeIds" value="">
        	<input type="hidden" name="roleId" id="roleId" value="">
			<div class="form-group">
					<label class="control-label col-md-2"><span class="required"> * </span>角色</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="roleName" name="roleName" />
						</div>
					</div>
				</div>
			<div class="form-group">
					<label class="control-label col-md-2"><span class="required">   </span>描述</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="description" name="description" rows="3"></textarea>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-2">角色权限</label>
					<div class="col-sm-9" >
						<div style="border: 1px solid #dedede; margin-top: 6px; background-color: #f9f9f9;">
						<div id="editPrivilegeTree" class="ztree" style="margin: 10px"></div>
					</div>
				</div>
			</div>
		</form>
	</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/user/role_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>