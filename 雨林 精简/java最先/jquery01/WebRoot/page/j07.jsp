<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(七)JQuery的UI</title>
    
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
		$("#w07").tabs();
	});
	
	
</script>
  </head>
  
  <body>
    This is my JSP page. <br>
    
 <h1>选项卡的效果</h1>
	<div id="w07">
		<ul>
			<li><a href="#c1">栏目一</a></li>
			<li><a href="#c2">栏目二</a></li>
			<li><a href="#c3">栏目三</a></li>
		</ul>
		
		<div id="c1">
			<p>111</p>
			<p>111</p>
			<p>111</p>
		</div>
		<div id="c2">
			<p>222</p>
			<p>222</p>
			<p>222</p>
		</div>
		<div id="c3">
			<p>333</p>
			<p>333</p>
			<p>333</p>
		</div>
	</div>
  </body>
</html>
