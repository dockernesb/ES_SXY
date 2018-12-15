<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>双公示上报量统计</title>
    <style>
        .heading th {
            text-align: center
        }

        .odd, .even {
            text-align: right
        }

        .odd :first-child, .odd :nth-child(2), .odd :nth-child(6), .even :first-child, .even :nth-child(2), .even :nth-child(6) {
            text-align: center
        }

        input[type="radio"] {
            vertical-align: text-top
        }
    </style>
    <!--[if IE]>
        <style>
        input[type="radio"]{vertical-align:middle}
        </style>
    <!-->
</head>
<body>
<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    双公示上报量统计
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
            </div>
            <div class="portlet-body">
                <div class=""
                     style="margin: 5px 60px 10px 60px; text-align: left; border-bottom: 1px solid #dedede; padding-bottom: 10px;">
                    <form id="form-search" class="form-inline">
                        统计主体：
                        <label for="ztb"><input type="radio" name="zt" id="ztb" value="B" checked/>区县</label>
                        <label for="zta"><input type="radio" name="zt" id="zta" value="A"/>部门</label>
                        <br/>
                        上报时间：
                        <input type="text" class="form-control date-icon" id="startDate" readonly="readonly"
                               placeholder="开始时间"/>
                        &nbsp;至&nbsp;
                        <input type="text" class="form-control date-icon" id="endDate" readonly="readonly"
                               placeholder="结束时间"/>
                        &nbsp;部门：
                        <select class="form-control input-md form-search" id="deptId"
                                style="width: 12%;"></select>
                        &nbsp;
                        <button type="button" id="searchBtn" class="btn btn-info btn-md"
                                onclick="pds.conditionSearch();"><i class="fa fa-search"></i>查询
                        </button>
                        <button type="button" class="btn btn-default btn-md "
                                onclick="pds.conditionReset();">
                            <i class="fa fa-rotate-left"></i>重置
                        </button>
                    </form>
                </div>
                <div class="col-md-12 col-sm-12" style="margin:30px 0 0px;">
                    <div id="repairAnalysisBar" style="width: 70%; height: 480px;float:left;"></div>
                    <div id="sgsSortBox" style="float:left;border: 1px solid #dedede;">
                        <div style="width: 270px; height: 38px;line-height: 34px;text-align: center;font-size: 17px;font-weight: bold;border-bottom: 1px solid #dedede;">
                            双公示上报量排行
                        </div>
                        <div id="sgsXzxkSort"
                             style="width: 260px; height: 235px; position:relative;left:5px; padding-top: 14px;"></div>
                        <div id="sgsXzcfSort"
                             style="width: 260px; height: 235px; position:relative;left:5px;margin-top:-13px;"></div>
                    </div>
                    <div style="clear: both;"></div>
                </div>
                <div style="height: 50px; clear: both;"></div>
                <div style="margin: 0px 60px 60px 60px;">
                    <table id="dataTable" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr role="row" class="heading">
                            <th>序号</th>
                            <th>信息提供部门名称</th>
                            <th>双公示上报量</th>
                            <th>行政许可上报量</th>
                            <th>行政处罚上报量</th>
                            <th>最后一次上报时间</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/publicityDataSize/publicityDataSize.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>

</body>
</html>