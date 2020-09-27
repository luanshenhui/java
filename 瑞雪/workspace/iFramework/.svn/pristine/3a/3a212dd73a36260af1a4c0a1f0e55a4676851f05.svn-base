function initEvents(jsonStr) {
	for (var i = 0; i < jsonStr.length; i++) {
		//alert(jsonStr[i].eventType + "==" + jsonStr[i].application.appId + "==" + jsonStr[i].application.appName);
		setEvent(jsonStr[i].eventType, jsonStr[i].application.appId, jsonStr[i].application.appName);
	}
	enableCheckBox();
}

//将已经设置的事件变为可选择
function enableCheckBox(){
	var checkedBoxs=document.getElementsByName("events");
	for(var i=0;i<checkedBoxs.length;i++){
		var box=checkedBoxs[i];
		if(box.checked==true){
			var id=box.getAttribute("id");
			var eventApp = document.getElementById(id + "Text");
			var eventBtn = document.getElementById(id + "Button");
			eventApp.disabled = "";
			eventBtn.disabled = "";
		
		}
	}
}

function setEvent(eventType, action, actionName) {
	switch (eventType) {
		case 103 :
			document.getElementById("procSuspendEvent").checked = true;
			document.getElementById("procSuspendEventAction").value = action;
			document.getElementById("procSuspendEventText").value = actionName;
			break;
		case 109 :
			document.getElementById("procCompletedEvent").checked = true;
			document.getElementById("procCompletedEventAction").value = action;
			document.getElementById("procCompletedEventText").value = actionName;
			break;
		case 107 :
			document.getElementById("procAbortEvent").checked = true;
			document.getElementById("procAbortEventAction").value = action;
			document.getElementById("procAbortEventText").value = actionName;
			break;
		case 101 :
			document.getElementById("procStartEvent").checked = true;
			document.getElementById("procStartEventAction").value = action;
			document.getElementById("procStartEventText").value = actionName;
			break;
		case 102 :
			document.getElementById("procRestartEvent").checked = true;
			document.getElementById("procRestartEventAction").value = action;
			document.getElementById("procRestartEventText").value = actionName;
			break;
		case 104 :
			document.getElementById("procResumeEvent").checked = true;
			document.getElementById("procResumeEventAction").value = action;
			document.getElementById("procResumeEventText").value = actionName;
			break;
		case 100 :
			document.getElementById("procCreateEvent").checked = true;
			document.getElementById("procCreateEventAction").value = action;
			document.getElementById("procCreateEventText").value = actionName;
			break;
		case 108 :
			document.getElementById("forceTerminateEvent").checked = true;
			document.getElementById("forceTerminateEventAction").value = action;
			document.getElementById("forceTerminateEventText").value = actionName;
			break;
	}
}
function ock_check(id) {
	var obj = document.getElementById(id);
	var eventAction = document.getElementById(id + "Action");
	var eventApp = document.getElementById(id + "Text");
	var eventBtn = document.getElementById(id + "Button");
	if (obj.checked == true) {
		eventApp.disabled = "";
		eventBtn.disabled = "";
	} else {
		eventAction.value = "";
		eventApp.value = "";
		eventApp.disabled = "disabled";
		eventBtn.disabled = "disabled";
	}
}
function setParentValue(processId,processVersion) {
	var isComplete = true;
	var events = [];
	var ret = "";
	events = document.getElementsByName("events");
	for (var i = 0; i < events.length; i++) {
		var eventID= new UUID() + "";
		if (events[i].checked) {
			//流程事件类型
			var eventType = document.getElementById(events[i].id + "Type").value;
			//流程事件应用Id
			var eventAction = document.getElementById(events[i].id + "Action").value;
			//流程事件应用名称
			var actionName = document.getElementById(events[i].id + "Text").value;
			if (eventAction == "") {
				isComplete = false;
				break;
			}
			ret += eventID;
			ret += ","+eventType;
			ret += "," + eventAction;
			ret += "," + actionName;
			ret += ";";
		}
	}
	var sURL = webpath +"/WfProcessAction.do?method=saveProcessEvent";
	if (isComplete) {
		$jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : "processId=" + processId + "&processVersion=" +processVersion+"&events="+ret,
			success : function(data) {
				window.close();
			}
		});
		window.close();
	} else {
		alert("请选择应用程序");
	}
}

// Open application dialog
function openApp(processId, processVersion, eventId) {
//	var obj = event.srcElement ? event.srcElement : event.target;
//	var applicationPageName = obj.name;
	/*var path = document.getElementById("projectPath").value;*/
	var left = (window.screen.availWidth - 635) / 2 + 320;
	var top = (window.screen.availHeight - 420) / 2;
	/*openUrl = path
			+ "/view/workflow/wfapplication/applicationManager.jsp?"
			+ "applicationPageName=" + applicationPageName;*/
	/*openUrl = path
	+ "/view/workflow/wfapplication/WfApplicationSelect.jsp?"
	+ "applicationPageName=" + applicationPageName;*/
	//openUrl = webpath + "/view/workflow/wfapplication/WfApplicationSelect.jsp?" + "applicationPageName=" + applicationPageName + "&processId=" + processId + "&processVersion=" + processVersion;
	//openUrl = webpath + "/view/workflow/wfapplication/WfApplicationSelect.jsp?processId=" + processId + "&processVersion=" + processVersion;  
	openUrl = webpath + "/WfProcessAction.do?method=selectApp&processId=" + processId + "&processVersion=" + processVersion + "&eventId=" + eventId;
	if(document.all){			  
	  	parameter='height=420, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }else{
	  	parameter='height=420, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }
	 newWin=window.open(openUrl, 'application', parameter);  

	
}

function validateInput() {

	if (!((window.event.keyCode >= 48) && (window.event.keyCode <= 57))
			&& !((window.event.keyCode >= 65) && (window.event.keyCode <= 90))
			&& !((window.event.keyCode >= 97) && (window.event.keyCode <= 122))
			&& !(window.event.keyCode == 95)) {
		window.event.keyCode = 0;
	}
}
