<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../distribution/addCompanys.js"></script>
<form id="form" class="form_template">
<h1>添加物流公司</h1>
<br/>
<div class="list_search">
	物流名称:
	<input type="text" id="companyname" name="companyname" style="width:80px;">
	<a id="addCompany" name="addCompany">添加</a>
</div>
<div id="CompanyResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="CompanyStatistic" class="pagingleft"></div>
	<div id="CompanyPagination" class="paging"></div>
	<textarea id="CompanyTemplate" class="list_template">
		<table class="list_result">
			<tr class="header">
			<td>物流名称</td>
			<td>操作</td>
			</tr>
			{#foreach $T.data as row}
			<tr id="">
			<td class="center">{$T.row.companyname}</td>
			<td><a href="javascript:void(0);" onclick="$.csDistributionPost.deleteCompany('{$T.row.id}')">删除</a></td>
			</tr>
			{#/for}
		</table>
	</textarea>
</form>

