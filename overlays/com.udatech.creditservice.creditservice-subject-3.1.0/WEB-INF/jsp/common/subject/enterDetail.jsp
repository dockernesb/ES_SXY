<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
<title>企业详细</title>
</head>
<body style="overflow-x: hidden">
	<div class="portlet box" style="margin: 0px;">
		<div class="portlet-body">
			<input id="qymc" name="qymc" value="${qyxx.JGQC}" type="hidden" />
			<input id="gszch" name="gszch" value="${qyxx.GSZCH}" type="hidden" />
			<input id="zzjgdm" name="zzjgdm" value="${qyxx.ZZJGDM}" type="hidden" />
			<input id="tyshxydm" name="tyshxydm" value="${qyxx.TYSHXYDM}" type="hidden" />
			<div class="row">
				<div class="col-md-12">
					<table class="table table-striped table-hover table-bordered">
						<tbody>
							<tr>
								<th width="10%">企业名称</th>
								<td width="20%">${qyxx.JGQC }</td>
								<th width="10%">工商注册号</th>
								<td width="20%">${qyxx.GSZCH}</td>
							</tr>
							<tr>
								<th>组织机构代码</th>
								<td>${qyxx.ZZJGDM}</td>
								<th>统一社会信用代码</th>
								<td>${qyxx.TYSHXYDM}</td>
							</tr>
							<tr>
								<th>注册资本</th>
								<td>${qyxx.ZCZJ}万</td>
								<th>注册日期</th>
								<td>${qyxx.FZRQ}</td>
							</tr>
							<tr>
								<th>法定代表人</th>
								<td>${qyxx.FDDBRXM}</td>
								<th>登记机关</th>
								<td>${qyxx.FZJGMC}</td>
							</tr>
							<tr>
								<th>所属行业名称</th>
								<td>${qyxx.SSHYMC}</td>
								<th>企业类型</th>
								<td>${qyxx.QYLXMC}</td>
							</tr>
							<tr>
								<th>经营范围</th>
								<td colspan="3">${qyxx.JYFW}</td>
							</tr>
							<tr>
								<th>企业地址</th>
								<td colspan="3">${qyxx.JGDZ}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<h3 class="form-section">股东信息</h3>
					<div class="row">
						<div class="col-md-12">
							<table id="gdxxTable" class="table table-striped table-bordered table-hover" style="width: 100%;">
								<thead>
									<tr role="row" class="heading">
										<th>股东类型</th>
										<th>股东名称</th>
										<th>认缴出资（万元）</th>
										<th>实缴出资（万元）</th>
										<th>登记机关名称</th>
										<th>登记日期</th>
										<th>公司股权出质证明</th>
										<th>变更日期</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
					<div class="div-horizontal-line"></div>
					<h3 class="form-section">董事监事高管信息</h3>
					<div class="row">
						<div class="col-md-12">
							<table id="dsjsggxxTable" class="table table-striped table-bordered table-hover" style="width: 100%;">
								<thead>
									<tr role="row" class="heading">
										<th>姓名</th>
										<th>证件类型</th>
										<th>证件号码</th>
										<th>职务类型（级别）</th>
										<th>国籍</th>
										<th>核准日期</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/subject/enterDetail.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>