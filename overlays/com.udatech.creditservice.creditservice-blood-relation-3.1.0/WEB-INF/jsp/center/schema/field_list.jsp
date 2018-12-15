<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>字段维护</title>
<style type="text/css">
div.field label.innerLabel {
	text-align: center;
	width: 100%;
	height: 34px;
	border: none;
	margin: 0px;
	padding: 7px 0px 0px 0px;
}

div.field input.innerInput {
	width: 100%;
}

div.field input.innerInputLen {
	/* width: 100px; */
	
}

div.field td {
	padding: 5px !important;
	vertical-align: middle !important;
}

table.winTable {
	width: 400px;
	border: 1px solid #dedede;
	table-layout: fixed;
	margin: auto;
	margin-top: 10px;
	margin-bottom: 10px;
}

table.winTable th, table.winTable td {
	height: 30px;
	vertical-align: middle;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	word-break: keep-all;
}

table.winTable tr.data-tr:hover {
	background-color: #eaf2ff;
}

table.winTable th {
	text-align: center;
}

table.winTable td {
	padding: 5px;
	border-top: 1px solid #dedede;
	border-left: 1px solid #dedede;
	text-align: left;
}

input.innerInputCode {
	text-transform: uppercase;
}

div.field-sort {
	width: 25px;
	height: 25px;
	display: inline-block;
	background-repeat: no-repeat;
	cursor: pointer;
}

div.sort-top {
	background-image:
		url("${pageContext.request.contextPath}/app/images/schema/move.png");
	background-position: 7px -14px;
}

div.sort-up {
	background-image:
		url("${pageContext.request.contextPath}/app/images/schema/move.png");
	background-position: -37px -14px;
}

div.sort-down {
	background-image:
		url("${pageContext.request.contextPath}/app/images/schema/move.png");
	background-position: -60px -14px;
}

div.sort-bottom {
	background-image:
		url("${pageContext.request.contextPath}/app/images/schema/move.png");
	background-position: -17px -14px;
}
</style>
</head>
<body>

	<div class="row field">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						字段维护
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" id="addBtn"
							class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i>
							添加
						</a>
						<a href="javascript:void(0);" id="commonBtn"
							class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i>
							选择
						</a>
						<a href="javascript:void(0);" id="saveBtn"
							class="btn btn-default btn-sm">
							<i class="fa fa-save"></i>
							保存
						</a>
						<a href="javascript:void(0);" id="backBtn"
							class="btn btn-default btn-sm"> 返回 </a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form id="form-search" class="form-inline">
								部门名称：
								<input class="form-control input-md" style="width: 200px;"
									readonly="readonly" value="${table.deptName}" />
								&nbsp;目录名称：
								<input class="form-control input-md" style="width: 200px;"
									readonly="readonly" value="${table.name}" />
								&nbsp;目录编码：
								<input class="form-control input-md" style="width: 200px;"
									readonly="readonly" value="${table.code}" />
							</form>
						</div>
						<div style="height: 30px;"></div>
					</div>
					<form id="fieldForm" action="#" method="post">
						<table id="dataTable"
							class="table table-striped table-bordered table-hover"
							style="min-width: 1200px;">
							<thead>
								<tr role="row" class="heading">
									<th>序号</th>
									<th width="110px;">排序</th>
									<th>字段名称</th>
									<th>字段编码</th>
									<th>字段类型</th>
									<th width="80px;">长度</th>
									<th>必填</th>
									<th width="60px;">
										分组
										<i class="fa fa-question-circle" style="color: #e35b5a;"
											title="有必填分组需求可输入分组编号进行分组，如1,2,3（限数字）"></i>
									</th>
									<th>状态</th>
									<th>批注</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>

	<div id="commonDiv" style="display: none; margin: 30px 40px;">
		<table class="winTable" style="width: 100%;">
			<tr>
				<th width="30px">
					<input type="checkbox" class="selectedAll" />
				</th>
				<th style="border-left: 1px solid #dedede;">字段名称</th>
				<th style="border-left: 1px solid #dedede;">字段编码</th>
			</tr>
			<c:if test="${commonFields != null}">
				<c:forEach items="${commonFields}" var="field">
					<tr class="data-tr" onclick="fl.selectField(this)">
						<th style="border-top: 1px solid #dedede;">
							<input type="checkbox" class="field" />
						</th>
						<td title='<c:out value="${field.dictValue}" />'>
							<c:out value="${field.dictValue}" />
						</td>
						<td title='<c:out value="${field.dictKey}" />'>
							<c:out value="${field.dictKey}" />
						</td>
					</tr>
				</c:forEach>
			</c:if>
		</table>
	</div>

	<div id="ruleDiv" style="display: none; margin: 30px 40px;">
		<table class="winTable" style="width: 100%;">
			<tr>
				<th width="30px"></th>
				<th style="border-left: 1px solid #dedede;">规则名称</th>
				<th style="border-left: 1px solid #dedede;">提示消息</th>
			</tr>
			<c:if test="${ruleList != null}">
				<c:forEach items="${ruleList}" var="rule">
					<tr class="data-tr" onclick="fl.selectRule(this)">
						<th style="border-top: 1px solid #dedede;">
							<input id="${rule.id}" type="checkbox" class="rule" />
						</th>
						<td title='<c:out value="${rule.ruleName}" />'>
							<c:out value="${rule.ruleName}" />
						</td>
						<td title='<c:out value="${rule.msg}" />'>
							<c:out value="${rule.msg}" />
						</td>
					</tr>
				</c:forEach>
			</c:if>
		</table>
		<input type="hidden" id="rowId" />
	</div>

	<div id="postilDiv"
		style="display: none; margin: 30px 40px; height: 220px;">
		<textarea style="width: 100%; height: 100%;" id="postil"></textarea>
	</div>

	<input type="hidden" id="tableId" value="${table.id}" />
	<input type="hidden" id="dataCount" value="${table.dataCount}" />

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/util/pinyin.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/schema/field_list.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>