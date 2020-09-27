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
.center_logo{margin:80px 0 0 0; text-align:center; width:100%; float:left}
.home_bottom{width:100%;position:absolute;background:#000000 url(<%=webpath%>/view/base/theme/css/redmond/images/frame/home_bottom.gif) repeat-x;height:18px; bottom:0; left:0;text-align:center; padding-top:26px; color:#FFFFFF}
</style>
<body>
<div class="con">
<div class="center_logo">
  <img src="<%=webpath%>/view/base/theme/css/redmond/images/frame/center_logo.gif"/>
</div>
</div>
<div class="home_bottom">
Copyright &copy; DHC Inc. All rights reserved.
</div>
</body>
</html>
