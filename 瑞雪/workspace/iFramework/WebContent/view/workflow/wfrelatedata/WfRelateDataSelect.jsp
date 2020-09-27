<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ page import="com.dhc.workflow.model.define.RelateData"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	String webpath = request.getContextPath();
	Map relateDataTypeMap = new HashMap<String, String>();
	try {
		//防跨站脚本编制
		//返回选择结果时，确定哪一列是要返回显示的。此参数必填！
		String displayColumnName = (String)request.getParameter("displayColumnName");
		String processId = (String)request.getParameter("processId");
		String processVersion =(String)request.getParameter("processVersion");
		//System.out.println(processId);
		//System.out.println(processVersion);
		Process process = (Process)request.getSession().getAttribute(processId + "," + processVersion);
		List<RelateData> relatedataList = process.getRdataList();
		//System.out.println(relatedataList.size());
		request.setAttribute("relatedataList", relatedataList);
		relateDataTypeMap.put("0", "字符串");
		relateDataTypeMap.put("1", "数值");
		request.setAttribute("relateDataTypeMap", relateDataTypeMap);
		
	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>相关数据</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/uuid.js" ></script>

<script type="text/javascript">

	var webpath = "<%=webpath%>";
	var processId = "${param.processId}";
	var processVersion = "${param.processVersion}";
	
	//保存选择的结果
	function confirmWfRelateDataSelect(){
		var returnValue = new Object();
		var ecsideObj=ECSideUtil.getGridObj("ec");
		var crow=ecsideObj.selectedRow;
		if (crow == null || crow.cells[0] == undefined){
			returnValue.itemIds = "";
			returnValue.itemTexts = "";
		} else {
			var selectedWfRelateDataID = ECSideUtil.getPropertyValue(crow,"rdataId","ec");
			var selectedWfRelateDataName = ECSideUtil.getPropertyValue(crow,displayColumnName,"ec");
			returnValue.itemIds = selectedWfRelateDataID;
			returnValue.itemTexts = selectedWfRelateDataName;
		}
		return returnValue;
	}

	function closeWin(){
		window.returnValue=null;
		window.close();
	}
	
	// grid提交
	function save() {
		var allRowJSON = ECSideUtil.getAllRowsJSON("ec");

		// window.opener.document.getElementById('transitionVariables').value = allRowJSON;//rdatavariables;
		var sURL = webpath + "/WfProcessAction.do?method=saveRelateData";
		// 调用AJAX请求函数
		$jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : "processId=" + processId + "&processVersion=" + 
			processVersion + "&detailsJSON=" + allRowJSON,
			success : function(data) {
				window.close();
			}
		});
	}
	
	function addRow(){
		var newRow = ECSideUtil.addToGird(this,'ec_add_template', 'ec');
		// 新建的行，给ID列赋值
		newRow.cells[4].setAttribute("cellValue",new UUID() + "");
	}
	
	function deleteRow(){
		ECSideUtil.delFromGird(this, 'ec');
		//ECSideUtil.selectedRow.parentNode.removeChild(ECSideUtil.selectedRow);
	}
</script>
</head>

<body class="popUp-body">
<div class="main_label_outline mt15">
<table class="main_button"  border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="left">
			<input class="popUp-button" id="btnUpdateWfProcess" type="button" value="删除" onClick="deleteRow()" />
			<input class="popUp-button" id="btnQueryWfProcess" type="button" value="添加" onClick="addRow()">
			
		</td>
	</tr>
</table>
<div>
	<ec:table toolbarContent="status"
		items="relatedataList" var="record" editable="true" 
		minHeight="300" height="300"
		 action="${pageContext.request.contextPath}/WfRelateDataAction.do?method=getWfRelateData&forward=wfrelatedataSelect"
		listWidth="100%" >
		<ec:row>
			<ec:column style="text-align:center;" width="25%" property="rdataName" title="相关数据名称" />
			<ec:column style="text-align:center;" width="25%" property="defaultValue" title="相关数据缺省值" />
			<ec:column style="text-align:center;" width="25%" property="rdataType" title="相关数据类型" mappingItem="relateDataTypeMap" />
			<ec:column style="text-align:center;" width="25%" property="rdataDesc" title="相关数据描述" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" 
				property="rdataId" title="主键" />
		</ec:row>
	</ec:table>
	<textarea id="add_template" rows="" cols="4" style="display: none" width="98%">
		<input type="text" width="25%" style="width:100%" name="rdataName" id="rdataName" validator="required,length,character" parameter="{required:true,length:[36],character:true}" onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)"/>
		<tpsp />
		<input type="text" width="25%" style="width:100%" name="defaultValue" id="defaultValue" validator="required,length,integer" parameter="{required:true,length:[50],character:true}"  onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)" />
		<tpsp />
		<select id="rdataType" name="rdataType" width="25%" style="width:100%" validator="required,lcharacter" parameter="{required:true,character:true}" onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)">
			<option value='0' selected>字符串</option><option value='1'>数值</option>
		</select>
		<tpsp />
		<input type="text" width="25%" style="width:100%" name="rdataDesc" id="rdataDesc" validator="required,length,character" parameter="{required:true,length:[36],character:true}"  onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)"/>
		<tpsp />
	</textarea>
</div>
<table width="100%" class="popUp-buttonBox" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<input class="popUp-button" type="button" value="取消" class="button_normal" onclick="javascript:window.close()" />
			<input class="popUp-button" type="button" value="提交" class="button_normal" onclick="save()" />
			
		</td>
	</tr>
</table>
</div>
</body>
</html>