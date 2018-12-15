<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>审查详细</title>
</head>
<body>
	<div class="portlet box red-intense">
		<div class="portlet-title">
			<div class="caption">
				<i class="fa fa-file-text-o"></i>法人信用审查详细
			</div>
			<div class="tools" style="padding-left: 5px;">
				<a href="javascript:void(0);" class="collapse"></a>
			</div>
			<div class="actions">
				<button type="button" class="btn btn-default" onclick="creditCheckDetail.goBack();">返回</button>
			</div>
		</div>
		<div class="portlet-body form">
			<input id="applyId" name="applyId" value="${id}" type="hidden" />
			<input id="status" name="status" value="${status}" type="hidden" />
			<input id="path_hcfj" name="path_hcfj" value="${path_hcfj}" type="hidden" />
			<form id="creditCheckApplyForm" method="post" class="form-horizontal">
				<div class="form-body">
					<div class="form-group">
						<label class="control-label col-md-1"> 办件编号 </label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" id="bjbh" name="bjbh" value="${creditExamine.bjbh }" readonly="readonly" />
							</div>
						</div>
						<label class="control-label col-md-2">操作用户</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" id="czyh" name="czyh" value="${userName}" readonly="readonly" />
								<input name="userId" value="${sysuserId}" type="hidden" />
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1"> 审查名称 </label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" maxlength="50" value="${creditExamine.scmc }" readonly="readonly" />
							</div>
						</div>
						<label class="control-label col-md-2">审查部门</label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<input class="form-control" name="scbm" value="${deptName }" readonly="readonly" />
								<input name="departentId" value="${departmentId}" type="hidden" />
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1"> 审查类别 </label>
						<div class="col-md-4">
							<div class="input-icon right">
								<textarea rows="3" style="resize: none;" class="form-control" maxlength="100" readonly="readonly">${scxxl }</textarea>
							</div>
						</div>
						<label class="control-label col-md-2"> 审查说明 </label>
						<div class="col-md-4">
							<div class="input-icon right">
								<i class="fa"></i>
								<textarea rows="3" style="resize: none;" class="form-control" id="scsm" name="scsm" maxlength="100" readonly="readonly">${creditExamine.scsm }</textarea>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-1">
							起止时间
						</label>
						<div class="col-md-2">
							<input class="form-control" name="scsjs" value="${scsjs }" readonly="readonly" />
						</div>
						<div class="col-md-2">
							<input class="form-control" name="scsjz" value="${scsjz }" readonly="readonly" />
						</div>
					</div>
					<div class="form-group">
						<c:if test="${not empty path_sqfj}">
							<label class="control-label col-md-1"> 申请附件</label>
							<div class="col-md-10">
								<button type="button" class="btn btn-success" onclick="creditCheckDetail.downLoadReport('${path_sqfj}', '${path_sqfjName}');">下载附件
								</button>
							</div>
						</c:if>
					</div>
					<hr>
					<div class="form-group" style="padding-right: 15px;">
						<label class="col-md-2" style="font-size: 18px;">企业名单 </label>
					</div>
					<div class="form-group">
						<div class="col-md-12 portlet-body">
							<table class="table table-striped table-hover table-bordered" id="enterGrid" style="width: 100%;">
								<thead>
									<tr class="heading">
										<th style="width: 4%;"></th>
										<th style="width: 26%;">企业名称</th>
										<th style="width: 22%;">工商注册号</th>
										<th style="width: 20%;">组织机构代码</th>
										<th style="width: 22%;">统一社会信用代码</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<div class="form-group" style="padding-right: 15px; display: none;" id="shyj">
						<label class="control-label col-md-1">审核意见</label>
						<div class="col-md-4">
							<textarea rows="3" style="resize: none;" class="form-control" readonly="readonly">${creditExamineHis.opinion}</textarea>
						</div>
					</div>
					<div class="form-group" style="padding-right: 15px; display: none;" id="shfj">
						<label class="control-label col-md-1">附件</label>
						<div class="col-md-4">
							<button type="button" class="btn btn-success" onclick="creditCheckDetail.downLoadReport('${path_hcfj}', '${path_hcfjName}');" >点击下载审查报告</button>
						</div>
					</div>
				</div>
				<div class="form-actions">
					<div class="row">
						<div class="col-md-12 text-center">
							<button type="button" class="btn btn-default" onclick="creditCheckDetail.goBack();">返回</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/gov/creditCheck/creditCheckDetail.js"></script>
</html>
