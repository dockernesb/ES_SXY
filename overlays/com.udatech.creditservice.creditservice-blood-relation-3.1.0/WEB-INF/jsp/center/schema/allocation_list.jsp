<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>归集信息配置</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/common/application.css" />
    <style type="text/css">
        .hideDiv{
            pointer-events: none;
        }
        #schemaTree.ztree li a.level0 {
            /* 	width: 200px; */
            height: 34px;
            text-align: left;
            padding-left: 20px;
            padding-top: 5px;
            display: block;
            background-color: #eee;
            border: 1px solid #ddd;
            text-decoration: none;
            margin-bottom: 2px;
        }
        #schemaTree.ztree li a.curSelectedNode{
            background-color: #0e7fd2;
        }

        #schemaTree.ztree li ul.level0 {
            display: block;
            padding: 5px 0 5px 18px;
        }

        #schemaTree.ztree li a.level0.cur {
            background-color: #ddd;
        }

        #schemaTree.ztree li a.level0 span.node_name{
            position: relative;
            top: 3px;
        }

        #schemaTree.ztree li a.level0 span.button {
            float: right;
            margin-left: 10px;
            visibility: visible;
            display: none;
        }

        #schemaTree.ztree li span.button.switch.level0 {
            display: none;
        }



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
            background-color: #fafafa;
            width: 80px;
            white-space:nowrap;
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

        form#fieldForm input.innerInput {
            width: 100% !important;
        }

        form#fieldForm input.innerInputLen {
            /* width: 100px; */
        }

        form#fieldForm td {
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

        table#dataTable td {
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

        div#schemaDiv div.dataTables_info {
            margin-left: 10px;
        }
        
         table.ccl-schema-table th, table.ccl-schema-table td {
		     border: 0px solid #e7e7e7; 
		    padding: 4px 10px;
		} 
		 table.ccl-schema-table th{padding: 0px 10px 0 10px; text-align:left;}
		 
		 #dataTable {
		     width: calc(100% - 10px);
    		 position: relative;
   			 left: 10px;
		 }
		 
		 #commonFieldDiv .ico_docu {
		 	background-position: center !important;
		 }
		 .thVer{
		  vertical-align: middle !important;text-align:center;
		 }
    </style>
</head>
<body>

<div class="row" id="schemaDiv">
    <div class="col-md-12">
        <div class="portlet box">
            <div class="portlet-title">
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
                <div class="actions">
                    <%--<a href="javascript:void(0);" id="historyBtn" --%>
                       <%--class="btn btn-default btn-sm">--%>
                        <%--<i class="fa icon-equalizer"></i>--%>
                        <%--变更追溯--%>
                    <%--</a>--%>
                    <a href="javascript:void(0);" id="saveBtn"
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
                            <div class="tab-content">
                                <div class="tab-pane active" id="tab_5_1">
	                                 <div class="ccl-search-bar">
										 <input type="text" class="form-control input-md" id="searchSchemaTree"
                                               placeholder="资源目录搜索"/>
									</div>
                                    <div class="ccl-tool-bar">
                                        <i class="fa fa-plus" title="新增版本" id="addTableBtn"></i>
                                        <i class="fa fa-copy" title="复制版本" id="copySchemaBtn"></i>
                                        <div style="float: right;">
                                        	<i class="fa fa-edit" title="修改版本" id="editSchemaBtn"></i>
                                        	<i class="fa fa-trash-o" title="删除版本" id="delSchemaBtn"></i>
                                        </div>
                                    </div>
                                    <div style="overflow: auto;height:25px">
                                        <div style="float: right;">
                                            <i title="仅显示启用">

                                                <input id='showAll' style="float: right;" type="checkbox"  class="icheck" checked name="showAll"/>
                                                <span style="color:red;" id="bbTs">仅显示启用&nbsp;&nbsp;</span>
                                            </i>
                                        </div>
                                    </div>
                                    <div class="ccl-tree-panel">
                                        <div id="searchSchemaTreeMsg"
                                             style="margin: 5px; color: red;display: none;">
                                            暂无相关数据！
                                        </div>
                                        <div id="schemaTree" class="ztree"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <div style="margin-bottom: 10px;">
                            <table class="ccl-schema-table">
                                <tr>
                                    <th>所属部门：</th>
                                    <td colspan="10"> <input type="hidden" id="deptId" name="deptId" value="" />
                                        <div style="position:relative;">
                                            <select id="department" name="departments" class="form-control" multiple="multiple"></select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>比&#12288;&#12288;对：</th>
                                    <td>
                                        <input type="checkbox" class="icheck" id="compareTime" style="position:relative;float: left">&nbsp;时间比对
                                    </td>
                                    <td>
                                        <input type="checkbox" class="icheck" id="compareSameDate" style="position:relative;float: left">&nbsp;重复数据比对
                                    </td>
                                </tr>
                                <tr>
                                    <th>时间比对：</th>
                                    <td style="width: 50%">
                                        <select class="form-control" name="start"  disabled="disabled" id="start" style="width: 100%">
                                        </select>
                                    </td>
                                    <td style="width: 50%">
                                        <select class="form-control" name="end" disabled="disabled" id="end" style="width: 100%">
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>重复数据<br/>比&#12288;&#12288;对：</th>
                                    <td colspan="10">
                                        <input type="hidden" id="aa" name="deptId" value="" />
                                        <div style="position:relative;" id="cfDiv">
                                            <select id="cfsj" name="cfsjs" class="form-control" multiple="multiple"></select>
                                        </div>
                                    </td>
                                </tr>
                            </table>
						</div>
                        
                        <div id="fieldBtns" class="actions" style=" float: right; margin-right: 5px;">
                                <span style="color:red; margin-right:10px; position:relative;top:2px;">*指标项可以上下拖动调整顺序</span>
                            <input id="check_id" name="check_id" value="" type="hidden"/>
                        </div>
                        <form id="fieldForm" action="#" method="post" style="width: 100%;">
                            <div class="table-scrollable" style="width: 100%;">
                                <div style="float: left; width: 100%;margin-bottom: 5px;">
                                    <table id="dataTable"
                                           class="table table-striped table-bordered table-hover sorted_table" style="width:98%">
                                        <thead>
                                        <tr role="row" class="heading">
                                            <th class="table-checkbox">
                                                <input type="checkbox" id="checkall" name="checkThis" class="icheck">
                                            </th>
                                            <th class="thVer" style="width:7%">拖动</th>
                                            <th class="thVer" >指标名称</th>
                                            <th class="thVer" >指标编码</th>
                                            <th class="thVer"style="width:13%">指标长度</th>
                                            <th  class="thVer"style="width:7%">必填</th>
                                            <th class="thVer"style="width:10%">
                                                分组
                                                <i class="fa fa-question-circle" style="color: #e35b5a;"
                                                   title="有必填分组需求可输入分组编号进行分组，如1,2,3（限数字）"></i>
                                            </th>
                                            <th class="thVer" style="width:7%">操作</th>
                                            <th class="thVer" style="width:7%">批注</th>
                                            
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
</div>


