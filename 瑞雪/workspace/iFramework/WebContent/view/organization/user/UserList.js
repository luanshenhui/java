
jQuery(document).ready(function(){
	//显示对话框页面，要放在按钮点击事件的前面，否则dialog不会隐藏
	//组织单元
//	jQuery("#unitDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		resizable : false,
//		height: 'auto',
//		width:410,	
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//		jQuery(this).dialog('close');
//	    },
//	        '清空': function(){
//	    	jQuery("#txtUnitName").val("");
//    		jQuery("#hidUnitID").val("");
//    		jQuery(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["unitFrame"].save(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("unitFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.save();
//	    		if (returnObj){
//		    		var itemId = returnObj.itemId;
//		    		var itemText = returnObj.itemText;
//		    		jQuery("#txtUnitName").val(itemText);
//		    		jQuery("#hidUnitID").val(itemId);
//	    		}	      	
//	    		jQuery(this).dialog('close');  				
//			}			
//		}
//	});
//	//改button文字
//    jQuery(jQuery("button", jQuery("#unitDialog").parent())[2]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#unitDialog").parent())[1]).text(PROMPT_RESET_BUTTON);
//    jQuery(jQuery("button", jQuery("#unitDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
//	//新建用户，修改用户信息
//	jQuery("#addUserDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		height: 'auto',
//		width: 360,
//		resizable : false,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//		jQuery(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["addUserFrame"].saveUser(); //调子页面的保存方法;	  
//	    		var centreFrameObj = window.document.getElementById("addUserFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.save();
//	    		if(checkFlag == "0" || checkFlag == 0){
//		    		if(returnObj != "false"){ //校验不通过，不关闭窗口
//		    			jQuery(this).dialog('close'); 
//		    		}
//	    		}
//	    		if(checkFlag == "1" || checkFlag == 1){
//	    			if(returnObj != "false"){ //校验不通过，不关闭窗口
//	    				if (returnObj){
//	    					//保存成功不刷新
//	    				}
//		    			jQuery(this).dialog('close'); 
//		    		}
//	    		}
//			}			
//		}
//	});
//	jQuery(jQuery("button", jQuery("#addUserDialog").parent())[1]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#addUserDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
	
	//权限调整
//	jQuery("#userPrivAdjustDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		height: 'auto',
//		width:350,
//		resizble:false,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//		jQuery(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["userPrivAdjustFrame"].save(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("userPrivAdjustFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.save();
//	    		if (returnObj){
//	    		}	      	
//	    		jQuery(this).dialog('close');  				
//			}			
//		}
//	});	
//	jQuery(jQuery("button", jQuery("#userPrivAdjustDialog").parent())[1]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#userPrivAdjustDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
//	
	// userDetail.jsp中的方法
//	jQuery("#unitAndStaDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		height: 'auto',
//		width:400,
//		resizable : false,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//		    jQuery(this).dialog('close');
//	    },
//	        '清空': function(){
//	    	//jQuery("#txtUserUnitsStations").val("");
//	    	//jQuery("#txtUserUnitsStationsValue").val("");
//	    	document.frames["addUserFrame"].document.getElementById("txtUserUnitsStations").value="";
//			document.frames["addUserFrame"].document.getElementById("txtUserUnitsStationsValue").value="";
//	    	jQuery(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["unitAndStaFrame"].save(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("unitAndStaFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.save();
//	    		if (returnObj){
//	    			var itemIds = returnObj.itemIds;
//	    			var itemTexts = returnObj.itemTexts;
//	    			document.frames["addUserFrame"].document.getElementById("txtUserUnitsStations").value=itemTexts;
//	    			document.frames["addUserFrame"].document.getElementById("txtUserUnitsStationsValue").value=itemIds;
//	    			//jQuery("#txtUserUnitsStations").val(itemTexts);
//	    			//jQuery("#txtUserUnitsStationsValue").val(itemIds);
//	    		}	      	
//	    		jQuery(this).dialog('close');  				
//			}			
//		}
//	});
//	//改button文字
//    jQuery(jQuery("button", jQuery("#unitAndStaDialog").parent())[2]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#unitAndStaDialog").parent())[1]).text(PROMPT_RESET_BUTTON);
//    jQuery(jQuery("button", jQuery("#unitAndStaDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
//	
//	jQuery("#roleDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		height: 'auto',
//		width:560,
//		resizable : false,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//		jQuery(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["roleFrame"].confirmRoleSelect(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("roleFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.save();
//	    		if (returnObj){
//	    			//alert(returnObj.userIds);
//	    			//alert(returnObj.userTexts);
//	    			var itemIds = returnObj.itemIds;
//	    			var itemTexts = returnObj.itemTexts;
//	    			document.frames["addUserFrame"].document.getElementById("txtUserRoles").value=itemTexts;
//	    			document.frames["addUserFrame"].document.getElementById("txtUserRolesValue").value=itemIds;
//	    			//jQuery("#txtUserRoles").val(itemTexts);
//	    			//jQuery("#txtUserRolesValue").val(itemIds);
//	    		}      	
//	    		jQuery(this).dialog('close');  				
//			}			
//		}
//	});
//	jQuery(jQuery("button", jQuery("#roleDialog").parent())[1]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#roleDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);

});

