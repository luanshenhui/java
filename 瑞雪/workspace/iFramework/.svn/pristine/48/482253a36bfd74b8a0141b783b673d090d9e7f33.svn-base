//查询
function doQuery(){
	var resultError = "";
	if(jQuery("#procDefID").val() == ""){
		resultError += "流程定义不能为空";
	}
	if(jQuery("#startDateStart").val() == "" || jQuery("#startDateEnd").val() == ""){
		if(jQuery("#procDefID").val() == ""){
			resultError += "\n";
		}
		resultError += "开始时间不能为空";
	}

	if(resultError != ""){
		alert(resultError);
		return;
	}
	var param={
			procDefID : jQuery("#procDefID").val() ,
			procDefVer : jQuery("#procDefVer").val() ,
			startDateStart : jQuery("#startDateStart").val() ,
			startDateEnd : jQuery("#startDateEnd").val(),
			endDateStart : jQuery("#endDateStart").val() ,
			endDateEnd : jQuery("#endDateEnd").val() 
		};
	ECSideUtil.queryECForm("ec", param, true);
}
//弹出流程列表页面
function doSelectProcess(){
	
	OpenModalWin(webpath + "/ProcessInstanceMonitorAction.do?method=getProcessList", 600, 400,window,'','');
	
}
//选择返回值
function setProcDefValue(id,ver,name){
	jQuery("#procDefID").val(id);
	jQuery("#procDefVer").val(ver);
	jQuery("#procInstName").val(name);
}
//重置
function doResert(){
	jQuery("#procDefID").val("");
	jQuery("#procDefVer").val("");
	jQuery("#startDateStart").val("");
	jQuery("#startDateEnd").val("");
	jQuery("#endDateStart").val("");
	jQuery("#endDateEnd").val("");
}

//挂起
function doSuspend(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要挂起的流程实例");
		return;
	}
	if(confirm("确认挂起？")){
		var procInstID = ECSideUtil.getPropertyValue(crow,"procInstID","ec");
		var url = webpath + "/ProcessInstanceMonitorAction.do?method=doSuspend";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				procInstID : procInstID
			},
			success : function(data) {
				if(data.info != "success"){
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
			}
		});
	}
}
//恢复 
function doResume(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要恢复的流程实例");
		return;
	}
	if(confirm("确认恢复？")){
		var procInstID = ECSideUtil.getPropertyValue(crow,"procInstID","ec");
		var url = webpath + "/ProcessInstanceMonitorAction.do?method=doResume";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				procInstID : procInstID
			},
			success : function(data) {
				if(data.info != "success"){
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
			}
		});
	}
}
//重启动
function doRestart(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要重启的流程实例");
		return;
	}
	if(confirm("确认重启动？")){
		var procInstID = ECSideUtil.getPropertyValue(crow,"procInstID","ec");
		var url = webpath + "/ProcessInstanceMonitorAction.do?method=doRestart";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				procInstID : procInstID
			},
			success : function(data) {
				if(data.info != "success"){
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
			}
		});
	}
}
//终止
function doTerminate(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要终止的流程实例");
		return;
	}
	if(confirm("确认终止？")){
		var procInstID = ECSideUtil.getPropertyValue(crow,"procInstID","ec");
		var url = webpath + "/ProcessInstanceMonitorAction.do?method=doTerminate";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				procInstID : procInstID
			},
			success : function(data) {
				if(data.info != "success"){
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
			}
		});
	}
}
//完成
function doComplete(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要完成的流程实例");
		return;
	}
	if(confirm("确认完成？")){
		var procInstID = ECSideUtil.getPropertyValue(crow,"procInstID","ec");
		var url = webpath + "/ProcessInstanceMonitorAction.do?method=doComplete";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				procInstID : procInstID
			},
			success : function(data) {
				if(data.info != "success"){
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
			}
		});
	}
}
//监控
function doMonitor(){
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择流程实例");
		return;
	}

	var procInstanceId = ECSideUtil.getPropertyValue(crow, "procInstID",
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