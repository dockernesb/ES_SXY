<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${cnlbName}承诺列表</title>
</head>
<body>
<div id="childTopBox">
<div id="child_fatherDiv">
	<input type="hidden" name="cnlb" id="cnlb" value="${cnlb}" />
	<input type="hidden" name="deptId" id="deptId" value="${deptId}" />
	<div class="portlet box red-intense">
		<div class="portlet-title">
			<div class="caption">
				<i class="fa fa-cogs"></i>${cnlbName}承诺列表
			</div>
			<div class="tools" style="padding-left: 5px;">
				<a href="javascript:void(0);" class="collapse"></a>
			</div>
			<div class="actions">
				<button type="button" onclick="promiseAddEnter.manualAdd();" class="btn btn-default btn-sm">
					<i class="glyphicon glyphicon-pencil"></i>
					手动录入
				</button>
				<button type="button" onclick="" class="btn btn-default btn-sm upload-file">
					<i class="glyphicon glyphicon-import"></i>
					批量导入
				</button>
				<button type="button" onclick="promiseAddEnter.templateDownload();"
					class="btn btn-default btn-sm">
					<i class="glyphicon glyphicon-save"></i>
					下载模板
				</button>
				<button type="button" class="btn btn-default" onclick="promiseAddEnter.goback();">返回</button>
			</div>
		</div>
		<div class="portlet-body">
			<div class="col-md-12">
				<form class="form-inline" id="searchForm">
					<div class="row">
						<input id="searchQymc" class="form-control input-md form-search" placeholder="企业名称" />
						<input id="searchGszch" class="form-control input-md form-search" placeholder="工商注册号" />
						<input id="searchZzjgdm" class="form-control input-md form-search" placeholder="组织机构代码" />
						<input id="searchTyshxydm" class="form-control input-md form-search" placeholder="统一社会信用代码" />
						<input id="startDate" name="startDate" class="form-control input-md form-search date-icon"
							placeholder="导入时间始" readonly="readonly" />
						<input id="endDate" name="endDate" class="form-control input-md form-search date-icon"
							placeholder="导入时间止" readonly="readonly" />
						<select id="searchStatus" name="searchStatus" class="form-control input-md form-search"
							style="width: 17%">
							<option value=" ">全部</option>
							<option value="0">未列入</option>
							<option value="1">已列入</option>
							<option value="2">已过期</option>
						</select>
						<button type="button" class="btn btn-info btn-md form-search"
							onclick="promiseAddEnter.conditionSearch(1);">
							<i class="fa fa-search"></i>
							查询
						</button>
						<button type="button" class="btn btn-default btn-md form-search"
							onclick="promiseAddEnter.conditionReset();">
							<i class="fa fa-rotate-left"></i>
							重置
						</button>
					</div>
				</form>
				<div class="row">
					<table class="table table-striped table-hover table-bordered" id="enterGrid"
						style="width: 100%;">
						<thead>
							<tr class="heading">
								<th style="width: 20%;">企业名称</th>
								<th style="width: 13%;">工商注册号</th>
								<th style="width: 13%;">组织机构代码</th>
								<th style="width: 12%;">统一社会信用代码</th>
								<th style="width: 10%;">导入时间</th>
								<th style="width: 10%;">承诺附件</th>
								<th style="width: 9%;">黑名单状态</th>
								<th style="width: 13%;">操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="form-actions">
				<div class="row">
					<div class="col-md-12 text-center"></div>
				</div>
			</div>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 10px 40px;">
		<form id="addEnterForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="control-label col-md-4">
						<span class="required">* </span>
						企业名称
					</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="qymc" id="qymc" maxlength="30" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4"> 组织机构代码 </label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="zzjgdm" id="zzjgdm" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4"> 工商注册号 </label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="gszch" id="gszch" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4"> 统一社会信用代码 </label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="shxydm" id="shxydm" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="alert alert-warning" style="margin-left: 10px;">
					<i class="fa fa-warning"></i>
					提示：统一社会信用代码必填，若没有请填写组织机构代码和工商注册号。
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/sszjpromise/sszj_promise_qy_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</div>
<div id="child_childDiv" style="display:none">
</div>
</div>
</body>
</html>
