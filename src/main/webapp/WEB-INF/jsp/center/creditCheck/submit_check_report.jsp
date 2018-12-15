<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>法人信用审查报告上传</title>
</head>
<body>

<div class="row objection-apply">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    法人信用审查报告上传
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
            </div>

            <div class="portlet-body form">
                <form action="#" class="form-horizontal" id="submit_form" method="POST">
                    <input type="hidden" id="id" value="${creditExamine.id}"/><br/>
                    <div class="form-wizard">
                        <div class="form-body">
                            <div class="form-group">
                                <label class="control-label col-md-3">审查名称：</label>
                                <div class="col-md-6">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" value="${creditExamine.scmc}" readonly="readonly"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3">审查报告：</label>
                                <div class="col-md-6">
                                    <c:if test="${hcfj != null}">
                                        <div class="preview-img-panel">
                                            <div class="preview-file">
                                                <div class="preview-icon">
                                                    <img src="${pageContext.request.contextPath}${hcfj.icon}"/>
                                                </div>
                                                <div class="preview-name">${hcfj.fileName}</div>
                                                <div class="preview-operate">
                                                    <div class="preview-download"
                                                         onclick="downloadFile('${hcfj.uploadFileId}');">下载
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3"><span class="required">*</span>上传附件：</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-success" id="uploadFile">上传附件</button>
                                    <div style="clear: both;padding-top:5px;">
                                        <span style="color: #e02222;">附件格式支持doc,docx,pdf，附件大小不能超过20M！</span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-3">审查意见：</label>
                                <div class="col-md-6">
                                    <div class="input-icon right">
                                        <i class="fa"></i>
                                        <textarea class="form-control" id="bz" name="bz" rows="5"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-actions">
                            <div class="row">
                                <div class="col-md-12 center">
                                    <a href="javascript:;" class="btn blue" id="submitBtn">
                                        提交
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/creditCheck/submit_check_report.js"></script>

</body>
</html>