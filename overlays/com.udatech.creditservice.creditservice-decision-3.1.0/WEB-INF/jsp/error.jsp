<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/common.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/app/css/datagrid/authStyle.css" />
<title>集中认证管理系统</title>
<script type="text/javascript">
    $(function() {
        if(window.parent != window){
            $("#backToMainPage").hide();
        }
    })
    function backToMainPage(){
        window.location = "${ctx}/index.action";
    }
</script>
</head>
<body class="bodyError">
    <div class="errorBox">
        <div class="errorInBox">
            <table border="0" cellspacing="0" cellpadding="0" class="mar0A">
                <tr>
                    <th align="left" width="160" rowspan="2" style="padding-right: 65px;"><img src="${ctx}/app/images/errorPic.png" alt="sorry" /></th>
                    <th align="left" valign="middle" width="*">
                        <div class="errorTit2">${errorInfo}</div>
                    </th>
                </tr>
                <tr>
                    <td align="center" width="*" class="errorText2"><a href="javascript:history.back();">返回上一页面 >></a>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:backToMainPage();" id="backToMainPage">返回系统首页 >></a></td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>