<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.util.logging.SimpleFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(1)内置对象session</title>
    
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
    <h1>(1)内置对象sessios</h1>
   	 获取会话ID的值<%=session.getId() %>
   	 </p>
   	 判断当前会话是否为新的会话：<%=session.isNew() %>
   	 </p>
   	 获取创建会话的时间<%=session.getCreationTime() %>
   	 </p>
   	 获取最后会话的时间<%=session.getLastAccessedTime() %>
   	 <%
   	 SimpleDateFormat date=new SimpleDateFormat("yyyy-MM-dd");
   	  %>
   	<%=date.format(session.getCreationTime())%>
   	 
   	 <%
   	 //注销会话的方法
   	// session.invalidate();
   	  %>
  </body>
</html>
