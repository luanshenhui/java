/*
 * 初始化方法
 * */
(function($){ 
	jQuery(document).ready(function(){

	jQuery('body').bind('keydown',shieldCommon);
	//getUnitType();
	//obj = window.dialogArguments;//定义一个对象用于接收对话框参数	
	//flagType = obj.flag;
	//unitId = obj.unitId;
	//staId = obj.staId;
	flagType = sendflag;
	unitId = sendunitId;
	staId = sendstaId;
	if(staId == null || staId == "null"){
		staId = ""; //如果组织下没有岗位，将岗位id赋空值
	}
	if(flagType==0||flagType=="0"){
	   jQuery("#staNum").val("-1");
	}
	if(flagType==1||flagType=="1"){
		showDetail(unitId,staId);
	}
	
	//页面控件输入有效性验证
	$("#detailForm").validate({
		errorClass : "error2",
		errorElement : "div",
		highlight : function(element, errorClass) {
			$(element).addClass(errorClass);
			$("#error_" + element.id).show();
		},
		unhighlight : function(element, errorClass) {
			$(element).removeClass(errorClass);
			$("#img_" + element.id).remove();
			$("#error_" + element.id).remove();
		},
		showErrors : function(error, element) {
			var _this = this;
			showErrorsWithPosition(error, element, _this, webpath);
		},
		rules: {
    		staName: {
				required: true,
				specialCharCheck:true,
				byteRangeLength: [0,32]
			},
			staDes: {
				byteRangeLength: [0,255]
			},
			staNum: {
				required : true,
				range : [-1,65535],
				integerValidate : true
			}
		},
		messages: {
			staName: {
				required : STAT_FILL_STATNAME,
				specialCharCheck:STAT_FILL_STATNAME,
				byteRangeLength : STAT_STAT_LONG
			},				
			staDes: {
				byteRangeLength : STAT_STATDESC_LONG
			},
			staNum : {
				required : STAT_MAXUSERS_MANDATORY,
				range : MAXUSERS_PROMPT_INFO,
				integerValidate : MAXUSERS_PROMPT_INFO
			}
		}
	});

});
})(jQuery); 

//验证-1,0,正整数
jQuery.validator.addMethod("integerValidate",
		function(value, element) {
	 var regx = /^[0-9]\d*$/; 
	 return (regx.test(value) || value=="-1");
});

var flagType ; // 区分新增保存和修改保存，新增保存为0，修改保存为1
var unitId; //组织---新增页面：所选节点的父节点id；修改页面：选择修改节点的id
var staId;//岗位  ---- 新增页面：所选节点的父节点id；修改页面：选择修改节点的id

//showStaUser 的回调函数
function showStaUserCallback(returnValue){
	if(returnValue){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		document.getElementById("staUser").value=itemTexts;
		document.getElementById("staUserHidden").value=itemIds;
		staUserId = itemIds;
	}	 
}
/*
 * 岗位下用户
 * */
function showStaUser(){
	//2011/08/02  Tue wxy URI是有长度限制的(operta4k,ie2k,ff10k)，如果有一天超长了会出错，需要在后台重新查询了
	var staUserIDs = document.getElementById("staUserHidden").value;
	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelect&stationUserIDs=" + staUserIDs;
	window.parent.dialogPopup_L3(sURL,STAT_USER_SELECT,450,540,true,"confirmUserSelect",null,showStaUserCallback);
	//window.parent.showStaUser();
//	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelect";
//	document.getElementById("userFrame").src=sURL;
//	jQuery("#userDialog").dialog('open');
//	var returnObj = window.showModalDialog(webpath + '/UserAction.do?method=getUser&forward=userSelect',null,'dialogWidth=500px;status:no;scroll:no;dialogHeight=380px');
//	if(returnObj){
//		var itemIds = returnObj.itemIds;
//		var itemTexts = returnObj.itemTexts;
//		jQuery("#staUser").val(itemTexts);
//		staUserId = itemIds;
//	}
}

/*
 * 提交保存
 * */
function save(){
	var returnValue;
	if (checkValidate()){
		returnValue = saveFormElement();
		return returnValue;
	}else{
		returnValue ="false";
		return returnValue;
	}	
}

/*
 * 校验数据
 * */
