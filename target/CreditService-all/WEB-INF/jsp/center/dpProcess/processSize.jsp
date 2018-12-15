<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>入库数据统计</title>
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
						入库数据统计
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
									<i class="fa fa-print"></i>
								</div>
								<div class="details">
                        			<div class="number">${data.creditCount }</div>
                        			<div class="desc">入库数据总量</div>
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
                        			<div class="number">${data.sxbmCount }</div>
                        			<div class="desc">市辖部门入库总量</div>
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
                        			<div class="number" >${data.qxCount }</div>
                        			<div class="desc">区县板块入库总量</div>
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
                        			<div class="number" >${data.lCount }</div>
                        			<div class="desc">法人数据总量</div>
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
									<div class="number" >${data.pCount }</div>
									<div class="desc">自然人数据总量</div>
								</div>
								<i class="more"> </i>
							</div>
						</div>
					</div>
					<div class="" style="margin: 15px 0px 50px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline">
							数据来源：
							<div class="form-group">
							    <label class="radio-inline">
							      <input type="radio"  value="all" name="dataOrigin" checked>全部
							    </label>
							    <label class="radio-inline">
							      <input type="radio"  value="sz" name="dataOrigin">市辖部门
							    </label>
							    <label class="radio-inline">
							      <input type="radio"  value="qx" name="dataOrigin">区县板块
							    </label>
							 </div>
							<br><br>
							入库时间：
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
					<div>
						<div class="col-md-12">
							<div class="processSizePie" id="processSizePie" style="width: 100%; height: 600px;"></div>
						</div>
					</div>
					<div>
						<div class="col-md-6">
							<div class="frSizePie" id="frSizePie" style="width: 100%; height: 200px;"></div>
						</div>
						<div class="col-md-6">
							<div class="zrrSizePie" id="zrrSizePie" style="width: 100%; height: 200px;"></div>
						</div>
					</div>
					<div style="height: 50px; clear: both;"></div>
					<div class="row">
					<div class="col-md-12" id="winAdd">
						<div class="tabbable-custom">
							<div class="tab-content">
								<div class="tab-pane active" id="deptDiv">
									<div style="margin: 0px 60px 60px 60px;" id="dept_fatherDiv">
										<div id="export_dept_btn" class="hide pull-right">
					                        <a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.exportDeptData();">导出</a>
					                    </div>
										<table id="deptDataTable" class="table table-striped table-bordered table-hover">
											<thead>
												<tr role="row" class="heading">
												    <th>序号</th>
													<th>单位名称</th>
													<th>合计入库</th>
													<th>法人入库</th>
													<th>自然人入库</th>
												</tr>
											</thead>
											<tbody></tbody>
										</table>
									</div>
									<div style="margin: 0px 60px 60px 60px;display: none;" id="dept_sonDiv" >
										<input type="hidden" id="detail_deptId" />
										<input type="hidden" id="detail_deptName" />
										<div id="detail_dept_btn" class="hide pull-right">
											<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.exportDeptDetailData();">导出</a>
											<a class="btn btn-sm blue" href="javascript:;" onclick="dataSize.goBack();">返回</a>
										</div>
										<table id="deptDataTable_detail" class="table table-striped table-bordered table-hover">
											<thead>
											<tr role="row" class="heading">
												<th>序号</th>
												<th>目录名称</th>
												<th>入库量</th>
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
		src="${pageContext.request.contextPath}/app/js/center/dpProcess/processSize.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/echarts/echarts.min.js"></script>

</body>
</html>