<!-- 数据目录新增编辑弹窗 -->
<div id="tableDiv" style="display: none; margin: 30px 40px;">
    <form id="tableForm" method="post" action="${pageContext.request.contextPath}/schema/saveTable.action"
          class="form-horizontal">
        <input type="hidden" id="bbid" name="bbid"/>
        <div class="form-body">
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    版本:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="code" name="code"
                               style="text-transform: uppercase;"/>
                    </div>
                </div>
            </div>
             <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required"></span>
                    版本描述:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <textarea class="form-control" id="codeDesc" name="codeDesc" rows="4" placeholder="请输入不超过400个字" maxlength="400"></textarea>
                        <span class="wordsNum">0/400</span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label">
                    <span class="required">*</span>
                    选择目录:
                </label>
                <div class="col-sm-9">
                    <div class="ccl-tree-panel">
                        <div id="schemaTreeAdd" class="ztree" ></div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-3 control-label" style="padding-top: 0px">
                    <span class="required">*</span>
                    是否启用:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <div class="switch switch-mini">
                            <input type="checkbox" checked id="sfqy" name="sfqy"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- 数据目录新增编辑弹窗 -->
<div id="tableDivCopy" style="display: none; margin: 30px 40px;">
    <form id="tableFormCopy" method="post" class="form-horizontal">
        <input type="hidden" id="bbidCopy" name="bbidCopy"/>
        <div class="form-body">
            <div class="form-group">
                <label class="col-md-2 control-label">
                    <span class="required">*</span>
                    版本:
                </label>
                <div class="col-sm-9">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" id="codeCopy" name="codeCopy"
                               style="text-transform: uppercase;"/>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>


<!-- 批注弹窗 -->
<div id="postilDiv"
     style="display: none; margin: 30px 40px; height: 220px;">
    <textarea style="width: 100%; height: 100%;" id="postil"></textarea>
</div>

<!-- 规则弹窗 -->
<div id="ruleDiv" style="display: none; margin: 30px 40px;">
    <table class="winTable" style="width: 100%;">
        <tr>
            <th width="30px"></th>
            <th style="border-left: 1px solid #dedede;">规则名称</th>
            <th style="border-left: 1px solid #dedede;">提示消息</th>
        </tr>
        <c:if test="${ruleList != null}">
            <c:forEach items="${ruleList}" var="rule">
                <tr class="data-tr" onclick="al.selectRule(this)">
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
    <input type="hidden" id="rowId"/>
</div>


<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/common/jquery-sortable.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/schema/allocation_list.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/cclSelect/cclSelect.js"></script>
<script type="application/javascript">
	//解决ie9placeholder位置错位问题
	    $(".phTips").css("marginLeft",'10px');
	    $(".phTips").css("marginTop",'-35px');
	    $(".phTips").css("line-height",'34px');
 
</script>
</body>
</html>