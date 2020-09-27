<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/member/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/member/listjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>

<div id="MemberSearch">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="myuser"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
	<s:label value="%{getText('lblKeyword')}"></s:label>:
	<input type="text" id="searchKeywords" style="width:60px;"/> &nbsp;
	<s:label value="%{getText('lblParentUsername')}"></s:label>:
	<input type="text" id="searchParent" style="width:70px;"/> &nbsp;
	<select id="searchGroupID" style="width:110px;"></select> &nbsp;
    <select id="searchStatusID" ></select> &nbsp;
	<a id="btnSearch" style="float: right;"><s:text name="btnSearch"></s:text></a>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
	<a id="btnRemoveMember"><s:text name="btnRemoveFabric"></s:text></a>
	<a id="btnCreateMember"><s:text name="btnCreateFabric"></s:text></a>
	<a id="btnExportMember"><s:text name="btnExportFabric"></s:text></a>　　
	<a id="changePasswordTwo"><s:text name="changePasswordTwo"></s:text></a>
	</div>
</div>
<div id="MemberResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="MemberStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="MemberPagination" class="paging"></div>
<textarea  id="MemberTemplate" class="list_template">
	<table style="width: 100%;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th class="check"><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></th>
			<th class="lblName"><s:text name="Name"></s:text></th>
			<th class="lblUsername"><s:text name="lblName"></s:text></th>
			<th class="lblGroup"><s:text name="lblGroup"></s:text></th>
			<th class="lblStatus"><s:text name="lblStatus"></s:text></th>
			<th class="lblParentName"><s:text name="lblParentUsername"></s:text></th>
			<th class="lblSubs"><s:text name="lblSubs"></s:text></th>
			<th class="lblRegistDate"><s:text name="lblRegistDate"></s:text></th>
			<th class="lblEdit"><s:text name="lblEdit"></s:text></th>
			<th class="lblDiscount"><s:text name="lblDiscount"></s:text></th>
			<th class="lblMenus"><s:text name="lblMenus"></s:text></th>
			<th class="lblMenus">收费工艺</th>
			<th class="lblMenus">单耗</th>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td class="center check"><input type="checkbox" value="{$T.row.ID}" name="chkRow"/></td>
			<td class="link" onclick="$.csMemberList.openView('{$T.row.ID}')">{$T.row.name}</td>
			<td>{$T.row.username}</td>
			<td>{$T.row.groupName}</td>
			<td>{$T.row.statusName}</td>
			<td>{$T.row.parentName}</td>
			<td class="center">{$T.row.subs}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.registDate)}</td>
			<td class="center"><a class="edit" onclick="$.csMemberList.openPost('{$T.row.ID}')"><s:text name="lbEdit"></s:text></a></td>
			<td class="center">
				{#if $T.row.isDiscount == DICT_YES}
					<a class="discount" onclick="$.csMemberList.blDiscountList('{$T.row.ID}')"><s:text name="blDiscountList"></s:text></a>
				{#/if}
			</td>
			<td class="center"><a class="menus" onclick="$.csMemberList.openMenus('{$T.row.ID}','{$T.row.name}')"><s:text name="Button_Menus"></s:text></a></td>
			<td class="center"><a class="menus" onclick="$.csMemberList.openDictPrice('{$T.row.ID}','{$T.row.username}')">维护</a></td>
			<td class="center"><a class="menus" onclick="$.csMemberList.openFabricConsume('{$T.row.username}')">维护</a></td>
			<!-- <td class="center"><a class="edit" onclick="$.csMemberList.openMenus('{$T.row.ID}','{$T.row.name}')"><s:text name="lblOperate"></s:text></a></td> -->
		</tr>
		{#/for}
	</table>
</textarea >