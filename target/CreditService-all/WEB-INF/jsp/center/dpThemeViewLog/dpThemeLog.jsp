<%@ page language="java" contentType="text/html;  charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上报省或信用中国的数据统计日志</title>
</head>
<body>
   <div class="row">
			<div class="col-md-12">
				<div class="portlet box red-intense">
					<div class="portlet-title">
						<div class="caption">
							<i class=""></i>数据报送记录
						</div>
						<div class="actions">
					    <a href="javascript:void(0);" class="btn exportData btn-default btn-sm">
							<i class="fa fa-print"></i> 导出
						</a>						
					</div>
					</div>
					<div class="portlet-body">
						<div class="row">
							<div class="col-md-12">
								<form class="form-inline" id="rightDataTitle">
								 	&nbsp;
								 	<input id="beginDate" class="form-control input-md form-search date-icon" placeholder="申诉时间始" readonly="readonly"/>
								 	<input id="endDate" class="form-control input-md form-search date-icon" placeholder="申诉时间止" readonly="readonly"/>
									
									&nbsp;
									<select id="messageType" class="form-control input-md form-search">	
									     <option value="">信息类型</option>									
									     <option value="1">双公示行政许可</option>									
									     <option value="2">双公示行政处罚</option>									
									</select>
									&nbsp;
									<select id="sblx" class="form-control input-md form-search">	
									     <option value="">上报类型</option>									
									     <option value="0">省平台</option>									
									     <option value="1">信用中国</option>									
									</select>
									&nbsp;
									<select id="dataStatus" class="form-control input-md form-search">
										<option value="">全部状态</option>
										<option value="1">提交成功</option>
										<option value="2">提交失败</option>
									</select>
									&nbsp;									
									<button type="button" class="btn btn-info btn-md form-search" onclick="dpLog.queryData();">
									<i class="fa fa-search"></i> 查询
									</button>						
									&nbsp;
									<button type="button" class="btn btn-default btn-md form-search" onclick="dpLog.clearData();">
										<i class="fa fa-rotate-left"></i> 重置
									</button>
									
									
								</form>
							</div>
						</div>
						<br>
						<div class="row" >
						<div class="col-md-12" id="tablePanel">
							
						</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	<div id="columnTogglerContent" class="btn-group hide pull-right">
		<a class="btn green" href="javascript:;" data-toggle="dropdown">
			列信息 <i class="fa fa-angle-down"></i>
		</a>
		<div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
		
			
		</div>
    </div>

	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/dpThemeViewLog/dpThemeLog.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>