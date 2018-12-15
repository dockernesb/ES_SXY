<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/app/images/favicon.ico"
	type="image/x-icon" />
<title>${pdf.fileName}</title>
<style type="text/css">
html, body {
	margin: 0px;
	padding: 0px;
	width: 100%;
	height: 100%;
	position: absolute;
	left: 0px;
	top: 0px;
	overflow: hidden;
}

div.media {
	height: 100%;
}
</style>
</head>
<body>

	<c:if test="${!exists or fact == null}">
		<script type="text/javascript">
			alert("文件不存在！");
			window.close();
		</script>
	</c:if>

	<a class="media" href="${pageContext.request.contextPath}/${fact}"></a>

	<script type="text/javascript"
		src="${rsa}/global/plugins/others/jquery.min.js"></script>
	<script type="text/javascript"
		src="${rsa}/global/plugins/jquery-meida/jquery.media.js"></script>

	<script type="text/javascript">
		$(function() {
			$('a.media').media({
				width : "100%",
				height : "100%"
			});
		});
	</script>
</body>
</html>
