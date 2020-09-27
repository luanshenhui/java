<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
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
    boolean hasAdminRole = false;
    try {
		SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
		hasAdminRole = securityUser.getUserBean().hasAdminRole();
    } catch (Exception ex) {
    	hasAdminRole = false;
    }
    if (!hasAdminRole)
    	response.sendRedirect(webpath + "/accessDenied.jsp");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="role.title.role_mngt"/></title>
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
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.min.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.ui.core.min.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.draggable.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.resizable.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.dialog.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.effects.core.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.effects.highlight.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.ui.widget.min.js"></script>
<script type="text/javascript">
	var jQuery = $;
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside_msg_utf8_<%=language%>.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/prototype_mini.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside_ext.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript" 
	src="<%=webpath%>/view/organization/role/RoleList.js"></script>

<script type="text/javascript">
	var webpath = "<%=webpath%>";
	// 将jQuery使用的$转义成$jQuery，避免jQuery和prototype冲突

	function test(){
		var jsonString = ECSideUtil.getSelectedRowJSON('ec');
		alert(jsonString);
		var obj=eval("({" + jsonString + "})");
		alert(obj.selectedRecords[0].roleId);
	}

</script>
</head>
<body>

<form name="queryForm" class="jqueryui">
<fieldset class="title1">
		<legend><bean:message key="commmon.fieldset.search"/></legend>
		<table align="left" border="0" cellpadding="0" cellspacing="3">
			<tr>
				<td style="width:20%"><bean:message key="role.element.rolename"/></td>
				<td style="width:30%"><input type="text" name="txtRoleName" id="txtRoleName"></td>
				<td style="width:20%"><bean:message key="role.element.is_adminrole"/></td>
				<td style="width:30%">
				  <select style="width:100px" name="selIsAdminRole" id="selIsAdminRole">
					<option value=""></option>
					<option value="true"><bean:message key="role.element.yes"/></option>
					<option value="false"><bean:message key="role.element.no"/></option>
				  </select>
				</td>
			</tr>
		</table>
</fieldset>
<table width="100%" class="jt_botton_table" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="4" align="right">
		    <input id="btnQueryRole" type="button" value="<bean:message key="common.button.query"/>" onClick="javascript:doQuery('queryForm', 'ec')";>
			<input id="btnReset" type="reset" value="<bean:message key="common.button.reset"/>">
		    <input id="btnAddRole" type="button" value="<bean:message key="role.btn.add_role"/>" onClick="addRole()" />
			<input id="btnUpdateRole" type="button" value="<bean:message key="role.btn.edit_role"/> " onClick="updateRole()" />
			<input id="btnDeleteRole" type="button" value="<bean:message key="role.btn.del_role"/>" onClick="deleteRole('queryForm', 'ec')" />
		</td>
	</tr>
</table>
</form>

<fieldset class="title1"><legend><bean:message key="role.element.role_list"/></legend> 
	<ec:table
		items="roleList" var="record" retrieveRowsCallback="limit" style="table-layout:fixed"
		useAjax="true" minHeight="230" height="230" toolbarContent="navigation|pagejump|pagesize|extend|status"
		action="${pageContext.request.contextPath}/RoleAction.do?method=getRole"
		xlsFileName="RoleList.xls" csvFileName="RoleList.csv" listWidth="100%"
		pageSizeList="5,10,20,50" rowsDisplayed="10">
		<ec:row>
		    <ec:column style="text-align:center;" width="10%" cell="checkbox"  headerCell="checkbox" alias="checkBoxID" 
	       		value="${record.roleId}"  viewsAllowed="html" /> 
			<ec:column style="text-align:center" width="10%" property="_0" title="<%=OrgI18nConsts.TABLE_COLUMN_SEQUENCE %>"
				value="${GLOBALROWCOUNT}" />
			<ec:column style="text-align:center;" width="35%" property="roleName" title="<%=OrgI18nConsts.ROLE_NAME %>" />
			<ec:column style="text-align:center;" width="35%" property="roleDescription" title="<%=OrgI18nConsts.ROLE_DESC %>" />
			<ec:column style="text-align:center;" width="10%" property="isAdminrole" title="<%=OrgI18nConsts.IS_ADMINROLE %>" />
			<ec:column style="display: none;" width="0%" headerStyle="display: none;" 
				property="roleId" title="角色主键" />
		</ec:row>
	</ec:table>
</fieldset>

</body>
</html>