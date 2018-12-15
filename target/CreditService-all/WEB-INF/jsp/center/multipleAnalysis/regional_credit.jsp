<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>区域信用分析</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/multipleAnalysis/multipleAnalysis.css" />
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/bootstrap/css/bootstrap-datepicker.css" />
<style type="text/css">
input[type="radio"]{vertical-align:text-top}
</style>
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						<span onclick="">区域信用分析</span>
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="topBox" id="topBox">
						<form id="form-search" class="form-inline">
							信用主题：
							<label for="cxjl" class="marginBottom_5 marginRight_5"><input type="radio" name="xyzt" id="cxjl" value="1"  checked/>诚信记录</label>
                			<label for="zxjl" class="marginBottom_5 marginRight_15"><input type="radio" name="xyzt" id="zxjl" value="2" />失信记录</label>
			                                                统计指标：
                			<label for="zhuti" class="marginBottom_5 marginRight_5"><input type="radio" name="zhibiao2" id="zhuti" value="1" checked />主体数量</label>
                			<label for="jilu" class="marginBottom_5"><input type="radio" name="zhibiao2" id="jilu" value="2" />记录数量</label>
                			<br />
                			<div class="conBox marginRight_15">
	                			行业划分：
	                			<select id="hyhf" class="marginBottom_5" multiple style="width:150px">
							    </select>
						    </div>
						    <div class="conBox marginRight_15">
							            企业年龄：
	                			<select id="qynl" class="marginBottom_5" multiple style="width:150px">
					                 <option value="0" selected>全部</option>
							         <option value="NLA">不足3年</option>
							         <option value="NLB">3至5年</option>
							         <option value="NLC">5至10年</option>
							         <option value="NLD">10至20年</option>
							         <option value="NLE">20至30年</option>
							         <option value="NLF">30年以上</option>
							    </select>
						    </div>
						    <div class="conBox marginRight_15">
								企业类型：
								<select id="qylx" class="marginBottom_5" multiple style="width:150px">
								     <option value="0" selected>全部</option>
					                 <option value="QIYEA" >内资非私营</option>
							         <option value="QIYEB" >内资私营</option>
							         <option value="QIYEC" >外商投资</option>
							         <option value="QIYED" >其他</option>
							    </select>
						    </div>
						    <div class="conBox marginRight_15">
	                			注册规模：
	                			<select id="zcgm" class="marginBottom_5" multiple style="width:150px;">
					                 <option value="0" selected>全部</option>
					                 <option value="ZHUCEA" >10万以下</option>
							         <option value="ZHUCEB" >10万-100万</option>
							         <option value="ZHUCEC" >100万-500万</option>
							         <option value="ZHUCED" >500万-1000万</option>
							         <option value="ZHUCEE" >1000万-5000万</option>
							         <option value="ZHUCEF" >5000万以上</option>
							    </select>
						    </div>
						    <div style="clear: both;"></div>
						   	<div class="conBox">
							   	统计方式：	
							   	<label for="xinz" class="marginBottom_5 marginRight_5"><input type="radio" name="zhibiao1" id="xinz" value="2" checked onclick="multiCommon.changeRQ()"/>新增</label>
							    <label for="Leiji" class="marginBottom_5 marginRight_15"><input type="radio" name="zhibiao1" id="Leiji" value="1" onclick="multiCommon.changeRQ()"/>累计</label>
								<span id="tjsjSpan">统计期间</span>：
							    <input type="text"  readonly class="form_datetime marginRight_5" id="startDate" style="width:150px;">
							    <button type="button" class="btn btn-info btn-md "  onclick="regionalCredit.conditionSearch();">
								<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md" onclick="regionalCredit.conditionReset();">
										<i class="fa fa-rotate-left"></i>重置
								</button>
							</div>
							<div style="clear: both;"></div>
						</form>
					</div>
				    <div class="toorBtn" ><img id="toBig"  onclick="multiCommon.toggleTopBox()" src="${pageContext.request.contextPath}/app/images/multipleAnalysis/toTop.png" /></div>
				
					<div class="col-md-6 col-sm-6" style="margin:30px 0 40px;">
						<div id="industrySpreadBar" style="width: 100%; height: 450px;"></div>
					</div>
					
					<div class="col-md-6 col-sm-6" style="margin:30px 0 40px;">
						<div id="huanbiBar" style="width: 100%; height: 450px;"></div>
					</div>
					
					<!-- <div class="col-md-6 col-sm-6">
						<div id="industryDetailsPie" style="width: 100%; height: 474px;"></div>
					</div> -->
					
					<div style="clear: both;"></div>
					<div style="margin: 0px 60px 60px 60px;">
						<table id="dataTable" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
								    <th rowspan="2" style="vertical-align:middle;" >序号</th>
									<th rowspan="2" style="vertical-align:middle;">时间</th>
									<th rowspan="2" style="vertical-align:middle;">行政区划</th>
									<th colspan="4">新增情况</th>
									<th colspan="3">累计情况</th>
								</tr>
								<tr role="row" class="heading subHeading">
									<th>新增数</th>
									<th>区域本期占比</th>
									<th>环比</th>
									<th>同比</th>
								    <th>累计数</th>
									<th>区域本期占比</th>
									<th>环比</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript" src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/d3/d3.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.zh-CN.min.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/multipleAnalysis/multipleAnalysis_common.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/multipleAnalysis/regional_credit.js"></script>
	<script type="text/javascript">
		if (window.ActiveXObject || "ActiveXObject" in window) {
			$("input[type='radio']").css("vertical-align","middle");
		}
	</script>
</body>
</html>