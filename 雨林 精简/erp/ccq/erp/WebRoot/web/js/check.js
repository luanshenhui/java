/**
 * 用户表单验证
 */
function checkpersonedit() {

	// 用户名验证
	var username = document.getElementById("username").value;
	if (username.length == 0) {
		alert("用户名不能为空!");
		return false;
	}
	
	// 年龄验证
	var age = document.getElementById("age").value;
	if (age.length == 0) {
		alert("年龄不能为空!");
		return false;
	}
	
	var age_va = new RegExp("^[0-9]{1,2}$");
	if (!age_va.test(age)) {
		alert("年龄必须是2位数字!");
		return false;
	}
	
	// 邮箱验证
	var email = document.getElementById("email").value;
	if (email.length == 0) {
		alert("邮箱不能为空!");
		return false;
	}
	
	var email_va = new RegExp("^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$");
	if (!email_va.test(email)) {
		alert("邮箱不合法!");
		return false;
	}
	
	
	// 电话验证
	var phone = document.getElementById("phone").value;
	if (phone.length == 0) {
		alert("电话不能为空!");
		return false;
	}
	
	// 用正则表达式判断数值是否符合规范
	var phone_va = new RegExp("[1][38][0-9]{9}");
	if (!phone_va.test(phone)) {
		alert("电话必须是11位数字!");
		return false;
	}

	// 工资验证
	var salary = document.getElementById("salary").value;
	if (salary.length == 0) {
		alert("工资不能为空!");
		return false;
	}

	return true;
}



/**
 * 用户修改密码验证
 */
function checkpassword() {

	var oldpassword = document.getElementById("oldpassword").value;
	if (oldpassword.length == 0) {
		alert("原密码不能为空!");
		return false;
	}
	

	var newpassword1 = document.getElementById("newpassword1").value;
	if (newpassword1.length == 0) {
		alert("新密码不能为空!");
		return false;
	}
	
	var newpassword2 = document.getElementById("newpassword2").value;
	if (newpassword2.length == 0) {
		alert("重复密码不能为空!");
		return false;
	}
	
	if (newpassword1 != newpassword2) {
		alert("两次密码不一致！");
		return false;
	}
	


	return true;
}