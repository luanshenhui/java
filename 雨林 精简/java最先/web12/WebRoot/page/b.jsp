<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(二)JSP 的基础语法</title>
    
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
   JSP 的基础语法 <br/>
  (1) jsp的本质就是写入java+html<p/>
  (2)tomcat怎样运行jsp:tomcat(容器)将java转换成html和原来的html一同发给浏览器<p/>
  (3)jsp的写法3种，：声明语句(几乎不用)，表达式(不能有分号)，java代码(常用)<p/>
<!-- 加"!"号，就是声明语句 -->
  <%! int i=0; %>
  <%=i++ %>
  
  <h1><%="syso" %></h1>
  <%out.print("<h1>java代码写法</h1>"); %>
  
  </body>
</html>
