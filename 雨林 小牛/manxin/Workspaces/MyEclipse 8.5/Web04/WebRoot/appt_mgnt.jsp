<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
  <head>
	<meta http-equiv="cache-control" content="no-cache">  
	<meta http-equiv="keywords" content="交友">
	<meta http-equiv="description" content="恋爱自由">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" type="text/css" href="css/style_appt.css">
	<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
	<script type="text/javascript">
	$(function(){
		$("#mgnt1 tr:gt(1)").mouseover(function(){
			$(this).css({"background":"#bfd5ff","color":"white"});
		}).mouseout(function(){
			$(this).css("background","#000");
		});
		$("#mgnt2 tr:gt(0)").mouseover(function(){
			$(this).css("background","#f3b7f7");
		}).mouseout(function(){
			$(this).css("background","#000");
		});
	});
	</script>
<style type="text/css">
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.STYLE1 {
font-size: 15px;
color:#559cff;
}
.STYLE2{
font-size: 16px;
color:#ccc;
font-weight: bold;
}
.STYLE4 {
	font-size: 17px;
	color: #57bfff;
	font-weight: bold;
}

a:link {
	font-size: 14px;
	color: #ffa136;
	text-decoration: none;
}
a:visited {
	font-size: 13px;
	color: #eedddd;
	text-decoration: none;
}
a:hover {
	font-size: 15px;
	color: #ff8ff4;
	text-decoration: underline;
}
a:active {
	color: #FF0000;
	text-decoration: none;
}
</style>
  </head>
  
  <body>
    <div id="wholepage">
				<%@include file="plugin/head.jsp" %>
				<%@include file="appt_send_list.jsp" %>
				<%@include file="appt_recv_list.jsp" %>
				</div>
  </body>
</html>