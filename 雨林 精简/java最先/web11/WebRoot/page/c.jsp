<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cc.aa.cc.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'c.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    Text<br>
    <%
    List<Person>list=new ArrayList<Person>();
    list.add(new Person("张三",30));
    list.add(new Person("李四",40));
    list.add(new Person("王五",50));
     %>
     
    
     <% for(Person p:list){ %>
     <table border="2">
     		<tr>
     		<td>
     		<%="姓名             	"+p.getName()%>
     		</td>
     		<td>
     		<%=p.getAge()+"岁"%>     		
     		</td>
     		</tr>
     		<%} %>
     </table>
  
     
  </body>
</html>
