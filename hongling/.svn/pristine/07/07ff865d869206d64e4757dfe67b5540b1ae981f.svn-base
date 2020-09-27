
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<script type="text/javascript" src="../distribution/list.js">
</script>
<style type="text/css">
	.ipt{
		width:80px;
	}
</style>
<%
	java.util.HashMap map=new HashMap();
	map.put(1, "陆运");
	map.put(2, "海运");
	map.put(3, "空运");
	request.setAttribute("map", map);
	
	java.util.HashMap st=new HashMap();
	st.put(1, "有效");
	st.put(2, "无效");
	request.setAttribute("st", st);
	
	
 %>
<div>
	<div id="DistributionSearch" class="list_search">
		<h1>物流管理</h1>
		<s:label value="始发地"></s:label>
		<s:textfield id="sendtos" name="sendtos" cssClass="ipt"></s:textfield>
		<s:label value="目的地"></s:label>
		<s:textfield id="sendends" name="sendends" cssClass="ipt"></s:textfield>
		<s:label value="物流方式"></s:label>
		<s:select list="#request.map" name="sendmodes" id="sendmodes" listKey="key" listValue="value" headerKey="0" headerValue="所有">
		</s:select>
		<s:label value="物流公司"></s:label>
		<select id="searchCompanyID"></select>
		<s:label value="是否有效"></s:label>
		<s:select list="#request.st" name="statuss" id="statuss" listKey="key" listValue="value" headerKey="0" headerValue="所有">
		</s:select>
		<a onclick="javascript:void(0);" id="btnQuery">查询</a>
		<br/>
		<a onclick="javascript:void(0);" id="btnAdd" style="width:80px;">添加物流</a>
		<a onclick="javascript:void(0);" id="btnAddMode" style="width:100px;">物流公司管理</a>
	</div>
	<div id="DistributionResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="DistributionStatistic" class="pagingleft"></div>
	<div id="DistributionPagination" class="paging"></div>
	<textarea id="DistributionTemplate"  class="list_template">
		<table class="list_result">
		<tr class="header">
			<td><input type="checkbox" id="moreSelect" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td>始发地</td>
			<td>目的地</td>
			<td>物流方式</td>
			<td>订单数量</td>
			<td>套装</td>
			<td>上衣</td>
			<td>西裤</td>
			<td>大衣</td>
			<td>马甲</td>
			<td>西裙</td>
			<td>衬衣</td>
			<td>配饰</td>
			<td>物流公司</td>
			<td>是否可用</td>
			<td>编辑</td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.id}">
			<td class="center"><input type="checkbox" value="{$T.row.id}" name="chkRow"/></td>
			<td class="center">{$T.row.sendto}</td>
			<td class="center">{$T.row.sendend}</td>
			<td class="center">
			{#if $T.row.sendmode=="1"}
			陆运
			{#/if}
			{#if $T.row.sendmode=="2"}
			海运
			{#/if}
			{#if $T.row.sendmode=="3"}
			空运
			{#/if}
			</td>
			<td class="center">{$T.row.sendcount}</td>
			<td class="center">{$T.row.MT_Price}</td>
			<td class="center">{$T.row.MXF_Price}</td>
			<td class="center">{$T.row.MXK_Price}</td>
			<td class="center">{$T.row.MDY_Price}</td>
			<td class="center">{$T.row.MMJ_Price}</td>
			<td class="center">{$T.row.MXQ_Price}</td>
			<td class="center">{$T.row.MCY_Price}</td>
			<td class="center">{$T.row.MPO_Price}</td>
			<td class="center">{$T.row.logisticsCompany.companyname}</td>
			<td class="center" id="td{$T.row.id}">
			{#if $T.row.status==1}
			是
			&nbsp;|&nbsp;
			<a class="edit" href="javascript:void(0);" onclick="$.csDistributionList.deleteByID('{$T.row.id}')">删除</a>
			{#else}
			否
			{#/if}
			</td>
			<td><a class="edit" href="javascript:void(0);" onclick="$.csDistributionList.openEdit('{$T.row.id}')">编辑</a></td>
		</tr>
		{#/for}
		</table>
	</textarea>
</div>