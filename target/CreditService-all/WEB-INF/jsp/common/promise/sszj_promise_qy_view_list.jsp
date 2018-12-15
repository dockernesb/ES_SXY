<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>信用承诺查询</title>
</head>
<body>
<div id="childTopBox">
<div id="child_fatherDiv">
	<div class="portlet box red-intense">
		<div class="portlet-title">
			<div class="caption">
				<i class="fa fa-cogs"></i>信用承诺查询
			</div>
			<div class="tools" style="padding-left: 5px;">
				<a href="javascript:void(0);" class="collapse"></a>
			</div>
			<div class="actions">
			</div>
		</div>
		<div class="portlet-body">
			<div class="col-md-12">
				<form class="form-inline" id="searchForm">
					<div class="row">
						<input id="searchQymc" class="form-control input-md form-search" placeholder="企业名称" />
						<input id="searchTyshxydm" class="form-control input-md form-search" placeholder="统一社会信用代码" />
						<input id="searchZzjgdm" class="form-control input-md form-search" placeholder="组织机构代码" />
						<input id="searchGszch" class="form-control input-md form-search" placeholder="工商注册号" />
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
						<select id="jgbmId" class="form-control input-md form-search">
							<option value=""></option>
						</select>
						<select id="cnlbKey" class="form-control input-md form-search" style="width: 200px;">
						</select>
						<button type="button" class="btn btn-info btn-md form-search"
							onclick="promiseAddEnter.conditionSearch();">
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
								<th style="width: 15%;">企业名称</th>
								<th style="width: 11%;">统一社会信用代码</th>
								<th style="width: 11%;">组织机构代码</th>
								<th style="width: 11%;">工商注册号</th>
								<th style="width: 8%;">导入时间</th>
								<th style="width: 8%;">承诺类别</th>
								<th style="width: 8%;">监管部门</th>
								<th style="width: 10%;">承诺附件</th>
								<th style="width: 7%;">黑名单状态</th>
								<th style="width: 11%;">操作</th>
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

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/sszjpromise/sszj_promise_qy_view_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</div>
<div id="child_childDiv" style="display:none">
</div>
</div>
</body>
</html>
