<%@page pageEncoding="utf-8" 
contentType="text/html;charset=utf-8" %>
<html>
	<head>
		<style>
			.tips{
				color:red;
			}
		</style>
		<script type="text/javascript" 
		src="js/my.js">
		</script>
		<script type="text/javascript"
		 src="js/prototype-1.6.0.3.js"></script>
		<script type="text/javascript">
			function check_username(){
				//获得ajax对象
				var xhr = getXhr();
				//发请求
				var uri = 'check_username.do?username=' 
				+ $F('username');
				xhr.open('get',encodeURI(uri),true);
				xhr.onreadystatechange=function(){
					//处理服务器返回的数据
					if(xhr.readyState == 4){
						if(xhr.status == 200){
							var txt = xhr.responseText;
							$('username_msg').innerHTML =	txt;
						}else{
							$('username_msg').innerHTML = '检查出错';
						}
					}
				};
				$('username_msg').innerHTML = '正在检查...';
				xhr.send(null);
			}
		</script>
	</head>
	<body style="font-size:30px;font-style:italic;">
		<form action="regist.do" method="post">
			<fieldset>
				<legend>注册</legend>
				用户名:<input id="username" name="username" 
				onblur="check_username();"/>
				<span class="tips" id="username_msg">${regist_error}</span>
				<br/>
				密码:<input type="password" name="pwd"/><br/>
				<input type="submit" value="提交"/>
			</fieldset>
		</form>
	</body>
</html>