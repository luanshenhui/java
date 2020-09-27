<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/message/postjsp.js"></script>
<form id="form" class="form_template">
<input type="hidden" name="ID" id="ID"/>
<h1></h1>
<table>
	<tr>
		<td class="label lblReceiver"><s:text name="lblReceiver"></s:text></td>
		<td>
			<input type="text" readonly="readonly" id="receiverTexts" class="pick textbox"/>
			<input type="hidden" id="receiverID"/>
		</td>
	</tr>
	<tr>
		<td class="label lblTitle"><s:text name="lblTitle"></s:text></td>
		<td><input type="text" id="title" name="title" class="textbox"/></td>
	</tr>
	<tr>
		<td class="label lblContent"><s:text name="lblContent"></s:text></td>
		<td colspan="3"><textarea id="content" name="content" class="editor"></textarea></td>
	</tr>
</table>
<div class="operation">
	<a id="btnSubmit"><s:text name="Button_Submit"></s:text></a> <a id="btnCancel"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>