<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>社会法人</title>
<style type="text/css">
.caption-df {
	padding: 10px 0;
	float: left;
	display: inline-block;
	font-size: 15px;
	font-weight: 600;
}
</style>
</head>
<body>
<div id="topBox">
<div id="parentBox">
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-th-list"></i>社会法人
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<div class="portlet light bg-inverse" style="padding: 10px; margin-bottom: 10px">
								<div class="row">
									<div class="col-md-1 col-sm-2">
										<div class="caption-df" style="width: 100px">法人分类</div>
									</div>
									<div class="col-md-11 col-sm-10 qylxDiv">
										<c:forEach items="${labelMapList}" var="labelMap" varStatus="num">
											<a href="javascript:void(0);" onclick="legalPerson.findByQylx(this);" style="margin: 5px 0;" class="btn btn-default btn-sm">${labelMap.FRFL}</a>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline" id="legalPersonFrom">
								<input id="qymc" name="qymc" class="form-control input-md form-search" placeholder="企业名称" />
								<input id="shxydm" name="shxydm" class="form-control input-md form-search" placeholder="统一社会信用代码" />
								<input id="zzjgdm" name="zzjgdm" class="form-control input-md form-search" placeholder="组织机构代码" />
								<input id="gszch" name="gszch" class="form-control input-md form-search" placeholder="工商注册号" />
								<select id="shhymc" name="shhymc" class="form-control input-md form-search " ></select>
								<input id="zcsjs" name="zcsjs" class="form-control input-md form-search date-icon" placeholder="注册时间始" readonly="readonly">
								<input id="zcsjz" name="zcsjz" class="form-control input-md form-search date-icon" placeholder="注册时间止" readonly="readonly">
								<select id="qylxSelect" name="qylxSelect" class="form-control input-md form-search " ></select>
								<button type="button" class="btn btn-info btn-md form-search" onclick="legalPerson.conditionSearch();">
									<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="legalPerson.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="legalPersonGrid">
						<thead>
							<tr class="heading">
								<th>企业名称</th>
								<th>统一社会信用代码</th>
								<th>组织机构代码</th>
								<th>工商注册号</th>
								<th>注册时间</th>
								<th>法定代表人</th>
								<th>所属行业名称</th>
								<th>企业类型</th>
								<th>注册资金</th>
								<th>操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="columnTogglerContent" class="btn-group hide pull-right">
		<a class="btn green" href="javascript:;" data-toggle="dropdown">
			列信息 <i class="fa fa-angle-down"></i>
		</a>
		<div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
			<label> <input type="checkbox" class="icheck" checked data-column="0">企业名称</label>
			<label> <input type="checkbox" class="icheck" checked data-column="1">统一社会信用代码</label>
			<label> <input type="checkbox" class="icheck" data-column="2">组织机构代码</label>
			<label> <input type="checkbox" class="icheck" data-column="3">工商注册号</label>
			<label> <input type="checkbox" class="icheck" checked data-column="4">注册时间</label>
			<label> <input type="checkbox" class="icheck" checked data-column="5">法定代表人</label>
			<label> <input type="checkbox" class="icheck" checked data-column="6">所属行业名称</label>
			<label> <input type="checkbox" class="icheck" checked data-column="7">企业类型</label>
			<label> <input type="checkbox" class="icheck" data-column="8">注册资金</label>
		</div>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/socialLegalPerson/socialLegalPersonList.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</div>
<div id="childBox" style="display:none">

</div>
</div>
</body>
</html>