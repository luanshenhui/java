<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.lsh.domain.Person" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
        <title>查看单个商品</title>
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />
	</head>

<%
Person person=(Person)session.getAttribute("person");
 %>


	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			<form action="" name="formAdd" method="post">
			
				     <table width="98%" align="center" border="0" cellpadding="4" cellspacing="1" bgcolor="#CBD8AC" style="margin-bottom:8px">
						<tr bgcolor="#EEF4EA">
					        <td colspan="3" background="web/img/wbg.gif" class='title'><span>查看<%=person.getUsername() %></>信息</span>
					        </td>
					    </tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        姓名：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
									<%=person.getUsername() %>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						       性别：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						       <%=person.getSex() %>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        年龄：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						        <%=person.getAge() %>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        邮箱：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						        <%=person.getEmail() %>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        电话：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						      <%=person.getPhone() %>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        工资：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						       <%=person.getSalary() %>
						    </td>
						</tr>

					 </table>
			</form>
			
			
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="返回" style="width: 80px;" />
			    </td>
			  </tr>
		    </table>
			
			
   </body>
</html>
