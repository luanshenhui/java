<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp" isELIgnored="false" %>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%@ page import="com.dhc.workflow.model.define.ManualActivity"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String processId = request.getParameter("processId");
	String processVersion = request.getParameter("processVersion");
	ManualActivity manualAct = new ManualActivity();
	if(request.getAttribute("manualAct") != null){
		manualAct=(ManualActivity)request.getAttribute("manualAct");
	}
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>手动活动</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfactivity/WfManualNode.js"></script>
<script>
	var webpath = "<%=webpath%>";
	var processId = "${param.processId}";
	var processVersion = "${param.processVersion}";
</script>
<c:set var="sessionKey" value="${param.processId},${param.processVersion}"/>
<c:forEach items="${requestScope.mainParList}" var="creatorList">   
     <c:set var="primaryPersons" value="${primaryPersons};${creatorList.participantName}"/>    
     <c:set var="punits" value="${punits};${creatorList.participantName},${creatorList.participantId},${creatorList.participantType}"></c:set>
</c:forEach> 
<c:forEach items="${requestScope.copyParList}" var="monitorList">   
     <c:set var="minorPersons" value="${minorPersons};${monitorList.participantName}"/>    
     <c:set var="munits" value="${munits};${monitorList.participantName},${monitorList.participantId},${monitorList.participantType}"></c:set>
