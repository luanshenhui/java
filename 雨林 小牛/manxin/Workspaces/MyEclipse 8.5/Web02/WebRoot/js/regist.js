function $(id){
	return document.getElementById(id);
}
function check(){
	//验证两次密码
	if($("pwd2").value != null){
		if($("pwd1").value == $("pwd2").value && $("pwd1").value != null){
			return true;
		}else{
//			$("mag").innerHTML="两次输入的密码不一样";
//			$("pwd2").style.backgroundColor = "red";
			alert("两次输入的密码不一样");
			return false;//false会阻止表单的提交
		}
	}else{
		alert("确认密码不能为空");
		return false;
	}
}

function checkId(){
	//验证id
	if($("loginId").value.length >= 6 && $("loginId").value.length <= 18){
		var id = $("loginId").value;
		if(!isNaN(id)){
			return true;
		}else{
			alert("id必须是数字！");
			return false;
		}
		
	}else{
		alert("id不能为空");
		return false;
	}
}

function checkPwd(){
	//验证密码
	if($("pwd1").value.length >=6 && $("pwd1").value.length <=18 && $("pwd1") != null){
		return true;
	}else{
		alert("密码不能为空");
		return false;
	}
}

function checkName(){
	//验证姓名
	if($("name").value != ""){
		return true;
	}else{
		alert("姓名不能为空");
		return false;
	}
}
function checkSubmit(){
	//验证全部
	if(check() && checkId() && checkName() && checkPwd()){
		return true;
	}else{
		alert("注册失败");
		return false;
	}
}