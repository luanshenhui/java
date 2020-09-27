jQuery(document).ready(function() {
	window.setTimeout(function() {
		doQuery('queryForm', 'ec');
	}, 500);
});

function doQuery(queryFormName, listFormName) {
	var queryPara = {
		procVersion : jQuery("#txtProcVersion").val(),
		procCategory : jQuery("#txtProcCategory").val(),
		procName : jQuery("#txtProcName").val()
	};
	ECSideUtil.queryECForm(listFormName, queryPara, true);
}

function copyProcess(bizCateId) {
	window.setTimeout(function() {
		var ecsideObj = ECSideUtil.getGridObj("ec");
		var crow = ecsideObj.selectedRow;
		if (crow == null || crow.cells[0] == undefined) {
			alert("请选择要复制的流程");
			return;
		}
		var procId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
		var procVersion = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");
	
		if (confirm("确认复制此流程吗？")) {
			var sURL = webpath + "/WfProcessAction.do?method=copyProcess";
			// 调用AJAX请求函数
			jQuery.ajax({
				url : sURL,
				async : false,
				type : "POST",
				dataType : "json",
				data : {
					procId : procId,
					procVersion : procVersion,
					bizCateId : bizCateId
				},
				success : function(data) {
					if (data.errorMessage)
						alert(data.errorMessage);
					else
						alert(data.info);
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					if (data.errorMessage)
						alert(data.errorMessage);
					else
						alert("网络错误");
				}
			});
		}
	}, 100);
}

function createProcessInstance() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择要创建实例的流程");
		return;
	}
	var procId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
	var procVersion = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");
	
	var relDataUrl = webpath + "/WfProcessAction.do?method=openRelDataList&procId="+procId+"&procVersion="+procVersion;
	var returnValue = window.showModalDialog(relDataUrl,null,"dialogHeight: 320px; dialogWidth: 600px; edge: Raised; center: Yes; help: No; scroll:No; resizable: No; status: No;");
	var sURL = "";
	if(returnValue&&returnValue!="empty") {
		sURL = webpath
				+ "/WfProcessAction.do?method=createProcessInstanceWithRelData";
	}else if(returnValue=="empty"){
		sURL = webpath + "/WfProcessAction.do?method=createProcessInstance";
	}
	else{
		return;
	}
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "POST",
		dataType : "json",
		data : {
			procId : procId,
			procVersion : procVersion,
			relData : returnValue
		},
		success : function(data) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else{
				alert(data.info);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("网络错误");
		}
	});
};

function addWfProcess() {
	if (bizCateId == undefined || bizCateId == "null" || bizCateId == 0
			|| bizCateId == "0") {
		alert("请选择业务分类");
		return;
	}
	var openUrl = webpath + "/WfProcessAction.do?method=create&procCateId="
			+ bizCateId;
	var left = 0;// (window.screen.availWidth - 635) / 2+20;
	var top = 0;// (window.screen.availHeight - 420) /2;

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
	newWin = window.open(openUrl, 'process', parameter);

	window.setTimeout(function() {
		// 下面代码把窗口最大化
		newWin.moveTo(0, 0);
		newWin.resizeTo(screen.availWidth, screen.availHeight);
		newWin.focus();
	}, 500);
}

function updateWfProcess() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择要修改的流程");
		return;
	}
	var processId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
	var processVersion = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");

	var sURL = webpath + "/WfProcessAction.do?method=showDetail&processId="
			+ processId + "&processVersion=" + processVersion;

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

	newWin = window.open(sURL, 'process', parameter);

	window.setTimeout(function() {
		// 下面代码把窗口最大化
		newWin.moveTo(0, 0);
		newWin.resizeTo(screen.availWidth, screen.availHeight);
		newWin.focus();
	}, 500);
}

/**
 * 激活流程定义
 */
function activeWfProcess() {
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择要激活的流程");
		return;
	}
	var procId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
	var procVersion = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");

	var sURL = webpath + "/WfProcessAction.do?method=active";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "POST",
		dataType : "json",
		data : {
			procId : procId,
			procVersion : procVersion
		},
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
				alert("网络错误");
		}
	});
}

