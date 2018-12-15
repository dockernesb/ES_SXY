<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>自然人审查申请</title>
</head>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<body>
	<div class="portlet box red-intense">
		<div class="portlet-title">
			<div class="caption">
				<i class="fa fa-pencil"></i>自然人信用审查申请
			</div>
			<div class="tools" style="padding-left: 5px;">
				<a href="javascript:void(0);" class="collapse"></a>
			</div>
		</div>
		<div class="portlet-body form">
			<form id="creditCheckApplyForm" method="post" class="form-horizontal">
				<div class="form-body">
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">办件编号</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" id="bjbh" name="bjbh" value="${bjbh}" readonly="readonly" />
							</div>
						</div>
						<label class="control-label col-md-2">申请人</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" id="czyh" name="czyh" value="${userName}" readonly="readonly" />
								<input name="userId" value="${sysuserId}" type="hidden"/>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">
							<span class="required">* </span>
							审查名称
						</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" maxlength="50" id="scmc" name="scmc" value="" />
							</div>
						</div>
						<label class="control-label col-md-2">审查部门</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" name="scbm" value="${departmentName}" readonly="readonly" />
								<input name="departentId" value="${departmentId}" type="hidden"/>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">
							<span class="required">* </span>
							审查类别
						</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<select id="scxxl" name="scxxl" class="form-control" multiple>
									<%--<option value="商业违约信息">商业违约信息</option>--%>
									<%--<option value="个人处罚信息">个人处罚信息</option>--%>
									<%--<option value="个人执行信息">个人执行信息</option>--%>
								</select>
							</div>
						</div>
						<label class="control-label col-md-2">
							<span class="required">* </span>
							审查说明
						</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<textarea rows="3" style="resize: none;" class="form-control" id="scsm" name="scsm" maxlength="100"></textarea>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">
							<span class="required">* </span>
							起止时间
						</label>
						<div class="col-md-2">
							<input id="scsjs" name="scsjs" class="form-control input-md form-search date-icon" readonly="readonly">
						</div>
						<div class="col-md-2">
							<input id="scsjz" name="scsjz" class="form-control input-md form-search date-icon" readonly="readonly">
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">
							<span class="required">* </span>
							上传附件
						</label>
						<div class="col-md-10">
							<button type="button" class="btn btn-success" id="uploadImg">点击上传附件</button>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1">
						</label>
						<div class="col-md-10">
							<span style="color: #e02222;">附件格式支持jpg,jpeg,gif,bmp,png,pdf，附件大小不能超过20M！</span>
						</div>
					</div>
					<hr>
					<div class="form-group" style="padding-right: 15px;">
						<label class="col-md-2" style="font-size: 18px;">
							添加名单
						</label>
						<div style="text-align: right;">
							<button type="button" class="btn btn-info btn-sm" onclick="pCreditCheckApply.manualAdd();">手动录入</button>&nbsp;
							<button type="button" class="btn btn-info btn-sm upload-file" id="batchAdd">批量导入</button>&nbsp;
							<button type="button" class="btn yellow-crusta btn-sm" onclick="pCreditCheckApply.templateDownload();">下载模板</button>&nbsp;
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-12 portlet-body">
							<table class="table table-striped table-hover table-bordered" id="enterGrid" style="width: 100%;">
								<thead>
									<tr  class="heading">
										<th style="width: 4%;"></th>
										<th style="width: 26%;">姓名</th>
										<th style="width: 54%;">身份证号</th>
										<th style="width: 16%;">操作</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
				<div class="form-actions">
					<div class="row">
						<div class="col-md-12 text-center">
							<button type="button" class="btn btn-primary" onclick="pCreditCheckApply.conditionAdd();">申请</button>
							<button type="button" class="btn btn-default" onclick="pCreditCheckApply.conditionReset();">重置</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 10px 40px;">
		<form id="addEnterForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="control-label col-md-4"><span class="required">* </span>姓名</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="xm" id="xm" maxlength="30" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4"><span class="required">* </span>身份证号</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="sfzh" id="sfzh" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="alert alert-warning" style="margin-left: 10px;">
					<i class="fa fa-warning"></i> 提示：姓名必填，身份证号必须符合规则。
				</div>
			</div>
		</form>
	</div>
	
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/gov/pCreditCheck/pCreditCheckApply.js"></script>
</html>
