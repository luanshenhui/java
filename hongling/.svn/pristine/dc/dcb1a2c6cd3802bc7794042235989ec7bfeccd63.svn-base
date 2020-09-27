<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../style_pcssuit/fabric_list.js"></script>
<div>
	<div id="search" class="list_search">
		<h1>面料库存查询</h1>
		<label>编码</label>
		<s:textfield name="searchFabricNo" id="searchFabricNo" style="width:100px;"></s:textfield>
		
		<label>品牌</label>
		<select id="searchBrands"></select>
		<a id="btnquery"  onclick="$.csPcssuitFabric.query();">查询</a>
		<a id="btnsubmit" onclick="$.csPcssuitFabric.submitFabric();">提交</a>
	</div>
	<div id="FabricWareroomResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="FabricWareroomStatistic" class="pagingleft"></div>
	<div id="FabricWareroomPagination" class="paging"></div>
	<textarea id="FabricWareroomTemplate" class="list_template">
		<table class="list_result">
			<tr class="header">
			<td><input type="checkbox" id="moreSelect" onclick="$.csPcssuitFabric.checkAll('chRow', this.checked);"/></td>
			<td>编码</td>
			<td>分类</td>
			
			<td>颜色</td>


			<td>属性</td>


			<td>库存</td>


			<td>品牌</td>
			<td>单位</td>
			</tr>
			{#foreach $T.data as row}
			<tr id="">
			<td class="center"><input type="checkbox" value="{$T.row.fabricNo}"  onclick="$.csPcssuitFabric.checkOnce(this);" name="chRow"/></td>
			<td class="center">{$T.row.fabricNo}</td>
			<td class="center">{$T.row.categoryName}</td>
			
			<td class="center">{$T.row.colorName}</td>
			
			<td class="center">{$T.row.property}</td>
			
			
			<td class="center">{$T.row.stock}</td>
			
			
			<td class="center">{$T.row.fabricTrader.traderName}</td>
			<td class="center">{$T.row.belong}</td>
			</tr>
			{#/for}
		</table>
	</textarea>
</div>
