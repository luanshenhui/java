<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/fabric/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/fabric/listjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>
<div id="FabricSearch">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="FabricSearch"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
		<s:label value="%{getText('lblFabric_Supply')}"></s:label>:
		<select id="searchSupplyCategoryID" name="searchSupplyCategoryID" ></select> &nbsp;
		<s:label value="%{getText('lblCommon_Category')}"></s:label>:
		<select id="searchCategoryID" name="searchCategoryID" ></select> &nbsp;
		<s:label value="%{getText('lblKeyword')}"></s:label>:<input type="text" id="keyword" style="width:80px;"/> &nbsp;
		<s:label value="%{getText('lblArriveDate')}"></s:label>:<input type="text" id="arriveDate"/><input type="text" id="arriveDateEnd"/> &nbsp;
		<select id="isValid" name="isValid" ></select> &nbsp;
		<a id="btnSearch" style="float: right;"><s:text name="btnSearch"></s:text></a><br/>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
		<a id="btnRemoveFabric"><s:text name="btnRemoveFabric"></s:text></a>
		<a id="btnCreateFabric"><s:text name="btnCreateFabric"></s:text></a>
		<a id="btnExportFabric"><s:text name="btnExportFabric"></s:text></a>　　
		<a id="btnOccupyView"><s:text name="btnOccupyView"></s:text></a>
	</div>
</div>
<div id="FabricResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="FabricStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="FabricPagination" class="paging"></div>
<textarea  id="FabricTemplate" class="list_template">
	<table style="width: 100%;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></th>
			<th class="lblCode"><s:text name="lbclCode"></s:text></th>
			<th class="lblFlower"><s:text name="lblFlower"></s:text></th>
			<th class="lblColor"><s:text name="lblColor"></s:text></th>
			<th class="lblComposition"><s:text name="lblComposition"></s:text></th>
			<th class="lblInventory"><s:text name="lblInventory"></s:text></th>
			<th class="lblShaZhi"><s:text name="lblShaZhi"></s:text></th>
			<th class="lblIsStop"><s:text name="lblIsStop"></s:text></th>
			<th><s:text name="lblFabricPrice"></s:text></th><!-- 面料价格 -->
			<th class="lblEdit"><s:text name="lblEdit"></s:text></th>
			<th class="lblOccupy"><s:text name="lblOccupy"></s:text></th>
			<th class="lblFabricPrice"><s:text name="lblFabricPrice"></s:text></th>
			<th class="lblDiscounts"><s:text name="lblDiscounts"></s:text></th>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td style="border-left: 1px solid #c69b6e;"><input type="checkbox" value="{$T.row.ID}" name="chkRow"/></td>
			<td class="center">{$T.row.code}</td>
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

<div id="FabricPieceResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="FabricPieceStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="FabricPiecePagination" class="paging"></div>
<textarea  id="FabricPieceTemplate" class="list_template">
	<table class="list_result">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th class="lblFabric_ename"><s:text name="lblFabric_ename"></s:text></th>
			<th class="lblFabric_ysddh"><s:text name="lblCode"></s:text></th>
			<th class="lblFabric_ecode"><s:text name="lbclCode"></s:text></th>
			<th class="lblFabric_mlwg"><s:text name="lblFabric_mlwg"></s:text></th>
			<th class="lblFabric_mdcd"><s:text name="lblFabric_mdcd"></s:text></th>
			<th class="lblFabric_mlcd"><s:text name="lblFabric_mlcd"></s:text></th>
			<th class="lblFabric_mlfk"><s:text name="lblFabric_mlfk"></s:text></th>
			<th class="lblFabric_hgf"><s:text name="lblFabric_hgf"></s:text></th>
			<th class="lblFabric_dhrq"><s:text name="lblFabric_dhrq"></s:text></th>
			<th class="lblFabric_Release"><s:text name="lblFabric_Release"></s:text></th>
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