function checkValidate(){
	if(!jQuery("#detailForm").valid())return false;
	
//	var detailForm;
//	eval('detailForm = document.detailForm');
//	if(!g_check.checkForm(detailForm)){
//		//alert(g_check.message);
//		return false;
//	}
	
//	var staName = jQuery("#staName").val();
//	if(staName == null || staName == ""){
//		alert(STAT_FILL_STATNAME);
//		jQuery("#staName").focus();
//		return false ;
//	}else{
//		var leng = staName.replace(/[^\x00-\xff]/g,"**").length;
//		if(leng>32){
//			alert(STAT_STAT_LONG);
//			jQuery("#staName").focus();
//			return false ;
//		}
//	}
//    len = jQuery("#staDes").val().replace(/[^\x00-\xff]/g,"**").length;
//    if (len >255){
//    	alert(STAT_STATDESC_LONG);
//    	jQuery("#staDes").focus();
//    	return false;
//    }
//	var staNum = jQuery("#staNum").val();
//    var objRegExp = /^(\d*|\-?[1-9]{1}\d*)$/; //整数
//    if(staNum==""){
//    	alert(STAT_MAXUSERS_MANDATORY);
//    	jQuery("#staNum").focus();
//		return false;
//    }
//	if(!objRegExp.test(staNum)&& staNum.replace(/[^\x00-\xff]/g,"**").length>10){
//		alert(STAT_NUMBER_INVALID);
//		jQuery("#staNum").focus();
//		return false;
//	}
	return true;
}

var parentId;// 修改岗位时保存岗位的parentId
function saveFormElement(){
	var returnValue;
	if(flagType == 0 || flagType == "0"){
		var staName = jQuery("#staName").val();
		var staDes = jQuery("#staDes").val();
		var staNum = jQuery("#staNum").val();
		if(jQuery("#staUser").val()!=""){
			var staUser = jQuery("#staUserHidden").val();
		}else{
			var staUser = "";
		}
		var itemId = unitId;
		var stationId = null ;
		if(staId == undefined || staId == null){
			var parStaId ="";
		}else{
		var parStaId = staId;
		}
		jQuery.ajax({
			url:webpath + "/StationAction.do?method=saveStation",
			type:"post",
			async:false,
			dataType:"json",
			data:{staName:staName,staDes:staDes,staNum:staNum,staUser:staUser,itemId:itemId,stationId:stationId,parStaId:parStaId,flag:"0"},
			success:function(data){
				if(data.errorMessage== null || data.errorMessage== null ){
					//window.returnValue = data;
					returnValue = data;
					alert(SAVE_OK);
					//window.close();
				}else{
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
					returnValue = "false";
				}
			}
		});
		return returnValue;
	}
	if(flagType == 1 || flagType == "1"){
		var staName = jQuery("#staName").val();
		var staDes = jQuery("#staDes").val();
		var staNum = jQuery("#staNum").val();
		var staUser = jQuery("#staUserHidden").val();
		var itemId = unitId;
		var stationId = staId ;
		var parStaId = parentId;

		jQuery.ajax({
			url:webpath + "/StationAction.do?method=saveStation",
			type:"post",
			async:false,
			dataType:"json",
			data:{staName:staName,staDes:staDes,staNum:staNum,staUser:staUser,itemId:itemId,stationId:stationId,parStaId:parStaId,flag:"1"},
			success:function(data){
				if(data.errorMessage== null || data.errorMessage== null ){
					//window.returnValue = data;
					returnValue = data;
					alert(STAT_UPDATE_OK);
					//window.close();
				}else{
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
					returnValue = "false";
				}
			}
		});
		return returnValue;
	}
}

/*
 * 修改显示详细信息
 */
function showDetail(unitId,staId){
	jQuery.ajax({
		url:webpath + "/StationAction.do?method=getStationDetail",
		type:"post",
		dataType:"json",
		data:{unitId:unitId,staId:staId},
		success:function(data){
			 jQuery("#staName").val(data.staDetail.stationName);
             jQuery("#staDes").val(data.staDetail.stationDescription);
             jQuery("#staNum").val(data.staDetail.userNumbers);
             jQuery("#staUser").val(data.staDetail.stationUsers);
             jQuery("#staUserHidden").val(data.staDetail.userId);
             staUserId = data.staDetail.userId;
             parentId = data.staDetail.parentStationId;
		}
	});
	
}