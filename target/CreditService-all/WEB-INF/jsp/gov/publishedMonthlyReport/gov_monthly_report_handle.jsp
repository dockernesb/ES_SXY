<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>添加修改月报</title>
</head>
<body>

<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    <c:if test="${report.id == null}">添加月报</c:if>
                    <c:if test="${report.id != null}">修改月报</c:if>
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
                    <input type="hidden" id="id" name="id" value="${report.id}"/>
                    <div class="form-wizard">
                        <div class="form-body">
                            <div class="form-group">
                                <label class="control-label col-md-2"><span class="required">*</span>上报月份：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input id="month" class="form-control date-icon" value="${report.month}"
                                               readonly="readonly" name="month" style="background-position-x: calc(100% - 30px);" />
                                    </div>
                                </div>
                                <label class="control-label col-md-2"><span class="required">*</span>本单位公示网址：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.webUrl}" name="webUrl"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2">&nbsp;</label>
                                <div class="col-md-4" style="text-align: center;font-weight: bold;">
                                    <br/>行政许可
                                </div>
                                <label class="control-label col-md-2">&nbsp;</label>
                                <div class="col-md-4" style="text-align: center;font-weight: bold;">
                                    <br/>行政处罚
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2"><span class="required">*</span>产生数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzxkCssl}" name="xzxkCssl"/>
                                    </div>
                                </div>
                                <label class="control-label col-md-2"><span class="required">*</span>产生数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzcfCssl}" name="xzcfCssl"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2"><span class="required">*</span>本单位公示数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzxkBdwgssl}" name="xzxkBdwgssl"/>
                                    </div>
                                </div>
                                <label class="control-label col-md-2"><span class="required">*</span>本单位公示数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzcfBdwgssl}" name="xzcfBdwgssl"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2"><span class="required">*</span>报送数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzxkBssl}" name="xzxkBssl"/>
                                    </div>
                                </div>
                                <label class="control-label col-md-2"><span class="required">*</span>报送数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzcfBssl}" name="xzcfBssl"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2"><span class="required">*</span>未报送数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzxkWbssl}" name="xzxkWbssl"/>
                                    </div>
                                </div>
                                <label class="control-label col-md-2"><span class="required">*</span>未报送数量：</label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${report.xzcfWbssl}" name="xzcfWbssl"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-2"> 未报送依据： </label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <textarea class="form-control" rows="4" name="xzxkWbsyj"><c:out
                                                value="${report.xzxkWbsyj}"/></textarea>
                                    </div>
                                </div>
                                <label class="control-label col-md-2"> 未报送依据： </label>
                                <div class="col-md-4">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <textarea class="form-control" rows="4" name="xzcfWbsyj"><c:out
                                                value="${report.xzcfWbsyj}"/></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-actions" style="text-align: center;">
                            <a href="javascript:;" id="submitBtn" class="btn btn-primary"> 提交 </a>
                            <a href="javascript:;" id="backBtn" class="btn default"> 返回 </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/gov/publishedMonthlyReport/gov_monthly_report_handle.js"></script>


</body>
</html>