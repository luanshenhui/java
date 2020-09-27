<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<script type="text/javascript" src="../member/fabricConsumejsp.js"></script>
<div id="fabric_consume_result" class="list_search">
<h1><s:text name="lblPriceYardage"></s:text></h1><br />
<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
<a id="btnAdd"><s:text name="btnCreateFabric"></s:text></a>
</s:if>
<div id="FabricConsumeResult"></div>
<div id="FabricConsumeStatistic"></div>
<div id="FabricConsumePagination" class="paging"></div>
<textarea  id="FabricConsumeTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td><s:text name="lblName"></s:text></td>
			<td><s:text name="lblCommon_Category"></s:text></td>
			<td><s:text name="lblPriceYardage"></s:text></td>
			<td class="lblOperate"><s:text name="lblDo"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td>{$T.row.username}</td>
			<td>{$T.row.sort}</td>
			<td>{$T.row.fabricsize}</td>
			<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
			<td class="lblOperate"><span class="edit" onclick="$.csFabricConsume.deleteFabricConsume('{$T.row.id}','{$T.row.username}')" style="cursor:pointer;"><s:text name="btnRemoveFabric"></s:text></span></td>
			</s:if>
			<s:else>
			<td class="lblOperate"></td>
			</s:else>
		</tr>
		{#/for}
	</table>
</textarea>
</div>