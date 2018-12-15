<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>信用修复审核</title>
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
                            信用修复审核
                        </div>
                        <div class="tools" style="padding-left: 5px;">
                            <a href="javascript:void(0);" class="collapse"></a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <form id="form-search" class="form-inline">
                                    <input id="bjbh" class="form-control input-md form-search" placeholder="办件编号">
                                    <input id="jgqc" class="form-control input-md form-search" placeholder="企业名称">
                                    <input id="tyshxydm" class="form-control input-md form-search" placeholder="统一社会信用代码">
                                    <input id="zzjgdm" class="form-control input-md form-search" placeholder="组织机构代码">
                                    <input id="gszch" class="form-control input-md form-search" placeholder="工商注册号">
                                    <input id="beginDate" class="form-control input-md form-search date-icon" placeholder="申诉时间始" readonly="readonly">
                                    <input id="endDate" class="form-control input-md form-search date-icon" placeholder="申诉时间止" readonly="readonly">
                                    <select id="status" class="form-control input-md form-search">
                                        <option value=" ">全部状态</option>
                                        <option value="0">待审核</option>
                                        <option value="1">待核实</option>
                                        <option value="2">已通过</option>
                                        <option value="3">未通过</option>
                                        <option value="4">已完成</option>
                                    </select>

                                    <button type="button" class="btn btn-info btn-md form-search"
                                            onclick="crl.conditionSearch();">
                                        <i class="fa fa-search"></i>
                                        查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search"
                                            onclick="crl.conditionReset();">
                                        <i class="fa fa-rotate-left"></i>
                                        重置
                                    </button>
                                </form>
                            </div>
                        </div>
                        <table id="dataTable" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr role="row" class="heading">
                                <th>办件编号</th>
                                <th>企业名称</th>
                                <th>统一社会信用代码</th>
                                <th>组织机构代码</th>
                                <th>工商注册号</th>
                                <th>修复主题</th>
                                <th>申诉时间</th>
                                <th>申诉人</th>
                                <th>申诉电话</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="columnTogglerContent" class="btn-group hide pull-right">
            <a class="btn green" href="javascript:;" data-toggle="dropdown">
                列信息
                <i class="fa fa-angle-down"></i>
            </a>
            <div id="dataTable_column_toggler"
                 class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
                <label>
                    <input type="checkbox" class="icheck" checked data-column="0">
                    办件编号
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="1">
                    企业名称
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="2">
                    统一社会信用代码
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="3">
                    组织机构代码
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="4">
                    工商注册号
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="5">
                    修复主题
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="6">
                    申诉时间
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="7">
                    申诉人
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="8">
                    申诉电话
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="9">
                    状态
                </label>
            </div>
        </div>

        <div id="amendDiv" style="display: none; overflow-x: hidden;">
            <form id="amendForm" action="#" class="form-horizontal">
                <div class="form-group"></div>
            </form>
        </div>

    </div>
    <div id="applyDetailDiv" style="display:none">
    </div>
</div>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/creditRepair/center_repair_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>