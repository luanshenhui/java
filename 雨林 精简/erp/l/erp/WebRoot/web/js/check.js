/**
 * �û�����֤
 */
function checkpersonedit() {

	// �û�����֤
	var username = document.getElementById("username").value;
	if (username.length == 0) {
		alert("�û�������Ϊ��!");
		return false;
	}
	
	// ������֤
	var age = document.getElementById("age").value;
	if (age.length == 0) {
		alert("���䲻��Ϊ��!");
		return false;
	}
	
	var age_va = new RegExp("^[0-9]{1,2}$");
	if (!age_va.test(age)) {
		alert("���������2λ����!");
		return false;
	}
	
	// ������֤
	var email = document.getElementById("email").value;
	if (email.length == 0) {
		alert("���䲻��Ϊ��!");
		return false;
	}
	
	var email_va = new RegExp("^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$");
	if (!email_va.test(email)) {
		alert("���䲻�Ϸ�!");
		return false;
	}
	
	
	// �绰��֤
	var phone = document.getElementById("phone").value;
	if (phone.length == 0) {
		alert("�绰����Ϊ��!");
		return false;
	}
	
	// ��������ʽ�ж���ֵ�Ƿ���Ϲ淶
	var phone_va = new RegExp("[1][38][0-9]{9}");
	if (!phone_va.test(phone)) {
		alert("�绰������11λ����!");
		return false;
	}

	// ������֤
	var salary = document.getElementById("salary").value;
	if (salary.length == 0) {
		alert("���ʲ���Ϊ��!");
		return false;
	}

	return true;
}



/**
 * �û��޸�������֤
 */
function checkpassword() {

	var oldpassword = document.getElementById("oldpassword").value;
	if (oldpassword.length == 0) {
		alert("ԭ���벻��Ϊ��!");
		return false;
	}
	

	var newpassword1 = document.getElementById("newpassword1").value;
	if (newpassword1.length == 0) {
		alert("�����벻��Ϊ��!");
		return false;
	}
	
	var newpassword2 = document.getElementById("newpassword2").value;
	if (newpassword2.length == 0) {
		alert("�ظ����벻��Ϊ��!");
		return false;
	}
	
	if (newpassword1 != newpassword2) {
		alert("�������벻һ�£�");
		return false;
	}
	


	return true;
}