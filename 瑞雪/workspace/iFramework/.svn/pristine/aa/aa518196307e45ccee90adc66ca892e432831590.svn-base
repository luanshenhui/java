<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.dhc.workflow.model.define.AutomaticActivity" %>

<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>自动活动</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
<script type="text/javascript">
	var processId  = "${param.processId}";
	var processVersion = "${param.processVersion}";
</script>
<script type="text/javascript"
		src="<%=webpath%>/view/workflow/wfactivity/WfAutoNode.js"></script>
</head>

<body class="popUp-body">
	<br>
	<form action="#" name="autoNodeForm">
		<div class="w530 main_label_outline">

			<table class="main_label_table" cellpadding="0" cellspacing="0">
			<tr style="display:none;">
					<td class="popUp-name">
						ID:
					</td>
					<td>
						<input class="w410 popUp-edit" type="text" id="actId" name="actId" readonly 
							styleClass="input_underline" value="${autoAct.actId}">
						</input>
						
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
						<font style="color: red">*</font>
						名称:
					</td>
					<td>
					<input class="w370 popUp-edit" type="text" id="actName" name="actName" styleClass="input_underline" value="${autoAct.actName}" />
				</td>
				<td valign="bottom">
					<a class="popUp-select" href="#" onclick="WFCommon.CopyContent2Clipboard('actId')">复制ID</a>
				</td>
				</tr>
				<tr>
					<td valign="top" class="popUp-name">
						描述:
					</td>
					<td>
						<textarea class="w410 popUp-describe" id="actDesc" name="actDesc" rows="5"
							styleClass="input_text">${autoAct.actDesc}</textarea>
									
					</td>
				</tr>
			</table>
			<table style="display:none;" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">
						办理时限:
					</td>
					<td>
						<a class="popUp-aLink" href="#" onclick="displaySurvival()">详细设置</a>
					<!-- 办理时限的超时时限设置 -->
					<input type="hidden" id="overdueTimelimit" value="${autoAct.overdueTimelimit}"  />
					<!-- 办理时限催办时限设置 -->
					 <input type="hidden" id="remindTimelimit" value="${autoAct.remindTimelimit}"  />
					<!-- 办理时限超时设置判断变量与简单 -->
					<input type="hidden" id="overdueRdata" value='' />
					<!-- 催办超时限制判断变量与简单 -->
					<input type="hidden" id="remindRdata" value='' />
					<!-- 办理时限的超时动作处理方式 -->
					<input type="hidden" id="overdueAction" value="${autoAct.overdueAction}"  />
					<!-- 催办的处理方式 -->
					<input type="hidden" id="remindAction" value="${autoAct.remindAction}"  />
					<!-- 催办的间隔时间 -->
					<input type="hidden" id="remindInterval" value="${autoAct.remindInterval}"  />
					<!-- 催办的次数 -->
				    <input type="hidden" id="remindCount" value="${autoAct.remindTimes}" />
					<!--办理时限超时的应用程序  -->
					<input type="hidden" id="overdueApp" value="${autoAct.overdueApp}"  />
					<!--办理时限催办的应用程序  -->
				    <input type="hidden" id="remindApp" value="${autoAct.remindApp}" />
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
						事件:
					</td>
					<td>
						<a class="popUp-aLink" href="#" onclick="displayEvents()">详细设置</a>
					</td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">
						前置条件:
					</td>
					<td>
						<input class="w370 popUp-edit fl" type="text" readonly id="preCondition" name="preCondition"
							 value="${autoAct.preCondition}"/>
						<a class="popUp-select" href="#" onclick="displayConditions('preCondition')">设置</a>
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
						后置条件:
					</td>
					<td>
						<input class="w370 popUp-edit fl" type="text" readonly="true" id="postCondition" name="postCondition" 
							 value="${autoAct.postCondition}"/>
						<a class="popUp-select" href="#" onclick="displayConditions('postCondition')">设置</a>
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
						应用程序:
					</td>
					<td>
						<input class="w320 popUp-edit fl" type="text" id="applicationName"  name="applicationName"  value="${app.appName}" readonly 
							styleClass="input_text"/>
						<input type="hidden" id="application" name="application"  value="${app.appId}"/>
										
						<input type="button" class="popUp-select button_small mr10"
							name="openAutoNodeApplication" onclick="openApp(event)"
							value="浏览" />
						 &nbsp;
						<input type="button" class="popUp-select button_small" onclick="clearUp()"
							value="清除" /> 
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
						扩展属性:
					</td>
					<td >
						<input class="w370 popUp-edit fl" type="text" readonly="true" id="extendProp" name="extendProp" 
							 value="${autoAct.extendProp}"/>
						<a class="popUp-select" href="#" onclick="editExtendProp()">设置</a>
					</td>
				</tr>
			</table>
		</div>
		<table class="w550 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td style="width: 570px" align="right">
					<input class="popUp-button" type="button" value="取消" 
						onclick="window.close()" />
					<input class="popUp-button" type="button" value="提交" 
						onclick="submit_onclick()" />					
				</td>
			</tr>
		</table>
	</form>
</body>
</html>