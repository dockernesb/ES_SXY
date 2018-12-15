<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>信用报告模板</title>
<style type="text/css">
.preprinttab {
	padding: 0px !important;
	position: relative;
	right: -1px;
	z-index: 99;
}

.preprinttab ul.tabs-left {
	border-right: none !important;
}

.preprint {
	border-left: 1px solid #ddd;
}
</style>
</head>
<body>
	<div class="row" id="templateRow">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						模板定制
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" onclick="creditTemplete.watermarkManage();" class="btn btn-default btn-sm">
							<i class="icon-puzzle"></i> 水印管理
						</a>
						<a href="javascript:void(0);" onclick="creditTemplete.addTemplate();" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 新建
						</a>
						<a href="javascript:void(0);" onclick="creditTemplete.editTemplate();" class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i> 编辑
						</a>
						<a href="javascript:void(0);" onclick="creditTemplete.deleteTemplate();" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除
						</a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row" style="padding: 2px 15px;">
						<c:if test="${empty templateList}">
							<span class="col-md-12" style="text-align: center; font-size: 18px; color: gray;">暂无模板信息，请新建模板。</span>
						</c:if>
						<div class="col-md-2 col-sm-2 col-xs-2 preprinttab">
							<ul class="nav nav-tabs tabs-left">
								<c:forEach var="template" items="${templateList}" varStatus="status">
									<c:if test="${status.index == 0 }">
										<li class="active">
									</c:if>
									<c:if test="${status.index > 0 }">
										<li>
									</c:if>
									<a href="#${template.id }" data-toggle="tab" title="${template.creditName}" onclick="creditTemplete.previewReport(this);">
										<c:if test="${template.isDefault == 0 }">
											<span class="badge badge-default" id="msgLabel">默认</span>
										</c:if>
										${template.creditName}
									</a>
									</li>
								</c:forEach>
							</ul>
						</div>
						<div class="col-md-10 col-sm-10 col-xs-10 preprint">
							<div class="tab-content">
								<c:forEach var="template" items="${templateList}" varStatus="status">
									<c:if test="${status.index == 0 }">
										<div class="tab-pane active" id="${template.id }">
									</c:if>
									<c:if test="${status.index > 0 }">
										<div class="tab-pane fade" id="${template.id }">
									</c:if>
									<h4>模板【${template.creditName}】产生的信用报告打印预览</h4>
									<div class="row">
										<div class="col-md-12">
											<div id="${template.id }_previewDiv"></div>
										</div>
									</div>
							</div>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>

	<div id="templateContent" style="display: none;"></div>
	<script type="text/javascript" src="${rsa}/global/plugins/bootstrap-tabdrop/js/bootstrap-tabdrop.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/resourceManage/template.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>