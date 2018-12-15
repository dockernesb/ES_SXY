<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/common/dataProcessLog.css"/>
    <title>数据处理日志</title>
</head>
<body style="background-color: #fff; width: 100%; overflow-x: hidden">
<input type="hidden" name="taskCode" id="taskCode" value="${dataProcessLogVo.taskCode}">
<div class="page-content-wrapper">
    <div class="page-content">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <div class="profile-sidebar">
                    <div class="row list-separated profile-stat">
                        <div class="col-md-3 col-sm-3 col-xs-6">
                            <div class="uppercase profile-stat-text">
                                上报批次编号
                            </div>
                            <div class="uppercase profile-stat-title">
                                ${dataProcessLogVo.taskCode}
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-3 col-xs-6">
                            <div class="uppercase profile-stat-text">
                                上报方式
                            </div>
                            <div class="uppercase profile-stat-title">
                                ${dataProcessLogVo.reportWay}
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-3 col-xs-6">
                            <div class="uppercase profile-stat-text">
                                上报部门
                            </div>
                            <div class="uppercase profile-stat-title">
                                ${dataProcessLogVo.deptName}
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-3 col-xs-6">
                            <div class="uppercase profile-stat-text">
                                目录名称
                            </div>
                            <div class="uppercase profile-stat-title">
                                ${dataProcessLogVo.tableName}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 处理日志时间轴--%>
        <div class="timeline">
            <div class="timeline-item">
                <div class="timeline-badge">
                    <div class="timeline-icon">
                        <i class="glyphicon glyphicon-file"></i>
                    </div>
                </div>
                <div class="timeline-body">
                    <div class="timeline-body-arrow">
                    </div>
                    <c:if test="${not empty dataProcessLogVo.dataReportTime}">
                        <div class="timeline-body-head">
                            <div class="timeline-body-head-caption">
                                <span class="timeline-body-alerttitle font-blue-madison">数据上报</span>
                                <span class="timeline-body-time font-grey-cascade">&nbsp;${dataProcessLogVo.dataReportTime}</span>
                            </div>
                        </div>
                        <div class="timeline-body-content">
                            <span class="font-grey-cascade">
                                <p>　数据上报开始　${dataProcessLogVo.dataReportStartTime} </p>
                                <p>　数据上报结束　${dataProcessLogVo.dataReportEndTime} </p>
                                <p>　数据上报通过记录数：${dataProcessLogVo.dataReportSuccessCnt} 条　　数据上报疑问记录数：${dataProcessLogVo.dataReportFailCnt} 条
                                    <button type="button" class="btn blue-hoki btn-xs" onclick="exportErrorData();">导出
                                    </button>
                                </p>

                            </span>
                        </div>
                    </c:if>
                    <c:if test="${empty dataProcessLogVo.dataReportTime}">
                        <div class="timeline-body-head">
                            <div class="timeline-body-head-caption">
                                <span class="timeline-body-alerttitle font-blue-madison">数据上报</span>
                                <span class="timeline-body-time font-grey-cascade">&nbsp;未开始</span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-badge">
                    <div class="timeline-icon">
                        <i class="glyphicon glyphicon-retweet"></i>
                    </div>
                </div>
                <div class="timeline-body">
                    <div class="timeline-body-arrow">
                    </div>
                    <c:if test="${not empty dataProcessLogVo.ruleCheckTime}">
                        <div class="timeline-body-head">
                            <div class="timeline-body-head-caption">
                                <span class="timeline-body-alerttitle font-blue-madison">规则校验</span>
                                <span class="timeline-body-time font-grey-cascade">&nbsp;${dataProcessLogVo.ruleCheckTime}</span>
                            </div>
                        </div>
                        <div class="timeline-body-content">
                            <span class="font-grey-cascade">
                                <p>　规则校验开始　${dataProcessLogVo.ruleCheckStartTime} </p>
                                <p>　规则校验结束　${dataProcessLogVo.ruleCheckEndTime}　　耗时：${dataProcessLogVo.ruleCheckTookTime} </p>
                                <p><%--　规则校验入库记录数：${dataProcessLogVo.ruleCheckSuccessCnt} 条　--%>　规则校验更新记录数：${dataProcessLogVo.ruleCheckUpdateCnt} 条　　规则校验疑问记录数：${dataProcessLogVo.ruleCheckFailCnt} 条 </p>
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${empty dataProcessLogVo.ruleCheckTime}">
                        <div class="timeline-body-head">
                            <div class="timeline-body-head-caption">
                                <span class="timeline-body-alerttitle font-blue-madison">规则校验</span>
                                <span class="timeline-body-time font-grey-cascade">&nbsp;未开始</span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-badge">
                    <div class="timeline-icon">
                        <i class="glyphicon glyphicon-link"></i>
                    </div>
                </div>
                <div class="timeline-body">
                    <div class="timeline-body-arrow">
                    </div>
                    <c:if test="${not empty dataProcessLogVo.relationTime}">
                        <div class="timeline-body-head">
                            <div class="timeline-body-head-caption">
                                <span class="timeline-body-alerttitle font-blue-madison">关联入库</span>
                                <span class="timeline-body-time font-grey-cascade">&nbsp;${dataProcessLogVo.relationTime}</span>
                            </div>
                        </div>
                        <div class="timeline-body-content">
                            <span class="font-grey-cascade">
                                <p>　关联比对开始　${dataProcessLogVo.relationStartTime} </p>
                                <p>　关联比对结束　${dataProcessLogVo.relationEndTime} </p>
                                <c:if test="${empty dataProcessLogVo.relationFailCnt}">
                                    <p>　关联对比入库记录数：${dataProcessLogVo.relationSuccessCnt} 条<%--　　关联对比更新记录数：${dataProcessLogVo.relationUpdateCnt}--%></p>
                                </c:if>
                                <c:if test="${not empty dataProcessLogVo.relationFailCnt}">
                                    <p>　关联对比入库记录数：${dataProcessLogVo.relationSuccessCnt} 条<%--　　关联对比更新记录数：${dataProcessLogVo.relationUpdateCnt}--%>　　关联对比未关联记录数：${dataProcessLogVo.relationFailCnt} 条
                                        <button type="button" class="btn blue-hoki btn-xs" onclick="exportNoRelatedData();">导出</button>
                                    </p>

                                </c:if>
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${empty dataProcessLogVo.relationTime}">
                        <div class="timeline-body-head">
                            <div class="timeline-body-head-caption">
                                <span class="timeline-body-alerttitle font-blue-madison">关联入库</span>
                                <span class="timeline-body-time font-grey-cascade">&nbsp;未开始</span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<script type="text/javascript">
    // 导出疑问数据
    function exportErrorData() {
        var taskCode = $('#taskCode').val();
        document.location = ctx + "/dp/historyDataReport/exportData.action?taskCode=" + taskCode;
    }
    // 导出未关联数据
    function exportNoRelatedData() {
        var taskCode = $('#taskCode').val();
        document.location = ctx + "/dp/task/exportData.action?taskCode=" + taskCode;
    }
</script>
</body>
</html>