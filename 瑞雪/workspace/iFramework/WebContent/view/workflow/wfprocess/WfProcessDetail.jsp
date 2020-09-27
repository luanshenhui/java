<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp" isELIgnored="false" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String opFlag = request.getParameter("opFlag");
	String procId = request.getParameter("processId");
	String procVer = request.getParameter("processVersion");
	String sessionKey = procId + "," + procVer;
	Process process = new Process();
	String buildTime = "";
	String modifiedTime = "";
	try {
		process = (Process)session.getAttribute(sessionKey);
		if (process == null)
			System.out.println("Process isn't exist:" + sessionKey);
		SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (process.getBuildTime() != null)
			buildTime = sFormat.format(process.getBuildTime()).toString();
		if (process.getModifiedTime() != null)
			modifiedTime = sFormat.format(process.getModifiedTime()).toString();
	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程详细信息</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>

<script type="text/javascript" src="<%=webpath%>/view/workflow/wfprocess/WfProcessDetail.js"></script>

<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var opFlag = "<%=opFlag%>";
	var procId = "${param.processId}";
	var procVer = "${param.processVersion}";
</script>
<c:set var="sessionKey" value="${param.processId},${param.processVersion}"/>
<c:forEach items="${sessionScope[sessionKey].creatorList}" var="creatorList">   
      <c:set var="creators" value="${creators};${creatorList.participantName}"/>  
      <c:set var="punits" value="${punits};${creatorList.participantName},${creatorList.participantId},${creatorList.participantType}"></c:set>  
</c:forEach> 
<c:forEach items="${sessionScope[sessionKey].monitorList}" var="monitorList">   
      <c:set var="monitors" value="${monitors};${monitorList.participantName}"/>   
       <c:set var="munits" value="${munits};${monitorList.participantName},${monitorList.participantId},${monitorList.participantType}"></c:set> 
</c:forEach> 
</head>
<body class="popUp-body">
	<br>
	<form action="" id="detailForm" name="detailForm">
		<div class="w550 main_label_outline">
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr style="display:none;">
					<td class="popUp-name">ID:</td>
					<td><input class="w400 popUp-notEdit" type="text" id="txtProcId" name="txtProcId" readonly="readonly" disabled="disabled"  value= "${param.processId}" />
					</td>
					<td></td>
				</tr>
				<tr>
					<td class="popUp-name" align="left"><font color="#ff0000">*</font>名称:</td>
					<td><input class="w359 input_underline popUp-edit" type="text" id="txtProcName" value="${sessionScope[sessionKey].procName}" /></td>
					<td><a class="popUp-select" href="#" id="getProcInstId" onclick="WFCommon.CopyContent2Clipboard('txtProcId')">复制ID </a></td>
				</tr>
				<tr>
					<td valign="top" class="popUp-name">描述:</td>
					<td colspan="2"><textarea class="w400 popUp-describe" name="txtProcDesc" id="txtProcDesc">${sessionScope[sessionKey].procDesc}</textarea></td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name" align="left">可创建者:</td>
					<td><input class="w359 input_underline popUp-edit" type="text" id="validCreator" readonly="readonly" disabled="disabled"  value="${fn:substring(creators,'1',fn:length(creators))}" /></td>
					<td><a class="popUp-select" href="#" id="choice" onclick="displayPerson(1)">选择 </a></td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name" align="left">可监控者:</td>
					<td><input class="w359 input_underline popUp-edit" type="text" id="monitor" readonly="readonly" disabled="disabled" value="${fn:substring(monitors,'1',fn:length(monitors))}" /></td>
					<td><a class="popUp-select" href="#" id="choice" onclick="displayPerson(0)">选择 </a></td>
				</tr>
			</table>


			<table style="width: 490px" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">办理时限:</td>
					<td><a class="popUp-aLink" href="#" onclick="displaySurvival('${param.processId}','${param.processVersion}')">详细设置</a>
					</td>
					<td class="popUp-smailName">事件:</td>
					<td><a class="popUp-aLink" href="#" onclick="displayEvents('${param.processId}','${param.processVersion}')">详细设置</a></td>
					<td class="popUp-smailName">相关数据:</td>
					<td><a class="popUp-aLink" href="#" onclick="displayVariableGrid()">详细设置</a>
					</td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">前置条件:</td>
					<td><input class="w359 popUp-edit" type="text" readonly="readonly" disabled="disabled" id="preCondition" value="${sessionScope[sessionKey].preCondition}" /></td>
					<td><a class="popUp-select" href="#"
						onclick="displayConditions('preCondition')">设置</a></td>
				</tr>
				<tr>
					<td class="popUp-name">后置条件:</td>
					<td><input class="w359 popUp-edit" type="text"  readonly="readonly" disabled="disabled" id="postCondition" value="${sessionScope[sessionKey].postCondition}" /></td>
					<td><a class="popUp-select" href="#" onclick="displayConditions('postCondition')">设置</a></td>
				</tr>
				<tr>
					<td class="popUp-name">扩展属性</td>
					<td><input class="w359 popUp-edit" type="text"  readonly="readonly" disabled="disabled" id="txtExtendProp" name="txtExtendProp" value="${sessionScope[sessionKey].extendProp}" /></td>
					<td><a class="popUp-select" href="#" onclick="editExtendProp('txtExtendProp')">设置</a></td>
				</tr>

			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">创建者:</td>
					<td><input class="w155 popUp-notEdit" type="text" id="txtBuilder" name="txtBuilder" disabled="disabled"  value="${sessionScope[sessionKey].builder.participantName}" /></td>
					<td class="popUp-name">版本:</td>
					<td><input class="w155 popUp-notEdit" type="text" id="txtProcVersion" name="txtProcVersion" disabled="disabled"  value="${param.processVersion}" /></td>
				</tr>
				<tr>
					<td class="popUp-name">创建时间:</td>
					<td><input class="w155 popUp-notEdit" type="text" id="txtBuildTime" name="txtBuildTime" disabled="true" value='<%=buildTime %>' />
					</td>
					<td class="popUp-name">修改时间:</td>
					<td><input class="w155 popUp-notEdit" type="text" id="txtModifiedTime" disabled="true"
						name="txtModifiedTime" value="<%=modifiedTime %>" /></td>
				</tr>
			</table>
			
		</div>
		<table class="w570 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right">
				<input type="button" value="取消" class="popUp-button" onclick="window.close()" />
				<input type="button" id="sub" value="提交" class="popUp-button" onclick="saveWfProcess()" /> 
				</td>
			</tr>
		</table>
		<div style="visibility:hidden">
		应用路径：<input type="text" id="path" value='<%=webpath%>' />
		<!-- 流程事件组合
		事件组合：<input type="text" id="events" value="" /><br/> -->
		<!-- 监控者回显 -->
		<input type="hidden" id="munit" value="${fn:substring(munits,'1',fn:length(munits))}" />
		<!-- 创建者回显 -->
		<input type="hidden" id="punit" value="${fn:substring(punits,'1',fn:length(punits))}" /><br/>
		是否新版本：<input type="text" id="isNewVersion" value="" />
		是否可操作：<input type="text" id="operatable" value="" /><br/>
		<!--类型： 创建者与监控着
		创建者与监控者：<input type="text" id="cType"> -->
		<!-- 条件类型：前置条件与后置条件
		条件类型：<input type="text" id="conditionType"><br/> -->
		<!--创建者类型 
		创建者类型：<input type="text" id="creatorType">-->
		<!-- 监控者类型
		监控者类型：<input type="text" id="monitorType"><br/> -->
		<!-- 扩展属性 -->
		扩展属性：<input type="text" id="extendProperties" value="" />
		<!-- 办理时限的超时时限设置 -->
		超时限制：<input type="text" id="overdueTimelimit" value="${sessionScope[sessionKey].overdueTimelimit}" /><br/>
		<!-- 办理时限催办时限设置 -->
		提醒限制：<input type="text" id="remindTimelimit" value="${sessionScope[sessionKey].remindTimelimit}" />
		<!-- 办理时限超时设置判断变量与简单 -->
		超时变量：<input type="text" id="overdueRdata" value="" /><br/>
		<!-- 催办超时限制判断变量与简单 -->
		提醒变量：<input type="text" id="remindRdata" value="" />
		<!-- 办理时限的超时动作处理方式 -->
		超时动作：<input type="text" id="overdueAction" value="${sessionScope[sessionKey].overdueAction}" /><br/>
		<!-- 催办的处理方式 -->
		提醒动作：<input type="text" id="remindAction" value="${sessionScope[sessionKey].remindAction}" />
		<!-- 催办的间隔时间 -->
		提醒间隔：<input type="text" id="remindInterval" value="${sessionScope[sessionKey].remindInterval}" /><br/>
		<!-- 催办的次数 -->
		提醒次数<input type="text" id="remindCount" value="${sessionScope[sessionKey].remindTimes}" />
		<!--办理时限超时的应用程序  -->
		超时应用：<input type="text" id="overdueApp" value="${sessionScope[sessionKey].overdueApp}" />	<br/>	
		<!--办理时限催办的应用程序  -->
		催办应用<input type="text" id="remindApp" value="${sessionScope[sessionKey].remindApp}" />
		<!--办理时限变量
		超时变量：<input type="text" id="variable" value="" /><br/>-->
		<!--预警变量 
		提醒变量：<input type="text" id="alertVariable" value="" /> -->
		<!--可创建者 -->
		可创建者：<input type="text" id="validCreators" value="" /><br/>
		<!--可监控者 -->
		可监控者：<input type="text" id="monitors" value="" />
		<!-- 起草人修改流程 -->
		是否可以修改流程：<input type="text" id="canModifyFlow" value="" /><br/>
		</div>
	</form>
	
</body>
</html>