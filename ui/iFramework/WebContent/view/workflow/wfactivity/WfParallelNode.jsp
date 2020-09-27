<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp" isELIgnored="false" %>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ page import="com.dhc.workflow.model.define.ParallelSplitActivity"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String processId = request.getParameter("processId");
	String processVersion = request.getParameter("processVersion");
	ParallelSplitActivity paraAct = new ParallelSplitActivity();
	if(request.getAttribute("paraAct") != null){
		paraAct=(ParallelSplitActivity)request.getAttribute("paraAct");
	}
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>并发活动</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
<script>
	var webpath = "<%=webpath%>";
	var processId = "${param.processId}";
	var processVersion = "${param.processVersion}";
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfactivity/WfParallelNode.js"></script>
</head>
<body class="popUp-body">
	<br>
	<form action="" name="parallelForm">
		<div class="main_label_outline" style="width: 570px">
			<table style="width: 550px" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr style="display:none;">
					<td class="popUp-name">ID:</td>
					<td><input class="w410 popUp-edit" type="text" id="actId" name="actId" readonly="true"
						 styleClass="input_underline" value="<%=paraAct.getActId()==null ? "" :paraAct.getActId() %>" /></td>
				</tr>
				<tr>
					<td class="popUp-name"><font color="#ff0000">*</font>名称:</td>
					<td>
						<input class="w370 popUp-edit" type="text" id="actName" name="actName" styleClass="input_underline" value="<%=paraAct.getActName()==null ? "" :paraAct.getActName() %>"  />
					</td>
				<td valign="bottom">
					<a class="popUp-select" href="#" onclick="WFCommon.CopyContent2Clipboard('actId')">复制ID</a>
				</td>
				</tr>
				<tr>
					<td valign="top" class="popUp-name">描述:</td>
					<td><textarea class="w410 popUp-describe" rows="5" id="actDesc" name="actDesc"   styleClass="input_text"><%=paraAct.getActDesc()==null ?"":paraAct.getActDesc() %></textarea>
					</td>
				</tr>
				<tr>
					<td class="popUp-name">前置条件:</td>
					<td><input class="w370 popUp-edit" type="text"  readonly="true"
						id="preCondition" name="preCondition" value='<%=paraAct.getPreCondition()==null ?"" :paraAct.getPreCondition()%>' /></td>
					<td style=""><a class="popUp-select" href="#" 
						onclick="setupCond('preCondition')">设置</a></td>
				</tr>
					<tr>
					<td class="popUp-name">
						扩展属性:
					</td>
					<td>
						<input class="w370 popUp-edit fl" type="text" readonly="true" id="extendProp" name="extendProp" 
							value='<%=paraAct.getExtendProp()==null ?"" :paraAct.getExtendProp() %>'/>
						<a class="popUp-select" href="#" onclick="editExtendProp()">设置</a>
					</td>
				</tr>
			</table>
		</div>
		<table class="w590 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td style="width: 570px" align="right"> 
					<input class="popUp-button" type="button" value='取消' onclick="window.close()" />
					<input class="popUp-button" type="button" id="sub"  value='提交'  onclick="submit_onclick()" /> 					
				</td>
			</tr>
		</table>
</body>
</html>
