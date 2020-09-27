<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>JSP的基础语法 </title>
    
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
    <h1>JSP的基础语法</h1>
    <h1>JSP=HTML+Java</h1>
    <h1>将java代码写在“尖括号，百分号中”即可</h1>
    <%String name= "张三"; %>
<!--  =shi syso  -->
    <%=name %>
    
    <%
    int a= 2;
    int b=3;
     %>
     
     <% if(a>b){ %>
     <%=a %>
     <% }else{ %>
     <%=b%>
     <%} %>
     
     <%for(int i=1;i<=10;i++){ %>
     <%=i %>
     <input type="text"/>
     <% }%>
     
  </body>
</html>
