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
	if (SecurityUtil.existUnavailableChar(request,"sendopFlag,senduserID"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String language = CommonConsts.LANGUAGE;
    String sendopFlag = request.getParameter("sendopFlag");
    String senduserID = request.getParameter("senduserID");
    
	//防跨站脚本编制
	if (SecurityUtil.existUnavailableChar(request,"sendflag,checkId"))
		response.sendRedirect(webpath + "/view/base/error/IllegalArgumentException.jsp");
    
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
<title><bean:message key="user.title.user_detail"/></title>
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
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>
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
	var $jQuery = $;
	var webpath = "<%=webpath%>";
	var opFlag = "<%=sendopFlag%>";
	var userID = "<%=senduserID%>";
	var hasAdminRole = "<%=hasAdminRole%>";
</script>

<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquerytools/tooltip.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/localization/messages_<%=language%>.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.ext.js"></script>

<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/organization/user/UserDetail.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/extinfo/extinfo.js"></script>
	

</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<div id="tabs" style="border:0px;">
	<ul>
		<li><a href="#tabs-1"><bean:message key="org.element.basic_property"/></a></li>
		<li><a href="#tabs-2"><bean:message key="org.element.ext_property"/></a></li> 
	</ul>
	<div id="tabs-1" style="border:0px;padding:5px 0 0px 0;margin:0;width:350px;">
	<form id="userDetail" name="userDetail" class="jqueryui">
		<table align="left" border="0" cellpadding="0" cellspacing="0"
			width="100%">
			<tr>
				<td style="width:30%"><bean:message key="org.element.username"/>:
					<font color="#ff0000">*</font>
				</td>
				<td style="width:70%">
					<input type="text" id="txtUserName" name="txtUserName"/>
					<input type="hidden" id="hidUserID" />
				</td>
			</tr>
			<tr>
				<td ><bean:message key="user.element.userpassword"/>:
					<font id="pwdStar" color="#ff0000">*</div>
				</td>
				<td><input type="password" id="txtUserPassword" name="txtUserPassword"></td>
			</tr>
			<tr>
				<td><bean:message key="user.element.useraccount"/>:
					<font color="#ff0000">*</font>
				</td>
				<td><input type="text" id="txtUserAccount" name="txtUserAccount"></td>
			</tr>
			<tr>
				<td><bean:message key="user.element.userdesc"/>:</td>
				<td><input type="text" id="txtUserDesc" name="txtUserDesc"></td>
			</tr>
			<tr>
				<td><bean:message key="user.title.unit_and_stat"/>:</td>
				<td>
					<input type="text" id="txtUserUnitsStations" readOnly />
					<input class="jt_botton_table2" onClick="unitSelect()" type="button" id="btnSta" value="..." />
					<input type="hidden" id="txtUserUnitsStationsValue" />
				</td>
			</tr>
			<tr>
				<td><bean:message key="role.element.admin_role"/>:</td>
				<td>
					<input type="text" id="txtUserAdminRole" readOnly>
					<input class="jt_botton_table2" onClick="adminRoleSelect()" type="button" id="btnAdminRole" value="..." />
					<input type="hidden" id="txtUserAdminRoleValue">
				</td>
			</tr>
			<tr>
				<td><bean:message key="role.element.biz_role"/>:</td>
				<td>
					<input type="text" id="txtUserRoles" readOnly>
					<input class="jt_botton_table2" onClick="roleSelect()" type="button" id="btnRole" value="..." />
					<input type="hidden" id="txtUserRolesValue">
				</td>
			</tr>
		
		</table>
	</form>
	</div>
	<div id="tabs-2" style="padding:0px 0px 0px 0px;margin:0;height:150px;overflow:auto">	
	    <form id="detailForm" >
			<table id="dyItem">
			</table>
	    </form>
	</div>
</div>	
<!--  
<table cellpadding="0" cellspacing="3" width="350px">
<tr><td align="right">
<input id="btnSave" class="jt_button" type="button" value="提交"
	onclick="saveUser()" /> 
<input id="btnClose" class="jt_button"
	type="button" value="关闭" onClick="closeWin()" />
</td></tr>
</table>

<div class="demo">
	<div id="unitAndStaDialog" title="组织单元和岗位" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="unitAndStaFrame" src=""  height="100%" width="100%" ></iframe>
    </div>
    <div id="roleDialog" title="角色" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="roleFrame" src=""  height="100%" width="100%" ></iframe>
    </div>
</div>
-->
</body>
</html>