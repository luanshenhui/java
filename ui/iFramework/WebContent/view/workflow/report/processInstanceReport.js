//查询
function doQuery(){
	jQuery("#error").text("");
	var name= jQuery("#name").val();
	var end_date= jQuery("#end_date").val();
	var start_date= jQuery("#start_date").val();
	var resultError = "";
	if(name == ""){
		resultError += "流程分类不能为空    ";
	}
	if(end_date == ""){
		resultError += "开始时间不能为空    ";
	}
	if(start_date == ""){
		resultError += "结束时间不能为空    ";
	}
	if(resultError != ""){
		jQuery("#error").text(resultError);
		return;
	}
	var tempurl = webpath+"/frameset?__locale=zh-CN&__toolbar=false&__report=view/workflow/report/processInstanceReport.rptdesign&name=" + name + "&end_date=" +end_date +"&start_date=" +start_date;
	document.getElementById("report").src= tempurl; 
}