<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="../customerassesment/categoryperiodlist.js">
</script>
<div>
	<div id="search" class="list_search">
		<h1>客户评价查询</h1>
		<s:label>服装分类名称</s:label>
		<s:textfield id="searchKeyword" name="searchKeyword"></s:textfield>
		<s:label>查询时间点</s:label>
		<input type="text" id="dealDate" class="date"/>
		<%-- <s:label value="%{getText('lblDealDate')}"></s:label>
		<input type="text" id="dealDate" class="date"/>
		<input type="text" id="dealToDate" class="date"/> --%>
		<a href="javascript:void(0);" id="btnQuery">查询</a>
		<a href="javascript:void(0);" id="btnExportCategory">导出</a>
	</div>
	<div id="CustomerAssessmentResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="CustomerAssessmentStatistic" class="pagingleft"></div>
	<div id="CustomerAssessmentPagination" class="paging"></div>
	<textarea id="CustomerAssessmentTemplate" class="list_template">
		<table class="list_result">
		<tr class="header">
		<td>产品大类</td>
		<td>日差评量</td>
		<td>日差评率</td>
		<td>日好评量</td>
		<td>日好评率</td>
		<td>日发货量</td>
		<td>月差评量</td>
		<td>月差评率</td>
		<td>月好评量</td>
		<td>月好评率</td>
		<td>月发货量</td>
		<td>年差评量</td>
		<td>年差评率</td>
		<td>年好评量</td>
		<td>年好评率</td>
		<td>年发货量</td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td class="center">{$T.row[1]}</td>
			<td class="center">{$T.row[5]}</td>
			<td class="center">{$T.row[19]}%</td>
			<td class="center">{$T.row[4]}</td>
			<td class="center">{$T.row[18]}%</td>
			<td class="center">{$T.row[2]}</td>
			<td class="center">{$T.row[9]}</td>
			<td class="center">{$T.row[15]}%</td>
			<td class="center">{$T.row[8]}</td>
			<td class="center">{$T.row[14]}%</td>
			<td class="center">{$T.row[6]}</td>
			<td class="center">{$T.row[13]}</td>
			<td class="center">{$T.row[17]}%</td>
			<td class="center">{$T.row[12]}</td>
			<td class="center">{$T.row[16]}%</td>
			<td class="center">{$T.row[10]}</td>
		</tr>
		{#/for}
		</table>
	</textarea>
</div>