</c:forEach> 
</head>
<body class="popUp-body">
	<br>
	<form action="" name="manualNodeForm">
		<div class="w530 main_label_outline">
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr style="display:none;">
					<td class="popUp-name">ID:</td>
					<td><input class="w410 popUp-edit" type="text" id="actId" name="actId" readonly="true" styleClass="input_underline" value="<%=manualAct.getActId()==null ? "" :manualAct.getActId() %>" /></td>
				</tr>
				<tr>
					<td class="popUp-name">
						<font color="#ff0000">*</font>
						名称:
					</td>
					<td>
					<input class="w370 popUp-edit" type="text" id="actName" name="actName" styleClass="input_underline" value="<%=manualAct.getActName()==null ? "" :manualAct.getActName() %>" />
					
						</td>
					<td valign="bottom">
						<a class="popUp-select" href="#" onclick="WFCommon.CopyContent2Clipboard('actId')">复制ID</a>
					</td>
				</tr>
				<tr>
					<td valign="top" class="popUp-name">描述:</td>
					<td><textarea class="w410 popUp-describe" rows="5" id="actDesc" name="actDesc" styleClass="input_text"><%=manualAct.getActDesc()==null ?"":manualAct.getActDesc() %></textarea>
					</td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">办理方式:</td>
					<td>
					<input class="mt6 fl mr6" type="radio" id="assignRule" name="assignRule"  value="0" <%=manualAct.getAssignRule()!=null && manualAct.getAssignRule()==0 ? "checked" :"" %>/> 
					<span class="popUp-SName fl">单人</span>
					</td>
					<td>
					<input class="mt6 fl mr6" type="radio" id="assignRule" name="assignRule"  value="1" <%=manualAct.getAssignRule()!=null && manualAct.getAssignRule()==1 ? "checked" :"" %>/> 
					<span class="popUp-SName fl">所有人</span>
					</td>
					<td><input class="mt6 fl mr6" type="radio" id="assignRule" name="assignRule"  value="2" <%=manualAct.getAssignRule()!=null && manualAct.getAssignRule()==2 ? "checked" :"" %>/> 
					<span class="popUp-SName fl">条件</span>
					</td>
					<td><input class="mt6 fl mr6" type="radio" id="assignRule" name="assignRule"  value="3" <%=manualAct.getAssignRule()!=null && manualAct.getAssignRule()==3 ? "checked" :"" %>/> 
					<span class="popUp-SName fl">角色</span>
					</td>
				</tr>
			</table>
			
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">
						<font color="#ff0000">*</font>
						办理人:
					</td>
					<td><input class="w370 popUp-edit" type="text" id="primaryPerson" name="primaryPerson"
						readonly="true" value="${fn:substring(primaryPersons,'1',fn:length(primaryPersons))}" />
						</td>
					<td valign="bottom">
						<a class="popUp-select" href="#" onclick="displayPerson(1)">选择</a>
					</td>
				</tr>
				<tr>
					<td class="popUp-name" align="left">抄阅人:</td>
					<td><input class="w370 popUp-edit" type="text" id="minorPerson" name="minorPerson"
						readonly="true" value="${fn:substring(minorPersons,'1',fn:length(minorPersons))}" /></td>
					<td valign="bottom">
					<a class="popUp-select" href="#" onclick="displayPerson(0)">选择</a>
					</td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">自动接受:</td>
					<td><input class="mt6 fl mr6" type="radio" id="autoAccept" name="autoAccept"  value="1" <%=manualAct.getAutoAccept()!=null && manualAct.getAutoAccept()==1 ? "checked" :"" %>/> 
					<span class="popUp-SName fl">是</span></td>
					<td><input class="mt6 fl mr6" type="radio" id="autoAccept" name="autoAccept"  value="0" <%=manualAct.getAutoAccept()!=null && manualAct.getAutoAccept()==0 ? "checked" :"" %>/> 
					<span class="popUp-SName fl">否</span>
					</td>
					
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">办理时限:</td>
					<td><a class="popUp-aLink" href="#" onclick="displaySurvival()">详细设置</a>
					</td>
				</tr>
				<tr>
					<td class="popUp-name">事件:</td>
					<td><a class="popUp-aLink" href="#" onclick="displayEvents()">详细设置</a></td>
				</tr>
			</table> 
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					   <input type="hidden"  id="operationLevel"  name="operationLevel" value="1" >
				</tr>
			</table>
			
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				
				<tr>
					<td class="popUp-name">前置条件:</td>
					<td><input class="w370 popUp-edit" type="text" readonly="true"
						id="preCondition" name="preCondition" value='<%=manualAct.getPreCondition()==null ?"" :manualAct.getPreCondition()%>' /></td>
					<td><a class="popUp-select" href="#"
						onclick="displayConditions('preCondition')">设置</a></td>
				</tr>
				<tr>
					<td class="popUp-name">后置条件:</td>
					<td><input class="w370 popUp-edit" type="text" readonly="true"
						id="postCondition" name="postCondition" value='<%=manualAct.getPostCondition()==null ?"" :manualAct.getPostCondition()%>'/></td>
					<td><a class="popUp-select" href="#"
						onclick="displayConditions('postCondition')">设置</a></td>
				</tr>
				</tr>
				<tr>
					<td class="popUp-name">应用程序:</td>
					<td><input class="w320 popUp-edit fl" type="text" id="applicationName"  name="applicationName" value="${app.appName}" readonly="true" styleClass="input_text" /> 
						<input type="hidden" id="application" value="${app.appId }" />
						<input class="popUp-select button_small mr10" type="button"  id="openManualNodeApplication" name="openManualNodeApplication" onclick="openApp(event)" value='浏览' /> 
						<input class="popUp-select button_small" type="button"  id="clearManualNodeApplication" name="clearManualNodeApplication" onclick="clearUp()" value='清除' /></td>
				</tr>
				<tr>
					<td class="popUp-name">
						扩展属性:
					</td>
					<td>
						<input class="w370 popUp-edit fl" type="text" readonly="true" id="extendProp" name="extendProp" 
							value='<%=manualAct.getExtendProp()==null ?"" :manualAct.getExtendProp() %>' />
						<a class="popUp-select" href="#" onclick="editExtendProp()">设置</a>
					</td>
				</tr>
			</table>

		</div>
		<table class="w550 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td> 
					<input class="popUp-button" type="button" value='取消' onclick="window.close()" />
					<input class="popUp-button" type="button" id="sub"  value='提交'  onclick="submit_onclick()" /> 	
				</td>
			</tr>
		</table>
		<input type="hidden" id="editable" value=''>
		<input type="hidden" id="operatable" value=''>
		<input type="hidden" id="tempId" value=''>
		<input type="hidden" id="unit" value=''>
		<input type="hidden" id="cType" value=''>
		<input type="hidden" id="path" value='<%=webpath%>'>
		<!-- 主送人回显 -->
		<input type="hidden" id="munit" value="${fn:substring(munits,'1',fn:length(munits))}" />
		<!-- 抄送人回显 -->
		<input type="hidden" id="punit" value="${fn:substring(punits,'1',fn:length(punits))}" />
		<input type="hidden" id="isNewVersion" value='' />
		

		<input type="hidden" id="msgReceiver" value='' />
		<input type="hidden" id="events" value='' />
		<input type="hidden" id="duration" value='' />
		<!-- 办理时限的超时时限设置 -->
		<input type="hidden" id="overdueTimelimit" value='<%=manualAct.getOverdueTimelimit()==null ?"" :manualAct.getOverdueTimelimit()%>'  />
		<!-- 办理时限催办时限设置 -->
		 <input type="hidden" id="remindTimelimit" value='<%=manualAct.getRemindTimelimit()==null ?"" :manualAct.getRemindTimelimit()%>'  />
		<!-- 办理时限超时设置判断变量与简单 -->
		<input type="hidden" id="overdueRdata" value='' />
		<!-- 催办超时限制判断变量与简单 -->
		<input type="hidden" id="remindRdata" value='' />
		<!-- 办理时限的超时动作处理方式 -->
		<input type="hidden" id="overdueAction" value='<%=manualAct.getOverdueAction()==null ?"" :manualAct.getOverdueAction()%>'  />
		<!-- 催办的处理方式 -->
		<input type="hidden" id="remindAction" value='<%=manualAct.getRemindAction()==null ?"" :manualAct.getRemindAction()%>'  />
		<!-- 催办的间隔时间 -->
		<input type="hidden" id="remindInterval" value='<%=manualAct.getRemindInterval()==null ?"" :manualAct.getRemindInterval()%>'  />
		<!-- 催办的次数 -->
	    <input type="hidden" id="remindCount" value='<%=manualAct.getRemindTimes()==null ?"" :manualAct.getRemindTimes()%>' />
		<!--办理时限超时的应用程序  -->
		<input type="hidden" id="overdueApp" value='<%=manualAct.getOverdueApp()==null ?"" :manualAct.getOverdueApp()%>'  />
		<!--办理时限催办的应用程序  -->
	    <input type="hidden" id="remindApp" value='<%=manualAct.getRemindApp()==null ?"" :manualAct.getRemindApp()%>'  />
		<!--办理时限变量-->
		<input type="hidden" id="variable" value='' />
		<!--预警变量  -->
		<input type="hidden" id="alertVariable" value='' />
		<!--主送预定义  -->
		<input type="hidden" id="primaryPreDefine" value='' />
		<!-- 抄送预定义 -->
		<input type="hidden" id="minorPreDefine" value='' />
		<!--主送参与人  -->
		<input type="hidden" id="primaryPeople" value='' />
		<!-- 抄送参与人 -->
		<input type="hidden" id="minorPeople" value='' />
		<input type="hidden" id="exActionName" value='' />
		<input type="hidden" id="exAlertActionName" value='' />
		<input type="hidden" id="nodeArraryString" value='' />
		<input type="hidden" id="variablesString" value='' />
		<input type="hidden" id="minorNodeArraryString" value='' />
		<input type="hidden" id="minorVariablesString" value='' />
		<!-- 参与人名称 -->
		<input type="hidden" id="participantsName" value='' />
		<input type="hidden" id="action" />
		<input type="hidden" id="id" value='' />
		<input type="hidden" id="xmlStr" value='' />
		<input type="hidden" id="customProperties" value='' />
		<!--处理方式  -->
	</form>
	<input type="hidden" id="manualNode" value='' />
	<input type="hidden" hiddenvariablesManualNode" value='' />
	<input type="hidden" id="nodeVariables" value='' />
	<input type="hidden" id="transitionVariables" value='' />
	<!-- 流程Id -->
	<input type="hidden" id="procId" value='<%=processId %>' />
	<!-- 流程版本号 -->
	<input type="hidden" id="procVersion" value='<%=processVersion %>' />
</body>
</html>
