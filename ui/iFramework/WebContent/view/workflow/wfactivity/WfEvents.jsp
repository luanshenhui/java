<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>

<%
	String webpath = request.getContextPath();
	String opFlag = request.getParameter("opFlag");
	String procId = request.getParameter("procId");
%>
<html>
<title>活动事件</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/uuid.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfactivity/WfEvents.js"></script>
<script>
	var webpath = "<%=webpath%>";
	var opFlag = "<%=opFlag%>";
	var procId = "<%=procId%>";
	var obj = jQuery.parseJSON('${requestScope.eventsJsonStr}');
</script>
<body class="popUp-body">
	<br>
	<div class="w570 main_label_outline">
		<fieldset class="popUp-fieldset">
			<legend> 节点事件 </legend>
			<table class="popUp-eventTable" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					<input type="hidden" id="actSuspendEventType" value="203"> 
					<input type="hidden" id="actSuspendEventAction" value=""> 
					<input type="checkbox" id="actSuspendEvent" name="events"
						onclick="ock_check('actSuspendEvent')" value=""> 
					<span class="popUp-SName">挂起</span>
					</td>
					<td>
						<input id="actSuspendEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="actSuspendEventButton" type="button"
							 class="popUp-select button_small" name="actSuspendEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actSuspendEvent')" 
							disabled="disabled" value="选择">
					</td>
					<td>
						<input type="hidden" id="actRollbackEventType" value="211"> 
						<input type="hidden" id="actRollbackEventAction" value=""> 
						<input type="checkbox" id="actRollbackEvent" name="events"
							onclick="ock_check('actRollbackEvent')" value=""> 
						<span class="popUp-SName">回退</span>
					</td>
					<td>
						<input id="actRollbackEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="actRollbackEventButton" type="button"
							 class="popUp-select button_small" name="actRollbackEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actRollbackEvent')" 
							disabled="disabled" value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="actAbortEventType" value="207"> 
						<input type="hidden" id="actAbortEventAction" value=""> 
						<input type="checkbox" id="actAbortEvent" name="events"
							onclick="ock_check('actAbortEvent')" value=""> 
						<span class="popUp-SName">终止</span>
					</td>
					<td>
						<input id="actAbortEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="actAbortEventButton" type="button"
							 class="popUp-select button_small" name="actAbortEvent" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actAbortEvent')"
							disabled="disabled" value="选择">
					</td>
					<td>
						<input type="hidden" id="actCompletedEventType" value="209"> 
						<input type="hidden" id="actCompletedEventAction" value=""> 
						<input type="checkbox" id="actCompletedEvent" name="events"
							onclick="ock_check('actCompletedEvent')" value=""> 
						<span class="popUp-SName">完成</span>
					</td>
					<td>
						<input id="actCompletedEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="actCompletedEventButton" type="button"
							 class="popUp-select button_small" name="actCompletedEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actCompletedEvent')" 
							disabled="disabled" value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="actStartEventType" value="201"> 
						<input type="hidden" id="actStartEventAction" value=""> 
						<input type="checkbox" id="actStartEvent" name="events"
							onclick="ock_check('actStartEvent')" value=""> 
						<span class="popUp-SName">启动</span>
					</td>
					<td>
						<input id="actStartEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="actStartEventButton" type="button"
							 class="popUp-select button_small" name="actStartEvent" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actStartEvent')"
							disabled="disabled" value="选择">
					</td>
					<td>
						<input type="hidden" id="actResumeEventType" value="204"> 
						<input type="hidden" id="actResumeEventAction" value=""> 
						<input type="checkbox" id="actResumeEvent" name="events"
							onclick="ock_check('actResumeEvent')" value=""> 
						<span class="popUp-SName">恢复</span>
				    </td>
					<td>
						<input id="actResumeEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="actResumeEventButton" type="button"
							 class="popUp-select button_small" name="actResumeEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actResumeEvent')" 
							disabled="disabled" value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="actCreateEventType" value="200"> 
						<input type="hidden" id="actCreateEventAction" value=""> 
						<input type="checkbox" id="actCreateEvent" name="events"
							onclick="ock_check('actCreateEvent')" value=""> 
						<span class="popUp-SName">创建</span>
					</td>
					<td>
						<input id="actCreateEventText" type="text"
							 class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">

						<input id="actCreateEventButton" type="button"
							 class="popUp-select button_small" name="actCreateEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','actCreateEvent')" 
							disabled="disabled" value="选择">
					</td>
					<td>
						<input type="hidden" id="forceTerminateEventType" value="208"> 
						<input type="hidden" id="forceTerminateEventAction" value=""> 
						<input type="checkbox" id="forceTerminateEvent" name="events"
							onclick="ock_check('forceTerminateEvent')" value=""> 
						<span class="popUp-SName">强制终止</span>
					</td>
					<td>
						<input id="forceTerminateEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="forceTerminateEventButton" type="button"
							class="popUp-select button_small" name="forceTerminateEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','forceTerminateEvent')" 
							disabled="disabled"  value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="withdrawEventType" value="210"> 
						<input type="hidden" id="withdrawEventAction" value=""> 
						<input type="checkbox" id="withdrawEvent" name="events"
							onclick="ock_check('withdrawEvent')" value=""> 
						<span class="popUp-SName">取回</span>
					</td>
					<td>
						<input id="withdrawEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="withdrawEventButton" type="button"
							class="popUp-select button_small" name="withdrawEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','withdrawEvent')" 
							disabled="disabled" value="选择">
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</table>
		</fieldset>
		<fieldset class="popUp-fieldset">
			<legend> 工作项事件 </legend>
			<table class="popUp-eventTable" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<input type="hidden" id="openEventType" value="301"> 
						<input type="hidden" id="openEventAction" value=""> 
						<input type="checkbox" id="openEvent" name="events" 
							onclick="ock_check('openEvent')" value=""> 
						<span class="popUp-SName">接收</span>
					</td>
					<td>
						<input id="openEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">

						<input id="openEventButton" type="button"
							class="popUp-select button_small" name="openEvent" 
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','openEvent')"
							disabled="disabled" value="选择">
					</td>
					<td>
						<input type="hidden" id="regretEventType" value="304"> 
						<input type="hidden" id="regretEventAction" value=""> 
						<input type="checkbox" id="regretEvent" name="events" 
							onclick="ock_check('regretEvent')" value=""> 
						<span class="popUp-SName">拒收</span>
					</td>
					<td>
						<input id="regretEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="regretEventButton" type="button"
							name="regretEvent" class="popUp-select button_small" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','regretEvent')"
							disabled="disabled" value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="suspendEventType" value="302"> 
						<input type="hidden" id="suspendEventAction" value=""> 
						<input type="checkbox" id="suspendEvent" name="events"
							onclick="ock_check('suspendEvent')" value=""> 
						<span class="popUp-SName">挂起</span>
					</td>
					<td>
						<input id="suspendEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="suspendEventButton" type="button"
							name="suspendEvent" class="popUp-select button_small" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','suspendEvent')"
							disabled="disabled" value="选择">
					<td>
						<input type="hidden" id="completedEventType" value="306"> 
						<input type="hidden" id="completedEventAction" value=""> 
						<input type="checkbox" id="completedEvent" name="events"
							onclick="ock_check('completedEvent')" value=""> 
						<span class="popUp-SName">完成</span>
					</td>
					<td>
						<input id="completedEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">
						<input id="completedEventButton" type="button"
							class="popUp-select button_small" name="completedEvent"
							onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','completedEvent')" 
							disabled="disabled" value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="abortEventType" value="305"> 
						<input type="hidden" id="abortEventAction" value=""> 
						<input type="checkbox" id="abortEvent" name="events" 
							onclick="ock_check('abortEvent')" value=""> 
						<span class="popUp-SName">终止</span>
					</td>
					<td>
						<input id="abortEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">

						<input id="abortEventButton" type="button"
							name="abortEvent"  class="popUp-select button_small" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','abortEvent')"
							disabled="disabled" value="选择">
					</td>
					<td>
						<input type="hidden" id="resumeEventType" value="303"> 
						<input type="hidden" id="resumeEventAction" value=""> 
						<input type="checkbox" id="resumeEvent" name="events" 
							onclick="ock_check('resumeEvent')" value=""> 
						<span class="popUp-SName">恢复</span>
					</td>
					<td>
						<input id="resumeEventText" type="text"
							class="w150 popUp-edit fl" readonly="readonly"
							disabled="disabled" value="">

						<input id="resumeEventButton" type="button"
							name="resumeEvent"  class="popUp-select button_small" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','resumeEvent')"
							disabled="disabled" value="选择">
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="createEventType" value="300"> 
						<input type="hidden" id="createEventAction" value=""> 
						<input type="checkbox" id="createEvent" name="events" onclick="ock_check('createEvent')" value=""> 
						<span class="popUp-SName">创建</span>
					</td>
					<td>
						<input id="createEventText" type="text"
						 class="w150 popUp-edit fl" readonly="readonly"
						disabled="disabled" value="">
						<input id="createEventButton" type="button"
							name="createEvent" class="popUp-select button_small" onclick="openApp('${requestScope.processId}','${requestScope.processVersion}','createEvent')"
							disabled="disabled" value="选择">
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</table>
		</fieldset>
	</div>
	<table class="w590 popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">
				<input class="popUp-button" type="button" value="取消" 
					onclick="window.close()" />
				<input class="popUp-button" type="button" value="提交"
					 onclick="setParentValue('${requestScope.processId}','${requestScope.processVersion}','${requestScope.actId }')" />				
			</td>
		</tr>
	</table>
</body>
</html>