jQuery(document).ready(function() {
	window.setTimeout(function(){
		doQuery('queryForm', 'ec');
	}, 100);
});

function doQuery(queryFormName, listFormName) {
	var queryPara = {
		workItemType : jQuery("#workItemType").val()
	};

	ECSideUtil.queryECForm(listFormName, queryPara, true);
}

function modifyRelateData() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");

	var openUrl = webpath
			+ "/WorkitemManagementAction.do?method=getRelateDataInstance&procInstanceId="
			+ procInstanceId;// + "&events=" + events;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;

	if (document.all) {
		parameter = 'height=430, width=670, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=455, width=670, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'relateData', parameter);
	doQuery('queryForm', 'ec');
}

// 接受
function doAccept() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doAccept";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				// 接受后执行查询操作
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 拒收
function doRefuse() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doRefuse";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 办理
function doDeal() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}

	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doDeal";
	// 调用AJAX请求函数
	jQuery
			.ajax({
				url : sURL,
				async : false,
				type : "get",
				dataType : "json",
				data : "workitemId=" + workitemId,
				success : function(data) {
					if (data.errorMessage)
						alert(data.errorMessage);
					else if (data.URL) {
						var openUrl = webpath + data.URL + "?processInstId="
								+ procInstanceId + "&activityInstId="
								+ activityInstId + "&workitemId=" + workitemId;
						var left = 0;
						var top = 0;

						if (document.all) {
							parameter = 'height=600, width=800, top='
									+ top
									+ ', left='
									+ left
									+ ', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
						} else {
							parameter = 'height=600, width=800, top='
									+ top
									+ ', left='
									+ left
									+ ', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
						}
						newWin = window.open(openUrl, 'bizForm', parameter);
						doQuery('queryForm', 'ec');
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					if (data.errorMessage)
						alert(data.errorMessage);
				}
			});
}

// 完成
function doComplete() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doComplete";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 暂停
function doPause() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doPause";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 恢复
function doRestore() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doRestore";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 终止
function doStop() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doStop";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 加签
function doAddsigner() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var openUrl = webpath
			+ "/WorkitemManagementAction.do?method=openAddSignerPage&procInstanceId="
			+ procInstanceId + "&activityInstId=" + activityInstId
			+ "&workitemId=" + workitemId;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;

	if (document.all) {
		parameter = 'height=530, width=670, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=530, width=670, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'addSigner', parameter);
	doQuery('queryForm', 'ec');
}

// 签收
function doSign() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=doSign";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "procInstanceId=" + procInstanceId + "&activityInstId="
				+ activityInstId + "&workitemId=" + workitemId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 单步回退
function dobackByStep() {
	// TODO 这里要先在表格上加activityInstance 的 ID。

	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}

	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");

	var sURL = webpath + "/WorkitemManagementAction.do?method=dobackByStep";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "activityInstId=" + activityInstId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 自由回退
function doBackByfree() {
	// TODO 同上，要先加activityInstance ID
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}

	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var targetActId = "";

	var sURL = webpath + "/WorkitemManagementAction.do?method=doBackByfree";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "get",
		dataType : "json",
		data : "activityInstId=" + activityInstId + "&targetActId="
				+ targetActId,
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				doQuery('queryForm', 'ec');
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("操作不成功。");
		}
	});
}

// 派送
function doSend() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}

	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var activityId = ECSideUtil.getPropertyValue(crow, "activityId", "ec");
	var processId = ECSideUtil.getPropertyValue(crow, "processId", "ec");
	var processVer = ECSideUtil.getPropertyValue(crow, "processVer", "ec");

	var openUrl = webpath
			+ "/WorkitemManagementAction.do?method=openSend&activityId="
			+ activityId + "&processId=" + processId + "&processVer="
			+ processVer + "&procInstanceId=" + procInstanceId
			+ "&activityInstId=" + activityInstId + "&workitemId=" + workitemId;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;

	if (document.all) {
		parameter = 'height=135, width=220, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=135, width=220, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'sendTo', parameter);
	doQuery('queryForm', 'ec');
}

// 特送
function doSendPre() {

	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}

	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var activityInstId = ECSideUtil.getPropertyValue(crow, "activityInsId",
			"ec");
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");

	var activityId = ECSideUtil.getPropertyValue(crow, "activityId", "ec");
	var processId = ECSideUtil.getPropertyValue(crow, "processId", "ec");
	var processVer = ECSideUtil.getPropertyValue(crow, "processVer", "ec");

	var openUrl = webpath
			+ "/WorkitemManagementAction.do?method=openSendPre&activityId="
			+ activityId + "&processId=" + processId + "&processVer="
			+ processVer + "&procInstanceId=" + procInstanceId
			+ "&activityInstId=" + activityInstId + "&workitemId=" + workitemId;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;

	if (document.all) {
		parameter = 'height=530, width=670, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	} else {
		parameter = 'height=530, width=670, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	}
	newWin = window.open(openUrl, 'sendToFree', parameter);
	doQuery('queryForm', 'ec');
}

// 监控
function doMonitor() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}

	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstanceId",
			"ec");
	var openUrl = webpath + "/MonitorAction.do?method=openProcessMonitor&procInstId=" + procInstanceId;
	var left = 0;//(window.screen.availWidth - 635) / 2+20;
	var top = 0;//(window.screen.availHeight - 420) /2;
	  
	if(document.all){			  
		parameter='height=600, width=800, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
	}else{
		parameter='height=600, width=800, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
	}
	newWin=window.open(openUrl, 'process', parameter);

	window.setTimeout(function() {
		// 下面代码把窗口最大化
		newWin.moveTo(0,0);
		newWin.resizeTo(screen.availWidth,screen.availHeight);
		newWin.focus();
	}, 500);

}

function openProcInstDetails() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var procInstId = ECSideUtil.getPropertyValue(crow, "procInstanceId", "ec");

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

function openActInstDetails() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	var actInstId = ECSideUtil.getPropertyValue(crow, "activityInsId", "ec");

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