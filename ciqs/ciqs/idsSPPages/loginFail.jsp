<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", -1);
	response.setDateHeader("max-age", 0);
	
	String failInfo = (String) request.getAttribute("sp.simple.login.fail.message");
	String returnUrl = (String)request.getAttribute("ids.ssoLogin.referURL");
%>
<html>
<head>
<title>TRS IDS Agent:::<%= request.getRequestURL() %></title>

</head>

<body>
	<%out.println("您未登录，请求的页面无法访问"); %>
</body>
</html>