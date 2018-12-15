<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>双公示数据质量分析</title>
<style>
.heading th{text-align:center}
.odd,.even{text-align:right}
.odd :first-child,.odd :nth-child(2),.even :first-child,.even :nth-child(2){text-align:center}
input[type="radio"]{vertical-align:text-top}
</style>
<!--[if IE]>
	<style>
    input[type="radio"]{vertical-align:middle}
    </style>
<!-->
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						双公示数据质量分析
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class=""
						style="margin: 5px 60px 10px 60px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
						<form id="form-search" class="form-inline">
						           统计类型：
			                <label for="xzxk"><input type="radio" name="sgs" id="xzxk" value="0"  checked/>行政许可</label>
                			<label for="xzcf"><input type="radio" name="sgs" id="xzcf" value="1" />行政处罚</label>
			                <br />   
							统计时间：
							<input type="text" class="form-control date-icon" id="startDate" readonly="readonly" placeholder="开始时间" />
							&nbsp;至&nbsp;
							<input type="text" class="form-control date-icon" id="endDate" readonly="readonly" placeholder="结束时间"/>
							&nbsp;
							<button type="button" id="searchBtn" class="btn btn-info btn-md" onclick="publicityDataQuality.conditionSearch();"><i class="fa fa-search"></i>查询</button>
							<button type="button" class="btn btn-default btn-md " onclick="publicityDataQuality.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
							</button>
						</form>
					</div>
					<div class="col-md-12 col-sm-12" style="margin:30px 0 0px;">
						<div id="publicityBar" style="width: 70%; height: 480px;float:left;"></div>
						<div id="sgsSortBox"  style="float:left;border: 1px solid #dedede;">
					    	<div style="width: 270px; height: 38px;line-height: 34px;text-align: center;font-size: 17px;font-weight: bold;border-bottom: 1px solid #dedede;">数据报送质量排行</div>
							<div  id="sgsAccuracyRank" style="width: 270px; height: 235px; position:relative;padding-top: 14px;"></div>
							<div  id="sgsEffectiveRank" style="width: 270px; height: 235px; position:relative;margin-top:-13px;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div style="height: 50px; clear: both;"></div>
					<div style="margin: 0px 60px 60px 60px;">
						<table id="dataTable" class="table table-striped table-bordered table-hover">
							<thead>
								<tr role="row" class="heading">
								    <th>序号</th>
									<th>信息提供部门名称</th>
									<th>上报数据量</th>
									<th>入库数据量</th>
									<th>关联数据量</th>
									<!-- <th>时效数据量</th> -->
									<th>入库率</th>
									<th>关联率</th>
									<th>时效性</th>
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
		src="${pageContext.request.contextPath}/app/js/center/publicityDataQuality/publicityDataQuality.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>