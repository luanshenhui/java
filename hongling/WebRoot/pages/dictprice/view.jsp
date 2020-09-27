<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../dictprice/view.js"></script>
<div id="view_dictprice" class="form_template">
	<h1><s:text name="View"></s:text></h1>
	<table style="width:620px;table-layout:fixed;word-wrap:break-word ">
		<tr>
			<td class="label lblUsername">工艺代码</td>
			<td id="_view_code" class="value"></td>
			<td class="label lblName">工艺描述</td>
			<td id="_view_name" class="value"></td>
		</tr>
		<tr>
			<td class="label lblRegistDate">人民币价格</td>
			<td id="_view_rmbPrice" class="value"></td>
			<td class="label lblLastLoginDate">美元价格</td>
			<td id="_view_price" class="value"></td>
		</tr>
		<tr>
			<td class="label lblGroup">是否手工</td>
			<td id="_view_ismanualInfo" class="value"></td>
			<td class="label lblStatus">定价方式</td>
			<td id="_view_pricetypeInfo" class="value"></td>
		</tr>
		<tr>
			<td class="label lblClientIP">权限组</td>
			<td colspan="3" id="_view_groupidsInfo" class="value"></td>
		</tr>
	</table>
</div>
