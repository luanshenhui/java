<%@ page contentType="text/html; charset=UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,"isAdminRole"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
	//bizAuthority（业务授权，即授权可使用）,mngAuthority（管理授权，即授权可分配）
	String isAdminRole = request.getParameter("isAdminRole");
	isAdminRole = isAdminRole == null || isAdminRole.equals("") ? "" : isAdminRole;
	
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
<title><bean:message key="role.title.role_mngt"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/dhtmlxtree/css/dhtmlxtree.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath %>/view/base/theme/css/redmond/msdropdown/css/dd.css" />
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
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jsplit/jsplit.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxcommon.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxtree.js"></script>
<script type="text/javascript"
	src="<%=webpath %>/view/base/plugin/msdropdown/jquery.dd.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/Arraylist.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_Dollar.js"></script>
<script type="text/javascript"
	src="<%=webpath %>/view/authorization/privilege/PrivilegeMain.js"></script>

<style>
	#splitter{background:#efefef;width:100%;height:400px;top:0; left:0px!important; left:3px; border:1px solid #ccc;}
</style>

<script language="javascript">
	var webpath = "<%=webpath%>";
	var isAdminRole = "<%=isAdminRole%>";
	//记录展开菜单树结点前结点出的记录数
	var beforeOpenSubNodes = -1;
	//左侧列表中选择的当前“类型”
	currSelType = null;
	//左侧列表中选择的当前“ID”
	currSelID = null;
</script>
</head>
<body>
<div style="padding:10px 0 0px 6px;background:#fff; width:800px; height:400px;border:0px">
	<table>
		<tr>
			<td>
				<!-- 下面是左侧角色、岗位选择区域 -->
				<div id="splitter" style="border:1px solid #ccc;background:#ffffff;width:250px;height:400px;overflow:hidden;">
					<table style="width:100%;" cellspacing=0 cellpadding=0 border="0">
						<tr>
							<td height="25px"  style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">
							<font style="padding:5px 0 0px 0;margin:0; font-size:13px;">
								<bean:message key="bg.element.role_stat"/>:</font>
							</td>
						</tr>
						<tr>
							<td>
							<div id="tabs" style="height:96%;width:96%;border:0px;font-size:13px;overflow:hidden;">
								<ul>
									<li><a href="#tabs-1"><bean:message key="bg.element.role"/></a></li>
									<%if (isAdminRole.equals("")) { %>
									<li><a href="#tabs-2"><bean:message key="bg.element.station"/></a></li> 
									<%} %>
								</ul>
								<div id="tabs-1" style="border:0px;padding:0px 0 0px 0;margin:0;width:100%;height:100%;">
									<select name="listbox" id="listbox" size="15" onclick="roleSelect('listbox')" 
										style="display:none;border:0px;padding:0px 0 0px 0;margin:0;width:100%;height:100%;">
						            </select>
								</div>
								<div id="tabs-2" style="padding:5px 5px 5px 5px;margin:0;">
									<%if (isAdminRole.equals("")) { %>
									<div id="orgTree" style="height:96%;width:96%;overflow:auto;"></div>
									<%} %>
								</div>
							</div>	
							</td>
						</tr>
					</table>
				</div>
			</td>
			<td>
				<!-- 下面是右侧选择树区域 -->
				<div style="border:1px solid #ccc; border-left:2;height:400px; width:500px">
				<form class="jqueryui">
					<table style="font-size: 12px; width:100%" cellspacing=0 cellpadding=0 border="0">
						<tr height="25px">
							<td  style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">
								<font style="padding:5px 0 0px 0;margin:0; font-size:13px;">
								<bean:message key="bg.element.useable_menu"/>:</font>
							</td>
							<td align="right"  style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">
							    <input class="jt_botton_table2" type="button" id="btnClean" value="<bean:message key="bg.button.empty_sub_nodes"/>" onClick="cleanSubnode()">
								<input class="jt_botton_table2" type="button" id="btnExpand" value="<bean:message key="bg.button.expend_all"/>" onClick="expandAll()">
								<input class="jt_botton_table2" type="button" id="btnClose" value="<bean:message key="bg.button.collaspane_all"/>" onClick="closeAll()">
								<input class="jt_botton_table2" type="button" id="btnSave" value="<bean:message key="common.button.save"/>" onclick="savePrivileges()">
							</td>
						</tr>
						<tr height="100%" valign="top" >
							<td height="100%" colspan="2" width="100%">
								<div id="menuTree" style="height:370px;overflow:auto;"></div>
							</td>
						</tr>
					</table>
				</form>
				</div>
			</td>
		</tr>
	</table>
</div>		
</body>
</html>