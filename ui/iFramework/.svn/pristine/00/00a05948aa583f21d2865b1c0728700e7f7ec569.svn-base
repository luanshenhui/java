jQuery(document).ready(function(){
	//显示对话框
   // var checkFlag; //判断是修改保存还是新建保存，用以区分修改节点的后重画的方式
//    jQuery("#delegateDetailDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		resizable : false,
//		height: 'auto',
//		width: 380,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//				jQuery(this).dialog('close');
//    		},
//			'保存 ': function() {
//	    		//var returnValue = document.frames["delegateDetailFrame"].saveDelegate(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("delegateDetailFrame");//兼容IE与firefox
//	    		var returnValue = centreFrameObj.contentWindow.saveDelegate();
//	    		if(returnValue || returnValue == "true"){  //保存失败不自动关闭页面
//	    			jQuery(this).dialog('close');  				
//	    		}
//	    	}
//		}
//	});
//    jQuery(jQuery("button", jQuery("#delegateDetailDialog").parent())[1]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#delegateDetailDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);

  //包含人员，对话框
//	jQuery("#userSelectDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		resizable : false,
//		height: 'auto',
//		width:540,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//				jQuery(this).dialog('close');
//    		},
//			'确定 ': function() {
//	    		//var returnValue = document.frames["userSelectFrame"].confirmUserSelect(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("userSelectFrame");//兼容IE与firefox
//	    		var returnValue = centreFrameObj.contentWindow.confirmUserSelect();
//	    		if (returnValue || returnValue == "true"){
//	    			var itemIds = returnValue.itemIds;
//	    			var itemTexts = returnValue.itemTexts;
//	    			document.frames["delegateDetailFrame"].document.getElementById("txtTrustor").value=itemTexts;
//	    			document.frames["delegateDetailFrame"].document.getElementById("hidTrustorId").value=itemIds;
//	    			jQuery(this).dialog('close');
//	    		}
//	    	}
//		}
//	});
//	jQuery(jQuery("button", jQuery("#userSelectDialog").parent())[1]).text(PROMPT_OK_BUTTON);
//    jQuery(jQuery("button", jQuery("#userSelectDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
//	
//	jQuery("#deleSelectDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		resizable : false,
//		height: 'auto',
//		width:550,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//				jQuery(this).dialog('close');
//    		},
//			'确定 ': function() {
//	    		//var returnValue = document.frames["deleSelectFrame"].confirmUserSelect(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("deleSelectFrame");//兼容IE与firefox
//	    		var returnValue = centreFrameObj.contentWindow.confirmUserSelect();
//	    		if (returnValue || returnValue == "true"){
//	    			var itemIds = returnValue.itemIds;
//	    			var itemTexts = returnValue.itemTexts;
//	    			document.getElementById("selDelegateUser").value=itemTexts;
//	    			document.getElementById("hidDeleId").value=itemIds;
//	    			jQuery(this).dialog('close');
//	    		}
//	    	}
//		}
//	});
//	jQuery(jQuery("button", jQuery("#deleSelectDialog").parent())[1]).text(PROMPT_OK_BUTTON);
//    jQuery(jQuery("button", jQuery("#deleSelectDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
//	
//	jQuery("#trustorSelectDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		resizable : false,
//		height: 'auto',
//		width:550,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//				jQuery(this).dialog('close');
//    		},
//			'确定 ': function() {
//	    		//var returnValue = document.frames["trustorSelectFrame"].confirmUserSelect(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("trustorSelectFrame");//兼容IE与firefox
//	    		var returnValue = centreFrameObj.contentWindow.confirmUserSelect();
//	    		if (returnValue || returnValue == "true"){
//	    			var itemIds = returnValue.itemIds;
//	    			var itemTexts = returnValue.itemTexts;
//	    			document.getElementById("selTrustorUser").value=itemTexts;
//	    			document.getElementById("hiddenTrustorId").value=itemIds;
//	    			jQuery(this).dialog('close');
//	    		}
//	    	}
//		}
//	});
//	jQuery(jQuery("button", jQuery("#trustorSelectDialog").parent())[1]).text(PROMPT_OK_BUTTON);
//    jQuery(jQuery("button", jQuery("#trustorSelectDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
});
function clearQueryCondition(){
	jQuery("#txtDelegateName").val("");
	jQuery("#hidDeleId").val("");
	jQuery("#selDelegateUser").val("");
	jQuery("#hiddenTrustorId").val("");
	jQuery("#selTrustorUser").val("");
}

function doQuery(queryFormName,listFormName){
	var queryPara={
			"delegateName" : jQuery("#txtDelegateName").val(),
			"delegateUser" : jQuery("#hidDeleId").val(),
			"trustorUser" : jQuery("#hiddenTrustorId").val()
		};
//	var queryForm=$(queryFormName);
//	var delegateUser = jQuery("#selDelegateUser").val();
//	var trustorUser = jQuery("#selTrustorUser").val();
//	if(delegateUser == ""){
//		jQuery("#hidDeleId").val("");
//	}
//	if(trustorUser == ""){
//		jQuery("#hiddenTrustorId").val("");
//	}
//	var queryPara={
////		"delegateName" : queryForm["txtDelegateName"].value != "" ? "%"+queryForm["txtDelegateName"].value+"%" : "",
////		"delegateUser" : queryForm["selDelegateUser"].value != "" ? "%"+queryForm["selDelegateUser"].value+"%" : "",
////		"trustorUser" : queryForm["selTrustorUser"].value != "" ? "%"+queryForm["selTrustorUser"].value+"%" : ""				
//		"delegateName" : queryForm["txtDelegateName"].value ,
//		"delegateUser" : queryForm["hidDeleId"].value ,
//		"trustorUser" : queryForm["hiddenTrustorId"].value 				
//	};
	ECSideUtil.queryECForm(listFormName,queryPara,true);
}
/*
 * 新建
 */
