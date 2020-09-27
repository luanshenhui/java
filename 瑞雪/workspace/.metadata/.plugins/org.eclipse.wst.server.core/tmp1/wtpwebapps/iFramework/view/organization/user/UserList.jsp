<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
<%@ page import="com.dhc.organization.user.domain.WF_ORG_USER"%>
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
<title><bean:message key="user.title.user_mngt"/></title>
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
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.js"></script>
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
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript" 
	src="<%=webpath%>/view/organization/user/UserList.js"></script>
</head>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
</script>
<body>

<form name="queryForm" class="jqueryui">
<fieldset class="title1">
		<legend><bean:message key="commmon.fieldset.search"/></legend>
		<table align="left" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="width:10%;padding-left:1px;padding-right:1px;text-align:center"><bean:message key="org.element.org_unit"/></td>
				<td style="width:22%;padding-left:1px;padding-right:1px">
					<input type="text" style="width:110px;float:left" id="txtUnitName" name="txtUnitName" readOnly>
					<input class="jt_botton_table2" style="padding-left:1px;padding-right:1px;float:left" onClick="queryUnitSelect()" type="button" width="20px" id="btnDot2" value="..." />
					<input type="hidden" id="hidUnitID" name="hidUnitID">
				</td>
				<td style="width:10%;padding-left:1px;padding-right:1px;text-align:center"><bean:message key="org.element.useraccount"/></td>
				<td style="width:14%;padding-left:1px;padding-right:1px"><input type="text" id="txtUserAccount" style="width:110px;float:left" name="txtUserAccount"></td>
				<td style="width:10%;padding-left:1px;padding-right:1px;text-align:center"><bean:message key="user.element.username"/></td>
				<td style="width:14%;padding-left:1px;padding-right:1px"><input type="text" id="txtUserName" style="width:110px;float:left" name="txtUserName"></td>
				<td style="width:8%;padding-left:1px;padding-right:1px;text-align:center"><bean:message key="user.prompt.lock_user"/></td>
				<td style="width:12%;padding-left:1px;padding-right:1px">
				  <select style="width:50px" name="cmbLockFlag" id="cmbLockFlag">
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
		    <input id="btnQueryUser" type="button" value="<bean:message key="common.button.query"/>" onClick="javascript:doQuery('queryForm', 'ec')";>
			<input id="btnReset" type="button" value="<bean:message key="common.button.reset"/>" onClick="javascript:clearQueryCondition();">
		    <input id="btnAddUser" type="button" value="<bean:message key="user.button.add_user"/>" onClick="addUser()" />
			<input id="btnUpdateUser" type="button" value="<bean:message key="user.button.edit_user"/> " onClick="updateUser()" />
			<input id="btnDeleteUser" type="button" value="<bean:message key="user.button.delete_user"/>" onClick="deleteUser('queryForm', 'ec')" />
			<input id="btnLockUser" type="button" value="<bean:message key="user.prompt.lock_user"/>/<bean:message key="user.prompt.unlock_user"/>" onClick="lockUser('queryForm', 'ec')" />
			<input id="btnUserPrivAdjust" type="button" value="<bean:message key="user.button.adjust_user_privilege"/>" onClick="userPrivAdjust()" />
		</td>
	</tr>
</table>
</form>
<fieldset class="title1"><legend><bean:message key="org.element.userlist"/></legend> 
<ec:table
	items="userList" var="record" retrieveRowsCallback="limit" style="table-layout:fixed"
	useAjax="true" minHeight="230" height="230" toolbarContent="navigation|pagejump|pagesize|extend|status"
	action="${pageContext.request.contextPath}/UserAction.do?method=getUser"
	xlsFileName="UserList.xls" csvFileName="UserList.csv" listWidth="100%"
	pageSizeList="5,10,20,50" rowsDisplayed="10">
	<ec:row>
	    <ec:column style="text-align:center;" width="5%" cell="checkbox"  headerCell="checkbox" alias="checkBoxID" 
       		value="${record.userId}"  viewsAllowed="html" /> 
		<ec:column style="display: none;" width="0%" headerStyle="display: none;" 
			property="userId" title="用户主键" />
		<ec:column style="text-align:center;" width="10%" property="userFullname" title="<%=OrgI18nConsts.USER_USERNAME %>" />
		<ec:column style="text-align:center;" width="10%" property="userAccount" title="<%=OrgI18nConsts.USER_ACCOUNT %>" />
		<ec:column style="text-align:center;" tipTitle="${record.userDescription}" width="20%" property="userDescription" title="<%=OrgI18nConsts.USER_DESC %>" />
		<ec:column style="text-align:center;" tipTitle="${record.userUnits}" width="25%" property="userUnits" title="<%=OrgI18nConsts.USER_UNIT %>" />
		<ec:column style="text-align:center;" tipTitle="${record.userRoles}" width="25%" property="userRoles" title="<%=OrgI18nConsts.USER_ROLES %>" />
		<ec:column style="text-align:center;" width="5%" property="userAccountLocked" title="<%=OrgI18nConsts.USER_LOCK %>" />
	</ec:row>
</ec:table>
</fieldset>

<div class="demo" style="display:none">
	<div id="unitDialog" title="<bean:message key="org.element.org_unit"/>" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="unitFrame" src=""   height="300px" width="410px"></iframe>
    </div>
    <div id="addUserDialog" title="<bean:message key="user.title.user_detail"/>" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="addUserFrame" src=""  height="230px" width="360px" ></iframe>
    </div>
     <div id="userPrivAdjustDialog" title="<bean:message key="user.button.adjust_user_privilege"/>" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="userPrivAdjustFrame" src=""  height="300px" width="350px" ></iframe>
    </div>
    <div id="unitAndStaDialog" title="<bean:message key="user.title.unit_and_stat"/>" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="unitAndStaFrame" src=""  height="300px" width="400px" ></iframe>
    </div>
    <div id="roleDialog" title="<bean:message key="user.element.roles"/>" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="roleFrame" src=""  height="280px" width="550px" ></iframe>
    </div>
</div>
</body>
</html>