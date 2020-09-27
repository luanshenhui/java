<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/struts-html.tld" prefix="html"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<br/>
<body class="popUp-body">
<div class="main_label_outline mt15">
	<table class="main_button"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="popUp-name">信息提示</td>
		</tr>
		<tr>
			<td height="25px" style="color:red" >
				&nbsp;&nbsp;&nbsp;&nbsp;<%=request.getAttribute("errorMsg") %>
			</td>
		</tr>
	</table>
	<table class="w450 popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">
				<input type="button" class="popUp-button" value="确定" onclick="window.close()" />
			</td>
		</tr>
	</table>
</div>
</body>