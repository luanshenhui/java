<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/blcash/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/blcash/BlDealListjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>

<div id="BlDealListSearch">
<input type="hidden" id="blmemberid" name="blmemberid">
<input type="hidden" id="blcashid" name="blcashid">
<input type="hidden" id="from" name="from">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="list_search"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
		<span id="blLblStatistic"></span> &nbsp;
		<s:label value="%{getText('lblKeyword')}"></s:label>:
		<input type="text" id="blKeyword"/> &nbsp;
		<s:label value="%{getText('blLblTimePeriod')}"></s:label>:
		<input type="text" id="blFromDate" class="date"/>
		<input type="text" id="blToDate" class="date"/> &nbsp;
		<a id="blBtnSearch" style="float: right;"><s:text name="btnSearch"></s:text></a>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
		<a id="blBtnDuizhangdan"><s:text name="blBtnDuizhangdan"></s:text></a>　　
		<a id="blshougongduizhang"><s:text name="shougongduizhang"></s:text></a>　　
		<a id="blBtnAdd"><s:text name="btnCreateFabric"></s:text></a>
	</div>
</div>
<div id="BlDealListResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="BlDealListStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="BlDealListPagination" class="paging"></div>
<textarea  id="BlDealListTemplate" class="list_template">
	<table style="width: 100%;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th class="blLblDealDate"><s:text name="blLblDealDate"></s:text></th>
			<th class="blLblClientCompanyName"><s:text name="blLblClientCompanyName"></s:text></th>
			<th class="blLblAccountName"><s:text name="blLblAccountName"></s:text></th>
			<th class="blLblDealProject"><s:text name="blLblDealProject"></s:text></th>
			<th class="blLblMoneyKind"><s:text name="blLblMoneyKind"></s:text></th>
			<th class="blLblInAccount"><s:text name="blLblInAccount"></s:text></th>
			<th class="blLblOutAccount"><s:text name="blLblOutAccount"></s:text></th>
			<th class="blLblOrderIdTrackingId"><s:text name="blLblOrderIdTrackingId"></s:text></th>
			<th class="blLblRemainMoney"><s:text name="blLblRemainMoney"></s:text></th>
			<th class="blLblRemark"><s:text name="lblMemo"></s:text></th>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td class="center" width="130">{$T.row.dealDate}</td>
			<td class="center" width="150">{$T.row.companyName}</td>
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