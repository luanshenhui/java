<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath()%>/pages/blexpresscom/common.js"></script>
<script src="<%=request.getContextPath()%>/pages/bldelivery/BlDeliveryFjsp.js"></script>
<script src="<%=request.getContextPath()%>/pages/bldelivery/settingjsp.js"></script>
<form id="formSetting" class="form_template">
<input type="hidden" name="ordenSettingID" id="ordenSettingID"/>
<h1><s:text name="formSetting"></s:text></h1>
<table>

	<tr>
		<td class="label star lblApplyDeliveryType"><s:text name="lblApplyDeliveryType"></s:text></td>
		<td id="applyDeliveryTypeIDContainer"></td>
	</tr>
	<tr>
		<td  class="label star lblExpressCom"><s:text name="lblDeliveryExpressCom"></s:text></td>
		<td><select id="expressComId" class="expressComId2" style="width: 155px"></select></td>
	</tr>
	<tr class="auto">
		<td class="label star lblApplyDeliveryDays"><s:text name="lblApplyDeliveryDays"></s:text></td>
		<td id="applyDeliveryDaysContainer"></td>
	</tr>
	<tr>
<!-- 		<td class="label star lblApplyDeliveryAddress"></td>
		<td><input id="applyDeliveryAddress" name="applyDeliveryAddress" type="text" class="textbox"/></td> -->
		<td class="label star lblApplyDeliveryCountry"><s:text name="lblDeliveryCountry"></s:text></td>
		<td>
			<input id="countryName" name="countryName" type="text"/>
			<input type="hidden" id="countryCode" name="countryCode" />
		</td>
	</tr>
	<tr class="state">
		<td class="label star lblApplyDeliveryDivision"><s:text name="lblDeliveryState"></s:text></td>
		<td>
			<input id="division" name="division" type="text">
			<input type="hidden" id="divisionCode" name="divisionCode">
		</td>
	</tr>
	<tr>
		<td class="label star lblApplyDeliveryCity"><s:text name="lblDeliveryCity"></s:text></td>
		<td><input id="city" name="city" type="text"/></td>
	</tr>
	<tr>
		<td class="label star lblApplyAddressLine1"><s:text name="lblDeliveryAddress1"></s:text></td>
		<td><input id="addressLine1" name="addressLine1" type="text"/></td>
	</tr>
	<tr>
		<td class="label lblApplyAddressLine2"><s:text name="lblDeliveryAddress2"></s:text></td>
		<td><input id="addressLine2" name="addressLine2" type="text"/></td>
	</tr>
	<tr>
		<td class="label star lblApplyPostalCode"><s:text name="lblDeliveryPostalCode"></s:text></td>
		<td>
			<!-- <input id="postalCode" name="postalCode" type="text" onclick="$.csDeliverySetting.getPostalCodes();" readonly="readonly"/> -->
			<input id="postalCode" name="postalCode" type="text" />
		</td>
	</tr>
	
</table>
<div class="operation">
	<a id="btnSubmitSetting"><s:text name="btnSubmitOrden"></s:text></a> <a id="btnCancelSetting"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>