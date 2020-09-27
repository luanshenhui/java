<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>这是一个工作流测试页面</title>
</head>
<body>
	<h1>工作流变量：</h1>
	作业项目ID:<%=request.getParameter("workitemId")%><br />
	活动实例ID:<%=request.getParameter("activityInstId")%><br />
	流程实例ID:<%=request.getParameter("processInstId")%><br />
	<h1>下面是正常的业务页面：</h1>
	业务页面...
</body>
</html>