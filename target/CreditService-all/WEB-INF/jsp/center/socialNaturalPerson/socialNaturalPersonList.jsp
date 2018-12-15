<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>自然人管理</title>
    <style type="text/css">
        .caption-df {
            padding: 10px 0;
            float: left;
            display: inline-block;
            font-size: 15px;
            font-weight: 600;
        }

        .zrrlxDiv a {
            margin: 5px 0;
            margin-left: 0px;
        }

        .btn + .btn {
            margin-left: 0px;
        }
    </style>
    <script type="text/javascript">
        function moreClick(em) {
            if ($('#more').hasClass('hide')) {
                $('#more').removeClass('hide')
                $(em).find('i').removeClass('glyphicon-chevron-down');
                $(em).find('i').addClass('glyphicon-chevron-up');
            } else {
                $('#more').addClass('hide')
                $(em).find('i').removeClass('glyphicon-chevron-up');
                $(em).find('i').addClass('glyphicon-chevron-down');
            }
        }
    </script>
</head>
<body>
<div id="topBox">
    <div id="parentBox">
        <div class="row">
            <div class="col-md-12">
                <div class="portlet box red-intense">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-th-list"></i>社会自然人
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="portlet light bg-inverse" style="padding: 10px; margin-bottom: 10px">
                                            <div class="row">
                                                <div class="col-md-1 col-sm-2">
                                                    <div class="caption-df" style="width: 100px">所属行业</div>
                                                </div>
                                                <div class="col-md-11 col-sm-10 zrrlxDiv">
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">律师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">教师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">医师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">公务员 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">企业法定代表人及相关责任人 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">房地产中介从业人员 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">导游 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">执业药师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">评估师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">税务师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">注册消防工程师 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">会计审计人员 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">认证人员 </a>
                                                    <a href="javascript:void(0);" onclick="naturalPerson.findByZymc(this);"
                                                       class="btn btn-default btn-sm">金融从业人员 </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <form class="form-inline" id="naturalPersonFrom">
                                            <input id="xm" name="xm" class="form-control input-md form-search" placeholder="姓名"/>
                                            <input id="sfzh" name="sfzh" class="form-control input-md form-search" placeholder="身份证号"/>
                                            <button type="button" class="btn btn-info btn-md form-search" onclick="naturalPerson.conditionSearch();">
                                                <i class="fa fa-search"></i>查询
                                            </button>
                                            <button type="button" class="btn btn-default btn-md form-search"
                                                    onclick="naturalPerson.conditionReset();">
                                                <i class="fa fa-rotate-left"></i>重置
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <table class="table table-striped table-hover table-bordered" id="naturalPersonGrid">
                                            <thead>
                                            <tr class="heading">
                                                <th>姓名</th>
                                                <th>身份证号</th>
                                                <th>性别</th>
                                                <th>所属行业</th>
                                                <th>出生日期</th>
                                                <th>民族</th>
                                                <th>户籍地址</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
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
                <label>
                    <input type="checkbox" class="icheck" checked data-column="0">
                    姓名
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="1">
                    身份证号
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="2">
                    性别
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="3">
                    所属行业
                </label>
                <label>
                    <input type="checkbox" class="icheck" checked data-column="4">
                    出生日期
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="5">
                    民族
                </label>
                <label>
                    <input type="checkbox" class="icheck" data-column="6">
                    户籍地址
                </label>
            </div>
        </div>
        <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/socialNaturalPerson/socialNaturalPersonList.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
    </div>
    <div id="childBox" style="display:none">

    </div>
</div>
</body>
</html>