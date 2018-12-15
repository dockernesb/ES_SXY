<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <title>模板内容配置</title>
</head>
<body>
<!-- 新建编辑模板 -->
<div class="row">
    <!-- 模板id -->
    <input type="hidden" id="templateId_hide" name="templateId" value="${templateId}"/> <input type="hidden"
                                                                                               id="opType_hide" value="${opType}"/>
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption" id="info_title">信用报告模板</div>
                <div class="actions">
                    <a href="javascript:void(0);" class="btn btn-default btn-sm" onclick="templeteConfig.goBack();">
                        <i class="fa fa-rotate-left"></i> 返回
                    </a>
                </div>
            </div>
            <div class="portlet-body form">
                <div class="row">
                    <div class="col-md-12">
                        <!-- BEGIN FORM-->
                        <form class="form-horizontal" id="addTemplateForm">
                            <div class="form-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>模板名称：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i> <input type="text" class="form-control" id="creditName" name="creditName">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>报告标题：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i> <input type="text" class="form-control" id="reportTitle" name="reportTitle">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>模板用途：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <select class="form-control" id="useType" name="useType" style="width: 100%;"></select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>背部水印：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <select class="form-control" id="bgImg" name="bgImg" style="width: 100%;"></select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>地址：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i> <input type="text" class="form-control" id="address" name="address">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>报告出处：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i> <input type="text" class="form-control" id="reportSource" name="reportSource">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>联系人：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i> <input type="text" class="form-control" id="contact" name="contact">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>联系电话：</label>
                                            <div class="col-md-9">
                                                <div class="input-icon right">
                                                    <i class="fa"></i> <input type="text" class="form-control" id="contactPhone" name="contactPhone">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>是否默认：</label>
                                            <div class="col-md-9">
                                                <div class="radio-list">
                                                    <div class="input-icon right">
                                                        <i class="fa"></i>
                                                        <div class="input-group">
                                                            <div class="icheck-inline">
                                                                <label> <input type="radio" name="isDefault" value="0" class="icheck"> 默认
                                                                </label> <label> <input type="radio" name="isDefault" value="1" checked
                                                                                        class="icheck"> 非默认
                                                            </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3"><span style="color: red">*</span>模板分类：</label>
                                            <div class="col-md-9">
                                                <div class="radio-list">
                                                    <div class="input-icon right">
                                                        <i class="fa"></i>
                                                        <div class="input-group">
                                                            <div class="icheck-inline">
                                                                <label> <input type="radio" name="category" value="0" checked class="icheck"> 法人
                                                                </label> <label> <input type="radio" name="category" value="1" class="icheck"> 自然人
                                                            </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--/row-->
                            </div>
                        </form>
                        <!-- END FORM-->
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-body">
                            <h4 class="form-section" style="margin-bottom: 10px;">模板内容</h4>
                            <div class="row">
                                <div class="col-md-3 col-sm-3">
                                    <div style="border: 1px solid #dedede; min-height: 400px; margin-top: 6px; background-color: #f9f9f9;">
                                        <button type="button" class="btn blue btn-sm" id="editThemeDisplayOrder" style="margin-left: 5px;">编辑顺序
                                        </button>
                                        <button type="button" class="btn blue btn-sm" id="saveThemeDisplayOrder" style="display: none;">保存顺序</button>
                                        <div id="themeTree" class="ztree" style="margin: 5px"></div>
                                    </div>
                                </div>
                                <div class="col-md-9 col-sm-9">
                                    <table class="table table-striped table-hover table-bordered" id="themeColumnGrid">
                                        <thead>
                                        <tr class="heading">
                                            <th class="table-checkbox"><input type="checkbox" id="checkall" class="icheck"></th>
                                            <th width="25%">字段描述</th>
                                            <th width="30%">字段别名</th>
                                            <th width="30%">显示顺序</th>
                                            <th style="text-align: center;">操作</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <div class="row" style="margin-top: 10px;">
                                <div class="col-md-12">
                                    <div class="form-actions">
                                        <div class="row">
                                            <div class="col-md-12 text-center">
                                                <button type="button" class="btn blue" onclick="templeteConfig.configure();">提交</button>
                                                <button type="button" class="btn default" onclick="templeteConfig.goBack();">取消</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    // 放在js文件中无法取到值，所以放这里取
    var tempalteThemeList = '${tempalteThemeList}';
    var tempalteThemeColumnList = '${tempalteThemeColumnList}';
    var template = '${template}';
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/resourceManage/templateConfig.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>