function deleteWfProcess(queryFormName, listFormName) {
	// 存放最终在删除的所有checked流程
	var idString = "";
	// 用于存放当前页的id，历史页的id不在这里存放
	var currentPageIDs = "";
	// var allcheckarray =ECSideUtil.getPageCheckValue("checkBoxID");
	var allcheckarray = [];
	var ecsideObj = ECSideUtil.getGridObj(listFormName);
	var crow = ecsideObj.selectedRow;

	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择要删除的流程");
		return;
	}

	var tempProcId = "";
	var tempProcVer = "";
	var procId = jQuery(crow).map(function() {
		procId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
		procVer = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");
		return procId + "&" + procVer;
	}).get().join();

	allcheckarray.push(procId);
	if (allcheckarray)
		currentPageIDs = allcheckarray.join(",");
	// 表示hashtable中没有数据
	if (hashTable.hashtable.length == 0) {
		idString = currentPageIDs;
	} else {
		// 把每一页中选定的那些id都拼成一个串
		for ( var i = 0; i < hashTable.hashtable.length; i++) {
			if (hashTable.hashtable[i]) {
				idString += hashTable.hashtable[i];
				if (i < hashTable.hashtable.length - 1) {
					idString += ",";
				}
			}
		}
		if (ECSideUtil.trimString(currentPageIDs) != "")
			idString += ("," + currentPageIDs);
		idString = idString.split(",").uniq().join(",");
		// alert(idString);
	}

	// 去除空格
	idString = ECSideUtil.trimString(idString);
	if (idString == ",") {
		idString = null;
	}
	// 删除所选的流程id
	if (idString == null || idString == undefined || idString == "") {
		alert("请选择要删除的流程");
		return;
	}
	var wfprocessIds = idString;
	if (confirm("确认删除吗？")) {
		var sURL = webpath + "/WfProcessAction.do?method=deleteWfProcess";
		jQuery
				.ajax({
					url : sURL,
					async : false,
					type : "post",
					dataType : "json",
					data : {
						procIds : wfprocessIds
					},
					success : function(data) {
						if (data.errorMessage == null
								|| data.errorMessage == undefined) {
							alert("删除成功");
							// 删除后重新查询一下，相当于刷新
							var queryForm = $(queryFormName);
							var queryPara = {
								procId : queryForm["txtProcId"].value,
								procVersion : queryForm["txtProcVersion"].value,
								procCategory : queryForm["txtProcCategory"].value,
								procName : queryForm["txtProcName"].value
							};
							ECSideUtil.queryECForm(listFormName, queryPara,
									true);
						} else {
							if (data.errorMessage == "session timeout")
								window.location.href = webpath + "/login.jsp";
							else
								alert(data.errorMessage);
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						alert("网络错误");
						// 通常 textStatus 和 errorThrown 之中
						// 只有一个会包含信息
						// this; 调用本次AJAX请求时传递的options参数
					}
				});
	};
}

//流程导出方法
function doExportProcessInstance(){
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择要导出的流程");
		return;
	}
	var procId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
	var procVersion = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");
	if (confirm("确认导出此流程吗？")) {
		var sURL = webpath + "/WfProcessAction.do?method=doExportProcess&procId="+procId+"&procVersion="+procVersion;
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
		newWin = window.open(sURL, 'download', parameter);

	}
}
//流程导入方法
function doImportProcessInstance(bizCateId){
	if (bizCateId == null || bizCateId == "null" || bizCateId == "") {
		alert("请选择要导入的业务分类");
		return;
	}
	var sURL = webpath + "/view/workflow/wfprocess/WfProcessImport.jsp?bizCateId=" + bizCateId + "&bizCateName=" + bizCateName;
	var left = 0;
	var top = 0;

	if (document.all) {
		parameter = 'height=200, width=500, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
	} else {
		parameter = 'height=200, width=500, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
	}
	newWin = window.open(sURL, 'download', parameter);
}

//选择业务分类,selectType:copyProcess(流程复制),updateCategory(修改业务分类)
function categorySelect(selectType) {
	var sURL = webpath + "/view/workflow/wfbizcategory/WfBizCategorySelect.jsp?displayColumnName=bizCateName&selectType=" + selectType;
	var left = 400;
	var top = 200;

	if (document.all) {
		parameter = 'height=400, width=440, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
	} else {
		parameter = 'height=400, width=440, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no,scrollbars=1,resizable=1, location=no, status=no';
	}
	newWin = window.open(sURL, 'download', parameter);
}

//修改流程分类
function updateProcessCategory(bizCateId) {
	window.setTimeout(function() {
		var ecsideObj = ECSideUtil.getGridObj("ec");
		var crow = ecsideObj.selectedRow;
		if (crow == null || crow.cells[0] == undefined) {
			alert("请选择要复制的流程");
			return;
		}
		var procId = ECSideUtil.getPropertyValue(crow, "procId", "ec");
		var procVersion = ECSideUtil.getPropertyValue(crow, "procVersion", "ec");
	
		if (confirm("确认修改此流程的业务分类吗？")) {
			var sURL = webpath + "/WfProcessAction.do?method=updateProcessCategory";
			// 调用AJAX请求函数
			jQuery.ajax({
				url : sURL,
				async : false,
				type : "POST",
				dataType : "json",
				data : {
					procId : procId,
					procVersion : procVersion,
					bizCateId : bizCateId
				},
				success : function(data) {
					if (data.errorMessage)
						alert(data.errorMessage);
					else
						alert(data.info);
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					if (data.errorMessage)
						alert(data.errorMessage);
					else
						alert("网络错误");
				}
			});
		}
	}, 100);
}