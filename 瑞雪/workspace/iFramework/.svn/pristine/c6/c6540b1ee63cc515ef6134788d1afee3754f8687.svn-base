function openStartActivity(activityId, activityName) {
	var heightweight="height=240, width=600, ";
	myWin = window.open(webpath + "/WfStartActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId + "&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();
}

function openFinishActivity(activityId, activityName) {
	var heightweight="height=240, width=600, ";
	myWin = window.open(webpath + "/WfFinishActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId + "&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();
}

function openSplitActivity(activityId, activityName) {
	var heightweight="height=240, width=620, ";
	myWin = window.open(webpath + "/WfSplitActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId+ "&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();
}

function openManualActivity(activityId, activityName) {
	var heightweight="height=530, width=580, ";
	myWin = window.open(webpath + "/WfManualActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId+ "&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();	
}

function openAutomaticActivity(activityId, activityName) {
	var heightweight="height=350, width=580, ";
	myWin = window.open(webpath + "/WfAutomaticActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId+ "&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();
}

function openParallelActivity(activityId, activityName) {
	var heightweight="height=280, width=620, ";
	myWin = window.open(webpath + "/WfParallelSplitActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId + "&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();
}

function openMergeActivity(activityId, activityName) {
	var heightweight="height=310, width=620, ";
	myWin = window.open(webpath + "/WfMergeActivity.do?method=find&processId=" + processId + "&processVersion=" + processVersion + "&activityId=" + activityId + 
			"&activityName=" + activityName, 'activity', heightweight + 'toolbar=0,scrollbars=0,location=no,status=no,statusbar=0,menubar=0,resizable=1,left=100,top=100');
	myWin.focus();
}

function openProcess() {
	var left = (window.screen.availWidth - 600) / 2 + 20;
	var top = (window.screen.availHeight - 500) / 2;
	var openUrl = webpath + "/view/workflow/wfprocess/WfProcessDetail.jsp?processId=" + processId + 
	"&processVersion=" + processVersion + "&opFlag="+opFlag;
	if (document.all) {
		parameter = 'height=480, width=600, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=480, width=600, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	myWin = window.open(openUrl , 'activity', parameter);
	myWin.focus();
}
// 删除流程定义(新建状态，关闭窗口、点退出设计器，结束浏览器进程、超时、断网等情况除外)
function deleteProcess(){
	// TODO
}

// 创建活动，activityType参见Java类中的定义ActivityType.java
function createActivity(activityId, actType, actName) {
	var actionName = "";
	switch (actType) {
	case 0:
		actionName = "/WfManualActivity";
		break;
	case 1:
		actionName = "/WfAutomaticActivity";
		break;
	case 2:
		actionName = "/WfSubProcessActivity";
		break;
	case 3:
		actionName = "/WfStartActivity";
		break;
	case 4:
		actionName = "/WfFinishActivity";
		break;
	case 5:
		actionName = "/WfSplitActivity";
		break;
	case 6:
		actionName = "/WfParallelSplitActivity";
		break;
	case 7:
		actionName = "/WfMergeActivity";
		break;
	}
	var sURL = webpath + actionName + ".do?method=create";
	var returnValue="1|创建活动失败";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : "processId=" + processId + "&processVersion=" + processVersion + 
		"&actId=" + activityId + "&actName=" + actName,
		success : function(data) {
			returnValue = "0|成功";
		},
		error : function(){
			returnValue = "1|网络错误";
		}
	});
	return returnValue;
	//alert("1" + activityId + "==" + actType + "===" + actName);
}

/**
 * 删除活动
 * @param activityId 活动id
 * @param actType 活动类型
 * @returns 0成功，非0为失败。“|”后是具体的失败原因
 */
function deleteActivity(activityId,actType) {
	var actionName = "";
	switch (actType) {
	case 0:
		actionName = "/WfManualActivity";
		break;
	case 1:
		actionName = "/WfAutomaticActivity";
		break;
	case 2:
		actionName = "/WfSubProcessActivity";
		break;
	case 3:
		actionName = "/WfStartActivity";
		return "1|开始活动不能删除！";
		break;
	case 4:
		actionName = "/WfFinishActivity";
		return "1|完结活动不能删除！";
		break;
	case 5:
		actionName = "/WfSplitActivity";
		break;
	case 6:
		actionName = "/WfParallelSplitActivity";
		break;
	case 7:
		actionName = "/WfMergeActivity";
		break;
	}
	var sURL = webpath + actionName + ".do?method=delete";
	var returnValue="1|删除活动失败";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : "processId=" + processId + "&processVersion=" + processVersion + 
		"&actId=" + activityId,
		success : function(data) {
			returnValue = "0|成功";
		},
		error : function(){
			returnValue = "1|网络错误";
		}
	});
	return returnValue;
	//alert(activityId);
}

//创建传输线，activityType参见Java类中的定义ActivityType.java
function createTransition(transId, transName, fromActId, toActId) {
	var returnValue="1|创建传输线失败";
	var sURL = webpath + "/WfTransitionAction.do?method=create";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "POST",
		dataType : "text",
		data : "processId=" + processId + "&processVersion=" + processVersion + 
		"&transId=" + transId + "&transName=" + transName + "&fromActId=" + 
		fromActId + "&toActId=" + toActId,
		success : function(data) {
			returnValue = "0|成功";
		},
		error : function(){
			returnValue = "1|网络错误";
		}
	});
	return returnValue;
	//alert(transId + "==" + transName + "==" + fromActId + "==" + toActId);
}

// 删除传输线
function deleteTransition(transId) {
	//alert("删传输线");
	var returnValue="1|删除传输线失败";
	var sURL = webpath + "/WfTransitionAction.do?method=delete";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : "processId=" + processId + "&processVersion=" + processVersion + 
		"&transId=" + transId,
		success : function(data) {
			returnValue = "0|成功";
		},
		error : function(){
			returnValue = "1|网络错误";
		}
	});
	return returnValue;
	//alert(transId);
}

