<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="org.element.unit"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp"%>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/dhtmlxtree/css/dhtmlxtree.css" />
<script type="text/javascript"
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>
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
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jsplit/jsplit.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/utils/Arraylist.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_Dollar.js"></script>
<script type="text/javascript" src="StationSelect.js"></script>     
<script type="text/javascript">
var webpath = "<%=webpath%>";
</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">  
  <div style="padding:0px 0 0px 0px;background:#ffffff; width:500px;border:0px;height:200px">
  <table>
  <tr>
  <td>
    <div id="splitter" style="border:1px solid #ccc;background:#ffffff;width:300px;height:200px;"> 
        <table style="width:100%;cellspacing:0;cellpadding:0;border:0;height:100%;">
	        <tr>
		        <td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">
		        <font style="padding:5px 0 0px 0;margin:0; font-size:16px;">
				       <bean:message key="org.element.unit"/>
				</font>
				</td>
			</tr>
			<tr>
				<td style="height:150px;overflow:auto;">
				<div id="orgTree" style="height:100%;width:100%margin:0;"></div>
			    </td>
		    </tr>
	    </table>
	</div>
  </td>
  <td>
	<div style="border:1px solid #ccc;background:#ffffff;height:200px;width:198px;"> 
	    <table style="width:100%;cellspacing:0;cellpadding:0;border:0;height:100%;">
	        <tr>
		        <td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">
		        <font style="padding:5px 0 0px 0;margin:0; font-size:16px;">
				       <bean:message key="org.element.station"/>
				</font>
				</td>
			</tr>
			<tr>
				<td style="height:150px;overflow:auto;">
				<div id="staTree" style="height:100%;width:100%margin:0;"></div>
				</td>
			</tr>
		</table>
	</div> 
	 </td>
  </tr>
  </table>
  <div id="foo" style=""></div>
	<!-- 
	<table width="100%" cellspacing=0 cellpadding=0 border=0 style="margin:5px;">
    <tr>
	    <td colspan="2" align="right">
			<input type="button" class="jt_button" value="确定" onclick="save()">
			<input type="button" class="jt_button" value="关闭" onclick="window.close();">
        </td>
	</tr>
    </table>
     -->
</div>
</body>
</html>