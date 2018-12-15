<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>行政权力目录管理</title>
</head>
<body>
<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-cogs"></i>行政权力目录
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
                <div class="actions">
                    <a href="javascript:void(0);" onclick="power.manualAdd();" class="btn btn-default btn-sm">
                        <i class="glyphicon glyphicon-pencil"></i> 手动录入
                    </a>
                    <a href="javascript:void(0);" onclick="power.onEditPower();" class="btn btn-default btn-sm">
                        <i class="glyphicon glyphicon-edit"></i> 修改
                    </a>
                    <button class="btn btn-default btn-sm upload-file" id="uploadFile">
                        <i class="glyphicon glyphicon-import"></i> 批量导入
                    </button>
                    <button class="btn btn-default btn-sm" type="button" onclick="power.templateDownload();">
                        <i class="glyphicon glyphicon-save"></i> 下载模板
                    </button>
                    <button class="btn btn-default btn-sm" id="export">
                        <i class="glyphicon glyphicon-export"></i> 导出
                    </button>
                </div>
            </div>
            <div class="portlet-body">
                <div class="row">
                    <div class="col-md-12">
                        <form id="form-search" class="form-inline">
                            <input id="powerCodeCon"
                                   class="form-control input-md form-search" placeholder="权力编码">
                            <input id="powerNameCon"
                                   class="form-control input-md form-search" placeholder="权力名称">
                            <select id="powerTypeCon"
                                    class="form-control input-md form-search" style="width: 200px;">
                            </select>
                            <button type="button" class="btn btn-info btn-md form-search"
                                    onclick="power.conditionSearch(1);">
                                <i class="fa fa-search"></i> 查询
                            </button>
                            <button type="button" class="btn btn-default btn-md form-search"
                                    onclick="power.conditionReset();">
                                <i class="fa fa-rotate-left"></i> 重置
                            </button>
                        </form>
                    </div>
                </div>
                <table id="dataTable"
                       class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr role="row" class="heading">
                        <th class="table-checkbox">
                            <input type="checkbox" class="icheck checkall">
                        </th>
                        <th width="15%">权力编码</th>
                        <th width="20%">权力名称</th>
                        <th width="15%">权力类别</th>
                        <th width="15%">实施主体</th>
                        <th width="10%">实施依据</th>
                        <th width="15%">行政相对人类别</th>
                        <th width="10%">状态</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<div id="winAdd" style="display: none; margin: 10px 40px;">
    <form id="addEnterForm" method="post" class="form-horizontal">
        <div class="form-body">
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 权力编码
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <input class="form-control required"
                                                  name="powerCode" id="powerCode" maxlength="25"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 权力类别
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <select class="form-control" name="powerType"
                                                   id="powerType" style="width: 100%">
                    </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 权力名称
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <input class="form-control required"
                                                  name="powerName" id="powerName" maxlength="50"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 实施主体
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <input class="form-control required"
                                                  name="deptName" id="deptName" value="${deptName}" maxlength="50"
                                                  readonly/> <input type="hidden" id="deptId" name="deptId" value="${deptId}"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 实施依据
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea class="form-control" id="according" name="according"
                                  maxlength="2000"></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 行政相对人类别
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <select class="form-control" name="xzxdrType"
                                                   id="xzxdrType" style="width: 100%">
                    </select>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<div id="winEdit" style="display: none; margin: 10px 40px;">
    <form id="editEnterForm" method="post" class="form-horizontal">
        <input type="hidden" name="powerId" id="editId" value="">
        <div class="form-body">
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 权力编码
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <input class="form-control required"
                                                  name="powerCode" id="powerCodeEidt" maxlength="25"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 权力类别
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <select class="form-control" name="powerType"
                                                   id="powerTypeEdit" style="width: 100%">
                    </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 权力名称
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <input class="form-control required"
                                                  name="powerName" id="powerNameEdit" maxlength="50"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 实施主体
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <input class="form-control required"
                                                  name="deptName" id="deptNameEdit" value="${deptName}" maxlength="50"
                                                  readonly/> <input type="hidden" id="deptIdEdit" name="deptId" value="${deptId}"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 实施依据
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea class="form-control" id="accordingEdit" name="according"
                                  maxlength="2000"></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-4"> <span
                        class="required">* </span> 行政相对人类别
                </label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i> <select class="form-control" name="xzxdrType"
                                                   id="xzxdrTypeEdit" style="width: 100%">
                    </select>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<input type="hidden" id="ownerDeptId" value="${deptId}"/>

<div id="accordingDiv"
     style="display: none; margin: 30px 40px; height: 220px;">
    <textarea style="width: 100%; height: 100%;" id="accordingText" readonly></textarea>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/gov/power/gov_power_list.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>