//打开传输线对话框
function openTransition(transId, transName, fromActId, toActId) {
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	var openUrl = webpath + "/view/workflow/wftransition/wfTransition.jsp?transId=" + transId + 
	"&processId=" + processId + "&processVersion=" + processVersion + "&fromActId=" + fromActId + 
	"&toActId=" + toActId;
	if (document.all) {
		parameter = 'height=570, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no, location=no, status=no';
	} else {
		parameter = 'height=570, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no, location=no, status=no';
	}
	myWin = window.open(openUrl, 'activity', parameter);
	myWin.focus();
}

function getProcessIdVersion() {
    return processId + "," + processVersion;
}

// publishProcess
function publishProcess(xmlStr){
	//xmlStr = encodeURI(xmlStr);
	var sURL = webpath + "/WfProcessAction.do?method=publish";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "json",
		data : "processId=" + processId + "&processVersion=" + processVersion + "&opFlag=" + opFlag +
		"&processXML=" + xmlStr,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else {
				alert(data.info);
				window.close();
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("网络错误");
		}
	});
    //alert(xmlStr);
}



/**
 * 0新增，1修改
 * @returns {Number}
 */
function getOPStatus(){
    return opFlag; 
}

/**
 * 修改时，获取流程定义xml
 * @returns {String}
 */
function getProcessXML(){
	var returnXML = processXML;
	if(processXML.indexOf("&gt;")>0){
		returnXML = WFCommon.HTMLDeCode(processXML);
	}
    return returnXML;
}

/**
 * 更新活动名称
 * @param actId
 * @param actName
 */
function updateActivity(actId, actName){	
	document.getElementById("iLead_Workflow").updateActivity(actId,actName);
}

/**
 * 设计器弹出对话框
 * @param messageStr
 */
function alertMessage(messageStr){
    alert(messageStr);
}

/**
 * 关闭当前窗口
 * @param messageStr
 */
function closeCurrentWindow(messageStr){
	if(confirm(messageStr)){
		window.close();
	}
}


/**
 * 更新传输线名称
 * @param transId
 * @param transName
 */
function updateTransition(transId, transName){
	document.getElementById("iLead_Workflow").updateTransition(transId,transName);
}

/**
 * 验证流程定义的有效性
 */
function validateProcess(){
	//alert("yeal i am here");
	var returnValue = "0|验证通过";
	var sURL = webpath + "/WfProcessAction.do?method=validateProcess";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "json",
		data : "processId=" + processId + "&processVersion=" + processVersion,
		success : function(data) {
			if (data.errorMessage) {
				returnValue = "1|" + data.errorMessage;
			} else if (data.ErrorMessageList) {
				returnValue = "1|" + JSON.stringify( data.ErrorMessageList );
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			if (data.errorMessage)
				returnValue = "1|" + data.errorMessage;
			else
				returnValue = "1|" + "网络错误";
		}
	});
	return returnValue;
}

/**
 * 清空画布
 */
function emptyCanvas(){
	//alert("emptyCanvas");
	var returnValue = "0|清空成功";
	var sURL = webpath + "/WfProcessAction.do?method=emptyProcess";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "json",
		data : "processId=" + processId + "&processVersion=" + processVersion,
		success : function(data) {
			if (data.errorMessage) {
				returnValue = "1|" + data.errorMessage;
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			if (data.errorMessage)
				returnValue = "1|" + data.errorMessage;
			else
				returnValue = "1|" + "网络错误";
		}
	});
	return returnValue;
}