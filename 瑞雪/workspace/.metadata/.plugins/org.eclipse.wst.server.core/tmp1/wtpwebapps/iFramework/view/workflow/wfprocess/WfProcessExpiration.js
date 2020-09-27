//Sent value to parent page
function setParentValue(){
	var sendDelayTime=sumDelayTime();//Delay time
	var sendAlertTime=sumAlertTime();//Alarm time
	var sendIntervalTime=sumIntervalTime();//Alarm interval time
	var sendDelayVar=$('dRadio').value;//Delay radio
	var sendAlertVar=$('alertRadio').value;//Alarm radio
	var sendDelayType=radioValue('delayType');//Delay type
	var sendAlertType=radioValue('alertType');//Alarm type
	var sendDA = "";
	var sendAA = "";
	if(sendDelayType=="3"){
		sendDA=$('actionApplication').value;//Delay application program
	}
	if(sendAlertType=="1"){
		sendAA=$('alertActionApplication').value;//Alarm application program
	}
	//var sendExAn=$('delayApplication').value;//Alarm application program
	//var sendExAAN=$('alertApplication').value;//Alarm application program
	var sendRemindCount=$('remindCount').value;//Alarm count
	if(checkIntervalTime()==false) {alert("请输入正确的数字");return;}
	//window.opener.document.getElementById("exActionName").value = sendExAn;//send Delay Time
	//window.opener.document.getElementById("exAlertActionName").value =sendExAAN;//send Delay Time
	window.opener.document.getElementById("overdueTimelimit").value =sendDelayTime;//send Delay Time
	window.opener.document.getElementById("remindTimelimit").value=sendAlertTime;//send Alert Time
	window.opener.document.getElementById("remindInterval").value=sendIntervalTime;//send alarm Interval Time
	window.opener.document.getElementById("overdueRdata").value=sendDelayVar;//send delay radio variable choice
	window.opener.document.getElementById("remindRdata").value=sendAlertVar;//send alerm radio variable choice
	window.opener.document.getElementById("overdueAction").value=sendDelayType;//send delay type
	window.opener.document.getElementById("remindAction").value=sendAlertType;//send alarm type
	window.opener.document.getElementById("overdueApp").value=sendDA;//send Delay application program
	window.opener.document.getElementById("remindApp").value=sendAA;//send Alarm application program
	window.opener.document.getElementById("remindCount").value=sendRemindCount;//send Alarm application program
	
//	var sURL1 = webpath + "/WfProcessAction.do?method=saveProcessExpiration";
//	jQuery.ajax( {
//		url : sURL1,
//		async : false,
//		type : "post",
//		dataType : "text",
//		data : {
//			procId : processId,
//			procVersion : processVersion,
//			overdueTimelimit : sendDelayTime,
//			overdueRdata : sendDelayVar,
//			overdueAction : sendDelayType,
//			overdueApp : sendDA,
//			remindTimelimit : sendAlertTime,
//			remindRdata : sendAlertVar,
//			remindAction : sendAlertType,
//			remindApp : sendAA,
//			remindInterval : sendIntervalTime,
//			remindCount : sendRemindCount,
//			opFlag : "1"
//		},
//		success : function(data) {
//			//blnReturn = true;
//		},
//		error : function(XMLHttpRequest,textStatus,errorThrown){
//			alert("网络错误");
//		}
//	});
	window.opener = null;
	window.close();
}

function ffNum(id){
	if(document.all){}
	else{
		$(id).value=$(id).value.replace(/[^0-9]/g,'');
	}
}

