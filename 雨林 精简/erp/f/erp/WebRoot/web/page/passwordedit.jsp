<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.f.domain.Person" %>
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
        <title>查看用户</title>
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />
	</head>
<% Person person=(Person)session.getAttribute("person"); %>
	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			<form action="PasswordEdit" name="formAdd" method="post">
			<%if(request.getAttribute("passworderr")!=null){ %>
 			<%=request.getAttribute("passworderr") %>
 			<%} %>
				
				     <table width="98%" align="center" border="0" cellpadding="4" cellspacing="1" bgcolor="#CBD8AC" style="margin-bottom:8px">
						<tr bgcolor="#EEF4EA">
					        <td colspan="3" background="web/img/wbg.gif" class='title'><span>修改密码</span>
					        </td>
					    </tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						      原密码：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
								<input name="oldpassword" type="password" >
						    </td>
						</tr>
						  
						  <tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						    新密码：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
								<input name="newpassword" type="password" >
						    </td>
						</tr>
						  <tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						  再次输入密码：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
								<input name="againpassword" type="password" >
						    </td>
						</tr>
					 </table>
					 <table width='9%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="submit" value="修改" style="width: 80px;" />
			    </td>
			     <td>
			      <input type="submit" value="重置" style="width: 80px;" />
			    </td>
			  </tr>
		    </table>
			</form>
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="返回" style="width: 80px;" onclick="history.back(-1)"/>
			    </td>
			  </tr>
		    </table>
			
			
   </body>
</html>
