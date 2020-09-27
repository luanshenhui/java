function $(id){
	return document.getElementById(id);
}

function check(){
	if(checkNickName() && checkPwd() && checkPwd2()){
		return true;
	}else{
		return false;
	}
}

function checkemail(){
	var email = $("email")
}

function checkNickName(){
	//验证昵称
	var nickname = $("nickname").value;
	if(nickname.length >= 4 && nickname.length <= 20){
		$("nickname").style.color = "balck";
		$("name.info").innerHTML = "";
		return true;
	}else{
		$("nickname").style.color = "red";
		$("name.info").innerHTML = "请正确输入昵称";
		return false;
	}
}

function checkPwd(){
	//验证密码
	var pwd = $("pwd").value;
	if(pwd.length >= 6 && pwd.length <= 20){
		$("pwd").style.color = "balck";
		$("password.info").innerHTML = "";
		return true;
	}else{
		$("pwd").style.color = "red";
		$("password.info").innerHTML = "请正确输入密码";
		return false;
	}
}

function checkPwd2(){
	//验证密码
	var pwd = $("pwd").value;
	var pwd2 = $("pwd2").value;
	if(pwd2 == pwd){
		$("pwd2").style.color = "balck";
		$("password1.info").innerHTML = "";
		return true;
	}else{
		$("pwd2").style.color = "red";
		$("password1.info").innerHTML = "两次输入的密码不一样";
		return false;
	}
}