<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>上报信用中国数据主页</title>
</head>
<body>
<div class="row">
	<div class="col-md-12">
		<div class="portlet box red-intense">
			<div class="portlet-title">
				<div class="caption">
					<i class=""></i>上报信用中国数据
				</div>

				<div class="tools" style="padding-left: 5px;">
					<a href="javascript:void(0);" class="collapse"></a>
				</div>
				<div class="actions">
					<button class="btn btn-default btn-md" type="button" id="commitChineseData">提交</button>
				</div>
			</div>
			<div class="portlet-body">
				<div class="row">
					<div class="col-md-12">
						<form class="form-inline" id="rightDataTitle">
							&nbsp;
							<input id="beginDate" class="form-control input-md form-search date-icon" placeholder="创建时间始" readonly="readonly"/>
							<input id="endDate" class="form-control input-md form-search date-icon" placeholder="创建时间止" readonly="readonly"/>
							<select id="tableCoulmnName" class="form-control input-md form-search">
							</select>
							<input id="tableCoulmnNameValue" class="form-control input-md form-search" disabled placeholder="查询内容"/>
							<br>
							&nbsp;
							<select id="messageType" class="form-control input-md form-search">
								<option value="">信息类型</option>
								<option value="1">双公示行政许可</option>
								<option value="2">双公示行政处罚</option>
							</select>
							&nbsp;
							<select id="dataStatus" class="form-control input-md form-search">
								<option value="">全部状态</option>
								<option value="0">未提交</option>
								<option value="1">提交成功</option>
								<option value="2">提交失败</option>
							</select>
							<button type="button" class="btn btn-info btn-md form-search" onclick="dp.queryData();">
								<i class="fa fa-search"></i> 查询
							</button>

							&nbsp;
							<button type="button" class="btn btn-default btn-md form-search" onclick="dp.clearData();">
								<i class="fa fa-rotate-left"></i> 重置
							</button>

						</form>
					</div>
				</div>
				<br>
				<div class="row" >
					<div class="col-md-12" id="tablePanel">

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="form-group" id="ChineseDiv" style="display: none;">

	<div class="col-md-7" style="position: absolute;top: 50%;left: 20%;">
		<div class="icheck-inline">
			<i class="fa"></i>
			<label><input type="checkbox" name="chineseSelected" id="chineseSelected" checked value="0"></input>上报至信用中国
			</label>
		</div>
	</div>
</div>
<div id="columnTogglerContent" class="btn-group hide pull-right">
	<a class="btn green" href="javascript:;" data-toggle="dropdown">
		列信息 <i class="fa fa-angle-down"></i>
	</a>
	<div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">


	</div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/dpChineseTheme/dpChinese.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>