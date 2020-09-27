
// 设置页面元素可用可见性
function setPageElementStatus(pageCode) {
	var sURL1 = webpath + "/PrivilegeAction.do?method=getPEP&id="+pageCode;	
	
	jQuery.ajax( {
		url : sURL1,
		type : "post",
		dataType : "text",
		async : false,
		data : {id : pageCode},
		success : function(data) {
			if(data != undefined && data != null){
				var idList = data.split(",");
				for (var i=0; i<idList.length; i++){
					var temp = idList[i];
					var element = document.getElementById(temp);
					if(element != undefined && element != null){
						if (element.disabled == true) {
							element.disabled = false;
						}
					}
				}
			}
		}
	});
}