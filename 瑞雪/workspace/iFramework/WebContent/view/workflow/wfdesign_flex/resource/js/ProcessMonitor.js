/**
 * 监控工具刷新间隔(毫秒)
 * @returns {String}
 */
function getProcessInterval() {
    return refreshInterval;
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
 * 获取监控数据
 * @returns {String}
 */
function getProcessMonitorInfo() {
	var returnJSON = "1|获取流程监控数据失败";
	var procInstId = processInstanceId;

	var sURL = webpath + "/MonitorAction.do?method=getProcessMonitorInfo";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstId=" + procInstId,
		success : function(data) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = data.info;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = "1|获取流程监控数据失败";
		}
	});
	return returnJSON;
}

/**
 * 获取流程实例 ID
 * @returns
 */
function getProcessIntsanceId() {
   return processInstanceId;
}

/**
 * 流程实例操作
 * PAUSE 暂停   RESTORE 恢复  TERMINAT 终止   RESTART重新开始
 */
function processOperate(processInstanceId, actionCode) {
	//alert(actionCode);
	//return "0|流程实例操作成功";
	
	var returnJSON = "1|获取流程监控数据失败";

	var sURL = webpath + "/MonitorAction.do?method=procInstOperations";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "processInstanceId=" + processInstanceId + "&actionCode=" + actionCode,
		success : function(data) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = data.info;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = "1|获取流程监控数据失败";
		}
	});
	return returnJSON;
}

/**
 * 活动实例操作：
 * PAUSE 暂停   RESTORE 恢复  TERMINAT 终止   ROLLBACK回退
 */
function activitiOperate(activitiInstanceId, actionCode) {
	//alert(actionCode);
	//return "0|活动实例操作成功";
	var returnJSON = "1|获取活动监控数据失败";

	var sURL = webpath + "/MonitorAction.do?method=actInstOperations";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "activitiInstanceId=" + activitiInstanceId + "&actionCode=" + actionCode,
		success : function(data) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = data.info;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = "1|获取活动监控数据失败";
		}
	});
	return returnJSON;
}

/**
 * 获取监控按钮操作
 */
function getControlStregety() {
	var returnJSON = "1|流程控制数据失败";
	
	var sURL = webpath + "/MonitorAction.do?method=controlStretegy";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "controlStretegy=" + controlStretegy,
		success : function(data) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = data.info;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				returnJSON = "1|" + data.errorMessage;
			else
				returnJSON = "1|获取流程控制数据失败";
		}
	});
	return returnJSON;
}

/**
 * 打开流程实例监控页面
 */
function openProcessDetail() {
	var procInstId = processInstanceId;
	var openUrl = webpath
			+ "/MonitorAction.do?method=getProcessInstanceDetails&procInstId="
			+ procInstId;
	var left = (window.screen.availWidth - 600) / 2 + 20;
	var top = (window.screen.availHeight - 610) / 2;

	if (document.all) {
		parameter = 'height=610, width=600, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=610, width=600, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'procInstDetail', parameter);
}

/**
 * 打开活动实例监控页面
 * @param actInstId
 */
function openActivitiDetail(actInstId) {
	var openUrl = webpath
			+ "/MonitorAction.do?method=getActivityInstanceDetails&actInstId="
			+ actInstId;
	var left = (window.screen.availWidth - 850) / 2 + 20;
	var top = (window.screen.availHeight - 550) / 2;

	if (document.all) {
		parameter = 'height=550, width=850, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=550, width=850, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'actInstDetail', parameter);
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
