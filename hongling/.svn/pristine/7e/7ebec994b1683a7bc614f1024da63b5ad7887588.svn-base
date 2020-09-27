<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<script type="text/javascript" src="../fabric/discountlistjsp.js"></script>
<div id="fabric_discount_result" class="list_search">
<h1><s:text name="FabricDiscountSearch"></s:text></h1><br />
<s:label value="%{getText('lblFabricDiscountDate')}"></s:label>
<input type="text" id="startDate" class="date"/>
<input type="text" id="endDate" class="date"/>
<a id="btnSearchFabricDiscount"><s:text name="btnSearch"></s:text></a>
<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
<a id="btnAdd"><s:text name="btnCreateFabric"></s:text></a>
</s:if>
<div id="FabricDiscountResult"></div>
<div id="FabricDiscountStatistic"></div>
<div id="FabricDiscountPagination" class="paging"></div>
<textarea  id="FabricDiscountTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="lblCode"><s:text name="lbclCode"></s:text></td>
			<td class="lblFabricDiscountStartDate"><s:text name="lblFabricDiscountStartDate"></s:text></td>
			<td class="lblFabricDiscountEndDate"><s:text name="lblFabricDiscountEndDate"></s:text></td>
			<td class="lblFabricDiscount"><s:text name="lblFabricDiscount"></s:text></td>
			<td class="lblOperate"><s:text name="lblDo"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td class="center link" onclick="$.csFabricDiscountList.openView('{$T.row.ID}')">{$T.row.fabricCode}</td>
			<td>{$.csDate.formatMillisecondDate($T.row.startDate)}</td>
			<td>{$.csDate.formatMillisecondDate($T.row.endDate)}</td>
			<td>{$T.row.discount}</td>
			<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
			<td class='center'>
			{#if $T.row.startDate > new Date()}
				<span class="edit" onclick="$.csFabricDiscountList.deleteDiscount('{$T.row.ID}', '{$T.row.fabricCode}')" style="cursor:pointer;"><s:text name="btnRemoveFabric"></s:text></span>
			{#/if}
			</td>
			</s:if>
			<s:else>
			<td class='center'></td>
			</s:else>
		</tr>
		{#/for}
	</table>
</textarea>
</div>