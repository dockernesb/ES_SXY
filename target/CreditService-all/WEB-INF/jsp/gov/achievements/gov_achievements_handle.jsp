<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>绩效考核管理</title>
    <style type="text/css">
        table.score-table {
            width: 100%;
            border-collapse: collapse;
        }

        table.score-table th, table.score-table td {
            border: 1px solid #DEDEDE;
            padding: 8px 8px;
        }

        textarea.score-input, textarea.desc-input {
            width: 100%;
            height: 100%;
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
                    <c:if test="${achievements.id == null}">添加绩效</c:if>
                    <c:if test="${achievements.id != null}">修改绩效</c:if>
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
                                        </tr>
                                        <tr>
                                            <td style="width: 20%;">保障机制（2分）</td>
                                            <td style="width: 50%;">
                                                落实牵头处室和技术保障处室，明确专人负责，得1分；<br/>
                                                建立和落实信用日常工作和数据报送、异议处理制度得1分。
                                            </td>
                                            <td style="width: 10%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score100100" class="score-input form-control"
                                                              name="score100100"><c:out
                                                            value="${kpis.score100100}"/></textarea>
                                                </div>
                                            </td>
                                            <td style="width: 20%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc100100" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc100100}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>宣传报道（10分）</td>
                                            <td>
                                                开展信用宣传活动2分，向“诚信苏州”网站等提供稿件，按月报送1篇得0.5分，最高得6分；<br/>
                                                年内稿件被“诚信苏州”网站采用1篇得1分，最高得2分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score100101" class="score-input form-control"
                                                              name="score100101"><c:out
                                                            value="${kpis.score100101}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc100101" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc100101}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>应用信用信息和信用产品（4分）</td>
                                            <td>
                                                在行政管理中实行信用承诺制度，并上网公示得1分；<br/>
                                                使用市公共信用信息中心出具的信用查询或审查报告，查询或审查对象超过100家以上或全年批量审查3次以上得3分，未达到100家或少于3次的，按比例得分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score100102" class="score-input form-control"
                                                              name="score100102"><c:out
                                                            value="${kpis.score100102}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc100102" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc100102}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>落实市信用管理部门工作任务（14分）</td>
                                            <td>
                                                参加市政府、市社会信用体系建设领导小组和市信用办等组织的会议（活动），满分2分，每缺席一次扣0.5分；<br/>
                                                完成工作要点（任务分解表）12分，未完成的按照任务量比例扣分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score100103" class="score-input form-control"
                                                              name="score100103"><c:out
                                                            value="${kpis.score100103}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc100103" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc100103}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>开展失信联动奖惩（10分）</td>
                                            <td>
                                                落实开展守信联合激励和失信联合惩戒制度，并向信用办报送守信联合激励和失信联合惩戒典型案例，最高得10分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score100104" class="score-input form-control"
                                                              name="score100104"><c:out
                                                            value="${kpis.score100104}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc100104" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc100104}"/></textarea>
                                                </div>
                                            </td>
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
                                        </tr>
                                        <tr>
                                            <td style="width: 20%;">提供方式（2分）</td>
                                            <td style="width: 50%;">
                                                数据库对接方式或前置机方式提供的得2分；其他方式提供的得1分。
                                            </td>
                                            <td style="width: 10%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101100" class="score-input form-control"
                                                              name="score101100"><c:out
                                                            value="${kpis.score101100}"/></textarea>
                                                </div>
                                            </td>
                                            <td style="width: 20%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101100" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101100}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>信息量（8分）</td>
                                            <td>
                                                根据市级部门全年产生数据量和报送数据量按比值给分。最高得5分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101101" class="score-input form-control"
                                                              name="score101101"><c:out
                                                            value="${kpis.score101101}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101101" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101101}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>标志失信程度（1分）</td>
                                            <td>
                                                报送信息中正确添加、标志失信严重程度的得3分，仅提供失信情况的得1分，否则不得分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101102" class="score-input form-control"
                                                              name="score101102"><c:out
                                                            value="${kpis.score101102}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101102" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101102}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>数据时效性（6分）</td>
                                            <td>
                                                双公示信息按7个工作日内报送3分，其他信用信息每月报送3分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101103" class="score-input form-control"
                                                              name="score101103"><c:out
                                                            value="${kpis.score101103}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101103" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101103}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>数据有效入库情况（6分）</td>
                                            <td>
                                                以有效入库率衡量，入库率=有效入库记录总数/提供记录总数×100%。入库率95%以上（含95%）得6分；95%以下的按百分比×6得分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101104" class="score-input form-control"
                                                              name="score101104"><c:out
                                                            value="${kpis.score101104}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101104" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101104}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>数据规范性（6分）</td>
                                            <td>
                                                以完整率衡量，完整率=实际提供的数据项数量/要求提供的数据项数量×100%。完整率95%以上（含95%）得3分；95%以下的按百分比×3得分。
                                                提供的数据内容准确要求达95%以上（含95%）的得3分，95%以下的按百分比×3得分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101105" class="score-input form-control"
                                                              name="score101105"><c:out
                                                            value="${kpis.score101105}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101105" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101105}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>“红黑名单”报送（1分）</td>
                                            <td>
                                                经严格审核，规范、准确向市公共信用信息系统报送已向社会公示的“红名单”或“黑名单”，除零增量外， 得1分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score101106" class="score-input form-control"
                                                              name="score101106"><c:out
                                                            value="${kpis.score101106}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc101106" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc101106}"/></textarea>
                                                </div>
                                            </td>
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
                                        </tr>
                                        <tr>
                                            <td style="width: 20%;">双公示月报表（12分）</td>
                                            <td style="width: 50%;">
                                                各部门每月10号前上报上一月度部门双公示情况表，认真填写表格内容。<br/>
                                                参照报送要求酌情给分，满分12分。
                                            </td>
                                            <td style="width: 10%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score102100" class="score-input form-control"
                                                              name="score102100"><c:out
                                                            value="${kpis.score102100}"/></textarea>
                                                </div>
                                            </td>
                                            <td style="width: 20%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc102100" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc102100}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>部门网站公示情况、数据报送情况（12分）</td>
                                            <td>
                                                每月对各部门网站双公示工作情况、对各部门双公示信息报送情况进行考核。<br/>
                                                参照考核要求酌情给分，满分12分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score102101" class="score-input form-control"
                                                              name="score102101"><c:out
                                                            value="${kpis.score102101}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc102101" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc102101}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>双公示工作落实情况（6分）</td>
                                            <td>
                                                根据各部门工作推进情况，年度总结，参加会议，督查情况考评等综合评分，满分6分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score102102" class="score-input form-control"
                                                              name="score102102"><c:out
                                                            value="${kpis.score102102}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc102102" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc102102}"/></textarea>
                                                </div>
                                            </td>
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
                                        </tr>
                                        <tr>
                                            <td style="width: 20%;">工作创新（6分）</td>
                                            <td style="width: 50%;">
                                                开展信用信息和产品（如桂花分）应用推广创新；信用工作创新得6分。
                                            </td>
                                            <td style="width: 10%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score103100" class="score-input form-control"
                                                              name="score103100"><c:out
                                                            value="${kpis.score103100}"/></textarea>
                                                </div>
                                            </td>
                                            <td style="width: 20%;">
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc103100" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc103100}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>获信用工作表彰情况或国家、省信用工作创新试点项目（4分）</td>
                                            <td>
                                                国家级4分，条线系统、领导小组2分，市政府1分。
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="score103101" class="score-input form-control"
                                                              name="score103101"><c:out
                                                            value="${kpis.score103101}"/></textarea>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-icon right">
                                                    <i class="fa"></i>
                                                    <textarea id="desc103101" class="desc-input form-control" name="desc"><c:out
                                                            value="${kpis.desc103101}"/></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" style="overflow: hidden;">
                        <div class="col-md-6">
                            部门附件：
                            <button type="button" class="btn btn-success upload-file" id="bmfj">上传附件</button>
                            <c:if test="${achievements.bmfj != null}">
                                <div class="preview-img-panel">
                                    <c:forEach var="t" items="${achievements.bmfj}">
                                        <div class="preview-file">
                                            <div class="preview-icon"><img src="${pageContext.request.contextPath}/${t.icon}"></div>
                                            <div class="preview-name">${t.fileName}</div>
                                            <div class="fa fa-trash-o delete" id="1512873700254" onclick="deleteAdjunct(this);"></div>
                                            <input type="hidden" name="bmfjName" value="${t.fileName}"><input
                                                type="hidden" name="bmfjPath"
                                                value="${t.filePath}">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                        <div class="col-md-6">

                        </div>
                    </div>

                </form>

                <div class="form-actions" style="text-align: center;">
                    <a href="javascript:;" id="saveBtn" class="btn green"> 保存 </a>
                    <a href="javascript:;" id="submitBtn" class="btn blue"> 提交 </a>
                    <a href="javascript:;" id="backBtn" class="btn default"> 返回 </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/app/js/gov/achievements/gov_achievements_handle.js"></script>

</body>
</html>