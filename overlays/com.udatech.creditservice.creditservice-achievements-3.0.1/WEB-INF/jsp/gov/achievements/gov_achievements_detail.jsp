<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>绩效考核评分</title>
    <style type="text/css">
        table.score-table {
            width: 100%;
            border-collapse: collapse;
        }

        table.score-table th, table.score-table td {
            border: 1px solid #DEDEDE;
            padding: 8px 8px;
        }
    </style>
</head>
<body>

<div class="row">
    <div class="col-md-12">
        <div class="portlet box red-intense">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    绩效考核评分
                </div>
                <div class="tools" style="padding-left: 5px;">
                    <a href="javascript:void(0);" class="collapse"></a>
                </div>
                <div class="actions">
                    <a href="javascript:void(0);" id="backBtn2" class="btn btn-default btn-sm"> 返回 </a>
                </div>
            </div>
            <div class="portlet-body">

                <form id="submit_form">
                    <input id="id" type="hidden" value="${achievements.id}"/>

                    <div class="panel-group accordion scrollable" id="accordion2">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                                       href="#collapse_2_1"> 一、工作组织推进力度（分值：40分） </a>
                                </h4>
                            </div>
                            <div id="collapse_2_1" class="panel-collapse in">
                                <div class="panel-body">
                                    <table class="score-table">
                                        <tr>
                                            <th colspan="2">考核内容</th>
                                            <th>部门评分</th>
                                            <th>部门备注</th>
                                            <%--<th>中心评分</th>
                                            <th>中心备注</th>--%>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%;">保障机制（2分）</td>
                                            <td style="width: 30%;">
                                                落实牵头处室和技术保障处室，明确专人负责，得1分；<br/>
                                                建立和落实信用日常工作和数据报送、异议处理制度得1分。
                                            </td>
                                            <td style="width: 10%;">
                                                <c:out value="${kpis.score100100}"/>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:out value="${kpis.desc100100}"/>
                                            </td>
                                            <%--<td style="width: 10%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score100100center}"/>
                                                </c:if>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc100100center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>宣传报道（10分）</td>
                                            <td>
                                                开展信用宣传活动2分，向“诚信苏州”网站等提供稿件，按月报送1篇得0.5分，最高得6分；<br/>
                                                年内稿件被“诚信苏州”网站采用1篇得1分，最高得2分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score100101}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc100101}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score100101center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc100101center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>应用信用信息和信用产品（4分）</td>
                                            <td>
                                                在行政管理中实行信用承诺制度，并上网公示得1分；<br/>
                                                使用市公共信用信息中心出具的信用查询或审查报告，查询或审查对象超过100家以上或全年批量审查3次以上得3分，未达到100家或少于3次的，按比例得分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score100102}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc100102}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score100102center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc100102center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>落实市信用管理部门工作任务（14分）</td>
                                            <td>
                                                参加市政府、市社会信用体系建设领导小组和市信用办等组织的会议（活动），满分2分，每缺席一次扣0.5分；<br/>
                                                完成工作要点（任务分解表）12分，未完成的按照任务量比例扣分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score100103}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc100103}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score100103center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc100103center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>开展失信联动奖惩（10分）</td>
                                            <td>
                                                落实开展守信联合激励和失信联合惩戒制度，并向信用办报送守信联合激励和失信联合惩戒典型案例，最高得10分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score100104}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc100104}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score100104center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc100104center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                                       href="#collapse_2_2"> 二、向市级公共信用信息平台报送信息（分值：30分） </a>
                                </h4>
                            </div>
                            <div id="collapse_2_2" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <table class="score-table">
                                        <tr>
                                            <th colspan="2">考核内容</th>
                                            <th>部门评分</th>
                                            <th>部门备注</th>
                                            <%--<th>中心评分</th>
                                            <th>中心备注</th>--%>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%;">提供方式（2分）</td>
                                            <td style="width: 30%;">
                                                数据库对接方式或前置机方式提供的得2分；其他方式提供的得1分。
                                            </td>
                                            <td style="width: 10%;">
                                                <c:out value="${kpis.score101100}"/>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:out value="${kpis.desc101100}"/>
                                            </td>
                                            <%--<td style="width: 10%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101100center}"/>
                                                </c:if>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101100center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>信息量（8分）</td>
                                            <td>
                                                根据市级部门全年产生数据量和报送数据量按比值给分。最高得5分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score101101}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc101101}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101101center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101101center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>标志失信程度（1分）</td>
                                            <td>
                                                报送信息中正确添加、标志失信严重程度的得3分，仅提供失信情况的得1分，否则不得分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score101102}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc101102}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101102center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101102center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>数据时效性（6分）</td>
                                            <td>
                                                双公示信息按7个工作日内报送3分，其他信用信息每月报送3分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score101103}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc101103}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101103center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101103center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>数据有效入库情况（6分）</td>
                                            <td>
                                                以有效入库率衡量，入库率=有效入库记录总数/提供记录总数×100%。入库率95%以上（含95%）得6分；95%以下的按百分比×6得分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score101104}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc101104}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101104center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101104center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>数据规范性（6分）</td>
                                            <td>
                                                以完整率衡量，完整率=实际提供的数据项数量/要求提供的数据项数量×100%。完整率95%以上（含95%）得3分；95%以下的按百分比×3得分。
                                                提供的数据内容准确要求达95%以上（含95%）的得3分，95%以下的按百分比×3得分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score101105}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc101105}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101105center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101105center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>“红黑名单”报送（1分）</td>
                                            <td>
                                                经严格审核，规范、准确向市公共信用信息系统报送已向社会公示的“红名单”或“黑名单”，除零增量外， 得1分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score101106}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc101106}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score101106center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc101106center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                                       href="#collapse_2_3"> 三、双公示工作情况（分值：30分） </a>
                                </h4>
                            </div>
                            <div id="collapse_2_3" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <table class="score-table">
                                        <tr>
                                            <th colspan="2">考核内容</th>
                                            <th>部门评分</th>
                                            <th>部门备注</th>
                                            <%--<th>中心评分</th>
                                            <th>中心备注</th>--%>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%;">双公示月报表（12分）</td>
                                            <td style="width: 30%;">
                                                各部门每月10号前上报上一月度部门双公示情况表，认真填写表格内容。<br/>
                                                参照报送要求酌情给分，满分12分。
                                            </td>
                                            <td style="width: 10%;">
                                                <c:out value="${kpis.score102100}"/>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:out value="${kpis.desc102100}"/>
                                            </td>
                                            <%--<td style="width: 10%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score102100center}"/>
                                                </c:if>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc102100center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>部门网站公示情况、数据报送情况（12分）</td>
                                            <td>
                                                每月对各部门网站双公示工作情况、对各部门双公示信息报送情况进行考核。<br/>
                                                参照考核要求酌情给分，满分12分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score102101}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc102101}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score102101center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc102101center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>双公示工作落实情况（6分）</td>
                                            <td>
                                                根据各部门工作推进情况，年度总结，参加会议，督查情况考评等综合评分，满分6分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score102102}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc102102}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score102102center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc102102center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2"
                                       href="#collapse_2_4"> 四、工作创新（加分项，分值：10分） </a>
                                </h4>
                            </div>
                            <div id="collapse_2_4" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <table class="score-table">
                                        <tr>
                                            <th colspan="2">考核内容</th>
                                            <th>部门评分</th>
                                            <th>部门备注</th>
                                            <%--<th>中心评分</th>
                                            <th>中心备注</th>--%>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%;">工作创新（6分）</td>
                                            <td style="width: 30%;">
                                                开展信用信息和产品（如桂花分）应用推广创新；信用工作创新得6分。
                                            </td>
                                            <td style="width: 10%;">
                                                <c:out value="${kpis.score103100}"/>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:out value="${kpis.desc103100}"/>
                                            </td>
                                            <%--<td style="width: 10%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score103100center}"/>
                                                </c:if>
                                            </td>
                                            <td style="width: 20%;">
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc103100center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td>获信用工作表彰情况或国家、省信用工作创新试点项目（4分）</td>
                                            <td>
                                                国家级4分，条线系统、领导小组2分，市政府1分。
                                            </td>
                                            <td>
                                                <c:out value="${kpis.score103101}"/>
                                            </td>
                                            <td>
                                                <c:out value="${kpis.desc103101}"/>
                                            </td>
                                            <%--<td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.score103101center}"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${achievements.status == 3}">
                                                    <c:out value="${kpis.desc103101center}"/>
                                                </c:if>
                                            </td>--%>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" style="overflow: hidden;">
                        <div class="col-md-6">
                            部门附件：
                            <c:if test="${achievements.bmfj != null}">
                                <div class="preview-img-panel">
                                    <c:forEach var="t" items="${achievements.bmfj}">
                                        <div class="preview-file">
                                            <div class="preview-icon">
                                                <img src="${pageContext.request.contextPath}${t.icon}"/>
                                            </div>
                                            <div class="preview-name">${t.fileName}</div>
                                            <div class="preview-operate">
                                                <div class="preview-download"
                                                     onclick="downloadFile('${t.uploadFileId}');">下载
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                        <%--<div class="col-md-6">
                            中心附件：
                            <c:if test="${achievements.status == 3 and achievements.zxfj != null}">
                                <div class="preview-img-panel">
                                    <c:forEach var="t" items="${achievements.zxfj}">
                                        <div class="preview-file">
                                            <div class="preview-icon">
                                                <img src="${pageContext.request.contextPath}${t.icon}"/>
                                            </div>
                                            <div class="preview-name">${t.fileName}</div>
                                            <div class="preview-operate">
                                                <div class="preview-download"
                                                     onclick="downloadFile('${t.uploadFileId}');">下载
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>--%>
                    </div>

                </form>

                <div class="form-actions" style="text-align: center;">
                    <a href="javascript:;" id="backBtn" class="btn default"> 返回 </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $("#backBtn,#backBtn2").click(function () {
            $("div#handleDiv").hide();
            $("div#mainListDiv").show();
            var selectArr = recordSelectNullEle();
            $("div#mainListDiv").prependTo('#topDiv');
            callbackSelectNull(selectArr);
            resetIEPlaceholder();
            var activeIndex = recordDtActiveIndex(gl.table);
            gl.table.ajax.reload(function () {
                callbackDtRowActive(gl.table, activeIndex);
            }, false);// 刷新列表还保留分页信息
        });
    });
</script>

</body>
</html>