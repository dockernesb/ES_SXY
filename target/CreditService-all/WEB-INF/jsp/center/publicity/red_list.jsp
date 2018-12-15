<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>红榜</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-th-list"></i>红榜
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
					<div class="actions">
						<button type="button" class="btn btn-default" id="exportResult">导出</button>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline" id="redFrom">
								<input id="qymc" name="qymc" class="form-control input-md form-search" placeholder="企业名称" />
								<input id="gszch" name="gszch" class="form-control input-md form-search" placeholder="工商注册号" />
								<input id="zzjgdm" name="zzjgdm" class="form-control input-md form-search" placeholder="组织机构代码" />
								<input id="tyshxydm" name="tyshxydm" class="form-control input-md form-search" placeholder="统一社会信用代码" />
								<input id="tgbm" name="tgbm" class="form-control input-md form-search" placeholder="提供部门" />
								<input id="startDate" name="startDate" class="form-control input-md form-search date-icon" placeholder="公示截止期始" readonly="readonly" />
								<input id="endDate" name="endDate" class="form-control input-md form-search date-icon" placeholder="公示截止期止" readonly="readonly" />
								<select id="status" name="status" class="form-control input-md form-search">
									<option value=" ">全部状态</option>
									<option value="1">待公示</option>
									<option value="2">公示中</option>
									<option value="3">已公示</option>
								</select>
								<button type="button" class="btn btn-info btn-md form-search" onclick="redList.conditionSearch();">
									<i class="fa fa-search"></i> 查询
								</button>
								<button type="button" class="btn btn-default btn-md form-search" onclick="redList.conditionReset();">
									<i class="fa fa-rotate-left"></i> 重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="redGrid">
						<thead>
							<tr class="heading">
								<th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th>
								<th>企业名称</th>
								<th>组织机构代码</th>
								<th>工商注册号</th>
								<th>统一社会信用代码</th>
								<th>荣誉名称</th>
								<th>列入日期</th>
								<th>提供部门</th>
								<th>公示截止期</th>
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
						<label class="control-label col-md-4">荣誉名称</label>
						<div class="col-md-8">
							<span class="help-block text" id="RYMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">认定文号</label>
						<div class="col-md-8">
							<span class="help-block text" id="RDWH"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">机构全称中文</label>
						<div class="col-md-8">
							<span class="help-block text" id="JGQC"></span>
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
						<label class="control-label col-md-4">认定日期</label>
						<div class="col-md-8">
							<span class="help-block text" id="RDRQ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">认定部门全称</label>
						<div class="col-md-8">
							<span class="help-block text" id="RDJGQC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">备注</label>
						<div class="col-md-8">
							<span class="help-block text" id="BZ"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">信息提供部门全称</label>
						<div class="col-md-8">
							<span class="help-block text" id="BMMC"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-4">公示截止期</label>
						<div class="col-md-8">
							<span class="help-block text" id="GSJZQ"></span>
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
			<label> <input type="checkbox" class="icheck" checked data-column="1">企业名称</label>
			<label> <input type="checkbox" class="icheck" data-column="2">组织机构代码</label>
			<label> <input type="checkbox" class="icheck" data-column="3">工商注册号</label>
			<label> <input type="checkbox" class="icheck" checked data-column="4">统一社会信用代码</label>
			<label> <input type="checkbox" class="icheck" checked data-column="5">荣誉名称</label>
			<label> <input type="checkbox" class="icheck" checked data-column="6">列入日期</label>
			<label> <input type="checkbox" class="icheck" checked data-column="7">提供部门</label>
			<label> <input type="checkbox" class="icheck" checked data-column="8">公示截止期</label>
			<label> <input type="checkbox" class="icheck" checked data-column="9">当前状态</label>
		</div>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/publicity/red_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>