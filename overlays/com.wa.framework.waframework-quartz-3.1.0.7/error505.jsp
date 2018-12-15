<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="${pageContext.request.contextPath}/app/images/favicon.ico"> 
<link rel="shortcut icon" href="${pageContext.request.contextPath}/app/images/favicon.ico">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/app/css/datagrid/authStyle.css" />
<script type="text/javascript">

</script>
</head>
<body class="errorBody">
<%-- <div class="errorBox">
			<div class="errorInBox">
						<table border="0" cellspacing="0" cellpadding="0" class="mar0A">
							<tr>
								<th align="left" width="160" rowspan="2" valign="top" style="padding-right:65px;"><img src="images/errorPic.png" alt="sorry"/></th>
								<th align="left" valign="middle" width="*" class="errorText1">
								  该用户没有任何权限，无法登录，请联系管理员！
								</th>
							</tr>
							<tr>
								<td colspan="2" align="left" class="errorText2">
								<a href="${pageContext.request.contextPath}/logout"
                class="topRicon" id="topRexit"></a><br>
									<!-- <a href="#">返回上一页面  >></a><br>
									<a href="#">返回系统首页  >></a> -->
								</td>
							</tr> 
						</table>
					</div>

</div> --%>
<div class="errorBox">
					<div class="errorInBox">
						<table border="0" cellspacing="0" cellpadding="0" class="mar0A">
							<tr>
								<th align="left" width="160" rowspan="2" style="padding-right:65px;"><img src="${pageContext.request.contextPath}/app/images/errorPic.png" alt="sorry"/></th>
								<th align="left" valign="middle" width="*" class="errorTit">
								   <div class="errorNum">
									<span class="errorFontL">5</span>
									<span class="errorFontC">0</span>
									<span class="errorFontR">0</span>
								   </div>
								</th>
							</tr>
							<tr>
								<td align="center" width="*" class="errorText1">服务器出现内部500错误</td>
							</tr>
							<tr>
								<td colspan="2" align="left" class="errorText2">友情提示:<br>
									1. 如果是web服务器繁忙，请稍后再访问；<br>
									2. 如果是web服务器错误页面被缓存，请按"ctrl"+"f5"刷新页面，<br>
									&nbsp;&nbsp;&nbsp;&nbsp;如果还是报错，请清除缓存后再重新访问；<br>
									3. 如果是浏览器兼容问题，请选用主流浏览器，如chorme、火狐或新版IE;<br>
									4. 如果以上方法都不能解决，请联系技术人员。<!-- <br>
									<a href="#">返回上一页面  >></a><br>
									<a href="#">返回系统首页  >></a> -->
								</td>
							</tr>
						</table>
					</div>
				</div>
</body>
</html>