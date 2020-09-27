function doImportProcess(){
	var processFile  = jQuery("input[name=processFile]").val();
	if(processFile.length <= 0){
		alert("请选择要导入的文件！");
		return false;
	}
	var fileNames = processFile.split(".");
	if (fileNames.length <= 0) {
		alert("请选择需要导入的流程文件，文件扩展名为.ipdl");
		return false;
	}
	if (fileNames[fileNames.length - 1] != "ipdl") {
		alert("请选择需要导入的流程文件，文件扩展名为.ipdl");
		return false;
	}
	jQuery("#wfProcessForm").submit();
}