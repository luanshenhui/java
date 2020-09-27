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
	<title>报表1</title>
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
	<script type="text/javascript" src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/workflow/report/peopleReport.js"></script>
</head>
<body style="margin: 10px;">
	<form method="post" >
		<div>
			<table  cellpadding="0" cellspacing="0"  >
				<tr>
			   		<td width=80px align="right"><span>角色</span></td>
			   		<td ><span style="color:red">&nbsp;*&nbsp;<span></td>
					<td>
						<select id="name" name="name" style="width:137px">
							<option value="">--请选择--</option>
							<ec:options items="roleParticipantMap"></ec:options>
						</select>
					</td>
					<td  width=80px align="right"><span>开始时间</span></td>
			   		<td ><span style="color:red">&nbsp;*&nbsp;<span></td>
					<td>
						<input type="text" id="start_date" name="start_date" readonly="readonly" onclick="WdatePicker()"/>
					</td>
					<td  width=80px align="right"><span>结束时间</span></td>
			   		<td ><span style="color:red">&nbsp;*&nbsp;<span></td>
					<td>
						<input type="text" id="end_date" name="end_date" readonly="readonly"  onclick="WdatePicker()"/>
					</td>
					<td  width=160px align="right">	
						<input type="button" style="width:60px" value="查   询" onclick="doQuery()" />&nbsp;&nbsp;	
						<input type="reset" style="width:60px" value="重   置"/>
					</td>
				</tr>
				<tr>
					<td colspan="10" align="center"><span id="error"  style="color:red"></span></td>
				</tr>
			</table>
		</div>
	</form>
	<div style="margin-top: 10px;">
		<iframe id="report" width="100%" height="500px" border="0px" frameborder="0"></iframe>
	</div>
</body>
</html>