<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <title>上报记录</title>
</head>
<body>
<div id="topBox">
    <div id="parentBox">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-globe"></i>上报记录
                        </div>
                        <div class="tools">
                            <a href="javascript:;" class="collapse"> </a>
                        </div>
                        <div class="actions">
                            <a href="javascript:void(0);" onclick="hisTask.dataDetail(false);" class="btn btn-default btn-sm"> 数据明细 </a>
                            <a href="javascript:void(0);" onclick="hisTask.dataDetail(true);" class="btn btn-default btn-sm"> 疑问数据 </a>
                            <a href="javascript:void(0);" onclick="hisTask.wglData();" class="btn btn-default btn-sm"> 未关联数据 </a>
                            <a href="javascript:void(0);" onclick="hisTask.dealLog();" class="btn btn-default btn-sm"> 处理日志 </a>
                            <!-- 3.0.2产品整改 begin-->
                            <a href="javascript:void(0);" onclick="hisTask.errorDataDownload();" class="btn btn-default btn-sm"> 错误数据下载 </a>
                            <!-- 3.0.2产品整改 end-->
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px 10px 15px;">
                                <div class="dashboard-stat blue-madison">
                                    <div class="visual">
                                        <i class="fa fa-align-justify"></i>
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
                                        <div class="number" id="sbyws"><span
                                                style="color: red;">0</span>/0
                                        </div>
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
                            <div class="col-md-2 col-xs-12  col-sm-12 col-lg-2" style="width: 20%; padding: 0px 5px;">
                                <div class="dashboard-stat green">
                                    <div class="visual">
                                        <i class="fa fa-outdent"></i>
                                    </div>
                                    <div class="details">
                                        <div class="number" id="sbrks">0</div>
                                        <div class="desc">入库量（条）</div>
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
                                        <div class="number" id="sbwgl">0</div>
                                        <div class="desc">未关联量（条）</div>
                                    </div>
                                    <i class="more"> </i>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <form id="form-search" class="form-inline">
                                    <input id="taskCode" class="form-control input-md form-search" placeholder="上报批次编号">
                                    <input id="tableName" class="form-control input-md form-search" placeholder="目录名称">
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
                                    <button type="button" class="btn btn-info btn-md form-search" onclick="hisTask.conditionSearch();">
                                        <i class="fa fa-search"></i> 查询
                                    </button>
                                    <button type="button" class="btn btn-default btn-md form-search" onclick="hisTask.conditionReset();">
                                        <i class="fa fa-rotate-left"></i> 重置
                                    </button>
                                </form>
                            </div>
                        </div>
                        <table class="table table-striped table-hover table-bordered" id="taskGrid">
                            <thead>
                            <tr class="heading">
                                <th style="width: 130px;vertical-align: middle;">上报批次编号</th>
                                <th style="width: 100px;vertical-align: middle;">目录名称</th>
                                <th style="text-align: center;vertical-align: middle;">上报量</th>
                                <th style="text-align: center;vertical-align: middle;">疑问量</th>
                                <th style="text-align: center;vertical-align: middle;">更新量</th>
                                <th style="text-align: center;vertical-align: middle;">入库量</th>
                                <th style="text-align: center;width: 60px;vertical-align: middle;">未关联量</th>
                                <th style="width: 140px;vertical-align: middle;">上报时间</th>
                                <th style="width: 90px;vertical-align: middle;">处理流程</th>
                                <th style="width: 30px;">上报状态</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <input type="hidden" id="deptId" value="${deptId }">
        <script type="text/javascript" src="${ctx}/app/js/gov/dataReport/gov_task_his_list.js"></script>
        <script type="text/javascript" src="${ctx}/app/js/common/commonInit.js"></script>
    </div>
    <div id="childBox" style="display:none">

    </div>
</div>
</body>
</html>