<%@page import="centling.business.BlMemberManager"%>
<%@page import="chinsoft.business.CurrentInfo"%>
<%@page import="chinsoft.business.MemberManager"%>
<%@page import="chinsoft.entity.Member"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/commonlist.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/listjsp.js"></script>
<div class="noprint">
<div id="OrdenSearch" class="list_search">
	<h1><s:text name="view_orden"></s:text></h1>
	<div class="search_left">
		<s:label value="%{getText('lblClothingCategory')}"></s:label>
		<select id="searchClothingID"></select>
		<s:label value="%{getText('lblStatus')}"></s:label>
		<select id="searchStatusID"></select>
		<s:label value="%{getText('lblMemberName')}"></s:label>
		<select id="searchClientID"></select>
		<s:label value="%{getText('lblKeyword')}"></s:label>
		<input type="text" id="keyword" style="width:50px;">
		<br/>
		<a id="btnCreateOrden"><s:text name="btnCreateOrden"></s:text></a>
		<a id="btnExportOrdens"><s:text name="btnExportOrdens"></s:text></a>
		<a id="btnStatement"><s:text name="btnStatement"></s:text></a>
		<%	
			Member member=CurrentInfo.getCurrentMember();
			if(member != null && !"0".equals(member.getParentID())){
				Member parentMember = new MemberManager().getMemberByID(member.getParentID());
				Integer isDaBUser = BlMemberManager.isDaBUser(member.getGroupID(), parentMember.getGroupID());
				if(isDaBUser!=1){
					%> <a id="btnOrdenStatistic"><s:text name="btnOrdenStatistic"></s:text></a><%
				}
			}else if("0".equals(member.getParentID())){
			%>
				<a id="btnOrdenStatistic"><s:text name="btnOrdenStatistic"></s:text></a>
			<%
			}
		%>
		<a id="btnPayMoreOrden"><s:text name="btnMorePay"></s:text></a>
		<a id="btnSubmitMoreOrden" style="display:none;"><s:text name="btnMoreSubmit"></s:text></a>
		<a id="btnExportOrdenContent"><s:text name="btnExportOrdenContent"></s:text></a>
		<a id="btnPrintOrden"><s:text name="btnPrintOrden"></s:text></a>
	</div>
	<div class="search_right">
		<s:label value="%{getText('lblPubDate')}"></s:label>
		<input type="text" id="fromDate" class="date"/>
		<input type="text" id="toDate" class="date"/>
		<br/>
		<s:label value="%{getText('lblDealDate')}"></s:label>
		<input type="text" id="dealDate" class="date"/>
		<input type="text" id="dealToDate" class="date"/>
		<a id="btnSearch"><s:text name="btnSearch"></s:text></a>
	</div>
</div>
<div id="OrdenResult"></div>
<div id="overdue" style="display:none;"></div>
<div id="OrdenStatistic" class="pagingleft"></div>
<div id="OrdenPagination" class="paging"></div>
<textarea  id="OrdenTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td ><input type="checkbox" id="moreSelect" onclick="$.csOrdenList.selectOrQuick();" title="<s:text name="lblMoreSelect"/>"/></td>
			<td class="lblNumber"><s:text name="lblNumber"></s:text></td>
			<td class="lblCode"><s:text name="lblCode"></s:text></td>
			<td class="lblCode"><s:text name="lblCustomerNo"></s:text></td>
			<td class="lblClothingCategory"><s:text name="lblClothingCategory"></s:text></td>
			<td class="lblName"><s:text name="lblCustomerName"></s:text></td>
			<td class="lblFabric"><s:text name="lblFabric"></s:text></td>
			<td class="lblPubDate"><s:text name="lblPubDate"></s:text></td>
			<td class="lblDeliveryDate"><s:text name="lblDeliveryDate"></s:text></td>
			<td class="lblDealDate"><s:text name="lblDealDate"></s:text></td>
			<td class="lblDeliveryStatus"><s:text name="lblDeliveryStatus"></s:text></td>
			<td class="lblStatus"><s:text name="lblStatus"></s:text></td>
			<td class="lblDo"><s:text name="lblDo"></s:text></td>
			<td class="lblStopCause"><s:text name="lblStopCause"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ordenID}">
			<td><input type="checkbox" value="{$T.row.ordenID}" onclick="$.csOrdenList.checkOnce(this);" name="chkRow"/></td>
			<td class="center">{$T.row.number}</td>
			<td class="link" onclick="$.csOrdenList.openView('{$T.row.ordenID}')">{$T.row.ordenID}</td>
			<td class="link">{$T.row.userordeNo}</td>
			<td>{$T.row.clothingName}</td>
			<td>{$T.row.customer.name}</td>
			<td>{$T.row.fabricCode}</td>
			<td class="center {#if $T.row.isPubOverdue == DICT_YES}red{#/if}">{$.csDate.formatMillisecondDate($T.row.pubDate)}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.deliveryDate)}</td>
			<s:if test="#session.SessionCurrentMember.groupID == 10015 || #session.SessionCurrentMember.groupID == 10016 || #session.SessionCurrentMember.groupID == 10017 || #session.SessionCurrentMember.groupID == 10018">
				<td class="center link" onclick="$.csOrdenList.editJhrq('{$T.row.ordenID}','{$.csDate.formatMillisecondDate($T.row.jhrq)}')">{$.csDate.formatMillisecondDate($T.row.jhrq)}</td>
			</s:if>
			<s:else>
				<td class="center link">{$.csDate.formatMillisecondDate($T.row.jhrq)}</td>
			</s:else>
			<td class="center">{$T.row.deliveryStatusName}</td>
			<td class="center">{$T.row.statusName}</td>
			<td class="center nowrap">{$T.row.constDefine}</td>
			{#if $T.row.isStop=="10050"}
				<td class="center" title="{$T.row.stopCauseName}" onclick="$.csOrdenList.viewStopCause('{$T.row.stopCauseName}');"style="color: #F7CA8D;cursor: pointer;">
					<s:text name="lbView"></s:text>
			{#else}
				<td>&nbsp;
			{#/if}
			</td>
		</tr>
		{#/for}
	</table>
</textarea>
</div>
<div id="payToCCB"></div>
<div id="payToAlipay"></div>
<form id="toAddOrdenJsp" method="post">
	<s:hidden id="ordenID2" name="ordenID2"></s:hidden>
	<s:hidden id="copyFlag" name="copyFlag"></s:hidden>
</form>
