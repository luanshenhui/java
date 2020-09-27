<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath()%>/pages/bldelivery/BlDeliveryHjsp.js"></script>
<script src="<%=request.getContextPath()%>/pages/bldelivery/BlDeliveryDetailViewjsp.js"></script>
<script src="<%=request.getContextPath()%>/pages/bldelivery/BlDeliveryDetailFjsp.js"></script>
<div id="BlDeliveryDetailFSearch" class="list_search">
	<h2 class="center" style="font-weight:normal"><s:text name="Delivery"></s:text></h2><br/>
	<div class="search_left">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<s:label value="%{getText('lblKeyword')}"></s:label>
		<input type="text" id="blDetailKeyword" style="width:50px;">&nbsp;&nbsp;&nbsp;&nbsp;
		<s:label value="%{getText('lblDeliveryDate')}"></s:label>
		<input type="text" id="blDeliverFromDate" class="date"/>
		<input type="text" id="blDeliverToDate" class="date"/>&nbsp;&nbsp;&nbsp;&nbsp;
		<a id="blDetailBtnSearch"><s:text name="btnSearch"></s:text></a>&nbsp;&nbsp;&nbsp;&nbsp;
		<a id="blDetailBtnExportDelivery"><s:text name="btnExportOrdens"></s:text></a>
	</div>
</div>
<div id="BlDeliveryDetailFResult"></div>
<div id="BlDeliveryDetailFStatistic" class="pagingleft"></div>
<div id="BlDeliveryDetailFPagination" class="paging"></div>
<textarea  id="BlDeliveryDetailFTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td><input type="checkbox" onclick="$.csControl.checkAll('chkRowDetail', this.checked);"/><s:label value="%{getText('lblNumber')}"></s:label></td>
			<td class="blLblUserName"><s:text name="lblName"></s:text></td>
			<td class="blLblUserCode"><s:text name="blLblUserCode"></s:text></td>
			<td class="blLblDeliveryAddr"><s:text name="blLblDeliveryAddr"></s:text></td>
			<td class="blLblCreateDate"><s:text name="blLblCreateDate"></s:text></td>
			<td class="blLblDeliveryDate"><s:text name="lblDeliveryDate"></s:text></td>
			<td class="blLblTrackingNumber"><s:text name="lblDeliveryDate"></s:text></td>
			<td class="blLblOperate"><s:text name="lblDo"></s:text></td>
			<td class="blLblExportDelivery"><s:text name="btnExportFabric"></s:text></td>
			<td class="blLblCancel"><s:text name="blLblCancel"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ordenID}">
			<td class="center"><input type="checkbox" value="{$T.row.ID}" name="chkRowDetail"/>No.{$T.row.number}</td>
			<td class="center">{$T.row.username}</td>
			<td class="center">{$T.row.name}</td>
			<td class="center" width="260">{$T.row.deliveryAddress}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.applyDate)}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.deliveryDate)}</td>
			<td class="center">
			    {#if $T.row.yundanId != null}
			        {#if $T.row.expressComName == "DHL"}
					    <a onclick="$.csBlDeliveryHList.openTrack('{$T.row.yundanId}');" style="color:#ffab00;">{$T.row.yundanId}</a>
					{#/if}
					{#if $T.row.expressComName != "DHL"}
						{$T.row.yundanId}
					{#/if}
				{#/if}
			</td>
			<td class="center"><a class="view" onclick="$.csBlDeliveryDetailView.openView('{$T.row.ID}');"></a></td>
			<td class="center">
				<a class="blExportDelivery" onclick="$.csBlDeliveryHList.exportDeliveryDetail('{$T.row.ID}');"></a>
			</td>
			<td class="center">
				{#if $T.row.statusId == DELIVERY_STATE_APPLY}
					<a class="blCancel" onclick="$.csBlDeliveryDetailFList.cancleDeliveryDetail('{$T.row.ID}');"></a>
				{#/if}
			</td>
		</tr>
		{#/for}
	</table>
</textarea>
