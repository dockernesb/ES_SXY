<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>数据质量统计</title>
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						数据质量统计
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row" style="padding:0 10px;">
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px">
							<div class="dashboard-stat blue-madison">
								<div class="visual">
									<i class="fa fa-indent"></i>
								</div>
								<div class="details">
									<div class="number" id="ywzs"></div>

									<div class="desc">疑问数据总数（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px;">
							<div class="dashboard-stat blue">
								<div class="visual">
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
									<div class="tipp">修改率：<span id="xgl"></span>%</div>
									<div class="number" id="xgzs"></div>

									<div class="desc">修改总数（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px;">
							<div class="dashboard-stat green">
								<div class="visual">
									<i class="fa fa-outdent"></i>
								</div>
								<div class="details">
									<div class="tipp">处理率：<span id="cll"></span>%</div>
									<div class="number" id="clzs"></div>

									<div class="desc">处理总数（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px;">
							<div class="dashboard-stat red-intense">
								<div class="visual">
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
									<div class="tipp">忽略率：<span id="hll"></span>%</div>
									<div class="number" id="hlzs"></div>

									<div class="desc">忽略总数（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
					</div>
					<div class=""
						style="margin: 15px 0px 50px/*5px 60px 10px 60px*/; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline">
							<input id="schemaName" class="form-control input-md form-search" placeholder="目录名称"/>
							<input type="text" class="form-control  form-search date-icon" id="startDate" readonly="readonly" placeholder="上报时间始"/>
							<input type="text" class="form-control  form-search date-icon" id="endDate" readonly="readonly"  placeholder="上报时间止"/>
							<button type="button" id="searchBtn" class="btn btn-info btn-md form-search">
								<i class="fa fa-search"></i>
								查询
							</button>
							<button type="button" id="resetBtn" class="btn btn-default btn-md form-search">
								<i class="fa fa-rotate-left"></i> 重置
							</button>
						</form>
					</div>
					<div class="col-md-6">
						<div id="errorDataStatusPie" style="width: 100%; height: 450px;"></div>
					</div>
					<div class="col-md-6">
						<div id="errorDataCodesPie" style="width: 100%; height: 450px;"></div>
					</div>
					<div style="clear: both;"></div>
					<div class="row">
						<div class="col-md-12" id="winAdd">
							<div id="dataQualitySchemaBar"
								 style="width: 100%;height: 450px; margin-bottom: 20px;"></div>
							<div id="dataQualitySchemaTrend"
								 style="width: 100%;height: 450px; margin-bottom: 20px;"></div>
							<div style="margin: 0px 60px 60px 60px;" id="fatherDiv">
								<div id="fk_enter_btns_2" class="hide pull-right">
									<a class="btn btn-sm blue" href="javascript:;" onclick="dq.exportData()">导出</a>
								</div>
								<table id="dataSchemaTable" class="table table-striped table-bordered table-hover">
									<thead>
									<tr role="row" class="heading">
										<th>序号</th>
										<th>目录名称</th>
										<th>疑问数据总数</th>
										<th>修改总数</th>
										<th>处理总数</th>
										<th>忽略总数</th>
										<th>修改率</th>
										<th>处理率</th>
										<th>忽略率</th>
									</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<div style="margin: 0px 60px 60px 60px;display: none;" id="sonDiv" >
								<input type="hidden" id="detail_schemaName" />
								<div id="detail_btn" class="hide pull-right">
									<a class="btn btn-sm blue" href="javascript:;" onclick="dq.exportDetailData();">导出</a>
									<a class="btn btn-sm blue" href="javascript:;" onclick="dq.goBack();">返回</a>
								</div>
								<table id="dataTable_detail" class="table table-striped table-bordered table-hover">
									<thead>
									<tr role="row" class="heading">
										<th>序号</th>
										<th>时间</th>
										<th>疑问数据总数</th>
										<th>修改总数</th>
										<th>处理总数</th>
										<th>忽略总数</th>
										<th>修改率</th>
										<th>处理率</th>
										<th>忽略率</th>
									</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/gov/statisAnalyze/data_quality.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>