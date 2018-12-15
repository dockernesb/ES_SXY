<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>信用审查上传</title>
</head>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<body>
	<div class="portlet box red-intense">
		<div class="portlet-title">
			<div class="caption">
				<i class="fa fa-pencil"></i>法人信用审查上传
			</div>
			<div class="tools" style="padding-left: 5px;">
				<a href="javascript:void(0);" class="collapse"></a>
			</div>
			<div class="actions">
				<a href="javascript:void(0);" class="btn btn-default btn-sm" onclick="cCreditCheckUpload.manualAdd();">
					<i class="glyphicon glyphicon-pencil"></i> 手动录入
				</a>
				<%--<button type="button" class="btn btn-default btn-sm" onclick="cCreditCheckUpload.manualAdd();">
					<i class="glyphicon glyphicon-pencil"></i> 手动录入
				</button>--%>
				<button type="button" class="btn btn-default btn-sm upload-file" id="batchAdd">
					<i class="glyphicon glyphicon-import"></i> 批量导入
				</button>
				<button type="button" class="btn btn-default btn-sm" onclick="cCreditCheckUpload.templateDownload();">
					<i class="glyphicon glyphicon-save"></i> 下载模板
				</button>
				<button type="button" class="btn btn-default btn-sm" onclick="cCreditCheckUpload.conditionReset();">
					<i class="fa fa-rotate-left"></i> 重置
				</button>
			</div>
		</div>
		<div class="portlet-body form">
			<form id="cCreditCheckUploadForm" method="post" class="form-horizontal">
				<input id="bjbh" name="bjbh" value="${bjbh}" type="hidden"/>
				<div class="form-body">
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">
							<span class="required">* </span>
							审查名称
						</label>
						<div class="col-sm-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" maxlength="50" id="scmc" name="scmc" value="" />
							</div>
						</div>
						<label class="control-label col-md-2" style="min-width: 100px;">
							<span class="required">* </span>
							审查部门
						</label>
						<div class="col-sm-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<select class="form-control col-sm-4" id="departentId" name="departentId"></select>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1" style="min-width: 100px;">
							<span class="required">* </span>
							审查类别
						</label>
						<div class="col-sm-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<select id="scxxl" name="scxxl"  multiple class="form-control col-sm-4">
								</select>
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
					<hr>
					<div class="form-group">
						<div class="col-md-12 portlet-body">
							<table class="table table-striped table-hover table-bordered" id="enterGrid" style="width: 100%;">
								<thead>
									<tr  class="heading">
										<th style="width: 4%;"></th>
										<th style="width: 26%;">企业名称</th>
										<th style="width: 22%;">工商注册号</th>
										<th style="width: 20%;">组织机构代码</th>
										<th style="width: 22%;">统一社会信用代码</th>
										<th style="width: 6%;">操作</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
				<div class="form-actions">
					<div class="row">
						<div class="col-md-12 text-center">
							<button type="button" class="btn btn-primary" onclick="cCreditCheckUpload.conditionAdd();">生成报告</button>
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
					<label class="control-label col-md-4">
							<span class="required">* </span>
							企业名称
					</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="qymc" id="qymc" maxlength="30" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4">组织机构代码</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="zzjgdm" id="zzjgdm" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4">工商注册号</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="gszch" id="gszch" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-4">统一社会信用代码</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" name="shxydm" id="shxydm" maxlength="20" />
						</div>
					</div>
				</div>
				<div class="alert alert-warning" style="margin-left: 10px;">
					<i class="fa fa-warning"></i> 提示：企业名称必填，工商注册号、组织机构代码和统一社会信用代码至少填写一个。
				</div>
			</div>
		</form>
	</div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditCheck/cCreditCheckUpload.js"></script>
</html>
