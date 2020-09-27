<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type="text/javascript" src="../style_assemble/list.js"></script>
<!-- 款式组合设计页面 -->
<!-- 查询功能 条件输入 -->
<div id="AssembleSearch" class="list_search">
	<h1>
		<s:text name="款式组合设计"></s:text>
	</h1>
	<!-- 关键字 -->
	<s:label value="%{getText('lblKeyword')}"></s:label>
	<input type="text" id="searchKeywords" style="width:60px;" />
	<!-- 代码 -->
	<s:text name="组合代码"></s:text>
	<input type="text" id=searchCode style="width:70px;" />
	<!-- 服装分类 -->
	<s:text name="服装分类">
	</s:text>
	<select id="searchClothingID" style="width:70px;"></select>
	<!-- 款式风格 -->
	<s:text name="款式风格"></s:text>
	<select id="searchStyleID" style="width:80px;"></select>
	<s:text name="ArchiveAddTime"></s:text>
	<input type="text" id="fromDate" class="date" /> 
	<input type="text" id="toDate" class="date" /> 
	<a id="btnSearch"><s:text name="btnSearch"></s:text> </a> 
	<br /> &nbsp;&nbsp;&nbsp;&nbsp; 
	<a id="btnCreateAssemble"><s:text name="btnCreateFabric"></s:text> </a> 
	<a id="btnRemoveAssemble"><s:text name="btnRemoveFabric"></s:text> </a> 
	<a id="btnExportAssemble"><s:text name="btnExportFabric"></s:text> </a>
	<a id="btnImportAssemble"><s:text name="导入"></s:text> </a>
	<a id="btnImportAssembleAll"><s:text name="导入全部"></s:text> </a>
</div>
<div id="AssembleResult"></div>
<div id="AssembleStatistic"></div>
<div id="AssemblePagination" class="paging"></div>


<!-- 显示的 table -->
<textarea id="AssembleTemplate" class="list_template">
<table class="list_result">
			<!-- 表头 -->
		<tr class="header">
			<td class="check"><input type="checkbox"
				onclick="$.csControl.checkAll('chkRow', this.checked);" />
			</td>
			<td class="lblNumber"></td>
			<td class="lblName"><s:text name="代码"></s:text></td>
			<td class="lblUsername"><s:text name="服装类别"></s:text></td>
			<td class="lblGroup"><s:text name="款式风格"></s:text></td>
			<td class="lblSubs"><s:text name="类似品牌"></s:text></td>
			<td class="lblSubs"><s:text name="默认面料"></s:text></td>
			<td class="lblSubs"><s:text name="创建人"></s:text></td>
			<td class="lblSubs"><s:text name="创建时间"></s:text>
			</td>
			<td>操作</td>
		</tr>
		
		
		{#foreach $T.data as row}
		<tr id="row{$T.row.id}">
			<td class="center"><input type="checkbox" value="{$T.row.ID}"
				name="chkRow" />
				</td>
			<td class="center">{$T.row.number}</td>
			<td class="link" onclick="$.csAssembleList.openView('{$T.row.ID}')">{$T.row.code}</td>
			<td class="center">{$T.row.clothName}</td>
			<td class="center">{$T.row.styleName}</td>
			<td class="center">{$T.row.brands}</td>
			<td class="center">{$T.row.defaultFabric}</td>
			<td class="center">{$T.row.createBy}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.createTime)}</td>
			<td class="center"><a class="edit"onclick="$.csAssembleList.openPost('{$T.row.ID}')"><s:text name="lbEdit"></s:text></a></td>
		</tr>
		{#/for}
		</table>
</textarea>
