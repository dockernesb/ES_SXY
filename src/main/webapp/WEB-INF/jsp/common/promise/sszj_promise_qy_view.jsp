<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>承诺处理查看</title>
</head>
<body>

	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
						承诺处理查看
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
					<div class="actions">
						<a href="javascript:void(0);" id="backBtn2" class="btn btn-default btn-sm"> 返回 </a>
					</div>
				</div>
				<div class="portlet-body form">
					<div style="height: 10px;"></div>
					<form action="#" class="form-horizontal" id="submit_form" method="POST">
						<input type="hidden" id="id" name="id" value="${promise.id}" />
						<input type="hidden" id="cnlb" value="${promise.cnlbKey}" />
						<input type="hidden" id="deptId" value="${promise.deptId}" />
						<input type="hidden" id="from" value="${from}" />
						<div class="form-wizard">
							<div class="form-body">
								<div class="form-group">
									<label class="control-label col-md-2"> 企业名称： </label>
									<div class="col-md-9">
										<div class="input-icon right">
											<i class="fa"></i>
											<input class="form-control" value="${promise.qymc}" readonly="readonly" />
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2"> 工商注册号： </label>
									<div class="col-md-9">
										<div class="input-icon right">
											<i class="fa"></i>
											<input class="form-control" value="${promise.gszch}" readonly="readonly" />
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2"> 组织机构代码： </label>
									<div class="col-md-9">
										<div class="input-icon right">
											<i class="fa"></i>
											<input class="form-control" value="${promise.zzjgdm}" readonly="readonly" />
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2"> 统一社会信用代码： </label>
									<div class="col-md-9">
										<div class="input-icon right">
											<i class="fa"></i>
											<input class="form-control" value="${promise.tyshxydm}" readonly="readonly" />
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2">
										<span class="required"></span>
										处理意见：
									</label>
									<div class="col-md-9">
										<div class="input-icon right">
											<i class="fa"></i>
											<textarea class="form-control" id="clyj" name="clyj" rows="4" readonly="readonly">${promise.clyj}</textarea>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2">
										<span class="required"></span>
										有效期：
									</label>
									<div class="col-md-9">
										<div class="input-icon right">
											<i class="fa"></i>
											<c:if test="${promise.yxq eq 1}">
												<input class="form-control" value="一年" readonly="readonly" />
											</c:if>
											<c:if test="${promise.yxq eq 2}">
												<input class="form-control" value="二年" readonly="readonly" />
											</c:if>
											<c:if test="${promise.yxq eq 3}">
												<input class="form-control" value="三年" readonly="readonly" />
											</c:if>
										</div>
									</div>
								</div>
							</div>
							<div class="form-actions" style="text-align: center;">
								<a href="javascript:;" id="backBtn" class="btn default"> 返回 </a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/app/js/common/sszjpromise/sszj_promise_qy_view.js"></script>


</body>
</html>