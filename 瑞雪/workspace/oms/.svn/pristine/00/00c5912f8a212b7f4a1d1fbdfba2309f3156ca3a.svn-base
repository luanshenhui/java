<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");

	boolean hasAdminRole = false;
	String language = CommonConsts.LANGUAGE;
	
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
<title><bean:message key="stat.title.stat_mngt"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/dhtmlxtree/css/MenuSkins/dhtmlxmenu_dhx_blue.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/dhtmlxtree/css/dhtmlxtree.css" />
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxcommon.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxtree.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/dhtmlxtree/dhtmlxmenu.js"></script>
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
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_jQuery.js"></script>
<script type="text/javascript" src="MenuMain.js"></script>

<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var jQuery = $;
	var $jQuery = $;
</script>

<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquerytools/tooltip.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/localization/messages_<%=language%>.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/base/plugin/validate/jquery.validate.ext.js"></script>

</head>
<body>  
<div style="padding:10px 0 0px 6px;background:#fff;height:400px; width:600px;border:0px">
	<table>
		<tr>
			<td>
			    <div id="splitter" style="border:1px solid #ccc;background:#ffffff;width:250px;overflow:auto;">
			    <table style="width:100%;" cellspacing=0 cellpadding=0 border="0">
			        <tr>
			           <td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);">
							<font style="padding:5px 0 0px 0;margin:0; font-size:13px;">
								<bean:message key="menu.element.func_menu"/>
							</font>
					  </td>
			        </tr>
			        <tr>
			           <td>
			               <div id="menuTree" style="height:370px;overflow:auto;"></div>
			           </td>
			        </tr>
			    </table>		
				</div>	
			</td>
			<td>
				<div id="form" style="border:1px solid #ccc; border-left:0;height:395px;width:500px">
				   <form name="menuDetail" id="menuDetail">
				      <table style="font-size: 12px; width:100%" cellspacing=0 cellpadding=0 border="0">
				         <tr>
							<td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);"
							 colspan="2">
								<font style="padding:5px 0 0px 0;margin:0; font-size:13px;">
									<bean:message key="menu.element.menu_detail_info"/>
								</font>
							</td>
						 </tr>
						 </table>
						 <table style="font-size: 12px;cellspacing:0;cellpadding:0; border:0">
				         <tr>
				            <td><bean:message key="menu.element.name"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="menuName" name="menuName" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td ><bean:message key="menu.element.img_path"/>:</td>
				            <td>
				               <input type="text" id="menuImg" name="menuImg" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td ><bean:message key="menu.element.desc"/>:</td>
				            <td>
				               <input type="text" id="menuDes" name="menuDes" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr>
				            <td><bean:message key="menu.element.url"/>:</td>
				            <td>
				               <input type="text" id="menuLocal" name="menuLocal" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr style="display: none">
				            <td><bean:message key="menu.element.target_area"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="menuArea" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr>
				            <td><bean:message key="menu.element.default_display"/>:</td>
				            <td>
				               <select id="menuDis" style="width:200px">
				                 <option value ="0" selected><bean:message key="role.element.no"/></option>
				                 <option value ="1"><bean:message key="role.element.yes"/></option>
				               </select> 
				            </td>
				         </tr>	 
				         <tr>
						   <td colspan="2" align="right" >
						       <input class="jt_botton_table2" type="button" id="btn_menuReset" value="<bean:message key="common.button.reset"/>" onClick="menuDetail.reset();">
					           <input class="jt_botton_table2" type="button" id="btn_menuSave" value="<bean:message key="common.button.save"/>" onclick="saveMenu()"> 
					        </td>
						</tr>
				      </table>
				   </form>
				   <form name="elementDetail" id="elementDetail" class="jqueryui">
				      <table style="font-size: 12px; width:100%;" cellspacing=0 cellpadding=0 border="0">
				      <tr>
							<td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);" colspan="2">
								<font style="padding:5px 0 0px 0;margin:0; font-size:13px;">
									<bean:message key="menu.element.element_detail_info"/>
								</font>
							</td>
						 </tr>
					</table>
					<table style="font-size: 12px; cellspacing:0; cellpadding:0; border:0">
				         <tr>
				            <td><bean:message key="menu.element.element_id"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="eleId" name="eleId" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td><bean:message key="menu.element.element_name"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="eleName" name="eleName" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td><bean:message key="menu.element.img_path"/>:</td>
				            <td>
				               <input type="text" id="eleImg" name="eleImg" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td><bean:message key="menu.element.element_type"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <select id="eleType" type="eleType" style="width:200px"></select>
				            </td>
				         </tr>	
				         <tr>
				            <td><bean:message key="menu.element.desc"/>:</td>
				            <td>
				               <input type="text" id="eleDes" name="eleDes" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr>
						   <td colspan="2" align="right">
						       <input class="jt_botton_table2" type="button" id="btn_eleReset" value="<bean:message key="common.button.reset"/>" onClick="elementDetail.reset()">
					           <input class="jt_botton_table2" type="button" id="btn_eleSave" value="<bean:message key="common.button.save"/>" onclick="saveEle()">   
					        </td>
						</tr>         				         				         			         
				      </table>
				   </form>
				    <form name="pageDetail" id="pageDetail" class="jqueryui">
				      <table style="font-size: 12px; width:100%" cellspacing=0 cellpadding=0 border="0">
				         <tr>
							<td height="25px" style="background-image:url(<%=webpath%>/view/base/theme/css/redmond/ecside/images/headerBg.gif);"
							 colspan="2">
								<font style="padding:5px 0 0px 0;margin:0; font-size:13px;">
									<bean:message key="menu.element.page_detail"/>
								</font>
							</td>
						 </tr>
						 </table>
						 <table style="font-size: 12px;cellspacing:0; cellpadding:0; border:0;">
				         <tr>
				            <td><bean:message key="menu.element.page_id"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="pageId" name="pageId" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td><bean:message key="menu.element.page_name"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="pageName" name="pageName" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td ><bean:message key="menu.element.img_path"/>:</td>
				            <td>
				               <input type="text" id="pageImg" name="pageImg" style="width:200px"/>
				            </td>
				         </tr>
				         <tr>
				            <td ><bean:message key="menu.element.desc"/>:</td>
				            <td>
				               <input type="text" id="pageDes" name="pageDes" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr>
				            <td><bean:message key="menu.element.url"/>:</td>
				            <td>
				               <input type="text" id="pageLocal" name="pageLocal" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr style="display: none">
				            <td><bean:message key="menu.element.target_area"/>:
				            	&nbsp;<font color="#ff0000">*</font>
				            </td>
				            <td>
				               <input type="text" id="pageArea" style="width:200px"/>
				            </td>
				         </tr>	
				         <tr>
				            <td><bean:message key="menu.element.default_display"/>:</td>
				            <td>
				               <select id="pageDis" style="width:200px">
				                 <option value ="0" selected><bean:message key="role.element.no"/></option>
				                 <option value ="1"><bean:message key="role.element.yes"/></option>
				               </select> 
				            </td>
				         </tr>	 
				         <tr>
						   <td colspan="2" align="right" >
						       <input class="jt_botton_table2" type="button" id="btn_pageReset" value="<bean:message key="common.button.reset"/>" onClick="pageDetail.reset();">
					           <input class="jt_botton_table2" type="button" id="btn_pageSave" value="<bean:message key="common.button.save"/>" onclick="savePage()"> 
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