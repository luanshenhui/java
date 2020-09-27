<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<html>
  <head>
  </head>
  <body style="font-size: 30px; font-style: italic;">
   <%!
   		int i = 100;
   		int sum(int a, int b){
   			return a + b;
   		}
   		String str = "张三";
    %>
    <%=str %><br/>
    <%=i %><br/>
    <%=sum(1, 1) %>
  </body>
</html>
