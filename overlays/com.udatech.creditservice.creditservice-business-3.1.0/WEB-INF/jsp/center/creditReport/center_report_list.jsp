<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>法人信用报告</title>
</head>
<body>
<div id="topDiv">
    <div id="mainListDiv">
        <!-- 信用报告申请是否审核开关：0不需要审核，1需要审核 -->
        <input type="hidden" id="audit" value="${audit }">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-list"></i> 法人信用报告
                        </div>
                        <div class="tools" style="padding-left: 5px;">
                            <a href="javascript:void(0);" class="collapse"></a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12 col-sm-12">
                                <form id="form-search" class="form-inline">
                                    <input id="bjbh" class="form-control input-md form-search" placeholder="办件编号">
                                    <input id="xybgbh" class="form-control input-md form-search" placeholder="信用报告编号">
                                    <input id="jgqc" class="form-control input-md form-search" placeholder="企业名称">
                                    <input id="tyshxydm" class="form-control input-md form-search" placeholder="统一社会信用代码">
                                    <input id="zzjgdm" class="form-control input-md form-search" placeholder="组织机构代码">
                                    <input id="gszch" class="form-control input-md form-search" placeholder="工商注册号">
                                    <c:if test="${audit == 1 }">
                                        <select id="status" class="form-control input-md form-search" style="width: 100px;">
                                            <option value=" ">全部状态</option>
                                            <option value="0">待审核</option>
                                            <option value="1">已通过</option>
                                            <option value="2">未通过</option>
                                        </select>
                                    </c:if>
                                    <input id="beginDate" class="form-control input-md form-search date-icon" placeholder="申请时间始" readonly="readonly">
                                    <input id="endDate" class="form-control input-md form-search date-icon" placeholder="申请时间止" readonly="readonly">

                                    <button type="button" class="btn btn-info btn-md form-search" onclick="centerReport.conditionSearch();">
                                        <i class="fa fa-search"></i> 查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search" onclick="centerReport.conditionReset();">
                                        <i class="fa fa-rotate-left"></i> 重置
                                    </button>
                                </form>
                                <table id="dataTable" class="table table-striped table-bordered table-hover ">
                                    <thead>
                                    <tr role="row" class="heading">
                                        <th width="150px;">办件编号</th>
                                        <th width="140px;">信用报告编号</th>
                                        <th>企业名称</th>
                                        <th>统一社会信用代码</th>
                                        <th>组织机构代码</th>
                                        <th>工商注册号</th>
                                        <th>申请时间</th>
                                        <th>申请人</th>
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
            </div>
        </div>

        <div id="columnTogglerContent" class="btn-group hide pull-right">
            <a class="btn green" href="javascript:;" data-toggle="dropdown">
                列信息 <i class="fa fa-angle-down"></i>
            </a>
            <div id="dataTable_column_toggler" class="dropdown-menu hold-on-click dropdown-checkboxes pull-right">
                <label> <input type="checkbox" class="icheck" checked data-column="0"> 办件编号</label>
                <label> <input type="checkbox" class="icheck" checked data-column="1"> 信用报告编号</label>
                <label> <input type="checkbox" class="icheck" checked data-column="2"> 企业名称</label>
                <label> <input type="checkbox" class="icheck" data-column="3"> 统一社会信用代码</label>
                <label> <input type="checkbox" class="icheck" data-column="4"> 组织机构代码</label>
                <label> <input type="checkbox" class="icheck" data-column="5"> 工商注册号</label>
                <label> <input type="checkbox" class="icheck" checked data-column="6"> 申请时间</label>
                <label> <input type="checkbox" class="icheck" data-column="7"> 申请人</label>
                <c:if test="${audit == 1 }">
                    <label> <input type="checkbox" class="icheck" checked data-column="8"> 状态
                    </label>
                </c:if>
                <c:if test="${audit == 0 }">
                    <label> <input type="checkbox" class="icheck" data-column="8"> 状态
                    </label>
                </c:if>
            </div>
        </div>
    </div>
    <div id="applyDetailDiv" style="display:none">
    </div>
    <div id="auditOneDiv" style="display:none">
    </div>
    <div id="auditTwoDiv" style="display:none">
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/creditReport/center_report_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>