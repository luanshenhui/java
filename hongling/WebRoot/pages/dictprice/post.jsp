<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<script src="../dictprice/post.js"></script>

<form id="form" class="form_template">
<input type="hidden" name="id" id="id"/>
<h1></h1>
<table>
	<tr>
		<td class="label star lblTitle nowrap">工艺代码</td>
		<td><input type="text" id="code" class="textbox" maxlength="20"/></td>
		<td class="label star lblTitle nowrap">工艺描述</td>
		<td><input type="text" id="name" class="textbox" maxlength="100"/></td>
	</tr>
	<tr>
		<td class="label star lblTitle nowrap">人民币价格</td>
		<td><input type="text" id="rmbPrice" class="textbox" maxlength="8" onkeyup="$.csDictPricePost.onlyNumber(this)"/></td>
		<td class="label star lblTitle nowrap">美元价格</td>
		<td><input type="text" id="price" class="textbox" maxlength="8" onkeyup="$.csDictPricePost.onlyNumber(this)"/></td>
	</tr>
	<tr>
		<td class="label lblGroup nowrap">权限组</td>
		<td colspan="3" id="divGroup"></td>
	</tr>
	<tr>
		<td class="label star lblCategory">定价方式</td>
		<td>
			<select id="pricetype">
				<option value="36019">工艺收费加盟商(BATE)</option>
				<option value="20142">国内加盟商</option>
				<option value="20143">国外加盟商</option>			
			</select>
		</td>
		<td class="label star lblCategory">是否手工</td>
		<td>
			<select id="ismanual">
				<option value="">机器收费</option>
				<option value="10050">全手工免费</option>
				<option value="10051">半手工机器类收费</option>
			</select>
		</td>
	</tr>
</table>
<div class="operation">
	<a id="btnSaveInformation"><s:text name="btnSubmitOrden"></s:text></a> <a id="btnCancelInformation"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>