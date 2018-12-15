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

	<a class="media"
		href="${pageContext.request.contextPath}/common/viewImg.action?path=${pdf.filePath}"></a>

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
