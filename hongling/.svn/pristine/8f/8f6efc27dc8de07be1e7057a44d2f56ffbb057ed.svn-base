<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<script type="text/javascript" src="../member/dictPricejsp.js"></script>
<div id="dict_price_result" class="list_search">
<h1><s:text name="DictPrice"></s:text></h1><br />
<s:label value="%{getText('lblKeyword')}"></s:label>
<input type="text" id="code" class="code"/>
<a id="btnSearchDictPrice"><s:text name="btnSearch"></s:text></a>
<a id="btnAdd"><s:text name="btnCreateFabric"></s:text></a>
<div id="DictPriceResult"></div>
<div id="DictPriceStatistic"></div>
<div id="DictPricePagination" class="paging"></div>
<textarea  id="DictPriceTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td ><s:text name="lblDictPrice_code"></s:text></td>
			<td><s:text name="lblDictPrice_price"></s:text></td>
			<td class="lblOperate"><s:text name="lblDo"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="dict_{$T.row.id}">
			<td>{$T.row.code}</td>
			<td>{$T.row.price}</td>
			<td class="lblOperate"><span class="edit" onclick="$.csDictPrice.deleteDictPrice('{$T.row.id}')" style="cursor:pointer;"><s:text name="btnRemoveFabric"></s:text></span></td>
		</tr>
		{#/for}
	</table>
</textarea>
</div>