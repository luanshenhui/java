<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<link rel="stylesheet" href="../../scripts/jquery/zTreeStyle/zTreeStyle.css" type="text/css"></link>
<script language= "javascript" src="../member/menusjsp.js"></script>
<form id="form">
<div id="GroupMenuSearch" class="list_search">
	<h1></h1>
</div>
<div id="memberName"></div>
<div ><ul id="menus" class="ztree"><s:text name="menus"></s:text></ul></div>

<div class="form_template">
<div class="operation">
	<a id="btnSaveMemberMenus"><s:text name="btnSubmitOrden"></s:text></a>
</div>
</div>
</form>