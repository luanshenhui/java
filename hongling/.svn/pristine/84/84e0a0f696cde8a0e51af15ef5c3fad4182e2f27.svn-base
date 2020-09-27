<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/bldelivery/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/bldelivery/BlDeliveryFjsp.js"></script>
<div id="BlDeliveryFSearch" class="list_search">
	<h1><s:text name="blDelivery"></s:text></h1>
	<div class="search_left">
		<s:label value="%{getText('lblClothingCategory')}"></s:label>
		<select id="blSearchClothingID"></select>
		<s:label value="%{getText('lblStatus')}"></s:label>
		<select id="blSearchStatusID"></select>
		<s:label value="%{getText('Name')}"></s:label>
		<select id="blSearchClientID"></select>
		<s:label value="%{getText('lblKeyword')}"></s:label>
		<input type="text" id="blKeyword" style="width:50px;">
		<br/>
		<a id="blBtnDelivery"><s:text name="blBtnDelivery"></s:text></a>
		<a id="blBtnDeliverySetting"><s:text name="blBtnDeliverySetting"></s:text></a>
		<a id="blBtnDeliveryDetail"><s:text name="blBtnDeliveryDetail"></s:text></a>
		<a id="blBtnExportOrdens"><s:text name="btnExportOrdens"></s:text></a>
	</div>
	<div class="search_right">
		<s:label value="%{getText('lblPubDate')}"></s:label>
		<input type="text" id="blFromDate" class="date"/>
		<input type="text" id="blToDate" class="date"/>
		<br/>
		<s:label value="%{getText('lblDealDate')}"></s:label>
		<input type="text" id="blDealDate" class="date"/>
		<input type="text" id="blDealToDate" class="date"/>
		<a id="blBtnSearch"><s:text name="btnSearch"></s:text></a>
	</div>
</div>
<div id="BlDeliveryFResult"></div>
<div id="BlDeliveryFStatistic" class="pagingleft"></div>
<div id="BlDeliveryFPagination" class="paging"></div>
<textarea  id="BlDeliveryFTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td></td>
			<td class="blLblNumber"><s:text name="lblNumber"></s:text></td>
			<td class="blLblCode"><s:text name="lblCode"></s:text></td>
			<td class="blLblClothingCategory"><s:text name="lblClothingCategory"></s:text></td>
			<td class="blLblName"><s:text name="Name"></s:text></td>
			<td class="blLblFabric"><s:text name="lblFabric"></s:text></td>
			<td class="blLblPubDate"><s:text name="lblPubDate"></s:text></td>
			<td class="blLblDeliveryDate"><s:text name="lblDeliveryDate"></s:text></td>
			<td class="blLblDealDate"><s:text name="lblDealDate"></s:text></td>
			<td class="blLblDeliveryStatus"><s:text name="lblDeliveryStatus"></s:text></td>
			<td class="blLblStatus"><s:text name="lblStatus"></s:text></td>
			<td class="blLblStopCause"><s:text name="lblStopCause"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ordenID}">
			<td class="center"><input type="checkbox" value="{$T.row.ordenID}" onclick="$.csControl.checkOnce(this);" name="chkRow"/></td>
			<td class="center">{$T.row.number}</td>
			<td class="link" onclick="$.csBlDeliveryFList.openView('{$T.row.ordenID}')">{$T.row.ordenID}</td>
			<td>{$T.row.clothingName}</td>
			<td>{$T.row.customer.name}</td>
			<td>{$T.row.fabricCode}</td>
			<td class="center {#if $T.row.isPubOverdue == DICT_YES}red{#/if}">{$.csDate.formatMillisecondDate($T.row.pubDate)}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.deliveryDate)}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.jhrq)}</td>
			<td class="center">{$T.row.deliveryStatusName}</td>
			<td class="center">{$T.row.statusName}</td>
			<td>{$T.row.stopCauseName}</td>
		</tr>
		{#/for}
	</table>
</textarea>
