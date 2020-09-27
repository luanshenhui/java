<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.organization.role.domain.WF_ORG_ROLE"%>
<%@ page import="com.dhc.organization.position.domain.WF_ORG_STATION"%>
<%@ page import="com.dhc.organization.unit.domain.WF_ORG_UNIT"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ page import="java.util.List"%>

<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,"deleId,opFlag"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    SecurityUser securityUser1 = SecurityUserHoder.getCurrentUser();
    if (securityUser1.getUserBean() == null) {
    	response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    String currentUserFullName = securityUser1.getUserBean().getFullName();
    String currentUserId = securityUser1.getUserBean().getId();
    List roleList = securityUser1.getUserBean().getRoleList();
    List unitList = securityUser1.getUserBean().getUnitList();
    List stationList = securityUser1.getUserBean().getStationList();
    String deleId = request.getParameter("deleId");
    String opFlag = request.getParameter("opFlag");
    String language = CommonConsts.LANGUAGE;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="delegate.detail.info"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css" 
    href="<%=webpath%>/view/base/theme/css/redmond/jquery.multiselect.css" />
<link rel="stylesheet" type="text/css" 
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.multiselect.style.css" />
<link rel="stylesheet" type="text/css" 
	href="<%=webpath%>/view/base/theme/css/redmond/jquery-ui.css" />
<script type="text/javascript"
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>  
<script type="text/javascript"
	src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>    
<script type="text/javascript"
	src="<%=webpath%>/view/base/ui/minified/jquery-ui-1.8.1.custom.min.js"></script>
<script type="text/javascript" 
    src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.multiselect.min.js"></script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var $jQuery = $;
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">   
	var opFlag = "<%=opFlag%>";
	var deleId = "<%=deleId%>";
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/authorization/delegate/DelegateDetail.js"></script>

<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquerytools/tooltip.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/localization/messages_<%=language%>.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.ext.js"></script>
	
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;" onLoad="init()">

<form id="detailForm" name="detailForm" class="jqueryui">
<table align="left" width="100%" style="padding:5px 0px 0px 0px;">
	<tr>
		<td width="30%"><bean:message key="delegate.element.dele_name"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td width="70%">
			<input type="text" id="txtDelegateName" name="txtDelegateName"
				style="width:230px"/>
			<input type="hidden" id="hidDelegateID"/>
		</td>
	</tr>
	<tr>
		<td><bean:message key="delegate.element.truster"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td><input type="text" id="txtDelegateUser" name="txtDelegateUser" disabled style="width:230px" value="<%=currentUserFullName%>" />
		    <input type="hidden" id="hidDelegateUserId"  value="<%=currentUserId%>"/>
		</td>
	</tr>
	<tr>
		<td ><bean:message key="delegate.element.trustee"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td >
			<input type="text" id="txtTrustor" name="txtTrustor" readOnly style="width:190px">
			<input type="button" class="jt_botton_table2" onclick="userSelect()" id="btnUser" value="..." />
			<input type="hidden" id="hidTrustorId">
		</td>
	</tr>
	<tr>
		<td><bean:message key="delegate.element.all_privilege"/>:</td>
		<td><select id="allPrivil" style="width:230px" onChange="selAllPrivil()">			
			<option value="0"><bean:message key="delegate.element.no"/></option>
			<option value="1"><bean:message key="delegate.element.yes"/></option>
		</select></td>
	</tr>
	<tr id="roleHidden">
		<td><bean:message key="delegate.element.select_roles"/>:</td>
		<td>
			<select id="selRole" title="Basic example" style="width:230px" name="example-basic" multiple="multiple" >
			<%
			if(roleList != null){
				for(int i=0;i<roleList.size();i++){
					WF_ORG_ROLE role = (WF_ORG_ROLE)roleList.get(i);
					String selRoleId=role.getRoleId();
					String selRoleName=role.getRoleName();
					//只能将业务角色委托给其它人，不能把管理角色委托给其它人
					if(role.getIsAdminrole() != null && role.getIsAdminrole().equalsIgnoreCase("否")) {
			%>
					<option value="<%=selRoleId%>"><%=selRoleName%></option>
			<%		}
				} 
			}%>
			</select>
		</td>
	</tr>
	<tr id="staHidden">
		<td><bean:message key="delegate.element.select_stats"/>:</td>
		<td>
			<select id="selSta" title="Basic example" style="width:230px" name="example-basic" multiple="multiple" >
			<%
			if (stationList != null){
				for(int i=0;i<stationList.size();i++){
					WF_ORG_STATION station = (WF_ORG_STATION)stationList.get(i);
					String selStaId=station.getStationId();
					String selStaValue=station.getStationName();
			%>
					<option value="<%=selStaId%>"><%=selStaValue%></option>
			<%  } 
			}%>
			</select>
		</td>
	</tr>
	<tr id="unitHidden">
		<td><bean:message key="delegate.element.select_units"/>:</td>
		<td>
			<select id="selUnit" title="Basic example" style="width:230px" name="example-basic" multiple="multiple" >
			<%
			if(unitList != null){
				for(int i=0;i<unitList.size();i++){
					WF_ORG_UNIT unit = (WF_ORG_UNIT)unitList.get(i);
					String selUnitId=unit.getUnitId();
					String selUnitName=unit.getUnitName();
			%>
					<option value="<%=selUnitId%>"><%=selUnitName%></option>
			<%  } 
			}%>
			</select>
		</td>
	</tr>
	<tr>
		<td><bean:message key="delegate.element.time_start"/>:</td>
		<td><input type="text" id="timeStart" name="timeStart" readOnly onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" class="Wdate" style="width:230px"/>
	</tr>
		<tr>
		<td><bean:message key="delegate.element.time_end"/>:</td>
		<td><input type="text" id="timeEnd" name="timeEnd" readOnly onFocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})" class="Wdate" style="width:230px"/>
	</tr>

	<tr>
		<td><bean:message key="delegate.element.desc"/>:</td>
		<td>
		<textarea id="description" name="description" rows="3" style="width:230px"></textarea>
		</td>
	</tr>
</table>
</form>
</body>
</html>