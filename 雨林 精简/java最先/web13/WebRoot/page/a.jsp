<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'a.jsp' starting page</title>
    
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
    <h1>超链接的方式提交给控制器：get和post都可以</h1>
    <form action="/web13/p" method="post">
		用户<input name="username" type="text"/><p/>
		密码<input name="password" type="password"/><p/>
		性别<input name="sex" type="radio" value="1"/>男
			<input name="sex" type="radio" value="2"/>女<p/>
			城市<select name="city">
					<option value="dl">大连</option>
					<option value="bj">北京</option>
					<option value="sh">上海</option>
				</select><p/>
			简介<textarea name="info" rows="5" cols="15"/></textarea><p/>
			隐藏<input name="id" type="hidden" value="101"/></p>
			爱好<input name="like" type="checkbox" value="lan"/>篮球
			<input name="like" type="checkbox" value="zu"/>足球
			<input name="like" type="checkbox" value="pai"/>排球</p>
			<input type="submit" value="提交"/>
			<input type="reset" value="重置"/>
		    
    </form>
    <p/>
    <h1>超链接的方式提交给控制器：就是get请求</h1>
    <a href="/web13/p?username=abc&like=1&like=2">跳到Servlet控制器</a>
  </body>
</html>
