<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/struts-html.tld" prefix="html"%>

<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导入流程</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfprocess/WfProcessImport.js"></script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
</script>
</head>
<body class="popUp-body">
	<div class="main_label_outline mt15">
		<html:form method="post" action="/WfProcessAction.do?method=doImportProcess&bizCateId=${param.bizCateId}&bizCateName=${param.bizCateName}" styleId="wfProcessForm" enctype="multipart/form-data">
				<table class="main_button"  border="0" cellpadding="0" cellspacing="0" style="width:100%">
					<tr>
						<td colspan="2" class="popUp-name" style="text-align: left; padding-left: 8px;">
						导入流程分类：${param.bizCateName}
						</td>
					</tr>
					<tr>
						<td class="popUp-name">选择导入文件：</td>
						<td>
							<html:file property="processFile"></html:file>
						</td>
					</tr>
				</table>
				<table class="w450 popUp-buttonBox" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right">
							<input id="btnImportProcess" type="button" value="导入" onclick="doImportProcess()" class="popUp-button"/>
						</td>
					</tr>
				</table>
		</html:form>
	</div>
</body>
</html>