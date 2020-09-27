<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page
	import="com.dhc.organization.user.domain.WF_ORG_USER"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,"sendunitId,sendflag"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	String sendunitId = request.getParameter("sendunitId");
	String sendflag = request.getParameter("sendflag");
	
	String language = CommonConsts.LANGUAGE;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="org.btn.add_unit"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ecside/css/ecside_style.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/msdropdown/css/dd.css" />
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
	src="<%=webpath%>/view/base/plugin/msdropdown/uncompressed.jquery.dd.js"></script>
<script type="text/javascript">
var jQuery = $;
var $jQuery = $;
</script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var flagType= "<%=sendflag%>";
	var unitId="<%=sendunitId%>";
</script>

<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquerytools/tooltip.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/localization/messages_<%=language%>.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.ext.js"></script>

<script type="text/javascript" 
    src="<%=webpath%>/view/base/ecside/prototype_mini.js"></script>
<script type="text/javascript" 
    src="<%=webpath%>/view/base/ecside/ecside_msg_utf8_<%=language%>.js"></script>
<script type="text/javascript" 
    src="<%=webpath%>/view/base/ecside/ecside.js"></script>

<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" 
    src="<%=webpath%>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/organization/unit/UnitDetail.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/extinfo/extinfo.js"></script>

</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<div id="tabs" style="width:99%;font-size:12px" >
	<ul >
		<li><a href="#tabs-1"><bean:message key="org.element.basic_property"/></a></li>
		<li><a href="#tabs-2"><bean:message key="org.element.ext_property"/></a></li> 
	</ul>
	<div id="tabs-1" style="padding:0px 0 0px 0;margin:0;width:100%;height:133px;">
	<form id="unitDetail" name="unitDetail" >
		<table>
			<tr>
				<td><bean:message key="org.element.unit_name"/>:
					&nbsp;<font color="#ff0000">*</font>
				</td>
				<td><input type="text" id="orgName" name="orgName" style="width:230px"/></td>
			</tr>
			<tr>
				<td><bean:message key="org.elements.desc"/>:</td>
				<td><input type="text" id="orgDes" name="orgDes" style="width:230px"/></td>
			</tr>
			<tr>
				<td><bean:message key="org.element.leader_station"/>:</td>
				<td>
				<input type="text" id="orgSta" readOnly style="width:230px"/>
				</td>
				<td>
				<form  class="jqueryui">
				<input 
				type="button" id="btnSelSta" class="jt_botton_table2"  value="..." onclick="showSta()"/>
				</form>
				<input type="hidden" id="stationIdHidden"></input>
				</td>
			</tr>
			<tr>
				<td><bean:message key="org.element.unit_type"/>:</td>
				<td><select id="orgType" style="width:230px"></select></td>
			</tr>
		</table>
	</form>
	</div>
	<div id="tabs-2" style="padding:0px 0px 0px 0px;margin:0;width:100%;height:133px;overflow:auto;">
		<form id="detailForm" name="detailForm">
			<table id="dyItem">
			</table>
	    </form>
	</div>	

</div>
<table style="border:0px solid;padding:0px 0px 0px 0px;margin:0">
	<tr>
		<td><bean:message key="org.element.org_unit"/>:&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>
			<form name="queryForm"><input type="text" id="org" readOnly style="width:230px" />
			</form>
		</td>
		<td>
			<form  class="jqueryui">
				<input type="button" id="btnSelOrg" class="jt_botton_table2" value="..." onclick="showOrg()"/>
				<input type="button" class="jt_botton_table2"  value="<bean:message key="org.btn.in_unit"/>"  onclick="moveLeftToRight()" />
				<input type="button" class="jt_botton_table2"  value="<bean:message key="org.btn.out_unit"/>" onclick="outPut()" />
			</form>
	    </td>
	</tr>
</table>

<table width="99%">
	<tr>
		<td>
		<fieldset style="width: 312px; height: 246px; border: 2px solid #98b8d1;">
		<legend><bean:message key="org.element.userlist"/></legend> 
		<ec:table tableId="table1"
			items="userList" var="record" retrieveRowsCallback="limit" useAjax="true"
			action="${pageContext.request.contextPath}/UserAction.do?method=getUser"
			width="100%" toolbarContent="navigation|status" height="150"
			listWidth="100%"  minHeight="150" pageSizeList="5,10,20,50" >
			<ec:row>
			    <ec:column style="text-align:center;" width="60" cell="checkbox"  headerCell="checkbox" alias="checkId" 
			        value="${record.userId}"  viewsAllowed="html" /> 
				<ec:column width="125" style="text-align:center" property="userAccount" title="<%=OrgI18nConsts.UNIT_USERACCOUNT%>" />
				<ec:column width="125" style="text-align:center" property="userFullname" title="<%=OrgI18nConsts.UNIT_USERNAME%>" />			
			</ec:row>
		</ec:table>
		</fieldset>
		</td>
		<td align="right">
		<fieldset style="width: 320px; height: 246px; border: 2px solid #98b8d1;">
		<legend><bean:message key="org.element.selected_users"/></legend> 
		<ec:table tableId="table2"
			items="userDetailList" var="record2" retrieveRowsCallback="process" 
			action="${pageContext.request.contextPath}/UnitAction.do?method=getUserDetail"
			width="100%" toolbarContent="none" listWidth="100%" minHeight="150" height="150">
			<ec:row>
			    <ec:column style="text-align:center;" width="53" cell="checkbox"  headerCell="checkbox" alias="checkId2" 
			        value="${record2.userId}"  viewsAllowed="html" /> 
				<ec:column width="165" style="text-align:center" property="userAccount" title="<%=OrgI18nConsts.UNIT_USERACCOUNT%>" />
				<ec:column width="96" style="text-align:center" property="userFullname" title="<%=OrgI18nConsts.UNIT_USERNAME%>" />			
			</ec:row>
		</ec:table>
		</fieldset>
		</td>
	</tr>
</table>
</body>
</html>