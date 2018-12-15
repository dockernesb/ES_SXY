<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>统计分析</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/dataAnalysis/dataAnalysis.css"/>
    <style type="text/css">
        .marginRight {
            margin-right: 60px;
            cursor: pointer
        }
    </style>
</head>
<body>
<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    统计分析
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
            </div>
            <div class="portlet-body">
                <div class="row" style="padding:0 10px;">
                    <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px">
                        <div class="dashboard-stat blue-madison">
                            <div class="visual">
                                <i class="fa fa-indent"></i>
                            </div>
                            <div class="details">
                                <div class="number" id="glbm">0</div>
                                <div class="desc">管理部门</div>
                            </div>
                            <i class="more"> </i>
                        </div>
                    </div>
                    <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px;">
                        <div class="dashboard-stat blue">
                            <div class="visual">
                                <i class="fa fa-print"></i>
                            </div>
                            <div class="details">
                                <div class="number" id="sszj">0</div>
                                <div class="desc">涉审中介</div>
                            </div>
                            <i class="more"> </i>
                        </div>
                    </div>
                    <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px;">
                        <div class="dashboard-stat green">
                            <div class="visual">
                                <i class="fa fa-outdent"></i>
                            </div>
                            <div class="details">
                                <div class="number" id="cyry">0</div>
                                <div class="desc">从业人员</div>
                            </div>
                            <i class="more"> </i>
                        </div>
                    </div>
                    <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 25%; padding: 0px 5px;">
                        <div class="dashboard-stat red-intense">
                            <div class="visual">
                                <i class="fa fa-print"></i>
                            </div>
                            <div class="details">
                                <div class="number" id="pjxx">0</div>
                                <div class="desc">评价信息</div>
                            </div>
                            <i class="more"> </i>
                        </div>
                    </div>
                </div>
                <div class=""
                     style="margin: 15px 0px 50px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
                    <form id="form-search" class="form-inline">
                        <input type="text" class="form-control date-icon form-search" id="startDate" readonly="readonly" placeholder="上报时间始"/>
                        <input type="text" class="form-control date-icon form-search" id="endDate" readonly="readonly" placeholder="上报时间止"/>
                        <button type="button" id="searchBtn" class="btn btn-info btn-md form-search" onclick="sszjStatistics.conditionSearch();">
                            <i class="fa fa-search"></i>查询
                        </button>
                        <button type="button" class="btn btn-default btn-md form-search" onclick="sszjStatistics.conditionReset();">
                            <i class="fa fa-rotate-left"></i>重置
                        </button>
                    </form>
                </div>
                <div class="" style="margin: 5px 60px 10px 60px; text-align: left;  padding-bottom: 10px;">
                </div>
                <div>
                    <div class="col-md-12">
                        <div class="processSizePie" id="JgdjBar" style="width: 100%; height: 500px;">111</div>
                    </div>
                </div>
                <div>
                    <div class="col-md-12">
                        <div class="processSizePie" id="ZjxxBar" style="width: 100%; height: 500px;">222</div>
                    </div>
                </div>
                <div style="height: 50px; clear: both;"></div>
                <div style="margin: 0px 60px 60px 60px;" id="dept_fatherDiv">
                    <div id="fk_enter_btns_2" class="hide pull-right">
                        <a class="btn btn-sm blue" href="javascript:;" onclick="sszjStatistics.exportData();">导出</a>
                    </div>
                    <table id="dataTable" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr  role="row" class="heading">
                            <th style="width: 30px;">序号</th>
                            <th>部门名称</th>
                            <th>中介基础信息</th>
                            <th>机构从业人员</th>
                            <th>中介评价信息</th>
                            <th>合计数</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                        <tr>
                            <th colspan="2" style="text-align: center;">小计</th>
                            <th style="text-align: right;">0</th>
                            <th style="text-align: right;">0</th>
                            <th style="text-align: right;">0</th>
                            <th style="text-align: right;">0</th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/app/js/sszj/sszjStatistics.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>