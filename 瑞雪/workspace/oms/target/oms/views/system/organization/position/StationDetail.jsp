<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page
	import="com.dhc.organization.user.domain.WF_ORG_USER"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,"sendunitId,sendflag,sendstaId,staUserId"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String sendunitId = request.getParameter("sendunitId");
    String sendflag = request.getParameter("sendflag");
    String sendstaId = request.getParameter("sendstaId");
    String staUserId = request.getParameter("staUserId");
    
    String language = CommonConsts.LANGUAGE;
    
	//request.setAttribute("userList",new ArrayList());	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="stat.title.stat_detail"/></title>
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
jQuery = $;
$jQuery = $;
</script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>

<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquerytools/tooltip.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/localization/messages_<%=language%>.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.ext.js"></script>

<script type="text/javascript"
	src="<%=webpath%>/view/organization/position/StationDetail.js"></script>
	
<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var sendunitId = "<%=sendunitId%>";
	var sendflag = "<%=sendflag%>";
	var sendstaId = "<%=sendstaId%>";
	var staUserId = "<%=staUserId%>";	
</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<div >
<form class="jqueryui" id="detailForm" name="detailForm">
<table style="padding:5px 0px 0px 0px;margin:0; border:0;">
	<tr>
		<td><bean:message key="stat.element.statname"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td><input type="text" id="staName" name="staName" /></td>
	</tr>
	<tr>
		<td><bean:message key="stat.element.statinfo"/>:</td>
		<td><input type="text" id="staDes" name="staDes" /></td>
	</tr>
	<tr>
		<td><bean:message key="role.element.max_users"/>:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td><input type="text" id="staNum" name="staNum"/></td>
	</tr>
	<tr>
		<td><bean:message key="role.element.include_users"/>:</td>
		<td><input type="text" id="staUser" readOnly/>&nbsp;&nbsp;<input 
		type="button" id="btnSelUser" class="jt_botton_table2" value="..." onclick="showStaUser()">
		<input type="hidden" id="staUserHidden" ></input>
		</td>
	</tr>
	<!-- 
	<tr>
	    <td colspan="2" align="right">
	        <input class="jt_button" type="button" value="提交" onclick="save()">
		    <input class="jt_button" type="button" value="关闭" onClick="window.close();">
	    </td>
	</tr>
	 -->
</table>
</form>
</div>
<!-- 
<div class="demo">
	 <div id="userDialog" title="用户选择">
		<iframe id="userFrame" src="" height="100%" width="100%"></iframe>
    </div>
</div>
-->
</body>
</html>