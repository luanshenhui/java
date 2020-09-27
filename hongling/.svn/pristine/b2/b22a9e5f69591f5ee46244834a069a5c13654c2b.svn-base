<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="../fabric/pricejsp.js"></script>
<form id="form_price" class="form_template">
<input type="hidden" name="fabricCode" id="fabricCode"/>
<input type="hidden" name="ID" id="ID" />
<h1></h1>
<table>
	<tr>
		<td class="label lblCode"><s:text name="lbclCode"></s:text></td>
		<td id="priceCode"></td>
	</tr>
	<tr>
		<td class="label star lblAreaId"><s:text name="blLblBusinessUnit"></s:text></td>
		<td>
			<select id="areaId" style="width: 240px"></select>
			<label id="areaName"></label>
			<input type="hidden" id="oriAreaId"/>
		</td>
	</tr>
	<tr>
		<td class="label lblRMBPrice star"><s:text name="lblRMBPrice"></s:text></td>
		<td><input type="text" id="rmbPrice" name="rmbPrice" /> (RMB)</td>
	</tr>
		<tr>
		<td class="label lblDollarPrice star"><s:text name="lblDollarPrice"></s:text></td>
		<td><input type="text" id="dollarPrice" name="dollarPrice" /> ($)</td>
	</tr>
</table>
<div class="operation">
	<a id="btnPriceFabric"><s:text name="Button_Submit"></s:text></a> 
	<a id="btnPriceCancel"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>