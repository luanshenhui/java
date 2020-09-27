<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(一)jQuery中的选择器</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<!--导入jqery框架	-->
<script type="text/javascript" src="js/jquery-1.8.3.js"></script>

<script type="text/javascript">
function m(){
	//(1)html选择器
	//$("div").css("background-color","#FF0000")
	//(2)id选择器
	//$("#a").css("background-color","#FF0000")
	//(3)class选择器
	//$(".b").css("background-color","#FF0000")
	//(4)组合选择器
	//$("#a,.b,p").css("background-color","#FF0000")
	//(5)包含选择器
	//$("div span").css("background-color","#FF0000")
	
	//(6)可以选择第一个和最后一个
	//$("li:first").css("background-color","#FF0000")
	//$("li:last").css("background-color","#0000FF")
	//(7)选择奇偶数行
	//$("li:even").css("background-color","#FF0000")
	//$("li:odd").css("background-color","#00FF00")
	//(8)选择制定的行
	//$("li:eq(1)").css("background-color","#FF0000")
	//$("li:gt(1)").css("background-color","#00FF00")
	
	//(9)选择属性,
	//$("div[id]").css("background-color","#FF0000")//找有id属性的
	//$("div[id=a]").css("background-color","#FF0000")//找有id属性的
	//$("div[id=a][class=b]").css("background-color","#FF0000")//找有id属性的
	
	//(10)全选，疑问
	alert($(":checkbox"));
	$(":checkbox").attr("checked",$("#all").attr("checked"))
	}
	
</script>
  </head>
  
  <body>
    This is my JSP page. <br>
    <h1>(一)jQuery中的选择器</h1>
    
<!--    <div ><span>111</span></div>-->
<!--    <span>000</span>-->
<!--    -->
<!--    -->
<!--    <div class="b">222</div>-->
<!--    <div class="b">333</div>-->
<!--    <p>444</p>-->

<!--	<ul>-->
<!--		<li>大连</li>-->
<!--		<li>上海</li>-->
<!--		<li>北京</li>-->
<!--		<li>广州</li>-->
<!--		<li>桂林</li>-->
<!--		<li>内蒙</li>-->
<!--	</ul>-->

<!--	<div id="a" class="b">111</div>-->
<!--	<div id="b">222</div>-->


<form action="">
	<input type="checkbox" id="all" onclick="m();"/>全选 </p>
	<input type="checkbox"/>足球
	<input type="checkbox"/>篮球
	<input type="checkbox"/>排球
</form>

    <input type="button" value="按钮" onclick="m();"/>
  </body>
</html>
