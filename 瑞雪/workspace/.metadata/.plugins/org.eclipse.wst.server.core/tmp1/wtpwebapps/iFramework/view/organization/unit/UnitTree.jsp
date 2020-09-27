<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
	String language = CommonConsts.LANGUAGE;
%>
<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<html>
<head>
<meta http-equiv="expires" content="0">
<title><bean:message key="org.title.unit_mngt"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/dhtmlxtree/css/dhtmlxtree.css" />
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxcommon.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxtree.js"></script>

<script type="text/javascript"
	src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.ui.core.min.js"></script>
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
</script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside_msg_utf8_<%=language%>.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/prototype_mini.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/utils/Arraylist.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript" src="UnitTree.js"></script>
<!-- script type="text/javascript" 
	src="<%=webpath%>/view/base/common/ElementPrivilegeUtil.js"></script -->
</head>
<body>
<table>
	<tr>
		<td>
		<form><input id="btnAdd" name="btnAdd" type="button" class="jt_botton_table2"
			value="<bean:message key="org.btn.add_unit"/>" onclick="addOrg()" /> <input
			id="btnUpdate" type="button" value="<bean:message key="org.btn.edit_unit"/>"
			onclick="updateOrg()" class="jt_botton_table2"/> <input id="btnDel" type="button"
			value="<bean:message key="org.btn.del_unit"/>"  class="jt_botton_table2" onclick="delOrg()" />
			</form>
		</td>
	</tr>
</table>
<div id="orgTree" style="height:94%;width:100%;"></div>
<!-- div id="unitDetailDialog" title="<bean:message key="org.elements.desc"/>"
	><iframe
	id="unitDetailFrame" src="" style="width: 100%; height: 100%;"></iframe>
</div>
<div id="staDialog" title="<bean:message key="org.element.leader_station"/>"
	style="padding: 0px 0px 0px 0px; margin: 0; border: 0;"><iframe
	id="staFrame" src="" height="100%" width="100%"></iframe></div>
<div id="unitDialog" title="<bean:message key="org.elements.desc"/>"
	style="padding: 0px 0px 0px 0px; margin: 0; border: 0;"><iframe
	id="unitFrame" src="" height="100%" width="100%"></iframe></div>
</div -->
</body>
</html>