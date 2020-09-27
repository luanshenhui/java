<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<script type="text/javascript" src="../fabric/pricelistjsp.js"></script>
<script type="text/javascript" src="../fabric/pricejsp.js"></script>
<div id="fabric_price_result" class="list_search">
<h1><s:text name="FabricPriceSearch"></s:text></h1><br />
<input type="hidden" id="code" name="code" />
<a id="btnAdd"><s:text name="btnCreateFabric"></s:text></a>
<a id="btnRemove"><s:text name="btnRemoveFabric"></s:text></a>
<div id="FabricPriceResult"></div>
<div id="FabricPriceStatistic"></div>
<div id="FabricPricePagination" class="paging"></div>
<textarea  id="FabricPriceTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class='check'><input type="checkbox" onclick="$.csControl.checkAll('price_chkRow', this.checked);"/></td>
			<td class="lblCode"><s:text name="lbclCode"></s:text></td>
			<td class="blLblBusinessUnit"><s:text name="blLblBusinessUnit"></s:text></td>
			<td class="lblRMBPrice"><s:text name="lblRMBPrice"></s:text></td>
			<td class="lblDollarPrice"><s:text name="lblDollarPrice"></s:text></td>
			<td class="lblEdit"><s:text name="lblEdit"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td class="center check"><input type="checkbox" value="{$T.row.ID}" name="price_chkRow"/></td>
			<td>{$T.row.fabricCode}</td>
			<td>{$T.row.areaName}</td>
			<td>{$T.row.rmbPrice}</td>
			<td>{$T.row.dollarPrice}</td>
			<td class='center'>
				<span class="edit" onclick="$.csFabricPrice.openEdit('{$T.row.ID}')" style="cursor:pointer;"><s:text name="lblEdit"></s:text></span>
			</td>
		</tr>
		{#/for}
	</table>
</textarea>
</div>