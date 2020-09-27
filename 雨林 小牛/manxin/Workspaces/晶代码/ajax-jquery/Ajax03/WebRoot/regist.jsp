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
		 		//检查用户名是否为空
		 		$('username_msg').innerHTML = '';
		 		if($F('username').strip().length == 0){
		 			$('username_msg').innerHTML = 
		 			'用户名不能为空';
		 			return false;
		 		}
		 		//用户名是否被占用
		 		var flag = false;
		 		var xhr = getXhr();
		 		xhr.open('post','check_username',false);
		 		xhr.setRequestHeader('content-type',
		 		'application/x-www-form-urlencoded');
		 		xhr.onreadystatechange=function(){
		 			if(xhr.readyState == 4){
		 				var txt = xhr.responseText;
		 				if(txt == 'ok'){
		 					flag = true;
		 					$('username_msg').innerHTML = 
		 					'可以使用';
		 				}else{
		 					flag = false;
		 					$('username_msg').innerHTML =
		 					'用户名被占用'
		 				}
		 			}
		 		};
		 		xhr.send('username=' + $F('username').strip());
		 		//如果发送的是同步请求，浏览器需要等待服务器
		 		//的晌应回来，然后继续向下执行。
		 		return flag;
		 	}
		 	function beforeSubmit(){
		 		var flag = check_username();
		 		return flag;
		 	}
		 </script>
	</head>
	<body style="font-size:30px;font-style:italic;">
		<form action="regist" method="post" 
		onsubmit="return beforeSubmit();">
			<fieldset>
				<legend>注册</legend>
				用户名:<input id="username" 
				name="username" 
				onblur="check_username();"/>
				<span class="tips" id="username_msg"></span>
				<br/>
				密码:<input type="password" name="pwd"/><br/>
				验证码:<input name="number"/><br/>
				<img src="checkcode" id="img1"/>
				<a href="javascript:;" 
				onclick="$('img1').src='checkcode?' + Math.random();">看不清，换一个</a><br/>
				<input type="submit" value="提交&nbsp;"/>
			</fieldset>
		</form>
	</body>
</html>