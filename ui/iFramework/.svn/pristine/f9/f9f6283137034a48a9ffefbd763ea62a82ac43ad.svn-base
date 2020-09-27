<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"
	errorPage="/ErrorNormal.jsp" isELIgnored="false"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<html>
<%
	// 获得应用上下文
	String webpath = request.getContextPath();
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>流程监控</title>
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
	<script type="text/javascript" src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/util.js" ></script>
	<script type="text/javascript" src="<%=webpath%>/view/workflow/management/monitor/ProcInstMonitor.js"></script>
</head>
<body style="margin: 10px;">
	<form method="post">
		<div>
			<table  cellpadding="0" cellspacing="0">
				<tr>
			   		<td width=80px align="right"><span>流程定义</span></td>
			   		<td ><span style="color:red">&nbsp;*&nbsp;<span></td>
					<td>
						<input type="text" id="procInstName" name="procInstName" readonly="readonly"/>
						<input type="button" value="选择" onclick="doSelectProcess()"/>
						<input type="hidden" id="procDefID" name="procDefID"/>
						<input type="hidden" id="procDefVer" name="procDefVer"/>
					</td>
					<td  width=80px align="right"><span>开始时间</span></td>
			   		<td ><span style="color:red">&nbsp;*&nbsp;<span></td>
					<td colspan=3>
						<input type="text" id="startDateStart" name="startDateStart" readonly="readonly" onclick="WdatePicker()"/>
						～<input type="text" id="startDateEnd" name="startDateEnd" readonly="readonly"  onclick="WdatePicker()"/>
					</td>
				</tr>
				<tr height="36px">
					<td  width=80px align="right"><span>结束时间</span></td>
			   		<td ><span style="color:red">&nbsp;&nbsp;&nbsp;<span></td>
					<td colspan="4">
						<input type="text" id="endDateStart" name="endDateStart" readonly="readonly" onclick="WdatePicker()"/>
						～<input type="text" id="endDateEnd" name="endDateEnd" readonly="readonly"  onclick="WdatePicker()"/>
					</td>
				</tr>
			</table>
		</div>
	</form><br>
	<table cellpadding="0" cellspacing="0" width="804px">
		<tr>
			<td align="right">	
				<input type="button" style="width:60px" value="查   询" onclick="doQuery()"/>&nbsp;
				<input type="button" style="width:60px" value="重   置" onclick="doResert()"/>&nbsp;
				<input type="button" style="width:60px" value="挂   起" onclick="doSuspend()" />&nbsp;
				<input type="button" style="width:60px" value="恢   复 " onclick="doResume()" />&nbsp;
				<input type="button" style="width:60px" value="重启动" onclick="doRestart()" />&nbsp;
				<input type="button" style="width:60px" value="终   止" onclick="doTerminate()" />&nbsp;
				<input type="button" style="width:60px" value="完   成" onclick="doComplete()" />&nbsp;
				<input type="button" style="width:60px" value="监   控" onclick="doMonitor()" />
			</td>
		</tr>
	</table>
	<ec:table
		items="recordList" var="record" style="table-layout:fixed"
		toolbarContent="extend|status" width="804" minHeight="300" height="300" rowsDisplayed="9999"
		action="${pageContext.request.contextPath}/ProcessInstanceMonitorAction.do?method=getProcessInstanceMonitor"
		listWidth="100%">
		<ec:row>  
			<ec:column property="_0" title="序号" value="${GLOBALROWCOUNT}" />
			<ec:column style="text-align:center;" property="procInstName" title="名称" />
			<ec:column style="text-align:center;" property="procInstStatus" title="状态"  mappingItem="statusMap"/>
			<ec:column style="text-align:center;" property="procDefNameVer" title="模板名称(版本)" />
			<ec:column style="text-align:center;" property="bizCategoryName" title="业务分类" mappingItem="bizCatMap"/>
			<ec:column style="text-align:center;" property="completeTime" cell="date" sortable="true" title="完成时间" format="yyyy-MM-dd HH:mm:ss" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="procDefCreatorName" title="流程定义者" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="procInstID" title="主键" />
		</ec:row>
	</ec:table>
</body>
</html>