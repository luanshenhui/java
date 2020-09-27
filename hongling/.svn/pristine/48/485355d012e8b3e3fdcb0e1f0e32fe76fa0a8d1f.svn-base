<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<link href='../../scripts/jquery/swfupload/css/default.css' rel='stylesheet' type='text/css' />
<link href='../../scripts/jquery/xheditor/style.css' type='text/css' rel='stylesheet' />
<script type="text/javascript" src="../../scripts/jquery/swfupload/swfupload.js"></script>
<script type="text/javascript" src="../../scripts/jquery/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="../../scripts/jquery/swfupload/fileprogress.js"></script>
<script type="text/javascript" src="../../scripts/jquery/swfupload/handlers.js"></script>

<script src="../information/post.js"></script>

<form id="form" class="form_template">
<input type="hidden" name="ID" id="ID"/>
<h1></h1>
<table>
	<tr>
		<td class="label star lblTitle nowrap"><s:text name="lblTitle"></s:text></td>
		<td><input type="text" id="title" class="textbox"/></td>
		<td class="label star lblCategory"><s:text name="Category"></s:text></td>
		<td><select id="categoryID"></select></td>
	</tr>
	<tr>
		<td class="label star lblContent"><s:text name="lblContent"></s:text></td>
		<td colspan="3"><textarea id="content" class="editor"></textarea></td>
	</tr>
	<tr>
		<td class="label lblGroup nowrap"><s:text name="lblGroup"></s:text></td>
		<td colspan="3" id="divGroup"></td>
	</tr>
	<tr>
		<td class="label lblAttachment"><s:text name="lblAttachment"></s:text></td>
		<td colspan="3">
			<span id="spanButtonPlaceholder1"></span>
			<div class="fieldset flash" id="fsUploadProgress1"></div>
			<input type="hidden" id="attachmentIDs" name="attachmentIDs"/>
		</td>
	</tr>
</table>
<div class="operation">
	<a id="btnSaveInformation"><s:text name="btnSubmitOrden"></s:text></a> <a id="btnCancelInformation"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>