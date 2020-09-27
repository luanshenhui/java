<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<html>
  <head>
    
  </head>
  
  <body style="font-size: 30px;font-style: italic;">
    当前系统在线人数是：
    <%=application.getAttribute("count") %><br/>
    <a href="logout.jsp">退出</a>
  </body>
</html>
