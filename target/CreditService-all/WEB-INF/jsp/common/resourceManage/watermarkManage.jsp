<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>水印管理</title>
</head>
<body>
	<input type="hidden" id="useType" value="${useType}" /> 
	<!-- 新建编辑模板 -->
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption" id="info_title">水印管理</div>
					<div class="actions">
						<a href="javascript:void(0);" onclick="watermarkManage.addWatermark();" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 新建
						</a>
						<a href="javascript:void(0);" onclick="watermarkManage.editWatermark();" class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i> 编辑
						</a>
						<a href="javascript:void(0);" onclick="watermarkManage.delWatermark();" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除
						</a>
						<a href="javascript:void(0);" id="backBtn" class="btn btn-default btn-sm">
							<i class="fa fa-rotate-left"></i> 返回
						</a>
					</div>
				</div>
				<div class="portlet-body form">
					<div class="row">
						<div class="col-md-12">
							<div class="form-body">
								<h4 class="form-section" style="margin-bottom: 10px;">
									<b>背部水印列表</b>
								</h4>
								<div class="row">
									<div class="col-md-12 col-sm-12">
										<table class="table table-striped table-hover table-bordered" id="watermarkGrid">
											<thead>
												<tr class="heading">
													<th width="30%">水印名称</th>
													<th width="20%">附件</th>
													<th width="25%">上传时间</th>
													<th>上传者</th>
												</tr>
											</thead>
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

	<div id="winAdd" style="display: none; margin: 30px 40px">
		<form id="addForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"><span class="required">*</span> 水印名称:</label>
					<div class="col-md-8 col-sm-8">
						<input class="form-control" id="name" name="name" autocomplete="off" maxlength="20" />
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 col-sm-3 control-label"></label>
					<div class="col-md-8 col-sm-8">
						<button type="button" class="btn btn-success upload-img" id="watermarkImg">上传水印</button>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-1 col-sm-1"></label>
					<div class="col-md-11 col-sm-11">
						<span style="color: #e02222;">1. 图片格式支持jpg,jpeg,bmp,png，上传的水印图片不能超过10M！<br>2. 水印名称最大20个字符，且只能上传一张水印图片！
						</span>
					</div>
				</div>
			</div>
		</form>
	</div>

	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/resourceManage/watermarkManage.js"></script>
</body>
</html>