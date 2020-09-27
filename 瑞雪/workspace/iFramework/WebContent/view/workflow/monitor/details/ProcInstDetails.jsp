<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"
	errorPage="/ErrorNormal.jsp" isELIgnored="false"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	String webpath = request.getContextPath();
	Map<String, String> procInstMap = (Map<String, String>)request.getAttribute("procInstance");
	if (procInstMap == null) {
		procInstMap = new HashMap<String, String>();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程实例详细</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/monitor/details/ProcInstDetails.js"></script>
<script type="text/javascript">

	var webpath = "<%=webpath%>";
	var procInstanceId = "${param.procInstanceId}";
	
	function closeWin(){
		window.returnValue=null;
		window.close();
	}
	
	// grid提交
	function save() {
		var allRowJSON = ECSideUtil.getAllRowsJSON("ec");

		// window.opener.document.getElementById('transitionVariables').value = allRowJSON;//rdatavariables;
		var sURL = webpath + "/WorkitemManagementAction.do?method=saveRelateDataInstance";
		// 调用AJAX请求函数
		$jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : "detailsJSON=" + allRowJSON + "&procInstanceId=" + procInstanceId,
			success : function(data) {
				window.close();
			}
		});
	}

</script>
</head>
<body class="popUp-body">
	<br/>
	<div class="w550 main_label_outline">
		<font style="color: #C6CEE1;font-size: 18px;font-weight:bolder;height:30px;line-height:30px;">流程实例</font>
		<table style="width: 520px" class="" cellpadding="0"
			cellspacing="0" height="220px">
			<tr>
				<td class="popUp-name">实例ID:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtProcInstID" name="txtProcInstID" value="<%=procInstMap.get("procInstanceId") %>" /> </td>
				<td class="popUp-name">实例名称:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtProcInstName" name="txtProcInstName" value="<%=procInstMap.get("name") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">实例创建者</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtInstCreatorID" name="txtInstCreatorID" value="<%=procInstMap.get("createrId") %>" /></td>
				<td class="popUp-name">实例创建时间:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtCreateTime" name="txtCreateTime" value="<%=procInstMap.get("startTime") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">实例当前状态:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtCurrentStatus" name="txtCurrentStatus" value="<%=procInstMap.get("currentStatus") %>" /></td>
				<td class="popUp-name">实例完成时间:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtCompleteTime" name="txtCompleteTime" value="<%=procInstMap.get("completeTime") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">实例是否超时:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtIsOvertime" name="txtIsOvertime" value="<%=procInstMap.get("hasOvertime") %>" /></td>
				<td class="popUp-name">实例是否催办:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtIsRemind" name="txtIsRemind" value="<%=procInstMap.get("hasReminder") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">流程ID:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtProcID" name="txtProcID" value="<%=procInstMap.get("processId") %>" /></td>
				<td class="popUp-name">流程名称:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtProcName" name="txtProcName" value="<%=procInstMap.get("processName") %>" /></td>
			</tr>
			<tr>
				<td class="popUp-name">流程分类:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtCategory" name="txtCategory" value="<%=procInstMap.get("processCategory") %>" /></td>
				<td class="popUp-name">流程版本:</td>
				<td><input class="w150 popUp-edit" disabled="disabled" type="text" 
					id="txtProcVersion" name="txtProcVersion" value="<%=procInstMap.get("processVer") %>" /></td>
			</tr>
		</table>
		<ec:table items="relateDataInstList" var="record"
			toolbarLocation="bottom" editable="true" minHeight="200" height="200"
			toolbarContent="extend|status" useAjax="true" doPreload="false"
			listWidth="100%" sortable="false" rowsDisplayed="9999">
			<ec:row>
				<ec:column style="text-align:center;" width="40%"
					property="rdataName" title="相关数据名称" />
				<ec:column style="text-align:center;" width="20%"
					property="rdataType" title="相关数据类型" mappingItem="relateDataTypeMap" />
				<ec:column style="text-align:center;" width="40%"
					property="rdataValue" title="值" editTemplate="value_edit_template" />
				<ec:column style="display: none;" width="0%"
					headerStyle="display: none;" property="rdataId" title="主键" />
			</ec:row>
		</ec:table>
		<textarea id="value_edit_template" rows="" cols=""
			style="display: none">
				<input type="text" style="width: 100%" name="temp_rdataValue"
				id="temp_rdataValue" validator="required,length,character"
				parameter="{required:true,length:[36],character:true}"
				onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)" />
		</textarea>
	</div>

	<table class="w550 popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">
				<input type="button" value="取消"
					class="popUp-button" onclick="window.close()" />
				<input type="button" id="sub" value="提交" class="popUp-button"
					onclick="save()" />
			</td>
		</tr>
	</table>
</body>
</html>