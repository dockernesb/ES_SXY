<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>业务应用分析</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/operationAnalysis/operationAnalysis.css" />
<style>
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
						业务应用分析
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
				<div class="row">
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2 marginRight_20" style="width: 21.3%;margin-left:43px; padding: 10px 5px" id="xybgDiv" onclick="businessApplication.toggleBox(this,1)">
							<div class="dashboard-stat green-haze">
								<div class="visual">
									<i class="fa  fa-align-justify"></i>
								</div>
								<div class="details">
									<div class="number" id="xybg"></div>
									<div class="desc">信用报告</div>
								</div>
								<i class="more"> </i>
								<div class="elementsOpa elementsActive"></div>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2 marginRight_20" style="width: 21.3%; padding: 10px 5px;" onclick="businessApplication.toggleBox(this,2)">
							<div class="dashboard-stat blue-madison">
								<div class="visual">
									<i class="fa fa-indent"></i>
								</div>
								<div class="details">
									<div class="number" id="yycl"></div>
									<div class="desc">异议处理</div>
								</div>
								<i class="more"> </i>
								<div class="elementsOpa"></div>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2 marginRight_20" style="width: 21.3%; padding: 10px 5px;" onclick="businessApplication.toggleBox(this,3)">
							<div class="dashboard-stat red-intense">
								<div class="visual">
									<i class="fa fa-outdent"></i>
								</div>
								<div class="details">
									<div class="number" id="xyxf"></div>
									<div class="desc">信用修复</div>
								</div>
								<i class="more"> </i>
								<div class="elementsOpa"></div>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2 marginRight_20" style="width: 21.3%; padding: 10px 5px;" onclick="businessApplication.toggleBox(this,4)">
							<div class="dashboard-stat blue">
								<div class="visual">
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
									<div class="number" id="xyhc"></div>
									<div class="desc">信用审查</div>
								</div>
								<i class="more"> </i>
								<div class="elementsOpa"></div>
							</div>
						</div>
						<%--<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2 marginRight_20" style="width: 21.3%; padding: 10px 5px;" onclick="businessApplication.toggleBox(this,5)">
							<div class="dashboard-stat yellow">
								<div class="visual">
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
									<div class="number" id="sgs"></div>
									<div class="desc">双公示</div>
								</div>
								<i class="more"> </i>
								<div class="elementsOpa"></div>
							</div>
						</div>--%>
					</div>
				
					<div class=""
						style="margin: 5px 60px 10px 60px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline" >
						    <div id="weiduDiv" class="marginBottom_5" style="display:none">
						            维度分析：
						    <label for="zxjl" class="marginRight_5" id="zxjlLabel" ><input type="radio" name="xyzt" id="zxjl" value="2" checked/><span id="weiduspan2">数据提供部门分析</span></label>
			                <label for="cxjl" title="汇总异议处理申请发起时有异议的所有数据记录" id="cxjlLabel"><input  type="radio" name="xyzt" id="cxjl" value="1"/><span id="weiduspan1">修复内容分析</span></label>
			                <br />   
			                </div>
							<div id="dataSource" class="marginBottom_5" style="display:none">
								数据来源：
								<label for="all" class="marginRight_5" id="allLabel" ><input type="radio" name="dataSources" id="all" value="" checked/><span id="dataSource1">全部</span></label>
								<label for="sxbm" class="marginRight_5" id="sxbmLabel"><input  type="radio" name="dataSources" id="sxbm" value="A"/><span id="dataSource2">市辖部门</span></label>
								<label for="qxbk" id="qxbkLabel" ><input type="radio" name="dataSources" id="qxbk" value="B"/><span id="dataSource3">区县板块</span></label>
							</div>
							<span id="reports" style="display: none;">
								办件部门：
								<div style="display: inline-block;margin-bottom: 5px;!important" id="department_bj_div">
								<input type="text" class="form-control" id="department_bj" />
								</div>
								<div style="display: inline-block;margin-bottom: 5px;!important" id="department_bj_div1">
								<select class="form-control input-md form-search" id="department_bj1" style="width: 100%;"></select>
								</div>
								类型：
								<select id="personType" name="personType" class="form-control" style="width: 100px" ></select>
							</span>
							统计时间：
							<input type="text" class="form-control date-icon" id="startDate" readonly="readonly" placeholder="开始时间" />
							&nbsp;至&nbsp;
							<input type="text" class="form-control date-icon" id="endDate" readonly="readonly" placeholder="结束时间"/>
							&nbsp;
							 <span id="weisgsDiv" width="200px"style="display:none">
						           部门：
						   &nbsp;<select class="form-control input-md form-search" id="xqbm" style="width: 12%;"></select>
			               </span>
							<button type="button" id="searchBtn" class="btn btn-info btn-md" onclick="businessApplication.conditionSearch();"><i class="fa fa-search"></i>查询</button>
							<button type="button" class="btn btn-default btn-md " onclick="businessApplication.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
							</button>
						</form>
					</div>
					<div class="col-md-12 col-sm-12" style="margin:30px 0 0px;">
						<div id="creditCheckHandleBar" style="width: 100%; height: 480px;float:left; display:block"></div>
						<div id="repairAnalysisBar" style="width: 100%; height: 480px;float:left;"></div>
						<div id="sgsSortBox"  style="float:left;display:none;border: 1px solid #dedede;">
					    	<div style="width: 270px; height: 38px;line-height: 34px;text-align: center;font-size: 17px;font-weight: bold;border-bottom: 1px solid #dedede;">双公示报送排行</div>
							<div  id="sgsXzxkSort" style="width: 260px; height: 235px; position:relative;left:5px; padding-top: 14px;"></div>
							<div  id="sgsXzcfSort" style="width: 260px; height: 235px; position:relative;left:5px;margin-top:-13px;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>

					<div class="col-md-6">
						<div  id="repairTrendXinzeBar" style="width: 100%; height: 450px;"></div>
					</div>
					
					<div class="col-md-6">
						<div id="repairTrendLeijiBar" style="width: 100%; height: 450px;"></div>
					</div>
					
					<div style="height: 50px; clear: both;"></div>
					<div style="margin: 0px 60px 60px 60px;">
						<table id="dataTable" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
								    <th rowspan="2" style="vertical-align:middle;" >序号</th>
									<th rowspan="2" style="vertical-align:middle;">时间</th>
									<th rowspan="2" style="vertical-align:middle;"><span id="headingTitle">报告用途</span></th>
									<th colspan="4">新增情况</th>
									<th colspan="3">累计情况</th>
								</tr>
								<tr role="row" class="heading subHeading">
									<th>新增数</th>
									<th><span id="headingTitle2">报告用途本期占比</span></th>
									<th>环比</th>
									<th>同比</th>
									<th>累计数</th>
									<th><span id="headingTitle3">报告用途本期占比</span></th>
									<th>环比</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
						<table id="dataTable2" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
								    <th>序号</th>
									<th>信息提供部门名称</th>
									<th>双公示合计</th>
									<th>行政许可数据量</th>
									<th>行政处罚数据量</th>
									<th>最近一次上报时间</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
						<table id="dataTable3" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
								    <th rowspan="2" style="vertical-align:middle;" >序号</th>
									<th rowspan="2" style="vertical-align:middle;"><span id="appalyDept">申请部门</span></th>
									<th colspan="2">审查申请</th>
									<th colspan="2">审核通过</th>
									<th colspan="2">审核驳回</th>
								</tr>
								<tr role="row" class="heading subHeading">
									<th>份数</th>
									<th>企业数</th>
									<th>份数</th>
									<th>企业数</th>
									<th>份数</th>
									<th>企业数</th>								
								</tr>
							</thead>
							<tbody></tbody>
						</table>
						<table id="dataTable4" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
								    <th rowspan="2" style="vertical-align:middle;" >序号</th>
									<th colspan="4" style="vertical-align:middle;"><span id="purposeReport">报告用途</span></th>
									<th rowspan="2">申请量</th>
									<th colspan="2">审核量</th>
									<th rowspan="2">下发量</th>
									<th rowspan="2">办结量</th>
								</tr>
								<tr role="row" class="heading subHeading">
									<th>申请用途</th>
									<th>区域部门</th>
									<th>项目名称</th>
									<th>项目细类</th>
									<th>通过量</th>
									<th>驳回量</th>								
								</tr>
							</thead>
							<tbody></tbody>
						</table>
						<table id="dataTable5" class="table table-striped table-bordered table-hover">
							<thead>
							<tr role="row" class="heading">
								<th rowspan="2" style="vertical-align:middle;" >序号</th>
								<th colspan="1" style="vertical-align:middle;"><span id="purposeReport5">报告用途</span></th>
								<th rowspan="2">申请量</th>
								<th colspan="2">审核量</th>
								<th rowspan="2">下发量</th>
								<th rowspan="2">办结量</th>
							</tr>
							<tr role="row" class="heading subHeading">
								<th colspan="1"></th>
								<th>通过量</th>
								<th>驳回量</th>
							</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/operationAnalysis/business_application.js"></script>
	<script type="text/javascript">
		if (window.ActiveXObject || "ActiveXObject" in window) {
			$("input[type='radio']").css("vertical-align","middle");
		}
	</script>
</body>
</html>