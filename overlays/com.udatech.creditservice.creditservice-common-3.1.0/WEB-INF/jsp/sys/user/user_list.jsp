<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="icon-user"></i>用户列表
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" onclick="user.onAddUser();" class="btn btn-default btn-sm"><i class="fa fa-plus"></i>  新增用户</a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<input id="conditionName" class="form-control input-md" placeholder="用户名"/>&nbsp;
								<input id="conditionRealName" class="form-control input-md" placeholder="真实姓名"/>&nbsp;
								<input id="conditionDepart" class="form-control input-md" placeholder="所属部门" />&nbsp;
								<select id="conditionStatus" class="form-control input-md" style="width: 10%">
									<option value="">全部</option>
									<option value="1">启用</option>
									<option value="0">禁用</option>
								</select>&nbsp;
								<select id="conditionType" class="form-control input-md" style="width: 10%">
									<option value="">用户类型</option>
									<option value="4">全部类型</option>
									<option value="0">管理员</option>
									<option value="1">中心端</option>
									<option value="2">业务端</option>
									<option value="3">政务端</option>
								</select>&nbsp;&nbsp;
								<button type="button" class="btn btn-info btn-md" onclick="user.conditionSearch(1);">
									<i class="fa fa-search"></i> 查询
								</button>
								&nbsp;
								<button type="button" class="btn btn-default btn-md" onclick="user.conditionReset();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="userGrid" style="width: 100%">
						<thead>
							<tr class="heading">
								<th style="width: 3%;min-width: 40px;"></th>
 								<th style="width: *;">用户名</th>
								<th style="width: 27%;">所属部门</th>
								<th style="width: 12%;">用户类型</th>
								<th style="width: 7%;">状态</th>
								<th style="width: 25%;">操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 10px 40px;">
		<form id="addUserForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>用户类型</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" name="type" id="type" style="width: 100%">
								<option value="0">管理员</option>
								<option value="1">中心端</option>
								<option value="2">业务端</option>
								<option value="3">政务端</option>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>部门</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" name="departmentId" id="departmentId" style="width: 100%">
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>用户名</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="username"  />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>密码</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="password" type="password" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>真实姓名</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="realName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>性别</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" name="gender" id="gender" style="width: 100%">
								<option value="0">女</option>
								<option value="1" selected>男</option>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3">身份证号</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="idCard" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>联系电话</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
						<input class="form-control" name="phoneNumber" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>Email</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input type="text" class="form-control" name="email" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>地址</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="address" />
						</div>
					</div>
				</div>
				<div class="form-group" style="display: none;">
					<label class="control-label col-md-3"><span class="required"> * </span>状态</label>
					<div class="col-sm-2">
						<input type="checkbox" checked class="make-switch" name="enabled" data-size="small" />
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="winEdit" style="display: none; margin: 10px 40px;">
		<form id="editUserForm" method="post" class="form-horizontal">
			<input type="hidden" name="userId" id="userId" value="">
			<input type="hidden" name="username" id="username" value="">
			<div class="form-body">
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>用户类型</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" name="type" id="editType" style="width: 100%">
								<option value="0">管理员</option>
								<option value="1">中心端</option>
								<option value="2">业务端</option>
								<option value="3">政务端</option>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>部门</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" name="departmentId" id="editDepartmentId" style="width: 100%">
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>真实姓名</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="editRealName" name="realName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>性别</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<select class="form-control" name="gender" id="editGender" style="width: 50%">
								<option value="0">女</option>
								<option value="1" selected>男</option>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3">身份证号</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="editIdCard" name="idCard" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>联系电话</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
						<input class="form-control" id="editPhoneNumber" name="phoneNumber" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>Email</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input type="text" class="form-control" id="editEmail" name="email" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>地址</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="editAddress" name="address" />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="winGrant" style="display: none; margin: 10px 40px;">
		<form id="grantUserForm" method="post" class="form-horizontal">
			<input type="hidden" name="userId" id="grantUserId" value="">
			<input type="hidden" name="privilegeIds" id="privilegeIds" value="">
			<input type="hidden" name="roleIds" id="roleIds" value="">
			<div class="col-sm-6">
				<b style="padding: 0px;">用户角色：</b>
			</div>
			<div class="col-sm-6">
				<b style="padding: 0px;">额外添加权限：</b>
			</div>
			<div class="col-sm-6">
				<table id="editRoleGrid" class="table table-striped table-bordered table-hover">
					<thead>
						<tr role="row" class="heading">
							<th>
								<input type="checkbox" id="chkall" class="icheck">
							</th>
							<th width="40%">角色</th>
							<th width="52%">描述</th>
						</tr>
					</thead>
				</table>
			</div>
			<div class="col-sm-6">
				<div style="border: 1px solid #dedede; margin-top: 6px; background-color: #f9f9f9;">
					<div id="editPrivilegeTree" class="ztree" style="margin: 10px"></div>
				</div>
			</div>
			<input type="hidden" name="userType" id="userType" value="${sysUser.type}">
		</form>
	</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/user/user_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>