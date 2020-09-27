<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String bizCateId = request.getParameter("bizCateId");
	String bizCateName = request.getParameter("bizCateName");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程管理</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfprocess/WfProcessList.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>

<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var bizCateId = "<%=bizCateId%>";
	var bizCateName = "<%=bizCateName%>";
</script>
</head>
<body id="processFrame">

	<form name="queryForm" class="jqueryui">
		<div class="title1">
			<table class="table_container" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td style="width: 10%">流程名称</td>
					<td style="width: 40%"><input type="text" name="txtProcName"
						id="txtProcName"> <input type="hidden" name="txtProcId"
						id="txtProcId"> <input type="hidden"
						name="txtProcCategory" value="<%=bizCateId%>" id="txtProcCategory">
					</td>
					<td style="width: 10%">流程版本</td>
					<td style="width: 40%"><input type="text"
						name="txtProcVersion" id="txtProcVersion">&nbsp;&nbsp; <input
						id="btnQueryWfProcess" type="button" value="查询"
						onClick="javascript:doQuery('queryForm', 'ec')" /></td>
				</tr>
			</table>
		</div>
	</form>
	<ec:table items="processList" var="record" style="table-layout:fixed"
		minHeight="280" height="280" rowsDisplayed="10" pageSizeList="10,20,50,100,all" toolbarContent="navigation|pagejump|pagesize|extend|status"
		action="${pageContext.request.contextPath}/WfProcessAction.do?method=queryProcess"
		listWidth="100%" >
		<ec:row>
			<ec:column style="text-align:center;" width="30%" property="procName"
				title="流程名称" />
			<ec:column style="text-align:center;" width="10%"
				property="procVersion" title="流程版本" />
			<ec:column style="text-align:center;" width="10%"
				property="isActiveVersion" title="激活状态"
				mappingItem="isActiveVersionMap" />
			<ec:column style="text-align:center;" width="10%"
				property="builder.participantName" title="创建人" />
			<ec:column style="text-align:center;" width="20%"
				property="buildTime" title="创建时间" cell="date"
				format="yyyy-MM-dd HH:mm:ss" />
			<ec:column style="text-align:center;" width="20%" property="procDesc"
				title="流程描述" />
			<ec:column style="display: none;" width="0%"
				headerStyle="display: none;" property="procId" title="主键" />
			<ec:column style="display: none;" width="0%"
				headerStyle="display: none;" property="procVersion" title="版本" />
			<ec:column style="display: none;" width="0%"
				headerStyle="display: none;" property="procCategory" title="流程分类" />
		</ec:row>
	</ec:table>
	<table width="100%" class="jt_botton_table" border="0" cellpadding="0"
		cellspacing="0">
		<tr>
			<td align="right">
				<input id="btnAddWfProcess" type="button" value="新增" onClick="addWfProcess()" />
				<input id="btnCopyProcess" type="button" value="复制流程" onclick="categorySelect('copyProcess')"/>
				<input id="btnUpdateWfProcess" type="button" value="修改" onClick="updateWfProcess()" />
				<input id="btnDeleteWfProcess" type="button" value="删除" onClick="deleteWfProcess('queryForm', 'ec')" />
				<input id="btnActiveWfProcess" type="button" value="激活" onClick="activeWfProcess()" />
				<input id="btnDeleteWfProcess" type="button" value="创建实例" onClick="createProcessInstance()" />
				<input id="btnImportWfProcess" type="button" value="导入实例" onClick="doImportProcessInstance(bizCateId,bizCateName)" />
				<input id="btnExportWfProcess" type="button" value="导出实例" onClick="doExportProcessInstance()" />
				<input id="btnUpdateProcessCategory" type="button" value="修改分类" onClick="categorySelect('updateCategory')" />
			</td>
		</tr>
	</table>
</body>
</html>