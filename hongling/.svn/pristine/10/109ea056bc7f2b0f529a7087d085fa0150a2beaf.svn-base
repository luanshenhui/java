<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type= "text/javascript" src="../fabric/discountjsp.js"></script>
<script type="text/javascript" src="../../scripts/jquery/datepicker/WdatePicker.js"></script>
<form id="form_discount" class="form_template">
<input type="hidden" name="fabricCode" id="fabricCode"/>
<h1></h1>
<table>
	<tr>
		<td class="label lblCode"><s:text name="lbclCode"></s:text></td>
		<td id="discountCode"></td>
	</tr>
	<tr>
		<td class="label star lblFabricMember"><s:text name="lblFabricMember"></s:text></td>
		<td>
			<input type="text" id="memberName" name="memberName" />
			<input type="hidden" id="memberId" />
		</td>
	</tr>
	<tr>
		<td class="label lblFabricDiscountStartDate star"><s:text name="lblFabricDiscountStartDate"></s:text></td>
		<td>
			<input type="text" id="startDate" name="startDate" onClick="WdatePicker();" readonly="readonly" style="cursor:pointer"/>
		</td>
	</tr>
	<tr>
		<td class="label lblFabricDiscountEndDate star"><s:text name="lblFabricDiscountEndDate"></s:text></td>
		<td><input type="text" id="endDate" name="endDate" onClick="WdatePicker();" readonly="readonly" style="cursor:pointer;"/></td>
	</tr>
	<tr>
		<td class="label lblFabricDiscount star"><s:text name="lblFabricDiscount"></s:text></td>
		<td><input type="text" id="discount" name="discount" /><s:text name="blLblReTailMemo"/></td>
	</tr>
</table>
<div class="operation">
	<a id="btnDiscountFabric"><s:text name="Button_Submit"></s:text></a> 
	<a id="btnDiscountCancel"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>