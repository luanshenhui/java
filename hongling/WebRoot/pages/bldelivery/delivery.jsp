<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath()%>/pages/blexpresscom/common.js"></script>
<script src="<%=request.getContextPath()%>/pages/bldelivery/commonjsp.js"></script>
<script src="<%=request.getContextPath()%>/pages/bldelivery/deliveryjsp.js"></script>
<form id="delivery_form" class="form_template">
	<h1><s:text name="delivery_form"></s:text></h1>
	<table style="width:98%">
		<tr>					  
			<td class="label star lblDeliveryDate"><s:text name="lblDeliveryDate"></s:text></td>
			<td><input type="text" id="deliveryDate" name="deliveryDate" class="textbox" style="width:180px;"/></td>
<!-- 			<td class="label lblDeliveryAddress star"></td>
			<td><input type="text" id="deliveryAddress" name="deliveryAddress" class="textbox" style="width:200px;"/></td> -->
			<td class="label star lblDeliveryExpressCom"><s:text name="lblDeliveryExpressCom"></s:text></td>
			<td><select id="expressComId" class="expressComId2" style="width: 150px;"></select></td>
			
		</tr>
		<tr>
		<td class="label star lblDeliveryCountry"><s:text name="lblDeliveryCountry"></s:text></td>
			<td>
				<input type="text" id="countryName" name="countryName" class="textbox" />
				<input type="hidden" id="countryCode" name="countryCode" />
			</td>
			<td class="label star lblDeliveryState state"><s:text name="lblDeliveryState"></s:text></td>
			<td class="state">
				<input type="text" id="division" name="division" class="textbox" />
				<input type="hidden" id="divisionCode" name="divisionCode" />
			</td>
			
		</tr>
		<tr>
			<td class="label star lblDeliveryCity"><s:text name="lblDeliveryCity"></s:text></td>
			<td>
				<input type="text" id="city" name="city" class="textbox" />
				<input type="hidden" id="cityCode" name="cityCode" />
			</td>
		    <td class="label star lblDeliveryDistrict"><s:text name="lblDeliveryDistrict"></s:text></td>
			<td>
				<input type="text" id="district" name="district" class="textbox" />
				<input type="hidden" id="districtCode" name="districtCode" />
			</td>
			
		</tr>
		<tr>
<%-- 			<td class="label lblDeliveryAddress2"><s:text name="lblDeliveryAddress2"></s:text></td> --%>
<!-- 			<td><input type="text" id="addressLine2" name="addressLine2" class="textbox" /></td> -->
		    <td class="label star lblDeliveryAddress1"><s:text name="lblDeliveryAddress1"></s:text></td>
			<td><input type="text" id="addressLine1" name="addressLine1" class="textbox" /></td>
		    <td class="label star lblDeliveryPostalCode"><s:text name="lblDeliveryPostalCode"></s:text></td>
			<td><input type="text" id="postalCode" name="postalCode" class="textbox" /></td>
		</tr>
	</table>
	<div id="DeliveryDetailsResult"></div>
	<div class="operation">
		<a id="btnSaveDelivery"><s:text name="btnSubmitOrden"></s:text></a> <a id="btnCancelDelivery"><s:text name="btnCancelOrden"></s:text></a>
	</div>
</form>
<textarea  id="DeliveryDetailsTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class='check' style="vertical-align:middle;"><input type="checkbox" onclick="$.csControl.checkAll('chkDeliveryOrden', this.checked);"/></td>
			<td class="lblCode"><s:text name="lblCode"></s:text></td>
			<td class="lblClothingCategory"><s:text name="lblClothingCategory"></s:text></td>
			<td class="lblName"><s:text name="Name"></s:text></td>
			<td class="lblTel"><s:text name="lblTel"></s:text></td>
			<td class="lblFabric"><s:text name="lblFabric"></s:text></td>
			<td class="lblState"><s:text name="lblStatus"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ordenID}">
			<td class="center" style="vertical-align:middle;"><input type="checkbox" value="{$T.row.ordenID}" name="chkDeliveryOrden"/></td>
			<td>{$T.row.ordenID}</td>
			<td>{$T.row.clothingName}</td>
			<td>{$T.row.customer.name}</td>
			<td>{$T.row.customer.tel}</td>
			<td>{$T.row.fabricCode}</td>
			<td>{$T.row.statusName}</td>
		</tr>
		{#/for}
	</table>
</textarea >