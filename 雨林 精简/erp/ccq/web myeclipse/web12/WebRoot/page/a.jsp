<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(1)JSP中的注释</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    <h1>(1)JSP中的注释</h1><br>
    <h1>(2)JSP的运行原理        a.JSP->a.java->a.class,为什么jsp在第一次运行时候慢</h1><br>
<!--  html的注释，JSP的显示注释会被发送到浏览器  -->
<%
//隐式注释
/*
不会发送到浏览器端
*/


 %>
    
    
  </body>
</html>
