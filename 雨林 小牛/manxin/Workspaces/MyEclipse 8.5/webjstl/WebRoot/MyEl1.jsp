<%@ page language="java" import="java.util.*" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="my" uri="http://www.yulin.com/myel"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'MyEl1.jsp' starting page</title>
    
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
   EThis is my JSP page. <br/>
   ${my:sum(3, 4)}<br/>
   ${my:sub("hdgjk","d","k") }<br/>
   <% ArrayList<String> list = new ArrayList<String>(); 
   	list.add("1");
   	list.add("2");
   	list.add("3");
   	list.add("4");
   	pageContext.setAttribute("list",list);
   %>
   ${list }
   ${my:list(list)}
  
  </body>
</html>
