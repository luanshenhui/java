$(document).ready(function (){
	jQuery.csBinding.init();
});
jQuery.csBinding = {
	bindEvent: function() {
//		var url = document.location.href;
//		var srUserName = url.substring(url.indexOf("=")+1,url.length);
//		$("#srUserName").html("欢迎，"+srUserName);
//		$("#userbinding").click($.csBinding.bindingMember);
	},
	validate: function() {
		if ($.csValidator.checkNull("hlUserName", $.csCore.getValue("Common_Required", "Member_Username"))) {
			return false;
		}
		if ($.csValidator.checkNull("hlPassWord", $.csCore.getValue("Common_Required", "Member_Password"))) {
			return false;
		}
		if ($.csValidator.checkNull("hlPassWordTwo", $.csCore.getValue("Common_Required", "Member_NewPasswordConfirm"))) {
			return false;
		}
		if($("#hlPassWord").val() != $("#hlPassWordTwo").val()){
			$.csCore.alert($.csCore.getValue("Member_PasswordNotMatch"));
			return false;
		}
	},
	bindingMember : function(){//绑定 --> 登录
		if($.csBinding.validate() == false){
			return false;
		}
		var param = $.csControl.appendKeyValue('', 'username', $("#hlUserName").val());
		param = $.csControl.appendKeyValue(param, 'password', $("#hlPassWord").val());
		var datas = $.csCore.invoke($.csCore.buildServicePath('/member/memberbinding'), param);
		var data = datas.split(":");
		if (data[0] == "OK"){
			document.location.href = data[1];
			$.csBinding.returnSR();//返回绑定信息给善融商务
		}else{
			$.csCore.alert(data[0]);
		}
	},
	returnSR : function(){
		$.csCore.invoke($.csCore.buildServicePath('/member/memberbindingtosr'));
	},
	init : function(){
		$.csBinding.bindEvent();
	}
};
