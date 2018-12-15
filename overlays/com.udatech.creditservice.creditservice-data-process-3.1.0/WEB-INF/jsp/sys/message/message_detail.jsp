<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    pageContext.setAttribute("basePath", basePath);
%>
<html>
<head><link href="<%=basePath %>app/images/favicon.ico" rel="shortcut icon" type="image/x-icon" media="screen" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统消息</title>
    <jsp:include page="/WEB-INF/jsp/common/common.jsp"></jsp:include>
    <!-- 嵌入式样式 -->
    <style type="text/css">
        .tdLabel{align:left; nowrap; width:80px;}
        .tdValue{align:left; nowrap; colspan:5;}
        .tdArea{align:left; colspan:5;}
    </style>
    <script type="text/javascript">
    $(function(){
    	 self.opener.reloadtree();
    })
    </script>
</head>
<body class="overflowH bodyBGgray">
<div class="container">
			<div class="containBox">
				<div class="positionBox">
					<div class="floatL"> 系统消息</div>
					<div class="floatR">&nbsp;</div>
				</div>
		<div class="menuThrBox" style="padding-bottom:5px;">
			<div class="whiteBox">
				<div class="whiteBoxIn">
				<div class="searchBox">
			<table width="100%" border="0" cellspacing="10" cellpadding="0" style="margin-top:5px;">
								<tr>
									<td align="left" nowrap width="1%">
										<button class="btn btn-warning btn-mini" onclick = "go_back();">返回消息</button>
									</td>
								</tr>
							</table>
							</div>
					<div> 
						<div class="grayBox1">
							<div class="grayBox1Con">
								<div class="formHead">
									<table width="100%" border="0" cellspacing="10" cellpadding="0">
										<tr>
											<th align="left" colspan="3">${message.title }</th>
										</tr>
										<tr>
											<td align="left" nowrap width="30%">发送人：${message.sendName }<br/>时间：<fmt:formatDate value="${message.sendDate }" type="both"/></td>
										</tr>
									</table>
								</div>
								<div style="border-radius:5px; behavior: url(../app/css/common/PIE.htc); position:relative; border:1px solid #e4e4e4; padding:25px 10px; background:#fefefe;">
									<p>${message.content }</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

</body>

<script type="text/javascript">
	function go_back(){
		window.location.href="<%=basePath%>system/message/message.action";
	}
</script>
</html>