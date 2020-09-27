<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <!-- <c:if test="${li != '呵呵'}"> --> 
 	<!--  	count : ${for.count},index : ${for.index },${li}<br/>-->
  	<!--   </c:if>-->
  
     
 <c:forEach items="${list}" var="li" varStatus="for">
  <c:choose>
   <c:when test="${li == '呵呵'}">
  	 hehe<br/>
   </c:when>
   <c:otherwise>
   	count : ${for.count},index : ${for.index },${li}<br/>
   </c:otherwise>
 </c:choose>
   </c:forEach> 
   
   <c:catch var="ex">
   <%
   	String[] ss = new String[0];
   	ss[1].toString();
    %>
   </c:catch>
   
	${ex }
  </body>
</html>
