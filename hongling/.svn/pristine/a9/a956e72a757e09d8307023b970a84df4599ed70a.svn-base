<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../fabricwareroom/list.js">
</script>
<div>
	<div id="search" class="list_search">
		<h1>面料库存管理</h1>
		<s:label>面料编码</s:label>
		<s:textfield name="searchFabricNo" id="searchFabricNo" style="width:100px;"></s:textfield>
		<s:label>面料分类</s:label>
		<select id="searchCategory"></select>
		<s:label>面料属性</s:label>
		<select name="searchProperty" id="searchProperty" style="width:100px;"></select>
		<s:label>面料品牌</s:label>
		<select id="searchBrands"></select>
		<a href="javascript:void(0);" id="btnquery">查询</a>
		<a href="javascript:void(0);" id="btnadd">新增</a>
	</div>
	<div class="list_search" style="padding-right:25px;text-align: right;">
		<s:label>面料单位</s:label>
		<select id="belong"></select>
		<s:label>是否在线</s:label>
		<select id="status">
		</select>
		<s:textfield id="exchange" name="exchange" style="width:50px;"  readonly="true"/>
		<s:label>人民币对美元汇率</s:label>
		<s:textfield id="uachange" name="uachange" style="width:50px;"  readonly="true"/>
		<s:label>美元对人民币汇率</s:label>
		<a href="javascript:void(0);" id="changeRate" >修改</a>
		<!--  <a href="javascript:void(0);" id="puton" >下架</a> -->
		<a href="javascript:void(0);" id="upload" >导入库存</a>
		<a href="javascript:void(0);" id="btndelete">删除</a>
		<a href="javascript:void(0);" id="exportOn" >导出</a>
	</div>
	<div id="FabricWareroomResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="FabricWareroomStatistic" class="pagingleft"></div>
	<div id="FabricWareroomPagination" class="paging"></div>
	<textarea id="FabricWareroomTemplate" class="list_template">
		<table class="list_result">
			<tr class="header">
			<td><input type="checkbox" id="moreSelect" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td>编码</td>
			<td>分类</td>
			<td>颜色</td>	
			<td>属性</td>
			<td>RMB</td>
			<td>美元</td>
			<td>库存</td>	
			<td>品牌</td>
			<td>单位</td>
			<td>操作</td>
			</tr>
			{#foreach $T.data as row}
			<tr id="row{$T.row.id}">
			<td class="center"><input type="checkbox" value="{$T.row.id}" name="chkRow"/></td>
			<td class="center"><a onclick="$.csFabricWareroomList.openV('{$T.row.id}')">{$T.row.fabricNo}</a></td>
			<td class="center">{$T.row.categoryName}</td>
			<td class="center">{$T.row.colorName}</td>
			<td class="center">{$T.row.dict.name}</td>
			<td class="center">{$T.row.rmb}</td>
			<td class="center">{$T.row.dollar}</td>
			<td class="center">{$T.row.stock}</td>
			<td class="center">{$T.row.fabricTrader.traderName}</td>
			<td class="center">{$T.row.belong}</td>
			<td class="center"><a href="javascript:void(0);" class="edit" onclick="$.csFabricWareroomList.openView('{$T.row.id}')">编辑</a></td>
			</tr>
			{#/for}
		</table>
	</textarea>
</div>
