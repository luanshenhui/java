<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.dhc.workflow.model.instance.RelateDataInstance"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	String webpath = request.getContextPath();
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
			var procInstanceId = "${param.procInstanceId}";
			
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
		<div style="margin: 5px auto auto 5px;"  class="main_label_outline">
			<ec:table
				items="relateDataInstList" var="record" toolbarLocation="bottom" editable="true" minHeight="300" height="300" 
				toolbarContent="extend|status" useAjax="true" doPreload="false" listWidth="100%" sortable="false" rowsDisplayed="9999">
				<ec:row>
					<ec:column style="text-align:center;" width="40%" property="rdataName" title="相关数据名称" />
					<ec:column style="text-align:center;" width="20%" property="rdataType" title="相关数据类型" mappingItem="relateDataTypeMap" />
					<ec:column style="text-align:center;" width="40%" property="rdataValue" title="值" editTemplate="value_edit_template" />
					<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="rdataId" title="主键" />
				</ec:row>
			</ec:table>
			<textarea id="value_edit_template" rows="" cols="" style="display: none">
				<input type="text" style="width:100%" name="temp_rdataValue" id="temp_rdataValue" validator="required,length,character" parameter="{required:true,length:[36],character:true}"  onblur="this.parentNode.ondblclick=function(){ECSideUtil.editCell(this,'ec')};ECSideUtil.updateEditCell(this)"/>
			</textarea>
		</div>
		<table>
			<tr>
				<td align="right" style="width: 650px">
					<input type="button" value="提交" class="button_normal" onclick="save()" />
					<input type="button" value="取消" class="button_normal" onclick="javascript:window.close()" />
				</td>
			</tr>
		</table>
	</body>
</html>