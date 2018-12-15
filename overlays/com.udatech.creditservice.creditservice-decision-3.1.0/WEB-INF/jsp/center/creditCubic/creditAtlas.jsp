<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${isOpen eq '1'}">
   <jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
</c:if>
<link rel="stylesheet" href="${rsa}/global/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditCubic/creditCubic.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditMap/creditMap.css" />
<title>信用图谱</title>
<style>
span.phTips {
	margin-left: 13px !important;
	margin-top: -35px;
}
</style>
</head>
<body <c:if test="${isOpen eq '1'}">style="background:#fff" class="extraBox"</c:if>>
    	<div class="portlet box" id="portlet">
        	<!-- 搜索开始-->
			<div class="row">
			<div class="form-group">
				<div class="col-md-10 col-sm-10" style="padding-left:180px">
						<div class="input-icon right">
							<i class="fa fa-search" title="查询企业信息" id="fasearch" style="width: 50px; color: #428BCA;">&nbsp;搜索</i>
							<input class="form-control" id="search-text" name="keyWord" style="padding-right: 63px;" placeholder="请输入主体名称/法人代表/统一社会信用代码" />
						</div>
					</div>
            	</div>
            	</div>
            </div>
       
        <!-- 搜索结束 -->
        <div class="tabs-scroller tabs-scroller-left" style="display: none; height: 28px;<c:if test="${isOpen eq '1'}">left:0px;top:114px</c:if>" onclick="creditAtlas.scrollTabs(1)"></div>
		<div class="tabs-scroller tabs-scroller-right" style="display: none; height: 28px;<c:if test="${isOpen eq '1'}">top:114px</c:if>" onclick="creditAtlas.scrollTabs(2)"></div>
                              
        <!-- Tab开始 -->
        <div class="portlet box tabbable" id="tabbable" style="position:relative;display:none">
						          <div class="tabbable-custom" id="tabs" >
									<ul class="nav nav-tabs">
									</ul>
									<div class="tab-content">
								</div>


				</div>
			    <div class="Legend">
				    <label for="gd"><input type="checkbox" name="legend" id="gd" value="gd" checked onclick="creditAtlas.showhideTree(this)"/>股东信息</label>
				    <label for="tz"><input type="checkbox" name="legend" id="tz" value="tz" checked onclick="creditAtlas.showhideTree(this)"/>对外投资</label>
				    <label for="gg"><input type="checkbox" name="legend" id="gg" value="gg" checked onclick="creditAtlas.showhideTree(this)"/>高管信息</label>
				    <label for="fy"><input type="checkbox" name="legend" id="fy" value="fy" checked onclick="creditAtlas.showhideTree(this)"/>法院判决</label>
				    <label for="fz"><input type="checkbox" name="legend" id="fz" value="fz" checked onclick="creditAtlas.showhideTree(this)"/>分支机构</label>
			    </div>
			    
				<div class="level_box">
			        <div class="form-inline">
					    <span class="mao-select-wrap">对外投资层级 &nbsp;
					        <select id="touziSelect" class="form-control input-md" onchange="creditAtlas.selectChange(this,1)">
					            <c:choose>
					                <c:when test="${level == 6}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
								         <option value="4">四层</option>
								         <option value="5">五层</option>
								         <option value="6">六层</option>
					                </c:when>
					                <c:when test="${level == 5}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
								         <option value="4">四层</option>
								         <option value="5">五层</option>
					                </c:when>
					                <c:when test="${level == 4}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
								         <option value="4">四层</option>
					                </c:when>
					                <c:when test="${level == 3}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
					                </c:when>
					                <c:when test="${level == 2}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
					                </c:when>
					                <c:otherwise>
					                     <option value="1">一层</option>
					                </c:otherwise>
					            </c:choose>
						    </select>
						</span> 
						<span class="mao-select-wrap">股东层级&nbsp;
						    <select  id="gudongSelect" class="form-control input-md" onchange="creditAtlas.selectChange(this,2)">
							    <c:choose>
							     	<c:when test="${level == 6}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
								         <option value="4">四层</option>
								         <option value="5">五层</option>
								         <option value="6">六层</option>
					                </c:when>
					                <c:when test="${level == 5}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
								         <option value="4">四层</option>
								         <option value="5">五层</option>
					                </c:when>
					                <c:when test="${level == 4}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
								         <option value="4">四层</option>
					                </c:when>
					                <c:when test="${level == 3}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
								         <option value="3">三层</option>
					                </c:when>
					                <c:when test="${level == 2}">
						                 <option value="1">一层</option>
								         <option value="2">二层</option>
					                </c:when>
					                <c:otherwise>
					                     <option value="1">一层</option>
					                </c:otherwise>
					            </c:choose>
						    </select>
						</span>&nbsp;
						<span>
						    <a href="javascript:;" class="btn btn-info btn-md" onclick="creditAtlas.exportImage()">导出</a>
						</span>
				    </div>
			    </div>
			    <div id="floatWin" class="floatWin" ></div>
				<div id="floatFyWin" class="floatWin"></div>
				</div>
				 
		<!-- Tab结束 -->
		<!-- <div class="defaultBg" id="defaultBg"></div> -->
		<img id="defaultBg" style="display:block" src="${pageContext.request.contextPath}/app/images/creditCubic/atlasbg.jpg" width="100%" >
	<script type="text/javascript">
        var qyid = '${qyid}';
        var isOpen = '${isOpen}';
        
    </script>
	<c:if test="${isOpen eq '1'}">
       <jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
    </c:if>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/d3/d3.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditCubic/creditAtlas.js"></script> 
</html>