<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<script type="text/javascript" src="js/jquery.validate.js"></script>
		<script type="text/javascript" src="js/jquery.validate.messages_cn.js"></script>
		<script type="text/javascript">
 $(function(){
   		$("#editpwd").validate(
			{
				rules: {		
					password1 : {
						required:true,
						rangelength:[6,10]
					},
					password2 : {
						required:true,
						equalTo:"#password1"
					}										
				},
				messages:{
					password1:{
						required:"  密码不能为空!",
						rangelength:"  密码必须在6-10位!"
					},
					password2:{
					 equalTo:"  要与上面的密码一致"
					}

				}
			}
		);
 });
		
		</script>
		
		<style type="text/css">

		body{
	background: url(img/123.jpg) no-repeat;
	background-color: #000;
	font-size: 25pt;
		}
		#editpwd{
				margin-left: 450px;
				margin-top: 200px;
				color:#aff;
				font-weight:bold;
		}
		.input{
			width:220px;
			font-weight:bold;
			font-size: 23pt;
			background-color: #D8E4D0;
		}
		</style>
	</head>
	<body>
		<form id="editpwd" action="editpwd.do">
			<table>
				<tr>
					<td>
						新密码：
					</td>
					<td colspan="2">
						<input class="input" type="password" name="password1" id="password1" />
					</td>
				</tr>
				<tr>
					<td>
						确认密码：
					</td>
					<td colspan="2">
						<input class="input" type="password" name="password2" />
					</td>
				</tr>
				
				<tr >
					<td/>
					<td colspan="2"> 
						<input type="submit" value="确定" style="font-size: 23pt;background-color: #FFE6CC;font-weight:bold; color:#9946FF;" />
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>