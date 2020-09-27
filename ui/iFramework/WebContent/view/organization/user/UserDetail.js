(function($) {
	jQuery(document).ready(function() {
		jQuery('body').bind('keydown',shieldCommon);
		//obj = window.dialogArguments;// 定义一个对象用于接收对话框参数
		//opFlag = obj.opFlag;
		//userID = obj.userID;
		opFlag = opFlag;
		userID = userID;
		if (opFlag == 1 || opFlag == "1") {
			//修改状态下，密码不必填
			document.getElementById("pwdStar").style.display="none";
			getExtendDetail();
			showDetail(userID);
		}else if(opFlag==0||opFlag=="0"){
			getExtendDetail();
		}
		
		
		//初始化Tab框
		$('#tabs').tabs();
		//hover states on the static widgets
		$('#dialog_link, ul#icons li').hover(
			function() { $(this).addClass('ui-state-hover'); }, 
			function() { $(this).removeClass('ui-state-hover'); }
		);
		
		//页面控件输入有效性验证
		jQuery("#userDetail").validate({
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
	    		txtUserName: {
					required: true,
					specialCharCheck:true,
					byteRangeLength: [0,20]
				},
				txtUserPassword: {
					required: (opFlag==0||opFlag=="0")?true:false,
					passwordValidate:true,
					byteRangeLength: [0,20]
				},
				txtUserAccount: {
					required: true,
					specialCharCheck:true,
					accountValidate:true,
					byteRangeLength: [4,20]
				},
				txtUserDesc: {
					byteRangeLength: [0,255]
				}
			},
			messages: {
				txtUserName: USER_USERNAME_INVALID,
				txtUserPassword: USER_PASSWORD_INVALID,
				txtUserAccount: USER_ACCOUNT_INVALID,
				txtUserDesc: USER_USERDESC_INVALID
			}
		});
	});	
		
})(jQuery);

//用户名密码只允许输入数字和字符及下划线
jQuery.validator.addMethod("passwordValidate",
		function(value, element) {
	 var regx = /^[a-zA-Z0-9_]{0,}$/; 
	 return regx.test(value);
});

/*
 * 获取扩展信息
 * */
var extendData;
function getExtendDetail(){
	jQuery.ajax({
		url:webpath + "/UserAction.do?method=getExtendDetail",
		type:"post",
		dataType:"json",
		async:false,
		data:{type:"user"}, //给出扩展信息内容类型
		success:function(data)
		{
			extendData = data;
			var obj = data.BizTypeDefine.elementList;
			var strHtml = getExtInfo(obj); //获取extInfo
			jQuery("#dyItem").append(strHtml);
			//为cobbobox赋值
			for(var i = 0 ; i<obj.length; i++){				
				if(obj[i].name !="id"){
					if(obj[i].type=="ComboBox"){
						var myOption=document.getElementById(obj[i].name);
						myOption.options[myOption.options.length]=new Option("","");
						for(var j in obj[i].storeValueMap){
							myOption.options[myOption.options.length]=new Option(obj[i].storeValueMap[j],j);
					    }
					}
				}
			}
		}
	});
}

