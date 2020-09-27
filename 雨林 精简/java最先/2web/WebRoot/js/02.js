function $(id) {
	return document.getElementById(id)
}

function check() {// 验证两次密码是否一致
	if ($("pwd1").value == $("pwd2").value && checkId()&& named()) {
		return true;
	} else {
		$("msg").innerHTML = "输入有误";
		$("pwd2").style.backgroundColor = "red";
		// alert("ok!");
		return false;// 阻止表单提交
	}
}
function checkId() {
	if($("pwd1").value.length >= 6 && $("pwd1").value.length <= 18){
		return true;
		$("p1").innerHTML = "输入正确";
	}else{
		$("p1").innerHTML = "输入正确格式";
		$("pwd2").style.backgroundColor = "yellow";
		return false;
	}
}
function checkId2(){
	if($("pwd1").value.length >= 6 && $("pwd1").value.length <= 18){
		return true;
		$("p1").innerHTML = "输入正确";
	}else{
		$("p1").innerHTML = "输入正确格式";
		$("pwd2").style.backgroundColor = "green";
		return false;
	}
}

function named(){
	if($("name").value!=""){
		return true;
	}else{
		alert();
		return false;
		
	}
}