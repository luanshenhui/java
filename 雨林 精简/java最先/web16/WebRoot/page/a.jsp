<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>A页面</title>
    
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
    <%
    //将数据存在当前组件的范围,几乎不用
   // pageContext默认存储在page中，同时也可以存在其他范围中
   pageContext.setAttribute("name","张三");
   //pageContext.setAttribute("name","张三",pageContext.APPLICATION_SCOPE);
   
   //将数据存储在一次请求中.必须是请求转发跳转
 //request.setAttribute("name","张三");
   //将数据存储在一次会话中。
 // session.setAttribute("name","zhangsan");
 //将数据存在整个应用中
 //application.setAttribute("name","lisi");
     %>
    
     
 <%
 response.sendRedirect("/web16/page/b.jsp");
 %>
     
  </body>
</html>
