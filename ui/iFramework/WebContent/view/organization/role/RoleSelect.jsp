<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.organization.role.domain.WF_ORG_ROLE"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>

<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
    String language = CommonConsts.LANGUAGE;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="role.title.biz_role_select"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css" 
    href="<%=webpath%>/view/base/theme/css/redmond/ecside/css/ecside_style.css" />
<script type="text/javascript"
	src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>
<script type="text/javascript">
	var $jQuery = $;
</script>
<script type="text/javascript"
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside_msg_utf8_<%=language%>.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/prototype_mini.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside.js"></script>
<script type="text/javascript">
	$jQuery().ready(function(){
		$jQuery('body').bind('keydown',shieldCommon);
	});

	var webpath = "<%=webpath%>";

	//保存选择的结果
	function confirmRoleSelect(){
		debugger
		var returnObj = new Object();
		//用于存放当前页的id，历史页的id不在这里存放
		var currentPageIDs ="";
		var allcheckarray =ECSideUtil.getPageCheckValue("checkBoxID");
		if(allcheckarray)
			currentPageIDs = allcheckarray.join(",");
		//表示hashtable中没有数据
		if (hashTable.hashtable.length == 0){
			returnObj.itemIds = currentPageIDs;
		} else {
			var idString = "";
			//把每一页中选定的那些id都拼成一个串
			for(i=0; i<hashTable.hashtable.length; i++){
				if (hashTable.hashtable[i]){
					idString += hashTable.hashtable[i];
					//alert(idString);
					if (i<hashTable.hashtable.length-1){
						idString += ",";
					}
				}
			}
			if (ECSideUtil.trimString(currentPageIDs) != "")
				idString += ("," + currentPageIDs);
			idString = idString.split(",").uniq().join(",");
			//alert(idString);
			returnObj.itemIds = idString;
		}
		//alert(returnObj.itemIds);
		var returnValue ;
		var sURL1 = webpath + "/RoleAction.do?method=getRolesInRoleIds";
		jQuery.ajax( {
			url : sURL1,
			type : "post",
			async:false,
			dataType : "json",
			data : {
				roleIds : returnObj.itemIds
			},
			success : function(data) {
				if(data.errorMessage == undefined){
					//alert(data.roleNames);
					returnObj.itemTexts = data.roleNames;
					//alert(returnObj.itemIds);
					//alert(returnObj.itemTexts);
					returnValue = returnObj;
					//window.returnValue = returnObj;
					//window.close();
				} else {
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert(NET_FAILD);
				// 通常 textStatus 和 errorThrown 之中 
			    // 只有一个会包含信息 
			    //this;  调用本次AJAX请求时传递的options参数
			}
		});
		return returnValue;
	}

	function closeWin(){
		window.returnValue=null;
		window.close();
	}

</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<div style="width:98%">
	<fieldset class="title1"><legend><bean:message key="role.title.biz_role_list"/></legend> 
		<ec:table
			items="roleList" var="record" retrieveRowsCallback="limit" toolbarContent="navigation|pagejump|pagesize|status"
			useAjax="true" action="${pageContext.request.contextPath}/RoleAction.do?method=getRole&forward=roleSelect&isAdminRole=false"
			xlsFileName="bizRoleList.xls" csvFileName="bizRoleList.csv" listWidth="100%" style="table-layout:fixed"
			pageSizeList="5,10,20,50" rowsDisplayed="10" minHeight="200" height="100%">
			<ec:row>
			    <ec:column width="5%" style="text-align:center;" cell="checkbox"  headerCell="checkbox" alias="checkBoxID" 
			        value="${record.roleId}"  viewsAllowed="html" /> 
				<ec:column width="40%" style="text-align:center;" property="roleName" title="<%=OrgI18nConsts.ROLE_NAME %>" />
				<ec:column width="40%"  style="text-align:center;"property="roleDescription" title="<%=OrgI18nConsts.ROLE_DESC %>" />
				<ec:column width="15%" style="text-align:center;" property="isAdminrole" title="<%=OrgI18nConsts.IS_ADMINROLE %>" />
			</ec:row>
		</ec:table>
	</fieldset>
</div>
<!-- 
<table border=0  width="100%">
<tr><td align="right">
<input id="btnSave" class="jt_button" type="button" value="保存 "
	onclick="confirmRoleSelect()" /> 
<input id="btnClose" class="jt_button"
	type="button" value="关闭" onClick="closeWin()" />
</td></tr>
</table>
 -->
</body>
</html>