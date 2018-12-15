<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${rsa}/admin/pages/css/profile.css" rel="stylesheet" type="text/css"/>
<title>个人中心</title>
<style type="text/css">
td {
	height: 50px !important;
	font-size: 15px;
}
</style>
</head>
<body>
	<div class="row">
		<div class="col-md-3">
			<div class="profile-sidebar">
				<div class="portlet light profile-sidebar-portlet">
					<div class="profile-userpic">
						<img src="${pageContext.request.contextPath}/common/viewImg.action?path=${userPhotoPath}" class="img-responsive userPhoto" alt="">
					</div>
					<div class="profile-usertitle">
						<div class="profile-usertitle-name">${user.username}</div>
					</div>
					<div style="text-align: center;margin-top: 15px;">
						<button type="button" class="btn btn-circle green btn-xs upload-img" id="uploadImg" >&nbsp;修改头像&nbsp;</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-9">
			<div class="portlet light ">
				<div class="portlet-title">
					<div class="caption caption-md">
						<span style="font-size: 20px;">基本信息</span>
					</div>
					<div class="actions">
						<div>
							<button type="button" class="btn btn-circle green btn-xs"  onclick="personalCenter.onEditUser();"> &nbsp;编辑资料&nbsp; </button>
						</div>
					</div>
				</div>
				<div class="portlet-body">
					<div class="table-scrollable table-scrollable-borderless">
						<table class="table table-hover table-light">
						   <tr>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">姓名</td>
								<td class="col-md-4">${user.realName}</td>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">性别</td>
								<td class="col-md-4">
									<c:if test="${user.gender == true}">
										男
									</c:if>
									<c:if test="${user.gender == false}">
										女
									</c:if>
								</td>
							</tr>
							<tr>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">身份证号</td>
								<td class="col-md-4">${user.idCard}</td>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">Email</td>
								<td class="col-md-4">${user.email}</td>
							</tr>
							<tr>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">部门</td>
								<td class="col-md-4">${user.sysDepartment.departmentName}</td>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">联系电话</td>
								<td class="col-md-4">${user.phoneNumber}</td>
							</tr>
							<tr>
								<td class="col-md-2" style="font-weight: bold;text-align: center;">地址</td>
								<td class="col-md-10" colspan="3">${user.address}</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="winEdit" style="display: none; margin: 10px 40px;">
		<form id="editUserForm" method="post" class="form-horizontal">
			<input type="hidden" name="id" id="userId" value="${user.id}">
			<input type="hidden" name="oldGender" id="oldGender" value="${user.gender}">
			<div class="form-body">
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required"> * </span>姓名</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="editRealName" name="realName"  value="${user.realName}"/>
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
					<label class="control-label col-md-3"><span class="required">  </span>身份证号</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="editIdCard" name="idCard" value="${user.idCard}"/>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>Email</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
							<input type="text" class="form-control" id="editEmail" name="email" value="${user.email}"/>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>联系电话</label>
					<div class="col-sm-6">
						<div class="input-icon right">
							<i class="fa"></i>
						<input class="form-control" id="editPhoneNumber" name="phoneNumber" value="${user.phoneNumber}"/>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3"><span class="required">   </span>地址</label>
					<div class="col-sm-9">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="editAddress" name="address" value="${user.address}"/>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/user/personalCenter.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>
