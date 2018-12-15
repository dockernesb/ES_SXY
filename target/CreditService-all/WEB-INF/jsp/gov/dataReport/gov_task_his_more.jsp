<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <title>更多-上报记录</title>
</head>
<body>
<div id="topBoxMore">
    <div id="parentBoxMore">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-globe"></i>上报记录 | ${name }
                        </div>
                        <div class="tools">
                            <a href="javascript:;" class="collapse"> </a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" onclick="hisTaskMore.dataDetail(false);" class="btn btn-default btn-sm"> 数据明细 </a>
                            <a href="javascript:void(0);" onclick="hisTaskMore.dataDetail(true);" class="btn btn-default btn-sm"> 疑问数据 </a>
                            <a href="javascript:void(0);" onclick="hisTaskMore.wglData();" class="btn btn-default btn-sm"> 未关联数据 </a>
                            <a href="javascript:void(0);" onclick="hisTaskMore.dealLog();" class="btn btn-default btn-sm"> 处理日志 </a>
                            <a href="javascript:void(0);" onclick="hisTaskMore.goBack();" class="btn btn-default btn-sm"> 返回 </a>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <form id="form-search" class="form-inline">
                                    <input id="taskCode" class="form-control input-md form-search" placeholder="上报批次编号">
                                    <select id="reportWay" class="form-control input-md form-search">
                                    </select>
                                    <select id="status" class="form-control input-md form-search">
                                        <option value=" ">全部状态</option>
                                        <option value="正常">正常</option>
                                        <option value="超时">超时</option>
                                    </select>
                                    <input id="startDate" class="form-control input-md form-search date-icon" placeholder="上报开始时间"
                                           readonly="readonly">
                                    <input id="endDate" class="form-control input-md form-search date-icon" placeholder="上报截止时间" readonly="readonly">
                                    <button type="button" class="btn btn-info btn-md form-search" onclick="hisTaskMore.conditionSearch();">
                                        <i class="fa fa-search"></i> 查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search" onclick="hisTaskMore.conditionReset();">
                                        <i class="fa fa-rotate-left"></i> 重置
                                    </button>
                                </form>
                            </div>
                        </div>
                        <table class="table table-striped table-hover table-bordered" id="taskGridMore">
                            <thead>
                            <tr class="heading">
                                <th style="width: 130px;">上报批次编号</th>
                                <th style="text-align: center">上报量</th>
                                <th style="text-align: center">疑问量</i></th>
                                <th style="text-align: center">更新量</th>
                                <th style="text-align: center">入库量</th>
                                <th style="text-align: center;width: 60px;">未关联量</th>
                                <th style="width: 140px;">上报时间</th>
                                <th style="width: 90px;">处理流程</th>
                                <th style="width: 60px;">上报状态</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <input type="hidden" id="deptId" value="${deptId }">
        <input type="hidden" id="versionId" value="${versionId }">
        <input type="hidden" id="logicTableId" value="${logicTableId }">
        <script type="text/javascript" src="${ctx}/app/js/gov/dataReport/gov_task_his_more.js"></script>
        <script type="text/javascript" src="${ctx}/app/js/common/commonInit.js"></script>
    </div>
    <div id="childBoxMore" style="display:none">

    </div>
</div>
</body>
</html>