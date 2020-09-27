//Make the page on the top
var newWin=null;
window.onfocus=function (){  
 	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};

window.document.onfocus=function (){  
	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};

window.document.onclick=function (){  
	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};

window.document.ondblclick=function (){  
	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};
//Get object method simplify 
function $(id){
	return document.getElementById(id);
};

function trim(str) {
	return str.replace(/\s/g, "");
}

function submit_onclick(){
  	if (trim(document.autoNodeForm.actName.value) == "") {
		document.autoNodeForm.actName.focus();
		alert("名称不可以为空");
		document.autoNodeForm.tatName.value = "";
		return false;
	}
  	var actId = jQuery("#actId").val();
  	var actName = jQuery("#actName").val();
  	var actDesc = jQuery("#actDesc").val();
  	var extendProp = jQuery("#extendProp").val();
  	var overdueTimelimit = jQuery("#overdueTimelimit").val();
  	var overdueRdata = jQuery("#overdueRdata").val();
  	var overdueAction = jQuery("#overdueAction").val();
  	
  	var overdueApp = jQuery("#overdueApp").val();
  	var remindTimelimit = jQuery("#remindTimelimit").val();
  	var remindRdata = jQuery("#remindRdata").val();
  	var remindAction = jQuery("#remindAction").val();
  	var remindApp = jQuery("#remindApp").val();
  	var remindInterval = jQuery("#remindInterval").val();
  	var remindCount = jQuery("#remindCount").val();
  	//应用
  	var applicationName = jQuery("#applicationName").val();
  	var application = jQuery("#application").val();
  	//前置条件
  	var preCondition = jQuery("#preCondition").val();
  	//后置条件
  	var postCondition = jQuery("#postCondition").val();
	//保存对自动活动的修改
	var sURL1 = webpath + "/WfAutomaticActivity.do?method=update";
	jQuery.ajax( {
		url : sURL1,
		async : false,
		type : "post",
		dataType : "text",
		data : {
			processId:processId,
			processVersion:processVersion,
			actId : actId,
			actName : actName,
			actDesc : actDesc,
			overdueTimelimit : overdueTimelimit,
			overdueRdata : overdueRdata,
			overdueAction : overdueAction,
			overdueApp : overdueApp,
			remindTimelimit : remindTimelimit,
			remindRdata : remindRdata,
			remindAction : remindAction,
			remindApp : remindApp,
			remindInterval : remindInterval,
			remindCount:remindCount,
			extendProp : extendProp,
			preCondition : preCondition,
			postCondition : postCondition,
			applicationName:applicationName,
			application:application
		},
		success : function(data) {
			window.opener.updateActivity(actId,actName);
			window.close();
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert("网络错误");
		}
	});
	window.close();
	}


// Display the events
function displayEvents() {
	var actId = jQuery("#actId").val();
	var openUrl = webpath
		+ "/WfManualActivity.do?method=displayEvents&processId=" + processId
		+ "&processVersion=" + processVersion+"&actId="+actId;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	
	if (document.all) {
	parameter = 'height=520, width=620, top='
			+ top
			+ ', left='
			+ left
			+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
	parameter = 'height=520, width=620, top='
			+ top
			+ ', left='
			+ left
			+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'events', parameter);
}

//Display the survival
function displaySurvival(){
	var overdueTimelimit = document.autoNodeForm.overdueTimelimit.value;
	var remindTimelimit = document.autoNodeForm.remindTimelimit.value;
	var overdueRdata = document.autoNodeForm.overdueRdata.value;
	var remindRdata = document.autoNodeForm.remindRdata.value;
	var overdueAction = document.autoNodeForm.overdueAction.value;
	var remindAction = document.autoNodeForm.remindAction.value;
	var remindInterval = document.autoNodeForm.remindInterval.value;
	var overdueApp = document.autoNodeForm.overdueApp.value;
	var remindApp = document.autoNodeForm.remindApp.value;
	//催办次数
	var remindCount = document.autoNodeForm.remindCount.value;
	if (processId != "" && processVersion != "") {
		var openUrl = webpath
				+ "/view/workflow/wfprocess/WfProcessExpiration.jsp?processId="
				+ processId + "&processVersion=" + processVersion
				+ "&overdueTimelimit="+overdueTimelimit+"&remindTimelimit="+remindTimelimit
				+ "&overdueRdata="+overdueRdata+"&remindRdata="+remindRdata
				+ "&overdueAction="+overdueAction+"&remindAction="+remindAction
				+ "&remindInterval="+remindInterval+"&overdueApp="+overdueApp
				+ "&remindApp="+remindApp
				+"&remindCount="+remindCount;
		var left = (window.screen.availWidth - 635) / 2 + 20;
		var top = (window.screen.availHeight - 420) / 2;

		if (document.all) {
			parameter = 'height=455, width=550, top='
					+ top
					+ ', left='
					+ left
					+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		} else {
			parameter = 'height=455, width=550, top='
					+ top
					+ ', left='
					+ left
					+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		}
		newWin = window.open(openUrl, 'survival', parameter);
	} else {
		alert("找不到流程ID和版本请重新登录系统！");
	}
};
//Open application dialog
function openApp(event){
	var obj = event.srcElement ? event.srcElement : event.target;
	var applicationPageName = obj.name;
	var left = (window.screen.availWidth - 660) / 2 + 20;
	var top = (window.screen.availHeight - 390) / 2;
	openUrl = webpath + "/WfProcessAction.do?method=selectApp"
			+ "&applicationPageName=" + applicationPageName
			+ "&processId="+processId+"&processVersion="+processVersion+"&eventId=undefine";
	if(document.all){			  
	  	parameter='height=430, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }else{
	  	parameter='height=430, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }
	newWin = window.open(openUrl,"application",parameter);
}
//clear up  application
function clearUp(){
	document.autoNodeForm.applicationName.value="";
	document.autoNodeForm.application.value="";
}
function displayConditions(conditionType) {
	var conditionValue = "";
	if (conditionType == "preCondition") {
		conditionValue = document.forms[0].preCondition.value;
	} else {
		conditionValue = document.forms[0].postCondition.value;
	}
	var openUrl = "";

	openUrl = webpath
			+ "/view/workflow/wfprocess/WfConditions.jsp?conditionValue="
			+ encodeURIComponent(encodeURIComponent(conditionValue)) + "&conditionType=" + conditionType
			+ "&processId="+processId+"&processVersion="+processVersion;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	if (document.all) {
		parameter = 'height=410, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	} else {
		parameter = 'height=410, width=570,  top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	}
	newWin = window
			.open(openUrl, 'condition', parameter);
}

function editExtendProp(){
	var compId = "extendProp";
	WFCommon.editExtendProperty(compId,compId);
}