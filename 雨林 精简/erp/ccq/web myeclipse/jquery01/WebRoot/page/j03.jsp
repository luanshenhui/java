<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(三)JQuery的UI</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<link rel="stylesheet" href="js/themes/base/jquery.ui.all.css">
<link rel="stylesheet" href="js/demos.css">

<script src="js/jquery-1.8.3.js"></script>
<script src="js/ui/jquery.ui.core.js"></script>
<script src="js/ui/jquery.ui.widget.js"></script>

<script src="js/ui/jquery.ui.accordion.js"></script>
<script src="js/ui/jquery.ui.tabs.js"></script>
<script src="js/ui/jquery.ui.mouse.js"></script>
<script src="js/ui/jquery.ui.draggable.js"></script>
<script src="js/ui/jquery.ui.position.js"></script>
<script src="js/ui/jquery.ui.menu.js"></script>
<script src="js/ui/jquery.ui.autocomplete.js"></script>
<script src="js/ui/jquery.ui.tooltip.js"></script>
<script src="js/ui/jquery.ui.datepicker.js"></script>

<script type="text/javascript">
	$(function(){
		$("#w03").datepicker({
			changeYear:true,
			changeMonth:true
			
		});
	});
</script>
  </head>
  
  <body>
    This is my JSP page. <br>
    
    请输入日期：<input id="w03" type="text"/>
  </body>
</html>
