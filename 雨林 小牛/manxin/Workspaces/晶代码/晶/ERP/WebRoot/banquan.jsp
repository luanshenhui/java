<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path;
	String applicationPath = basePath + "/" + "application";
%>
<html>
<head>
<title>雨淋科技版权所有</title>
<LINK href="<%=path%>/theme/sophia_style.css" type="text/css"
	rel="stylesheet">
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center" class="lan12">版权所有：雨淋科技</td>
		</tr>
	</table>

</body>
</html>
