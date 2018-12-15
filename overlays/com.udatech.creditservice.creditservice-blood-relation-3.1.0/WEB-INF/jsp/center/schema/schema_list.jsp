<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>征集目录管理</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/common/application.css"/>
    <style type="text/css">
        div.ccl-tool-bar {
            border: 1px solid #e7e7e7;
            background-color: #F8F8F8;
            margin: 5px;
            padding: 5px;
        }

        div.ccl-tool-bar i {
            cursor: pointer;
            margin: 5px;
        }

        div.ccl-tool-bar i:hover {
            color: #2386CA;
        }

        div.ccl-search-bar {
            margin: 15px 5px;
        }

        div.ccl-tree-panel {
            border: 1px solid #e7e7e7;
            background-color: #fafafa;
            min-height: 200px;
            margin: 15px 5px 5px 5px;
            overflow-x: auto;
        }

        table.ccl-schema-table {
            width: 100%;
        }

        table.ccl-schema-table th, table.ccl-schema-table td {
            border: 1px solid #e7e7e7;
            padding: 4px 15px;
        }

        table.ccl-schema-table th {
            /* background-color: #fafafa; */
            /* width: 80px; */
            white-space: nowrap;
            text-align: center;
        }

        div.treePanel {
            border: 1px solid #989898;
            background-color: #fafafa;
            min-height: 90px;
            position: fixed;
            display: none;
            z-index: 9999999;
            max-height: 200px;
            overflow: auto;
        }

        form#fieldForm_JC input.innerInput {
            width: 100% !important;
        }

        form#fieldForm_JC input.innerInputLen {
            /* width: 100px; */
        }

        form#fieldForm_JC td {
            padding: 5px !important;
            vertical-align: middle !important;
        }

        table.winTable {
            width: 400px;
            border: 1px solid #dedede;
            table-layout: fixed;
            margin: auto;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        table.winTable th, table.winTable td {
            height: 30px;
            vertical-align: middle;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            word-break: keep-all;
        }

        table.winTable tr.data-tr:hover {
            background-color: #eaf2ff;
        }

        table.winTable th {
            text-align: center;
        }

        table.winTable td {
            padding: 5px;
            border-top: 1px solid #dedede;
            border-left: 1px solid #dedede;
            text-align: left;
        }

        input.innerInputCode {
            text-transform: uppercase;
        }

        input.innerInputGroup, input.innerInputLen {
            width: 80px !important;
        }

        table#dataTable_JC td {
            text-align: center;
            vertical-align: middle;
        }

        div.field-sort {
            width: 25px;
            height: 25px;
            display: inline-block;
            background-repeat: no-repeat;
            cursor: pointer;
        }

        div.sort-top {
            background-image: url("${pageContext.request.contextPath}/app/images/schema/move.png");
            background-position: 7px -14px;
        }

        div.sort-up {
            background-image: url("${pageContext.request.contextPath}/app/images/schema/move.png");
            background-position: -37px -14px;
        }

        div.sort-down {
            background-image: url("${pageContext.request.contextPath}/app/images/schema/move.png");
            background-position: -60px -14px;
        }

        div.sort-bottom {
            background-image: url("${pageContext.request.contextPath}/app/images/schema/move.png");
            background-position: -17px -14px;
        }

        div#schemaDiv_JC div.dataTables_info {
            margin-left: 10px;
        }

        table.ccl-schema-table th, table.ccl-schema-table td {
            border: 0px solid #e7e7e7;
            padding: 4px 10px;
        }

        table.ccl-schema-table th {
            padding: 0px 10px 0 0;
            text-align: left;
        }

        #dataTable_JC {
            width: calc(100% - 10px);
            position: relative;
            left: 10px;
        }

        #commonFieldDiv_JC .ico_docu {
            background-position: center !important;
        }

        .thVer {
            vertical-align: middle !important;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="row" id="schemaDiv_JC">
    <div class="col-md-12">
        <div class="tabbable-custom ">
        <ul class="nav nav-tabs ">
            <li class="active">
                <a href="#tab_0_1" data-toggle="tab" id="jc">基本信息配置</a>
            </li>

            <li>
                <a href="#tab_0_2" data-toggle="tab" id="gj">归集信息配置</a>
            </li>
        </ul>

        <div class="tab-content">
            <%--基本目录配置--%>
            <div class="tab-pane active" id="tab_0_1">

                <div class="portlet box">
                    <div class="portlet-title">
                        <div class="tools" style="padding-left: 5px;">
                            <a href="javascript:void(0);" class="collapse"></a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" id="saveBtn_JC"
                               class="btn blue btn-sm">
                                <i class="fa fa-save"></i>
                                保存
                            </a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="tabbable-custom ">
                                    <ul class="nav nav-tabs ">
                                        <li class="active">
                                            <a href="#tab_5_1_JC" data-toggle="tab" id="zy">资源目录</a>
                                        </li>
                                        <li>
                                            <a href="#tab_5_2_JC" data-toggle="tab">公共指标项</a>
                                        </li>
                                    </ul>
                                    <div class="tab-content">
                                        <div class="tab-pane active" id="tab_5_1_JC">
                                            <div class="ccl-search-bar">
                                                <input type="text" class="form-control input-md" id="searchSchemaTree_JC"
                                                       placeholder="资源目录搜索"/>
                                            </div>
                                            <div class="ccl-tool-bar">
                                                <i class="fa fa-plus-circle" title="新增数据分类" id="addClassifyBtn_JC"></i>
                                                <i class="fa fa-plus" title="新增数据目录" id="addTableBtn_JC"></i>
                                                <div style="float: right;">
                                                    <i class="fa fa-edit" title="修改" id="editSchemaBtn_JC"></i>
                                                    <i class="fa fa-trash-o" title="删除" id="delSchemaBtn_JC"></i>
                                                </div>
                                            </div>
                                            <div class="ccl-tree-panel">
                                                <div id="searchSchemaTreeMsg_JC"
                                                     style="margin: 5px; color: red;display: none;">
                                                    暂无相关数据！
                                                </div>
                                                <div id="schemaTree_JC" class="ztree"></div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="tab_5_2_JC">
                                            <div class="ccl-search-bar">
                                                <input type="text" class="form-control input-md" id="searchCommonFieldTree_JC"
                                                       placeholder="公共指标搜索"/>
                                            </div>
                                            <div class="ccl-tool-bar">
                                                <i class="fa fa-plus" title="新增公共指标" id="addCommonFieldBtn_JC"></i>
                                                <div style="float: right;">
                                                    <i class="fa fa-edit" title="修改" id="editCommonFieldBtn_JC"></i>
                                                    <i class="fa fa-trash-o" title="删除" id="delCommonFieldBtn_JC"></i>
                                                    <i class="fa fa-arrow-circle-o-right" title="加入列表" id="addToList_JC"></i>
                                                </div>
                                            </div>
                                            <div id="commonFieldDiv_JC" class="ccl-tree-panel">
                                                <div id="searchCommonFieldTreeMsg_JC"
                                                     style="margin: 5px; color: red;display: none;">
                                                    暂无相关数据！
                                                </div>
                                                <div id="fieldTree_JC" class="ztree"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-9">
                                <div style="margin-bottom: 10px;">
                                    <table class="ccl-schema-table">
                                        <tr>
                                            <th width="1%" nowrap="nowrap">目录名称</th>
                                            <td><input id="nameTd_JC" class="form-control input-sm" type="text" readonly value="" style="width:100%;"/></td>
                                            <th width="1%" nowrap="nowrap">目录编码</th>
                                            <td><input id="codeTd_JC" class="form-control input-sm" type="text" readonly value="" style="width:100%;"/></td>
                                            <th width="1%" nowrap="nowrap">征集周期</th>
                                            <td width="1%"><input id="rtaskPeriod_JC" class="form-control input-sm" type="text" readonly value="" style="width:80px;"/></td>
                                            <th width="1%" nowrap="nowrap">任务有效期</th>
                                            <td width="1%"><input id="rdays_JC" class="form-control input-sm" type="text" readonly value="" style="width:80px;"/></td>
                                        </tr>
                                        <tr>
                                            <th>目录描述</th>
                                            <td colspan="10" style="word-wrap:break-word">
                                                <textarea id="rtableDesc_JC" class="form-control-d" readonly rows="6" style="resize:none"></textarea>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                                <div id="fieldBtns_JC" class="actions" style=" float: right; margin-right: 5px;">
                                    <span style="color:red; margin-right:10px; position:relative;top:2px;">*指标项可以上下拖动调整顺序</span><a
                                        class="btn btn-sm blue" id="addBtn_JC" name="tj_btn" href="javascript:;">添加</a>
                                    <!-- <span title="指标项可以上下拖拽移动顺序">帮助</span>
                                    <i class="fa fa-question-circle" style="color: #e35b5a;" title="指标项可以上下拖拽移动顺序"></i> -->
                                    <input id="check_id_JC" name="check_id" value="" type="hidden"/>
                                </div>
                                <form id="fieldForm_JC" action="#" method="post" style="width: 100%;">
                                    <div class="table-scrollable" style="width: 100%;">
                                        <div style="float: left; width: 100%;margin-bottom: 5px;">
                                            <table id="dataTable_JC"
                                                   class="table table-striped table-bordered table-hover sorted_table" style="width:98%">
                                                <thead>
                                                <tr role="row" class="heading">
                                                    <th class="thVer" style="width:5%">拖动</th>

                                                    <th class="thVer">指标名称</th>
                                                    <th class="thVer">指标编码</th>
                                                    <th class="thVer" style="width:15%">指标类型</th>
                                                    <th class="thVer" style="width:13%">指标长度</th>
                                                    <th class="thVer" style="width:12%">操作</th>

                                                </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%--归集目录配置--%>
            <div class="tab-pane" id="tab_0_2">
                <div id="allocation_list"></div>
            </div>

        </div>
        </div>
    </div>
</div>

<!-- 数据分类新增编辑弹窗 -->
<div id="classifyDiv_JC" style="display: none; margin: 30px 40px;">
    <form id="classifyForm_JC" method="post" action="${pageContext.request.contextPath}/schema/saveClassify.action"
          class="form-horizontal">
        <input type="hidden" id="classifyId_JC_classify" name="id"/>
        <div class="form-body">
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    分类名称:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="classifyName_JC" name="classifyName"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    父节点:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="classifyNameText" readonly="readonly"/>
                        <input type="hidden" name="pid"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    分类描述:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea class="form-control" id="classifyRemark_JC" name="classifyRemark" rows="4"></textarea>
                    </div>
                </div>
            </div>

        </div>
    </form>
</div>

<!-- 数据目录新增编辑弹窗 -->
<div id="tableDiv_JC" style="display: none; margin: 30px 40px;">
    <form id="tableForm_JC" method="post" action="${pageContext.request.contextPath}/schema/saveTable.action"
          class="form-horizontal">
        <input type="hidden" name="templateId" id="templateId"/>
        <input type="hidden" id="tableId" name="id"/>
        <div class="form-body">
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    目录名称:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa" id="temId" style="right: 132px;"></i>
                        <input class="form-control input-md " id="name" name="name" style="width:250px; float: left;"/>
                        <a id="selectTemp" class="btn btn-md blue" href="javascript:;" onclick="sl.selectTemplate();" style="float:right;">选择目录模板</a>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    目录编码:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="code_JC" name="code"
                               style="text-transform: uppercase;"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    征集周期:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="taskPeriod" name="taskPeriod" class="form-control"
                                style="width: 100%">
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    任务有效期:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="days" name="days"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    数据类别:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="dataCategory" name="dataCategory"
                                class="form-control" style="width: 100%">
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    目录类别:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="personType" name="personType"
                                class="form-control" style="width: 100%">
                            <option value="1">自然人</option>
                            <option value="0">法人</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    父节点:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="classifyNameText" readonly="readonly"/>
                        <input type="hidden" name="classifyId" id="classifyId_JC"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required"></span>
                    目录描述:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea class="form-control" id="tableDesc" name="tableDesc" rows="4"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- 选择模板-->
<div id="winSelectTemplate" style="display: none; margin: 10px 20px;">
    <div class="row">
        <form class="form-inline" id="enterFrom" style="margin: 0px 15px;">
            <input id="selectLogicName" name="selectLogicName" width="100%"
                   class="form-control input-md form-search" placeholder="目录名称"/>
            <input
                    id="selectLogicCode" name="selectLogicCode" width="100%"
                    class="form-control input-md form-search" placeholder="目录编码"/>
            <button type="button" class="btn btn-info btn-md form-search"
                    id="selectTemlateSearch">
                <i class="fa fa-search"></i>查询
            </button>
            <button type="button" class="btn btn-default btn-md form-search"
                    id="selectTemplateReset">
                <i class="fa fa-rotate-left"></i>重置
            </button>
        </form>
    </div>
    <table class="table table-striped table-hover table-bordered" id="templateGrid">
        <thead>
        <tr class="heading">
            <th width="10%"></th>
            <th width="45%">目录名称</th>
            <th width="45%">目录编码</th>
        </tr>
        </thead>
    </table>
</div>

<!-- 新增编辑数据目录或数据分类时，下拉框中的树 -->
<div id="treePanel" class="treePanel">
    <ul id="classifyTree" class="ztree" style="margin-top:0; width:160px;"></ul>
</div>

<!-- 批注弹窗 -->
<div id="postilDiv_JC"
     style="display: none; margin: 30px 40px; height: 220px;">
    <textarea style="width: 100%; height: 100%;" id="postil_JC"></textarea>
</div>

<!-- 规则弹窗 -->
<div id="ruleDiv_JC" style="display: none; margin: 30px 40px;">
    <table class="winTable" style="width: 100%;">
        <tr>
            <th width="30px"></th>
            <th style="border-left: 1px solid #dedede;">规则名称</th>
            <th style="border-left: 1px solid #dedede;">提示消息</th>
        </tr>
        <c:if test="${ruleList != null}">
            <c:forEach items="${ruleList}" var="rule">
                <tr class="data-tr" onclick="sl.selectRule(this)">
                    <th style="border-top: 1px solid #dedede;">
                        <input id="${rule.id}" type="checkbox" class="rule"/>
                    </th>
                    <td title='<c:out value="${rule.ruleName}" />'>
                        <c:out value="${rule.ruleName}"/>
                    </td>
                    <td title='<c:out value="${rule.msg}" />'>
                        <c:out value="${rule.msg}"/>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
    </table>
    <input type="hidden" id="rowId_JC"/>
</div>

<!-- 公共指标新增编辑弹窗 -->
<div id="commonFieldWin" style="display: none; margin: 30px 40px;">
    <form id="commonFieldForm" method="post" action="${pageContext.request.contextPath}/schema/saveCommonField.action"
          class="form-horizontal">
        <input type="hidden" id="commonFieldId" name="id"/>
        <div class="form-body">
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    指标名称:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="commonFieldName" name="name"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    指标编码:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="commonFieldCode" name="code"
                               style="text-transform: uppercase;"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    指标类型:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="commonFieldType" name="columnType" class="form-control"
                                style="width: 100%">
                            <option value="VARCHAR2">VARCHAR2</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    指标长度:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="commonFieldLen" name="len" value="200"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required"></span>
                    批注:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea class="form-control" id="commonFieldPostil" name="postil" rows="4"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/common/jquery-sortable.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/schema/schema_list.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/cclSelect/cclSelect.js"></script>
<script type="application/javascript">
    //解决ie9placeholder位置错位问题
    $(".phTips").css("marginLeft", '10px');
    $(".phTips").css("marginTop", '-35px');
    $(".phTips").css("line-height", '34px');

</script>
</body>
</html>