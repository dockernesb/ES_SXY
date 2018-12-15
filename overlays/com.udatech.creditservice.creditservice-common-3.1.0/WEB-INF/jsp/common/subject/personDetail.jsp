<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
    <title>自然人详细</title>
</head>
<body style="overflow-x: hidden">
<input id="sfzh" name="sfzh" value="${grxx.SFZH}" type="hidden"/>
<div class="portlet box" style="margin: 0px;">
    <div class="portlet-body">
        <div class="row">
            <div class="col-md-12">
                <table class="table table-striped table-hover table-bordered">
                    <tbody>
                    <tr>
                        <th width="10%">姓名</th>
                        <td width="20%">${grxx.XM }</td>
                        <th width="10%">身份证号</th>
                        <td width="20%">${grxx.SFZH}</td>
                    </tr>
                    <tr>
                        <th>性别</th>
                        <td>${grxx.XB}</td>
                        <th>民族</th>
                        <td>${grxx.MZ}</td>
                    </tr>
                    <tr>
                        <th>职业</th>
                        <td>${grxx.ZYMC}</td>
                        <th>出生日期</th>
                        <td>${grxx.CSRQ}</td>
                    </tr>
                    <tr>
                        <th>户籍地址</th>
                        <td colspan="3">${grxx.HJDZ}</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="tabbable-custom">
                    <ul class="nav nav-tabs">
                        <li class="active">
                            <a href="#tab_1" data-toggle="tab">失信信息</a>
                        </li>
                        <li>
                            <a href="#tab_2" data-toggle="tab">表彰荣誉 </a>
                        </li>
                        <li>
                            <a href="#tab_3" data-toggle="tab">许可资质 </a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">
                            <h3 class="form-section">行政处罚信息</h3>
							<div class="row">
								<div class="col-md-12">
									<table id="xzcfTable" class="table table-striped table-bordered table-hover" style="width: 1300px;">
										<thead>
											<tr role="row" class="heading">
												<th>处罚文号</th>
												<th>处罚名称</th>
												<th width="20%">主要失信事实</th>
												<th>失信严重程度</th>
												<th>处罚结果</th>
												<th>处罚种类</th>
												<th width="20%">处罚依据</th>
												<th>处罚日期</th>
											</tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
							</div>
							<div class="div-horizontal-line"></div>
                            <h3 class="form-section">黑名单信息</h3>
                            <div class="row">
                                <div class="col-md-12">
                                    <table id="heimingdanxxTable" class="table table-striped table-bordered table-hover" style="width: 100%;">
                                        <thead>
                                        <tr role="row" class="heading">
                                            <th width="25%">主要失信事实</th>
                                            <th width="20%">行政处理决定内容</th>
                                            <th>认定文号</th>
                                            <th>认定单位</th>
                                            <th>认定日期</th>
                                        </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="div-horizontal-line"></div>
                            <h3 class="form-section">交通失信信息</h3>
                            <div class="row">
                                <div class="col-md-12">
                                    <table id="jtxxxxTable" class="table table-striped table-bordered table-hover" style="width: 100%;">
                                        <thead>
                                        <tr role="row" class="heading">
                                            <th width="30%">交通失信行为</th>
                                            <th>失信严重程度</th>
                                            <th>认定单位</th>
                                            <th>认定日期</th>
                                        </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="tab_2">
                            <h3 class="form-section">红名单信息</h3>
                            <div class="row">
                                <div class="col-md-12">
                                    <table id="hongmingdanTable" class="table table-striped table-bordered table-hover" style="width: 100%;">
                                        <thead>
                                        <tr role="row" class="heading">
                                            <th width="25%">荣誉名称</th>
                                            <th width="25%">荣誉事项</th>
                                            <th>认定文号</th>
                                            <th>认定单位</th>
                                            <th>认定日期</th>
                                        </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="tab_3">
                            <h3 class="form-section">许可资质</h3>
                            <div class="row">
                                <div class="col-md-12">
                                    <table id="xkzzTable" class="table table-striped table-bordered table-hover" style="width: 2000px;">
                                        <thead>
                                        <tr role="row" class="heading">
                                            <th>许可决定书文号</th>
                                            <th>许可证编号</th>
                                            <th width="15%">许可证名称</th>
                                            <th width="25%">许可内容（范围）</th>
                                            <th>种类</th>
                                            <th>许可生效期</th>
                                            <th>许可截止期</th>
                                            <th width="10%">批准机关全称</th>
                                            <th>批准日期</th>
                                            <th>变更核准日期</th>
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
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/subject/personDetail.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>