function add(){
	//opFlag ： 0 为新增保存；1为修改保存
	var sURL = webpath + "/view/authorization/delegate/DelegateDetail.jsp?opFlag=0";
	window.parent.dialogPopup_L2(sURL,DELEGATE_PRIVILEGE_DETAIL,450,470,true,"saveDelegate");
	//document.getElementById("delegateDetailFrame").src=sURL;
	//jQuery("#delegateDetailDialog").dialog('open');
}
/*
 * 选择人员
 */
function userSelect(){
	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelectRadio";
	document.getElementById("userSelectFrame").src=sURL;
	jQuery("#userSelectDialog").dialog('open');
}
/*
 * 修改
 */
function update(){
	var sendPara = new Object();
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert(DELEGATE_SELECT_DELE_TO_EDIT);
		return;
	}
	var userId = ECSideUtil.getPropertyValue(crow,"userId","ec");
	//只能修改自己的权限委托
	if (userId != currentUserId){
		alert(CANT_EDIT_OTHERS_DELEGATE);
		return;
	}
	var selectedDeleID = ECSideUtil.getPropertyValue(crow,"deleId","ec");
	var sURL = webpath + "/view/authorization/delegate/DelegateDetail.jsp?opFlag=1&deleId=" + selectedDeleID;
	window.parent.dialogPopup_L2(sURL,DELEGATE_PRIVILEGE_DETAIL,440,470,true,"saveDelegate");
	//document.getElementById("delegateDetailFrame").src=sURL;
	//jQuery("#delegateDetailDialog").dialog('open');
}

function deleteDelegate(queryFormName,listFormName){
	//存放最终在删除的所有checked用户
	var idString = "";
	//用于存放当前页的id，历史页的id不在这里存放
	var currentPageIDs ="";
	var allcheckarray =ECSideUtil.getPageCheckValue("checkBoxID");
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
		alert(DELEGATE_SELECT_DELE_TO_DELETE);
		return;
	}
	//只能删除自己的权限委托
	var tempList = idString.split(",");
	var ecsideObj=ECSideUtil.getGridObj("ec");
	for(j=0; j<tempList.length; j++){
		var userId = getUserID(tempList[j],currentUserId);
		if(userId != currentUserId){
			alert(CANT_DEL_OTHERS_DELEGATE);
			return;
		}
	}
//	if (!confirm("确认删除选择的用户吗？"))
//		return;
	confirm(DELEGATE_CONFIRM_USER_DELETE,function(){
		var deleIds = idString;
		//alert(userName + "，" +  userDesc + "，" + userMax + "，" + isAdminRole + "，" + userUsers + "，" + userUnits)
		var sURL = webpath + "/DelegateAction.do?method=deleteDelegate";
		jQuery.ajax( {
			url : sURL,
			type : "post",
			dataType : "json",
			data : {
			     deleIds : deleIds
			},
			success : function(data) {
				if(data.errorMessage==null || data.errorMessage==undefined){
					alert(DELETE_OK);
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
				}
				//删除后重新查询一下，相当于刷新 
				alert();
				var queryForm=$(queryFormName);
				var queryPara={
						"delegateName" : queryForm["txtDelegateName"].value != "" ? "%"+queryForm["txtDelegateName"].value+"%" : "",
						"delegateUser" : queryForm["selDelegateUser"].value != "" ? "%"+queryForm["selDelegateUser"].value+"%" : "",
						"trustorUser" : queryForm["selTrustorUser"].value != "" ? "%"+queryForm["selTrustorUser"].value+"%" : ""				
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

function deleSelectCallback(returnValue){
	var itemIds = returnValue.itemIds;
	var itemTexts = returnValue.itemTexts;
	document.getElementById("selDelegateUser").value=itemTexts;
	document.getElementById("hidDeleId").value=itemIds;
}
//选择委托人
function deleSelect(){
	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelectRadio";
	window.parent.dialogPopup_L2(sURL,STAT_USER_SELECT,470,530,true,"confirmUserSelect",null,deleSelectCallback);
}
function trustorSelectCallback(returnValue){
	var itemIds = returnValue.itemIds;
	var itemTexts = returnValue.itemTexts;
	document.getElementById("selTrustorUser").value=itemTexts;
	document.getElementById("hiddenTrustorId").value=itemIds;
}
//选择被委托人
function trustorSelect(){
	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelectRadio";
	window.parent.dialogPopup_L2(sURL,STAT_USER_SELECT,470,530,true,"confirmUserSelect",null,trustorSelectCallback);
}

//根据委托id，取该委托的委托人，这是写死的函数，如果列有变化需要修改。
//注意，第10列是隐藏列，内容是委托人id
function getUserID(rowID,currentUserId) {
	var returnValue = "";
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var listBody = ecsideObj.ECListBody.rows;
	for(j=0; j<listBody.length; j++){
		var tempID = listBody[j].cells[0].children[0].value;
		if (tempID == rowID){
			returnValue = listBody[j].cells[10].innerText;
			break;
		}
	}
	return returnValue;
}