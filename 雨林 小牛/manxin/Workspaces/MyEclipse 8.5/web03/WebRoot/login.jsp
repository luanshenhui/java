<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<style>
</style>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="css/style1.css" />
		<!-- <script type="text/javascript">
			function selected(){
			var user = document.getElementById("User");
			var admin = document.getElementById("Admin");
			var span = document.getElementById("select");
			span.removeChild(span.firstChild);
			if(user.checked==false&&admin.checked==false){
			var text = document.createTextNode("请选择用户类型");
			span.appendChild(text);
			return false;
			}else{
			var text = document.createElement("text");
			text = "*";
			span.appendChild(text);
			return true;
			}
			}
		</script> -->
	</head>
	<body >
		<div class="dd_tbody" >
		<div class="left">
			<div class="title">			
			</div>
		</div>
		<form action="UserOrAdminServlet" method="post" class="dd_form1" onsubmit="return selected();">
				<table  cellpadding="0" cellspacing="0" height="200" width="600px">
					<tr>
						<td>
							用户名：
						</td>
						<td  class="a">
							<input type="text" name="username" id="username" class="input"
								value="${loginForm.username}"  />
						</td>
						
						<td>
							<span id="username2" style="color: #FFFFCC; font-size:20px;">
								*</span>
						</td>
					</tr>
					<tr>
						<td>
							密码：
						</td>
						<td  class="a">
							<input type="password" name="password" class="input" />
							
						</td>						
						<td>
							<span id="password2" style="color: #FFFFCC; font-size: 20px;">
				* </span></td>
						</tr>
					<tr>
					
						<td align="center">
							用户
							<input type="radio" name="status" value="User" id="User"
								<c:if test="${loginForm.status == 'User'}">checked="checked"</c:if> />

						</td>
						<td  align="center">
							管理员
							<input type="radio" name="status" value="Admin"  id="Admin"
							<c:if test="${loginForm.status == 'Admin'}">checked="checked"</c:if>
								 />
						</td>
				<td>
              		<span style="color:#FFFFCC;;font-size:20pt;" id="select">*</span>
              	</td>
					</tr>
					<tr>
						<td class="button" align="center">
							<input type="submit" value="登录" class="dd_login" />
						</td>
						<td class="button" align="center">
							<a href="regist.jsp" id="link1">注册</a>
						</td>
						<td class="button" align="center">
						<a href="forgetpwd.jsp"></a>
						</td>
					</tr>	
				</table>
			
		</form>
		</div>
	</body>
</html>