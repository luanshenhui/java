<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%@ page import="com.dhc.workflow.model.define.Application"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String appId = request.getParameter("appId");
	//opFlag:0新增，1修改
	String opFlag = request.getParameter("opFlag");
	String processId = request.getParameter("processId");
	String  processVersion = request.getParameter("processVersion");
	Application app =new Application();
	if(request.getAttribute("appDetail")!=null){
		app= (Application)request.getAttribute("appDetail");
	}else{
		//默认异步
		app.setSynchOrAsynch(0);
		//程序类型默认java
		app.setAppType(0);
	}
	
%>

<html>
<head>
	<title>应用程序属性</title>
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />	
	<c:set var="sessionKey" value="${param.processId},${param.processVersion}"/>
	<c:set var="result" value="${sessionScope[sessionKey].appList}"/>

	<script type="text/javascript">
		var appId = <%=appId%>;
		var opFlag = <%=opFlag%>;
		var processId = "${param.processId}";
		var processVersion = "${param.processVersion}";
	</script>
	<script type="text/javascript" src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/workflow/wfapplication/application.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/workflow/wfapplication/OpenWin.js"></script>
</head>

<body onLoad="LoadName()" class="popUp-body">
	<form  name="appForm" class="w570 main_label_outline mt15" >
		<table class="main_label_table" >
			<colgroup>
				<col></col>
				<col></col>
				<col></col>
				<col></col>
				<col></col>
			</colgroup>
			<tr>
				<td class="popUp-name">ID:</td>
				<td colspan="4">
					<input  type="text" id="appId" name="appId"  readonly="true" class="w170 input_underline popUp-edit"
						value='<%=appId %>'>
					</input>
				</td>
			</tr>
			<tr>
				<td class="popUp-name"><font style="color: red">*</font>名称:</td>
				<td colspan="4">
					<input type="text" id="appName" name="appName" class="w170 input_underline popUp-edit"
						value="<%=app.getAppName()==null?"": app.getAppName()%>"/>					
				</td>
			</tr>
			<tr>
				<td valign="top" class="popUp-name">描述:</td>
				<td align="left" colspan="4">
					<input type="textarea" id="appDesc" name="appDesc"  class="w170 input_underline popUp-edit"
						value="<%=app.getAppDesc()==null?"": app.getAppDesc() %>"	 />
				</td>
			</tr>
			<tr>
				<td class="popUp-name">处理器:</td>
				<td colspan="4">
					<input type="text" id="appHost" name="appHost"  onkeypress="validateInput()" class="w170 input_underline popUp-edit"
					 	value="<%=app.getAppHost()==null?"": app.getAppHost()%>"	 />
				</td>
			</tr>
			<tr>
				<td class="popUp-name">调用方式:</td>
				<td colspan="4">

					<input class="mt6 fl mr6"  type="radio" <%=(app.getSynchOrAsynch()!=null&&app.getSynchOrAsynch()==1) ? "checked" : ""%> 
						value="1" name="synchMode" />
					<span class="popUp-SName fl">同步</span>
					
					<input class="mt6 fl mr6" type="radio" <%=(app.getSynchOrAsynch()!=null&&app.getSynchOrAsynch()==0) ? "checked" : ""%> 
						name="synchMode" value="0" />
					<span class="popUp-SName fl">异步</span>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="popUp-name">程序类型:</td>
				<td colspan="4">
					<input class="mt6 fl mr6" type="radio" <%=(app.getAppType()!=null && app.getAppType()==0) ? "checked" : ""%> name="appType" value="0" /> 
					<span class="popUp-SName fl">Java</span>
					<input class="mt6 fl mr6" type="radio" <%=(app.getAppType()!=null && app.getAppType()==1) ? "checked" : ""%> name="appType" value="1" /> 
					<span class="popUp-SName fl">WebService(Rest)</span>
					<input class="mt6 fl mr6" type="radio" <%=(app.getAppType()!=null && app.getAppType()==2) ? "checked" : ""%>  name="appType" value="2" />
					<span class="popUp-SName fl">URL</span>
					<input class="mt6 fl mr6" type="radio" <%=(app.getAppType()!=null && app.getAppType()==3) ? "checked" : ""%> name="appType" value="3" />
					<span class="popUp-SName fl">EXE</span>
				</td>
			</tr>
			<tr>
				<td class="popUp-name">程序URI:</td>
				<td colspan="4">
					<input class="w435 popUp-edit" type="text" id="appUrl" name="appUrl" 
						value="<%=app.getAppUrl()==null?"": app.getAppUrl()%>" />
				</td>
			</tr>
			
		</table>
		
		<input type="hidden" id="processId"  value="<%=processId%>" />
		<input type="hidden" id="processVersion" value="<%=processVersion%>" />
	</form>
		<table class="w590  popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="5" align="right">					
					<input class="popUp-button" type="button" value="取消" onclick="window.close()" />
					<input class="popUp-button" type="button" value="提交" onclick="submit_onclick('<%=opFlag %>')" />
				</td>
			</tr>
		</table>
</body>
</html>