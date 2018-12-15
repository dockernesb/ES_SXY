<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>数据质量统计</title>
<style>
.marginBottom_5{margin-bottom:5px;}
.marginTop_5{margin-top:5px;}
.marginRight_5{margin-right:5px}
.marginRight_10{margin-right:10px}
.marginRight_15{margin-right:15px}
.form-inline{line-height:25px;padding-top:10px}
.select2-selection__rendered {border-radius:4px}
.select2-selection--multiple,.select2-selection__rendered{border-color:#e5e5e5 !important;}
.select2-selection--multiple{box-shadow:none !important;webkit-box-shadow:none !important}
.odd,.even{text-align:right}  
.odd :first-child,.odd :nth-child(2),.even :first-child,.even :nth-child(2){text-align:center} 
.conBox{float:left;margin-bottom:5px}
</style>
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
									<!-- <div class="tipp">疑问类型总数：<span id="ywlxzs"></span></div> -->
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
						style="margin: 5px 60px 10px 60px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline">
							统计主体：
			                <label for="cxjl" class="marginBottom_5 marginRight_5"><input type="radio" name="tjzt" onChange="dataQuality.changeTjzt()" id="city" value="1"  checked/>市辖部门</label>
                			<label for="zxjl" class="marginBottom_5 marginRight_15"><input type="radio" name="tjzt" onChange="dataQuality.changeTjzt()" id="area" value="2" />区县板块</label>
                			<label for="zxjl" class="marginBottom_5 marginRight_15"><input type="radio" name="tjzt" onChange="dataQuality.changeTjzt()" id="province" value="3" />省级下发</label>
					   	    <br />
					   	    <div class="conBox marginRight_15" id="dept1Div" style="width:250px">
					   	         统计部门：
                			<select id="deptId_1" class="marginBottom_5"  >
						    </select>
					   	    </div>
					   	    <div class="conBox marginRight_15" id="dept2Div" style="display:none" style="width:250px">
					   	         统计部门：
                			<select id="deptId_2" class="marginBottom_5" >
						    </select>
					   	    </div>
					   	    <div class="conBox marginRight_15" id="dept3Div" style="display:none" style="width:250px">
					   	         统计部门：
                			<select id="deptId_3" class="marginBottom_5" >
						    </select>
					   	    </div>
                            <div style="clear: both;"></div>
                            <div class="conBox">
							开始日期：
							<input type="text" class="form-control date-icon" id="startDate" readonly="readonly"  placeholder="开始日期"/>
							&nbsp;结束日期：
							<input type="text" class="form-control date-icon" id="endDate" readonly="readonly"  placeholder="结束日期"/>
							&nbsp;
							<input id="schemaName" class="form-control" placeholder="目录名称">
								&nbsp;
							<button type="button" id="searchBtn" class="btn btn-info btn-md ">
								<i class="fa fa-search"></i>
								查询
							</button>
							<button type="button" class="btn btn-default btn-md " onclick="dataQuality.conditionReset();">
										<i class="fa fa-rotate-left"></i>重置
								</button>
							</div>
							<div style="clear: both;"></div>
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
							<div class="tabbable-custom">
								<ul class="nav nav-tabs">
									<li class="active"><a href="#deptDiv" data-toggle="tab">部门统计</a></li>
									<li><a href="#schemaDiv" data-toggle="tab">目录统计</a></li>
								</ul>
								<div class="tab-content">
									<div class="tab-pane active" id="deptDiv">
										<div id="dataQualityBar"
											 style="width: 100%; height: 450px; margin-bottom: 20px;"></div>
										<div id="dataQualityTrend"
											 style="width: 100%; height: 450px; margin-bottom: 20px;"></div>
										<div style="margin: 0px 60px 60px 60px;" id="dept_fatherDiv">
											<div id="fk_enter_btns" class="hide pull-right">
												<a class="btn btn-sm blue" href="javascript:;" onclick="dataQuality.exportData(1)">导出</a>
											</div>
											<table id="dataTable" class="table table-striped table-bordered table-hover">
												<thead>
												<tr role="row" class="heading">
													<th>序号</th>
													<th>部门名称</th>
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
										<div style="margin: 0px 60px 60px 60px;display: none;" id="dept_sonDiv" >
											<input type="hidden" id="detail_deptId" />
											<input type="hidden" id="detail_deptName" />
											<div id="detail_dept_btn" class="hide pull-right">
												<%--<label style="padding-left: 50px;" class="col-sm-3 control-label pull-left">部门数据量统计</label>--%>
												<a class="btn btn-sm blue" href="javascript:;" onclick="dataQuality.exportDeptDetailData();">导出</a>
												<a class="btn btn-sm blue" href="javascript:;" onclick="dataQuality.goBack();">返回</a>
											</div>
											<table id="deptDataTable_detail" class="table table-striped table-bordered table-hover">
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
									</div>
									<div class="tab-pane" id="schemaDiv">
										<div id="dataQualitySchemaBar"
											 style="height: 450px; margin-bottom: 20px;"></div>
										<div id="dataQualitySchemaTrend"
											 style="height: 450px; margin-bottom: 20px;"></div>
										<div style="margin: 0px 60px 60px 60px;" id="schema_fatherDiv">
											<div id="fk_enter_btns_2" class="hide pull-right">
												<a class="btn btn-sm blue" href="javascript:;" onclick="dataQuality.exportData()">导出</a>
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
										<div style="margin: 0px 60px 60px 60px;display: none;" id="schema_sonDiv" >
											<input type="hidden" id="detail_schemaId" />
											<input type="hidden" id="detail_schemaName" />
											<div id="detail_schema_btn" class="hide pull-right">
												<%--<label style="padding-left: 50px;" class="col-sm-3 control-label pull-left">部门数据量统计</label>--%>
												<a class="btn btn-sm blue" href="javascript:;" onclick="dataQuality.exportSchemaDetailData();">导出</a>
												<a class="btn btn-sm blue" href="javascript:;" onclick="dataQuality.goSchemaBack();">返回</a>
											</div>
											<table id="schemaDataTable_detail" class="table table-striped table-bordered table-hover">
												<thead>
												<tr role="row" class="heading">
													<th>序号</th>
													<th>部门名称</th>
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
			</div>
		</div>
	</div>
	<%--<script type="text/javascript"--%>
		<%--src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>--%>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/center/statisAnalyze/data_quality.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>