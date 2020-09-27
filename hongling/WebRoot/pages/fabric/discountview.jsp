<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../fabric/discountviewjsp.js"></script>
<div id="view_fabricdiscount" class="form_template">
	<h1><s:text name="view_fabricDiscount"></s:text></h1>
	<table>
		<tr>
			<td class="label"><s:text name="lbclCode"></s:text></td>
			<td id="_view_fabricCode"></td>
			<td class="label"><s:text name="lblFabricDiscount"></s:text></td>
			<td id="_view_discount"></td>
		</tr>
		<tr>
			<td class="label"><s:text name="lblFabricDiscountStartDate"></s:text></td>
			<td id="_view_startDate"></td>
			<td class="label"><s:text name="lblFabricDiscountEndDate"></s:text></td>
			<td id="_view_endDate"></td>
		</tr>
		<tr>
			<td class="label"><s:text name="lblFabricMember"></s:text></td>
			<td id="_view_users"></td>
		</tr>
	</table>
</div>