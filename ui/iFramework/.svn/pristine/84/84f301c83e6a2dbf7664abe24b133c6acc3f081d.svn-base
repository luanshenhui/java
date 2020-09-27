<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.organization.role.domain.WF_ORG_ROLE"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>

<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,"opFlag,roleID"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String language = CommonConsts.LANGUAGE;
	String opFlag = request.getParameter("opFlag");
	String roleID = request.getParameter("roleID");

    boolean hasAdminRole = false;
    try {
		SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
		//如果session超时，则重新登录
		if (securityUser.getUserBean() == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
		}
		//over
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
<title>角色详细信息</title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<script type="text/javascript"
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>
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
	var $jQuery = $;
</script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>

<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquerytools/tooltip.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/localization/messages_<%=language%>.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.ext.js"></script>

<script type="text/javascript"
	src="<%=webpath%>/view/organization/role/RoleDetail.js"></script>

<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var opFlag = "<%=opFlag%>";
	var roleID = "<%=roleID%>";
	var hasAdminRole = "<%=hasAdminRole%>";
</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<form id="detailForm" name="detailForm" class="jqueryui">
<div style="padding:0px 0px 0px 0px">
<table align="left" cellpadding="0" cellspacing="3"
	 width="100%" style="padding:5px 0px 0px 0px;margin:0; border:0;">
	<tr>
		<td style="width: 30%"><bean:message key="role.element.rolename"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td style="width: 70%">
			<input type="text" id="txtRoleName" name="txtRoleName" >
			<input type="hidden" id="hidRoleID" />
		</td>
	</tr>
	<tr>
		<td><bean:message key="role.element.roledesc"/>:</td>
		<td><input type="text" id="txtRoleDesc" name="txtRoleDesc" ></td>
	</tr>
	<tr>
		<td><bean:message key="role.element.max_users"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td><input type="text" id="txtMax" name="txtMax" value="-1"></td>
	</tr>
	<tr>
		<td><bean:message key="role.element.include_users"/>:</td>
		<td>
			<input type="text" id="txtRoleUsers" readOnly>
			<input class="jt_botton_table2" onclick="userSelect()" type="button" id="btnDot1" value="..." />
			<input type="hidden" id="txtRoleUsersValue">
		</td>
	</tr>
	<tr>
		<td><bean:message key="role.element.mng_role"/>:</td>
		<td><select style="width: 100px" id="selIsAdminRole" onchange="adminRoleChange();">
			<option value="否"><bean:message key="role.element.no"/></option>
			<option value="是"><bean:message key="role.element.yes"/></option>
		</select></td>
	</tr>
	<tr>
		<td><bean:message key="role.element.managable_units"/>:</td>
		<td>
			<input type="text" id="txtRoleUnits" readOnly>
			<input class="jt_botton_table2" onclick="unitSelect1()" type="button" id="btnDot2" value="..." />
			<input type="hidden" id="txtRoleUnitsValue">
		</td>
	</tr>
</table>
</div>
</form>
<table border=1  width="100%" style="display:none;">
<tr><td align="right">
<input id="btnSave" class="jt_button" type="button" value="保存 "
	onclick="saveRole()" /> 
<input id="btnClose" class="jt_button"
	type="button" value="关闭" onClick="closeWin()" />
</td></tr>
</table>

</body>
</html>