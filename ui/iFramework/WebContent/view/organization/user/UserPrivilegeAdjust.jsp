<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,"senduserID,senduserFullName"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String userID = request.getParameter("senduserID");
    String userFullName = request.getParameter("senduserFullName");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户权限调整</title>
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
	src="<%=webpath%>/view/base/plugin/page.set.js"></script>
<script type="text/javascript"
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxcommon.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxtree.js"></script>
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
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_Dollar.js"></script>
<script type="text/javascript" src="UserPrivilegeAdjust.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/Arraylist.js"></script> 
<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var userID = "<%=userID%>";
	var userFullName = "<%=userFullName%>";
	//存放菜单树上选中的结点
	debugger
	var addList = new ArrayList();
	//存放菜单树上移除的结点
	var delList = new ArrayList();
</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">  
    <table width="380px" height="290px">
	    <tr>
		    <td>
		       <!--  
		    	<fieldset class="title3" style="word-break: keep-all"><legend id="userName"></legend>-->
				<div id="menuTree" style="border:0px;padding:0px 0 0px 0;margin:0;width:100%;height:100%;"></div>
			</td>
		</tr>
		<!-- 
	    <tr>
		    <td align="right">
				<input type="button" class="jt_button" value="确定" onclick="save()">
				<input type="button" class="jt_button" value="关闭" onclick="window.close();">
		    </td>
	    </tr>
	     -->
	</table>
</body>
</html>