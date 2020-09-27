(function($) {
	jQuery(document).ready(function() {
		jQuery('body').bind('keydown',shieldCommon);
		//obj = window.dialogArguments;// 定义一个对象用于接收对话框参数
		//opFlag = obj.opFlag;
		//roleID = obj.roleID;
		if (opFlag == 1 || opFlag == "1") {
			showDetail(roleID);
		}
		//判断登录人员的控件可见范围
	    if(hasAdminRole == "false"){
	    	jQuery("#selIsAdminRole").attr('disabled',true);
			jQuery("#txtRoleUnits").attr('disabled',true);
			jQuery("#btnDot2").attr('disabled',true);
		}
		//页面控件输入有效性验证
	    jQuery("#detailForm").validate({
			errorClass : "error2",
			errorElement : "div",
			highlight : function(element, errorClass) {
	    		jQuery(element).addClass(errorClass);
	    		jQuery("#error_" + element.id).show();
			},
			unhighlight : function(element, errorClass) {
				jQuery(element).removeClass(errorClass);
				jQuery("#img_" + element.id).remove();
				jQuery("#error_" + element.id).remove();
			},
			showErrors : function(error, element) {
				var _this = this;
				showErrorsWithPosition(error, element, _this, webpath);
			},
			rules: {
	    		txtRoleName: {
					required: true,
					specialCharCheck:true,
					byteRangeLength: [0,32]
				},
				txtRoleDesc: {
					byteRangeLength: [0,255]
				},
				txtMax: {
					required : true,
					range : [-1,65535],
					integerValidate : true
				}
			},
			messages: {
				txtRoleName: ROLENAME_PROMPT_INFO,				
				txtRoleDesc: ROLEDESC_PROMPT_INFO,
				txtMax : MAXUSERS_PROMPT_INFO
			}
		});
	    //修改可管理组织的可用状态
	    adminRoleChange();
	});
})(jQuery);

//验证-1,0,正整数
jQuery.validator.addMethod("integerValidate",
		function(value, element) {
	 var regx = /^[0-9]\d*$/; 
	 return (regx.test(value) || value=="-1");
});

function adminRoleChange(){
	var temp = jQuery("#selIsAdminRole").val();
	if(temp == "是"){
		jQuery("#txtRoleUnits").attr('disabled',false);
		jQuery("#btnDot2").attr('disabled',false);
	} else {
		jQuery("#txtRoleUnits").val("");
		jQuery("#txtRoleUnitsValue").val("");
		jQuery("#txtRoleUnits").attr('disabled',true);
		jQuery("#btnDot2").attr('disabled',true);
	}
}

//显示角色的详细信息
function showDetail(roleID) {
	jQuery("#hidRoleID").val(roleID);
	//根据roleID取role的明细
	var sURL1 = webpath + "/RoleAction.do?method=getRoleDetail";
	jQuery.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		data : {
			roleID : roleID
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//使用返回的role明细画页面
				if(data.roleDetail.roleId == "adminRole"){
					jQuery("#selIsAdminRole").attr('disabled',true);
				}
				jQuery("#txtRoleName").val(data.roleDetail.roleName);
				jQuery("#txtRoleDesc").val(data.roleDetail.roleDescription);
				jQuery("#txtMax").val(data.roleDetail.userNumbers);
				jQuery("#selIsAdminRole").val(data.roleDetail.isAdminrole);
				jQuery("#selIsAdminRole").attr('disabled',true);
				jQuery("#txtRoleUsers").val(data.roleUsersVALUE);
				jQuery("#txtRoleUsersValue").val(data.roleUsersKEY);
				jQuery("#txtRoleUnits").val(data.roleManageUnitsVALUE);
				jQuery("#txtRoleUnitsValue").val(data.roleManageUnitsKEY);
				//修改可管理组织单元的状态
				adminRoleChange();
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert(NET_FAILD);
			// 通常 textStatus 和 errorThrown 之中 
		    // 只有一个会包含信息 
		    //this;  调用本次AJAX请求时传递的options参数
		}
	});
}

