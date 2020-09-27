<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/bldelivery/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/bldelivery/BlDeliveryFjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>

<div id="BlDeliveryFSearch">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="blDelivery"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
		<s:label value="%{getText('lblClothingCategory')}"></s:label>:
		<select id="blSearchClothingID"></select> &nbsp;
		<s:label value="%{getText('lblStatus')}"></s:label>:
		<select id="blSearchStatusID"></select> &nbsp;
		<s:label value="%{getText('Name')}"></s:label>:
		<select id="blSearchClientID"></select> &nbsp;
		<s:label value="%{getText('lblKeyword')}"></s:label>:
		<input type="text" id="blKeyword" style="width:50px;"> &nbsp;
		<s:label value="%{getText('lblPubDate')}"></s:label>:
		<input type="text" id="blFromDate" class="date"/>
		<input type="text" id="blToDate" class="date"/> &nbsp;
		<s:label value="%{getText('lblDealDate')}"></s:label>:
		<input type="text" id="blDealDate" class="date"/>
		<input type="text" id="blDealToDate" class="date"/> &nbsp;
		<a id="blBtnSearch" style="float: right;"><s:text name="btnSearch"></s:text></a>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
		<a id="blBtnDelivery"><s:text name="blBtnDelivery"></s:text></a>　　
		<a id="blBtnDeliverySetting"><s:text name="blBtnDeliverySetting"></s:text></a>　　
		<a id="blBtnDeliveryDetail"><s:text name="blBtnDeliveryDetail"></s:text></a>　　
		<a id="blBtnExportOrdens"><s:text name="btnExportOrdens"></s:text></a>
	</div>
</div>
<div id="BlDeliveryFResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="BlDeliveryFStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="BlDeliveryFPagination" class="paging"></div>
<textarea  id="BlDeliveryFTemplate" class="list_template">
	<table style="width: 100%;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th></th>
			<th class="blLblNumber"><s:text name="lblNumber"></s:text></th>
			<th class="blLblCode"><s:text name="lblCode"></s:text></th>
			<th class="blLblClothingCategory"><s:text name="lblClothingCategory"></s:text></th>
			<th class="blLblName"><s:text name="Name"></s:text></th>
			<th class="blLblFabric"><s:text name="lblFabric"></s:text></th>
			<th class="blLblPubDate"><s:text name="lblPubDate"></s:text></th>
			<th class="blLblDeliveryDate"><s:text name="lblDeliveryDate"></s:text></th>
			<th class="blLblDealDate"><s:text name="lblDealDate"></s:text></th>
			<th class="blLblDeliveryStatus"><s:text name="lblDeliveryStatus"></s:text></th>
			<th class="blLblStatus"><s:text name="lblStatus"></s:text></th>
			<th class="blLblStopCause"><s:text name="lblStopCause"></s:text></th>
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
