jQuery(function($) {
	jQuery(document).ready(function() {
		//if (opFlag == 1 || opFlag == "1") {
		//	showDetail(procId);
		//}
	});
});

//验证-1,0,正整数
jQuery.validator.addMethod("integerValidate",
	function(value, element) {
	var regx = /^[0-9]\d*$/; 
	return (regx.test(value) || value=="-1");
});


//显示流程的详细信息
function showDetail(procId) {
	jQuery("#hidProcId").val(procId);
	//根据procId取wF_PROCESS的明细
	var sURL1 = webpath + "/WfProcessAction.do?method=getWfProcessDetail";
	jQuery.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		data : {
			procId : procId
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//使用返回的wfProcess明细画页面
				jQuery("#txtProcId").val(data.wfprocessDetail.procId);
				jQuery("#txtProcVersion").val(data.wfprocessDetail.procVersion);
				jQuery("#txtProcName").val(data.wfprocessDetail.procName);
				jQuery("#txtProcDesc").val(data.wfprocessDetail.procDesc);
				jQuery("#txtStartNode").val(data.wfprocessDetail.startNode);
				jQuery("#txtBuilder").val(data.wfprocessDetail.builder);
				jQuery("#txtBuildTime").val(data.wfprocessDetail.buildTime);
				jQuery("#txtModifiedTime").val(data.wfprocessDetail.modifiedTime);
				jQuery("#txtOverdueTimelimit").val(data.wfprocessDetail.overdueTimelimit);
				jQuery("#txtOverdueRdata").val(data.wfprocessDetail.overdueRdata);
				jQuery("#txtOverdueAction").val(data.wfprocessDetail.overdueAction);
				jQuery("#txtOverdueApp").val(data.wfprocessDetail.overdueApp);
				jQuery("#txtRemindTimelimit").val(data.wfprocessDetail.remindTimelimit);
				jQuery("#txtRemindRdata").val(data.wfprocessDetail.remindRdata);
				jQuery("#txtRemindAction").val(data.wfprocessDetail.remindAction);
				jQuery("#txtRemindApp").val(data.wfprocessDetail.remindApp);
				jQuery("#txtRemindInterval").val(data.wfprocessDetail.remindInterval);
				jQuery("#txtRemindTimes").val(data.wfprocessDetail.remindCount);
				jQuery("#txtExtendProp").val(data.wfprocessDetail.extendProp);
				jQuery("#txtPreCondition").val(data.wfprocessDetail.preCondition);
				jQuery("#txtPostCondition").val(data.wfprocessDetail.postCondition);
				jQuery("#txtIsActiveVersion").val(data.wfprocessDetail.isActiveVersion);
				jQuery("#txtHasProcInst").val(data.wfprocessDetail.hasProcInst);
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert("网络错误");
		}
	});
}

//输入有效性校验
function checkValidate(){
	if(!jQuery("#detailForm").valid())return false;
	return true;
}

function trim(str) {
	return str.replace(/\s/g, "");
}

// 保存流程修改
function saveWfProcess() {
	var blnReturn = "false";
	// 有效性检查没有通过不能保存
	if (trim(document.getElementById("txtProcName").value) == "") {
		document.getElementById("txtProcName").focus();
		alert("流程名称不可以为空");
		document.getElementById("txtProcName").value = "";
		return false;
	}
	var procId = jQuery("#txtProcId").val();
	var procVersion = jQuery("#txtProcVersion").val();
	var procName = jQuery("#txtProcName").val();
	var procDesc = jQuery("#txtProcDesc").val();
	var builder = jQuery("#txtBuilder").val();
	var buildTime = jQuery("#txtBuildTime").val();
	var modifiedTime = jQuery("#txtModifiedTime").val();
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
	var extendProp = jQuery("#txtExtendProp").val();
	var preCondition = jQuery("#preCondition").val();
	var postCondition = jQuery("#postCondition").val();
	/*
	 * //流程事件 var events = jQuery("#events").val(); //监控者 var munit =
	 * jQuery("#munit").val(); //监控者类型 var monitorType =
	 * jQuery("#monitorType").val(); //监控者名称 var monitor =
	 * jQuery("#monitor").val(); //监控者id var monitors =
	 * jQuery("#monitors").val(); //创建者 var punit = jQuery("#punit").val();
	 * //创建者类型 var creatorType = jQuery("#creatorType").val(); //创建者名称 var
	 * validCreator = jQuery("#validCreator").val(); //创建者id var validCreators =
	 * jQuery("#validCreators").val();
	 */
	var sURL = webpath + "/WfProcessAction.do?method=save";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "POST",
		dataType : "text",
		data : {
			procId : procId,
			procVersion : procVersion,
			procName : procName,
			procDesc : procDesc,
			builder : builder,
			buildTime : buildTime,
			modifiedTime : modifiedTime,
			overdueTimelimit : overdueTimelimit,
			overdueRdata : overdueRdata,
			overdueAction : overdueAction,
			overdueApp : overdueApp,
			remindTimelimit : remindTimelimit,
			remindRdata : remindRdata,
			remindAction : remindAction,
			remindApp : remindApp,
			remindInterval : remindInterval,
			remindCount : remindCount,
			extendProp : extendProp,
			preCondition : preCondition,
			postCondition : postCondition,
			/*
			 * events :events, transitionVariables:transitionVariables,
			 * munit:munit, monitorType:monitorType, monitor :monitor, monitors
			 * :monitors, punit:punit, creatorType :creatorType,
			 * validCreator:validCreator, validCreators :validCreators,
			 */
			opFlag : opFlag
		},
		success : function(data) {
			blnReturn = true;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert("网络错误");
			blnReturn = "false";
		}
	});

	closeWin();
}

