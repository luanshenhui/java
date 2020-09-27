//Display the conditions
function displayConditions(conditionType) {
	//alert(conditionType);
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
		parameter = 'height=390, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	} else {
		parameter = 'height=390, width=570,  top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	}
	newWin = window.open(openUrl, 'condition', parameter);
}


// Get object method simplify
function $(id) {
	return document.getElementById(id);
};
function trim(str) {
	return str.replace(/\s/g, "");
}
function submit_onclick() {
	if (trim(document.mergeForm.actName.value) == "") {
		document.mergeForm.actName.focus();
		alert("名称不可以为空");
		document.mergeForm.actName.value = "";
		return false;
	}
	var actId = jQuery("#actId").val();
  	var actName = jQuery("#actName").val();
  	var actDesc = jQuery("#actDesc").val();
  	var extendProp = jQuery("#extendProp").val();
  	//汇聚类型
  	var mergeType = jQuery("input[name=mergeType]:checked").val();
  	//后置条件
  	var postCondition = jQuery("#postCondition").val();
	//保存对自动活动的修改
	var sURL1 = webpath + "/WfMergeActivity.do?method=update";
	jQuery.ajax( {
		url : sURL1,
		async : false,
		type : "post",
		dataType : "text",
		data : {
			procId:processId,
			procVersion:processVersion,
			actId : actId,
			actName : actName,
			actDesc : actDesc,
			extendProp : extendProp,
			postCondition : postCondition,
			mergeType:mergeType
		},
		success : function(data) {
			window.close();
		},
		error : function(){
		}
	});
}
// Under the FF's value can only input number type
function ffNum(id) {
	if (document.all) {
	} else {
		$(id).value = $(id).value.replace(/[^0-9]/g, '');
	}
};
// Under the IE's value can only input number type
function ieNum(e) {
	if (document.all) {
		var key = window.event ? e.keyCode : e.which;
		var keychar = String.fromCharCode(key);
		reg = /\d/;
		return reg.test(keychar);
	}
};

// Display the survival
function displaySurvival() {
	var dur = document.mergeForm.overdueTimelimit.value;
	var aDur = document.mergeForm.remindTimelimit.value;
	var vOD = document.mergeForm.overdueRdata.value;
	var aVOD = document.mergeForm.remindRdata.value;
	var aType = document.mergeForm.overdueAction.value;
	var aAType = document.mergeForm.remindAction.value;
	var aAI = document.mergeForm.remindInterval.value;
	var aA = document.mergeForm.overdueApp.value;
	var aAA = document.mergeForm.remindApp.value;
	var v = document.mergeForm.variable.value;
	var aV = document.mergeForm.alertVariable.value;
	var exAn = document.mergeForm.exActionName.value;
	var exAAN = document.mergeForm.exAlertActionName.value;
	var openUrl = "";
	var path = document.getElementById("path").value;
	openUrl = path
			+ "/view/workflow/wfprocess/WfProcessExpiration.jsp"
			+ "?dur=" + dur + "&aDur=" + aDur + "&vOD=" + vOD + "&aVOD=" + aVOD
			+ "&aType=" + aType + "&aAType=" + aAType + "&aAI=" + aAI + "&aA="
			+ aA + "&aAA=" + aAA + "&v=" + v + "&aV=" + aV + "&exAn=" + exAn
			+ "&exAAN=" + exAAN;
	if (document.all) {
		parameter = 'height=430, width=550, top=120, left=262, toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=445, width=550, top=120, left=262, toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'survival', parameter);
};
function editExtendProp(){
	var compId = "extendProp";
	WFCommon.editExtendProperty(compId,compId);
}