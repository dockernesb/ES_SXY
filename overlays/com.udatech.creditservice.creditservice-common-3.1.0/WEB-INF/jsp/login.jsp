<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
<link href="${ctx }/app/login/login.css" rel="stylesheet" type="text/css" />
<title>公信力</title>
</head>
<body class="login">
	<!-- BEGIN LOGO -->
	<div class="logo">
		<a href="http://www.citgc.com/" title="未至科技" target="_Blank" style="position: relative; top: -5px;">
			<img src="${ctx}/app/login/img/login.png" style="height: 27px;" alt="未至科技">
		</a>
		<span style="color: white; font-size: 28px;">公信力</span>
	</div>
	<!-- END LOGO -->

	<!-- BEGIN SIDEBAR TOGGLER BUTTON -->
	<div class="menu-toggler sidebar-toggler"></div>
	<!-- END SIDEBAR TOGGLER BUTTON -->

	<div class="content">
		<!-- BEGIN LOGIN FORM -->
		<form action="${ctx}/login.action" class="login-form" method="post" id="loginForm">
			<h3 class="form-title">请登录</h3>
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
					<i class="fa fa-user"></i>
					<input class="form-control placeholder-no-fix" type="text" autocomplete="off" placeholder="账号" name="username" id="username" />
				</div>
			</div>
			<div class="form-group">
				<label class="control-label visible-ie8 visible-ie9">密码</label>
				<div class="input-icon">
					<i class="fa fa-lock"></i>
					<input class="form-control placeholder-no-fix" type="password" autocomplete="off" placeholder="密码" name="password" id="password" />
				</div>
			</div>
			<div class="form-group">
				<label class="control-label visible-ie8 visible-ie9">验证码</label>
				<div class="input-group" style="width: 100%;">
					<div class="input-icon">
						<i class="glyphicon glyphicon-barcode"></i>
						<input name="captcha" id="verCode" type="text" class="form-control placeholder-no-fix" style="width: 68.5%; display: block;" placeholder="验证码"
							maxlength="4" />
						<span class="input-group-addon" style="padding: 0px; margin: 0px; width: 31.5%; display: block; float: left;">
						<%-- <img id="vercodeImg" src="${ctx}/verCode.jsp" height="32px" onclick="this.src='${ctx}/verCode.jsp?d='+new Date()" title="点击更换验证码" /> --%>
						<img id="vercodeImg" src="${ctx}/captcha.jpg" onclick="this.src = '${ctx}/captcha.jpg?' + Math.random();"  height="32px" alt="验证码" title="点击更换验证码"/>
						</span>
						
					</div>
				</div>
			</div>
			<div class="form-actions">
				<button type="button" class="btn blue pull-right" onclick="Login.submitForm();">
					登录 <i class="m-icon-swapright m-icon-white"></i>
				</button>
			</div>
			<br>
			<div class="create-account">
				<div class="copyright" style="padding: 0px;">2017 &copy; UDATECH - <a href="http://www.citgc.com/" style="color: white;" title="未至科技" target="_blank">江苏未至科技股份有限公司</a></div>
			</div>
		</form>
		<!-- END LOGIN FORM -->
	</div>
	<!-- END LOGIN -->

	<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
	<script type="text/javascript" src="${rsa}/global/plugins/backstretch/jquery.backstretch.min.js"></script>
	<script type="text/javascript" src="${ctx}/app/login/login.js"></script>

	<script>
		$(function() {
			Metronic.init(); // init metronic core components
			Layout.init(); // init current layout
			Login.init();
			Demo.init();
			// init background slide images
			$.backstretch([ "${ctx}/app/login/img/bg/1.jpg", "${ctx}/app/login/img/bg/2.jpg", "${ctx}/app/login/img/bg/3.jpg", "${ctx}/app/login/img/bg/4.jpg" ], {
				fade : 500,
				duration : 15000
			});
			$("#username").focus();
		});
		
		var message = '${message}';
		
		if(message != ''){
			$('.alert-danger span').html(message);
			$('.alert-danger').show();
			$('#vercodeImg').click();
		}
	</script>
</body>
</html>