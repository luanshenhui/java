<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/receiving/common.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/receiving/list.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/commonlist.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/viewjsp.js"></script>
<div id="OrdenSearch" class="list_search">
	<h1></h1>
	<div class="search_left">
		<label class="lblClothingCategory"></label>
		<select id="searchClothingID"></select>
		<label class="lblOwnedStore"></label>
		<input type="text" id="searchClientID" class="date"/>
		<label class="lblKeyword"></label>
		<label class="lblDealDate"></label>
		<input type="text" id="fromDate" class="date"/>
		<input type="text" id="toDate" class="date"/>
		
		<a id="btnSearch"></a>
		<a id="btnAdd"></a>
		<a id="btnRemove"></a>
		<a id="btnExportOrdens"></a>
	</div>
</div>
<div id="OrdenResult"></div>
<div id="OrdenStatistic" class="pagingleft"></div>
<div id="OrdenPagination" class="paging"></div>
<textarea  id="OrdenTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="check"><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td class="lblNumber"></td>
			<td class="lblOwnedStore"></td>
			<td class="lblCode"></td>
			<td class="lblName"></td>
			<td class="lblListClothingCategory"></td>
			<td class="lblTel"></td>
			<td class="lblPubDate"></td>
			<td class="blLblMemo"></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.id}">
			<td class="center"><input type="checkbox" value="{$T.row.id}" name="chkRow"/></td>
			<td class="center">{$T.row.number}</td>
			<td class="center">{$T.row.ownedstore}</td>
			<td class="center" style="cursor: pointer;" onclick="$.csReceivingList.openView('{$T.row.ordenid}')">{$T.row.ordenid}</td>
			<td class="center">{$T.row.name}</td>
			<td class="center">{$T.row.sortName}</td>
			<td class="center">{$T.row.phonenumber}</td>
			<td class="center">{$T.row.createtime}</td>
			<td class="center">{$T.row.memo}</td>
		</tr>
		{#/for}
	</table>
</textarea >
