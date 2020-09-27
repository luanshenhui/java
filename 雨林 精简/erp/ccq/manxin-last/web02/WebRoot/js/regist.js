function $(id){
	return document.getElementById(id);
}
function check(){
	//验证两次密码是否一致！
	if($("pwd1").value == $("pwd2").value){
		return true; 
	}else{
	//	$("msg").innerHTML="两次输入的密码不一样";
		$("pwd2").style.backgroundColor="red";
		return false; //false会阻止表单的提交
	}
}
function checkId(){
	if($("loginId").value.length >= 6 && $("loginId").value.length<=18){
		alert("OK!");
	}
}
/**
 * 练习：
 * 	1.验证密码
 *  2.确认密码
 *  3.验证真是姓名
 *  4.所有输入都不能为空
 *  5.只有所有验证通过之后才能提交表单
 *  6.提交表单之后将用户注册至数据库。
 */