function displayDiv() {
	var durationTime = 0;
	var alertDurationTime = 0;
	var aInterval = 0;

	if ($('duration').value == ""
			|| ($("duration").value.length > 1 && $("duration").value.charAt(0) == 0)
			|| /[^\d+]/g.test($("duration").value)) {
		alert("超时时间设置错误！");
		return;
	} else {
		durationTime = parseInt($('duration').value);
	}
	if ($('alertDuration').value == ""
			|| ($("alertDuration").value.length > 1 && $("alertDuration").value
					.charAt(0) == 0)
			|| /[^\d+]/g.test($("alertDuration").value)) {
		alert("催办时间设置错误！");
		return;
	} else {
		alertDurationTime = parseInt($('alertDuration').value);
	}
	if ($('alertActionInterval').value == ""
			|| ($("alertActionInterval").value.length > 1 && $("alertActionInterval").value
					.charAt(0) == 0)
			|| /[^\d+]/g.test($("alertActionInterval").value)) {
		alert("催办间隔设置错误！");
		return;
	} else {
		aInterval = parseInt($('alertActionInterval').value);
	}

	 if($('alertApp').checked==true) displayAlertApp();
	 if($('delayApp').checked==true) displayDelayApp();
	// if($('radioDelayTime').checked==true) displayDelayInput();
	// if($('alertDelayTime').checked==true) displayAlertInput();
	var overdueAction = jQuery("#actionType").val();
	if (overdueAction != "") {
		jQuery("input[name=delayType][value=" + overdueAction + "]").attr(
				"checked", 'checked');
		if (overdueAction == "3") {
			$('application1').style.display = "block";
		}
	}
	var remindAction = jQuery("#alertActionType").val();
	if (overdueAction != "") {
		jQuery("input[name=alertType][value=" + remindAction + "]").attr(
				"checked", 'checked');
		if (remindAction == "1") {
			$('application2').style.display = "block";
		}
	}

	$("durationDay").value = parseInt(durationTime / (24 * 60));
	$("durationHour").value = parseInt((durationTime - parseInt(durationTime
			/ (24 * 60)) * 24 * 60) / 60);
	$("durationMin").value = (durationTime - parseInt(durationTime / (24 * 60)) * 24 * 60) % 60;

	$("alertDurationDay").value = parseInt(alertDurationTime / (24 * 60));
	$("alertDurationHour").value = parseInt((alertDurationTime - parseInt(alertDurationTime
			/ (24 * 60)) * 24 * 60) / 60);
	$("alertDurationMin").value = (alertDurationTime - parseInt(alertDurationTime
			/ (24 * 60)) * 24 * 60) % 60;

	$("intervalDay").value = parseInt(aInterval / (24 * 60));
	$("intervalHour").value = parseInt((aInterval - parseInt(aInterval
			/ (24 * 60)) * 24 * 60) / 60);
	$("intervalMin").value = (aInterval - parseInt(aInterval / (24 * 60)) * 24 * 60) % 60;

}

