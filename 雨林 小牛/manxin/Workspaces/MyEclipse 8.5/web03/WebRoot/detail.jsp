<%@ page language="java" contentType="text/html; charset=utf-8" import="java.util.*,entity.*" 
pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 赵佳楠 -->

<html>
  <head>
    <title>个人资料</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.messages_cn.js"></script>
<script type="text/javascript">

</script>

<style type="text/css">
body{
background-color:black;

}
#ff{
	background:url(img/3.png) 300px 50px no-repeat;

	display: block;
	line-height: 50px;
	margin-top:30px;
	margin-left:300px;
	width:600px;
	text-align:left;
	color:#fcff42;
	font-weight:bold;
	font-size:20px;
	float: left;
	clear: left;
}
#d2{
margin-right: 200px;
}
.confirm{
	border:0;
	color:#ddd;
	cursor:pointer;
	background: url(img/btn2.png) 55% no-repeat;
}
.confirm:HOVER{
	border:0;
	color:#fff;
	cursor:pointer;
	background: url(img/btnl2.png) 55% no-repeat;
}
</style>
  </head>
  
  <body>
  <%@include file="plugin/head.jsp"%>
  <c:if test="${empty friend}">
  <div id="ff">
  	<form id="dform" action="DetailServlet" method="post">
  		用户名：<input type="text" name="username"  value="${user.name}" /><br/>
  		真实姓名：<input type="text" name="realname" value="${user.trueName}" /><br/>
  		性别：男:<input type="radio" name="sex" value="男" <c:if test="${user.sex=='男'}">checked="checked"</c:if>/>
			女:<input type="radio" name="sex" value="女"<c:if test="${user.sex=='女'}">checked="checked"</c:if>/><br/>
  		年龄：<input type="text" name="age" value="${user.age}" /><br/>
  		邮箱：<input type="text" name="email" value="${user.email }" /><br/>
  		电话：<input type="text" name="phone" value="${user.phoneNo}"/><br/>
  		地址：<input type="text" name="address" value="${user.address }" /><br/>
  		个性签名：<input type="text" name="signature" value = "${user.personal.signature}"/><br/>
  		<input type="submit" value="提交" class="confirm"/>
  		<input type="reset" value="重置" class="confirm"/><br/>	
  	</form>
   </div></c:if>
   <c:if test="${!empty friend}">
   <div id="ff">
  	<form id="dform" action="DetailServlet" method="post">
  		用户名：<input type="text" name="username"  value="${friend.name}" /><br/>
  		真实姓名：<input type="text" name="realname" value="${friend.trueName}" /><br/>
  		性别：男:<input type="radio" name="sex" value="男" <c:if test="${friend.sex=='男'}">checked="checked"</c:if>/>
			女:<input type="radio" name="sex" value="女"<c:if test="${friend.sex=='女'}">checked="checked"</c:if>/><br/>
  		年龄：<input type="text" name="age" value="${friend.age}" /><br/>
  		邮箱：<input type="text" name="email" value="${friend.email }" /><br/>
  		电话：<input type="text" name="phone" value="${friend.phoneNo}"/><br/>
  		地址：<input type="text" name="address" value="${friend.address }" /><br/>
  		个性签名：<input type="text" name="signature" value = "${friend.personal.signature}"/><br/>
  	</form>
   </div></c:if>
   			<div id="d2">
				<%@include file="plugin/foot.jsp" %>
			</div>
  </body>
</html>
