<%@ page pageEncoding="utf-8" contentType="text/html;charset=utf-8"
	errorPage="a4.jsp"
%>

<html>
  <head>
  </head>
  
  <body style="font-size: 30px; font-style: italic;">
    <%
    	String num = request.getParameter("num");
    	out.println(Integer.parseInt(num) + 100);
     %>
  </body>
</html>
