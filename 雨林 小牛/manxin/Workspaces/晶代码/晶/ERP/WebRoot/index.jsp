<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
String applicationPath = basePath + "/" + "application";
%>
<html>
	<head>
	  <title>进销存管理系统</title>
	</head>
<frameset rows="98,*" cols="*" frameborder="no" border="0" framespacing="0">
  <frame src="top.jsp" name="topFrame" scrolling="No" noresize="noresize" id="topFrame" title="topFrame" />
  <frameset cols="170,*" frameborder="no" border="0" framespacing="0" id="content">
    <frame src="left.jsp" name="leftFrame" noresize="noresize" id="leftFrame" title="leftFrame" />
	<frameset rows="*,20" frameborder="no" border="0" framespacing="0" id="content">
      <frame src="main.jsp" name="mainFrame" id="mainFrame" title="mainFrame" />
	  <frame src="banquan.jsp" name="buttonFrame" scrolling="No" noresize="noresize" id="buttonFrame" title="buttonFrame" />
	</frameset>
  </frameset>
</frameset>
<noframes><body>
</body>
</noframes>
</html>
