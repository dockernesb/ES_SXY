<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>上报时效统计</title>
</head>
<body>

<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    上报时效统计
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
            </div>
            <div class="portlet-body">
                <div class=""
                     style="margin: 5px 60px 10px 60px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
                    <form id="form-search" class="form-inline">
                        <input type="text" class="form-control" id="name" placeholder="目录名称"/>
                        <input type="text" class="form-control date-icon" id="startDate" readonly="readonly" placeholder="上报时间始"/>
                        <input type="text" class="form-control date-icon" id="endDate" readonly="readonly" placeholder="上报时间止"/>
                        <button type="button" id="searchBtn" class="btn btn-info btn-md">
                            <i class="fa fa-search"></i>
                            查询
                        </button>
                        <button type="button" id="resetBtn" class="btn btn-default btn-md">
                            <i class="fa fa-rotate-left"></i> 重置
                        </button>
                    </form>
                </div>
                <div class="col-md-12 col-sm-12">
                    <div id="timelinessBar" style="width: 100%; height: 550px;"></div>
                </div>
                <div class="col-md-12 col-sm-12" style="padding-top: 20px;">
                    <div id="timelinessSchemaTrend" style="width: 100%; height: 550px;"></div>
                </div>
                <div style="height: 50px; clear: both;"></div>
                <div style="margin: 0px 60px 60px 60px;" id="fatherDiv">
                    <div id="fk_enter_btns_2" class="hide pull-right">
                        <a class="btn btn-sm blue" href="javascript:;">导出</a>
                    </div>
                    <table id="dataTable" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr role="row" class="heading">
                            <th style="width: 30px;">序号</th>
                            <th>目录名称</th>
                            <th>征集周期数</th>
                            <th>正常周期数</th>
                            <th>时效性</th>
                            <th>超时周期数</th>
                            <th>超时率</th>
                            <th>漏报周期数</th>
                            <th>漏报率</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div style="margin: 0px 60px 60px 60px;display: none;" id="sonDiv" >
                    <input type="hidden" id="detail_schemaName" />
                    <div id="detail_btn" class="hide pull-right">
                        <a class="btn btn-sm blue" href="javascript:;" onclick="data_timeline.exportDetailData();">导出</a>
                        <a class="btn btn-sm blue" href="javascript:;" onclick="data_timeline.goBack();">返回</a>
                    </div>
                    <table id="dataTable_detail" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr role="row" class="heading">
                            <th>序号</th>
                            <th>时间</th>
                            <th>征集周期数</th>
                            <th>正常周期数</th>
                            <th>时效性</th>
                            <th>超时周期数</th>
                            <th>超时率</th>
                            <th>漏报周期数</th>
                            <th>漏报率</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>


<input type="hidden" id="deptId" value="${deptId }">
<script type="text/javascript" src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/gov/statisAnalyze/data_timeliness.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>