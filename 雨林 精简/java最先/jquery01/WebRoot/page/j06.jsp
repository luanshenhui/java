<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(六)JQuery的UI</title>
    
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
		$("#w06").accordion();
	});
	
	
</script>
  </head>
  
  <body>
    This is my JSP page. <br>
    
 <h1>折叠面板的效果</h1>
<div id="w06"> 
	<div>栏目一的标题</div>
	<div>
		<p>栏目一的内容</p>
		<p>栏目一的内容</p>
		<p>栏目一的内容</p>
	</div>
	
	<div>栏目二的标题</div>
	<div>
		<p>栏目二的内容</p>
		<p>栏目二的内容</p>
		<p>栏目二的内容</p>
	</div>
	
	<div>栏目三的标题</div>
	<div>
		<p>栏目三的内容</p>
		<p>栏目三的内容</p>
		<p>栏目三的内容</p>
	</div>
</div>
  </body>
</html>