//显示用户的详细信息
function showDetail(userID) {
	jQuery("#hidUserID").val(userID);
	//根据userID取user的明细
	var sURL1 = webpath + "/UserAction.do?method=getUserDetail";
	jQuery.ajax( {
		url : sURL1,
		type : "post",
		async:false,
		dataType : "json",
		data : {
			userID : userID
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//使用返回的user明细画页面
				jQuery("#txtUserName").val(data.userDetail.userFullname);
				jQuery("#txtUserDesc").val(data.userDetail.userDescription);
				//jQuery("#txtUserPassword").val(data.userDetail.userPassword);
				jQuery("#txtUserAccount").val(data.userDetail.userAccount);
				jQuery("#txtUserRoles").val(data.userRolesVALUE);
				jQuery("#txtUserRolesValue").val(data.userRolesKEY);
				jQuery("#txtUserAdminRole").val(data.userAdminRoleVALUE);
				jQuery("#txtUserAdminRoleValue").val(data.userAdminRoleKEY);
				jQuery("#txtUserUnitsStations").val(data.userUnitsVALUE);
				jQuery("#txtUserUnitsStationsValue").val(data.userUnitsKEY);
				if(userID == "adminUser"){
					jQuery("#txtUserRoles").attr('disabled',true);
					jQuery("#btnRole").attr('disabled',true);
				}
				//给扩展信息赋值
		    	var mapData = data.userDetail.extInfoMap;
		    	var dataExt = extendData;
		    	var obj = dataExt.BizTypeDefine.elementList;
		    	for(var i = 0 ; i<obj.length; i++){				
		    		if(obj[i].name !="id"){
		    			//document.getElementById(obj[i].name).value = mapData[obj[i].name];
		    			var eleId = "#"+obj[i].name;
		    			//jQuery(eleId).val(mapData[obj[i].name]);
		    			if(mapData[obj[i].name] == " "){
		    				jQuery(eleId).val("");
		    			}else{
		    				jQuery(eleId).val(mapData[obj[i].name]);
		    			}
		    		}
		    	}	        	
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
	jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
	if(!jQuery("#userDetail").valid())return false;
	
//	//用户名正则：数字、字符、汉字
//	var objRegExp = /^[0-9a-zA-Z_\u4e00-\u9fa5]+$/;
//	//整数正则（正数、负数、0）
//	var objRegExp2 = /^(\d*|\-?[1-9]{1}\d*)$/;
//	//密码验证正则(只能输入6-20位字母、数字、下划线)
//	var objRegExp3 = /^(\w){1,20}$/;
//	//帐号正则(只能输入4-20位字母、数字、下划线)
//	var objRegExp4 = /^(\w){4,20}$/;
//	
//    var strName = jQuery("#txtUserName").val();
//    var strPassword = jQuery("#txtUserPassword").val();
//    var strAccount = jQuery("#txtUserAccount").val();
//    
//    var charTest = objRegExp.test(strName);
//    var len = jQuery("#txtUserName").val().replace(/[^\x00-\xff]/g,"**").length;
//    if (!charTest || len >20){
//    	jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
//    	alert(USER_USERNAME_INVALID);
//    	jQuery("#txtUserName").focus();
//    	return false;
//    }
//    //只有新建的时候密码才必填，修改密码不必填
//    if(opFlag==0||opFlag=="0"){
//	    charTest = objRegExp3.test(strPassword);
//	    if (!charTest){
//	    	jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
//	    	alert(USER_PASSWORD_INVALID);
//	    	jQuery("#txtUserPassword").focus();
//	    	return false;
//	    }
//    }
//    
//    charTest = objRegExp4.test(strAccount);
//    if (!charTest){
//    	jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
//    	alert(USER_ACCOUNT_INVALID);
//    	jQuery("#txtUserAccount").focus();
//    	return false;
//    }
//    
//    len = jQuery("#txtUserDesc").val().replace(/[^\x00-\xff]/g,"**").length;
//    if (len >254){
//    	jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
//    	alert(USER_USERDESC_INVALID);
//    	jQuery("#txtUserDesc").focus();
//    	return false;
//    }

    return true;
    	
}

/*
 * 校验扩展的数据
 * */
function checkExtendDetail(){
	var data = extendData;
	var obj = data.BizTypeDefine.elementList;
	for(var i = 0 ; i<obj.length; i++){	
		if(obj[i].name !="id"){
			if(obj[i].type=="TextField"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null || value.replace(/[^\x00-\xff]/g,"**").length > 32){
						jQuery("#tabs").tabs('select', 1);  //tab切换
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}
				if(obj[i].regex !="" && value != ""){
					var reg = new RegExp(obj[i].regex);
					if(!reg.test(value)){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();;
						return false;
					}
				}
				if(value.replace(/[^\x00-\xff]/g,"**").length > 32){
					alert(USER_INPUT_LONG);
					document.getElementById(obj[i].name).focus();
					return false;
				}	
			}
          if(obj[i].type=="DateField"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}				
			}
          if(obj[i].type=="NumberField"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null || value.replace(/[^\x00-\xff]/g,"**").length > 5){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}
				if (obj[i].regex !="" && value != ""){
					var reg = new RegExp(obj[i].regex);
					if(!reg.test(value)){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();;
						return false;
					}				
				}
				if(value.replace(/[^\x00-\xff]/g,"**").length > 5){
					jQuery("#tabs").tabs('select', 1);
					alert(USER_INPUT_LONG);
					document.getElementById(obj[i].name).focus();
					return false;
				}
			}
         if(obj[i].type=="ComboBox"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}
			}			
		}
	}
	return true;
}
///*
// * 校验扩展的数据
// * */
//function checkExtendDetail(){
//	var data = extendData;
//	var obj = data.BizTypeDefine.elementList;
//	for(var i = 0 ; i<obj.length; i++){				
//		if(obj[i].name !="id"){
//			if(obj[i].type=="TextField"){
//				var value = document.getElementById(obj[i].name).value;
//				if(obj[i].allowBlank=="true"){
//					if(value =="" || value == null || value.replace(/[^\x00-\xff]/g,"**").length > 32){
//						jQuery("#tabs").tabs('select', 1);  //tab切换
//						alert(obj[i].errorInfoText);
//						document.getElementById(obj[i].name).focus();
//						return false;
//					}
//					if(obj[i].regex !=""){
//						var reg = new RegExp(obj[i].regex);
//						if(!reg.test(value)){
//							jQuery("#tabs").tabs('select', 1);
//							alert(obj[i].errorInfoText);
//							document.getElementById(obj[i].name).focus();;
//							return false;
//						}
//					}
//				}	
//			}else if(obj[i].type=="DateField"){
//				var value = document.getElementById(obj[i].name).value;
//				if(obj[i].allowBlank=="true"){
//					if(value =="" || value == null){
//						jQuery("#tabs").tabs('select', 1);
//						alert(obj[i].errorInfoText);
//						document.getElementById(obj[i].name).focus();
//						return false;
//					}
//				}
//				
//			}else if(obj[i].type=="NumberField"){
//				var value = document.getElementById(obj[i].name).value;
//				var reg = new RegExp(obj[i].regex);
//				if(obj[i].allowBlank=="true"){
//					if(value =="" || value == null || value.replace(/[^\x00-\xff]/g,"**").length > 5){
//						jQuery("#tabs").tabs('select', 1);
//						alert(obj[i].errorInfoText);
//						document.getElementById(obj[i].name).focus();
//						return false;
//					}
//				}
//				if(!reg.test(value)){
//					jQuery("#tabs").tabs('select', 1);
//					alert(obj[i].errorInfoText);
//					document.getElementById(obj[i].name).focus();;
//					return false;
//				}
//			}else if(obj[i].type=="ComboBox"){
//				var value = document.getElementById(obj[i].name).value;
//				if(obj[i].allowBlank=="true"){
//					if(value =="" || value == null){
//						jQuery("#tabs").tabs('select', 1);
//						alert(obj[i].errorInfoText);
//						document.getElementById(obj[i].name).focus();
//						return false;
//					}
//				}
//			}
//			return true;
//		}
//	}	
//}

