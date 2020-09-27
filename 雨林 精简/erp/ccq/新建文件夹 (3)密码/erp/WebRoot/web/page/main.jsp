<%@ page contentType="text/html; charset=UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
  <head>
    <title>系统主页面</title>
    <base href="<%=basePath%>">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

  </head>
  <frameset rows="60,*" cols="*" frameborder="no" border="0" framespacing="0">
	  <frame src="web/page/top.jsp" name="topFrame" scrolling="no">
	  <frameset cols="180,*" name="btFrame" frameborder="NO" border="0" framespacing="0">
	    <frame src="web/page/menu.jsp" noresize name="menu" scrolling="yes">
	    <frame src="web/page/personview.jsp" noresize name="main" scrolling="yes">
	  </frameset>
			
   				
   			
  </frameset>


</html>
