<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>行政处罚</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-th-list"></i>行政处罚
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
					<div class="actions">
						<button type="button" class="btn btn-default" id="startPenalty">恢复公示</button>
						<button type="button" class="btn btn-default" id="cancelPenalty">取消公示</button>
						<button type="button" class="btn btn-default" id="exportResult">导出</button>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline" id="penaltyFrom">
								<input id="xzxdr" name="xzxdr" class="form-control input-md form-search" placeholder="行政相对人名称" />
								<input id="cfjgmc" name="cfjgmc" class="form-control input-md form-search" placeholder="处罚决定机关" />
								<input id="bmmc" name="bmmc" class="form-control input-md form-search" placeholder="报送机关" />
								<input id="startDate" name="startDate" class="form-control input-md form-search date-icon" placeholder="处罚决定日期始" readonly="readonly" />
								<input id="endDate" name="endDate" class="form-control input-md form-search date-icon" placeholder="处罚决定日期终" readonly="readonly" />
								<input id="publicityStartDate" name="publicityStartDate" class="form-control input-md form-search date-icon" placeholder="公示日期始" readonly="readonly" />
								<input id="publicityEndDate" name="publicityEndDate" class="form-control input-md form-search date-icon" placeholder="公示日期终" readonly="readonly" />
								<select id="status" name="status" class="form-control input-md form-search">
									<option value=" ">全部状态</option>
									<option value="0">正常</option>
									<option value="1">撤销</option>
									<option value="2">异议</option>
									<option value="3">其他</option>
								</select>
								<button type="button" class="btn btn-info btn-md form-search" onclick="penaltyList.conditionSearch();">
									<i class="fa fa-search"></i> 查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="penaltyList.conditionReset();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="penaltyGrid">
						<thead>
							<tr class="heading">
								<th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th>
								<th>案件名称</th>
								<th>行政相对人名称</th>
								<th>统一社会信用代码</th>
								<th>居民身份证号</th>
								<th>处罚种类</th>
								<th>处罚决定日期</th>
								<th>处罚决定机关</th>
								<th>报送机关</th>
								<th>公示日期</th>
								<th>当前状态</th>
								<th>操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div style="display: none" id="details">
		<div class="portlet-body form">
			<form action="#" class="form-horizontal form-bordered form-row-stripped">
				<div class="form-body">
					<div class="form-group">
						<label class="control-label col-md-4">案件名称</label>
						<div class="col-md-8">
							<span class="help-block text" id="AJMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">行政处罚决定书文号</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFJDSWH"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">行政处罚编码</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFBM"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚事由</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFSY"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚依据</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFYJ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚种类</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFZL"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">行政相对人名称</label>
						<div class="col-md-8">
							<span class="help-block text" id="XZXDRMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">统一社会信用代码</label>
						<div class="col-md-8">
							<span class="help-block text" id="TYSHXYDM"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">组织机构代码</label>
						<div class="col-md-8">
							<span class="help-block text" id="ZZJGDM"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">工商注册号</label>
						<div class="col-md-8">
							<span class="help-block text" id="GSZCH"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">税务登记号</label>
						<div class="col-md-8">
							<span class="help-block text" id="XZXDRSWDJH"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">法定代表人名称</label>
						<div class="col-md-8">
							<span class="help-block text" id="FDDBRMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">居民身份证号</label>
						<div class="col-md-8">
							<span class="help-block text" id="FDDBRSFZH"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚结果</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFJG"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚生效期</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFSXQ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚截止期</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFJZQ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">处罚机关</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFJGMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">报送机关</label>
						<div class="col-md-8">
							<span class="help-block text" id="BMMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">当前状态</label>
						<div class="col-md-8">
							<span class="help-block text" id="DQZT"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">地方编码</label>
						<div class="col-md-8">
							<span class="help-block text" id="DFBM"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">数据更新时间戳</label>
						<div class="col-md-8">
							<span class="help-block text" id="GXSJC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">失信严重程度</label>
						<div class="col-md-8">
							<span class="help-block text" id="CFDJ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">信息使用范围</label>
						<div class="col-md-8">
							<span class="help-block text" id="SYFW"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">备注</label>
						<div class="col-md-8">
							<span class="help-block text" id="BZ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">公示日期</label>
						<div class="col-md-8">
							<span class="help-block text" id="CREATE_TIME"></span>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>

	<div id="columnTogglerContent" class="btn-group hide pull-right">
		<a class="btn green" href="javascript:;" data-toggle="dropdown">
			列信息 <i class="fa fa-angle-down"></i>
		</a>
		<div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
		<label> <input type="checkbox" class="icheck" checked data-column="1">案件名称</label>
			<label> <input type="checkbox" class="icheck" checked data-column="2">行政相对人名称</label>
			<label> <input type="checkbox" class="icheck"  data-column="3">统一社会信用代码</label>
			<label> <input type="checkbox" class="icheck"  data-column="4">居民身份证号</label>
			<label> <input type="checkbox" class="icheck" checked data-column="5">处罚种类</label>
			<label> <input type="checkbox" class="icheck" checked data-column="6">处罚日期</label>
			<label> <input type="checkbox" class="icheck" checked data-column="7">处罚机关</label>
			<label> <input type="checkbox" class="icheck" checked data-column="8">报送机关</label>
			<label> <input type="checkbox" class="icheck" checked data-column="9">公示日期</label>
			<label> <input type="checkbox" class="icheck" checked data-column="10">当前状态</label>
		</div>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/publicity/penalty_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>