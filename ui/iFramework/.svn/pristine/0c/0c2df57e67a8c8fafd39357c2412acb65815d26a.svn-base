$(function() {
	//生成修改密码dialog
	generateChangePasswordDialog();
});

function generateChangePasswordDialog() {
	$("#passwordDiv").dialog("destroy");
	var webpath = $("#webpath").val();	
	var fieldOldPassword = jQuery("#oldPassword");
	var fieldNewPassword = jQuery("#newPassword");
	var fieldConfirmPassword = jQuery("#confirm_password");
	var allFields = $([]).add(fieldOldPassword).add(fieldNewPassword).add(fieldConfirmPassword);
	
	var $dialog = $("#passwordDiv")
		.dialog({
			autoOpen: false,
			title: Consts.Password.title,
			modal: true,
			buttons: {
				"cancel": function() {
					initDialog();
					$(this).dialog('close');
				},
				"confirm": function() {
					allFields.removeClass('ui-state-error');
					var bValid = true;					
					bValid = bValid && checkMandatory(fieldOldPassword,Consts.Password.field_oldPassword);
					bValid = bValid && checkMandatory(fieldNewPassword,Consts.Password.field_newPassword);
					bValid = bValid && checkMandatory(fieldConfirmPassword,Consts.Password.field_confirmPassword);
					if(bValid){
						bValid = bValid && securityCheck();
					}
					if (bValid) {
						bValid = bValid && checkLength(fieldNewPassword,Consts.Password.field_newPassword,5);
						bValid = bValid && checkLength(fieldConfirmPassword,Consts.Password.field_confirmPassword,5);
						if (bValid) {
							bValid = bValid && checkConfirmPassword(fieldNewPassword, fieldConfirmPassword);
						}
					}
					if (bValid){
						updateTips("");
						$("#error").removeClass('ui-state-highlight');
						var oldPassword = jQuery("#oldPassword").val();
						var newPassword = jQuery("#newPassword").val();
						jQuery.ajax({
							url:webpath + "/MainAction.do?method=changePassword",
							type:"post",
							async: false,
							dataType:"String",
							data:{oldPassword:oldPassword,newPassword:newPassword}, 
							success:function(msg)
					        {  	
								if ("success" == msg.substr(0,7)) {
									$dialog.dialog("close");
									$confirmDialog = $("<div>"+Consts.Password.message_success+"</div>")
										.dialog({
											autoOpen: false,
											title: Consts.Password.title,
											modal: true,
											buttons: {
												"confirm": function() {
													$(this).dialog('close');
												}
											}
										}).dialog("open");
									$confirmDialog.parent().children().last().children("button:eq(0)").text(Consts.Password.button_confirm);
								} else {
									updateTips(msg);
								}
					        }
						});
					}
				}
			},
			open:function(){
				$(this).parent().children().last().children("button:eq(0)").text(Consts.Password.button_cancel);
				$(this).parent().children().last().children("button:eq(1)").text(Consts.Password.button_confirm);
			},
			close: function() {
				initDialog();
			}
		});
	function initDialog() {
		allFields.removeClass('ui-state-error');
		updateTips("");
		$("#error").removeClass('ui-state-highlight');
		fieldOldPassword.val("");
		fieldNewPassword.val("");
		fieldConfirmPassword.val("");
	}
	function checkMandatory(o,field) {
		if (o.val()==null || o.val().length==0) {
			o.addClass('ui-state-error');
			updateTips(Consts.Password.message_pleaseEnter+field);
			return false;
		} else {
			return true;
		}
	};
	function checkLength(o,field,min) {
		if ( o.val().length < min ) {
			o.addClass('ui-state-error');
			updateTips(field+Consts.Password.message_atLeast+min);
			return false;
		} else {
			return true;
		}
	};
	function checkConfirmPassword(oldPassword, newPassword) {
		if (oldPassword.val() != newPassword.val()) {
			updateTips(Consts.Password.message_mustSamePassword);
			return false;
		} else {
			return true;
		}
	};
	function securityCheck(){	
		var regx = /^[a-zA-Z0-9_]{1,}$/; 
		var error = 0;
		if(!regx.test($("#oldPassword").val())){
			$("#oldPassword").addClass('ui-state-error');			
			error = error+1;
		}
		if(!regx.test($("#newPassword").val())){
			$("#newPassword").addClass('ui-state-error');			
			error = error+1;
		}
		if(!regx.test($("#confirm_password").val())){
			$("#confirm_password").addClass('ui-state-error');			
			error = error+1;
		}		
		if(error>0){
			updateTips(Consts.Password.message_security_check);
			return false;
			}else 
				return true; 
	};

	function updateTips(t) {
		$("#error")
			.text(t)
			.addClass('ui-state-highlight');
	};
};

function openChangePasswordDialog() {
	$("#passwordDiv").dialog('open');
};
