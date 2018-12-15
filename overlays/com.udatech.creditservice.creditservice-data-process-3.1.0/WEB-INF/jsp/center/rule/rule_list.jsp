<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>字段规则管理</title>
    <style type="text/css">
        div.rule div.portlet-body {
            overflow-x: hidden;
        }

        div.rule input.form-control, div.rule button.btn {
            margin-top: 5px;
            margin-bottom: 5px;
        }

        div.rule button.btn {
            margin-left: 0px;
            margin-right: 5px;
        }

        .iCheck {
            margin-bottom: 10px;
        }

        .iCheck label {
            padding-left: 5px;
        }

        .hidden {
            display: none
        }
    </style>
</head>
<body>
<div class="row rule">

    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    字段规则管理
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
                <div class="actions">
                    <a href="javascript:void(0);" id="newBtn" class="btn btn-default btn-sm">
                        <i class="fa fa-plus"></i>
                        新增
                    </a>
                </div>
            </div>

            <div class="portlet-body">

                <div class="iCheck">
                    <label><input type="radio" name="iCheck" value="0" checked class="icheck">正则表达式</label>
                    <%--<label><input type="radio" name="iCheck" value="1" class="icheck">插件</label>--%>
                    <label><input type="radio" name="iCheck" value="2" class="icheck">默认值</label>
                    <label><input type="radio" name="iCheck" value="3" class="icheck">时间合理性</label>
                    <label><input type="radio" name="iCheck" value="4" class="icheck">特殊规则</label>
                    <label><input type="radio" name="iCheck" value="5" class="icheck">身份证验证</label>
                </div>
                <div id="table0">
                    <div class="row" style="border-bottom: 1px solid #dedede; padding-bottom: 5px; font-weight: bold;">
                        <div class="col-md-2">
                            <i class="fa fa-info" style="color: green;"></i>
                            &nbsp;规则名称
                        </div>
                        <div class="col-md-2">
                            <i class="fa fa-question" style="color: blue;"></i>
                            &nbsp;规则（正则表达式）
                        </div>
                        <div class="col-md-3">
                            <i class="fa fa-bell-o" style="color: #dd4b39;"></i>
                            &nbsp;提示消息
                        </div>
                        <%--<div class="col-md-2">--%>
                            <%--<i class="fa fa-flask" style="color: #f39c12;"></i>--%>
                            <%--&nbsp;用途类型--%>
                        <%--</div>--%>
                        <div class="col-md-3">操作</div>
                    </div>
                    <form id="ruleForm0" class="rule" action="#" method="post">
                        <div id="ruleList0"></div>
                    </form>
                </div>

                <div id="table1" class="hidden">
                    <div class="row" style="border-bottom: 1px solid #dedede; padding-bottom: 5px; font-weight: bold;">
                        <div class="col-md-2">
                            <i class="fa fa-info" style="color: green;"></i>
                            &nbsp;规则名称
                        </div>
                        <div class="col-md-2" style="width: 14%">
                            <i class="fa fa-file-code-o" style="color: blue;"></i>
                            &nbsp;类名
                        </div>
                        <div class="col-md-2">
                            <i class="fa fa-file-zip-o" style="color: #f39c12;"></i>
                            &nbsp;方法名
                        </div>
                        <%--<div class="col-md-2">--%>
                            <%--<i class="fa fa-flask" style="color: #f39c12;"></i>--%>
                            <%--&nbsp;用途类型--%>
                        <%--</div>--%>
                        <div class="col-md-2">
                            <i class="fa fa-bell-o" style="color: #dd4b39;"></i>
                            &nbsp;提示消息
                        </div>
                        <div class="col-md-3" style="width: 18%;">操作</div>
                    </div>
                    <form id="ruleForm1" class="rule" action="#" method="post">
                        <div id="ruleList1"></div>
                    </form>
                </div>

                <div id="table2" class="hidden">
                    <div class="row" style="border-bottom: 1px solid #dedede; padding-bottom: 5px; font-weight: bold;">
                        <div class="col-md-2">
                            <i class="fa fa-info" style="color: green;"></i>
                            &nbsp;规则名称
                        </div>
                        <div class="col-md-2">
                            <i class="fa fa-check-square" style="color: blue;"></i>
                            &nbsp;默认值
                        </div>
                        <%--<div class="col-md-2">--%>
                            <%--<i class="fa fa-flask" style="color: #f39c12;"></i>--%>
                            <%--&nbsp;用途类型--%>
                        <%--</div>--%>
                        <div class="col-md-3">
                            <i class="fa fa-bell-o" style="color: #dd4b39;"></i>
                            &nbsp;提示消息
                        </div>
                        <div class="col-md-3">操作</div>
                    </div>
                    <form id="ruleForm2" class="rule" action="#" method="post">
                        <div id="ruleList2"></div>
                    </form>
                </div>

                <div id="table3" class="hidden">
                    <div class="row" style="border-bottom: 1px solid #dedede; padding-bottom: 5px; font-weight: bold;">
                        <div class="col-md-2">
                            <i class="fa fa-info" style="color: green;"></i>
                            &nbsp;规则名称
                        </div>
                        <%--<div class="col-md-2">--%>
                            <%--<i class="fa fa-flask" style="color: #f39c12;"></i>--%>
                            <%--&nbsp;用途类型--%>
                        <%--</div>--%>
                        <div class="col-md-3">
                            <i class="fa fa-bell-o" style="color: #dd4b39;"></i>
                            &nbsp;提示消息
                        </div>
                        <div class="col-md-3">操作</div>
                    </div>
                    <form id="ruleForm3" class="rule" action="#" method="post">
                        <div id="ruleList3"></div>
                    </form>
                </div>
                <div id="table4" class="hidden">
                    <div class="row" style="border-bottom: 1px solid #dedede; padding-bottom: 5px; font-weight: bold;">
                        <div class="col-md-2">
                            <i class="fa fa-info" style="color: green;"></i>
                            &nbsp;规则名称
                        </div>
                        <%--<div class="col-md-2">--%>
                        <%--<i class="fa fa-flask" style="color: #f39c12;"></i>--%>
                        <%--&nbsp;用途类型--%>
                        <%--</div>--%>
                        <div class="col-md-3">
                            <i class="fa fa-bell-o" style="color: #dd4b39;"></i>
                            &nbsp;提示消息
                        </div>
                        <div class="col-md-3">操作</div>
                    </div>
                    <form id="ruleForm4" class="rule" action="#" method="post">
                        <div id="ruleList4"></div>
                    </form>
                </div>
                <div id="table5" class="hidden">
                    <div class="row" style="border-bottom: 1px solid #dedede; padding-bottom: 5px; font-weight: bold;">
                        <div class="col-md-2">
                            <i class="fa fa-info" style="color: green;"></i>
                            &nbsp;规则名称
                        </div>
                        <%--<div class="col-md-2">--%>
                        <%--<i class="fa fa-flask" style="color: #f39c12;"></i>--%>
                        <%--&nbsp;用途类型--%>
                        <%--</div>--%>
                        <div class="col-md-3">
                            <i class="fa fa-bell-o" style="color: #dd4b39;"></i>
                            &nbsp;提示消息
                        </div>
                        <div class="col-md-3">操作</div>
                    </div>
                    <form id="ruleForm5" class="rule" action="#" method="post">
                        <div id="ruleList5"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div style="display: none;">
    <div class="row" id="oneRule0" style="border-bottom: 1px dashed #dedede;">
        <input type="hidden" class="id" value=""/>
        <input type="hidden" class="type" value="0"/>
        <input type="hidden" class="ruleType" value="0"/>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control ruleName" name="ruleName"/>
            </div>
        </div>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control pattern" name="pattern"/>
            </div>
        </div>
        <div class="col-md-3">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control msg" name="msg"/>
            </div>
        </div>
        <%--<div class="col-md-2">--%>
            <%--<div class="input-icon right">--%>
                <%--<select class="form-control userType" name="userType" style="margin-top:5px">--%>
                    <%--<option value="0">校验数据</option>--%>
                    <%--<option value="1">清洗数据</option>--%>
                <%--</select>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="col-md-3">
            <button class="btn btn-info btn-sm edit-rule" type="button" style="display: none;">编辑</button>
            <button class="btn btn-success btn-sm cancel-rule" type="button" style="display: none;">取消</button>
            <button class="btn btn-primary btn-sm save-rule" type="button">保存</button>
            <button class="btn btn-danger btn-sm del-rule" type="button">删除</button>
        </div>
    </div>
