<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>待办任务管理</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript" 
	src="<%=webpath%>/view/workflow/management/workitem/todo.js"></script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
</script>
</head>
<body>

<form name="queryForm" class="jqueryui">
<div class="title1">
	<table class="table_container" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width:30%">工作项类型：</td>
			<td style="width:30%">
				<select id="workItemType" name="workItemType">
					<option value="0">所有任务</option>
					<option value="1">个人任务</option>
					<option value="2">角色任务</option>
					<option value="3">代理任务</option>
					<option value="4">超时任务</option>
				</select>				
			</td>
			<td>
				&nbsp;<input id="btnQueryWfProcess" type="button" value="查询" onClick="javascript:doQuery('queryForm', 'ec')" />
			</td>
		</tr>
	</table>
</div>
</form>
	<ec:table
		items="recordList" var="record" style="table-layout:fixed"
		minHeight="230" height="230" toolbarContent="navigation|pagejump|pagesize|extend|status"
		action="${pageContext.request.contextPath}/WorkitemManagementAction.do?method=getMyWorkitem" rowsDisplayed="10" pageSizeList="10,20,50,100,all"
		listWidth="100%">
		<ec:row>
			<ec:column style="text-align:center;" width="18%" property="name" title="任务名称" />
			<ec:column style="text-align:center;" width="18%" property="processName" title="流程名" />
			<ec:column style="text-align:center;" width="15%" property="bizCateName" title="业务分类名" />
			<ec:column style="text-align:center;" width="5%" property="assignRule" title="完成方式" />
			<ec:column style="text-align:center;" width="5%" property="currentStatusName" title="状态"/>
			<ec:column style="text-align:center;" width="5%" property="sendTypeName" title="办理类型" />
			<ec:column style="text-align:center;" width="5%" property="alreadyOverduedName" title="是否超时"/>
			<ec:column style="text-align:center;" width="12%" property="createTime" cell="date" sortable="true" title="创建时间" format="yyyy-MM-dd HH:mm:ss" />
			<ec:column style="text-align:center;" width="12%" property="acceptTime" cell="date" sortable="true" title="接受时间" format="yyyy-MM-dd HH:mm:ss" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="activityId" title="活动Id" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="processId" title="流程Id" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="processVer" title="流程版本" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="procInstanceId" title="流程实例Id" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="activityInsId" title="活动实例Id" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="workitemInsId" title="主键" />
		</ec:row>
	</ec:table>
	<table width="100%" class="jt_botton_table" border="0" cellpadding="0" cellspacing="0" >
		<tr>
			<td  align="right">
				<input id="btnModifyRelateData" type="button" value="相关数据" onClick="modifyRelateData()" />
				<input id="btnAddWfProcess" type="button" value="接受" onClick="doAccept()" />
				<input id="btnUpdateWfProcess" type="button" value="拒收" onClick="doRefuse()" />
				<input id="btnDeleteWfProcess" type="button" value="办理" onClick="doDeal()" />
				<input id="btnDeleteWfProcess" type="button" value="完成" onClick="doComplete()" />
				<input id="btnDeleteWfProcess" type="button" value="暂停" onClick="doPause()" />
				<input id="btnDeleteWfProceTs" type="button" value="恢复" onClick="doRestore()" />
				<input id="btnDeleteWfProcess" type="button" value="终止" onClick="doStop()" />
				<input id="btnDeleteWfProcess" type="button" value="加签" onClick="doAddsigner()" />
				<input id="btnDeleteWfProcess" type="button" value="签收" onClick="doSign()" />
				<input id="btnDeleteWfProcess" type="button" value="回退" onClick="dobackByStep()" />
				<!-- input id="btnDeleteWfProcess" type="button" value="自由回退" onClick="doBackByfree()" /-->
				<input id="btnDeleteWfProcess" type="button" value="普送" onClick="doSend()" />
				<input id="btnDeleteWfProcess" type="button" value="特送" onClick="doSendPre()" />
				<input id="btnMonitor" type="button" value="监控" onClick="doMonitor()" />
				<!-- 
				<input id="btnMonitor" type="button" value="测流程实例 " onClick="openProcInstDetails()" />
				<input id="btnMonitor" type="button" value="测活动实例" onClick="openActInstDetails()" />
				-->
			</td>
		</tr>
</table>
</body>
</html>