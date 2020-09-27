<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../style_pcssuit/post.js"></script>
<form id="form" class="form_template">
<input type="hidden" id="ID"/>
<h1 id="kitStyleTitle"></h1>
<table>
	<tr>
		<td class="label star">组合代码</td>
		<td><input type="text" id="kitStyleNo"  class="textbox" style="width:180px;"/></td>
		<td class="label star">服装分类</td>
		<td><select id="category" style="width:180px;">
			<option value="0">--请选择--</option>
			<option value="1">套装(2pcs)</option>
			<option value="2">套装(3pcs)</option>
		</select></td>
	</tr>
	<tr>
		<td class="label star">默认面料</td>
		<td>
			<input type="text" id="defaultFabric"  class="textbox" readonly="readonly" style="width:150px;" /><input type="button" id="btnf" value="..." style="width:29px;">
		</td>
		<td class="label star">款式风格</td>
		<td>
			<select id="styleIDs"  style="width:180px;"></select>
		</td>
	</tr>
	<tr>
		<td class="label">适用面料</td>
		<td colspan="3">
			<input type="text" id="fabrics"  class="textbox"  style="width:450px;" /><input type="button" id="btnfs" value="..."  style="width:29px;">
		</td>
	</tr>
	<tr>
		<td class="label">中文标题</td>
		<td colspan="3"><input type="text" id="titleCn" style="width:450px;"  class="textbox" /></td>
	</tr>
	<tr>
		<td class="label">英文标题</td>
		<td colspan="3"><input type="text" id="titleEn" style="width:450px;"  class="textbox" /></td>
	</tr>
	<tr id="category_style"></tr>
	<tr id="category_style3"></tr>
</table>
<div class="operation">
	<a id="btnSave">提交</a> <a id="btnCancel" onclick="$.csCore.close();">取消</a>
</div>
<br/><br/>
</form>
