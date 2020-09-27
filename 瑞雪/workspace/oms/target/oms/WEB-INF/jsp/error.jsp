<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>出错啦</title>
</head>
<body>
	<% Exception ex = (Exception)request.getAttribute("ex"); %>
	<H2>
		异常类型:
		<%= ex%></H2>
	<H2>
		异常信息:
		<%= ex.getMessage()%></H2>
	<P>
		<% ex.printStackTrace(new java.io.PrintWriter(out)); %>
	</P>
</body>
</html>