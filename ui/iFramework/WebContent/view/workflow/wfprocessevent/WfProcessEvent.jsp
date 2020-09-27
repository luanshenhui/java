<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>引擎事件</title>

<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/uuid.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/workflow/wfprocessevent/WfProcessEvent.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	var obj = jQuery.parseJSON('${requestScope.eventsJsonStr}');
// 	alert(obj);
	//displayDiv();
	if (obj!=null && obj != ""){
		initEvents(obj);
	}
});
</script>
</head>
<body class="popUp-body">
		<input type="hidden" id="path" value="" />
		<br>
		<div class="w570 main_label_outline">
			<fieldset class="popUp-fieldset">
				<legend>
					流程事件
				</legend>
				<table class="popUp-eventTable" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<input type="hidden" id="procSuspendEventType" value="103">
							<input type="hidden" id="procSuspendEventAction" value="">
							<input type="checkbox" id="procSuspendEvent" name="events"
								onclick="ock_check('procSuspendEvent')"  value=""></td>
							<td class="popUp-SName">
							挂起
							</td>
						<td>
							<input class="w150 popUp-edit fl" id="procSuspendEventText" type="text"
								  readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procSuspendEventButton" name="procSuspendEvent"
								 onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procSuspendEvent')" type="button"
								disabled="disabled"  value="选择">
						</td>
						
						
						<td>
							<input type="hidden" id="procCompletedEventType" value="109">
							<input type="hidden" id="procCompletedEventAction" value="">
							<input type="checkbox" style="margin:0px" id="procCompletedEvent" name="events"
								onclick="ock_check('procCompletedEvent')"  value=""></td>
							<td class="popUp-SName">
							完成
						</td>
						<td>
							<input class="w150 popUp-edit fl" id="procCompletedEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procCompletedEventButton" type="button"
								name="procCompletedEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procCompletedEvent')" disabled="disabled"
								 value="选择">
						</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" id="procAbortEventType" value="107">
							<input type="hidden" id="procAbortEventAction" value="">
							<input type="checkbox" style="margin:0px" id="procAbortEvent" name="events"
								onclick="ock_check('procAbortEvent')"  value=""></td>
							<td class="popUp-SName">
							终止
						</td>
						<td>
							<input class="w150 popUp-edit fl" id="procAbortEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procAbortEventButton" type="button"
							 name="procAbortEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procAbortEvent')" disabled="disabled"
								 value="选择">
						</td>
						
						
						<td>
							<input type="hidden" id="procStartEventType" value="101">
							<input type="hidden" id="procStartEventAction" value="">
							<input type="checkbox" style="margin:0px" id="procStartEvent" name="events"
								onclick="ock_check('procStartEvent')"  value=""></td>
							<td class="popUp-SName">
							启动
						</td>
						<td>
							<input class="w150 popUp-edit fl" id="procStartEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procStartEventButton" type="button"
								 name="procStartEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procStartEvent')" disabled="disabled"
								 value="选择">
						</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" id="procRestartEventType" value="102">
							<input type="hidden" id="procRestartEventAction" value="">
							<input type="checkbox" style="margin:0px" id="procRestartEvent" name="events"
								onclick="ock_check('procRestartEvent')"  value=""></td>
							<td class="popUp-SName">
							重启动
						</td>
						<td>
							<input class="w150 popUp-edit fl" id="procRestartEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procRestartEventButton" type="button"
								 name="procRestartEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procRestartEvent')" disabled="disabled"
								 value="选择">
						</td>
						
						
						<td>
							<input type="hidden" id="procResumeEventType" value="104">
							<input type="hidden" id="procResumeEventAction" value="">
							<input type="checkbox" style="margin:0px" id="procResumeEvent" name="events"
								onclick="ock_check('procResumeEvent')"  value=""></td>
							<td class="popUp-SName">
							恢复
						</td>
						<td>
							<input class="w150 popUp-edit fl" class="w150 popUp-edit fl" id="procResumeEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procResumeEventButton" type="button"
								 name="procResumeEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procResumeEvent')" disabled="disabled"
								 value="选择">
						</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" id="procCreateEventType" value="100">
							<input type="hidden" id="procCreateEventAction" value="">
							<input type="checkbox" style="margin:0px" id="procCreateEvent" name="events"
								onclick="ock_check('procCreateEvent')"  value=""></td>
							<td class="popUp-SName">
							创建
						</td>
						<td>
							<input class="w150 popUp-edit fl" id="procCreateEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="procCreateEventButton" type="button"
								 name="procCreateEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','procCreateEvent')" disabled="disabled"
								 value="选择">
						</td>

						<td>
							<input type="hidden" id="forceTerminateEventType" value="108">
							<input type="hidden" id="forceTerminateEventAction" value="">
							<input type="checkbox" style="margin:0px" id="forceTerminateEvent" name="events"
								onclick="ock_check('forceTerminateEvent')"  value=""></td>
							<td class="popUp-SName">
							强制终止
						</td>
						<td>
							<input class="w150 popUp-edit fl" id="forceTerminateEventText" type="text"
								 readonly="readonly"
								disabled="disabled" value="">

							<input class="popUp-select button_small" id="forceTerminateEventButton" type="button"
								 name="forceTerminateEvent"
								onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','forceTerminateEvent')" disabled="disabled"
								 value="选择">
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
		<table class="w590 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right">
					<input type="button" value="取消" class="popUp-button"
						onclick="window.close()" />
					<input type="button" value="提交" class="popUp-button"
						onclick="setParentValue('${requestScope.processId}','${requestScope.processVersion}')" />
				</td>
			</tr>
		</table>
	</body>
</html>