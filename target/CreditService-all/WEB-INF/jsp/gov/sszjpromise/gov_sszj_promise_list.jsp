<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>信用承诺管理</title>
</head>
<body>

<div id="fatherDiv">
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						信用承诺管理
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form id="form-search" class="form-inline">
								<select id="cnlbKey" class="form-control input-md form-search" style="width:200px;">
									<option value=""></option>
								</select>
								<button type="button" class="btn btn-info btn-md form-search"
									onclick="cpl.conditionSearch();">
									<i class="fa fa-search"></i>
									查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search"
									onclick="cpl.conditionReset();">
									<i class="fa fa-rotate-left"></i>
									重置
								</button>
							</form>
						</div>
					</div>
					<table id="dataTable" class="table table-striped table-bordered table-hover">
						<thead>
							<tr role="row" class="heading">
								<th>承诺类别</th>
								<th>企业数量</th>
								<th>更新时间</th>
								<th>承诺细则</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/gov/sszjpromise/center_sszj_promise_list.js"></script>


</div>
<div id="childDiv" style="display:none">
</div>
</body>
</html>