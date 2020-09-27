<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
  	<!-- 相当于 for(String s : ss) -->
  	<c:forEach items="${list}" var="li" varStatus="for">
  		<c:if test="${li != '哈哈'}">
	  		count : ${for.count }, index : ${for.index } , ${li } </br>
  		</c:if>
  	<!-- if 不显示 呵呵 -->
  	<!-- choose 遇到呵呵 换成 输出hehe -->
  		<c:choose>
  			<c:when test="${li == '呵呵'}">
  				hehe </br>
  			</c:when>
  			<c:otherwise>
  				count : ${for.count }, index : ${for.index } , ${li } </br>
  			</c:otherwise>
  		</c:choose>
  	</c:forEach>
  	
  	另一个页面</br>
  	<c:import url="index2.jsp">
  	</c:import>
  	<c:redirect url="index2.jsp"></c:redirect>
  </body>
</html>



