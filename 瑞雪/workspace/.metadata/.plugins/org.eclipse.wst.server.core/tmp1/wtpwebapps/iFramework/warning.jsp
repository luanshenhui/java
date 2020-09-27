<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%
	// 获得应用上下文
	String webpath = request.getContextPath();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TSD-Welcome</title>
<link href="theme/css/main.css" rel="stylesheet" type="text/css" />
</head>
<style>
body{font-family:Arial, Helvetica, sans-serif;font-size:12px}
.con{position:relative}
.nav_url{position:absolute; left:10px;top:10px; float:left%;color:#0068a8}
.nav_url a{color:#0068a8; text-decoration:none}
.nav_url a:hover{color:#0068a8; text-decoration:underline}
.nav_url a:visited{color:#0068a8}
.center_logo{margin:200px auto 0 auto; text-align:center; width:100%; float:left;}
</style>
<body>
<div class="con">
  <div class="center_logo">
<table align="center" style="height:253px;width:490px; background-image:url(<%=webpath%>/view/base/theme/css/redmond/images/frame/warning.gif)"border="0" cellspacing="0" cellpadding="0" >
  <tr><td width="167" rowspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td width="323" style="line-height:26px">jhgfjhgjhg<br />
      AccessDenied</td>
  </tr>
</table>
</div>
</div>
</body>
</html>
