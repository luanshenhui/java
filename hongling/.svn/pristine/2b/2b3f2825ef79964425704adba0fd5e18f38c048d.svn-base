<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/information/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/information/listjsp.js"></script>
<div id="InformationSearch" class="list_search">
	<h1></h1>
	<s:label value="%{getText('lblKeyword')}"></s:label><input type="text" id="keyword"/>
	<a id="btnSearch"><s:text name="btnSearch"></s:text></a>
	<a id="btnRemoveInformation"><s:text name="btnRemoveFabric"></s:text></a>
	<a id="btnCreateInformation"><s:text name="btnCreateFabric"></s:text></a>
</div>
<div id="InformationResult"></div>
<div id="InformationStatistic"></div>
<div id="InformationPagination" class="paging"></div>
<textarea  id="InformationTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class='check'><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td class="lblTitle"><s:text name="lblTitle"></s:text></td>
			<td class="lblCategory"><s:text name="Category"></s:text></td>
			<td class="lblGroup"><s:text name="lblGroup"></s:text></td>
			<td class="lblPubDate"><s:text name="Date"></s:text></td>
			<td class="lblEdit"><s:text name="lblEdit"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td class="center check"><input type="checkbox" value="{$T.row.ID}" name="chkRow"/></td>
			<td class="link" onclick="$.csInformationList.openView('{$T.row.ID}')">{$T.row.title}</td>
			<td>{$T.row.categoryName}</td>
			<td>{$T.row.accessGroupNames}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.pubDate)}</td>
			<td class="center"><a class="edit" onclick="$.csInformationList.openPost('{$T.row.ID}')"><s:text name="lbEdit"></s:text></a></td>
		</tr>
		{#/for}
	</table>
</textarea >