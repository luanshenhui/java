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
	<title>流程popup页面</title>
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
	<script type="text/javascript" src="<%=webpath%>/view/workflow/management/monitor/ProcessPopup.js"></script>
</head>
<body style="margin: 10px;">
	<ec:table
		items="recordList" var="record" style="table-layout:fixed"
		toolbarContent="status"  rowsDisplayed="9999"
		action="${pageContext.request.contextPath}/ProcessInstanceMonitorAction.do?method=getProcessList"
		listWidth="100%">
		<ec:row>  
			<ec:column property="_0" title="序号" value="${GLOBALROWCOUNT}" />
			<ec:column style="text-align:center;" property="procName" title="名称" />
			<ec:column style="text-align:center;" property="procVersion" title="版本" />
			<ec:column property="_3"  sortable="false" title="操作" viewsAllowed="html">
				<a href="javascript:return false;" onclick="doSelect('${record.procId}','${record.procVersion}','${record.procName}')">选择</a>
			</ec:column>
		</ec:row>
	</ec:table>
</body>
</html>