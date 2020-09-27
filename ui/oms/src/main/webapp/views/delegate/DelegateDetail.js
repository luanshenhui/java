$().ready(function(){    
	$('body').bind('keydown',shieldCommon);
});
function init(){
	//页面控件输入有效性验证
	$("#detailForm").validate({
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
			txtDelegateName: {
				required: true,
				specialCharCheck:true,
				byteRangeLength: [0,32]
			},
			txtTrustor: {
				required : true
			},
			timeEnd: {
				dateGreaterThen : "#timeStart"
			},
			description: {
				byteRangeLength: [0,255]
			}
		},
		messages: {
			txtDelegateName: {
				required : DELEGATE_TRUSTOR_MANDATORY,
				specialCharCheck: DELEGATE_TRUSTOR_MANDATORY,
				byteRangeLength : DELEGATE_DELE_NAME_LONG
			},				
			txtTrustor: {
				required : DELEGATE_PLZ_SELECT_TRUSTEE
			},
			timeEnd : DELEGATE_END_TIME_LESS_THEN_START_TIME,
			description: DELEGATE_DESC_LONG
		}
	});
	
    if (opFlag == 1 || opFlag == "1") {
			showDetail(deleId);
		}
	 $("#selRole").multiselect({
	    	noneSelectedText: DELEGATE_PLZ_SELECT,
			selectedList : 5
		});
	 $("#selSta").multiselect({
	    	noneSelectedText: DELEGATE_PLZ_SELECT,
			selectedList : 5
		});
	 $("#selUnit").multiselect({
	    	noneSelectedText: DELEGATE_PLZ_SELECT,
			selectedList : 5
		});
	 selAllPrivil();
}
//$(function (){
//	var $widget = $("roleHidden").multiselect(), state = false;
//	$("#allPrivil").click(function(){
//		var allPrivil = $("#allPrivil").val();
//		if(allPrivil=="0" || allPrivil==0){
//		state = !state;
//		$widget.multiselect(state ? 'disable' : 'enable');
//		alert(state);
//		}else{
//			state = false;
//			$widget.multiselect(state ? 'disable' : 'enable');
//		}
//	});
//});

//unitSelect 的回调函数
function userSelectCallback(returnValue){
	if (returnValue || returnValue == "true"){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		document.getElementById("txtTrustor").value=itemTexts;
		document.getElementById("hidTrustorId").value=itemIds;
	}
}
/*
 * 选择人员
 */
function userSelect(){
	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelectRadio&needAllUser=true";
	window.parent.dialogPopup_L3(sURL,STAT_USER_SELECT,480,540,true,"confirmUserSelect",null,userSelectCallback);
	//window.parent.userSelect();
}
/*
 * 判断是、否全部授权。是：隐藏；否：不隐藏组织、角色、岗位
 */
function selAllPrivil(){
	var allPrivil = $("#allPrivil").val();
	if(allPrivil=="1" || allPrivil== 1 ){
		$("#selRole").multiselect().multiselect('disable');
		$("#selUnit").multiselect().multiselect('disable');
		$("#selSta").multiselect().multiselect('disable');
	}
	if(allPrivil=="0" || allPrivil== 0 ){
		$("#selRole").multiselect().multiselect('enable');
		$("#selUnit").multiselect().multiselect('enable');
		$("#selSta").multiselect().multiselect('enable');
	}
}



