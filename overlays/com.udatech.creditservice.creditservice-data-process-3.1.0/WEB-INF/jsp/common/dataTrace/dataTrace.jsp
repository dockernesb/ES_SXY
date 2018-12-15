<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>数据追溯</title>
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/dataTables-1.10.12/media/css/jquery.dataTables.min.css" />
<style>
.btn {
	display: inline-block;
	padding: 6px 12px;
	margin-bottom: 0;
	font-size: 14px;
	font-weight: 400;
	line-height: 1.42857143;
	text-align: center;
	white-space: nowrap;
	vertical-align: middle;
	-ms-touch-action: manipulation;
	touch-action: manipulation;
	cursor: pointer;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
	background-image: none;
	border: 1px solid transparent;
	border-radius: 4px;
	text-decoration:none;
    font-family: inherit;
}

.DTFC_RightBodyLiner{overflow-y:auto !important}
.form-control {
    display: block;
    width: 100%;
    height:auto ;/* 34px */
    padding: 6px 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
}
.dataTables_wrapper > div{
	overflow:hidden !important;
}
.highcharts-contextmenu hr{
	margin:5px 0;
}
</style>
<link rel="stylesheet" type="text/css" href="${rsa}/global/css/components-rounded.css" id="style_components" />
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/font-awesome/css/font-awesome.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/common/common.css" />
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/dataTables-1.10.12/extensions/FixedColumns/css/fixedColumns.dataTables.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/common/dataTrace.css" />
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/dataTables-1.10.12/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/dataTables-1.10.12/extensions/FixedColumns/js/dataTables.fixedColumns.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/base.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/layer-v3.0.1/layer/layer.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/laydate-v1.1/laydate/laydate.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/hightcharts/Highcharts-4.2.3/highcharts.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/hightcharts/Highcharts-4.2.3/modules/exporting.js"></script>
<script type="text/javascript" src="${rsa}/i18n/dataTables.chinese.js"></script>
</head>
<body>
   <div id="winAdd">
		<div class="tabbable-custom">
			<ul class="nav nav-tabs" style="position: fixed; z-index: 60;">
			</ul>
			<div class="tab-content" style="position: absolute; z-index: 50; left: 0px; top: 43px; border-bottom:0px;;bottom: 0px; width: 100%; overflow: auto; padding: 15px;box-sizing:border-box;">
			</div>
		</div>
	</div>
	<div id="winRecordTrace" style="display: none; margin: 10px auto;">
	<div class="portlet-body">
	    <div class="row" style="margin:0px;">
						<div class="col-md-12" style="position:relative">
						  <div  style="width: 650px;margin: 0 auto">
						  <div style="position:absolute;top:10px;left:31px;z-index:1000;font-weight:bold">企业名称：<span id="qymcDiv"></span></div>
						  <div id="container" style="width: 650px;"></div>
						  </div>
						</div>
		</div>
	</div>
	</div>
	<div id="winViewTraceDetail" style="display: none; padding: 10px 40px;word-break:break-all ">
	     <div style="margin:10px 0">时间：<span id="detailTime" style="margin-right:40px"></span>数据状态：<span id="traceState"></span></div>
	     <table class="detailTable" width="100%" id="detailTable" style="word-break:break-all ">
		</table>
	</div>
    <script>
    var CONTEXT_PATH = '${pageContext.request.contextPath}';
    var RESOURCE_PATH = '${rsa}';

	var ctx = CONTEXT_PATH;
	var rsa = RESOURCE_PATH;
	
	// 设置dataTable默认语言(中文)
	$.extend($.fn.dataTable.defaults, {
		dom : '<"ttop"i<"columnToggler">><t>r<"tfoot"lp>',
		lengthMenu : [ [ 5, 10, 20, 30, 50, 100, -1 ], [ 5, 10, 20, 30, 50, 100, "All" ] ],// change per page values here
		language : dataTableI18N
	});
	
	$.fn.dataTable.ext.errMode = function(s, h, m) {
		log(m);
		$.alert('数据列表加载出错！');
	}
	
	var qyid = '${qyid}';
	var qymc = '${qymc}';
    </script>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/dataTrace/dataTrace.js"></script>	
</body>
</html>