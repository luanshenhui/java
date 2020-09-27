	 //页面加载后调用
    function LoadName(){ 
          if(action == "close"){
	          var xmlStr = document.appForm.xmlStr.value;
	           window.close();      
			if(templateNodeType != '')//把jsp的编辑信息，回写到flex树上
				opener.callFlexTree(xmlStr,id ,'',templateNodeType);
			else
				opener.callFlex(xmlStr , id);
          }
          else if(getSelectedAppType()=="wform"||getSelectedAppType()=="WebForm")//如果当前应用程序类型为表单，则显示表单的输入域
          {
	        	  document.getElementById('textURI').style.display="none";
	        	 document.getElementById('formURI').style.display="";	
          }
    }

//提交表单	
function submit_onclick(opFlag){
  	if (document.appForm.appName.value.replace(/\s/g, "") == "") {
		document.appForm.appName.focus();
		alert("名称不可以为空");
		document.appForm.appName.value = "";
		return false;
	}
  	var processId = jQuery("#processId").val();
  	var processVersion = jQuery("#processVersion").val();
  	var appId = jQuery("#appId").val();
	var appName = jQuery("#appName").val();
	var appDesc = jQuery("#appDesc").val();
	var appHost = jQuery("#appHost").val();
	var synchMode = jQuery("input[name=synchMode]:checked").val();
	var appType = jQuery("input[name=appType]:checked").val();
	var appUrl = jQuery("#appUrl").val();
  	if (opFlag == 0 || opFlag == "0") {
		var sURL = webpath + "/WfApplicationAction.do?method=create";
		// 调用AJAX请求函数
		$jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : 
				"processId="+processId
			+"&processVersion="+processVersion
			+"&appId="+appId
			+"&appName="+ appName
			+"&appDesc="+ appDesc
			+"&appHost="+ appHost
			+"&synchMode="+ synchMode
			+"&appType="+ appType
			+"&appUrl="+ appUrl
			+"&opFlag=0",
			success : function(data) {
			    window.close();
			    window.opener.location.href = window.opener.location.href;
			}
		});
	} else if (opFlag == 1 || opFlag == "1") {
		//保存对流程的修改
		var sURL1 = webpath + "/WfApplicationAction.do?method=update";
		jQuery.ajax( {
			url : sURL1,
			async : false,
			type : "post",
			dataType : "text",
			data : 
				 "processId="+processId
					+"&processVersion="+processVersion
					+"&appId="+appId
					+"&appName="+ appName
					+"&appDesc="+ appDesc
					+"&appHost="+ appHost
					+"&synchMode="+ synchMode
					+"&appType="+ appType
					+"&appUrl="+ appUrl
					+"&opFlag=1",
			success : function(data) {
				window.close();
				window.opener.location.href = window.opener.location.href;
			},	
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
			}
		});
	}
}

//校验输入域
function validateInput() {
	if (!((window.event.keyCode >= 48) && (window.event.keyCode <= 57))
			&& !((window.event.keyCode >= 65) && (window.event.keyCode <= 90))
			&& !((window.event.keyCode >= 97) && (window.event.keyCode <= 122))
			&& !(window.event.keyCode == 95)) {
		window.event.keyCode = 0;
	}
}
//获取选中的应用程序类型
function getSelectedAppType(){
	var types=document.getElementsByName("appType");
      	for(var i=0;i<types.length;i++){
      		var type=types[i];
      		if(type.checked)
      			return type.value;
  		}
}