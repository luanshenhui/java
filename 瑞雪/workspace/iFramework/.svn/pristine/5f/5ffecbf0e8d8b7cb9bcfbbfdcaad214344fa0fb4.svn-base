<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"
	errorPage="/ErrorNormal.jsp" isELIgnored="false"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	String webpath = request.getContextPath();
	Map<String, String> actInstMap = (Map<String, String>)request.getAttribute("actInstance");
	if (actInstMap == null) {
		actInstMap = new HashMap<String, String>();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>活动实例详细</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/monitor/details/ProcInstDetails.js"></script>

</head>
<body class="popUp-body">
	<br/>
	<div class="w800 main_label_outline">
		<font style="color: #C6CEE1;font-size: 18px;font-weight:bolder;height:30px;line-height:30px;">活动实例</font>
		<table style="width: 800px" class="" cellpadding="0"
			cellspacing="0" height="220px">
			<tr>
				<td class="popUp-name">实例ID:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtActInstId" name="txtActInstId" value="<%=actInstMap.get("txtActInstId") %>" /> </td>
				<td class="popUp-name">实例名称:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtName" name="txtName" value="<%=actInstMap.get("txtName") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">实例办理方式:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtDeal" name="txtDeal" value="<%=actInstMap.get("txtDeal") %>" /></td>
				<td class="popUp-name">实例创建时间:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtCreateTime" name="txtCreateTime" value="<%=actInstMap.get("txtCreateTime") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">实例当前状态:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtCurrentStatus" name="txtCurrentStatus" value="<%=actInstMap.get("txtCurrentStatus") %>" /></td>
				<td class="popUp-name">实例完成时间:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtCompleteTime" name="txtCompleteTime" value="<%=actInstMap.get("txtCompleteTime") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">实例是否超时:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtIsOvertime" name="txtIsOvertime" value="<%=actInstMap.get("txtIsOvertime") %>" /></td>
				<td class="popUp-name">实例是否催办:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtIsRemind" name="txtIsRemind" value="<%=actInstMap.get("txtIsRemind") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">活动前置条件:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtPreCondition" name="txtPreCondition" value="<%=actInstMap.get("txtPreCondition") %>" /></td>
				<td class="popUp-name">活动后置条件:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtPostCondition" name="txtPostCondition" value="<%=actInstMap.get("txtPostCondition") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">活动类型:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtActivityType" name="txtActivityType" value="<%=actInstMap.get("txtActivityType") %>" /></td>
				<td class="popUp-name">活动扩展属性:</td>
				<td><input class="w260 popUp-edit" disabled="disabled" type="text" id="txtExtend" name="txtExtend" value="<%=actInstMap.get("txtExtend") %>" /></td>
			</tr>
		</table>
		<ec:table
			items="workitemList" var="record" style="table-layout:fixed"
			minHeight="130" height="130" toolbarContent="extend|status"
			action="${pageContext.request.contextPath}/WorkitemManagementAction.do?method=getMyWorkitem"
			listWidth="100%">
			<ec:row>
				<ec:column style="text-align:center;" width="20%" property="participantName" title="参与者" />
				<ec:column style="text-align:center;" width="10%" property="participantType" title="参与者类型" />
				<ec:column style="text-align:center;" width="10%" property="currentStatusName" title="状态"/>
				<ec:column style="text-align:center;" width="10%" property="sendTypeName" title="办理类型" />
				<ec:column style="text-align:center;" width="5%" property="alreadyOverduedName" title="超时"/>
				<ec:column style="text-align:center;" width="15%" property="createTime" cell="date" sortable="true" title="创建时间" format="yyyy-MM-dd HH:mm:ss" />
				<ec:column style="text-align:center;" width="15%" property="acceptTime" cell="date" sortable="true" title="接受时间" format="yyyy-MM-dd HH:mm:ss" />
				<ec:column style="text-align:center;" width="15%" property="completeTime" cell="date" sortable="true" title="完成时间" format="yyyy-MM-dd HH:mm:ss" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="activityId" title="活动Id" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="processId" title="流程Id" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="processVer" title="流程版本" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="procInstanceId" title="流程实例Id" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="activityInsId" title="活动实例Id" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="workitemInsId" title="主键" />
			</ec:row>
		</ec:table>
		<textarea id="value_edit_template" rows="" cols=""
			style="display: none">
				<input type="text" style="width: 100%" name="temp_rdataValue"
				id="temp_rdataValue" validator="required,length,character"
				parameter="{required:true,length:[36],character:true}"
				onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)" />
		</textarea>
	</div>

	<table class="w800 popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">
				<input type="button" value="取消"
					class="popUp-button" onclick="window.close()" />
<!-- 				<input type="button" id="sub" value="提交" class="popUp-button" -->
<!-- 					onclick="saveWfProcess()" /> -->
			</td>
		</tr>
	</table>
</body>
</html>