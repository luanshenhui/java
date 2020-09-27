<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type="text/javascript" src="../style_pcssuit/assemble_list.js">
</script>
<input type="hidden" id="value" name="value">
<div id="SearchPcssuitAssemble" class="list_search">
	<h1>款式组合设计</h1>
	<s:label value="组合代码" id="searchCode" name="searchCode"></s:label>
	<input type="text" id=searchCode style="width:70px;" />
	<s:label value="款式风格" id="style" name="style"></s:label>
	<select id="searchStyleID" style="width:70px;"></select>
	<a id="btnsearch">查询</a>
	<a id="btnsumbit">提交</a>	
</div>
<div id="AssembleResult"></div>
<div id="AssembleStatistic"></div>
<div id="AssemblePagination" class="paging"></div>
<textarea id="AssembleTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td>&nbsp;</td>
			<td>编码</td>
			<td>款式风格</td>
			<td>类似品牌</td>
			<td>默认面料</td>
			<td>使用面料</td>
			<td>中文</td>
			<td>英文</td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.id}">
			<td class="center"><input type="checkbox" value="{$T.row.code}"  onclick="$.csPcssuitAssemble.checkOnce(this);" name="chkRow"/></td>
			<td class="center">{$T.row.code}</td>
			<td class="center">{$T.row.dict.name}</td>
			<td class="center">{$T.row.brands}</td>
			<td class="center">{$T.row.defaultFabric}</td>
			<td class="center">{$T.row.fabrics}</td>
			<td class="center">{$T.row.titleCn}</td>
			<td class="center">{$T.row.titleEn}</td>
		</tr>
		{#/for}
	</table>
</textarea>
