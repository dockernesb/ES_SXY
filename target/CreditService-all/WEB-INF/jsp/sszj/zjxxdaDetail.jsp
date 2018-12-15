<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>涉审中介详细</title>
    <style>
        .fjDiv{
            width: 97%;
            height: 40px;
            text-align:left;
            margin-bottom: 2px;
        }
        .fjTs{
            text-align:left;
            margin-top: 13px;
        }
    </style>
</head>
<body>
<div id="fatherDiv">
    <div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-th-list"></i>涉审中介详细
                </div>
                <div class="tools">
                    <a href="javascript:;" class="collapse"> </a>
                </div>
                <div class="actions">
                    <button type="button" class="btn btn-default" id="goback" onclick="zjxxdaDetail.goBackList();">返回</button>
                </div>
            </div>
            <div class="portlet-body">
                <div class="row">
                    <div class="col-md-12">
                        <table class="table table-striped table-hover table-bordered">
                            <tbody>
                            <tr>
                                <th width="10%">机构名称</th>
                                <td width="20%">${sszjJbxx.jgqc }</td>
                                <th width="10%">统一社会信用代码</th>
                                <td width="20%" id="tyshxydm">${sszjJbxx.tyshxydm}</td>
                            </tr>
                            <tr>
                                <th>组织机构代码</th>
                                <td>${sszjJbxx.zzjgdm}</td>
                                <th>税务机构代码</th>
                                <td>${sszjJbxx.swJgdm}</td>
                            </tr>
                            <tr>
                                <th>法人代表(负责人)</th>
                                <td>${sszjJbxx.frdbFzr}</td>
                                <th>经营地址</th>
                                <td>${sszjJbxx.jydz}</td>
                            </tr>
                            <tr>
                                <th>网址</th>
                                <td>${sszjJbxx.wz}</td>
                                <th>联系电话</th>
                                <td>${sszjJbxx.lxdh}</td>
                            </tr>
                            <tr>
                                <th>部门选择</th>
                                <td>${sszjJbxx.deptId}</td>
                                <th>服务时限</th>
                                <td>${sszjJbxx.fwsx}</td>
                            </tr>
                            <tr>
                                <th>收费依据</th>
                                <td>${sszjJbxx.sfyj}</td>
                                <th>收费标准</th>
                                <td>${sszjJbxx.sfbz}</td>
                            </tr>
                            <tr>
                                <th>服务项目</th>
                                <td>${sszjJbxx.fwxm}</td>
                                <th>操作流程</th>
                                <td>${sszjJbxx.czlc}</td>
                            </tr>
                            <tr>
                                <th>对应审批</th>
                                <td colspan="3">${sszjJbxx.dysp}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="tabbable-custom">
                    <ul class="nav nav-tabs ">
                        <li class="active">
                            <a href="#tab_1_SSZJ" data-toggle="tab">执业资质<span class="badge badge-default" style="background: red" id="zyzzTs"></span></a>
                        </li>
                        <li>
                            <a href="#tab_2_SSZJ" data-toggle="tab">执业人员<span class="badge badge-default" style="background: red" id="zyryTs"></span></a>
                        </li>
                        <li>
                            <a href="#tab_3_SSZJ" data-toggle="tab">奖惩信息<span class="badge badge-default" style="background: red" id="jqxxTs"></span></a>
                        </li>
                        <li>
                            <a href="#tab_4_SSZJ" data-toggle="tab">信用承诺<span class="badge badge-default" style="background: red" id="xycnTs"></span></a>
                        </li>
                        <li>
                            <a href="#tab_5_SSZJ" data-toggle="tab">评价等级<span class="badge badge-default" style="background: red" id="pjdjTs"></span></a>
                        </li>
                        <li>
                            <a href="#tab_6_SSZJ" data-toggle="tab">附件信息</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1_SSZJ">
                            <h3>执业资质</h3>
                            <table class="table table-striped table-hover table-bordered" id="zyzzGrid">
                                <thead>
                                <tr class="heading">
                                    <th>资质证书名称</th>
                                    <th>资质证书编号</th>
                                    <th>资质证书等级</th>
                                    <th>类型</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="tab-pane" id="tab_2_SSZJ">
                            <h3>执业人员</h3>
                            <table class="table table-striped table-hover table-bordered" id="zyryGrid">
                                <thead>
                                <tr class="heading">
                                    <th>姓名</th>
                                    <th>资质证书名称</th>
                                    <th>资质证书编号</th>
                                    <th>资质证书等级</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="tab-pane" id="tab_3_SSZJ">
                            <h3>奖惩信息</h3>


                        </div>
                        <div class="tab-pane" id="tab_4_SSZJ">
                            <h3>信用承诺</h3>
                            <table class="table table-striped table-hover table-bordered" id="xycnGrid">
                                <thead>
                                <tr class="heading">
                                    <th>导入时间</th>
                                    <th>承诺类别</th>
                                    <th>监管部门</th>
                                    <th>承诺附件</th>
                                    <th>黑名单状态</th>
                                </tr>
                                </thead>
                            </table>

                        </div>
                        <div class="tab-pane" id="tab_5_SSZJ">
                            <h3>评价等级</h3>
                            <table class="table table-striped table-hover table-bordered" id="pjdjGrid">
                                <thead>
                                <tr class="heading">
                                    <th>评价年度</th>
                                    <th>评价等级</th>
                                    <th>评价结果</th>
                                    <th>评价部门</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="tab-pane" id="tab_6_SSZJ">
                            <div class="fjDiv">
                                <div style="float: left"><p class="fjTs">操作流程附件：</p></div>
                                <div style="float: left">
                                    <input type="hidden" value="${czlcFj}" id="czlcId">
                                    <button type="button" class="btn btn-success buttonRight" id="uploadCzlc" onclick="downloadFile('${czlcFj}')">下载</button>
                                    <span id="czlcTs">无附件</span>
                                </div>
                            </div>
                            <div class="fjDiv">
                                <div style="float: left"><p class="fjTs">服务项目附件：</p></div>
                                <div style="float: left">
                                    <input type="hidden" value="${fwxmFj}" id="fwxmId">
                                    <button type="button" class="btn btn-success buttonRight" id="uploadFwxm" onclick="downloadFile('${fwxmFj}')">下载</button>
                                    <span id="fwxmTs">无附件</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        </div>
    </div>
</div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sszj/zjxxdaDetail.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>