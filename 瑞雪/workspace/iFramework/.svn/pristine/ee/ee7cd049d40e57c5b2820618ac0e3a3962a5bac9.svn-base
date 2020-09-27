<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.model.define.Application"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String procId = request.getParameter("processId");
	String procVer = request.getParameter("processVersion");
	String overtimeAppName = "";
	String remiderAppName = "";
	
	try {
		Process process = (Process)session.getAttribute(procId + "," + procVer);
		if(process.getAppList()!=null){
			for (Application app : process.getAppList()) {
				if (app.getAppId().equals(request.getParameter("overdueApp"))){
					overtimeAppName = app.getAppName();
				}
				if (app.getAppId().equals(request.getParameter("remindApp"))){
					remiderAppName = app.getAppName();
				}
			}
		}
		
	} catch (Exception ex) {
		// 里应该跳转了
	}
	System.out.println(overtimeAppName);

	System.out.println(remiderAppName);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>办理时限</title>
	
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<c:set var="sessionKey" value="${param.processId},${param.processVersion}"/>
<script type="text/javascript" src="<%=webpath%>/view/workflow/wfprocess/WfProcessExpiration.js"></script> 

<script type="text/javascript">
var processId = "${param.processId}";
var processVersion = "${param.processVersion}";
jQuery(document).ready(function(){
	displayDiv();
});
</script>
</head>
<body class="popUp-body">
	<!-- 办理时限的时间设置 -->
	<input type="hidden" id="duration" value='<%=request.getParameter("overdueTimelimit") %>'></input>
	<!-- 预警的时间设置 -->
	<input type="hidden"  id="alertDuration" value='<%=request.getParameter("remindTimelimit") %>'></input>
	<!-- 办理时限判断变量与简单 -->
	<input type="hidden"  id="varOrDur" value='<%=request.getParameter("overdueRdata") %>'></input>
	<!-- 催办判断变量与简单 -->
	<input type="hidden" id="alertVarOrDur" value='<%=request.getParameter("remindRdata") %>'</input> 	 	
	<!-- 办理时限的处理方式 -->
	<input type="hidden" id="actionType" value='<%=request.getParameter("overdueAction") %>'</input> 	 	
	<!-- 预警的处理方式 -->
	<input type="hidden" id="alertActionType" value='<%=request.getParameter("remindAction") %>'</input> 	 	
	<!-- 预警的间隔时间 -->
	<input type="hidden" id="alertActionInterval" value='<%=request.getParameter("remindInterval") %>'/> 	 	
	<!--办理时限超时的应用程序  -->
	  <input type="hidden" id="overdueApp" value='<%=request.getParameter("overdueApp") %>'/> 	 	
	<!--办理时限预警的应用程序  -->
	<input type="hidden"  id="remindApp" value='<%=request.getParameter("remindApp") %>'/> 

	<div class="w500 main_label_outline mt15">
		<fieldset class="popUp-fieldset">
			<legend>超时设置</legend>
			<div id="delayTime">
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">时间设置:</td>
						<td>
							<input id="durationDay" type="text" class="w30 popUp-edit input_text"  value=0  onkeyup="ffNum(this.id)"  />
							<span class="popUp-smailName">天</span>
						</td>
						<td>
						    <input id="durationHour"  type="text" class="w30 popUp-edit input_text" value=0 onkeyup="ffNum(this.id)" />
							<span class="popUp-smailName">小时</span>
						</td>
						<td>
							<input  id="durationMin"  type="text"  class="w30 popUp-edit input_text" value=0 onkeyup="ffNum(this.id)" />
						    <span class="popUp-smailName">分钟</span>
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">处理方式:</td>
						<td>
							<input class="mt6 fl mr6" type="radio" name="delayType" class="rodio" value="0" onclick="displayDelayApp()" <%= request.getParameter("overdueAction").equals(0) ? "checked" : "" %> />
							<span class="popUp-SName fl">等待</span>
						</td>
						<td>
							<input class="mt6 fl mr6" type="radio" name="delayType" class="rodio" value="1" onclick="displayDelayApp()" <%=request.getParameter("overdueAction").equals(1)  ? "checked" : "" %> />
							<span class="popUp-SName fl">终止</span>
						</td>
						<td>
							<input class="mt6 fl mr6" type="radio" name="delayType" class="rodio" value="2" onclick="displayDelayApp()" <%=request.getParameter("overdueAction").equals(2) ? "checked" : "" %>  />
							<span class="popUp-SName fl">挂起</span>
						</td>
						<td>
							<input class="mt6 fl mr6" type="radio" name="delayType" class="rodio" value="3" id="delayApp" onclick="displayDelayApp()" <%=request.getParameter("overdueAction").equals(3) ? "checked" : "" %>  />
							<span class="popUp-SName fl">应用程序</span>
						</td>
					</tr>
				</table>
			</div>
		<div id="application1" style="display:block">
			<table class="main_label_table">
				<tr>
					<td class="popUp-name">应用程序:</td>
					<td>
						<input type="text" id="delayApplication" class="w250 popUp-edit  fl" value='<%=overtimeAppName %>' disabled="disabled" />
						<inpu type="hidden" id="actionApplication" name="actionApplication" value='<%=request.getParameter("overdueApp") %>' readonly="true">
						<input type="button" id="application1_browse" class="popUp-select button_small mr10 fl" name="openDelayApplication" onclick="openApp(event)" value="浏览" disabled="disabled">
						<input type="button" id="application1_clear" class="popUp-select button_small fl" onclick="clearUp1()" value="清除" disabled="disabled">
					</td>
				</tr>
			</table>
		</div>
		</fieldset>
		<fieldset class="popUp-fieldset">
			<legend>催办设置</legend>
			<div id="alertTime">
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">时间设置:</td>
						<td>
						
						<input id="alertDurationDay" type="text" class="w30 popUp-edit input_text"  value=0 onkeyup="ffNum(this.id)" />
						<span class="popUp-smailName">天</span>
						</td>
						<td>
						<input id="alertDurationHour"  type="text" class="w30 popUp-edit input_text"  value=0 onkeyup="ffNum(this.id)" />
						<span class="popUp-smailName">小时</span>
						</td>
						<td>
						<input  id="alertDurationMin" type="text"  class="w30 popUp-edit input_text"value=0 onkeyup="ffNum(this.id)" />
						<span class="popUp-smailName">分钟</span>							
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">间隔时间:</td>
						<td>
						<input id="intervalDay" type="text" class="w30 popUp-edit input_text" onkeyup="ffNum(this.id)" value=0 />
						<span class="popUp-smailName">天</span>
						</td>
						<td>
						<input id="intervalHour" type="text" class="w30 popUp-edit input_text"  onkeyup="ffNum(this.id)" value=0 />
						<span class="popUp-smailName">小时</span>
						</td>
						<td>
						<input id="intervalMin"  type="text"  class="w30 popUp-edit input_text" onkeyup="ffNum(this.id)" value=0 />
						<span class="popUp-smailName">分钟</span>	
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">催办次数:</td>
						<td align="right">
							<input type="text" class="popUp-edit input_text" style="width: 100px;" id="remindCount" name="remindCount" value='<%=request.getParameter("remindCount") %>'></input>
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">处理方式:</td>
						<td>
							<input class="mt6 fl mr6" type="radio" name="alertType" class="rodio"  value="0" onclick="displayAlertApp()" <%= request.getParameter("remindAction").equals(0) ? "checked" : "" %>  />
							<span class="popUp-SName fl">默认</span>	
						</td>
						<td>
					   		<input class="mt6 fl mr6" type="radio" name="alertType" class="rodio"  value="1" id="alertApp" onclick="displayAlertApp()" <%= request.getParameter("remindAction").equals(1) ? "checked" : "" %>  />
					   		<span class="popUp-SName fl">应用程序</span>	
					   	</td>
				</table>
			</div>
			<div id="application2">
				<table class="main_label_table">
					<tr>
						<td class="popUp-name">应用程序:
						</td>
						<td>
						    <input type="text" id="alertApplication" class="w250 popUp-edit input_text fl" value='<%=remiderAppName %>' disabled="disabled" />
						    <input type="hidden" id="alertActionApplication" name="alertActionApplication" value='<%=request.getParameter("remindApp") %>' readonly="true"/>
						    <input type="button" id="application2_browse" class="popUp-select button_small mr10" name="openAlertApplication" onclick="openApp(event)" value="浏览" disabled="disabled"/>
						    <input type="button" id="application2_clear" class="popUp-select button_small" onclick="clearUp2()" value="清除" disabled="disabled"/>
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<table class="w520  popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">
			<input class="popUp-button" type="button" value="取消" onclick="window.close()" />
			<input class="popUp-button" type="button" value="提交"
				 onclick="setParentValue();" />			
			</td>
		</tr>
	</table>
	<!-- 超时设置：默认简单 -->
	<input type="hidden" name="dRadio" id="dRadio" value="0"  >
	<!-- 催办设置：默认简单 -->
	<input type="hidden" name="alertRadio" id="alertRadio" value="0" >
</body>
</html>