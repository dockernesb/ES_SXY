<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>定时任务管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-globe"></i>定时任务列表
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
					<div class="actions">
					    <shiro:hasPermission name="system.quartz.trigger.create">
						<a href="javascript:void(0);" onclick="trigger.addTrigger();" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 新增任务
						</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.quartz.trigger.delete">
						<a href="javascript:void(0);" onclick="trigger.deleteConfirm();" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除任务
						</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.quartz.trigger.pause">
						<a href="javascript:void(0);" onclick="trigger.pause();" class="btn btn-default btn-sm">
							<i class="fa fa-pause"></i> 暂停任务
						</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.quartz.trigger.resume">
						<a href="javascript:void(0);" onclick="trigger.resume();" class="btn btn-default btn-sm">
							<i class="fa fa-play"></i> 恢复任务
						</a>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
							    <input id="triggerName" class="form-control input-md" placeholder="触发器名称" /> &nbsp;
								<input id="jobName" class="form-control input-md" placeholder="任务名称" /> &nbsp; 
								<button type="button" class="btn btn-info btn-md" onclick="trigger.conditionSearch(1);">
									<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md" onclick="trigger.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="triggersGrid">
						<thead>
							<tr class="heading">
								<th style="min-width: 150px;">触发器名称</th>
								<th style="min-width: 120px;">触发器状态</th>
								<th>任务名称</th>
								<th>任务描述</th>
								<th>下次执行时间</th>
								<th>上次执行时间</th>
								<th>开始时间</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 30px 40px">
		<form id="addTriggerForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 触发器名称</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="triggerName" name="triggerName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 任务描述</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <select class="form-control" style="width: 100%" id="jobId" name="jobId">
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> cron表达式</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i> <input class="form-control" id="cronExpression" name="cronExpression" />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/quartz/trigger_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>