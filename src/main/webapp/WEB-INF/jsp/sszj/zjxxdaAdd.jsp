<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>新增机构</title>
    <style>
        .clasify{
            width: 97%;
            height: 45px;
            text-align:center;
            /*padding-left: 20px;*/
            margin-left: 15px;
            display: block;
            background-color: #eee;
            border: 1px solid #ddd;
            text-decoration: none;
            margin-bottom: 2px;
            text-align:center
        }
        .buttonRight{
            float: right;
            margin-right: 3px;
            margin-top: 5px;
        }
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
        .jbxx{
            margin-right: 25px;
            margin-left: 15px;
            border: #ddd solid 1px;
        }
        .left{
            font-size: 15px;
            float: left;
            margin-top: 8px;
            margin-left: 10px;
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
                    <i class="fa fa-th-list"></i>新增机构
                </div>
                <div class="tools">
                    <a href="javascript:;" class="collapse"> </a>
                </div>
                <div class="actions">
                    <button type="button" class="btn btn-default" id="goback" onclick="zjxxdaAdd.goBackList();">返回</button>
                </div>
            </div>
            <div class="portlet-body">
                <div class="row">
                    <!-- 基本信息-->
                    <div class="clasify" id="jbxxDiv">
                        <span class="left">基本信息</span>
                        <button type="button" class="btn btn-info buttonRight" id="saveJbxx">保存</button>
                    </div>
                    <div id="jbxxXx" class="jbxx">
                        <form class="form-horizontal form-bordered form-row-stripped" method="post" id="jbxxForm">
                            <input type="hidden" id="bcType" name="type" value="${sszjJbxx.type}"/>
                            <input type="hidden" id="jbxxId" name="id" value="${sszjJbxx.id}" />
                            <div class="form-body" style="margin-top: 10px">
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>机构名称:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                            <i class="fa"></i>
                                            <input class="form-control" id="jgqc" name="jgqc" value="${sszjJbxx.jgqc}" placeholder="机构名称">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>统一社会信用代码:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                            <i class="fa"></i>
                                            <input class="form-control" id="tyshxydm" name="tyshxydm" value="${sszjJbxx.tyshxydm}" placeholder="统一社会信用代码" value="">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>组织机构代码:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" id="zzjgdm" name="zzjgdm"  value="${sszjJbxx.zzjgdm}" placeholder="组织机构代码">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>税务机构代码:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control" id="swJgdm" name="swJgdm"  value="${sszjJbxx.swJgdm}" placeholder="税务机构代码">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>法人代表(负责人):</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="frdbFzr" name="frdbFzr" value="${sszjJbxx.frdbFzr}" placeholder="法人代表(负责人)">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>经营地址:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="jydz" name="jydz" value="${sszjJbxx.jydz}" placeholder="经营地址">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>网址:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="wz" name="wz" value="${sszjJbxx.wz}" placeholder="网址">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>联系电话:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="lxdh" name="lxdh" value="${sszjJbxx.lxdh}" placeholder="联系电话">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>部门选择:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input type="hidden" id="deptId" name="deptId" value="${sysUser.sysDepartment.id}">
                                        <input class="form-control" readonly value="${sysUser.sysDepartment.departmentName}" placeholder="部门选择">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>服务时限:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="fwsx" name="fwsx" value="${sszjJbxx.fwsx}" placeholder="服务时限">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>收费依据:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="sfyj" name="sfyj" value="${sszjJbxx.sfyj}" placeholder="收费依据">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>收费标准:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="sfbz" name="sfbz" value="${sszjJbxx.sfbz}" placeholder="收费标准">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>服务项目:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <input class="form-control"  id="fwxm" name="fwxm" value="${sszjJbxx.fwxm}" placeholder="服务项目">
                                        </div>
                                    </div>
                                    <label class="control-label col-md-2"><span class="required">*</span>操作流程:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <textarea class="form-control"  id="czlc" name="czlc" placeholder="操作流程">${sszjJbxx.czlc}</textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-2"><span class="required">*</span>对应审批:</label>
                                    <div class="col-md-3">
                                        <div class="input-icon right">
                                        <i class="fa"></i>
                                        <textarea class="form-control"  id="dysp" name="dysp" placeholder="对应审批">${sszjJbxx.dysp}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!--执业资质-->
                    <div class="clasify" id="zyzzDiv">
                        <span class="left">执业资质</span>
                        <button type="button" class="btn btn-info buttonRight" id="downLoadZyzz">模板下载</button>
                        <button type="button" class="btn btn-info buttonRight upload-file" id="leadZyzz">批量导入</button>
                        <button type="button" class="btn btn-info buttonRight" id="goByHandZyzz">手动录入</button>
                        <button type="button" class="btn btn-info buttonRight" id="getZyzz">获取系统</button>
                    </div>
                    <%--<button type="button" style="display: none" id="leadFileZyzz">批量导入1</button>--%>
                    <div id="zyzzXx" class="jbxx">
                        <table class="table table-striped table-hover table-bordered" id="zyzzGrid">
                            <thead>
                            <tr class="heading">
                                <th>资质证书名称</th>
                                <th>资质证书编号</th>
                                <th>资质证书等级</th>
                                <th>类型</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <!-- 执业人员-->
                    <div class="clasify" id="zyryDiv">
                        <span class="left">执业人员</span>
                        <button type="button" class="btn btn-info buttonRight" id="downLoadZyry">模板下载</button>
                        <button type="button" class="btn btn-info buttonRight" id="leadZyry">批量导入</button>
                        <button type="button" class="btn btn-info buttonRight" id="goByHandZyry">手动录入</button>
                    </div>
                    <%--<button type="button" style="display: none" id="leadFileZyry">批量导入2</button>--%>
                    <div id="zyryXx" class="jbxx">
                        <table class="table table-striped table-hover table-bordered" id="zyryGrid">
                            <thead>
                            <tr class="heading">
                                <th>姓名</th>
                                <th>资质证书名称</th>
                                <th>资质证书编号</th>
                                <th>资质证书等级</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <!-- 评价等级-->
                    <div class="clasify" id="pjdjDiv">
                        <span class="left">评价等级</span>
                        <button type="button" class="btn btn-info buttonRight" id="goByHandPjdj">手动录入</button>
                    </div>
                    <div id="pjdjXx" class="jbxx">
                        <table class="table table-striped table-hover table-bordered" id="pjdjGrid">
                            <thead>
                            <tr class="heading">
                                <th>评价年度</th>
                                <th>评价等级</th>
                                <th>评价结果</th>
                                <th>评价部门</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                    <!-- 信用承诺-->
                    <div class="clasify" id="xycnDiv">
                        <span class="left">信用承诺</span>
                        <button type="button" class="btn btn-info buttonRight" id="goByHandXycn">手动录入</button>
                    </div>
                    <div id="xycnXx" class="jbxx">
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
                </div>
                <!-- 附件-->
                <div class="fjDiv">
                    <div style="float: left"><p class="fjTs">操作流程附件：</p></div>
                    <div style="float: left">
                        <input type="hidden" id="czlcFj" value="${czlcFj}">
                        <input type="hidden" id="fileBusinessIdCzlc" name="fileIdCzlc">
                        <button type="button" class="btn btn-success buttonRight" id="uploadCzlc">上传附件</button>
                        <button type="button" style="display: none" class="btn btn-danger buttonRight" id="deleteCzlc">删除</button>
                    </div>
                    <div style="float: left"><p class="fjTs">请上传单一附件，格式支持PDF、JPG、PNG文件</p></div>
                </div>
                <div class="fjDiv">
                    <div style="float: left"><p class="fjTs">服务项目附件：</p></div>
                    <div style="float: left">
                        <input type="hidden" id="fwxmFj" value="${fwxmFj}">
                        <input type="hidden" id="fileBusinessIdFwxm" name="fileIdFwxm">
                        <button type="button" class="btn btn-success buttonRight" id="uploadFwxm">上传附件</button>
                        <button type="button" style="display: none" class="btn btn-danger buttonRight" id="deleteFwxm">删除</button>
                    </div>
                    <div style="float: left"><p class="fjTs">请上传单一附件，格式支持PDF、JPG、PNG文件</p></div>
                </div>

            </div>
        </div>
    </div>
    </div>
</div>
<%--执业资质手动录入弹出框--%>
<div id="winAddZyzz" style="display: none; margin: 10px 40px;">
    <form id="addZyzzForm" method="post" class="form-horizontal">
        <input type="hidden" id="tyshxydmZyzz" name="tyshxydm">
        <input type="hidden" id="idZyzz" name="id">
        <input type="hidden" id="createTimeZyzz" name="createTime">
        <input type="hidden" id="createIdZyzz" name="createId">
        <input type="hidden" id="stateZyzz" name="state">
        <div class="form-body">
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质证书名称</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzZsmc" id="zzzsmcZyzz" maxlength="30" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质证书编号</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzZsbh" id="zzzsbhZyzz" maxlength="20" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质等级</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzDj" id="zzdjZyzz" maxlength="20" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>许可内容</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea name="xknr" id="xknr" class="form-control"></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质生效期</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzsxqTime" id="zzsxq"/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质截止期</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzjzqTime" id="zzjzq"/>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<%--执业人员手动录入弹出框--%>
<div id="winAddZyry" style="display: none; margin: 10px 40px;">
    <form id="addZyryForm" method="post" class="form-horizontal">
        <input type="hidden" id="tyshxydmZyry" name="tyshxydm">
        <input type="hidden" id="idZyry" name="id">
        <div class="form-body">
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>姓名</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="xm" id="xm" maxlength="30" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>身份证号</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="sfzh" id="sfzh" maxlength="20" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质证书名称</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzZsmc" id="zzzsmcZyry" maxlength="30" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>资质证书编号</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzZsbh" id="zzzsbhZyry" maxlength="20" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3">资质等级</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <input class="form-control" name="zzDj" id="zzdjZyry" maxlength="20" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<%--评价等级手动录入弹出框--%>
<div id="winAddPjdj" style="display: none; margin: 10px 40px;">
    <form id="addPjdjForm" method="post" class="form-horizontal">
        <input type="hidden" id="tyshxydmPjdj" name="tyshxydm">
        <input type="hidden" id="idPjdj" name="id">
        <div class="form-body">
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>评价年度</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="pjnd" name="pjnd" class="form-control">
                            <option value="2010">2010</option>
                            <option value="2011">2011</option>
                            <option value="2012">2012</option>
                            <option value="2013">2013</option>
                            <option value="2014">2014</option>
                            <option value="2015">2015</option>
                            <option value="2016">2016</option>
                            <option value="2017">2017</option>
                            <option value="2018">2018</option>
                            <option value="2019">2019</option>
                            <option value="2020">2020</option>
                            <option value="2021">2021</option>
                            <option value="2022">2022</option>
                            <option value="2023">2023</option>
                            <option value="2024">2024</option>
                            <option value="2025">2025</option>
                            <option value="2026">2026</option>
                            <option value="2027">2027</option>
                            <option value="2028">2028</option>
                            <option value="2029">2029</option>
                            <option value="2030">2030</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>评价等级</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="pjdj" name="pjdj" class="form-control">
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3">评价结果</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <textarea id="pjjg" name="pjjg" class="form-control"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<%--信用承诺手动录入弹出框--%>
<div id="winAddXycn" style="display: none; margin: 10px 40px;">
    <form id="addXycnForm" method="post" class="form-horizontal">
        <input type="hidden" id="tyshxydmXycn" name="tyshxydm">
        <div class="form-body">
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>承诺类别</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <i class="fa"></i>
                        <select id="cnlb" name="cnlb" class="form-control">
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3"><span class="required">* </span>承诺类别</label>
                <div class="col-sm-8">
                    <div class="input-icon right">
                        <button type="button" class="btn btn-info" id="uploadImgCnlb">上传附件</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sszj/zjxxdaAdd.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>