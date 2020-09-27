<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../bldiscount/commonjsp.js"></script>
<script src="../bldiscount/BlDiscountListjsp.js"></script>
<div id="BlDiscountListSearch" class="list_search">
	<h1></h1>
	<span id="blLblStatistic"></span>
	<label class="blLblKeyword"></label>
	<input type="text" id="searchKeywords"/>
	<a id="blBtnSearchMemberDiscount"></a>
	<a id="blBtnAddMemberDiscount"></a>
</div>
<div id="BlDiscountListResult"></div>
<div id="BlDiscountListStatistic"></div>
<div id="BlDiscountListPagination" class="paging"></div>
<textarea  id="BlDiscountListTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
		    <td class="blLblName"></td>
		    <td class="blLblDisClothingName"></td>
			<td class="blLblFromNum"></td>
			<td class="blLblToNum"></td>
			<td class="blLblDiscountNum"></td>
			<td class="blLblMemo"></td>
			<td class="blLbledit"></td>
			<td class="blLbldelete"></td>
		</tr>
		{#foreach $T.data as row}
		<tr>
		    <td class="center">{$T.row.memberUserName}</td>
			<td class="center">{$T.row.disClothingName}</td>
			<td class="center">{$T.row.fromNum}</td>
		    <td class="center">{$T.row.toNum}</td>
			<td class="center">{$T.row.discountNum}%</td>
			<td class="center">{$T.row.memo}</td>
			<td class="center"><a class="edit" onclick="$.csBlDiscountList.openPost('{$T.row.memberId}','{$T.row.ID}');"></a></td>
			<td class="center"><a class="delete" onclick="$.csBlDiscountList.remove('{$T.row.memberId}','{$T.row.ID}');"></a></td>
		</tr>
		{#/for}
	</table>
</textarea>