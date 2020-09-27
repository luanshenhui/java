<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/blcash/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/blcash/BlDealListjsp.js"></script>
<div id="BlDealListSearch" class="list_search">
<input type="hidden" id="blmemberid" name="blmemberid">
<input type="hidden" id="blcashid" name="blcashid">
<input type="hidden" id="from" name="from">
	<h1><s:text name="list_search"></s:text></h1>
	<span id="blLblStatistic"></span>
	<s:label value="%{getText('lblKeyword')}"></s:label>
	<input type="text" id="blKeyword"/>
	<s:label value="%{getText('blLblTimePeriod')}"></s:label>
	<input type="text" id="blFromDate" class="date"/>
	<input type="text" id="blToDate" class="date"/>
	<!-- <a id="blBtnExportCash"></a> -->
	<a id="blBtnSearch"><s:text name="btnSearch"></s:text></a>
	<a id="blBtnDuizhangdan"><s:text name="blBtnDuizhangdan"></s:text></a>
	<a id="blshougongduizhang"><s:text name="shougongduizhang"></s:text></a>
	<a id="blBtnAdd"><s:text name="btnCreateFabric"></s:text></a>
</div>
<div id="BlDealListResult"></div>
<div id="BlDealListStatistic"></div>
<div id="BlDealListPagination" class="paging"></div>
<textarea  id="BlDealListTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="blLblDealDate"><s:text name="blLblDealDate"></s:text></td>
			<td class="blLblClientCompanyName"><s:text name="blLblClientCompanyName"></s:text></td>
			<!-- <td class="blLblCompanyShortName"></td> -->
			<td class="blLblAccountName"><s:text name="blLblAccountName"></s:text></td>
			<td class="blLblDealProject"><s:text name="blLblDealProject"></s:text></td>
			<td class="blLblMoneyKind"><s:text name="blLblMoneyKind"></s:text></td>
			<td class="blLblInAccount"><s:text name="blLblInAccount"></s:text></td>
			<td class="blLblOutAccount"><s:text name="blLblOutAccount"></s:text></td>
			<td class="blLblOrderIdTrackingId"><s:text name="blLblOrderIdTrackingId"></s:text></td>
			<td class="blLblRemainMoney"><s:text name="blLblRemainMoney"></s:text></td>
			<td class="blLblRemark"><s:text name="lblMemo"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td class="center" width="130">{$T.row.dealDate}</td>
			<td class="center" width="150">{$T.row.companyName}</td>
			<!-- <td class="center" width="50">{$T.row.companyShortName}</td> -->
			<td class="center" width="50">{$T.row.username}</td>
			<td class="center" width="120">{$T.row.dealItemName}</td>
			<td class="center" width="50">{$T.row.moneySignName}</td>
			<td class="center" width="100">{$T.row.accountIn}</td>
			<td class="center" width="100">{$T.row.accountOut}</td>
			<td class="center" width="100">{$T.row.ordenId}</td>
			<td class="center" width="50">{$T.row.num}</td>
			<td class="center" width="50">{$T.row.memo}</td>
		</tr>
		{#/for}
	</table>
</textarea>