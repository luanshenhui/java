<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.yulin.com/mytag" prefix="my" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'MyJsp3.jsp' starting page</title>
    
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
    This is my JSP page. <br>
    <% ArrayList<String> list = new ArrayList<String>();
    	list.add("呵呵~");
    	list.add("哈哈~");
    	list.add("嘻嘻~");
    	list.add("嘿嘿~");
    	list.add("嘎嘎~");
    	pageContext.setAttribute("list", list);
    %>
   <my:easyFor3 var="li" list="${list}">
   		${li }<br/>
   </my:easyFor3>
  </body>
</html>
