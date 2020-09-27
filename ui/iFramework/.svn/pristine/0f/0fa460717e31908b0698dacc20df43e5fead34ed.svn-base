<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ page import="java.util.ArrayList"%>
<%@ page
	import="com.dhc.authorization.delegate.domain.WF_ORG_DELEGATE"%>
<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String language = CommonConsts.LANGUAGE;
    String currentUserId = "";
    try{
    	//取当前登录人的id
    	SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
    	currentUserId = securityUser.getUserBean().getId();
    } catch (Exception ex){}
%>

<html>
<head>
<meta http-equiv="expires" content="0">
<title><bean:message key="delegate.title.privilege_delegate"/></title>
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
	src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.ui.core.min.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.min.js"></script>
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
	//当前登录用户的用户id
	var currentUserId = "<%=currentUserId%>";
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside_msg_utf8_<%=language%>.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/prototype_mini.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside.js"></script>
<script type="text/javascript" 
	src="<%=webpath%>/view/authorization/delegate/DelegateList.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
</script>
</head>
<body>

<form name="queryForm" class="jqueryui">
<fieldset class="title1">
		<legend><bean:message key="commmon.fieldset.search"/></legend>
		<table align="left" border="0" cellpadding="0" cellspacing="3">
			<tr>
				<td style="width:11%"><bean:message key="delegate.element.dele_name"/></td>
				<td style="width:18%"><input type="text" name="txtDelegateName" style="width:100px" id="txtDelegateName"></td>
				<td style="width:10%"><bean:message key="delegate.element.truster"/></td>
				<td style="width:25%"><input type="text" name="selDelegateUser" style="width:100px" id="selDelegateUser">&nbsp;				
				   <input class="jt_botton_table2"  onclick="deleSelect()" type="button" value="..." />
			       <input type="hidden" name="hidDeleId" id="hidDeleId">			 
				</td>
				<td style="width:11%"><bean:message key="delegate.element.trustee"/></td>
				<td style="width:25%"><input type="text" name="selTrustorUser" style="width:100px" id="selTrustorUser">&nbsp;				
				   <input class=jt_botton_table2 onclick="trustorSelect()" type="button" value="..." />
			       <input type="hidden" name="hiddenTrustorId" id="hiddenTrustorId">			
			    </td>
			</tr>
		</table>
</fieldset>
<table class="jt_botton_table" width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="4" align="right">
		    <input id="btnQuery" type="button" value="<bean:message key="common.button.query"/>" onClick="javascript:doQuery('queryForm', 'ec')";>
			<input id="btnReset" type="button" value="<bean:message key="common.button.reset"/>" onClick="javascript:clearQueryCondition();">
		    <input id="btnAdd" type="button" value="<bean:message key="common.button.add"/>" onClick="add()" />
			<input id="btnUpdate" type="button" value="<bean:message key="common.button.edit"/>" onClick="update()" />
			<input id="btnDelete" type="button" value="<bean:message key="common.button.delete"/>" onClick="deleteDelegate('queryForm','ec')" />
		</td>
	</tr>
</table>
</form>
<fieldset class="title1"><legend><bean:message key="delegate.element.privilege_list"/></legend> 
<ec:table
	items="delegateList" var="record" retrieveRowsCallback="limit" style="table-layout:fixed"
	useAjax="true" minHeight="230" height="230" toolbarContent="navigation|pagejump|pagesize|extend|status"
	action="${pageContext.request.contextPath}/DelegateAction.do?method=getDelegate"
	xlsFileName="delegateList.xls" csvFileName="delegateList.csv" listWidth="100%"
	pageSizeList="5,10,20,50" rowsDisplayed="10">
	<ec:row>
	    <ec:column style="text-align:center;" width="5%" cell="checkbox"  headerCell="checkbox" alias="checkBoxID" 
       		value="${record.deleId}"  viewsAllowed="html" />
		<ec:column style="text-align:center" width="5%" property="_0" title="<%=OrgI18nConsts.TABLE_COLUMN_SEQUENCE%>"
			value="${GLOBALROWCOUNT}" />
		<ec:column style="display: none;" width="0%" headerStyle="display: none;" 
			property="deleId" title="委托名称ID" />
		<ec:column style="text-align:center;" width="15%" property="deleName" title="<%=OrgI18nConsts.DELEGATE_DELE_NAME%>" />
		<ec:column style="text-align:center;" width="10%" property="userName" title="<%=OrgI18nConsts.DELEGATE_TRUSTER%>" />
		<ec:column style="text-align:center;" width="10%" property="trustor_name" title="<%=OrgI18nConsts.DELEGATE_TRUSTEE%>" />
		<ec:column style="text-align:center;" width="10%" property="deleAllPrivil" title="<%=OrgI18nConsts.DELEGATE_ALL_PRIVILEGE%>" />
		<ec:column style="text-align:center;" width="15%" property="deleTimeBegin" title="<%=OrgI18nConsts.DELEGATE_TIME_START%>" />
		<ec:column style="text-align:center;" width="15%" property="deleTimeEnd" title="<%=OrgI18nConsts.DELEGATE_TIME_END%>" />
		<ec:column style="text-align:center;" width="15%" property="deleDescription" title="<%=OrgI18nConsts.DELEGATE_DESC%>" />
		<ec:column style="display: none;" width="0%" 
			property="userId" title="委托人主键" />
	</ec:row>
</ec:table>
</fieldset>
<!-- 
<div class="demo" style="display:none">
	<div id="delegateDetailDialog" title="<bean:message key="role.title.role_detail"/>" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="delegateDetailFrame" src="" style="width: 400px; height: 330px;"></iframe>
	</div>	
	<div id="userSelectDialog" title="<bean:message key="delegate.user"/>" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="userSelectFrame" src=""  style="width: 540px; height: 220px;"></iframe>
    </div> 	
    <div id="deleSelectDialog" title="人员" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="deleSelectFrame" src=""  style="width: 540px; height: 220px;"></iframe>
    </div>
    <div id="trustorSelectDialog" title="人员" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="trustorSelectFrame" src=""  style="width: 540px; height: 220px;"></iframe>
    </div>
</div> -->
</body>
</html>