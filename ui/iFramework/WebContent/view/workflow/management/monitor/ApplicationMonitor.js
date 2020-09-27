$jQuery(function(){ 
	$jQuery( "#tabs" ).tabs({"cache":false});
});
//查询
function doQuery(){
	var resultError = "";
//	if(jQuery("#procDefID").val() == ""){
//		resultError += "流程定义不能为空";
//	}
	if(jQuery("#startDateStart").val() == "" || jQuery("#startDateEnd").val() == ""){
//		if(jQuery("#procDefID").val() == ""){
//			resultError += "\n";
//		}
		resultError += "开始时间不能为空";
	}

	if(resultError != ""){
		alert(resultError);
		return;
	}
	var param={
			//procDefID : jQuery("#procDefID").val() ,
			procDefVer : jQuery("#procDefVer").val() ,
			startDateStart : jQuery("#startDateStart").val() ,
			startDateEnd : jQuery("#startDateEnd").val(),
			endDateStart : jQuery("#endDateStart").val() ,
			endDateEnd : jQuery("#endDateEnd").val() 
		};
	if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-1"){
		ECSideUtil.queryECForm("ec", param, true);
	}else if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-2"){
		ECSideUtil.queryECForm("ec2", param, true);
	}else{
		ECSideUtil.queryECForm("ec3", param, true);	
	}
}
//弹出流程列表页面
function doSelectProcess(){
	
	OpenModalWin(webpath + "/ProcessInstanceMonitorAction.do?method=getProcessList", 600, 400,window,'','');
	
}
//选择返回值
function setProcDefValue(id,ver,name){
	//jQuery("#procDefID").val(id);
	jQuery("#procDefVer").val(ver);
	jQuery("#procInstName").val(name);
}
//重置
function doResert(){
	//jQuery("#procDefID").val("");
	jQuery("#procDefVer").val("");
	jQuery("#startDateStart").val("");
	jQuery("#startDateEnd").val("");
	jQuery("#endDateStart").val("");
	jQuery("#endDateEnd").val("");
}

//删除
function doDelete(){
	var name;
	if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-1"){
		name = "ec";
	}else if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-2"){
		name = "ec2";
	}else{
		name = "ec3";
	}
	var ecsideObj=ECSideUtil.getGridObj(name);
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要删除的应用程序");
		return;
	}
	if(confirm("确认删除？")){
		var jobName = ECSideUtil.getPropertyValue(crow,"jobName",name);
		var url = webpath + "/ApplicationMonitorAction.do?method=doDetele";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				jobName : jobName
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
	var name;
	if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-1"){
		name = "ec";
	}else if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-2"){
		name = "ec2";
	}else{
		name = "ec3";
	}
	var ecsideObj=ECSideUtil.getGridObj(name);
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要恢复的应用程序");
		return;
	}
	if(confirm("确认恢复？")){
		var jobName = ECSideUtil.getPropertyValue(crow,"jobName",name);
//		if (jobName == null || jobName == "") {
//			alert("作业名称不可为空");
//		}
		var url = webpath + "/ApplicationMonitorAction.do?method=doResume";
		jQuery.ajax( {
			url : url,
			type : "post",
			dataType : "json",
			data : {
				jobName : jobName
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
//详情
function doDetail(){
	var name;
	if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-1"){
		name = "ec";
	}else if(jQuery("li[aria-selected='true']").attr("aria-labelledby") == "ui-id-2"){
		name = "ec2";
	}else{
		name = "ec3";
	}
	var ecsideObj=ECSideUtil.getGridObj(name);
	var crow=ecsideObj.selectedRow;
	if (crow == null || crow.cells[0] == undefined){
		alert("请选择要查看的应用程序");
		return;
	}
}