//保存用户修改
function saveUser() {
	console.log(2222222222222)
	var blnReturn = "false";
	//有效性检查没有通过不能保存
	if(!(checkValidate() && checkExtendDetail())){
		blnReturn = "false";
		return blnReturn;
	}		
	if (opFlag == 0 || opFlag == "0") {
		var userName = jQuery("#txtUserName").val();
		var userDesc = jQuery("#txtUserDesc").val();
		var userPass = jQuery("#txtUserPassword").val();
		var userAccount = jQuery("#txtUserAccount").val();
		var userRoles = jQuery("#txtUserRolesValue").val();
		if (jQuery("#txtUserRolesValue").val().length > 0) {
			userRoles = userRoles + "," + jQuery("#txtUserAdminRoleValue").val();
		} else {
			userRoles = jQuery("#txtUserAdminRoleValue").val();
		}
		var userUnits = jQuery("#txtUserUnitsStationsValue").val();
		//序列化扩展信息
	    var extInfo = jQuery("form").serialize();
	    extInfo = decodeURIComponent(extInfo,true);//对序列后信息进行解码，以解决乱码问题。但是时间中的空格问题无法解决
		//alert(userName + "，" +  userDesc + "，" + userMax + "，" + isAdminUser + "，" + userUsers + "，" + userUnits)
		var sURL = webpath + "/UserAction.do?method=saveUser";
		// 调用AJAX请求函数
		jQuery.ajax( {
			url : sURL,
			type : "post",
			async : false,
			dataType : "json",
			data : {
				userName : userName,
				userDesc : userDesc,
				userPass : userPass,
				userAccount : userAccount,
				userRoles : userRoles,
				userUnits : userUnits,
				opFlag : "0",
				extInfo:extInfo
			},
			success : function(data) {
				if(data.errorMessage==undefined){
					//window.returnValue = data;
					alert(SAVE_OK);
					//window.close();
					blnReturn = data;
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
					blnReturn = "false";
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert(NET_FAILD);
				blnReturn = "false";
			}
		});
	} else if (opFlag == 1 || opFlag == "1") {
		//保存对用户的修改
		var sURL1 = webpath + "/UserAction.do?method=saveUser";
		var userName = jQuery("#txtUserName").val();
		var userDesc = jQuery("#txtUserDesc").val();
		var userPass = jQuery("#txtUserPassword").val();
		var userAccount = jQuery("#txtUserAccount").val();
		var userRoles = jQuery("#txtUserRolesValue").val();
		if (jQuery("#txtUserAdminRoleValue").val().length > 0){
			if (jQuery("#txtUserRolesValue").val().length > 0) {
				userRoles = userRoles + "," + jQuery("#txtUserAdminRoleValue").val();
			} else {
				userRoles = jQuery("#txtUserAdminRoleValue").val();
			}
		}
		var userUnits = jQuery("#txtUserUnitsStationsValue").val();
		//序列化扩展信息
	    var extInfo = jQuery("form").serialize();
	    extInfo = decodeURIComponent(extInfo,true);//对序列后信息进行解码，以解决乱码问题。但是时间中的空格问题无法解决。
	    //alert(userName + "，" +  userDesc + "，" + userMax + "，" + isAdminUser + "，" + userUsers + "，" + userUnits)
		var sURL = webpath + "/UserAction.do?method=saveUser";
		jQuery.ajax( {
			url : sURL1,
			type : "post",
			async : false,
			dataType : "json",
			data : {
				userName : userName,
				userDesc : userDesc,
				userPass : userPass,
				userAccount : userAccount,
				userRoles : userRoles,
				userUnits : userUnits,
				userId : userID,
				opFlag : "1",
				extInfo : extInfo
			},
			success : function(data) {
				if(data.errorMessage==null || data.errorMessage==undefined){
					alert(SAVE_OK);
					blnReturn = data;
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
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
	if (returnValue){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtUserUnitsStations").val(itemTexts);
		jQuery("#txtUserUnitsStationsValue").val(itemIds);
	}
}
//选择组织单元
function unitSelect(){
	isMultiSelect = true;
	needStation = true;
	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp?isMultiSelect="+isMultiSelect+"&needStation="+needStation;
	window.parent.dialogPopup_L3(sURL,STAT_SELECT_ORG,300,520,true,"save",null,unitSelectCallback);
	//window.parent.unitSelect();
	//var sendPara = new Object();
	//sendPara.isMultiSelect = true;
	//sendPara.needStation = true;
//	isMultiSelect = true;
//	needStation = true;
//	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp?isMultiSelect="+isMultiSelect+"&needStation="+needStation;
//	document.getElementById("unitAndStaFrame").src=sURL;				
//	jQuery("#unitAndStaDialog").dialog('open');
//	var returnObj = window.showModalDialog('../unit/UnitSelect.jsp',sendPara,'dialogWidth=500px;status:no;scroll:no;dialogHeight=400px');
//	if (returnObj){
//		var itemIds = returnObj.itemIds;
//		var itemTexts = returnObj.itemTexts;
//		jQuery("#txtUserUnitsStations").val(itemTexts);
//		jQuery("#txtUserUnitsStationsValue").val(itemIds);
//	}
}

//roleSelect 的回调函数
function roleSelectCallback(returnValue){
	if (returnValue){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtUserRoles").val(itemTexts);
		jQuery("#txtUserRolesValue").val(itemIds);
	}
}
//选择业务角色
function roleSelect(){
	var sURL = webpath + "/RoleAction.do?method=getRole&forward=roleSelect&isAdminRole=false";
	window.parent.dialogPopup_L3(sURL,ROLE_BIZROLE_SELECT,420,570,true,"confirmRoleSelect",null,roleSelectCallback);
	//window.parent.roleSelect();
//	var sURL = webpath + "/RoleAction.do?method=getRole&forward=roleSelect";
//	document.getElementById("roleFrame").src=sURL;				
//	jQuery("#roleDialog").dialog('open');
//	var returnObj = window.showModalDialog(webpath + '/RoleAction.do?method=getRole&forward=roleSelect',null,'dialogWidth=500px;status:no;scroll:no;dialogHeight=380px');
//	if (returnObj){
//		//alert(returnObj.userIds);
//		//alert(returnObj.userTexts);
//		var itemIds = returnObj.itemIds;
//		var itemTexts = returnObj.itemTexts;
//		jQuery("#txtUserRoles").val(itemTexts);
//		jQuery("#txtUserRolesValue").val(itemIds);
//	}
}

//roleSelect 的回调函数
function adminRoleSelectCallback(returnValue){
	if (returnValue){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtUserAdminRole").val(itemTexts);
		jQuery("#txtUserAdminRoleValue").val(itemIds);
	}
}
//选择管理角色
function adminRoleSelect(){
	var sURL = webpath + "/RoleAction.do?method=getRole&forward=adminRoleSelect&isAdminRole=true";
	window.parent.dialogPopup_L3(sURL,ROLE_ADMINROLE_SELECT,400,570,true,"confirmRoleSelect",null,adminRoleSelectCallback);
}