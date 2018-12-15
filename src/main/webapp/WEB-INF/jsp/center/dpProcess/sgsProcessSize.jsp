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
						双公示入库统计
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
                        			<div class="number">${data.allCount }</div>
                        			<div class="desc">双公示入库数据总量</div>
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
                        			<div class="number" >${data.xzxkCount }</div>
                        			<div class="desc">行政许可总量</div>
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
									<div class="number" >${data.xzcfCount }</div>
									<div class="desc">行政处罚总量</div>
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
							      <input type="radio"  value="sz" name="dataOrigin" >市辖部门
							    </label>
							    <label class="radio-inline">
							      <input type="radio"  value="qx" name="dataOrigin">区县板块
							    </label>
							 </div>
							<br><br>
							维度分析：
							<div class="form-group">
							    <label class="radio-inline">
							      <input type="radio"  value="jdrq" name="dimension" checked>决定日期
							    </label>
							    <label class="radio-inline">
							      <input type="radio"  value="sbrq" name="dimension">上报时间
							    </label>
							 </div>
							<br><br>							
							入库时间：
							<input type="text" class="form-control date-icon form-search" id="startDate" readonly="readonly" placeholder="开始时间" />
							<input type="text" class="form-control date-icon form-search" id="endDate" readonly="readonly" placeholder="结束时间"/>
							<select class="form-control input-md form-search" id="deptId"></select>
							<button type="button" id="searchBtn" class="btn btn-info btn-md form-search" onclick="dataSize.conditionSearch();">
							<i class="fa fa-search"></i>查询</button>
							<button type="button" class="btn btn-default btn-md form-search" onclick="dataSize.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
							</button>
						</form>
					</div>
					<div class="col-md-12 col-sm-12" style="margin:30px 0 0px;">
					<div>
						<div id="monthBar" style="width: 100%; height: 480px;float:left;"></div>
						<div style="height: 50px; clear: both;"></div>	
					</div>
						<div id="publicityBar" style="width: 70%; height: 480px;float:left;"></div>
						<div id="sgsSortBox"  style="float:left;border: 1px solid #dedede;">
					    	<div style="width: 270px; height: 38px;line-height: 34px;text-align: center;font-size: 17px;font-weight: bold;border-bottom: 1px solid #dedede;">双公示报送排行</div>
							<div  id="xzxkRank" style="width: 270px; height: 235px; position:relative;padding-top: 14px;"></div>
							<div  id="xzcfRank" style="width: 270px; height: 235px; position:relative;margin-top:-13px;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div style="height: 50px; clear: both;"></div>	
					<div class="row">
					<div style="margin: 0px 60px 60px 60px;" >
					   <table id="dataTable" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr role="row" class="heading">
                                <th rowspan="2" style="text-align: center;vertical-align:middle">序号</th>
                                <th rowspan="2" style="text-align: center;vertical-align:middle">单位</th>
                                <th rowspan="2" style="text-align: center;vertical-align:middle">双公示合计</th>
                                <th colspan="2" style="text-align: center;">行政许可</th>
                                <th colspan="2" style="text-align: center;">行政处罚</th>
                            </tr>
                            <tr role="row" class="heading">
                                <th>法人</th>
                                <th>自然人</th>
                                <th>法人</th>
                                <th>自然人</th>
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
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/dpProcess/sgsProcessSize.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>