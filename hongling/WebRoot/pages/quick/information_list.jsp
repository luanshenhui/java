<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/information/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/information/listjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>

<div id="InformationSearch">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="myinformation"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
		<s:label value="%{getText('lblKeyword')}"></s:label>:<input type="text" id="keyword"/>
		<a id="btnSearch" style="float: right;"><s:text name="btnSearch"></s:text></a>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
		<a id="btnRemoveInformation"><s:text name="btnRemoveFabric"></s:text></a>
		<a id="btnCreateInformation"><s:text name="btnCreateFabric"></s:text></a>
	</div>
</div>
<div id="InformationResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="InformationStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="InformationPagination" class="paging"></div>
<textarea  id="InformationTemplate" class="list_template">
	<table style="width: 100%;margin-top: 50px;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th class='check'><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></th>
			<th class="lblTitle"><s:text name="lblTitle"></s:text></th>
			<th class="lblCategory"><s:text name="Category"></s:text></th>
			<th class="lblGroup"><s:text name="lblGroup"></s:text></th>
			<th class="lblPubDate"><s:text name="Date"></s:text></th>
			<th class="lblEdit"><s:text name="lblEdit"></s:text></th>
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