<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String processId = request.getParameter("processId");
	String  processVersion = request.getParameter("processVersion");
	
	//应用程序类型
	Map appType = new HashMap<String, String>();
	appType.put("0", "java");
	appType.put("1", "WebService");
	appType.put("2", "URL");
	appType.put("3", "EXE");
	request.setAttribute("appType", appType);
	//事件类型
	String eventId = request.getParameter("eventId");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应用程序管理</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/uuid.js" ></script>
<c:set var="sessionKey" value="${param.processId},${param.processVersion}"/>
<c:set var="result" value="${sessionScope[sessionKey].appList}"/>
<script type="text/javascript">
	
 	 $jQuery().ready(function(){
		//$jQuery('body').bind('keydown',shieldCommon);
	 });
 
	var webpath = "<%=webpath%>";
	var processId = "${param.processId}";
	var processVersion = "${param.processVersion}";
	
	function submit_onClick_source(){
		var name='<%=request.getAttribute("applicationPageName")%>';
		var  eventId = "<%=eventId%>";
		var ecsideObj=ECSideUtil.getGridObj("ec");
		var crow=ecsideObj.selectedRow;
		var appName = ECSideUtil.getPropertyValue(crow,"appName","ec");
		var appId = ECSideUtil.getPropertyValue(crow,"appId","ec");
		switch(name){
			case "openAutoNodeApplication":window.opener.document.autoNodeForm.applicationName.value = appName;
										   window.opener.document.autoNodeForm.application.value = appId;break;
			case "openDelayApplication": window.opener.document.getElementById("delayApplication").value = appName;
										 window.opener.document.getElementById("actionApplication").value = appId; break;
			case "openAlertApplication": window.opener.document.getElementById("alertApplication").value = appName;
										 window.opener.document.getElementById("alertActionApplication").value = appId;	break;
			case "openManualNodeApplication": 
				 window.opener.document.getElementById("applicationName").value = appName;
				 window.opener.document.getElementById("application").value = appId;	break;
	        default:
	        	
				window.opener.document.getElementById(eventId+"Action").value=appId;
				window.opener.document.getElementById(eventId+"Text").value=appName;
		}
		window.close();
	}
	function closeWin(){
		window.returnValue=null;
		window.close();
	}
	
	function add_onClick() {
		var appId = new UUID() + "";
		var openUrl = webpath + "/view/workflow/wfapplication/WfApplicationEdit.jsp?processId="+processId+"&processVersion="+processVersion+"&appId="+appId+"&opFlag=0";
		var left = (window.screen.availWidth - 635) / 2 + 20;
		var top = (window.screen.availHeight - 420) / 2;
		if (document.all) {
			parameter = 'height=300, width=620, top=' + top + ', left=' + left
					+ ', toolbar=no, menubar=no, location=no, status=no';
		} else {
			parameter = 'height=300, width=620,  top=' + top + ', left=' + left
					+ ', toolbar=no, menubar=no, location=no, status=no';
		}
		newWin = window
				.open(openUrl, 'applicationDetail', parameter);
	}
	function update_onClick(){
		var ecsideObj=ECSideUtil.getGridObj("ec");
		var crow=ecsideObj.selectedRow;
		var appId = ECSideUtil.getPropertyValue(crow,"appId","ec");
		if(appId=="" || appId==null){
			alert("请选择应用！");
			return false;
		}
		var url = webpath + "/WfApplicationAction.do?method=getAppDetail&appId="+appId+"&processId="+processId+"&processVersion="+processVersion+"&opFlag=1";
		var left = (window.screen.availWidth - 635) / 2 + 20;
		var top = (window.screen.availHeight - 420) / 2;
		if (document.all) {
			parameter = 'height=330, width=580, top=' + top + ', left=' + left
					+ ', toolbar=no, menubar=no, location=no, status=no';
		} else {
			parameter = 'height=330, width=580,  top=' + top + ', left=' + left
					+ ', toolbar=no, menubar=no, location=no, status=no';
		}
		newWin = window.open(url, 'applicationUpdate', parameter);
	}
function remove_onClick(){
	var ecsideObj=ECSideUtil.getGridObj("ec");
	var crow=ecsideObj.selectedRow;
	var appId = ECSideUtil.getPropertyValue(crow,"appId","ec");
	if(appId=="" || appId==null){
		alert("请选择应用！");
		return false;
	}
	var sURL =  webpath + "/WfApplicationAction.do?method=delete";
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : 
			"processId="+processId
		+"&processVersion="+processVersion
		+"&appId="+appId,
		success : function(data) {
		    window.location.reload();
		}
	});
}
</script>
</head>
<body class="popUp-body">
<div class="main_label_outline mt15">
	<table class="main_button">
	<tr>
		<td align="left">
		   <input type="button" value="新增" class="popUp-button"
				onclick="add_onClick()" />
			 <input type="button" value="修改" class="popUp-button"
			onclick="update_onClick()" />
		   <input type="button" value="删除" class="popUp-button"
				onclick="remove_onClick()" />
		</td>
	</tr>
</table>
<div>
	<fieldset class="title1 popUp-fieldset" ><legend>应用程序列表</legend> 
		<ec:table items="appList" var="record" toolbarContent="status" listWidth="100%" minHeight="200" height="100%">
			<ec:row>
				<ec:column width="5%" style="text-align:center;" cell="radiobox" headerCell="radiobox" alias="checkBoxID" value="${record.appId}"  /> 
				<ec:column style="text-align:center;" width="15%" property="appName" title="应用程序名称" />
				<ec:column style="text-align:center;" width="15%" property="appType" title="应用程序类型" mappingItem="appType" />
				<ec:column style="text-align:center;" width="15%" property="appDesc" title="应用程序描述" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="appId" title="主键" />
			</ec:row>
		</ec:table>
		
	</fieldset>
	<table class="popUp-buttonBox" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>

				<input type="button" value="取消" class="popUp-button"
					onclick="window.close()" />

				<input type="button" value="提交" class="popUp-button"
					onclick="submit_onClick_source()" />				
			</td>
		</tr>
	</table>
</div>

</div>
</body>
</html>