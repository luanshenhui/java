<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="stat.title.stat_mngt"/></title>
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
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jsplit/jsplit.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/Arraylist.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript" src="StationMain.js"></script>     
<script type="text/javascript">
var webpath = "<%=webpath%>";
</script>
</head>
<body>  
	<div style="float:left;width:1800px; height:400px;">
		<div id="splitter" style="float:left;border:1px solid #ccc;background:#ffffff;width:250px;height:400px;overflow:none;">
			<table style="width:100%;height:400px;cellspacing:0; cellpadding:0; border:0">
			    <tr>
				    <td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);"> 
				    	<bean:message key="org.element.unit"/>
				    </td>
				</tr>
				<tr>
				    <td>      
						<div id="unitTree" style="height:400px;width:100%;overflow:auto;"></div>
					</td>
				</tr>
			</table>
		</div>
		<div style="float:left;border:1px solid #ccc; width:500px; border-left:0;height:400px;">
			<form  class="jqueryui">
				<table style="cellspacing:0; cellpadding:0; border:0; width:500px; height:400px;">
				      <tr style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">	
						<td id="stationTitle" width="200px" height="25px"> 
					    </td>
					    <td align="right" width="400px">
					        <input type="button" id="btnAdd" class="jt_botton_table2" value="<bean:message key="common.button.add"/>" onclick="addSta()">
							<input type="button" id="btnUpdate" class="jt_botton_table2" value="<bean:message key="common.button.edit"/>" onclick="updateSta()">
							<input type="button" id="btnDel" class="jt_botton_table2" value="<bean:message key="common.button.delete"/>" onclick="delSta()">
					    </td>
					  <tr>
					    <td colspan="2">  
						<div id="staTree" style="height:400px"></div>
						</td>
					</tr>    
				</table>
			</form>
		</div>
	</div>
	<div class="demo" style="display: none">
	 <div id="unitDialog" title="<bean:message key="stat.title.stat_detail"/>" style="padding:0px 0px 0px 0px;margin:0; border:0;">
		<iframe id="unitFrame" src="" height="170px" width="350px"></iframe>
    </div>
    <div id="userDialog" title="<bean:message key="stat.title.user_select"/>">
		<iframe id="userFrame" src="" height="210px" width="630px"></iframe>
    </div>
    </div>

</body>
</html>