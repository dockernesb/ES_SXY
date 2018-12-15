<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上报/维护信息</title>
</head>
<body>
	<input type="hidden" name="codeList" id="codeList" value='${codeList}'>
	<input type="hidden" name="nameList" id="nameList" value='${nameList}'>
	<input type="hidden" name="nameList" id="tableColumList" value='${tableColumList}'>
	<input type="hidden" name="templateFilePath" id="templateFilePath" value='${templateFilePath}'>
	<input type="hidden" name="typeList" id="typeList" value='${typeList}'>
	<input type="hidden" name="rulesList" id="rulesList" value='${rulesList}'>
	<input type="hidden" name="checkTime" id="checkTime" value='${checkTime}'>
	<input type="hidden" name="requiredGroupList" id="requiredGroupList" value='${requiredGroupList}'>
	<input type="hidden" name="tableId" id="tableId" value="${tableId}">
	<input type="hidden" name="errorTaskCode" id="errorTaskCode" value="${errorTaskCode}">
	<input type="hidden" name="beginTime" id="beginTime" value="${fn:substring(beginTime,"0","10") }"/>

	<input type="hidden" id="choseTitle" value="${choseTitle}"/>
	
	<input type="hidden" id="uploadTableHasData" value="0"/>
		
	<div class="row">
		<div class="col-md-12">
			
			<div class="portlet box red-intense" id="rightData">
				<div class="portlet-title">
					<div class="caption">
					<i class="glyphicon glyphicon-open"></i>数据上报 | ${reportName}
					</div>
					
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
                        <button class="btn btn-default btn-sm sbbtn" type="button" onclick="dataReport.onAddData();">手动录入</button>
						<button class="btn btn-default btn-sm upload-file" id="uploadFile">文件上传</button>
						<button class="btn btn-default btn-sm sbbtn" type="button" onclick="dataReport.downloadByType('doc');">接口上报</button>
						<button class="btn btn-default btn-sm sbbtn" type="button" onclick="dataReport.openDownload();">模板下载</button>
						<button class="btn btn-default btn-sm sbbtn" type="button" onclick="dataReport.openEdit();">修改</button>
						<button class="btn btn-default btn-sm sbbtn" type="button" onclick="dataReport.deleteData();">删除</button>
						<button class="btn btn-default btn-sm" type="button" onclick="dataReport.goBack();">返回</button>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<button id="bqBtn" type="button" class="btn btn-info btn-md form-search" style="width: 84px;padding-left: 5px;"
                                        onclick="dataReport.getData(0);">
									本周期
								</button>
								<button id="allBtn" type="button" class="btn btn-default btn-md form-search" style="margin-left: -10px;"
										onclick="dataReport.getData(1);">
									全部上报
								</button>
								<hr style="margin-top: -5px;">
								<input id="taskCode" class="form-control input-md form-search" placeholder="上报批次编号"/>
								<select id="reportWay" class="form-control input-md form-search">
								</select>
								<select id="reprotDataStatus" class="form-control input-md form-search">
									<option value=" ">全部状态</option>
									<option value="1">新增</option>
									<option value="2">已修改</option>
									<option value="3">已删除</option>
									<option value="4">已处理</option>
								</select>
								
								<select id="tableCoulmnName" class="form-control input-md form-search">
									<option value=" ">不限</option>
									<c:forEach items="${tableColumList}" var="tableColum" varStatus="num">
										<option value="${tableColum.CODE }">${tableColum.NAME }</option>
									</c:forEach>
								</select>
								<input id="tableCoulmnNameValue" class="form-control input-md form-search" disabled  placeholder="查询内容"/>
								<input id="beginDate" class="form-control input-md form-search date-icon" placeholder="更新时间始"
									   readonly="readonly" value="${fn:substring(beginTime,"0","10") }">
								<input id="endDate" class="form-control input-md form-search date-icon"
									   placeholder="更新时间止" readonly="readonly">
								<button type="button" class="btn btn-info btn-md form-search" onclick="dataReport.queryData();">
									<i class="fa fa-search"></i> 查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="dataReport.clearData();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>
							</form>
							
						</div>
					</div>
					<div class="row" >
						<div class="col-md-12">
								<table class="table table-striped table-hover table-bordered" id="dataReportGrid" style="width: 2000px;">
									<thead>
										<tr class="heading">
											<th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th>
											<th>上报批次编号</th>
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
	<div id="winAdd" style="display: none; margin: 10px 40px;">
		<form id="addDataForm" class="form-horizontal">
            <input type="hidden" name="tableStatus" id="tableStatus" value="${tableStatus}">
			<div class="form-body">
				<div id="warningMsgDiv" class="alert alert-warning" style="margin-left: 10px;">
					<i class="fa fa-warning"></i> 提示：${warningMsg}
				</div>
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
												<input class="form-control required" id="Add${tableColum.CODE }" name="${tableColum.CODE }"
													   onkeyup="this.value=this.value.replace(/[^\d]/g,'')" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'DATE'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input name="${tableColum.CODE }" id="Add${tableColum.CODE }" class="form-control input-md date-icon required" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'CLOB'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea rows="4" style="resize: none;" class="form-control required" id="Add${tableColum.CODE }" name="${tableColum.CODE }"></textarea>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control required" id="Add${tableColum.CODE }" name="${tableColum.CODE }"  maxlength="${tableColum.LENGTH }"/>
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
												<input class="form-control required" id="Add${tableColum.CODE }" name="${tableColum.CODE }"
													   onkeyup="this.value=this.value.replace(/[^\d]/g,'')" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'CLOB'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea rows="4" style="resize: none;" class="form-control" id="Add${tableColum.CODE }" name="${tableColum.CODE }"></textarea>
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'DATE'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input name="${tableColum.CODE }" id="Add${tableColum.CODE }" class="form-control input-md date-icon" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control" id="Add${tableColum.CODE }" name="${tableColum.CODE }" maxlength="${tableColum.LENGTH }" />
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
	<div id="winEdit" style="display: none; margin: 10px 40px;">
		<form id="editDataForm" class="form-horizontal">
			<div class="form-body">
				<div id="editWarningMsgDiv" class="alert alert-warning" style="margin-left: 10px;">
					<i class="fa fa-warning"></i> 提示：${warningMsg}
				</div>
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
												<input class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE }"
													   onkeyup="this.value=this.value.replace(/[^\d]/g,'')" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'CLOB'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea rows="3" style="resize: none;" class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE }"></textarea>
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'DATE'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input name="${tableColum.CODE }" id="${tableColum.CODE }" class="form-control input-md date-icon required"
													   onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})"/>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE }" maxlength="${tableColum.LENGTH }"/>
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
												<input class="form-control required" id="${tableColum.CODE }" name="${tableColum.CODE } "
													   onkeyup="this.value=this.value.replace(/[^\d]/g,'')" />
											</div>
										</div>
									</c:when>
									<c:when test="${tableColum.TYPE == 'CLOB'}">
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea rows="3" style="resize: none;" class="form-control" id="${tableColum.CODE }" name="${tableColum.CODE }"></textarea>
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
									<c:otherwise>
										<div class="col-sm-8">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control" id="${tableColum.CODE }" name="${tableColum.CODE }" maxlength="${tableColum.LENGTH }"/>
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
	<div id="winDownload" style="display: none;">
		<div style="text-align: center; margin: 5px;">
			<div style="float: left; width: 150px; height: 200px;" hidden="true">
				<a href="javascript:void(0);" onclick="dataReport.downloadByType('txt');">
					<img style="text-align: center; width:100%; padding-bottom: 10px; padding-top: 10px;" src="${pageContext.request.contextPath}/app/images/icon/txt_file.png">
					<small style="text-align: center">下载Txt模板</small>
				</a>
			</div>
			<div style="float: left; margin-left: 55px; width: 150px; height: 200px;">
				<a href="javascript:void(0);" onclick="dataReport.downloadByType('xls');">
					<img style="text-align: center; width:100%; padding-bottom: 10px; padding-top: 10px;" src="${pageContext.request.contextPath}/app/images/icon/xls_file.png">
					<small style="text-align: center">下载Excel2003模板</small>
				</a>
			</div>
			<div style="float: right; margin-right: 55px; width: 150px; height: 200px;">
				<a href="javascript:void(0);" onclick="dataReport.downloadByType('xlsx');">
					<img style="text-align: center; width:100%; padding-bottom: 10px; padding-top: 10px;" src="${pageContext.request.contextPath}/app/images/icon/xlsx_file.png">
					<small style="text-align: center">下载Excel2007模板</small>
				</a>
			</div>
			<div style="float: left; width: 150px; height: 200px;" hidden="true">
				<a href="javascript:void(0);" onclick="dataReport.downloadByType('xml');">
					<img style="text-align: center; width:100%; padding-bottom: 10px; padding-top: 10px;" src="${pageContext.request.contextPath}/app/images/icon/xml_file.png">
					<small style="text-align: center">下载Xml模板</small>
				</a>
			</div>
			<div style="float: left; width: 150px; height: 200px;" hidden="true">
				<a href="javascript:void(0);" onclick="dataReport.downloadByType('doc');">
					<img style="text-align: center; width:100%; padding-bottom: 10px; padding-top: 10px;" src="${pageContext.request.contextPath}/app/images/icon/doc_file.png">
					<small style="text-align: center">下载WebService接口文档</small>
				</a>
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
					<input type="checkbox" class="icheck" checked data-column="${num.index +2}"> ${tableColum.NAME }
				</label>
			</c:forEach>
		</div>
	</div>
	
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/gov/dataReport/dataReport.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>