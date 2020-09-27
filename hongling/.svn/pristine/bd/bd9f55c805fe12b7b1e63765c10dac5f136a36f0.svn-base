<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript"
	src="../fabricInfoReport/fabricpricereport.js">
</script>
<div>
	<div id="search" class="list_search">
		<h1>零售面料报表信息查询</h1>
		<s:label>面料code</s:label>
		<s:textfield id="searchKeyword" name="searchKeyword"></s:textfield>
		<s:label value="查询时间点"></s:label>
		<input type="text" id="dealDate" class="date" /> 
		<a href="javascript:void(0);" id="btnQuery">查询</a>
		<a id="btnExportFabricPrice" ><s:text name="导出"></s:text></a>
	</div>
	<div id="FabricPriceReportResult"></div>
	<div id="overdue" style="display: none;"></div>
	<div id="FabricPriceReportStatistic" class="pagingleft"></div>
	<div id="FabricPriceReportPagination" class="paging"></div>
	<textarea id="FabricPriceReportTemplate" class="list_template">
		<table class="list_result">
		<tr class="header">
		<td>面料code</td>
		<td>品牌</td>
		<td>面料成分</td>
		<td>面料颜色</td>
		<td>人民币价格</td>
		<td>美元价格</td>
		<td>月度使用米数</td>
		<td>年度使用米数</td>
		</tr>
        {#foreach $T.data as row}
		<tr>
			<td class="center">{$T.row[1]}</td>
			<td class="center">{$T.row[2]}</td>
			<td class="center">{$T.row[6]}</td>
			<td class="center">{$T.row[5]}</td>
			<td class="center">￥ {$T.row[3]}</td>
			<td class="center">$ {$T.row[4]}</td>
			<td class="center">{$T.row[7]}</td>
			<td class="center">{$T.row[8]}</td>
		</tr>
		{#/for}
		</table>
	</textarea>
</div>