</div>

<div style="display: none;">
    <div class="row" id="oneRule1" style="border-bottom: 1px dashed #dedede;">
        <input type="hidden" class="id" value=""/>
        <input type="hidden" class="type" value="0"/>
        <input type="hidden" class="ruleType" value="1"/>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control ruleName" name="ruleName"/>
            </div>
        </div>
        <div class="col-md-2" style="width:14%">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control pluginClassName" name="pluginClassName"/>
            </div>
        </div>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control pluginMethodName" name="pluginMethodName"/>
            </div>
        </div>
        <%--<div class="col-md-2">--%>
            <%--<div class="input-icon right">--%>
                <%--<select class="form-control userType" name="userType" style="margin-top:5px">--%>
                    <%--<option value="0">校验数据</option>--%>
                    <%--<option value="1">清洗数据</option>--%>
                <%--</select>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control msg" name="msg"/>
            </div>
        </div>
        <div class="col-md-3" style="width: 18%">
            <button class="btn btn-info btn-sm edit-rule" type="button" style="display: none;">编辑</button>
            <button class="btn btn-success btn-sm cancel-rule" type="button" style="display: none;">取消</button>
            <button class="btn btn-primary btn-sm save-rule" type="button">保存</button>
            <button class="btn btn-danger btn-sm del-rule" type="button">删除</button>
        </div>
    </div>
</div>

