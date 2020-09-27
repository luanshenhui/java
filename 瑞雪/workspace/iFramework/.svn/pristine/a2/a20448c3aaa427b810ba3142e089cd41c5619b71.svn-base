//Make the page on the top
var newWin=null;
/*window.onfocus=function (){  
 	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};

window.document.onfocus=function (){  
	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};

window.document.onclick=function (){  
	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};

window.document.ondblclick=function (){  
	if(newWin){
		if(!newWin.closed)
		newWin.focus();
	} 
};*/

function $(id) {
	return document.getElementById(id);
};

function trim(str) {
	return str.replace(/\s/g, "");
}
function getRadioValue(name) {
	var names = document.getElementsByName(name);
	var radioValue = "";
	for (var i = 0; i < names.length; i++) {
		if (names[i].checked == true) {
			radioValue = names[i].value;
			return radioValue;
		}
	}
}
function submit_onclick() {
	if (trim(document.manualNodeForm.actName.value) == "") {
		document.manualNodeForm.actName.focus();
		alert("名称不可以为空");
		document.manualNodeForm.actName.value = "";
		return false;
	}
	if (document.manualNodeForm.primaryPerson.value == "") {
		document.manualNodeForm.primaryPerson.focus();
		alert("办理人不可以为空");
		document.manualNodeForm.primaryPerson.value = "";
		return false;
	}
	
	document.manualNodeForm.participantsName.value = $('primaryPerson').value
			+ $('minorPerson').value;
	var procId = jQuery("#procId").val();
	var procVersion = jQuery("#procVersion").val();
	var actId = jQuery("#actId").val();
  	var actName = jQuery("#actName").val();
  	var actDesc =trim(document.manualNodeForm.actDesc.value);
  	var extendProp = jQuery("#extendProp").val();
  	var overdueTimelimit = jQuery("#overdueTimelimit").val();
  	var overdueRdata = jQuery("#overdueRdata").val();
  	var overdueAction = jQuery("#overdueAction").val();
  	
  	var overdueApp = jQuery("#overdueApp").val();
  	var remindTimelimit = jQuery("#remindTimelimit").val();
  	var remindRdata = jQuery("#remindRdata").val();
  	var remindAction = jQuery("#remindAction").val();
  	var remindApp = jQuery("#remindApp").val();
  	var remindInterval = jQuery("#remindInterval").val();
  	var remindCount = jQuery("#remindCount").val();
  	//办理方式
  	var assignRule = "";
  	if(jQuery("input[name=assignRule]:checked").val()!=undefined){
  		assignRule =jQuery("input[name=assignRule]:checked").val();
  	}
  	//操作级别
  	var operationLevel = jQuery("#operationLevel").val();
  	//自动接受
  	var autoAccept = "";
  	if(jQuery("input[name=autoAccept]:checked").val()!=undefined){
  		autoAccept =jQuery("input[name=autoAccept]:checked").val();
  	}
  	//应用
  	var applicationName = jQuery("#applicationName").val();
  	var application = jQuery("#application").val();
  	//事件
  	var events = jQuery("#events").val();
  	//前置条件
  	var preCondition = jQuery("#preCondition").val();
  	//后置条件
  	var postCondition = jQuery("#postCondition").val();
  	//主送人
  	var punit = jQuery("#punit").val();
  	//抄送人
  	var munit = jQuery("#munit").val();
	//保存对自动活动的修改
	var sURL = webpath + "/WfManualActivity.do?method=update";
	jQuery.ajax( {
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : 
			{ 
		 	procId:procId,
			procVersion:procVersion,
			actId: actId,
			actName: actName,
			actDesc: actDesc,
			extendProp:extendProp,
			overdueTimelimit: overdueTimelimit,
			overdueRdata: overdueRdata,
			overdueAction: overdueAction,
			overdueApp: overdueApp,
			remindTimelimit: remindTimelimit,
			remindRdata: remindRdata,
			remindAction: remindAction,
			remindApp: remindApp,
			remindInterval: remindInterval,
			remindCount:remindCount,
			assignRule:assignRule,
			operationLevel:operationLevel,
			autoAccept:autoAccept,
			preCondition: preCondition,
			postCondition: postCondition,
			events:events,
			applicationName:applicationName,
			application:application,
			punit:punit,
			munit:munit
		},
		success : function() {
			window.opener.updateActivity(actId,actName);
			window.close();
		},
		error : function(){
			alert("网络错误");
		}
	});
	
window.close();
}
// Display the person page
function displayPerson(flag) {
	$('cType').value = flag;
	var processId = jQuery("#procId").val();
	var processVersion = jQuery("#procVersion").val();
	var path = document.manualNodeForm.path.value;
	var actId = jQuery("#actId").val();
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	openUrl = path
			+ "/view/workflow/wfactivityparticipant/WfUnitOrgTree.jsp?flag="+flag+"&processId="+processId
			+"&processVersion="+processVersion
			+"&actId="+actId;
	newWin = window
			.open(
					openUrl,
					'person',
					'height=400, width=710, top='
							+ top
							+ ', left='
							+ left
							+ ',toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}

//Display the conditions
function displayConditions(conditionType) {
	var conditionValue = "";
	if (conditionType == "preCondition") {
		conditionValue = document.forms[0].preCondition.value;
	} else {
		conditionValue = document.forms[0].postCondition.value;
	}
	var openUrl = "";

	openUrl = webpath
			+ "/view/workflow/wfprocess/WfConditions.jsp?conditionValue="
			+ encodeURIComponent(encodeURIComponent(conditionValue)) + "&conditionType=" + conditionType
			+ "&processId="+processId+"&processVersion="+processVersion;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	if (document.all) {
		parameter = 'height=410, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	} else {
		parameter = 'height=410, width=570,  top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	}
	newWin = window
			.open(openUrl, 'condition', parameter);
}
// Call function when init page
function initPage() {
	if (document.all) {
		self.resizeTo(660, 620);
	} else {
		self.resizeTo(660, 620);
	}
//	checkOpertion();
	
	//初始化主送参与人
	setprimaryPerson();
	
	//初始化抄送参与人
	setminorPerson();
	
	//初始化业务信息
	setBizInfo();
}
function setprimaryPerson(){
	var primaryPreDefine="";
    var def= document.getElementsByName("primaryPreDefine")[0].value;
    var def_all = def.split(";");
    for(var i=0;i<def_all.length;i++){
		if(def_all[i]=="2"){
			primaryPreDefine += "实例创建者;";
		}
		if(def_all[i]=="3"){
			primaryPreDefine += "实例创建者上级;";
		}
		if(def_all[i]=="4"){
			primaryPreDefine += "前一节点;";
		}
		if(def_all[i]=="5"){
			primaryPreDefine += "前一节点上级;";
		}
	}
	
	var nodeVariables = "";
	var variablesString = document.getElementsByName("variablesString")[0].value;
	var str=document.getElementById("nodeVariables").value;
	var variables=str.split(";");
	for(i=0;i<variables.length-1;i++){
	if(variablesString.indexOf(variables[i].split(",")[0])!=-1){
			nodeVariables+=variables[i].split(",")[1]+";";	
		}	
	}
	var node = "";
	
	var nodeArraryString = document.getElementsByName("nodeArraryString")[0].value;
	var nodeStr=document.getElementById("manualNode").value;
	
	var nodes = nodeStr.split(";");
    for(i=0;i<nodes.length-1;i++){
        if(nodeArraryString.indexOf(nodes[i].split(",")[0])!=-1){
            node+=nodes[i].split(",")[1]+";";	
        }
    }
    
	var value = document.getElementById("primaryPerson").value;
	if(value != ""){
		value += ";";
	}
	value += primaryPreDefine+nodeVariables+node;
	document.getElementById("primaryPerson").value = value;
}
function setminorPerson(){
	var minorPreDefine="";
    var def= document.getElementsByName("minorPreDefine")[0].value;
    var def_all = def.split(";");
    for(var i=0;i<def_all.length;i++){
		if(def_all[i]=="2"){
			minorPreDefine += "实例创建者;";
		}
		if(def_all[i]=="3"){
			minorPreDefine += "实例创建者上级;";
		}
		if(def_all[i]=="4"){
			minorPreDefine += "前一节点;";
		}
		if(def_all[i]=="5"){
			minorPreDefine += "前一节点上级;";
		}
	}
	
	var nodeVariables = "";
	var variablesString = document.getElementsByName("minorVariablesString")[0].value;
	var str=document.getElementById("nodeVariables").value;
	var variables=str.split(";");
	for(i=0;i<variables.length-1;i++){
	if(variablesString.indexOf(variables[i].split(",")[0])!=-1){
			nodeVariables+=variables[i].split(",")[1]+";";	
		}	
	}
	var node = "";
	var nodeArraryString = document.getElementsByName("minorNodeArraryString")[0].value;
	var nodeStr=document.getElementById("manualNode").value;
	var nodes = nodeStr.split(";");
    for(i=0;i<nodes.length-1;i++){
        if(nodeArraryString.indexOf(nodes[i].split(",")[0])!=-1){
            node+=nodes[i].split(",")[1]+";";	
        }
    }
	var value = document.getElementById("minorPerson").value;
	if(value != ""){
		value += ";";
	}
	value += minorPreDefine+nodeVariables+node;
	document.getElementById("minorPerson").value = value;
}
// Open application dialog
function openApp(event) {
	var obj = event.srcElement ? event.srcElement : event.target;
	var applicationPageName = obj.name;
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 500) / 2;
	openUrl = webpath + "/WfProcessAction.do?method=selectApp"
			+ "&applicationPageName=" + applicationPageName
			+ "&processId="+processId+"&processVersion="+processVersion+"&eventId=undefine";
	if(document.all){			  
	  	parameter='height=450, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }else{
	  	parameter='height=450, width=650, top='+top+', left='+left+', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
	 }
	newWin = window.open(openUrl,"application",parameter);
}
// clear up application
function clearUp() {
	document.manualNodeForm.application.value = "";
	document.manualNodeForm.applicationName.value = "";
}

// Display the events
function displayEvents() {
	var actId = jQuery("#actId").val();
		var openUrl = webpath
			+ "/WfManualActivity.do?method=displayEvents&processId=" + processId
			+ "&processVersion=" + processVersion+"&actId="+actId;
		var left = (window.screen.availWidth - 635) / 2 + 20;
		var top = (window.screen.availHeight - 600) / 2;
		
		if (document.all) {
		parameter = 'height=540, width=610, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		} else {
		parameter = 'height=540, width=610, top='
				+ top
				+ ', left='
				+ left
				+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		}
		newWin = window.open(openUrl, 'events', parameter);
}

// Display the survival
function displaySurvival() {
	var overdueTimelimit = document.manualNodeForm.overdueTimelimit.value;
	var remindTimelimit = document.manualNodeForm.remindTimelimit.value;
	var overdueRdata = document.manualNodeForm.overdueRdata.value;
	var remindRdata = document.manualNodeForm.remindRdata.value;
	var overdueAction = document.manualNodeForm.overdueAction.value;
	var remindAction = document.manualNodeForm.remindAction.value;
	var remindInterval = document.manualNodeForm.remindInterval.value;
	var overdueApp = document.manualNodeForm.overdueApp.value;
	var remindApp = document.manualNodeForm.remindApp.value;
	//催办次数
	var remindCount = document.manualNodeForm.remindCount.value;
	if (processId != "" && processVersion != "") {
		var openUrl = webpath
				+ "/view/workflow/wfprocess/WfProcessExpiration.jsp?processId="
				+ processId + "&processVersion=" + processVersion
				+ "&overdueTimelimit="+overdueTimelimit+"&remindTimelimit="+remindTimelimit
				+ "&overdueRdata="+overdueRdata+"&remindRdata="+remindRdata
				+ "&overdueAction="+overdueAction+"&remindAction="+remindAction
				+ "&remindInterval="+remindInterval+"&overdueApp="+overdueApp
				+ "&remindApp="+remindApp
				+"&remindCount="+remindCount;
		var left = (window.screen.availWidth - 550) / 2 + 20;
		var top = (window.screen.availHeight - 460) / 2;

		if (document.all) {
			parameter = 'height=540, width=540, top='
					+ top
					+ ', left='
					+ left
					+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		} else {
			parameter = 'height=540, width=540, top='
					+ top
					+ ', left='
					+ left
					+ ', toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no';
		}
		newWin = window.open(openUrl, 'expiration', parameter);
	} else {
		alert("找不到流程ID和版本请重新登录系统！");
	}
};

function setBizInfo()
{
	var bizInfoXML=document.manualNodeForm.customProperties.value;
	if(bizInfoXML!=null&&bizInfoXML!="")
	{
		var xmlParser=XmlLoader(bizInfoXML);
		if(xmlParser==null)
	    {
	     alert("your explorer do not have the xml parser required!");
	     return "";
	    }
	    var root=xmlParser.documentElement;
	    var biz=root.getElementsByTagName("bizInfo")[0];
	    if(biz)
	    {
	    	var biz1=biz.getElementsByTagName("BizInfo1")[0];
	    	if(biz1&&biz1.getAttribute("value"))
	    	{
	    		document.getElementById("bizInfo1").value=biz1.getAttribute("value");
	    	}
	    	var biz2=biz.getElementsByTagName("BizInfo2")[0];
	    	if(biz2&&biz2.getAttribute("value"))
	    	{
	    		document.getElementById("bizInfo2").value=biz2.getAttribute("value");
	    	}
	    }
	}
};



function XmlLoader(xmlStr)
{
   var xmlDoc=null;
        if(!window.DOMParser && window.ActiveXObject){//IE
            var xmlDomVersions = ['Microsoft.XMLDOM','MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0'];
            for(var i=0;i<xmlDomVersions.length;i++){
                try{
                    xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                    xmlDoc.async = false;
                    xmlDoc.loadXML(xmlStr);
                    break;
                }catch(e){
                   return null;
                }
            }
        }
        else if(window.DOMParser && document.implementation && document.implementation.createDocument){//FireFox
            try{
                domParser = new  DOMParser();
                xmlDoc = domParser.parseFromString(xmlStr, 'text/xml');
            }catch(e){
               return null;
            }
        }
        else{
            return null;
        }
        return xmlDoc;
};
function editExtendProp(){
	var compId = "extendProp";
	WFCommon.editExtendProperty(compId,compId);
}