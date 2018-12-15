<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
<link href="${ctx }/app/login/login.css" rel="stylesheet"
	type="text/css" />
<title>苏州市信用信息共享平台</title>
<style>
h3.form-title b{padding-right:15px;font-weight:normal;}
h3.form-title a{color:#eee;font-size:17px;position:relative;top:1px;padding-left:15px;border-left:1px dotted #eee;}
h3.form-title a:hover{text-decoration:none; color:#fff;}
</style>
</head>
<body class="login">
	<!-- BEGIN LOGO -->
	<div class="logo">
		<span style="color: white; font-size: 28px;">苏州市信用信息共享平台</span>
	</div>
	<!-- END LOGO -->

	<!-- BEGIN SIDEBAR TOGGLER BUTTON -->
	<div class="menu-toggler sidebar-toggler"></div>
	<!-- END SIDEBAR TOGGLER BUTTON -->

	<div class="content">
		<!-- BEGIN LOGIN FORM -->
		<form action="${ctx}/loginCa.action" class="login-form" method="post"
			id="loginForm">
			<input type="hidden" id="UserSignedData" name="UserSignedData" /> <input
				type="hidden" id="RandomString" name="RandomString"
				value="${RandomString}" /> <input type="hidden" id="UserCert"
				name="UserCert" />
			<!-- <h3 class="form-title">请登录</h3> -->
			<h3 class="form-title"><b>CA登录</b><a href="${ctx}/login.action">账号登录</a></h3>			
			<c:if test="${ not empty message }">
				<div class="alert alert-danger display-hide">
					<button class="close" data-close="alert"></button>
					<span> ${message} </span>
				</div>
			</c:if>
			<div class="form-group">
				<!--ie8, ie9 does not support html5 placeholder, so we just show field title for that-->
				<label class="control-label visible-ie8 visible-ie9">账号</label>
				<div class="input-icon">
					<i class="fa fa-user"></i> <select
						class="form-control placeholder-no-fix" placeholder="账号"
						name="username" id="username"></select>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label visible-ie8 visible-ie9">密码</label>
				<div class="input-icon">
					<i class="fa fa-lock"></i> <input
						class="form-control placeholder-no-fix" type="password"
						autocomplete="off" placeholder="密码" name="password" id="password" />
				</div>
			</div>
			<div class="form-actions">
				<button type="button" class="btn blue pull-right"
					onclick="LoginCa.submitForm();">
					登录 <i class="m-icon-swapright m-icon-white"></i>
				</button>
			</div>
			<br>
			<div class="create-account">
				<div class="copyright" style="padding: 0px;">
					2017 &copy; UDATECH - <a href="http://www.citgc.com/"
						style="color: white;" title="未至科技" target="_blank">江苏未至科技股份有限公司</a>
				</div>
			</div>
		</form>
		<!-- END LOGIN FORM -->
	</div>
	<!-- END LOGIN -->

	<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
	<script type="text/javascript"
		src="${ctx}/app/js/common/SecX_Common.js"></script>
	<script type="text/javascript"
		src="${ctx}/$_staticResource_$/global/plugins/backstretch/jquery.backstretch.min.js"></script>
	<script type="text/javascript" src="${ctx}/app/login/login_ca.js"></script>

	<script>
		var strServerSignedData = "${strServerSignedData}";
		var strServerRan = "${strServerRan}";
		var strServerCert = "${strServerCert}";

		$(function() {
			Metronic.init(); // init metronic core components
			Layout.init(); // init current layout
			LoginCa.init();
			Demo.init();
			// init background slide images
			$.backstretch([ "${ctx}/app/login/img/bg/1.jpg",
					"${ctx}/app/login/img/bg/2.jpg",
					"${ctx}/app/login/img/bg/3.jpg",
					"${ctx}/app/login/img/bg/4.jpg" ], {
				fade : 500,
				duration : 15000
			});
			$("#password").focus();
		});

		var message = '${message}';

		if (message != '') {
			$('.alert-danger span').html(message);
			$('.alert-danger').show();
		}

		GetList("loginForm.username");
	</script>
</body>
</html>