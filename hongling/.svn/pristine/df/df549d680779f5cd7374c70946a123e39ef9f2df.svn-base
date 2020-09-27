<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../style_pcssuit/list.js"></script>
<script src="../style_assemble/assembleCommon.js"></script>
<div>
	<div id="search" class="list_search">
		<h1>套装款式组合</h1>
		<s:label>关键字</s:label>
		<input type="text" id="searchKeyword" style="width:50px;"/>
		<label>组合代码</label>
		<input type="text" id="searchCode" style="width:50px;"/>
		<label>服装分类</label>
		<select id="searchClothing">
			<option value="0">--请选择--</option>
			<option value="1">套装(2pcs)</option>
			<option value="2">套装(3pcs)</option>
		</select>
		<label>款式风格</label>
		<select id="styleID" style="width:80px;"></select>
		<s:text name="ArchiveAddTime"></s:text>
		<input type="text" id="fromDate" class="date" /> 
		<input type="text" id="toDate" class="date" />
		
		<a id="btnquery">查询</a>
		<br>
		<a id="btnadd">新增</a>
		<a id="btndelete">删除</a>
	</div>
	<div id="PcsSuitResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="PcsSuitStatistic" class="pagingleft"></div>
	<div id="PcsSuitPagination" class="paging"></div>
	<textarea id="PcsSuitTemplate" class="list_template">
		<table class="list_result">
			<tr class="header">
			<td><input type="checkbox" id="moreSelect" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td>组合代码</td>
			<td>服装类别</td>
			<td>款式风格</td>
			<td>默认面料</td>
			<td>适用面料</td>
			<td>创建人</td>
			<td>创建时间</td>
			<td>操作</td>
			</tr>
			{#foreach $T.data as row}
			<tr id="row{$T.row.ID}">
			<td class="center"><input type="checkbox" value="{$T.row.ID}" id="chkRow" name="chkRow"/></td>
			<td class="center"><a onclick="$.csPcsSuitList.openView('{$T.row.ID}')">{$T.row.code}</a></td>
			<td class="center">
				{#if $T.row.clothingID=="1"}
				套装(2pcs)
				{#/if}
				{#if $T.row.clothingID=="2"}
				套装(3pcs)
				{#/if}
			</td>
			<td class="center">{$T.row.styleName}</td>
			<td class="center">{$T.row.defaultFabric}</td>
			<td class="center" width="40px">{$T.row.fabrics}</td>
			<td class="center">{$T.row.createBy}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.createTime)}</td>
			<td class="center">
					<a  class="edit" onclick="$.csPcsSuitList.openPost('{$T.row.ID}')">编辑</a>
				</td>
			</tr>
			{#/for}
		</table>
	</textarea>
</div>
