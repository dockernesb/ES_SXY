<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<!-- BEGIN GLOBAL MANDATORY STYLES -->
<jsp:include page="/WEB-INF/jsp/common/head.jsp"></jsp:include>
<style type="text/css">
#winEditPwd span.phTips {
    margin-left: 13px !important;
    margin-top: -40px;
}
</style>
<title>公信力</title>
</head>
<!-- BEGIN BODY -->
<!-- DOC: Apply "page-header-fixed-mobile" and "page-footer-fixed-mobile" class to body element to force fixed header or footer in mobile devices -->
<!-- DOC: Apply "page-sidebar-closed" class to the body and "page-sidebar-menu-closed" class to the sidebar menu element to hide the sidebar by default -->
<!-- DOC: Apply "page-sidebar-hide" class to the body to make the sidebar completely hidden on toggle -->
<!-- DOC: Apply "page-sidebar-closed-hide-logo" class to the body element to make the logo hidden on sidebar toggle -->
<!-- DOC: Apply "page-sidebar-fixed" class to the body element to have fixed sidebar -->
<!-- DOC: Apply "page-footer-fixed" class to the body element to have fixed footer -->
<!-- DOC: Apply "page-sidebar-reversed" class to put the sidebar on the right side -->
<!-- DOC: Apply "page-full-width" class to the body element to have full width page without the sidebar menu -->
<body class="page-header-fixed page-quick-sidebar-over-content page-sidebar-closed-hide-logo" onload="openIndex(${userType});">
	<!-- BEGIN HEADER -->
	<div class="page-header navbar navbar-fixed-top">
		<!-- BEGIN HEADER INNER -->
		<div class="page-header-inner">
			<!-- BEGIN LOGO -->
			<div class="page-logo">
				<a href="index.action">
					<img src="${rsa}/admin/layout/img/logo.png" alt="logo" class="logo-default" />
				</a>
				<span id="logoText" class="logoText">公信力</span>
				<div class="menu-toggler sidebar-toggler">
					<!-- DOC: Remove the above "hide" to enable the sidebar toggler button on header -->
				</div>
			</div>
			<!-- END LOGO -->
			<!-- BEGIN RESPONSIVE MENU TOGGLER -->
			<a href="javascript:;" class="menu-toggler responsive-toggler" data-toggle="collapse" data-target=".navbar-collapse"> </a>
			<!-- END RESPONSIVE MENU TOGGLER -->
			<!-- BEGIN TOP NAVIGATION MENU -->
			<div class="top-menu">
				<ul class="nav navbar-nav pull-right">
					<!-- BEGIN INBOX DROPDOWN -->
					<li class="dropdown dropdown-extended dropdown-inbox" id="header_inbox_bar">
						<a href="javascript:;" title="主页" onclick="gotoHome();" style="width: 41.25px;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
							<i class="icon-home"></i>
						</a>
					</li>
					<!-- DOC: Apply "dropdown-dark" class after below "dropdown-extended" to change the dropdown styte -->
					<li class="dropdown dropdown-extended dropdown-inbox" id="header_inbox_bar">
						<a href="javascript:;" onclick="showMessage();" title="系统消息" style="width: 41.25px;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
							<i class="icon-envelope"></i>
							<span class="badge badge-default" id="msgLabel"></span>
						</a>
					</li>
					<!-- END INBOX DROPDOWN -->
					<!-- BEGIN USER LOGIN DROPDOWN -->
					<!-- DOC: Apply "dropdown-dark" class after below "dropdown-extended" to change the dropdown styte -->
					<li class="dropdown dropdown-user">
						<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
							<img alt="" class="img-circle userPhoto" id="userPhotoImg" /> <span class="username username-hide-on-mobile">
								${SESSION_USERNAME } </span> <i class="fa fa-angle-down"></i>
						</a>
						<ul class="dropdown-menu dropdown-menu-default">
							<li>&nbsp;</li>
							<%-- <c:if test="${userType == 2 or userType == 3}"> --%>
							<li>
								<a href="javascript:void(0);" onclick="openSelfCenter();">
									<i class="icon-user"></i> 个人中心
								</a>
							</li>
							<li>
                                <a href="javascript:void(0);" onclick="openSkin();">
                                    <i class="icon-heart"></i> 主题管理
                                </a>
                            </li>
							<%-- </c:if> --%>
							<li class="divider"></li>
							<li>
								<a href="javascript:void(0);" onclick="editPwd();">
									<i class="icon-lock"></i> 修改密码
								</a>
							</li>
							<li>
								<a href="javascript:void(0);" title="退出登录" onclick="logOut();">
									<i class="icon-power"></i> 退出登录
								</a>
							</li>
						</ul>
					</li>
					<!-- END USER LOGIN DROPDOWN -->
				</ul>
			</div>
			<!-- END TOP NAVIGATION MENU -->
		</div>
		<!-- END HEADER INNER -->
	</div>
	<!-- END HEADER -->
	<div class="clearfix"></div>
	<!-- BEGIN CONTAINER -->
	<div class="page-container">
		<!-- BEGIN SIDEBAR -->
		<div class="page-sidebar-wrapper">
			<!-- DOC: Set data-auto-scroll="false" to disable the sidebar from auto scrolling/focusing -->
			<!-- DOC: Change data-auto-speed="200" to adjust the sub menu slide up/down speed -->
			<div class="page-sidebar navbar-collapse collapse in">
				<!-- BEGIN SIDEBAR MENU -->
				<!-- DOC: Apply "page-sidebar-menu-light" class right after "page-sidebar-menu" to enable light sidebar menu style(without borders) -->
				<!-- DOC: Apply "page-sidebar-menu-hover-submenu" class right after "page-sidebar-menu" to enable hoverable(hover vs accordion) sub menu mode -->
				<!-- DOC: Apply "page-sidebar-menu-closed" class right after "page-sidebar-menu" to collapse("page-sidebar-closed" class must be applied to the body element) the sidebar sub menu mode -->
				<!-- DOC: Set data-auto-scroll="false" to disable the sidebar from auto scrolling/focusing -->
				<!-- DOC: Set data-keep-expand="true" to keep the submenues expanded -->
				<!-- DOC: Set data-auto-speed="200" to adjust the sub menu slide up/down speed -->
				<ul class="page-sidebar-menu" data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200"></ul>
			</div>
		</div>
		<!-- END SIDEBAR -->
		<!-- BEGIN CONTENT -->
		<div class="page-content-wrapper">
			<c:if test="${userType == 2}">
				<!-- 业务端主页默认不设置背景图片 -->
				<div class="page-content">
			</c:if>
			<c:if test="${userType != 2}">
				<div class="page-content wellcome">
			</c:if>
			<!-- BEGIN STYLE CUSTOMIZER -->
			<div class="theme-panel hidden-xs hidden-sm">
				<div class="toggler" style="display: none !important;background:none"></div>
				<div class="toggler-close"></div>
				<div class="theme-options">
					<div class="theme-option theme-colors clearfix">
						<span> 主题皮肤 </span>
						<ul>
							<li class="color-darkblue current tooltips" data-style="darkblue" data-container="body" data-original-title="黑蓝"></li>
							<li class="color-blue tooltips" data-style="blue" data-container="body" data-original-title="蓝色"></li>
							<li class="color-yellow tooltips" data-style="yellow" data-container="body" data-original-title="黄色"></li>
							<li class="color-green tooltips" data-style="green" data-container="body" data-original-title="绿色"></li>
							<li class="color-red tooltips" data-style="red" data-container="body" data-html="true" data-original-title="红色"></li>
							<li class="color-darkblue-slide  tooltips" data-style="darkblue_slide" data-container="body" data-original-title="黑蓝(幻灯片版)"></li>
						</ul>
					</div>
					<div class="theme-option">
						<span> 侧边栏位置 </span> <select class="sidebar-pos-option form-control input-sm">
							<option value="left" selected="selected">左侧</option>
							<option value="right">右侧</option>
						</select>
					</div>
					<div class="theme-option">
						<span> 底部 </span> <select class="page-footer-option form-control input-sm">
							<option value="fixed">固定</option>
							<option value="default" selected="selected">默认</option>
						</select>
					</div>
					<div class="theme-option" style="text-align: center;">
						<button type="button" class="btn blue btn-sm" onclick="saveThemeSkin();">保存设置</button>
					</div>
				</div>
			</div>
			<!-- END STYLE CUSTOMIZER -->
			<!-- <h3 class="page-title"></h3> -->
			<div id="mainContent"></div>
			<div class="clearfix"></div>
		</div>
	</div>
				
	<!-- END CONTENT -->
	</div>
	<!-- END CONTAINER -->
	<!-- BEGIN FOOTER -->
	<div class="page-footer">
		<div class="page-footer-inner">
			<em>2017 &copy; UDATECH - <a href="http://www.citgc.com/" title="江苏未至科技股份有限公司" target="_blank">江苏未至科技股份有限公司</a>
			</em>
		</div>
		<em class="pull-right" style="color: white; padding-right: 25px;">公信力 Version ${version }</em>
		<div class="scroll-to-top">
			<i class="icon-arrow-up"></i>
		</div>
	</div>
	<!-- END FOOTER -->
	<!-- 修改密码 -->
	<div id="winEditPwd" style="display: none; margin: 30px 40px">
		<form id="editPwdForm" method="post" class="form-horizontal">
			<input name="managerId" type="hidden" value="${SESSION_USERID}" />
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						原密码:
					</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input type="password" class="form-control" id="oldPwd" name="oldPwd" placeholder="原密码">
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						新密码:
					</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input type="password" class="form-control" id="newPwd" name="newPwd" placeholder="新密码">
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">
						<span class="required">*</span>
						确认密码:
					</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input type="password" class="form-control" id="surePwd" name="surePwd" placeholder="确认密码">
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<!-- 	系统消息 -->
	<div id="sysMsgDiv" style="display: none; margin: 10px 20px">
		<div id="msgDiv">
			<div class="row">
				<div class="col-md-12">
					<form class="form-inline">
						<button type="button" class="btn btn-success" onclick="conditionSearch1(false);">未读消息</button>
						&nbsp;
						<button type="button" class="btn btn-info" onclick="conditionSearch1(true);">已读消息</button>
						&nbsp;
						<button type="button" class="btn btn-warning" onclick="operMessage(1);">批量已读</button>
					</form>
				</div>
			</div>
			<table class="table table-striped table-hover table-bordered" id="sysMessageTable" style="min-width: 700px;">
				<thead>
					<tr class="heading">
						<th class="table-checkbox">
							<input type="checkbox" class="icheck checkall">
						</th>
						<th style="text-align: center;">状态</th>
						<th style="text-align: center;">标题</th>
						<th style="text-align: center;">发送者</th>
						<th style="text-align: center;">发送时间</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="msgDetail" style="display: none;">
			<div class="box">
				<div class="box-header" style="float: left; padding-bottom: 10px;">
					<h3 class="box-title">消息详情</h3>
					<button type="button" class="btn btn-info" onclick="msgBack();">返回</button>
				</div>
				<!-- /.box-header -->
				<div class="box-body no-padding">
					<table class="table table-bordered">
						<tbody>
							<tr>
								<th style="text-align: right;">发送者：</th>
								<td id="sendUser"></td>
							</tr>
							<tr>
								<th style="text-align: right;">发送时间：</th>
								<td id="sendTime"></td>
							</tr>
							<tr>
								<th style="text-align: right;">消息内容：</th>
								<td id="msgContent"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- /.box-body -->
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/common/foot.jsp"></jsp:include>
	<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.longpolling.js"></script>
	<script type="text/javascript" src="${ctx}/app/js/common/menu.js"></script>
	<script type="text/javascript" src="${ctx}/app/js/common/index.js"></script>
	<script type="text/javascript" src="${ctx}/app/js/common/commonInit.js"></script>
	<script type="text/javascript">
		$(function() {
			// init menu list
			var menus = '${SESSION_MENUS}';
			new AccordionMenu({
				menuArrs : menus
			});

			Metronic.init(); // init metronic core componets
			Layout.init(); // init layout
			Layout.setSidebarMenuActiveLink();// init sidebar click event
			
        	$.post(CONTEXT_PATH + "/system/user/getThemeSkin.action", function (themeSkinData) {
        		Demo.init(themeSkinData); // init demo features
        	}, "json");
        	
			
			// 判断是否显示/隐藏 logo后面的文字（公信力）
			if ($('body').hasClass('page-sidebar-closed')) {
				$('#logoText').hide();
            }else{
            	$('#logoText').show();
            }
		});
		
		//打开皮肤管理
		function openSkin() {
			$("div.toggler").click();
		}
		
		// 系统消息
	    <c:if test="${SUPPORT_POP == '1' || SUPPORT_MESSAGE == '1'}">
		window.setTimeout(function() {
			$.longpolling({
				url : '${pageContext.request.contextPath}/pushServlet',
				timeout : 5 * 60 * 1000,
				cache : false,
				dataType : 'json',
				type : 'GET',
				success : function(data) {
					var list = data.list;
					if (list != null) {
						$.each(list, function(i, msg) {
							if (msg.type == 'SYS') {
								var countType = msg.param.countType;
								
								if ('${SUPPORT_POP}' == '1') {
									if (countType == "ADD") {
										// 右下角弹出
										layer.open({
											type : 1,
											offset : 'rb',
											title: msg.message,
											content : msg.param.message,
											skin:'',
											btn : '关闭',
											btnAlign : 'r',
											shade : 0,
											time:5000,// 5秒后自动关闭
											yes : function(index) {
												layer.close(index);
											}
										});
									}
								}
								if ('${SUPPORT_MESSAGE}' == '1') {
									var readNum = msg.param.readNum;
									var messageSumCount = parseInt(isNull($("#msgLabel").html()) ? '0' : $("#msgLabel").html());
									if (countType == "DEL") {
										if (messageSumCount < 1) {
											$("#msgLabel").html('');
										} else {
											var messageCount = messageSumCount - readNum;
											if (messageCount < 1) {
												$("#msgLabel").html('');
											} else {
												$("#msgLabel").html(messageCount);
											}
										}
									} else {
										var messageSumCount = parseInt(isNull($("#msgLabel").html()) ? '0' : $("#msgLabel").html());
										$("#msgLabel").html(messageSumCount+1);
									}
								}
							}
						});
					}
				},
			});
		}, 3000); 
		</c:if>
	</script>
</body>
</html>