function clearQueryCondition(){
	jQuery("#hidUnitID").val("");
	jQuery("#txtUnitName").val("");
	jQuery("#txtUserAccount").val("");
	jQuery("#txtUserName").val("");
	jQuery("#cmbLockFlag").val("");
}

function doQuery(queryFormName,listFormName){
	//var queryForm=$(queryFormName);
	var queryPara={
		"forward" : "userList",
		"needUserRole" : "1",//只要有此参数，就表示需要提取用户角色
//		"itemId" : queryForm["hidUnitID"].value,
//		"userAccount" : queryForm["txtUserAccount"].value,
//		"userName" : queryForm["txtUserName"].value != "" ? "%"+queryForm["txtUserName"].value+"%" : ""
		"itemId" : jQuery("#hidUnitID").val(),
		"userAccount" : jQuery("#txtUserAccount").val(),
		"userName" : jQuery("#txtUserName").val(),
		"cmbLockFlag" : jQuery("#cmbLockFlag").val()
	};
	ECSideUtil.queryECForm(listFormName,queryPara,true);
}

var checkFlag;
function addUser(){
	var sendopFlag = 0;
	checkFlag = sendopFlag;
	var sURL = webpath + "/view/organization/user/UserDetail.jsp?sendopFlag="+sendopFlag;
	window.parent.dialogPopup_L2(sURL,USER_DETAIL,330,380,true,"saveUser");
	//var sendPara = new Object();
	//sendPara.opFlag = 0; // 0 为新增保存；1为修改保存
	//var sendopFlag = 0;
	//checkFlag = sendopFlag;
	//var sURL = webpath + "/view/organization/user/UserDetail.jsp?sendopFlag="+sendopFlag;
	//document.getElementById("addUserFrame").src=sURL;				
	//jQuery("#addUserDialog").dialog('open');
	//var returnObj = window.showModalDialog(webpath + '/view/organization/user/UserDetail.jsp',sendPara,'dialogWidth=360px;status:no;scroll:no;dialogHeight=280px');
	//if (returnObj){
		//新建成功以后，没有任何操作。
		//var jsonObj = eval('(' + returnObj + ')');
		//alert(jsonObj.userDetail.userId);
	//}
}

function updateUser(){
	//var sendPara = new Object();
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert(USER_SELECT_USER_TO_EDIT);
		return;
	}
	var selectedUserID = ECSideUtil.getPropertyValue(crow,"userId","ec");
	//sendPara.userID = selectedUserID;
	//sendPara.opFlag = 1; // 0 为新增保存；1为修改保存
	var senduserID = selectedUserID;
	sendopFlag = 1; // 0 为新增保存；1为修改保存
	checkFlag = sendopFlag;
	var sURL = webpath + "/view/organization/user/UserDetail.jsp?sendopFlag="+sendopFlag+"&senduserID="+senduserID;
	window.parent.dialogPopup_L2(sURL,USER_DETAIL,340,360,true,"saveUser");
	//document.getElementById("addUserFrame").src=sURL;				
	//jQuery("#addUserDialog").dialog('open');
