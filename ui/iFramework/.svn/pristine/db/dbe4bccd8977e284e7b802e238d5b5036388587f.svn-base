jQuery(function($) {
	jQuery(document).ready(function() {
		if (obj!=null && obj != ""){
			initEvents(obj);
		}
	});
});

function initEvents(jsonStr) {
	for (var i = 0; i < jsonStr.length; i++) {
//		alert(jsonStr[i].eventType + "==" + jsonStr[i].application.appId + "==" + jsonStr[i].application.appName);
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
		case 203 :
			document.getElementById("actSuspendEvent").checked = true;
			document.getElementById("actSuspendEventAction").value = action;
			document.getElementById("actSuspendEventText").value = actionName;
			break;
		case 211 :
			document.getElementById("actRollbackEvent").checked = true;
			document.getElementById("actRollbackEventAction").value = action;
			document.getElementById("actRollbackEventText").value = actionName;
			break;
		case 207 :
			document.getElementById("actAbortEvent").checked = true;
			document.getElementById("actAbortEventAction").value = action;
			document.getElementById("actAbortEventText").value = actionName;
			break;
		case 209 :
			document.getElementById("actCompletedEvent").checked = true;
			document.getElementById("actCompletedEventAction").value = action;
			document.getElementById("actCompletedEventText").value = actionName;
			break;
		case 201 :
			document.getElementById("actStartEvent").checked = true;
			document.getElementById("actStartEventAction").value = action;
			document.getElementById("actStartEventText").value = actionName;
			break;
		case 204 :
			document.getElementById("actResumeEvent").checked = true;
			document.getElementById("actResumeEventAction").value = action;
			document.getElementById("actResumeEventText").value = actionName;
			break;
		case 200 :
			document.getElementById("actCreateEvent").checked = true;
			document.getElementById("actCreateEventAction").value = action;
			document.getElementById("actCreateEventText").value = actionName;
			break;
		case 208 :
			document.getElementById("forceTerminateEvent").checked = true;
			document.getElementById("forceTerminateEventAction").value = action;
			document.getElementById("forceTerminateEventText").value = actionName;
			break;
		case 210 :
			document.getElementById("withdrawEvent").checked = true;
			document.getElementById("withdrawEventAction").value = action;
			document.getElementById("withdrawEventText").value = actionName;
			break;
		case 301 :
			document.getElementById("openEvent").checked = true;
			document.getElementById("openEventAction").value = action;
			document.getElementById("openEventText").value = actionName;
			break;
		case 304 :
			document.getElementById("regretEvent").checked = true;
			document.getElementById("regretEventAction").value = action;
			document.getElementById("regretEventText").value = actionName;
			break;
		case 302:
			document.getElementById("suspendEvent").checked = true;
			document.getElementById("suspendEventAction").value = action;
			document.getElementById("suspendEventText").value = actionName;
			break;
		case 306 :
			document.getElementById("completedEvent").checked = true;
			document.getElementById("completedEventAction").value = action;
			document.getElementById("completedEventText").value = actionName;
			break;
		case 305 :
			document.getElementById("abortEvent").checked = true;
			document.getElementById("abortEventAction").value = action;
			document.getElementById("abortEventText").value = actionName;
			break;
		case 303 :
			document.getElementById("resumeEvent").checked = true;
			document.getElementById("resumeEventAction").value = action;
			document.getElementById("resumeEventText").value = actionName;
			break;
		case 300 :
			document.getElementById("createEvent").checked = true;
			document.getElementById("createEventAction").value = action;
			document.getElementById("createEventText").value = actionName;
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
function setParentValue(processId,processVersion,actId) {
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
	var sURL = webpath +"/WfManualActivity.do?method=saveManualActEvent";
	if (isComplete) {
		$jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : "processId=" + processId + "&processVersion=" +processVersion+"&events="+ret+"&actId="+actId,
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
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 500) / 2;
	openUrl = webpath + "/WfProcessAction.do?method=selectApp"
			+ "&processId="+processId+"&processVersion="+processVersion+"&eventId="+eventId;
	if(document.all){			  
	  	parameter='height=420, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }else{
	  	parameter='height=420, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }
	newWin = window.open(openUrl,"application",parameter);
}
