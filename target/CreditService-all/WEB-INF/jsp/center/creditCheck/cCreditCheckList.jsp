<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>信用审查审核</title>
</head>
<body>
	<input type="hidden" id="bmlx" value="${bmlx}" />
	<input type="hidden" id="type" value="${type}" />

	<div id="topBox">
		<div id="cCreditCheckExamineList">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-list"></i>
                        <c:if test="${type == 1}">
                            法人信用审查审核
                        </c:if>
                        <c:if test="${type == 2}">
                            法人信用审查查询
                        </c:if>
					</div>
					<div class="tools" style="padding-left: 5px;">
						<a href="javascript:void(0);" class="collapse"></a>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<div class="col-md-12">
								<form class="form-inline" id="applyListForm">
									<div class="row">
										<input id="bjbh" class="form-control input-md form-search" placeholder="办件编号" />
										&nbsp;
										<input id="scmc" class="form-control input-md form-search" placeholder="审查名称"/>

                                        <c:if test="${type == 2}">
                                            &nbsp;
                                            <select id="examineList_status" class="form-control input-md form-search">
                                            <option value="">全部状态</option>
                                            <option value="0">待审核</option>
                                            <option value="1">未通过</option>
                                            <option value="2">已通过</option>
                                            </select>
                                        </c:if>

										&nbsp;
										<select class="form-control input-md form-search" id="xqbm" style="width: 12%;"></select>
										&nbsp;
                                        <c:if test="${bmlx == 0}">
                                            <select id="deptId" class="form-control input-md form-search"
                                                    style="width: 179px;">
                                                <option value="">办件部门</option>
                                            </select>
                                            &nbsp;
                                        </c:if>
										<input id="sqsjs" class="form-control input-md form-search date-icon" placeholder="申请时间始" readonly="readonly">
										&nbsp;
										<input id="sqsjz" class="form-control input-md form-search date-icon" placeholder="申请时间止" readonly="readonly">
										&nbsp;
										<button type="button" class="btn btn-info btn-md form-search" onclick="cCreditCheckList.conditionSearch();">
											<i class="fa fa-search"></i> 查询
										</button>
										&nbsp;
										<button type="button" class="btn btn-default btn-md form-search" onclick="cCreditCheckList.conditionReset();">
											<i class="fa fa-rotate-left"></i> 重置
										</button>
									</div>
								</form>
								<div class="row">
									<table class="table table-striped table-hover table-bordered" id="applyListGrid" style="width: 100%">
										<thead>
											<tr class="heading">
												<th>办件编号</th>
                                                <th>办件部门</th>
												<th>审查名称</th>
												<th>审查部门</th>
												<th>审查类别</th>
												<th>申请时间</th>
												<th>状态</th>
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

			<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditCheck/cCreditCheckList.js"></script>
			<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
		</div>
		<div id="cCreditCheckExamineDetail" style="display:none"></div>
	</div>
</body>
</html>