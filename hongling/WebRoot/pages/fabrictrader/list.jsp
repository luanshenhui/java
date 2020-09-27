<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="../fabrictrader/list.js">
</script>
<div>
	<div id="search" class="list_search">
		<h1>面料品牌管理</h1>
		<s:label>关键字</s:label>
		<s:textfield id="searchKeyword" name="searchKeyword"></s:textfield>
		<a href="javascript:void(0);" id="btnQuery">查询</a>
		<a href="javascript:void(0);" id="btnDelete">删除</a>
		<a href="javascript:void(0);" id="btnAdd">新增</a>
	</div>
	<div id="FabricTraderResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="FabricTraderStatistic" class="pagingleft"></div>
	<div id="FabricTraderPagination" class="paging"></div>
	<textarea id="FabricTraderTemplate" class="list_template">
		<table class="list_result">
		<tr class="header">
			<td><input type="checkbox" id="moreSelect" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td>商户</td>
			<td>推荐面料</td>
			<td>地址</td>
			<td>电话</td>
			<td>品牌描述</td>
			<td>操作</td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.id}">
			<td class="center"><input type="checkbox" value="{$T.row.id}" name="chkRow"/></td>
			<td class="center">{$T.row.traderName}</td>
			<td class="center">{$T.row.recommendation}</td>
			<td class="center">{$T.row.address}</td>
			<td class="center">{$T.row.telephone}</td>
			<td class="center">{$T.row.remark}</td>
			<td class="center"><a href="javascript:void(0);" class="edit" onclick="$.csFabricTraderList.openPost('{$T.row.id}')">编辑</a></td>
		</tr>
		{#/for}
		</table>
	</textarea>
</div>