//输入有效性校验
function checkValidate(){
	if(!jQuery("#detailForm").valid())return false;
	
//	var detailForm;
//	eval('detailForm = document.detailForm');
//	if(!g_check.checkForm(detailForm)){
//		//alert(g_check.message);
//		return false;
//	}
	
//	//数字、字符、汉字
//	var objRegExp = /^[0-9a-zA-Z_\u4e00-\u9fa5]+$/;
//	//整数
//	var objRegExp2 = /^(\d*|\-?[1-9]{1}\d*)$/;
//    var strText1 = jQuery("#txtRoleName").val();
//    var strMax = jQuery("#txtMax").val();
//    var charTest = objRegExp.test(strText1);
//    var len = jQuery("#txtRoleName").val().replace(/[^\x00-\xff]/g,"**").length;
//    if (!charTest || len >32){
//    	alert(ROLENAME_PROMPT_INFO);
//    	jQuery("#txtRoleName").focus();
//    	return false;
//    }
//    len = jQuery("#txtRoleDesc").val().replace(/[^\x00-\xff]/g,"**").length;
//    if (len >254){
//    	alert(ROLEDESC_PROMPT_INFO);
//    	jQuery("#txtRoleDesc").focus();
//    	return false;
//    }
//    charTest = objRegExp2.test(strMax);
//    len = jQuery("#txtMax").val().replace(/[^\x00-\xff]/g,"**").length;
//    if (!charTest || len >10){
//    	alert(MAXUSERS_PROMPT_INFO);
//    	jQuery("#txtMax").focus();
//    	return false;
//    }
    return true;
    	
}

