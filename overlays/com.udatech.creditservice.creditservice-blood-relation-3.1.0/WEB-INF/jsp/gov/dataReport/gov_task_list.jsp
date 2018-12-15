<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <title>数据上报</title>
    <style type="text/css">
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
    </style>
</head>
<body>
<div id="topBox">
    <div id="parentBox">
        <input type="hidden" id="versionId" name="versionId" value="${versionId}">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-globe"></i>数据上报
                        </div>
                        <div class="tools">
                            <a href="javascript:;" class="collapse"> </a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" onclick="govTask.reportedData(false);" class="btn btn-default btn-sm"> 上报/维护信息 </a>
                            <a href="javascript:void(0);" onclick="govTask.reportedData(true);" class="btn btn-default btn-sm"> 疑问数据 </a>
                            <a href="javascript:void(0);" onclick="govTask.wglData();" class="btn btn-default btn-sm"> 未关联数据 </a>
                            <a href="javascript:void(0);" onclick="govTask.noData();" class="btn btn-default btn-sm"> 无数据上报 </a>
                            <a href="javascript:void(0);" onclick="cetlInfo.showCetl();" class="btn btn-default btn-sm"> 数据血缘 </a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px 10px 15px;">
                                <div class="dashboard-stat green-haze">
                                    <div class="visual">
                                        <i class="fa  fa-align-justify"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="wsbsjl"><span style="color: red;">0</span>/0</div>
                                        <div class="desc">今日未上报数据（类）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
                                <div class="dashboard-stat blue-madison">
                                    <div class="visual">
                                        <i class="fa fa-indent"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="sbzs">0</div>
                                        <div class="desc">上报量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
                                <div class="dashboard-stat blue">
                                    <div class="visual">
                                        <i class="fa fa-print"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="sbyws"><span style="color: red;">0</span>/0</div>
                                        <div class="desc">疑问量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
                                <div class="dashboard-stat green">
                                    <div class="visual">
                                        <i class="fa fa-outdent"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="sbgxs">0</div>
                                        <div class="desc">更新量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 15px 10px 5px;">
                                <div class="dashboard-stat red-intense">
                                    <div class="visual">
                                        <i class="fa fa-print"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="sbrks">0</div>
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
                                    <select id="status" class="form-control input-md form-search" style="width: 100px;">
                                        <option value=" ">全部状态</option>
                                        <option value="待上报">待上报</option>
                                        <option value="已上报">已上报</option>
                                        <option value="超时">超时</option>
                                    </select>
                                    <select id="version" class="form-control input-md form-search" style="width: 160px;">
                                    </select>
                                    <button type="button" class="btn btn-info btn-md form-search" onclick="govTask.conditionSearch();">
                                        <i class="fa fa-search"></i> 查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search" onclick="govTask.conditionReset();">
                                        <i class="fa fa-rotate-left"></i> 重置
                                    </button>
                                </form>
                            </div>
                        </div>
                        <table class="table table-striped table-hover table-bordered" id="taskGrid">
                            <thead>
                            <tr class="heading">
                                <th style="width: 30px"></th>
                                <th>目录名称</th>
                                <th>征集周期</th>
                                <th style="text-align: center">上报量</th>
                                <th style="text-align: center">疑问量</th>
                                <th style="text-align: center">更新量</th>
                                <th style="text-align: center">入库量</th>
                                <th style="text-align: center">未关联量</th>
                                <th>最近上报时间</th>
                                <th>本期截止时间</th>
                                <th>状态</th>
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

        <input type="hidden" id="deptId" value="${deptId }">
        <input type="hidden" id="reportValidDays" value="${reportValidDays }">
        <script type="text/javascript" src="${ctx}/app/js/gov/dataReport/gov_task_list.js"></script>
        <script type="text/javascript" src="${ctx}/app/js/gov/dataReport/gov_cetl_info.js"></script>
        <script type="text/javascript" src="${ctx}/app/js/common/commonInit.js"></script>
    </div>
    <div id="childBox" style="display:none">

    </div>
</div>
</body>
</html>