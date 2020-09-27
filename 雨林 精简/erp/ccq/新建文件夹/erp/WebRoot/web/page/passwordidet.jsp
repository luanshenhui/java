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
        <title>编辑用户</title>
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />
	</head>

<%
Person person=(Person)session.getAttribute("person");
 %>


	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			<form action="editpasd" name="formAdd" method="post">
			<input name="id" type="hidden" value="<%=person.getId()%>"/>
				     <table width="98%" align="center" border="0" cellpadding="4" cellspacing="1" bgcolor="#CBD8AC" style="margin-bottom:8px">
						<tr bgcolor="#EEF4EA">
					        <td colspan="3" background="web/img/wbg.gif" class='title'><span>查看<%=person.getUsername() %></>信息</span>
					        </td>
					    </tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        旧密码：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
									<input name="oldpassword" type="text"/>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						       新密码：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						     <input name="newpassword" type="text"/>
						      
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        密码确认：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						   <input name="repassword" type="text"/>
						    </td>
						</tr>
						

					 </table>
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="submit" value="更新" style="width: 80px;" />
			      <input type="submit" value="重置" style="width: 80px;" />
			    </td>
			  </tr>
		    </table>
			</form>
			
			
			
			
   </body>
</html>
