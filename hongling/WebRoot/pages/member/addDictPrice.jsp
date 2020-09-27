<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type="text/javascript" src="../member/addDictPricejsp.js"></script>
<form id="form_dictPrice" class="form_template">
<h1></h1>
<table>
	<tr>
		<td class="label star lblFabricMember"><s:text name="lblFabricMember"></s:text></td>
		<td>
			<input type="text" id="username" name="username" readonly="readonly" />
		</td>
	</tr>
	<tr>
		<td class="label lblDictPrice_code star"><s:text name="lblDictPrice_code"></s:text></td>
		<td>
			<input type="text" id="addDictPrice_code" name="code"/>
		</td>
	</tr>
	<tr>
		<td class="label lblDictPrice_price star"><s:text name="lblDictPrice_price"></s:text></td>
		<td><input type="text" id="addDictPrice_price" name="price" /></td>
	</tr>
</table>
<div class="operation">
	<a id="btnDictPrice"><s:text name="Button_Submit"></s:text></a> 
	<a id="btnDictPriceCancel"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>