function checkDelayTime() {
	if (($("durationDay").value.length > 1 && $("durationDay").value.charAt(0) == 0)
			|| /[^\d+]/g.test($("durationDay").value)) {
		$("durationDay").value = "";
		$("durationDay").focus();
		return false;
	} else if (($("durationHour").value.length > 1 && $("durationHour").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("durationHour").value)) {
		$("durationHour").value = "";
		$("durationHour").focus();
		return false;
	} else if (($("durationMin").value.length > 1 && $("durationMin").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("durationMin").value)) {
		$("durationMin").value = "";
		$("durationMin").focus();
		return false;
	} else {
		return true;
	}
}
function checkAlertTime() {
	if (($("alertDurationDay").value.length > 1 && $("alertDurationDay").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("alertDurationDay").value)) {
		$("alertDurationDay").value = "";
		$("alertDurationDay").focus();
		return false;
	} else if (($("alertDurationHour").value.length > 1 && $("alertDurationHour").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("alertDurationHour").value)) {
		$("alertDurationHour").value = "";
		$("alertDurationHour").focus();
		return false;
	} else if (($("alertDurationMin").value.length > 1 && $("alertDurationMin").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("alertDurationMin").value)) {
		$("alertDurationMin").value = "";
		$("alertDurationMin").focus();
		return false;
	} else {
		return true;
	}
}
function checkIntervalTime() {
	if (($("intervalDay").value.length > 1 && $("intervalDay").value.charAt(0) == 0)
			|| /[^\d+]/g.test($("intervalDay").value)) {
		$("intervalDay").value = "";
		$("intervalDay").focus();
		return false;
	} else if (($("intervalHour").value.length > 1 && $("intervalHour").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("intervalHour").value)) {
		$("intervalHour").value = "";
		$("intervalHour").focus();
		return false;
	} else if (($("intervalMin").value.length > 1 && $("intervalMin").value
			.charAt(0) == 0)
			|| /[^\d+]/g.test($("intervalMin").value)) {
		$("intervalMin").value = "";
		$("intervalMin").focus();
		return false;
	} else {
		return true;
	}
}
// Check radio's choice value
function radioValue(name) {
	var names = document.getElementsByName(name);
	for ( var i = 0; i < names.length; i++) {
		if (names[i].checked == true) {
			return names[i].value;
		}
	}
}
// Compute delay time
function sumDelayTime() {
	if ($("durationDay").value == "") {
		$("durationDay").value = 0;
	}
	if ($("durationHour").value == "") {
		$("durationHour").value = 0;
	}
	if ($("durationMin").value == "") {
		$("durationMin").value = 0;
	}
	var delayTime = parseInt($("durationDay").value) * 24 * 60
			+ parseInt($("durationHour").value) * 60
			+ parseInt($("durationMin").value);
	return delayTime;
}
// Compute alarm time
function sumAlertTime() {
	if ($("alertDurationDay").value == "") {
		$("alertDurationDay").value = 0;
	}
	if ($("alertDurationHour").value == "") {
		$("alertDurationHour").value = 0;
	}
	if ($("alertDurationMin").value == "") {
		$("alertDurationMin").value = 0;
	}
	var alertTime = parseInt($("alertDurationDay").value) * 24 * 60
			+ parseInt($("alertDurationHour").value) * 60
			+ parseInt($("alertDurationMin").value);
	return alertTime;
}
// Compute interval time
function sumIntervalTime() {
	if ($("intervalDay").value == "") {
		$("intervalDay").value = 0;
	}
	if ($("intervalHour").value == "") {
		$("intervalHour").value = 0;
	}
	if ($("intervalMin").value == "") {
		$("intervalMin").value = 0;
	}
	var intervalTime = parseInt($("intervalDay").value) * 24 * 60
			+ parseInt($("intervalHour").value * 60)
			+ parseInt($("intervalMin").value);
	return intervalTime;
}

function getSelectValue(id) {
	var obj = document.getElementById(id);
	for ( var i = 0; i < obj.length; i++) {
		if (obj[i].selected == true) {
			return obj[i].innerHTML;
		}
	}
}
// Display delay time's frame
function displayDelayTime() {
	document.getElementById('delayTime').style.display = "block";
	document.getElementById('delayVarSet').style.display = "none";
}
// Display delay variable
function displayDelayInput() {
	if (document.getElementById('delayVarSet').style.display != "none") {
		return;
	} else {
		document.getElementById('delayTime').style.display = "none";
		document.getElementById('delayVarSet').style.display = "block";
	}
}
function $(id) {
	return document.getElementById(id);
};
// Display delay application program's frame
function displayDelayApp() {
	if ($('delayApp').checked == true) {
		$('application1_browse').disabled=false;
		$('application1_clear').disabled=false;
	} else {
		$('application1_browse').disabled="disabled";
		$('application1_clear').disabled="disabled";
	}
}
// Display alarm application program's frame
function displayAlertApp() {
	if ($('alertApp').checked == true) {
		$('application2_browse').disabled=false;
		$('application2_clear').disabled=false;
	} else {
		$('application2_browse').disabled="disabled";
		$('application2_clear').disabled="disabled";
	}
}
// Open application dialog
function openApp(event) {
	var obj = event.srcElement ? event.srcElement : event.target;
	var applicationPageName = obj.name;
	var left = (window.screen.availWidth - 635) / 2 + 320;
	var top = (window.screen.availHeight - 420) / 2;
	openUrl = webpath + "/WfProcessAction.do?method=selectApp"
			+ "&processId=" + processId + "&processVersion=" + processVersion + "&eventId=undefined&applicationPageName="+applicationPageName;

	newWin = window
			.open(
					openUrl,
					'applicationPages',
					'height=460, width=600,  top='
							+ top
							+ ', left='
							+ left
							+ ',toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}
// clear up application
function clearUp1() {
	document.getElementById("delayApplication").value = "";
	document.getElementById("actionApplication").value = "";
}
function clearUp2() {
	document.getElementById("alertApplication").value = "";
	document.getElementById("alertActionApplication").value = "";
}