//保存角色修改
function saveRole() {
	var blnReturn = "false";
	//有效性检查没有通过不能保存
	if(!checkValidate())
		return "false";
	if (opFlag == 0 || opFlag == "0") {
		var roleName = jQuery("#txtRoleName").val();
		var roleDesc = jQuery("#txtRoleDesc").val();
		var roleMax = jQuery("#txtMax").val();
		var isAdminRole = jQuery("#selIsAdminRole").find("option:selected").text();
		var roleUsers = jQuery("#txtRoleUsersValue").val();
		var roleUnits = jQuery("#txtRoleUnitsValue").val();
		//alert(roleName + "，" +  roleDesc + "，" + roleMax + "，" + isAdminRole + "，" + roleUsers + "，" + roleUnits)
		var sURL = webpath + "/RoleAction.do?method=saveRole";
		// 调用AJAX请求函数
		jQuery.ajax( {
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : {
				roleName : roleName,
				roleDescription : roleDesc,
				roleMax : roleMax,
				isAdminrole : isAdminRole,
				roleUsers : roleUsers,
				roleUnits : roleUnits,
				opFlag : "0"
			},
			success : function(data) {
				if (data.indexOf("session timeout") != -1)
					top.location.href = webpath + "/login.jsp";
				var obj = eval('(' + data + ')');  //转换json
				if(obj.errorMessage==undefined){
					//window.returnValue = data;
					alert(SAVE_OK);
					//window.close();
					blnReturn = "true";
				} else {
					alert(obj.errorMessage);
					blnReturn = "false";
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert(NET_FAILD);
				blnReturn = "false";
			}
		});
	} else if (opFlag == 1 || opFlag == "1") {
		//保存对角色的修改
		var sURL1 = webpath + "/RoleAction.do?method=saveRole";
		var roleName = jQuery("#txtRoleName").val();
		var roleDesc = jQuery("#txtRoleDesc").val();
		var roleMax = jQuery("#txtMax").val();
		var isAdminRole = jQuery("#selIsAdminRole").find("option:selected").text();
		var roleUsers = jQuery("#txtRoleUsersValue").val();
		var roleUnits = jQuery("#txtRoleUnitsValue").val();
		//alert(roleName + "，" +  roleDesc + "，" + roleMax + "，" + isAdminRole + "，" + roleUsers + "，" + roleUnits)
		var sURL = webpath + "/RoleAction.do?method=saveRole";
		jQuery.ajax( {
			url : sURL1,
			async : false,
			type : "post",
			dataType : "text",
			data : {
				roleName : roleName,
				roleDescription : roleDesc,
				roleMax : roleMax,
				isAdminrole : isAdminRole,
				roleUsers : roleUsers,
				roleUnits : roleUnits,
				roleId : roleID,
				opFlag : "1"
			},
			success : function(data) {
				if (data.indexOf("session timeout") != -1)
					top.location.href = webpath + "/login.jsp";
				var obj = eval('(' + data + ')');  //转换json
				if(obj.errorMessage==null || obj.errorMessage==undefined){
					alert(SAVE_OK);
					//window.close();
					blnReturn = "true";
				} else {
					alert(obj.errorMessage);
					blnReturn = "false";
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert(NET_FAILD);
				blnReturn = "false";
				// 通常 textStatus 和 errorThrown 之中 
			    // 只有一个会包含信息 
			    //this;  调用本次AJAX请求时传递的options参数
			}
		});
	}
	return blnReturn;
}

//关闭窗体
function closeWin() {
	window.close();
}

//unitSelect 的回调函数
function unitSelectCallback(returnValue){
	var itemIds = returnValue.itemIds;
	var itemTexts = returnValue.itemTexts;
	document.getElementById("txtRoleUnits").value=itemTexts;
	document.getElementById("txtRoleUnitsValue").value=itemIds;
}
//选择组织单元
function unitSelect1(){
	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp?isMultiSelect=true";
	window.parent.dialogPopup_L3(sURL,STAT_SELECT_ORG,340,420,true,"save",null,unitSelectCallback);
	//window.parent.unitSelect();
	//var centreFrameObj = window.document.getElementById("PopupBoxIframe_L3"); //下面的兼容IE和firefox
	//var returnValue = centreFrameObj.contentWindow.unitSelect();
	//var sURL = webpath + "/view/organization/unit/UnitSelect.jsp?isMultiSelect=true";
	//window.parent.document.getElementById("unitSelectFrame").src=sURL;				
	//jQuery(window.parent.document).find("#unitSelectDialog").dialog('open');
	//var sendPara = new Object();
	//sendPara.isMultiSelect = true;
	//var returnObj = window.showModalDialog('../unit/UnitSelect.jsp',sendPara,'dialogWidth=500px;status:no;scroll:no;dialogHeight=400px');
	//if (returnObj){
	//	var itemIds = returnObj.itemIds;
	//	var itemTexts = returnObj.itemTexts;
	//	jQuery("#txtRoleUnits").val(itemTexts);
	//	jQuery("#txtRoleUnitsValue").val(itemIds);
	//}
}


//unitSelect 的回调函数
function userSelectCallback(returnValue){
	var itemIds = returnValue.itemIds;
	var itemTexts = returnValue.itemTexts;
	document.getElementById("txtRoleUsers").value=itemTexts;
	document.getElementById("txtRoleUsersValue").value=itemIds;
}
//选择用户
function userSelect(){
	//2011/08/02  Tue wxy URI是有长度限制的(operta4k,ie2k,ff10k)，如果有一天超长了会出错，需要在后台重新查询了
	var roleUserIDs = document.getElementById("txtRoleUsersValue").value;
	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelect&stationUserIDs=" + roleUserIDs;
	window.parent.dialogPopup_L3(sURL,STAT_USER_SELECT,450,480,true,"confirmUserSelect",null,userSelectCallback);
	//var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelect";
	//window.parent.document.getElementById("userSelectFrame").src=sURL;
	//debugger;
	//jQuery(window.parent.document).find("#userSelectDialog").dialog('open');
	//var returnObj = window.showModalDialog(webpath + '/UserAction.do?method=getUser&forward=userSelect',null,'dialogWidth=500px;status:no;scroll:no;dialogHeight=380px');
	//if (returnObj){
		//alert(returnObj.userIds);
		//alert(returnObj.userTexts);
	//	var itemIds = returnObj.itemIds;
	//	var itemTexts = returnObj.itemTexts;
	//	jQuery("#txtRoleUsers").val(itemTexts);
	//	jQuery("#txtRoleUsersValue").val(itemIds);
	//}
}