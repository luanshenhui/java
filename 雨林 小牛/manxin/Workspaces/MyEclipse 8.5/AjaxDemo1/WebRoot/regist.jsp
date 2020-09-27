<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type="text/javascript" src="js/my.js"></script>
	<script type="text/javascript" src="js/prototype-1.6.0.3.js"></script>
	<script type="text/javascript">
	
	function check_username(){
		$('username_msg').innerHTML = '';
		if($F('username').strip().length == 0){
			$('username_msg').innerHTML = '用户名不能为空';
			return false;
		}
		var flag = false;
		var xhr = getXhr();
		xhr.open('post','checkname.do',false);
		xhr.setRequestHeader('content-type','application/x-www-form-urlencoded');
		xhr.onreadystatechange = function(){
			if(xhr.readyState == 4){
				var txt = xhr.responseText;
				if(txt == 'ok'){
					flag = true;
					$('username_msg').innerHTML = '可以使用';
				}else{
					flag = false;
					$('username_msg').innerHTML = '用户名已存在';
				}
			}
		};
		
		xhr.send('username=' + $F('username').strip());
		return flag;
	}
	function besubmit(){
		var flag = check_username();
		alert(flag);
		return flag;
	}
	</script>
</head>
  
  <body style="font-size: 30px; font-style: italic;">
    <form action="regist.do" method="post" onsubmit="return besubmit();">
    	<fieldset>
    		<legend>注册</legend>
    		用户名:<input id="username" name="username" onblur="check_username();"/>
    		<span style="color: red" class="tips" id="username_msg">${username_msg }</span>
    		<br/>
    		密码:<input type="password" name="pwd"/><br/>
    		<a href="javascript:;" onclick="document.getElementById('num').src = 'image?' + Math.random();">
			<img id="num" src="image"/>
			</a>
			<input type="text" class="inputgri" name="code" />
    		<br/>
    		<input type="submit" value="提交">
    	</fieldset>
    </form>
  </body>
</html>