//显示角色的详细信息
function showDetail(deleId) {
	$("#hidDelegateID").val(deleId);
	//根据roleID取role的明细
	var sURL1 = webpath + "/DelegateAction.do?method=getDelegateDetail";
	$.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		async : false,
		data : {
			deleId : deleId
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				$("#txtDelegateName").val(data.delegateDetail.deleName);
				$("#hidDelegateID").val(data.delegateDetail.deleId);
				$("#txtDelegateUser").val();
				$("#hidDelegateUserId").val(data.delegateDetail.userId);
				$("#txtTrustor").val(data.delegateDetail.trustor_name);
				$("#hidTrustorId").val(data.delegateDetail.trustorId);
				$("#timeStart").val(data.delegateDetail.deleTimeBegin);
				$("#timeEnd").val(data.delegateDetail.deleTimeEnd);
				$("#allPrivil").val(data.delegateDetail.deleAllPrivil);
				$("#description").val(data.delegateDetail.deleDescription);
				
				// 给角色下拉列表赋值
				var roleList = data.delegateDetail.roleItemList;
				var roleCount =$("#selRole option").length;
				for(var i=0;i<roleCount;i++){
					var selRoleId = document.getElementById("selRole").options[i].value;
					for(var j=0;j<roleList.length;j++){
						if(selRoleId == roleList[j]){
							document.getElementById("selRole").options[i].setAttribute("selected","selected");
						}						
					}
				}
				
				// 给岗位下拉列表赋值
				var staList = data.delegateDetail.stationItemList;
				var staCount =$("#selSta option").length;
				for(var i=0;i<staCount;i++){
					var selStaId = document.getElementById("selSta").options[i].value;
					for(var j=0;j<staList.length;j++){
						if(selStaId == staList[j]){
							document.getElementById("selSta").options[i].setAttribute("selected","selected");
						}						
					}
				}
				
                // 给组织下拉列表赋值
				var unitList = data.delegateDetail.unitItemList;
				var unitCount =$("#selUnit option").length;
				for(var i=0;i<unitCount;i++){
					var selUnitId = document.getElementById("selUnit").options[i].value;
					for(var j=0;j<unitList.length;j++){
						if(selUnitId == unitList[j]){
							document.getElementById("selUnit").options[i].setAttribute("selected","selected");
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
	if(!$("#detailForm").valid())return false;

	if($("#allPrivil").val() == "0"){
		if($("#selUnit").multiselect("getChecked").length == 0 && 
				$("#selSta").multiselect("getChecked").length == 0 && 
				$("#selRole").multiselect("getChecked").length == 0){
			alert(PLZ_SELECT_PRIVILEGE);
			return false;
		}
	}
	
	var trustorId = $("#hidTrustorId").val();
	var delegateUserId = $("#hidDelegateUserId").val();
	if(trustorId == delegateUserId){
		alert(DELEGATE_TRUSTOR_TRUSTEE_CANT_SAME);
		return false;
	}
	
//	var detailForm;
//	eval('detailForm = document.detailForm');
//	if(!g_check.checkForm(detailForm)){
//		//alert(g_check.message);
//		return false;
//	}
//	var txtDelegateName = $("#txtDelegateName").val();
//	if(txtDelegateName==""||txtDelegateName==null){
//		alert(DELEGATE_TRUSTOR_MANDATORY);
//		$("#txtDelegateName").focus();
//		return false;
//	}
//	if(txtDelegateName.replace(/[^\x00-\xff]/g,"**").length>32){
//		alert(DELEGATE_DELE_NAME_LONG);
//		$("#txtDelegateName").focus();
//		return false;
//	}	
//	var txtTrustor = $("#txtTrustor").val();
//	if(txtTrustor==""||txtTrustor==null){
//		alert(DELEGATE_PLZ_SELECT_TRUSTEE);
//		$("#txtTrustor").focus();
//		return false;
//	}
//	if(txtTrustor.replace(/[^\x00-\xff]/g,"**").length>32){
//		alert(DELEGATE_TRUSTEE_LONG);
//		$("#txtTrustor").focus();
//		return false;
//	}
//	var trustorId = $("#hidTrustorId").val();
//	var delegateUserId = $("#hidDelegateUserId").val();
//	if(trustorId == delegateUserId){
//		alert(DELEGATE_TRUSTOR_TRUSTEE_CANT_SAME);
//		return false;
//	}
//	var timeBegin = $("#timeStart").val();
//	var timeEnd = $("#timeEnd").val();
//	//判断日期，开始时间应小于结束时间
//	if(timeBegin != "" ){
//		if(timeEnd != "" ){
//			var timeCheckValue =(new Date(timeBegin.replace(/-/g,"\/"))) < (new Date(timeEnd.replace(/-/g,"\/")));
//			if(!timeCheckValue){
//				alert(DELEGATE_END_TIME_LESS_THEN_START_TIME);
//				$("#timeEnd").focus();
//				return false;
//			}
//		}
//		//可以只填结束时间
//		if(timeEnd == ""){
//			alert(DELEGATE_PLZ_FILL_END_TIME);
//			$("#timeEnd").focus();
//			return false;
//		}
//	}	
//	var description = $("#description").val();
//	if(description.replace(/[^\x00-\xff]/g,"**").length>255){
//		alert(DELEGATE_DESC_LONG);
//		$("#description").focus();
//		return false;
//	} 
	return true;
}

//保存角色修改
function saveDelegate() {
	var blnReturn = "false";
	//有效性检查没有通过不能保存
	if(!checkValidate())
	  {
		return "false";
	  }
	var deleId = $("#hidDelegateID").val();
	var checkFlag; //检查是否有相同委托人和被委托人记录，如果值不等于0表示有，则不能新建此记录
	
		var delegateName = $("#txtDelegateName").val();
		var delegateUserId = $("#hidDelegateUserId").val();
		if (opFlag == 1 || opFlag == "1"){
			var delegateId = $("#hidDelegateID").val();
		}
		var trustorId = $("#hidTrustorId").val();
		var timeStart = $("#timeStart").val();
		var timeEnd = $("#timeEnd").val();
		var allPrivil = $("#allPrivil").val();
		if(allPrivil == "0" || allPrivil== 0){
		//获取下拉列表选择的值
		var roleValueStr = $("#selRole").multiselect("update");
		//获取下拉列表选择值的id
		var roleId= $("#selRole").multiselect("getChecked");
		var roleIdStr="";
        for(var i=0;i<roleId.length;i++) 
        {
        	if (roleId[i].value){
        		roleIdStr += roleId[i].value;
				if (i<roleId.length-1){
					roleIdStr += ",";
				}
			}
        }
		var staValueStr = $("#selSta").multiselect("update");
		var staId= $("#selSta").multiselect("getChecked");
		var staIdStr="";
        for(var i=0;i<staId.length;i++) 
        {
        	if (staId[i].value){
        		staIdStr += staId[i].value;
				if (i<staId.length-1){
					staIdStr += ",";
				}
			}
        }	
		var unitValueStr = $("#selUnit").multiselect("update");
		var unitId= $("#selUnit").multiselect("getChecked");
		var unitIdStr="";
        for(var i=0;i<unitId.length;i++) 
        {
        	if (unitId[i].value){
        		unitIdStr += unitId[i].value;
				if (i<unitId.length-1){
					unitIdStr += ",";
				}
			}
        }
		}else{
			roleValueStr = "";
		    roleIdStr = "";
		    staValueStr = "";
		    staIdStr = "";
		    unitValueStr = "";
		    unitIdStr = "";			
		}		
		var description = $("#description").val();
		var sURL = webpath + "/DelegateAction.do?method=checkDelegate";
		$.ajax( {
			url : sURL,
			async : false,
			type : "post",
			dataType : "json",
			data : {
			delegateUserId  : delegateUserId ,
		    trustorId  : trustorId ,
		    deleId : deleId
		    },
		    success : function(data) {		    	
		    		checkFlag = data.num.number;		    	
		    }
		});
		if (opFlag == 0 || opFlag == "0") {
		//alert(roleName + "，" +  roleDesc + "，" + roleMax + "，" + isAdminRole + "，" + roleUsers + "，" + roleUnits)
		
		if(checkFlag == "0" || checkFlag == 0){
		var sURL = webpath + "/DelegateAction.do?method=saveDelegate";
		// 调用AJAX请求函数
		$.ajax( {
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : {
			    delegateName  : delegateName ,
			    delegateUserId  : delegateUserId ,
			    trustorId  : trustorId ,
			    timeStart  : timeStart ,
			    timeEnd  : timeEnd ,
			    allPrivil  : allPrivil ,
			    roleValueStr  : roleValueStr ,
			    roleIdStr : roleIdStr ,
			    staValueStr : staValueStr ,
			    staIdStr : staIdStr ,
			    unitValueStr : unitValueStr ,
			    unitIdStr : unitIdStr ,
			    description : description ,
				opFlag : "0"
			},
			success : function(data) {
				if(data.errorMessage==undefined){
					alert(SAVE_OK);
					blnReturn = "true";
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
					blnReturn = "false";
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("委托名称重复");//NET_FAILD);
				blnReturn = "false";
			}
		});
		}else{
			alert(DELEGATE_SAVE_RECORD_WAS_FOUND);
		}
	} 
	
		//保存对角色的修改
//			var delegateName = $("#txtDelegateName").val();
//			var delegateId = $("#hidDelegateID").val();
//			var delegateUserId = $("#hidDelegateUserId").val();
//			var trustorId = $("#hidTrustorId").val();
//			var timeStart = $("#timeStart").val();
//			var timeEnd = $("#timeEnd").val();
//			var allPrivil = $("#allPrivil").val();
//			//获取下拉列表选择的值
//			var roleValueStr = $("#selRole").multiselect("update");
//			//获取下拉列表选择值的id
//			var roleId= $("#selRole").multiselect("getChecked");
//			var roleIdStr="";
//	        for(var i=0;i<roleId.length;i++) 
//	        {
//	        	if (roleId[i].value){
//	        		roleIdStr += roleId[i].value;
//					if (i<roleId.length-1){
//						roleIdStr += ",";
//					}
//				}
//	        }
//			var staValueStr = $("#selSta").multiselect("update");
//			var staId= $("#selSta").multiselect("getChecked");
//			var staIdStr="";
//	        for(var i=0;i<staId.length;i++) 
//	        {
//	        	if (staId[i].value){
//	        		staIdStr += staId[i].value;
//					if (i<staId.length-1){
//						staIdStr += ",";
//					}
//				}
//	        }	
//			var unitValueStr = $("#selUnit").multiselect("update");
//			var unitId= $("#selUnit").multiselect("getChecked");
//			var unitIdStr="";
//	        for(var i=0;i<unitId.length;i++) 
//	        {
//	        	if (unitId[i].value){
//	        		unitIdStr += unitId[i].value;
//					if (i<unitId.length-1){
//						unitIdStr += ",";
//					}
//				}
//	        }
//			var description = $("#description").val();
		if (opFlag == 1 || opFlag == "1") {
			if(checkFlag == "0" || checkFlag == 0){
			//alert(roleName + "，" +  roleDesc + "，" + roleMax + "，" + isAdminRole + "，" + roleUsers + "，" + roleUnits)
			var sURL = webpath + "/DelegateAction.do?method=saveDelegate";
			// 调用AJAX请求函数
			$.ajax( {
				url : sURL,
				async : false,
				type : "post",
				dataType : "text",
				data : {
				    delegateName  : delegateName ,
				    delegateId : delegateId,
				    delegateUserId  : delegateUserId ,
				    trustorId  : trustorId ,
				    timeStart  : timeStart ,
				    timeEnd  : timeEnd ,
				    allPrivil  : allPrivil ,
				    roleValueStr  : roleValueStr ,
				    roleIdStr : roleIdStr ,
				    staValueStr : staValueStr ,
				    staIdStr : staIdStr ,
				    unitValueStr : unitValueStr ,
				    unitIdStr : unitIdStr ,
				    description : description ,
					opFlag : "1"
				},
				success : function(data) {
					if(data.errorMessage==undefined){
						alert(SAVE_OK);
						blnReturn = "true";
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
			}else{
				alert(DELEGATE_SAVE_RECORD_WAS_FOUND);
			}
	}
	return blnReturn;
}
function update(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert(DELEGATE_SELECT_DELE_TO_EDIT);
		return "false";
	}
	var selectedRoleID = ECSideUtil.getPropertyValue(crow,"roleId","ec");
	var sURL = webpath + "/view/organization/role/RoleDetail.jsp?opFlag=1&roleID=" + selectedRoleID;
	document.getElementById("roleDetailFrame").src=sURL;
	jQuery("#roleDetailDialog").dialog('open');
}
