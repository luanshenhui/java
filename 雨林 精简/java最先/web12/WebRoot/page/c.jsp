<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(三)JSP指令和标签</title>
    
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
    JSP指令盒标签 <br/>
    <h1>(1)page指令：1制定页面编码2导包</h1>
    <h1>(1)include指令：包含页面。静态包含，先包含，后执行，用的少</h1>
    <h3>(3)include标签;包含页面。动态包含。先执行后包含，用的多</h3>
    <h4>(4)forward标签：请求转发跳转</h4>
    
    
  
 
   <%@include file="login.jsp" %>

    <jsp:include page="/page/login.jsp"></jsp:include>
    
    <jsp:forward page="/page/a.jsp"></jsp:forward>
    


    
    





    
     
    
	
  </body>
</html>