//	var returnObj = window.showModalDialog(webpath + '/view/organization/user/UserDetail.jsp',sendPara,'dialogWidth=450px;status:no;scroll:no;dialogHeight=280px');
//	if (returnObj){
//		//保存成功不刷新
//	}
}

function deleteUser(queryFormName,listFormName){
	//存放最终在删除的所有checked用户
	var idString = "";
	//用于存放当前页的id，历史页的id不在这里存放
	var currentPageIDs ="";
	var allcheckarray =ECSideUtil.getPageCheckValue("checkBoxID");
	for(var i=0;i<allcheckarray.length;i++){
		if(allcheckarray[i]== "adminUser"){
			alert(USER_ADMIN_USER_CANT_DELETE);
			return;
		}
	}
	if(allcheckarray)
		currentPageIDs = allcheckarray.join(",");
	//表示hashtable中没有数据
	if (hashTable.hashtable.length == 0){
		idString = currentPageIDs;
	} else {
		//把每一页中选定的那些id都拼成一个串
		for(i=0; i<hashTable.hashtable.length; i++){
			if (hashTable.hashtable[i]){
				idString += hashTable.hashtable[i];
				//alert(idString);
				if (i<hashTable.hashtable.length-1){
					idString += ",";
				}
			}
		}
		if (ECSideUtil.trimString(currentPageIDs) != "")
			idString += ("," + currentPageIDs);
		idString = idString.split(",").uniq().join(",");
		//alert(idString);
	}
	
	//去除空格
	idString = ECSideUtil.trimString(idString);
	if (idString == ","){
		idString = null;
	}
	//删除所选的用户id
	if (idString == null || idString==undefined || idString==""){
		alert(USER_CHOOSE_USER_TO_DELETE);
		return;
	}
//	if (!confirm("确认删除选择的用户吗？"))
//		return;
	confirm(USER_CONFIRM_USER_DELETE,function(){
		var userIds = idString;
		//alert(userName + "，" +  userDesc + "，" + userMax + "，" + isAdminRole + "，" + userUsers + "，" + userUnits)
		var sURL = webpath + "/UserAction.do?method=deleteUser";
		jQuery.ajax( {
			url : sURL,
			type : "post",
			dataType : "json",
			data : {
				userIds : userIds
			},
			success : function(data) {
				if(data.errorMessage==null || data.errorMessage==undefined){
					//删除后重新查询一下，相当于刷新 
					var queryForm=$(queryFormName);
					var queryPara={
						"forward" : "userList",
						"needUserRole" : "1",//只要有此参数，就表示需要提取用户角色
						"itemId" : queryForm["hidUnitID"].value,
						"userAccount" : queryForm["txtUserAccount"].value,
						"userName" : queryForm["txtUserName"].value != "" ? "%"+queryForm["txtRoleName"].value+"%" : ""
					};
					ECSideUtil.queryECForm(listFormName,queryPara,true);
					alert(DELETE_OK);
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
	});
}

function queryUnitSelectCallback(returnValue){
	if (returnValue){
		var itemId = returnValue.itemId;
		var itemText = returnValue.itemText;
		jQuery("#txtUnitName").val(itemText);
		jQuery("#hidUnitID").val(itemId);
	}
}
//选择组织单元
function queryUnitSelect(){
	var sendPara = new Object();
	sendPara.isMultiSelect = false;
	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp";
	window.parent.dialogPopup_L3(sURL,STAT_SELECT_ORG,300,520,true,"save",null,queryUnitSelectCallback);
	//document.getElementById("unitFrame").src=sURL;				
	//jQuery("#unitDialog").dialog('open');
//	var returnObj = window.showModalDialog('../unit/UnitSelect.jsp',sendPara,'dialogWidth=500px;status:no;scroll:no;dialogHeight=400px');
//	if (returnObj){
//		var itemId = returnObj.itemId;
//		var itemText = returnObj.itemText;
//		jQuery("#txtUnitName").val(itemText);
//		jQuery("#hidUnitID").val(itemId);
//	}
}

function userPrivAdjust(){
	//var sendPara = new Object();
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert(USER_SELECT_USER_FIRST);
		return;
	}
	var selectedUserID = ECSideUtil.getPropertyValue(crow,"userId","ec");
	var selectedUserName = ECSideUtil.getPropertyValue(crow,"userFullname","ec");
	//sendPara.userID = selectedUserID;
	//sendPara.userFullName = selectedUserName;
	senduserID = selectedUserID;
	senduserFullName = selectedUserName;
	var sURL = webpath + "/view/organization/user/UserPrivilegeAdjust.jsp?senduserID="+senduserID+"&senduserFullName";
	window.parent.dialogPopup_L2(sURL,USER_ADJUST_PRIVILEGE,400,400,true,"save");
	//document.getElementById("userPrivAdjustFrame").src=sURL;				
	//jQuery("#userPrivAdjustDialog").dialog('open');
}
var isLocked; //为confirm定义全局变量，否则以后传递的变量都是第一次的值。
function lockUser(queryFormName,listFormName){
	var ecsideObj=ECSideUtil.getGridObj(listFormName);
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert(USER_SELECT_USER_FIRST);
		return;
	}
	var selectedUserID = ECSideUtil.getPropertyValue(crow,"userId","ec");
	isLocked = ECSideUtil.getPropertyValue(crow,"userAccountLocked","ec");
	var infoMsg = isLocked == "是" ? USER_UNLOCK_USER : USER_LOCK_USER;
	var messageStr = "";
	if (infoMsg == USER_LOCK_USER)
		messageStr= USER_CONFIRM_LOCK_USER;
	else
		messageStr= USER_CONFIRM_UNLOCK_USER;
	confirm(messageStr,function(){
//	if (!confirm("确认" + infoMsg + "此用户吗？"))
//		return;
	var sURL = webpath + "/UserAction.do?method=lockUser";
	jQuery.ajax( {
		url : sURL,
		type : "post",
		dataType : "json",
		data : {
			userId : selectedUserID,
			isLocked : isLocked
		},
		success : function(data) {
			if(data.errorMessage==null || data.errorMessage==undefined){
				alert(infoMsg + USER_SUCCESS);
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
			//删除后重新查询一下，相当于刷新 
			var queryForm=$(queryFormName);
			var queryPara={
				"forward" : "userList",
				"needUserRole" : "1",//只要有此参数，就表示需要提取用户角色
				"itemId" : queryForm["hidUnitID"].value,
				"userAccount" : queryForm["txtUserAccount"].value,
				"userName" : queryForm["txtUserName"].value != "" ? "%"+queryForm["txtRoleName"].value+"%" : ""
			};
			ECSideUtil.queryECForm(listFormName,queryPara,true);
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert(NET_FAILD);
			// 通常 textStatus 和 errorThrown 之中 
		    // 只有一个会包含信息 
		    //this;  调用本次AJAX请求时传递的options参数
		}
	});
	});
}
//选择组织单元
function unitSelect(){
	//isMultiSelect = true;
	//needStation = true;
	//var sURL = webpath + "/view/organization/unit/UnitSelect.jsp?isMultiSelect="+isMultiSelect+"&needStation="+needStation;
	//document.getElementById("unitAndStaFrame").src=sURL;				
	//jQuery("#unitAndStaDialog").dialog('open');
}


//选择用户
function roleSelect(){
	//var sURL = webpath + "/RoleAction.do?method=getRole&forward=roleSelect";
	//document.getElementById("roleFrame").src=sURL;				
	//jQuery("#roleDialog").dialog('open');
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
