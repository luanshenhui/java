<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
  <head>
    <title>My JSP 'head.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
<style type="text/css">
body{
		margin: 0;
		font-family: Verdana, Arial, Helvetica, sans-serif;
		padding: 15px 0;
		background: #000;
}
#head{
		width: 820px;
		margin: 0 auto;	
}
#firdttop{
	display:block;
	margin-top:-20px;
	margin-right:50px
}
#firdttop a{
color:#666;
font-size:15px;
float: right;
overflow: hidden;
padding: 2px;
}
#firdttop a:HOVER{
color:#fff;
}
#firdttop a:LINK{
color:#acb;
}
#h_middle{
			padding: 100px 50px 50px 50px;
			margin: 0 auto 0 auto;
			background: url(img/030.jpg) top center no-repeat;
}
#h_middle p{
			color: #bc1fff;
			font-size:60px;
			margin: -50px auto 0 auto;
			float:right;
}
#h_bottom{
		width: 930px;
		margin: 0 auto;
		float:left;	
}
#h_bottom ul{
		list-style-type: none;
		margin-left: 0;
		padding-left: 0;
		overflow: hidden;
		zoom: 1;
}
#h_bottom ul li{
		color: #eee;
		width: 110px;
		font-size:20px;
		float:left;	
}
#h_bottom ul a{
	float: left;
	display: block;
	height: 20px;
	width:100px;
	line-height: 20px;
	text-align:center;
	padding: 0 10px;
	font-size: 20px;
	font-weight: bold;
	text-decoration: none;
	color:#f8c3ff;
}
#h_bottom ul a:hover{
	color: #fff;
}
#h_bottom ul a:VISITED{
	
}
#soso{
	margin-top:-6px;
	color:#999;
	margin-left:50px;
}

</style>

  </head>
  
  <body>
    			<div id="head">
    			<ul id="firdttop">
    			<c:if test="${empty friend}"><li><a href="out?id=${user.userID}">退出</a></li>
    					<!-- <li><a href="" onclick="">注销</a></li> --></c:if>		
    					<li><a href="back">返回我的主页</a></li>
    			</ul>
						<div id="h_middle">
						<c:if test="${empty friend}"><h2><span style="color:purple">${user.name}，欢迎你</span></h2></c:if>
						<c:if test="${!empty friend}"><h2><span style="color:purple">${user.name}，欢迎你来到 ${friend.name}的家园</span></h2></c:if>
						<p id="yuan">缘份天空</p>
						</div>
						<div id="h_bottom">
									<ul>
											<li><a href="main.jsp">首页</a></li>
											<li><a href="log?pageIndex=0&pageSize=5">日志</a></li>	
											<li><a href="friend">好友</a></li>
											<li><a href="detail.jsp">个人资料</a></li>
											<li><a href="getLeaveWordActionServlet">留言版</a></li>
											<c:if test="${friend==null}">
											<li><a href="selectAppointment">约会</a></li>				
											</c:if>				
									</ul>
						<hr width="790px"  style="size:10px;margin-left:0; mcolor: 999;"/>
						</div>
				</div>
  </body>
</html>
