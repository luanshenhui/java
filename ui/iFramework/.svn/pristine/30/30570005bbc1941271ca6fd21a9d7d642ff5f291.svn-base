<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	//返回选择结果时，确定哪一列是要返回显示的。此参数必填！
	String displayColumnName = (String)request.getParameter("displayColumnName");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务分类选择</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/framework/common/jsp/EcHeader.jsp" flush="true" />
<script type="text/javascript">
	//返回选择结果时，确定哪一列是要返回显示的。
	var displayColumnName = "<%=displayColumnName%>";
</script>
<script type="text/javascript">
	
	$jQuery().ready(function(){
// 		$jQuery('body').bind('keydown',shieldCommon);
	});

	var webpath = "<%=webpath%>";
	
	//保存选择的结果
	function confirmWfBizCategoryParentSelect(){
		
		var returnValue = new Object();
		var ecsideObj=ECSideUtil.getGridObj("ec");
		var crow=ecsideObj.selectedRow;
		if (crow == null || crow.cells[0] == undefined){
			returnValue.itemIds = "";
			returnValue.itemTexts = "";
			
		} else {
			var selectedWfBizCategoryParentID = ECSideUtil.getPropertyValue(crow,"bizCateId","ec");
			var selectedWfBizCategoryParentName = ECSideUtil.getPropertyValue(crow,"bizCateName","ec");
			returnValue.itemIds = selectedWfBizCategoryParentID;
			returnValue.itemTexts = selectedWfBizCategoryParentName;
		}
		return returnValue;
	}

	function closeWin(){
		window.returnValue=null;
		window.close();
	}

</script>
</head>
<body>
<!-- 	<fieldset><legend>业务分类列表</legend>  -->
		<ec:table
			items="wfbizcategoryList" var="record" retrieveRowsCallback="limit" toolbarContent="navigation|pagejump|pagesize|status"
			useAjax="true" action="${pageContext.request.contextPath}/WfBizCategoryAction.do?method=getWfBizCategory&forward=wfbizcategorySelect"
			xlsFileName="bizWfBizCategoryList.xls" csvFileName="bizWfBizCategoryList.csv" listWidth="100%" style="table-layout:fixed"
			pageSizeList="5,10,20,50" >
			<ec:row>
				<ec:column width="5%" style="text-align:center;" cell="radiobox" headerCell="radiobox" alias="checkBoxID" 
					value="${record.bizCateId}"  viewsAllowed="html" /> 
				<ec:column style="text-align:center;" width="30%" property="bizCateName" title="分类名称" />
				<ec:column style="text-align:center;" width="35%" property="bizCateDesc" title="分类描述" /> 
				<ec:column style="text-align:center;" width="30%" property="bizCateParentName" title="父分类名称" />
				<ec:column style="display: none;" width="0%" headerStyle="display: none;" 
					property="bizCateId" title="主键" /> 
			</ec:row>
		</ec:table>
<!-- 	</fieldset> -->
	
<table border=0  width="100%">
	<tr>
		<td align="center">
			<input id="btnSave" class="jt_button" type="button" value="保存 " onclick="confirmWfBizCategoryParentSelect()" /> 
			<input id="btnClose" class="jt_button" type="button" value="关闭" onClick="closeWin()" />
		</td>
	</tr>
</table>
</body>
</html>