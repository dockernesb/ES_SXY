<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <title>数据征集</title>
    <style type="text/css">
        .ths {
            text-align: center
        }

        table.ccl-schema-table {
            width: 100%;
        }

        table.ccl-schema-table th, table.ccl-schema-table td {
            padding: 4px 15px;
        }

        table.ccl-schema-table th {
            /* width: 80px; */
            white-space: nowrap;
            text-align: left;
        }

        .menuList {
            padding-left: 0;
            height: auto;
            background: #ededed;
            padding: 10px;
        }
    </style>
</head>
<body>
<div id="topBox">
    <div id="parentBox">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-globe"></i>数据征集
                        </div>
                        <div class="tools">
                            <a href="javascript:;" class="collapse"> </a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" onclick="collection.dataDetail(false);" class="btn btn-default btn-sm"> 数据明细 </a>
                            <a href="javascript:void(0);" onclick="collection.errorDetailInfo(true);" class="btn btn-default btn-sm"> 疑问数据 </a>
                            <a href="javascript:void(0);" onclick="collection.noRelatedList();" class="btn btn-default btn-sm"> 未关联数据 </a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 10px 5px 10px 15px;">
                                <div class="dashboard-stat green-haze">
                                    <div class="visual">
                                        <i class="fa  fa-indent"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="schemaSize"></div>
                                        <div class="desc">征集目录总计</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 10px 5px;">
                                <div class="dashboard-stat blue-madison">
                                    <div class="visual">
                                        <i class="fa fa-indent"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="allSize"></div>
                                        <div class="desc">上报量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 10px 5px;">
                                <div class="dashboard-stat green">
                                    <div class="visual">
                                        <i class="fa fa-outdent"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="failSize"></div>
                                        <div class="desc">疑问量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 10px 5px;">
                                <div class="dashboard-stat blue">
                                    <div class="visual">
                                        <i class="fa fa-print"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="updateSize"></div>
                                        <div class="desc">更新量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 10px 15px 10px 5px;">
                                <div class="dashboard-stat red-intense">
                                    <div class="visual">
                                        <i class="fa fa-print"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="successSize"></div>
                                        <div class="desc">入库量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                        </div>
                        <!-- ./col -->
                        <div class="row">
                            <div class="col-md-12">
                                <form id="form-search" class="form-inline">
                                    <input id="tableName" class="form-control input-md form-search" placeholder="目录名称">
                                    <select id="conditionDeptId" class="form-control input-md form-search"></select>
                                    <input type="hidden" id="versionId" name="versionId" value="${versionId}">
                                    <select id="version" class="form-control input-md form-search" style="width: 160px;"></select>
                                    <button type="button" class="btn btn-info btn-md form-search" onclick="collection.conditionSearch(1);">
                                        <i class="fa fa-search"></i> 查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search" onclick="collection.conditionReset();">
                                        <i class="fa fa-rotate-left"></i> 重置
                                    </button>
                                </form>
                            </div>
                        </div>
                        <table class="table table-striped table-hover table-bordered" id="taskGrid">
                            <thead>
                            <tr class="heading">
                                <th class="ths">目录名称</th>
                                <th class="ths">征集周期</th>
                                <th class="ths">上报量</th>
                                <th class="ths">疑问量</th>
                                <th class="ths">更新量</th>
                                <th class="ths">入库量</th>
                                <th class="ths"> 未关联量</th>
                            </tr>
                            </thead>
                        </table>
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
                                <td colspan="10" style="word-wrap: break-word"><textarea id="rtableDesc" class="form-control-d" readonly
                                                                                         rows="3"></textarea></td>
                            </tr>
                            <tr>
                                <th>所属部门</th>
                                <td colspan="10" style="word-wrap: break-word">
                                    <ul id="deptsId" class="menuList">
                                    </ul>
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

        <input type="hidden" id="deptId" value="${deptId }">
        <input type="hidden" id="reportValidDays" value="${reportValidDays }">
        <script type="text/javascript" src="${ctx}/app/js/center/schema/schema_collection_list.js"></script>
        <script type="text/javascript" src="${ctx}/app/js/common/commonInit.js"></script>
    </div>
    <div id="childBox" style="display:none">

    </div>
</div>
</body>
</html>