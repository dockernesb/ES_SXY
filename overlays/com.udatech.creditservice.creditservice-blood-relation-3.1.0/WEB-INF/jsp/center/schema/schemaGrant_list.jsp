<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>部门目录管理</title>
    <style type="text/css">
        div.ccl-tree-panel {
            border: 1px solid #e7e7e7;
            background-color: #fafafa;
            min-height: 200px;
            margin: 15px 5px 5px 0px;
            overflow: auto;
        }

        table.ccl-schema-table {
            width: 100%;
        }

        table.ccl-schema-table th, table.ccl-schema-table td {
            padding: 4px 15px;
        }

        table.ccl-schema-table th {
            /*background-color: #fafafa;*/
            /* width: 80px; */
            white-space: nowrap;
            text-align: left;
        }
    </style>
</head>
<body>

<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>部门目录管理
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
            </div>
            <div class="portlet-body">
                <div style="display: block; margin: 10px 15px;">
                    <div class="row">
                        <div class="col-sm-6" style="padding-right: 80px;">
                            <form class="form-inline">
                                选择版本：
                                <select id="conditionversionId" class="form-control input-md form-search">

                                </select>
                                <input type="text" id="mlmc" class="form-control form-search input-md" style="width: 60%;" placeholder="资源目录搜索"/>
                                &nbsp; <br>

                                <div style="margin-top: 22px; margin-bottom: -10px; color: red;">*部门添加目录时，将左侧列表中的目录拖拽到右侧部门目录列表。</div>
                            </form>


                            <div class="ccl-tree-panel">
                                <div id="searchTreeMsg" style="margin-top: 5px; color: red; display: none;">暂无相关数据！</div>
                                <div id="menuTree" class="ztree" style="max-height: 635px;">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6" style="padding-right: 40px;">
                            <form class="form-inline">
                                选择部门：
                                <select id="conditionDeptId" class="form-control input-md form-search">
                                    <option value="0">请选择</option>
                                </select>
                                <br>
                                <button type="button" id="saveSchemaGrant" class="btn btn-info btn-md">保存</button>
                            </form>
                            <div class="ccl-tree-panel" id="div2Tree">
                                <div id="menuTree2" class="ztree" style="max-height: 635px; min-height: 200px;height: 635px;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="schemaDiv" style="display: none; margin: 10px 20px">
    <div id="scDiv">
        <div class="row">
            <div class="col-md-12">
                <table class="ccl-schema-table">
                    <tr>
                        <th>目录名称</th>
                        <td><input id="nameTd" class="form-control input-sm" type="text" readonly value=""/></td>
                        <th>目录编码</th>
                        <td><input id="codeTd" class="form-control input-sm" type="text" readonly value=""/></td>
                        <th>征集周期</th>
                        <td><input id="rtaskPeriod" class="form-control input-sm" type="text" readonly value=""/></td>
                    </tr>
                    <tr>
                        <th>任务有效期</th>
                        <td><input id="rdays" class="form-control input-sm" type="text" readonly value=""/></td>
                        <th>数据类别</th>
                        <td><input id="dataCategory" class="form-control input-sm" type="text" readonly value=""/></td>
                    </tr>
                    <tr>
                        <th>目录描述</th>
                        <td colspan="10" style="word-wrap: break-word">
                            <textarea id="rtableDesc" class="form-control-d" readonly rows="3"></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <table class="table table-striped table-hover table-bordered" id="schemaTable" style="min-width: 700px;">
            <thead>
            <tr class="heading">
                <th width="150px">指标名称</th>
                <th width="120px">指标编码</th>
                <th width="100px">指标类型</th>
                <th width="60px">指标长度</th>
                <th width="30px">必填</th>
                <th width="30px">分组</th>
                <th>批注</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/schema/schemaGrant_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/d3/d3.v4.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/d3/viz.v1.1.0.min.js"></script>

</body>
</html>