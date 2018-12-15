<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>数据量统计</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/dataAnalysis/dataAnalysis.css" />
<style type="text/css">
.marginRight{margin-right:60px;cursor:pointer}
</style>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						数据量统计
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row" style="padding:0 10px;">
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px">
							<div class="dashboard-stat blue-madison">
								<div class="visual">
									<i class="fa fa-indent"></i>
								</div>
								<div class="details">
									<div class="tipp">上报信息类：<span id="sbxxl"></span></div>
									<div class="number" id="sbl"></div>
									<div class="desc">上报量（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
							<div class="dashboard-stat blue">
								<div class="visual">
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
									<div class="tipp">疑问率：<span id="ywl"></span></div>
									<div class="number" id="ywli"></div>

									<div class="desc">疑问量（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
							<div class="dashboard-stat green">
								<div class="visual">
									<i class="fa fa-outdent"></i>
								</div>
								<div class="details">
									<div class="tipp">更新率：<span id="gxl"></span></div>
									<div class="number" id="gxli"></div>

									<div class="desc">更新量（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
							<div class="dashboard-stat red-intense">
								<div class="visual">
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
									<div class="tipp">入库率：<span id="rkl"></span></div>
									<div class="number" id="rkli"></div>

									<div class="desc">入库量（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
						<div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px">
							<div class="dashboard-stat blue-madison">
								<div class="visual">
									<i class="fa fa-indent"></i>
								</div>
								<div class="details">
									<div class="tipp">未关联率：<span id="wgll"></span></div>
									<div class="number" id="wglli"></div>

									<div class="desc">未关联量（条）</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
					</div>
					<div class=""
					style="margin: 15px 0px 50px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline">
							<select class="form-control input-md form-search" id="deptId"></select>
						   <input id="tableName" class="form-control input-md form-search" placeholder="目录名称">
							<input type="text" class="form-control date-icon form-search" id="startDate" readonly="readonly" placeholder="上报时间始" />
							<input type="text" class="form-control date-icon form-search" id="endDate" readonly="readonly" placeholder="上报时间止"/>
							<button type="button" id="searchBtn" class="btn btn-info btn-md form-search" onclick="dataSize.conditionSearch();">
							<i class="fa fa-search"></i>查询</button>
							<button type="button" class="btn btn-default btn-md form-search" onclick="dataSize.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
							</button>
						</form>
					</div>
					<div class=""
						style="margin: 5px 60px 10px 60px; text-align: left;  padding-bottom: 10px;">
					</div>
					<div class="col-md-6">
                        <div class="tabbable-custom">
						<ul class="nav nav-tabs">
							<li class="active"><a href="#dataSizePie" data-toggle="tab"><h4>征集数据统计</h4></a></li>
						</ul>
						<div class="dataSizePie" id="dataSizePie" style="width: 100%; height: 450px;"></div>
                        </div>
					</div>
					<div class="col-md-6">
                        <div class="tabbable-custom">
						<ul class="nav nav-tabs dataType">
							<li class="active"><a href="#dataIncrease" data-toggle="tab"><h4>上报方式统计</h4></a></li>
							<li><a href="#dataTypePie" data-toggle="tab"><h4>数据类型统计</h4></a></li>
						</ul>
                            <div class="dataIncrease" id="dataIncrease" style="width: 100%; height: 450px;"></div>
                            <div class="dataIncrease" id="dataTypePie" style="width: 100%; height: 450px;"></div>
                        </div>
					</div>

					<div style="height: 50px; clear: both;"></div>
					<div class="row">
					<div class="col-md-12" id="winAdd">
						<div class="tabbable-custom">
							<ul class="nav nav-tabs">
								<li class="active"><a href="#deptDiv" data-toggle="tab">部门统计</a></li>
								<li><a href="#schemaDiv" data-toggle="tab">目录统计</a></li>
							</ul>
							<div class="tab-content">
								<div class="tab-pane active" id="deptDiv">
									<div id="deptDataSizeBar"
										 style="width: 100%; height: 450px; margin-bottom: 20px;"></div>
									<div id="deptDataStack"
										 style="width: 100%; height: 450px; margin-bottom: 20px;"></div>
									<div style="margin: 0px 60px 60px 60px;" id="dept_fatherDiv">
										<div id="export_dept_btn" class="hide pull-right">
					                        <a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.exportDeptData();">导出</a>
					                        <%--<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.showDetail();">查看</a>--%>
					                    </div>
										<table id="deptDataTable" class="table table-striped table-bordered table-hover">
											<thead>
												<tr role="row" class="heading">
												    <th>序号</th>
													<th>部门名称</th>
													<th>上报量</th>
													<th>疑问量</th>
													<th>更新量</th>
													<th>入库量</th>
													<th>未关联量</th>
													<th>疑问率</th>
													<th>更新率</th>
													<th>入库率</th>
													<th>未关联率</th>
												</tr>
											</thead>
											<tbody></tbody>
										</table>
									</div>
									<div style="margin: 0px 60px 60px 60px;display: none;" id="dept_sonDiv" >
										<input type="hidden" id="detail_deptId" />
										<input type="hidden" id="detail_deptName" />
										<div id="detail_dept_btn" class="hide pull-right">
											<%--<label style="padding-left: 50px;" class="col-sm-3 control-label pull-left">部门数据量统计</label>--%>
											<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.exportDeptDetailData();">导出</a>
											<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.goBack();">返回</a>
										</div>
										<table id="deptDataTable_detail" class="table table-striped table-bordered table-hover">
											<thead>
											<tr role="row" class="heading">
												<th>序号</th>
												<th>目录名称</th>
												<th>上报量</th>
												<th>疑问量</th>
												<th>更新量</th>
												<th>入库量</th>
												<th>未关联量</th>
												<th>疑问率</th>
												<th>更新率</th>
												<th>入库率</th>
												<th>未关联率</th>
											</tr>
											</thead>
											<tbody></tbody>
										</table>
									</div>
								</div>
								<div class="tab-pane" id="schemaDiv">
									<div class="dataSizeBar" id="dataSizeBar"
											style="height: 450px; margin-bottom: 50px;"></div>
									<div class="dataStack" id="dataStack" style="height: 450px;margin-bottom: 50px;"></div>
									<div style="margin: 0px 60px 60px 60px;" id="schema_fatherDiv">
										<div id="schema_btn" class="hide pull-right">
					                        <a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.exportSchemaData();">导出</a>
					                    </div>
										<table id="dataTable" class="table table-striped table-bordered table-hover">
											<thead>
												<tr role="row" class="heading">
												    <th>序号</th>
													<th>目录名称</th>
													<th>上报量</th>
													<th>疑问量</th>
													<th>更新量</th>
													<th>入库量</th>
													<th>未关联量</th>
													<th>疑问率</th>
													<th>更新率</th>
													<th>入库率</th>
													<th>未关联率</th>
												</tr>
											 </thead>
											<tbody></tbody>
										</table>
									</div>
									<div style="margin: 0px 60px 60px 60px;display: none;" id="schema_sonDiv" >
										<input type="hidden" id="detail_schemaId" />
										<input type="hidden" id="detail_schemaName" />
										<div id="detail_schema_btn" class="hide pull-right">
											<%--<label style="padding-left: 50px;" class="col-sm-3 control-label pull-left">部门数据量统计</label>--%>
											<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.exportSchemaDetailData();">导出</a>
											<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.goSchemaBack();">返回</a>
										</div>
										<table id="schemaDataTable_detail" class="table table-striped table-bordered table-hover">
											<thead>
											<tr role="row" class="heading">
												<th>序号</th>
												<th>部门名称</th>
												<th>上报量</th>
												<th>疑问量</th>
												<th>更新量</th>
												<th>入库量</th>
												<th>未关联量</th>
												<th>疑问率</th>
												<th>更新率</th>
												<th>入库率</th>
												<th>未关联率</th>
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
		</div>
	</div>
</div>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/statisAnalyze/data_size.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>