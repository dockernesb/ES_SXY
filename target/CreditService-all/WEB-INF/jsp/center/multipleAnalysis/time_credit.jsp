<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>企业年龄分析</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/multipleAnalysis/multipleAnalysis.css" />
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/bootstrap/css/bootstrap-datepicker.css" />
<style>
text{
	font-size:12px;
}
.mainBars rect{
  shape-rendering: auto;
  fill-opacity: 0;
  stroke-width: 0.5px;
  stroke: rgb(0, 0, 0);
  stroke-opacity: 0;
}
.subBars{
	shape-rendering:crispEdges;
}
.edges{
	stroke:none;
	fill-opacity:0.5;
}
.header{
	text-anchor:middle;
	font-size:16px;
}
line{
	stroke:grey;
}
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
						企业年龄分析
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
                			 <label for="jilu" class="marginBottom_5" ><input type="radio" name="zhibiao2" id="jilu" value="2" />记录数量</label>
                			<br />
                			<div class="conBox marginRight_15">
	                			行政区划：
	                			<select id="xzq" class="marginBottom_5" multiple style="width:150px">
							    </select>
						    </div>
						    <div class="conBox marginRight_15">
	                		            行业划分：
	                			<select id="hyhf" class="marginBottom_5" multiple style="width:150px">
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
								<span id="tjsjSpan">截止时间</span>：
							    <input type="text"  readonly class="form_datetime marginRight_5 " id="startDate" style="width:150px;">
							    <button type="button" class="btn btn-info btn-md "  onclick="timeCredit.conditionSearch();">
								<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md" onclick="timeCredit.conditionReset();">
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
					
					<div style="clear: both;"></div>
					
					<div class="col-md-12 col-sm-12" style="margin-top:30px;">
					    <span class="chart-title">企业年龄信用记录时序分布</span>
						<div id="bp1" style="width: 100%; height: 800px;text-align:center;"></div>
					</div> 
					
					
					<div style="clear: both;"></div>
					
					
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/d3/d3.v4.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/d3/viz.v1.1.0.min.js"></script>
	<script type="text/javascript"
		src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.js"></script>
	<script type="text/javascript"
		src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.zh-CN.min.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/multipleAnalysis/multipleAnalysis_common.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/multipleAnalysis/time_credit.js"></script>
	<script type="text/javascript">
		if (window.ActiveXObject || "ActiveXObject" in window) {
			$("input[type='radio']").css("vertical-align","middle");
		}
	</script>
</body>
</html>