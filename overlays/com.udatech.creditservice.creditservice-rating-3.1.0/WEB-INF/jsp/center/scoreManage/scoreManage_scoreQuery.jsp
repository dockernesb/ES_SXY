<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>评分查询</title>
<style type="text/css">
table#scoreList th, table#scoreList td {
	height: 30px;
	line-height: 30px;
	text-align: center;
	border: 1px solid #DEDEDE;
}

table#scoreList th {
	background-color: #EBEBEB;
}
</style>
</head>
<body>

	<div class="row rule">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						评分查询
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form id="form-search" class="form-inline">
								<input id="qymc" class="form-control input-md form-search" style="width: 160px;"
									placeholder="企业名称">
								<input id="shxydm" class="form-control input-md form-search" style="width: 160px;"
									placeholder="统一社会信用代码">
								<input id="zzjgdm" class="form-control input-md form-search" style="width: 160px;"
									placeholder="组织机构代码">
								<input id="gszch" class="form-control input-md form-search" style="width: 160px;"
									placeholder="工商注册号">
								<select id="pfmx" class="form-control input-md form-search" style="width: 160px;">
									<option value=""></option>
								</select>
								<button type="button" class="btn btn-info btn-md form-search"
									onclick="smsq.conditionSearch();">
									<i class="fa fa-search"></i>
									查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search"
									onclick="smsq.conditionReset();">
									<i class="fa fa-rotate-left"></i>
									重置
								</button>
							</form>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="formBox">
								<div class="height10"></div>
								<div class="height20"></div>
								<table class="tableForm" style="width: 100%; margin-top: 5px;">
									<tr>
										<th align="center" class="font18"
											style="background-color: #EBEBEB; border: 1px solid #DEDEDE; height: 30px; line-height: 30px; font-weight: bold; text-align: center;">
											总分：&nbsp;
											<span class="font20" id="total">1000</span>
											&nbsp;&nbsp;分&nbsp;&nbsp;
										</th>
									</tr>
									<tr>
										<td align="left"
											style="padding: 10px !important; border: 1px solid #EAEAEA;">
											<div id="tips" style="display: none;">查询中，请耐心等待！</div>
											<table id="scoreList" class="tableForm" style="width: 100%;"></table>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/scoreManage/scoreManage_scoreQuery.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>