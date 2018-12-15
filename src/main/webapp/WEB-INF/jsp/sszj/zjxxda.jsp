<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>中介信息档案</title>
</head>
<body>
<div id="fatherDiv">
    <div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-th-list"></i>中介信息档案
                </div>
                <div class="tools">
                    <a href="javascript:;" class="collapse"> </a>
                </div>
                <div class="actions">
                    <button type="button" class="btn btn-default" id="addDept">
                        <i class="glyphicon glyphicon-pencil"></i>新增机构</button>
                    <button type="button" class="btn btn-default" id="updateDept" onclick="zjxxda.updateSszj();">
                        <i class="glyphicon glyphicon-edit"></i>修改</button>
                    <button type="button" class="btn btn-default" id="deleteDept" onclick="zjxxda.deleteSszj();">
                        <i class="fa fa-trash-o"></i>删除</button>
                    <button type="button" class="btn btn-default" onclick="zjxxda.templateDownload();">
                        <i class="glyphicon glyphicon-save"></i>机构模板下载</button>
                    <button type="button" class="btn btn-default btn-sm upload-file" id="leadResult">
                        <i class="glyphicon glyphicon-import"></i> 批量导入</button>
                </div>
            </div>
            <div class="portlet-body">
                <div class="row">
                    <div class="col-md-12">
                        <form class="form-inline" id="licensingFrom">
                            <input id="jgmc" name="jgmc" class="form-control input-md form-search" placeholder="机构名称" />
                            <input id="bmmc" name="bmmc" class="form-control input-md form-search" placeholder="部门名称" />
                            <button type="button" class="btn btn-info btn-md form-search" onclick="zjxxda.conditionSearch();">
                                <i class="fa fa-search"></i> 查询
                            </button>
                            <button type="button" class="btn btn-default btn-md form-search" onclick="zjxxda.conditionReset();">
                                <i class="fa fa-rotate-left"></i> 重置
                            </button>
                        </form>
                    </div>
                </div>
                <table class="table table-striped table-hover table-bordered" id="zjxxdaGrid">
                    <thead>
                    <tr class="heading">
                        <th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th>
                        <th>机构名称</th>
                        <th>联系电话</th>
                        <th>法人代表(负责人)</th>
                        <th>执业人员</th>
                        <th>部门名称</th>
                        <th>创建时间</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</div>
</div>
<div id="childDiv" style="display:none">
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sszj/zjxxda.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>