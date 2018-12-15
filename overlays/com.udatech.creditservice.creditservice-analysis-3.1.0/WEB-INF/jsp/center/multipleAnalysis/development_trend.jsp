<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>发展趋势分析</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/multipleAnalysis/multipleAnalysis.css" />
<style>
.over {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	background-color: #f5f5f5;
	opacity: 0.5;
	z-index: 1000;
}

.layout {
	display: none;
	position: absolute;
	top: 40%;
	left: 40%;
	width: 20%;
	height: 20%;
	z-index: 1001;
	text-align: center;
}

text {
	font: 10px sans-serif;
}

.dot {
	stroke: #000;
}

.axis path, .axis line {
	fill: none;
	stroke: #000;
	shape-rendering: crispEdges;
}

.label {
	fill: #777;
}

.year.label {
	font: 300 150px "Helvetica Neue";
	fill: #ddd;
}

.year.label.active {
	fill: #aaa;
}

.axis path, .axis line {
	fill: none;
	stroke: #000;
	shape-rendering: crispEdges;
}

circle.pointTrajectory {
	pointer-events: none;
	stroke: lightgray;
	fill: black;
	opacity: 0;
}

path.lineTrajectory {
	stroke-width: 2;
	stroke-opacity: .5;
	stroke: black;
	fill: none;
	pointer-events: none;
}

.overlay {
	fill: none;
	pointer-events: all;
	cursor: ew-resize;
}
input[type="radio"]{vertical-align:text-top}
</style>
</head>
<body>
<div id="over" class="over"></div>
<div id="titleTips"></div>  
    <div id="layout" class="layout"><img src="${pageContext.request.contextPath}/app/images/loading-0.gif" alt="" /></div>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						发展趋势分析
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
                			<label for="zxjl" class="marginBottom_5"><input type="radio" name="xyzt" id="zxjl" value="2" />失信记录</label>
                			<br />
			                                                类别选择：
			                <label for="lbhyml" class="marginBottom_5 marginRight_5"><input type="radio" name="tjlb" id="lbhyml" value="1"  checked onclick="developmentTrend.showorhideCondition(1)"/>行业门类</label>
                			<label for="lbxzqh" class="marginBottom_5 marginRight_5"><input  type="radio" name="tjlb" id="lbxzqh" value="2" onclick="developmentTrend.showorhideCondition(2)"/>行政区划</label>
                			<label for="lbqynl" class="marginBottom_5 marginRight_15"><input  type="radio" name="tjlb" id="lbqynl" value="3" onclick="developmentTrend.showorhideCondition(3)"/>企业年龄</label>
                			<br />
                			<div class="conBox marginRight_15" id="xzqBox">
                			行政区划：
                			<select id="xzq" multiple style="width:150px">
						    </select>
                			</div>
                		
                		    <div class="conBox marginRight_15" id="hyhfBox" style="display:none">
                			行业划分：
                			<select id="hyhf" multiple style="width:150px">
						    </select>
							</div>
							
							<div class="conBox marginRight_15" id="qynlBox">
							企业年龄：
                			<select id="qynl" multiple style="width:150px">
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
							<select id="qylx" multiple style="width:150px">
							     <option value="0" selected>全部</option>
				                 <option value="QIYEA" >内资非私营</option>
						         <option value="QIYEB" >内资私营</option>
						         <option value="QIYEC" >外商投资</option>
						         <option value="QIYED" >其他</option>
						    </select>
						    </div>
						    <div class="conBox">
                			注册规模：
                			<select id="zcgm" multiple style="width:150px;">
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
						    <div class="conBox marginRight_10">
						            统计方式：	
						   	<label for="xinz" class="marginBottom_5 marginRight_5"><input type="radio" name="zhibiao1" id="xinz" value="2" checked onclick="multiCommon.changeRQ()"/>新增</label>
						   	<label for="Leiji" class="marginBottom_5 marginRight_5"><input type="radio" name="zhibiao1" id="Leiji" value="1"  onclick="multiCommon.changeRQ()"/>累计</label>
							<button type="button" class="btn btn-info btn-md" onclick="developmentTrend.conditionSearch();">
							<i class="fa fa-search"></i>查询
							</button>
							<button type="button" class="btn btn-default btn-md"  onclick="developmentTrend.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
							</button>
							</div>
							<div style="clear: both;"></div>
						</form>
					</div>
					<div class="toorBtn" ><img id="toBig"  onclick="multiCommon.toggleTopBox()" src="${pageContext.request.contextPath}/app/images/multipleAnalysis/toTop.png" /></div>
					
					<div class="col-md-12 col-sm-12" style="margin:20px 0 15px 0">
						<div id="developmentTrend" style="width: 100%; height: 500px;"></div>
					</div>
					<div class="introduce"><span style="font-weight:bold;">发展趋势气泡图：</span><br />显示了过去的N年中信用记录涉及的主体数量（X轴）、记录数量（Y轴）和期末累计在营主体数（半径）的动态波动情况，用鼠标点击圆球或拖拽时间轴可展示该分类信用的发展轨迹及变化趋势。</div>
					<div style="clear: both;"></div>
					
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript" src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/d3/d3.v3.min.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/d3/dragit.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/multipleAnalysis/multipleAnalysis_common.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/multipleAnalysis/development_trend.js"></script>
	<script type="text/javascript">
		if (window.ActiveXObject || "ActiveXObject" in window) {
			$("input[type='radio']").css("vertical-align","middle");
		}
	</script>
</body>
</html>