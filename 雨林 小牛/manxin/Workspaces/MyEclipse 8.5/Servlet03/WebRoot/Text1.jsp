<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  </head>
  
  <body style="font-size: 30px;font-style: italic">
   ````` <br>
   <%
   	 Date date = new Date();
   	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	 out.println(sdf.format(date));
    %><br/>
    <%=sdf.format(date) %>
    <br/>
    <%
    	out.println(new Date());
     %><br/>
     <%=new Date() %><br/>
     <%
     	for(int i = 0; i < 100; i++){
     		%>
     			hello world<br/>
     		<%
     	}
      %>
  </body>
</html>
