<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>绩效考核管理</title>
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
                            绩效考核管理
                        </div>
                        <div class="tools" style="padding-left: 5px;">
                            <a href="javascript:void(0);" class="collapse"></a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" id="editBtn"
                               class="btn btn-default btn-sm">
                                评分
                            </a>
                            <a href="javascript:void(0);" id="detailBtn"
                               class="btn btn-default btn-sm">
                                查看绩效
                            </a>
                            <a href="javascript:void(0);" id="exportBtn"
                               class="btn btn-default btn-sm">
                                导出
                            </a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <form id="form-search" class="form-inline">
                                    <input id="year" class="form-control input-md form-search"
                                           placeholder="年度">
                                    &nbsp;
                                    <select id="deptId"
                                            class="form-control input-md form-search">
                                        <option value="">全部部门</option>
                                    </select>
                                    &nbsp;
                                    <select id="status" class="form-control input-md form-search">
                                        <option value="">全部状态</option>
                                        <option value="2">待评分</option>
                                        <option value="3">已评分</option>
                                    </select>
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
                                <th>年度</th>
                                <th>部门名称</th>
                                <th>部门评分</th>
                                <th>中心评分</th>
                                <th>状态</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="handleDiv" style="display:none">
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/achievements/center_achievements_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>