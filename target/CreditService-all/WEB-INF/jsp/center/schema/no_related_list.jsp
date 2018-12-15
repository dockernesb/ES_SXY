<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>未关联数据</title>
</head>
<body>
	<input type="hidden" name="codeList" id="codeList" value='${codeList}'>
	<input type="hidden" name="nameList" id="nameList" value='${nameList}'>
	<input type="hidden" name="nameList" id="tableColumList" value='${tableColumList}'>
	<input type="hidden" name="typeList" id="typeList" value='${typeList}'>
	<input type="hidden" name="rulesList" id="rulesList" value='${rulesList}'>
	<input type="hidden" name="tableId" id="tableId" value="${logicTableId}">
	<input type="hidden" name="errorTaskCode" id="errorTaskCode" value="${errorTaskCode}">
	<input type="hidden" name="requiredGroupList" id="requiredGroupList" value='${requiredGroupList}'>
	<input type="hidden" name="deptId" id="deptId" value='${deptId}'>
	<input type="hidden" name="versionId" id="deptId" value='${versionId}'>
	<input type="hidden" id="uploadTableHasData" value="0"/>
	<input type="hidden" id="reportName" value="${reportName}"/>
	<input type="hidden" id="tableCode" value="${tableCode}"/>	
	<div class="row">
			<div class="col-md-12">
				<div class="portlet box red-intense">
					<div class="portlet-title">
						<div class="caption">
							<i class="glyphicon glyphicon-open"></i>未关联数据| ${reportName}
						</div>
						
						<div class="tools" style="padding-left: 5px;">
							<a href="javascript:void(0);" class="collapse"></a>
						</div>
						<div class="actions">
							<button class="btn btn-default btn-md" type="button" onclick="noRelated.goBack();">
								<i class="fa fa-rotate-left"></i> 返回
							</button>
						</div>
					</div>
					<div class="portlet-body">
						<div class="row">
							<div class="col-md-12">
								<form class="form-inline" id="rightDataTitle">

								<input id="showTaskCode"
									class="form-control input-md form-search" placeholder="上报批次编号" /> 
								<select id="tableCoulmnName"
									class="form-control input-md form-search">
									<option value=" ">不限</option>
									<c:forEach items="${tableColumList}" var="tableColum"
										varStatus="num">
										<option value="${tableColum.COLUMN_NAME }">${tableColum.COLUMN_ALIAS }</option>
									</c:forEach>
								</select> 
								<input id="tableCoulmnNameValue"
									class="form-control input-md form-search" disabled
									placeholder="查询内容" /> 
								<input id="updateStartDate"
									class="form-control input-md form-search date-icon"
									placeholder="更新时间始" readonly="readonly"> 
								<input
									id="updateEndDate"
									class="form-control input-md form-search date-icon"
									placeholder="更新时间止" readonly="readonly">
									 <br> 
								<select
									class="form-control input-md form-search" id="departmentDetail"></select>
								<button type="button" class="btn btn-info btn-md form-search"
									onclick="noRelated.queryData();">
									<i class="fa fa-search"></i> 查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search"
									onclick="noRelated.clearData();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>

							</form>
							</div>
						</div>
						<br>
						<div class="row" >
						<div class="col-md-12">
							<table class="table table-striped table-hover table-bordered" id="dataReportGrid" style="width: 2000px">
							<thead>
								<tr class="heading">
									<th>上报批次编号</th>
									<th>部门名称</th>
									<th>更新时间</th>
									<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
										<th>${tableColum.COLUMN_ALIAS }</th>
									</c:forEach>
								</tr>
							</thead>
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
				<label> 
					<input type="checkbox" class="icheck" checked data-column="${num.index+2}"> ${tableColum.COLUMN_ALIAS }
				</label>
			</c:forEach>
		</div>
	</div>
	
	
	
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/schema/no_related_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>