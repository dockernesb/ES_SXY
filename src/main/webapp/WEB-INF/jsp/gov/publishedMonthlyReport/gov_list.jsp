<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>双公示月报表</title>
</head>
<body>
<div id="topDiv">
    <div id="mainListDiv">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-list"></i>
                            双公示月报表
                        </div>
                        <div class="tools" style="padding-left: 5px;">
                            <a href="javascript:void(0);" class="collapse"></a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" id="addBtn"
                               class="btn btn-default btn-sm">
                                添加月报
                            </a>
                            <a href="javascript:void(0);" id="editBtn"
                               class="btn btn-default btn-sm">
                                修改月报
                            </a>
                            <a href="javascript:void(0);" id="delBtn"
                               class="btn btn-default btn-sm">
                                删除月报
                            </a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <form id="form-search" class="form-inline">
                                    <input id="beginDate" class="form-control input-md form-search date-icon"
                                           placeholder="开始时间" readonly="readonly">
                                    &nbsp;
                                    <input id="endDate" class="form-control input-md form-search date-icon"
                                           placeholder="结束时间"
                                           readonly="readonly">
                                    &nbsp;
                                    <button type="button" class="btn btn-info btn-md form-search"
                                            onclick="gl.conditionSearch();">
                                        <i class="fa fa-search"></i>
                                        查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search"
                                            onclick="gl.conditionReset();">
                                        <i class="fa fa-rotate-left"></i>
                                        重置
                                    </button>
                                </form>
                            </div>
                        </div>
                        <table id="dataTable" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr role="row" class="heading">
                                <th rowspan="2">上报月份</th>
                                <th rowspan="2">部门名称</th>
                                <th rowspan="2">本单位公示网址</th>
                                <th colspan="5" style="text-align: center;">行政许可</th>
                                <th colspan="5" style="text-align: center;">行政处罚</th>
                                <th rowspan="2">上报时间</th>
                                <th rowspan="2">上报人员</th>
                                <th rowspan="2">更新时间</th>
                                <th rowspan="2">更新人员</th>
                            </tr>
                            <tr role="row" class="heading">
                                <th>产生数量</th>
                                <th>本单位公示数量</th>
                                <th>报送数量</th>
                                <th>未报送数量</th>
                                <th>未报送依据</th>
                                <th>产生数量</th>
                                <th>本单位公示数量</th>
                                <th>报送数量</th>
                                <th>未报送数量</th>
                                <th style="border-right: 1px solid #ddd;">未报送依据</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>

                        <table id="dataTableSum" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr role="row" class="heading">
                                <th colspan="4" style="text-align: center;">行政许可（汇总）</th>
                                <th colspan="4" style="text-align: center;">行政处罚（汇总）</th>
                            </tr>
                            <tr role="row" class="heading">
                                <th>产生数量</th>
                                <th>本单位公示数量</th>
                                <th>报送数量</th>
                                <th>未报送数量</th>
                                <th>产生数量</th>
                                <th>本单位公示数量</th>
                                <th>报送数量</th>
                                <th>未报送数量</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <br/>
                    </div>
                </div>
            </div>
        </div>

        <div id="columnTogglerContent" class="btn-group hide pull-right">
            <a class="btn green" href="javascript:;" data-toggle="dropdown">
                列信息
                <i class="fa fa-angle-down"></i>
            </a>
            <div id="dataTable_column_toggler" style="width: 240px;"
                 class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
                <label>
                    <input type="checkbox" class="icheck" checked data-column="0">
                    上报月份
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="1">
                    部门名称
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="2">
                    本单位公示网址
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="3">
                    行政许可 - 产生数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="4">
                    行政许可 - 本单位公示数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="5">
                    行政许可 - 报送数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="6">
                    行政许可 - 未报送数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="7">
                    行政许可 - 未报送依据
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="8">
                    行政处罚 - 产生数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="9">
                    行政处罚 - 本单位公示数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="10">
                    行政处罚 - 报送数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="11">
                    行政处罚 - 未报送数量
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="12">
                    行政处罚 - 未报送依据
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="13">
                    上报时间
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="14">
                    上报人员
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="15">
                    更新时间
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="16">
                    更新人员
                </label>
            </div>
        </div>
    </div>

    <div id="handleDiv" style="display:none">
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/gov/publishedMonthlyReport/gov_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>