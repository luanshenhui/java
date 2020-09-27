jQuery.csChangePassword={
	bindLabel:function (){
		$.csCore.getValue("Member_CurrentPassword",null,"#lblPassword");
		$.csCore.getValue("Member_NewPassword",null,"#lblNewPassword");
		$.csCore.getValue("Member_NewPasswordConfirm",null,"#lblVerfyNewPassword");
		$.csCore.getValue("Button_Submit",null,"#btnChangePassword");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelPassword");
	},
	bindEvent:function(){
		$("#btnChangePassword").click($.csChangePassword.change);
		$("#btnCancelPassword").click($.csCore.close);
	},
	validate:function (){
		if($.csValidator.checkNull("password",$.csCore.getValue("Common_Required","Member_Password"))){
			return false;
		}
		if($.csValidator.checkNull("newPassword",$.csCore.getValue("Common_Required","Member_NewPassword"))){
			return false;
		}
		if($("#newPassword").val()!=$("#verfyNewPassword").val()){
			$.csCore.alert($.csCore.getValue("Member_PasswordNotMatch"));
			return false;
		}
		return true;
	},
	change:function (){
		if($.csChangePassword.validate()){
			if($.csCore.postData($.csCore.buildServicePath('/service/member/changepassward'), 'form')){
				$.csCore.close();
				$.csCore.alert($.csCore.getValue("Member_PasswordModefySuccess"));
			}
		}
	},
	init:function(){
		$.csChangePassword.bindLabel();
		$.csChangePassword.bindEvent();
	}
};