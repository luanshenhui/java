<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
String applicationPath = basePath + "/" + "application";
%>
<html>
<head>
<title>我的工作台</title>
<LINK href="<%=path%>/theme/sophia_style.css" type="text/css" rel="stylesheet">
</head>
<body >
<br><br><br><br>
<table width="98%" cellspacing="0" cellpadding="0" align="center" border="0" class="margtb5">
  <tr>
    <td  align="center" valign="top" class="padr5" >
	      <h3>欢迎使用进销存管理系统</h3>
	</td>
	
  </tr>
</table>

</body>
</html>