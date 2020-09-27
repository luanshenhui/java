<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<script type="text/javascript" src="js/jquery.validate.js"></script>
		<script type="text/javascript" src="js/jquery.validate.messages_cn.js"></script>
		<script type="text/javascript">
		$(function(){
				$("#forgetpwd").validate(
			{
				rules: {		
					age:{
						range:[20,99]
					},
			messages:{
						age:{
					 range:" 年龄必须在20－99之间"
					}
				}
			}
			}
		);
		})
		</script>
		<style type="text/css">

		body{
	background: url(img/123.jpg) no-repeat;
	background-color: #000;
	font-size: 24pt;
		}
		#forgetpwd{
			
				margin-left: 200px;
				margin-top: 150px;
				color:#aff;
				font-weight:bold;
		}
		.input{
			width:230px;
			font-weight:bold;
			font-size: 23pt;
			background-color: #D8E4D0;
		}
		</style>
	</head>
	<body >
		<form action="forgetpwd.do" method="post" id="forgetpwd">
			<table>
				<tr>
					<td>
						用户名：
					</td>
					<td>
						<input class="input" type="text" name="username"
							value="${ forgetpwdForm.username}" />
					</td>
					<td colspan="2">
						<span style="color: #A246FD; font-size: 22pt;">
							${forget_err1 } </span>
					</td>
				</tr>
				<tr>
					<td>
						性别：
					</td>
					<td colspan="2">
						男
						<input type="radio" name="sex" value="男" checked="checked" />
						女

						<input type="radio" name="sex" value="女"
							<c:if test="${forgetpwdForm.sex=='女'}">checked="checked"</c:if> />
					</td>
				</tr>
				<tr>
					<td>
						年龄：
					</td>
					<td colspan="2">
						<input class="input" type="text" name="age" value="${forgetpwdForm.age}" />
					</td>
				</tr>
				<tr>
					<td>
						email：
					</td>
					<td colspan="2"> 
						<input class="input" type="text" name="email" value="${forgetpwdForm.email}" />
					</td>
				</tr>
				<tr>
					<td/>
					<td>
						<input  type="submit" value="确定"  style="font-size: 20pt;background-color: #FFE6CC;font-weight:bold; color:#9946FF;"/>
					<td colspan="2">
						<span style="color: #A246FD; font-size: 22pt;">
							${forget_err2 } </span>
					</td>
				</tr>
			</table>

		</form>
	</body>
</html>