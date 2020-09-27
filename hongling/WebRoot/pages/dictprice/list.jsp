<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/dictprice/listjsp.js"></script>
<div id="DictPriceSearch" class="list_search">
	<h1></h1>
	<s:label value="%{getText('lblKeyword')}"></s:label><input type="text" id="keyword"/>
	<a id="btnSearch"><s:text name="btnSearch"></s:text></a>
	<a id="btnRemoveDictPrice"><s:text name="btnRemoveFabric"></s:text></a>
	<a id="btnCreateDictPrice"><s:text name="btnCreateFabric"></s:text></a>
</div>
<div id="DictPriceResult"></div>
<div id="DictPriceStatistic"></div>
<div id="DictPricePagination" class="paging"></div>
<textarea  id="DictPriceTemplate" class="list_template">
<div style="overflow-x:auto; width:900px;"> 
	<table class="list_result">
		<tr class="header">
			<td class='check'><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td class="lblTitle">工艺代码</td>
			<td class="lblCategory">工艺描述</td>
			<td class="lblGroup">美元价格</td>
			<td class="lblPubDate">人民币价格</td>
			<td class="lblPubDate">是否手工</td>
			<td class="lblPubDate">定价方式</td>
			<td class="lblEdit">操作</td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td class="center check"><input type="checkbox" value="{$T.row.id}" name="chkRow"/></td>
			<td class="link" onclick="$.csDictPriceList.openView('{$T.row.id}')">{$T.row.code}</td>
			<td>{$T.row.name}</td>
			<td>{$T.row.price}</td>
			<td>{$T.row.rmbPrice}</td>
			<td>{$T.row.ismanualInfo}</td>
			<td>{$T.row.pricetypeInfo}</td>
			<td class="center"><a class="edit" onclick="$.csDictPriceList.openPost('{$T.row.id}')"><s:text name="lbEdit"></s:text></a></td>
		</tr>
		{#/for}
	</table>
	</div>
</textarea>
