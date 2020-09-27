function $(id){
	return document.getElementById(id);
}
function checkId(){
	if($("loginId").value == null){
		alert("用户名不能为空！");
		return false;
	}else{
		return true;
	}
}
function checkPwd(){
	if($("pwd").value == null){
		alert("密码不能为空！");
		return false;
	}else{
		return true;
	}
}
function checkAll(){
	if(checkId() && checkPwd()){
		alert("登录成功");
		return true;
	}else{
		alert("登录成功");
		return false;
	}
}