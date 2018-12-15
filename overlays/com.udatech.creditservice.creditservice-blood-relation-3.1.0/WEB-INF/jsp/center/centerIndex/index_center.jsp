<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8"/>
    <title>公信力</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="description" content="">
    <link href="${pageContext.request.contextPath}/app/css/center/centerIndex.css" rel="stylesheet" type="text/css"/>
</head>

<body>

<div class="creditCountBox">

    <div class="sjgjBox gray1BG marB10" style="padding-left: 20px;padding-top: 10px;padding-right: 10px;">
        <div class="countTit">
            <h3 class="floatL bold">数据归集统计</h3>
            <div class="floatR">
                <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#2511')">更多>><span></span></a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 col-xs-12  col-sm-12 col-lg-4" style=" padding: 10px 20px;">
                <div class="dashboard-stat green-haze zxdzy-div">
                    <div class="visual zxdzy-visual">
                        <i class="fa  fa-database"></i>
                    </div>
                    <div class="details">
                        <div class="number" id="allCreditCount">0</div>
                        <div class="desc">信用数据总量</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 col-xs-12  col-sm-12 col-lg-4" style="padding: 10px 20px;">
                <div class="dashboard-stat blue-madison zxdzy-div">
                    <div class="visual zxdzy-visual">
                        <i class="fa fa-university"></i>
                    </div>
                    <div class="details">
                        <div class="number" id="allEnterpriseCount">0</div>
                        <div class="desc">企业法人数据总量</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 col-xs-12  col-sm-12 col-lg-4" style=" padding: 10px 20px;">
                <div class="dashboard-stat blue zxdzy-div">
                    <div class="visual zxdzy-visual">
                        <i class=" icon-users"></i>
                    </div>
                    <div class="details">
                        <div class="number" id="allPersonCount"></div>
                        <div class="desc">自然人数据总量</div>
                    </div>
                </div>
            </div>
        </div>

        <%--<div class="countCon sjgjCon overH">--%>
            <%--<div class="w33p">--%>
                <%--<dl>--%>
                    <%--<dt>--%>
                        <%--<img src="${pageContext.request.contextPath}/app/images/center/sjgj1.png" alt=""/>--%>
                        <%--<h4>信用数据总量</h4>--%>
                    <%--</dt>--%>
                    <%--<dd>--%>
                        <%--<h2 id="allCreditCount"></h2>--%>
                    <%--</dd>--%>
                <%--</dl>--%>
            <%--</div>--%>

            <%--<div class="w33p">--%>
                <%--<dl>--%>
                    <%--<dt>--%>
                        <%--<img src="${pageContext.request.contextPath}/app/images/center/sjgj2.png" alt=""/>--%>
                        <%--<h4>企业法人数据总量</h4>--%>
                    <%--</dt>--%>
                    <%--<dd>--%>
                        <%--<h2 id="allEnterpriseCount"></h2>--%>
                    <%--</dd>--%>
                <%--</dl>--%>
            <%--</div>--%>

            <%--<div class="w33p">--%>
                <%--<dl>--%>
                    <%--<dt>--%>
                        <%--<img src="${pageContext.request.contextPath}/app/images/center/sjgj3.png" alt=""/>--%>
                        <%--<h4>自然人数据总量</h4>--%>
                    <%--</dt>--%>
                    <%--<dd>--%>
                        <%--<h2 id="allPersonCount"></h2>--%>
                    <%--</dd>--%>
                <%--</dl>--%>
            <%--</div>--%>
        <%--</div>--%>

    </div>

    <div class="overH">

        <div class="w80p">

            <div class="sjgjBox gray1BG pad20 marB10">
                <div class="countTit">
                    <h3 class="floatL bold">数据新增月度统计</h3>
                    <div class="floatR">
                        <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#320005')">更多>><span></span></a>
                    </div>
                </div>
                <div class="ywlCon countCon">
                    <div class="topicCountBar" id="topicCountBar" style="width: 100%; height: 350px;">
                    </div>
                </div>

            </div>

            <div class="ywlBox gray1BG marB10">
                <div class="pad20">
                    <div class="countTit">
                        <h3 class="floatL bold">业务申请量统计</h3>
                        <div class="floatR">
                            <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#66')">更多>><span></span></a>
                        </div>
                    </div>
                    <div class="ywlCon countCon">
                        <div class="ywlConIn overH marB20">
                            <div class="w25p">
                                <dl class="ywl">
                                    <dd>
                                        <div class="overH">
                                            <h5 class="floatL">信用报告</h5>
                                        </div>
                                        <div class="ywlShow">
                                            <h4 class="floatL">本月</h4>
                                            <div class="floatR">
                                                <h2 class="bold" id="monthOfApply"></h2>
                                            </div>
                                        </div>
                                    </dd>
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">累计</h5>
                                            <div class="floatR">
                                                <h4 class="bold" id="allOfApply"></h4>
                                            </div>
                                        </div>

                                    </dt>
                                </dl>

                            </div>

                            <div class="w25p">
                                <dl class="ywl">
                                    <dd>
                                        <div class="overH">
                                            <h5 class="floatL">信用审查</h5>
                                        </div>
                                        <div class="ywlShow">
                                            <h4 class="floatL">本月</h4>
                                            <div class="floatR">
                                                <h2 class="bold" id="monthOfExamine"></h2>
                                            </div>
                                        </div>
                                    </dd>
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">累计</h5>
                                            <div class="floatR">
                                                <h4 class="bold" id="allOfExamine"></h4>
                                            </div>
                                        </div>
                                    </dt>
                                </dl>

                            </div>

                            <div class="w25p">
                                <dl class="ywl">
                                    <dd>
                                        <div class="overH">
                                            <h5 class="floatL">信用修复</h5>
                                        </div>
                                        <div class="ywlShow">
                                            <h4 class="floatL">本月</h4>
                                            <div class="floatR">
                                                <h2 class="bold" id="monthOfRepair"></h2>
                                            </div>
                                        </div>
                                    </dd>
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">累计</h5>
                                            <div class="floatR">
                                                <h4 class="bold" id="allOfRepair"></h4>
                                            </div>
                                        </div>
                                    </dt>
                                </dl>
                            </div>

                            <div class="w25p">
                                <dl class="ywl">
                                    <dd>
                                        <div class="overH">
                                            <h5 class="floatL">异议申诉</h5>
                                        </div>
                                        <div class="ywlShow">
                                            <h4 class="floatL">本月</h4>
                                            <div class="floatR">
                                                <h2 class="bold" id="monthOfObjection"></h2>
                                            </div>
                                        </div>
                                    </dd>
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">累计</h5>
                                            <div class="floatR">
                                                <h4 class="bold" id="allOfObjection"></h4>
                                            </div>
                                        </div>
                                    </dt>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ztBox gray1BG marB10">
                <div class="pad20">
                    <div class="countTit">
                        <h3 class="floatL bold">专题统计</h3>
                        <div class="floatR">
                            <div class="countTab">
                                <a href="javascript:;" class="countTabAct" onclick="indexCenter.getMonthTopicCount();" id="monthTopicCount">本月新增</a>
                                <a href="javascript:;" class="countTabNor" onclick="indexCenter.getAllTopicCount();" id="allTopicCount">累计全部</a>
                            </div>
                        </div>
                    </div>
                    <div class="ztCon countCon">
                        <div class="ztConIn overH">

                            <div class="w33p">
                                <dl class="zt">
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">信用双公示</h5>
                                            <div class="floatR">
                                                <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#50')">更多>><span></span></a>
                                            </div>
                                        </div>
                                    </dt>
                                    <dd>
                                        <div class="overH">

                                            <table width="100%">
                                                <tr>
                                                    <td width="60%" align="center">
                                                        <div class="sgsPie" id="sgsPie" style="width: 100%; height: 120px;">
                                                        </div>
                                                    </td>
                                                    <td width="40%" nowrap="nowrap">
                                                        <div>

                                                            <div class="marB10">
                                                                <h6 class="taLeft">
                                                                    行政许可公示
                                                                </h6>
                                                                <h3 class="taRight bold">
                                                                    <span id="dataOfsgsxzxk"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条
																</span>
                                                                </h3>
                                                            </div>

                                                            <div>
                                                                <h6 class="taLeft">
                                                                    行政处罚公示
                                                                </h6>
                                                                <h3 class="taRight bold">
                                                                    <span id="dataOfsgsxzcf"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条
																</span>
                                                                </h3>
                                                            </div>

                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </dd>
                                </dl>
                            </div>

                            <div class="w33p">
                                <dl class="zt">
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">红黑名单</h5>
                                            <div class="floatR">
                                                <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#70')">更多>><span></span></a>
                                            </div>
                                        </div>
                                    </dt>
                                    <dd>
                                        <div class="overH">

                                            <table width="100%">
                                                <tr>
                                                    <td width="60%" align="center">
                                                        <div class="mingdanPie" id="mingdanPie" style="width: 100%; height: 120px;">
                                                        </div>
                                                    </td>
                                                    <td width="40%" nowrap="nowrap">
                                                        <div>

                                                            <div class="marB10">
                                                                <h6 class="taLeft">
                                                                    红名单
                                                                </h6>
                                                                <h3 class="taRight bold">
                                                                    <span id="dataOfhongmingdan"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条
																</span>
                                                                </h3>
                                                            </div>

                                                            <div>
                                                                <h6 class="taLeft">
                                                                    黑名单
                                                                </h6>
                                                                <h3 class="taRight bold">
                                                                    <span id="dataOfheimingdan"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条
																</span>
                                                                </h3>
                                                            </div>

                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </dd>
                                </dl>
                            </div>

                            <div class="w33p">
                                <dl class="zt">
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">信用承诺</h5>
                                            <div class="floatR">
                                                <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#57')">更多>><span></span></a>
                                            </div>
                                        </div>
                                    </dt>
                                    <dd>
                                        <div class="overH">

                                            <table width="100%">
                                                <tr>
                                                    <td width="60%" align="center">
                                                        <div class="creditCommintPie" id="creditCommintPie" style="width: 100%; height: 120px;">
                                                        </div>
                                                    </td>
                                                    <td width="40%" nowrap="nowrap">
                                                        <div>

                                                            <div class="marB10">
                                                                <h6 class="taLeft">
                                                                    承诺主体
                                                                </h6>
                                                                <h3 class="taRight bold">
                                                                    <span id="creditCommint"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条</span>
                                                                </h3>
                                                            </div>

                                                            <div>
                                                                <h6 class="taLeft">
                                                                    列入黑名单
                                                                </h6>
                                                                <h3 class="taRight bold">
                                                                    <span id="creditCommintWithBlack"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条</span>
                                                                </h3>
                                                            </div>

                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </dd>
                                </dl>
                            </div>

                        </div>

                    </div>
                </div>
            </div>

            <div class="ztBox gray1BG">
                <div class="pad20">
                    <div class="countTit">
                        <h3 class="floatL bold">联合奖惩统计</h3>
                        <div class="floatR">
                            <a href="javascript:;" class="countMore" onclick="AccordionMenu.skipToMenu('#5005')">更多>><span></span></a>
                        </div>
                    </div>
                    <div class="ztCon countCon">
                        <div class="ztConIn overH">

                            <div class="w33p">
                                <dl class="zt">
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">联合激励专题</h5>
                                            <div class="floatR">
                                                <h6 class="taRight bold">
                                                    <span id="rewardsCount"></span>&nbsp;&nbsp;<span class="font14 Fnormal">个</span>
                                                </h6>
                                            </div>
                                        </div>
                                    </dt>
                                    <dd>
                                        <div class="overH">

                                            <table width="100%">
                                                <tr>
                                                    <td nowrap="nowrap">
                                                        <div>

                                                            <div>
                                                                <h6 class="taLeft">
                                                                    激励对象
                                                                </h6>
                                                                <h3 class="taRight bold zxdzy-h3">
                                                                    <span class="font14 Fnormal">企业法人</span>&nbsp;&nbsp;
                                                                    <span id="enterpriseRewards"></span>&nbsp;&nbsp;<span class="font14 Fnormal">条</span>
                                                                </h3>
                                                                <h3 class="taRight bold zxdzy-h3">
                                                                    <span class="font14 Fnormal">自然人</span>&nbsp;&nbsp;
                                                                    <span id="personRewards"></span>&nbsp;&nbsp;<span class="font14 Fnormal">条</span>
                                                                </h3>
                                                            </div>

                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </dd>
                                </dl>
                            </div>

                            <div class="w33p">
                                <dl class="zt">
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">联合惩戒专题</h5>
                                            <div class="floatR">
                                                <h6 class="taRight bold">
                                                    <span id="punishmentCount"></span>&nbsp;&nbsp;<span class="font14 Fnormal">个</span>
                                                </h6>
                                            </div>
                                        </div>
                                    </dt>
                                    <dd>
                                        <div class="overH">

                                            <table width="100%">
                                                <tr>
                                                    <td nowrap="nowrap">
                                                        <div>

                                                            <div>
                                                                <h6 class="taLeft">
                                                                    惩戒对象
                                                                </h6>
                                                                <h3 class="taRight bold zxdzy-h3">
                                                                    <span class="font14 Fnormal">企业法人</span>&nbsp;&nbsp;
                                                                    <span id="enterprisePunishment"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条</span>
                                                                </h3>
                                                                <h3 class="taRight bold zxdzy-h3">
                                                                    <span class="font14 Fnormal">自然人</span>&nbsp;&nbsp;
                                                                    <span id="personPunishment"></span>&nbsp;&nbsp;<span class="font12 Fnormal">条</span>
                                                                </h3>
                                                            </div>

                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </dd>
                                </dl>
                            </div>

                            <div class="w33p">
                                <dl class="zt">
                                    <dt>
                                        <div class="overH">
                                            <h5 class="floatL">执行反馈情况</h5>
                                            <div class="floatR">
                                            </div>
                                        </div>
                                    </dt>
                                    <dd>
                                        <div class="overH">

                                            <table width="100%">
                                                <tr>
                                                    <td nowrap="nowrap">
                                                        <div>

                                                            <div>
                                                                <h6 class="taLeft">
                                                                    反馈对象
                                                                </h6>
                                                                <h3 class="taRight bold zxdzy-h3">
                                                                    <span class="font14 Fnormal">企业法人</span>&nbsp;&nbsp;
                                                                    <span id="enterpriseFeedback"></span>&nbsp;&nbsp;<span class="font12 Fnormal">次</span>
                                                                </h3>
                                                                <h3 class="taRight bold zxdzy-h3">
                                                                    <span class="font14 Fnormal">自然人</span>&nbsp;&nbsp;
                                                                    <span id="personFeedback"></span>&nbsp;&nbsp;</span><span class="font12 Fnormal">次</span>
                                                                </h3>
                                                            </div>

                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </dd>
                                </dl>
                            </div>

                        </div>

                    </div>
                </div>
            </div>

        </div>

        <div class="dbsxBox w20p">
            <div class="padL10">
                <div class="pad20 gray1BG">
                    <div class="countTit">
                        <h3 class="floatL bold">待办事项</h3>
                        <div class="floatR">
                        </div>
                    </div>
                    <div class="dbsxCon countCon">

                        <dl class="dbsx blue-madison marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#1500')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待审核法人信用报告</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="ExamineOfApplyEnterprise"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx green-haze marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#1501')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待审核自然人信用报告</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="ExamineOfApplyPerson"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx blue-madison marB10" href="javascript:;" onclick="indexCenter.toCreditExamineList()">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待审核法人信用审查</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="ExamineOfExamineEnterprise"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx green-haze marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#3000')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待审核自然人信用审查</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="ExamineOfExaminePerson"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx blue-madison marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#1510')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待审核信用修复</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="repairExamine"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx green-haze marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#1510')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待修复信用修复</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="repairRepair"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx blue-madison marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#1505')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待审核异议申诉</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="objectionExamine"></h2>
                                </div>
                            </dd>
                        </dl>

                        <dl class="dbsx green-haze marB10" href="javascript:;" onclick="AccordionMenu.skipToMenu('#1505')">
                            <dd>
                                <div class="overH">
                                    <h6 class="floatL">待修正异议申诉</h6>
                                    <div class="floatR">
                                    </div>
                                </div>
                                <div class="dbsxShow">
                                    <h2 class="bold" id="objectionRepair"></h2>
                                </div>
                            </dd>
                        </dl>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/centerIndex/index_center.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>