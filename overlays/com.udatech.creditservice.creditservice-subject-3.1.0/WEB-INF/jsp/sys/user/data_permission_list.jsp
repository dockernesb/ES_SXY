<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据权限管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>数据权限列表
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
					    <shiro:hasPermission name="system.user.datapermission.edit">
						<a href="javascript:void(0);" id="addAccessBtn"  onclick="dataPermission.saveOrUpdate()" class="btn btn-default btn-sm"> <i
							class="fa fa-comfirm"></i> 保存配置
						</a> 
						</shiro:hasPermission>
					</div>
				</div>
				<div class="portlet-body">
					<div style="display: block; margin: 10px 15px;">
						<div class="row">
							<div class="col-sm-3">
								<div style="border: 1px solid #dedede; margin-top: 6px; background-color: #f9f9f9;">
									<div style="margin: 15px 15px 0px 15px;">
										<input type="text" id="searchTree" class="form-control" placeholder="数据权限搜索" />
										<div id="searchTreeMsg" style="margin-top: 15px; color: red; display: none;">暂无相关数据！</div>
									</div>
									<div id="menuTree" class="ztree" style="margin: 10px"></div>
								</div>
							</div>
							<div class="col-sm-9">
									<div style='margin-top:15px'>
							                 <form id="formEdit" method="post">
							                     <input type="hidden" name="id" id="id">
							                     <input type="hidden" name="menuId" id="menuId">
														<div class="form-group">
															<label class="control-label col-md-2">菜单名称</label>
															<div class="col-sm-10">
																<div class="input-icon right">
																	<i class="fa"></i>
																	<input class="form-control"  name="menuName" id="menuName" readonly = readonly />
																</div>
															</div>
														</div>
														<div class="form-group" style="padding-top:60px">
															<label class="control-label col-md-2">过滤条件</label>
															<div class="col-sm-10">
																<div class="input-icon right">
																	<i class="fa"></i>
																	 <textarea class="form-control" rows="6" maxlength="2000" id="dataFilter" name="dataFilter" style="height: 160px;max-height: 160px;"></textarea>
																</div>
															</div>
														</div>
														<div class="form-group" style="padding-top:175px">
															<label class="control-label col-md-2">备注说明</label>
															<div class="col-sm-10">
																<div class="input-icon right">
																	<i class="fa"></i>
																	 <textarea  class="form-control"  rows="6" maxlength="500" id="description" name="description" style="height: 160px;max-height: 160px;"></textarea>
																</div>
															</div>
														</div>
														<div style="clear:both"></div>
							                 </form>
            						</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/sys/user/data_permission_list.js"></script>
</body>
</html>