// 关闭窗体
function closeWin() {
	window.opener = null;
	window.close();
}


//选择生存期
function displaySurvival(processId, processVersion) {
	var overdueTimelimit = document.detailForm.overdueTimelimit.value;
	var remindTimelimit = document.detailForm.remindTimelimit.value;
	var overdueRdata = document.detailForm.overdueRdata.value;
	var remindRdata = document.detailForm.remindRdata.value;
	var overdueAction = document.detailForm.overdueAction.value;
	var remindAction = document.detailForm.remindAction.value;
	var remindInterval = document.detailForm.remindInterval.value;
	var overdueApp = document.detailForm.overdueApp.value;
	var remindApp = document.detailForm.remindApp.value;
	//催办次数
	var remindCount = document.detailForm.remindCount.value;
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
		var left = (window.screen.availWidth - 550) / 2 + 20;
		var top = (window.screen.availHeight - 460) / 2;

		if (document.all) {
			parameter = 'height=540, width=550, top='
					+ top
					+ ', left='
					+ left
					+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		} else {
			parameter = 'height=540, width=550, top='
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
//选择流程事件
function displayEvents(processId, processVersion) {
	// var openUrl = webpath+"/view/workflow/wfprocessevent/WfProcessEvent.jsp";
	//var events = document.detailForm.events.value;
	var openUrl = webpath
			+ "/WfProcessAction.do?method=displayEvents&processId=" + processId
			+ "&processVersion=" + processVersion;// + "&events=" + events;
	var left = (window.screen.availWidth - 620) / 2 + 20;
	var top = (window.screen.availHeight - 300) / 2;

	if (document.all) {
		parameter = 'height=300, width=620, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=300, width=620, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'events', parameter);
}

//选择流程变量
function displayVariableGrid() {
	// var path=document.getElementById("path").value;
	var openUrl = webpath
			+ "/view/workflow/wfrelatedata/WfRelateDataSelect.jsp?processId="
			+ procId + "&processVersion=" + procVer;
	var left = (window.screen.availWidth - 660) / 2 + 20;
	var top = (window.screen.availHeight - 480) / 2;

	if (document.all) {
		parameter = 'height=480, width=660, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=yes, resizable=yes,location=no, status=no';
	} else {
		parameter = 'height=480, width=660, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=yes, resizable=yes,location=no, status=no';
	}
	newWin = window.open(openUrl, 'variable', parameter);

};
//Display the person page 创建者与监控者
function displayPerson(flag) {
	$('cType').value = flag;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	openUrl = webpath
			+ "/view/workflow/wfactivityparticipant/WfActivityParticipant.jsp"
			+ "?flag=" + flag+ "&processId=" + procId + "&processVersion=" + procVer;
	;
	if (document.all) {
		parameter = 'height=500, width=710, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	} else {
		parameter = 'height=500, width=710,  top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	}
	newWin = window.open(openUrl, 'person', parameter);
}
// 编辑扩展属性
function editExtendProp(compId) {
	WFCommon.editExtendProperty(compId,compId);
}
// 前置条件与后置条件
function displayConditions(conditionType) {
	var conditionValue = "";
	if (conditionType == "preCondition") {
		conditionValue = document.getElementById("preCondition").value;
	} else {
		conditionValue = document.getElementById("postCondition").value;
	}
	var openUrl = "";
	/*var path = document.getElementById("path").value;*/

	openUrl = webpath + "/view/workflow/wfprocess/WfConditions.jsp?processId="
			+ procId + "&processVersion=" + procVer + "&conditionValue="
			+ encodeURIComponent(encodeURIComponent(conditionValue))
			+ "&conditionType=" + conditionType;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	if (document.all) {
		parameter = 'height=410, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	} else {
		parameter = 'height=410, width=570,  top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	}
	newWin = window.open(openUrl, 'condition', parameter);
}