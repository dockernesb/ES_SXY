<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上报/维护信息</title>
</head>
<body>
	<input type="hidden" name="codeList" id="codeList" value='${codeList}'>
	<input type="hidden" name="nameList" id="nameList" value='${nameList}'>
	<input type="hidden" name="nameList" id="nameList" value='${tableColumList}'>
	<input type="hidden" name="templateFilePath" id="templateFilePath" value='${templateFilePath}'>
	<input type="hidden" name="typeList" id="typeList" value='${typeList}'>
	<input type="hidden" name="rulesList" id="rulesList" value='${rulesList}'>
	<input type="hidden" name="requiredGroupList" id="requiredGroupList" value='${requiredGroupList}'>
	<input type="hidden" name="tableId" id="tableId" value="${tableId}">
	<input type="hidden" name="errorTaskCode" id="errorTaskCode" value="${errorTaskCode}">
	<input type="hidden" name="taskCode" id="taskCode" value="${taskCode}">
	<input type="hidden" id="choseTitle" value="${choseTitle}" />
	<input type="hidden" id="deptId" value="${deptId}" />
	<input type="hidden" id="versionId" value="${versionId}" />
	<input type="hidden" id="uploadTableHasData" value="0" />
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense" id="errorData">
				<div class="portlet-title">
					<div class="caption">
						<i class="glyphicon glyphicon-open"></i>疑问数据 | ${reportName}
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<button class="btn btn-default btn-sm" type="button" onclick="errorDetailInfo.goBack();">
							<i class="fa fa-rotate-left"></i> 返回
						</button>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<input id="error_reportBatch" class="form-control input-md form-search" placeholder="上报批次编号"/>
								<span id="queryCoulmnLabel">
									<select id="error_tableCoulmnName"  class="form-control input-md form-search">
										<option value=" ">不限</option>
										<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
											<option value="${tableColum.CODE}">${tableColum.NAME}</option>
										</c:forEach>
									</select>
									<input id="error_tableCoulmnNameValue" class="form-control input-md form-search" disabled placeholder="查询内容"/>
								</span>
								<input id="error_startDate" class="form-control input-md form-search date-icon" placeholder="更新时间始" readonly="readonly">
								<input id="error_endDate" class="form-control input-md form-search date-icon" placeholder="更新时间止" readonly="readonly">
								<br>
								<select
									class="form-control input-md form-search" id="error_departmentDetail"></select>
								<select id="error_reportWay" class="form-control input-md form-search">
								</select>
								<select id="errorDataStatus" class="form-control input-md form-search">
									<option value=" ">全部状态</option>
									<option value="0">未处理</option>
									<option value="4">已修改</option>
									<option value="1">已处理</option>
									<option value="2">已忽略</option>
								</select>
								<select id="errorReason" class="form-control input-md form-search">
								</select>
								<button type="button" class="btn btn-info btn-md form-search" onclick="errorDetailInfo.queryData();">
									<i class="fa fa-search"></i> 查询 &nbsp;
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="errorDetailInfo.clearData();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>
							</form>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
								<table class="table table-striped table-hover table-bordered" id="errorDataTable" style="width: 1500px;">
									<thead>
										<tr class="heading">
											<th>上报批次编号</th>
											<th>部门名称</th>
											<th>错误原因</th>
											<th>上报方式</th>
											<th>数据状态</th>
											<th>更新时间</th>
											<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
												<th>${tableColum.NAME}</th>
											</c:forEach>
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
	<div id="columnTogglerContent" class="btn-group hide pull-right">
		<a class="btn green" href="javascript:;" data-toggle="dropdown">
			列信息 <i class="fa fa-angle-down"></i>
		</a>
		<div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right" style="position:absolute; height:160px; overflow:auto">
			<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
				<label style="margin-right: 20px;">
					<nobr>
					<input type="checkbox" class="icheck" checked data-column="${num.index+3}">
					${tableColum.NAME }
					</nobr>
				</label>
			</c:forEach>
		</div>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/schema/error_detail_info.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>