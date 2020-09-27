<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
 <head>
		<title>regist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="css/style.css" />
		<script type="text/javascript" src="js/my.js"></script>
		<script type="text/javascript" src="js/prototype-1.6.0.3.js"></script>
		<script type="text/javascript">
			function check_name(){
				var xhr = getXhr();
				var uri = 'checkname.do?name='+$F('name');
				xhr.open('get',encodeURI(uri),true);
				xhr.onreadystatechange = function(){
					if(xhr.readyState == 4){
						if(xhr.status == 200){
							var txt = xhr.responseText;
							$('name_msg').innerHTML = txt;
						}else{
							$('name_msg').innerHTML = '检查出错...';
						}
					}
				};
				$('name_msg').innerHTML = '正在检查....';
				xhr.send(null);
			}
		</script>
	</head>
	<body>
		<div id="wrap">
			<div id="top_content">
					<div id="header">
						<div id="rightheader">
							<p>
								2009/11/20
								<br />
							</p>
						</div>
						<div id="topheader">
							<h1 id="title">
								<a href="#">main</a>
							</h1>
						</div>
						<div id="navigation">
						</div>
					</div>
				<div id="content">
					<p id="whereami">
					</p>
					<h1>
						注册
					</h1>
					<form action="regist.do" method="post">
						<table cellpadding="0" cellspacing="0" border="0"
							class="form_table">
							<tr>
								<td valign="middle" align="right">
									用户名:
								</td>
								<td valign="middle" align="left">
									<input type="text" class="inputgri" name="name" id="name" onblur="check_name();"/>
									<span id="name_msg" style="color: red;">${name_error }</span>
								</td>
							</tr>
							<tr>
								<td valign="middle" align="right">
									密码:
								</td>
								<td valign="middle" align="left">
									<input type="password" class="inputgri" name="pwd" />
								</td>
							</tr>
							
							<tr>
								<td valign="middle" align="right">
									性别:
								</td>
								<td valign="middle" align="left">
									男
									<input type="radio" class="inputgri" name="sex" value="m" checked=""/>
									女
									<input type="radio" class="inputgri" name="sex" value="f"/>
								</td>
							</tr>
							
							<tr>
								<td valign="middle" align="right">
								<a href="javascript:;" onclick="document.getElementById('num').src = 'image?' + Math.random();">
								<img id="num" src="image"/>
								</a>
								</td>
								<td valign="middle" align="left">
									<input type="text" class="inputgri" name="code" />
								</td>
							</tr>
						</table>
						<p>
							<input type="submit" class="button" value="Submit &raquo;" onclick="javascript:;location.href='login.jsp'"/>
						</p>
						<p style="color: red">
							
						</p>
					</form>
				</div>
			</div>
			<div id="footer">
				<div id="footer_bg">
				ABC@126.com
				</div>
			</div>
		</div>
	</body>
</html>