<div style="display: none;">
    <div class="row" id="oneRule2" style="border-bottom: 1px dashed #dedede;">
        <input type="hidden" class="id" value=""/>
        <input type="hidden" class="type" value="0"/>
        <input type="hidden" class="ruleType" value="2"/>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control ruleName" name="ruleName"/>
            </div>
        </div>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control defaultValue" name="defaultValue"/>
            </div>
        </div>
        <%--<div class="col-md-2">--%>
            <%--<div class="input-icon right">--%>
                <%--<i class="fa"></i>--%>
                <%--<select class="form-control userType" name="userType" style="margin-top:5px">--%>
                    <%--<option value="0">校验数据</option>--%>
                    <%--<option value="1">清洗数据</option>--%>
                <%--</select>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="col-md-3">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control msg" name="msg"/>
            </div>
        </div>
        <div class="col-md-3">
            <button class="btn btn-info btn-sm edit-rule" type="button" style="display: none;">编辑</button>
            <button class="btn btn-success btn-sm cancel-rule" type="button" style="display: none;">取消</button>
            <button class="btn btn-primary btn-sm save-rule" type="button">保存</button>
            <button class="btn btn-danger btn-sm del-rule" type="button">删除</button>
        </div>
    </div>
</div>
<div style="display: none;">
    <div class="row" id="oneRule3" style="border-bottom: 1px dashed #dedede;">
        <input type="hidden" class="id" value=""/>
        <input type="hidden" class="type" value="0"/>
        <input type="hidden" class="ruleType" value="3"/>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control ruleName" name="ruleName"/>
            </div>
        </div>
        <%--<div class="col-md-2">--%>
            <%--<div class="input-icon right">--%>
                <%--<i class="fa"></i>--%>
                <%--<select class="form-control userType" name="userType" style="margin-top:5px">--%>
                    <%--<option value="0">校验数据</option>--%>
                    <%--<option value="1">清洗数据</option>--%>
                <%--</select>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="col-md-3">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control msg" name="msg"/>
            </div>
        </div>
        <div class="col-md-3">
            <button class="btn btn-info btn-sm edit-rule" type="button" style="display: none;">编辑</button>
            <button class="btn btn-success btn-sm cancel-rule" type="button" style="display: none;">取消</button>
            <button class="btn btn-primary btn-sm save-rule" type="button">保存</button>
            <button class="btn btn-danger btn-sm del-rule" type="button">删除</button>
        </div>
    </div>

</div>
<div style="display: none;">
    <div class="row" id="oneRule4" style="border-bottom: 1px dashed #dedede;">
        <input type="hidden" class="id" value=""/>
        <input type="hidden" class="type" value="0"/>
        <input type="hidden" class="ruleType" value="4"/>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control ruleName" name="ruleName"/>
            </div>
        </div>
        <%--<div class="col-md-2">--%>
            <%--<div class="input-icon right">--%>
                <%--<i class="fa"></i>--%>
                <%--<select class="form-control userType" name="userType" style="margin-top:5px">--%>
                    <%--<option value="0">校验数据</option>--%>
                    <%--<option value="1">清洗数据</option>--%>
                <%--</select>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="col-md-3">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control msg" name="msg"/>
            </div>
        </div>
        <div class="col-md-3">
            <button class="btn btn-info btn-sm edit-rule" type="button" style="display: none;">编辑</button>
            <button class="btn btn-success btn-sm cancel-rule" type="button" style="display: none;">取消</button>
            <button class="btn btn-primary btn-sm save-rule" type="button">保存</button>
            <button class="btn btn-danger btn-sm del-rule" type="button">删除</button>
        </div>
    </div>
</div>
<div style="display: none;">
    <div class="row" id="oneRule5" style="border-bottom: 1px dashed #dedede;">
        <input type="hidden" class="id" value=""/>
        <input type="hidden" class="type" value="0"/>
        <input type="hidden" class="ruleType" value="5"/>
        <div class="col-md-2">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control ruleName" name="ruleName"/>
            </div>
        </div>
        <%--<div class="col-md-2">--%>
        <%--<div class="input-icon right">--%>
        <%--<i class="fa"></i>--%>
        <%--<select class="form-control userType" name="userType" style="margin-top:5px">--%>
        <%--<option value="0">校验数据</option>--%>
        <%--<option value="1">清洗数据</option>--%>
        <%--</select>--%>
        <%--</div>--%>
        <%--</div>--%>
        <div class="col-md-3">
            <div class="input-icon right">
                <i class="fa"></i>
                <input type="text" class="form-control msg" name="msg"/>
            </div>
        </div>
        <div class="col-md-3">
            <button class="btn btn-info btn-sm edit-rule" type="button" style="display: none;">编辑</button>
            <button class="btn btn-success btn-sm cancel-rule" type="button" style="display: none;">取消</button>
            <button class="btn btn-primary btn-sm save-rule" type="button">保存</button>
            <button class="btn btn-danger btn-sm del-rule" type="button">删除</button>
        </div>
    </div>
</div>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/center/rule/rule_list.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>