jQuery(document).ready(function(){
	window.setTimeout(function(){
		doQuery('queryForm', 'ec');
	}, 100);
});

function doQuery(queryFormName,listFormName){
	var queryPara={
		workItemType : jQuery("#workItemType").val()
	};
	
	ECSideUtil.queryECForm(listFormName,queryPara,true);
}
//查看
function doView1(){
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	
	var sURL = webpath + "/WorkitemManagementAction.do?method=doView";
	jQuery.ajax( {
		url : sURL,
		type : "post",
		dataType : "json",
		data : {

		},
		success : function(data) {
			if(data.errorMessage == undefined){
				alert("查看操作成功！");
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


//查看
function doView() {
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
//回收
function doRecover(){
	var ecsideObj = ECSideUtil.getGridObj("ec");
	var crow = ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined) {
		alert("请选择作业项目");
		return;
	}
	
	var workitemId = ECSideUtil.getPropertyValue(crow, "workitemInsId", "ec");
	
	var sURL = webpath + "/WorkitemManagementAction.do?method=doRecover";
	jQuery.ajax( {
		url : sURL,
		type : "post",
		dataType : "json",
		data : {
			type : 0,
			workitemId : workitemId
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				// 取回操作成功后，执行查询操作。
				doQuery('queryForm', 'ec');
				alert("取回操作成功！");
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