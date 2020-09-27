<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="../customerassesment/list.js">
</script>
<div>
	<div id="search" class="list_search">
		<h1>客户评价查询</h1>
		<s:label>用户名</s:label>
		<s:textfield id="searchKeyword" name="searchKeyword"></s:textfield>
		<s:label value="评价日期"></s:label>
		<input type="text" id="dealDate" class="date"/>
		<input type="text" id="dealToDate" class="date"/>
		<a href="javascript:void(0);" id="btnQuery">查询</a>
		<a href="javascript:void(0);" id="btnExportAssess">导出</a>
	</div>
	<div id="CustomerAssessmentResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="CustomerAssessmentStatistic" class="pagingleft"></div>
	<div id="CustomerAssessmentPagination" class="paging"></div>
	<textarea id="CustomerAssessmentTemplate" class="list_template">
		<table class="list_result">
		<tr class="header">
		<td rowspan='2'>用户名</td>
		<td rowspan='2'>评价总量</td>
		<td colspan='2'>好评</td>
		<td colspan='2'>差评</td>
		<td colspan='4'>差评原因统计</td>
		</tr>
		<tr class="header">
		<td>好评数</td>
		<td>好评率(%)</td>
		<td>差评数</td>
		<td>差评率(%)</td>
		<td>版型</td>
		<td>做工</td>
		<td>尺寸</td>
		<td>服务支持</td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td class="center">{$T.row[0]}</td>
			<td class="center">{$T.row[2]}</td>
			<td class="center">{$T.row[3]}</td>
			<td class="center">{$T.row[5]}</td>
			<td class="center">{$T.row[4]}</td>
			<td class="center">{$T.row[6]}</td>
			<td class="center">{$T.row[7]}</td>
			<td class="center">{$T.row[8]}</td>
			<td class="center">{$T.row[9]}</td>
			<td class="center">{$T.row[10]}</td>
		</tr>
		{#/for}
		</table>
	</textarea>
</div>
