<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据明细</title>
</head>
<body>
	<input type="hidden" name="codeList" id="codeList" value='${codeList}'>
	<input type="hidden" name="nameList" id="nameList" value='${nameList}'>
	<input type="hidden" name="nameList" id="tableColumList" value='${tableColumList}'>
	<input type="hidden" name="templateFilePath" id="templateFilePath" value='${templateFilePath}'>
	<input type="hidden" name="typeList" id="typeList" value='${typeList}'>
	<input type="hidden" name="rulesList" id="rulesList" value='${rulesList}'>
	<input type="hidden" name="checkTime" id="checkTime" value='${checkTime}'>
	<input type="hidden" name="tableId" id="tableId" value="${tableId}">
	<input type="hidden" name="errorTaskCode" id="errorTaskCode" value="${errorTaskCode}">
	<input type="hidden" name="requiredGroupList" id="requiredGroupList" value='${requiredGroupList}'>
	<input type="hidden" name="taskCode" id="taskCode" value="${taskCode}">
	<input type="hidden" id="choseTitle" value="${choseTitle}"/>
	<input type="hidden" id="uploadTableHasData" value="0"/>
	<input type="hidden" id="parentMenu" value="${parentMenu}"/>
	<input type="hidden" id="toMore" value="${toMore}"/>
	<input type="hidden" id="reportName" value="${reportName}"/>
	<input type="hidden" id="logicTableId" value="${logicTableId}"/>	
	<input type="hidden" id="deptId" value="${deptId}"/>
	<div class="row">
			<div class="col-md-12">
				<div class="portlet box red-intense">
					<div class="portlet-title">
						<div class="caption">
							<i class="glyphicon glyphicon-open"></i>数据明细 | ${reportName}
						</div>
						
						<div class="tools" style="padding-left: 5px;">
							<a href="javascript:void(0);" class="collapse"></a>
						</div>
						<div class="actions">
							<c:if test="${parentMenu ne 'center' && confirmStatus eq 'null'}">
							    <button class="btn btn-default btn-sm" type="button" onclick="dataReport.openEdit();">修改</button>
								<button class="btn btn-default btn-sm " type="button" onclick="dataReport.deleteData();">删除</button>
						    </c:if>
							<button class="btn btn-default btn-md" type="button" onclick="dataReport.goBack();">返回</button>
						</div>
					</div>
					<div class="portlet-body">
						<div class="row">
							<div class="col-md-12">
								<form class="form-inline" id="rightDataTitle">
								 	<c:if test="${parentMenu eq 'center'}">
										<label>部门名称</label>
										<input id="deptName" class="form-control input-md form-search" value="${deptName}" readonly/>
									</c:if>
									<label>上报批次编号</label>
									<input id="showTaskCode" class="form-control input-md form-search" value="${taskCode}" disabled />
									<label>上报方式</label>
									<input id="reportWay" class="form-control input-md form-search" value="${reportWay}" disabled />
									<select id="reprotDataStatus" class="form-control input-md form-search">
										<option value=" ">全部状态</option>
										<option value="1">新增</option>
										<option value="2">已修改</option>
										<option value="3">已删除</option>
										<option value="4">已处理</option>
									</select>
									<c:if test="${parentMenu eq 'center'}">
										<br />
									</c:if>
									<select id="tableCoulmnName" class="form-control input-md form-search">
										<option value=" ">不限</option>
										<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
											<option value="${tableColum.CODE }">${tableColum.NAME }</option>
										</c:forEach>
									</select>
									<input id="tableCoulmnNameValue" class="form-control input-md form-search" disabled placeholder="查询内容"/>
									<button type="button" class="btn btn-info btn-md form-search" onclick="dataReport.queryData();">
									<i class="fa fa-search"></i> 查询
									</button>
									<button type="button" class="btn btn-default btn-md form-search" onclick="dataReport.clearData();">
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
									<th class="table-checkbox">
												<input type="checkbox" class="icheck checkall">
									</th>
									<th>上报方式</th>
									<th>数据状态</th>
									<th>更新时间</th>
									<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
										<th>${tableColum.NAME }</th>
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
	<div id="winEdit" style="display: none; margin: 10px 40px;">
		<form id="editDataForm" class="form-horizontal">
			<div class="form-body">
			 <div id="warningMsgDiv" class="alert alert-warning" style="margin-left: 10px;">
					<i class="fa fa-warning"></i> 提示：${warningMsg}
			 </div>
			 <input type="hidden" name="logicTableId" value="${logicTableId}"/>
         	 <input type="hidden" name="editId" id="editId" value="">
				<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
					<div class="form-group">
						<label class="control-label col-md-4"> ${tableColum.NAME } </label>
						<c:choose>
							<c:when test="${tableColum.NULLABLE}">
								<c:choose>
									<c:when test="${tableColum.TYPE == 'NUMBER'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE }" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'DATE'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input name="${tableColum.CODE }" id="${tableColum.CODE }" class="form-control input-md date-icon"
													   onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})"/>
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'CLOB'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea rows="3" style="resize: none;" class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE }" ></textarea>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE }" maxlength="${tableColum.LENGTH }" />
											</div>
										</div>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${tableColum.TYPE == 'NUMBER'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control" id="${tableColum.CODE }" name="${tableColum.CODE }"
													   onkeyup="this.value=this.value.replace(/[^\d]/g,'')" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'DATE'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input name="${tableColum.CODE }" id="${tableColum.CODE }" class="form-control input-md date-icon"
													   onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})"/>
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'CLOB'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea rows="3" style="resize: none;" class="form-control" id="${tableColum.CODE }" name="${tableColum.CODE }" ></textarea>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control" id="${tableColum.CODE }" name="${tableColum.CODE }" maxlength="${tableColum.LENGTH }" />
											</div>
										</div>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</div>
				</c:forEach>
			</div>
		</form>
	</div>
	<div id="columnTogglerContent" class="btn-group hide pull-right">
		<a class="btn green" href="javascript:;" data-toggle="dropdown">
			列信息 <i class="fa fa-angle-down"></i>
		</a>
		<div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right" style="position:absolute; height:160px; overflow:auto">
		
			<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
				<label> 
					<input type="checkbox" class="icheck" checked data-column="${num.index+1}"> ${tableColum.NAME }
				</label>
			</c:forEach>
		</div>
	</div>
	
	
	
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/gov/dataReport/dataReportHistory.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>