<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/fabric/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/fabric/listjsp.js"></script>
<div id="FabricSearch" class="list_search">
	<h1><s:text name="FabricSearch"></s:text></h1>
	<s:label value="%{getText('lblFabric_Supply')}"></s:label>
	<select id="searchSupplyCategoryID" name="searchSupplyCategoryID" ></select>
	<s:label value="%{getText('lblCommon_Category')}"></s:label>
	<select id="searchCategoryID" name="searchCategoryID" ></select>
	<s:label value="%{getText('lblKeyword')}"></s:label><input type="text" id="keyword" style="width:80px;"/>
	<s:label value="%{getText('lblArriveDate')}"></s:label><input type="text" id="arriveDate"/><input type="text" id="arriveDateEnd"/>
	
	<select id="isValid" name="isValid" ></select>
	<a id="btnSearch"><s:text name="btnSearch"></s:text></a><br/>
	<a id="btnRemoveFabric"><s:text name="btnRemoveFabric"></s:text></a>
	<a id="btnCreateFabric"><s:text name="btnCreateFabric"></s:text></a>
	<a id="btnExportFabric"><s:text name="btnExportFabric"></s:text></a>
	<a id="btnOccupyView"><s:text name="btnOccupyView"></s:text></a>
</div>
<div id="FabricResult"></div>
<div id="FabricStatistic" class="pagingleft"></div>
<div id="FabricPagination" class="paging"></div>
<textarea  id="FabricTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="check"><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<!--<td class="lblFabricSupplyCategory"></td>-->
			<!--<td class="lblCategory"></td>-->
			<td class="lblCode"><s:text name="lbclCode"></s:text></td>
			<!--<td class="lblPrice"></td>-->
			<!--<td class="lblWeight"></td>-->
			<!--<td class="lblSeries"></td>-->
			<td class="lblFlower"><s:text name="lblFlower"></s:text></td>
			<td class="lblColor"><s:text name="lblColor"></s:text></td>
			<td class="lblComposition"><s:text name="lblComposition"></s:text></td>
			<td class="lblInventory"><s:text name="lblInventory"></s:text></td>
			<td class="lblShaZhi"><s:text name="lblShaZhi"></s:text></td>
			<td class="lblIsStop"><s:text name="lblIsStop"></s:text></td>
			<td class="lblIsStop"><s:text name="lblFabricPrice"></s:text></td>
			<td class="lblEdit"><s:text name="lblEdit"></s:text></td>
			<td class="lblOccupy"><s:text name="lblOccupy"></s:text></td>
			<td class="lblFabricPrice"><s:text name="lblFabricPrice"></s:text></td>
			<td class="lblDiscounts"><s:text name="lblDiscounts"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td class="center check"><input type="checkbox" value="{$T.row.ID}" name="chkRow"/></td>
			<!--<td class="center">{$T.row.fabricSupplyCategoryName}</td>-->
			<!--<td class="center">{$T.row.categoryName}</td>-->
			<td class="center">{$T.row.code}</td>
			<!--<td class="center">{$T.row.price}</td>-->
			<!--<td class="center">{$T.row.weight}</td>-->
			<!--<td class="center">{$T.row.seriesName}</td>-->
			<td class="center">{$T.row.flowerName}</td>
			<td class="center">{$T.row.colorName}</td>
			<td class="center">{$T.row.compositionName}</td>
			<td class="center">{$T.row.inventory}</td>
			<td class="center">{$T.row.shaZhi}</td>
			<td class="center {#if $T.row.isStop == DICT_NO}green{#/if}">{$T.row.isStopName}</td>
			<td align="left">{$T.row.fabricPrice}</td>
			<td class='center'><a class="edit" onclick="$.csFabricList.openPost('{$T.row.ID}')"><s:text name="lblEdit"></s:text></a></td>
			<td class='center'><a class="occupy" onclick="$.csFabricList.openOccupy('{$T.row.code}')"><s:text name="lblOccupy"></s:text></a></td>
			<td class='center lblFabricPrice'><a class="edit" onclick="$.csFabricList.openPrice('{$T.row.code}')"><s:text name="lblOperate"></s:text></a></td>
			<td class='center lblDiscounts'><a class="edit" onclick="$.csFabricList.openDiscount('{$T.row.code}')"><s:text name="lblOperate"></s:text></a></td>
		</tr>
		{#/for}
	</table>
</textarea>

<div id="FabricPieceResult"></div>
<div id="FabricPieceStatistic"></div>
<div id="FabricPiecePagination" class="paging"></div>
<textarea  id="FabricPieceTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="lblFabric_ename"><s:text name="lblFabric_ename"></s:text></td>
			<td class="lblFabric_ysddh"><s:text name="lblCode"></s:text></td>
			<td class="lblFabric_ecode"><s:text name="lbclCode"></s:text></td>
			<td class="lblFabric_mlwg"><s:text name="lblFabric_mlwg"></s:text></td>
			<td class="lblFabric_mdcd"><s:text name="lblFabric_mdcd"></s:text></td>
			<td class="lblFabric_mlcd"><s:text name="lblFabric_mlcd"></s:text></td>
			<td class="lblFabric_mlfk"><s:text name="lblFabric_mlfk"></s:text></td>
			<td class="lblFabric_hgf"><s:text name="lblFabric_hgf"></s:text></td>
			<td class="lblFabric_dhrq"><s:text name="lblFabric_dhrq"></s:text></td>
			<td class="lblFabric_Release"><s:text name="lblFabric_Release"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td>{$T.row.ename}</td>
			<td>{$T.row.ysddh}</td>
			<td>{$T.row.ecode}</td>
			<td>{$T.row.mlwg}</td>
			<td>{$T.row.mdcd}</td>
			<td>{$T.row.mlcd}</td>
			<td>{$T.row.mlfk}</td>
			<td>{$T.row.hgf}</td>
			<td class="center">{$T.row.dhrq}</td>
			<td class='center'>{#if $T.row.hgf == 2}<a class="lblFabric_Release" style='color:#f7ca8d;' onclick="$.csFabricList.releaseFabric('{$T.row.code}','{$T.row.ysddh}')"><s:text name="lblFabric_Release"></s:text></a>{#/if}</td>
		</tr>
		{#/for}
	</table>
</textarea>