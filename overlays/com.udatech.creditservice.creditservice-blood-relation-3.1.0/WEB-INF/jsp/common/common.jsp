<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ page language="java" pageEncoding="UTF-8"%>
<link rel="icon" href="${pageContext.request.contextPath}/app/images/favicon.ico"> 
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico">
<link rel="stylesheet" href="${pageContext.request.contextPath}/app/css/common/style.css"  type="text/css" />
<link rel="stylesheet" href="${rsa}/global/plugins/bootstrap/datagrid/bootstrap.min.css" />
<link rel="stylesheet" href="${rsa}/global/plugins/bootstrap/datagrid/bootstrap-responsive.min.css" />
<link rel="stylesheet" href="${rsa}/global/plugins/uniform-2.1.2/themes/default/css/uniform.default.min.css" />

<script type="text/javascript">
  var CIP_PATH = '${pageContext.request.contextPath}';
  </script>

<script src="${rsa}/global/plugins/jquery-easyui-1.4/jquery.min.js" type="text/javascript" ></script>


<%
	String contextPath = request.getContextPath();
 %>
<!--[if lt IE 9]>
    <script src="${pageContext.request.contextPath}/js/json2.js" type="text/javascript" ></script>
<![endif]-->

<%
    String common1 = request.getParameter("common");
    if ("true".equals(common1)) {
%>
<script src="${rsa}/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript" ></script>
<script src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.js" type="text/javascript" ></script>
<script src="${rsa}/global/plugins/bootstrap/js/bootstrap-datepicker.zh-CN.min.js" type="text/javascript" ></script>
<%-- <script src="${pageContext.request.contextPath}/thirdParty/bootstrap/plugin/datepicker/config.js" type="text/javascript" ></script> --%>
<script src="${pageContext.request.contextPath}/app/js/datagrid/dataGridFormat.js" type="text/javascript" ></script>
<script src="${pageContext.request.contextPath}/app/js/common/common.js?ff3" type="text/javascript" ></script>
<script src="${rsa}/global/plugins/uniform-2.1.2/jquery.uniform.min.js" type="text/javascript" ></script>
<%
    }
%>

<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/jquery-easyui-1.4/themes/custom/easyui.css">
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/jquery-easyui-1.4/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${rsa}/global/plugins/jquery-easyui-1.4/themes/color.css">

<script type="text/javascript" src="${rsa}/global/plugins/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/jquery-easyui-1.4/jquery.easyui.fixRownum.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 

<%
    String common2 = request.getParameter("common");
    if ("true".equals(common2)) {
%>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/remoteeasyui.js"></script> 
<link rel="stylesheet" href="${rsa}/global/plugins/select2/datagrid/select2.css?v=3.4" type="text/css" />
<link rel="stylesheet" href="${rsa}/global/plugins/select2/datagrid/select2-extra.css" type="text/css" />
<script type="text/javascript" src="${rsa}/global/plugins/select2/datagrid/select2.js?v=3.4"></script>
<script type="text/javascript" src="${rsa}/global/plugins/multifile/jquery.MetaData.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/multifile/jQuery.MultiFile.min.js"></script>
<%
    }
%>

<%
    String export = request.getParameter("export");
    if ("true".equals(export)) {
%>
<script type="text/javascript" src="<%=contextPath%>/global/plugins/export/json2.js" ></script>
<%
    }
%>

<%
    String owindow = request.getParameter("owindow");
    if ("true".equals(owindow)) {
%>
   <script type="text/javascript" src="<%=contextPath%>/app/js/common/window.js"></script>
<%
    }
%>

<%
    String datagrid = request.getParameter("datagrid");
    if ("true".equals(datagrid)) {
%>
	<link rel="stylesheet" href="<%=contextPath%>/app/css/datagrid/toolForm.css"  type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/app/js/datagrid/dataGridConfig.js?ff"></script>
	<script type="text/javascript" src="<%=contextPath%>/app/js/datagrid/dataGridFormat.js?ff"></script>
<%
    }
%>

<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/extandsEasyUiValidate.js"></script>
<script src="${pageContext.request.contextPath}/app/js/common/filterIllegal.js" type="text/javascript" ></script>

<!-- 用于代码自动生成框架 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/base.js?sdfs"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/datagrid/template.form.js?sdfs"></script>

<%
    String bootChange = request.getParameter("bootChange");
    if (!"false".equals(bootChange)) {
%>
<link rel="stylesheet" href="<%=contextPath%>/app/css/datagrid/bootChange.css"  type="text/css" />
<%
    }
%>
<link rel="stylesheet" href="<%=contextPath%>/app/css/datagrid/easyChange.css"  type="text/css" />
