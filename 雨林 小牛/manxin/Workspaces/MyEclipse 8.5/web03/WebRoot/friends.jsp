<%@ page language="java" import="java.util.*,entity.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
response.setCharacterEncoding("utf-8");
 %>
<!DOCTYPE HTML PUBLIC "-//  W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   <title>我的好友</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript"  src="js/jquery-1.4.min.js"></script>
	<script type="text/javascript" src = "js/ajax.js"></script>
    <script type="text/javascript">
	$(function(){
			$("#ftable tr:even").css("height","88px");
	});
	function del(tag){
	var ret = confirm("你确定删除该好友吗？");
	if(ret){
	var id = tag.id;
	Ajax.sendRequest("GET","/datebar/deleteFriend?id="+id,null,fun);
	}else{
	
	}
	}
	function fun(p){
	var text = p.text;
	if(text=="ok"){
	location.href="http://localhost:8080/datebar/friend";
	}
	}
   </script>

   <style>
#ff{
	background:url(img/blackbg.jpg) 100px 100px no-repeat;
	margin-right: 200px;
}
		#ftable{
				float: left;
				display: block;
				margin-left:200px;
				width:650px;
				text-align:left;
				padding: 0 10px;
				font-size: 20px;
				font-weight: bold;
				text-decoration: none;
				color: #acd;
		}
	a{
			color: #b4b5ff;
			overflow: hidden;
			text-decoration: none;
		}
		a:HOVER {
	color:#89f7ff;
}
</style>
  </head>
  
  <body>
  <%@include file="plugin/head.jsp"%>
  <div id="ff">
    <table id="ftable" border=0 cellSpacing=2px cellPadding=2px width="100%">
    			<tr><td colspan="5" style="font-size:30px;">好友列表：</td></tr>
    			<c:forEach var = "user" items="${friends}">
    			<tr>
    			<td width="120px">
    			<c:forEach var = "pic" items = "${pictures}">
    			<c:if test="${user.userID==pic.key.userID}">
    			<a href="friendMain?id=${user.userID}">
				<img id="image" width="80px"src="image/${pic.value.pictureName}"/>
    			</a>
    			</c:if></c:forEach>
    			</td>	
    			<td width="120px"><a href="friendMain?id=${user.userID}">${user.name}</a></td>
    			<td width="120px">${user.sex}</td>
    			<td width="120px">&nbsp;</td>
    				<c:if test="${user.istrue==false}"><td width="120px">离线</td></c:if>
    			    <c:if test="${user.istrue==true}"><td width="120px" style="color:#ffff34; ">在线</td></c:if>
    			<td width="120px"><a id = "${user.userID}" href="javascript:;" onclick="del(this);">删除</a></td></tr>
    			</c:forEach>
    			<tr><td colspan="5">-------------------------------------------------------------</td></tr>
    </table>
    <%@include file="plugin/foot.jsp" %>
    </div>
  </body>
</html>
