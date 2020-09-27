<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/receiving/common.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/receiving/list.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/commonlist.js"></script>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/viewjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>

<div id="OrdenSearch">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="receivingmanagement"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
		<s:label value="%{getText('lblClothingCategory')}"></s:label>:
		<select id="searchClothingID"></select> &nbsp;
		<label class="lblOwnedStore"></label>:
		<input type="text" id="searchClientID" class="date"/> &nbsp;
		<label class="lblKeyword"></label>
		<label class="lblDealDate"></label>:
		<input type="text" id="fromDate" class="date"/>
		<input type="text" id="toDate" class="date"/> &nbsp;
		<a id="btnSearch" style="float: right;"></a>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">	
		<a id="btnAdd"></a>　　
		<a id="btnRemove"></a>　　
		<a id="btnExportOrdens"></a>
	</div>
</div>
<div id="OrdenResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="OrdenStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="OrdenPagination" class="paging"></div>
<textarea  id="OrdenTemplate" class="list_template">
	<table style="width: 100%;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th class="check"><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></th>
			<th class="lblNumber"></th>
			<th class="lblOwnedStore"></th>
			<th class="lblCode"></th>
			<th class="lblName"></th>
			<th class="lblListClothingCategory"></th>
			<th class="lblTel"></th>
			<th class="lblPubDate"></th>
			<th class="blLblMemo"></th>
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
