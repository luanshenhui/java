<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>(二)jQuery中的DOM</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<script type="text/javascript" src="js/jquery-1.8.3.js"/></script>
	
	<script type="text/javascript">
	//当浏览器加载完了，就会调它
	$(function(){
	
		$("#b01").click(function(){
		//(1)后面，前面创建节点	
//		$("div").append("<div>222</div>");
//		$("#a").append("<div>222</div>");
//		$("#a").prepend("<div>333</div>");
		
		//(2)文本内容的获取和设置
		//alert($("#a").text());		
		//$("#a").text("修改内容....");
		
		//(3)html内容的获取和设置
		alert($("#a").html());
		$("#a").html("<h2>修改html内容...</h2>");
		
		
		});
		
	});
	</script>
  </head>
  
  <body>
    This is my JSP page. <br>
    <h1>(二)jQuery中的DOM</h1>
    <div id="a">
    	<a herf="http://www.baidu.com">百度网站</a>
    </div>
     <input id="b01" type="button" value="按钮"/>
  </body>
</html>
