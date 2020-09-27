<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/member/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/member/listjsp.js"></script>
<div id="MemberSearch" class="list_search">
	<h1></h1>
	<s:label value="%{getText('lblKeyword')}"></s:label>
	<input type="text" id="searchKeywords" style="width:60px;"/>
	<s:label value="%{getText('lblParentUsername')}"></s:label>
	<input type="text" id="searchParent" style="width:70px;"/>
	<select id="searchGroupID" style="width:85px;"></select>
    <select id="searchStatusID" ></select>
	<a id="btnSearch"><s:text name="btnSearch"></s:text></a>
	<a id="btnExportMember"><s:text name="btnExportFabric"></s:text></a>
	<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
	<a id="btnRemoveMember"><s:text name="btnRemoveFabric"></s:text></a>
	<a id="btnCreateMember"><s:text name="btnCreateFabric"></s:text></a>
	<a id="changePasswordTwo"><s:text name="changePasswordTwo"></s:text></a>
	<a id="changeMemberRegisterTime"><s:text name="changeMemberRegisterTime"></s:text></a>
	</s:if>
</div>
<div id="MemberResult"></div>
<div id="MemberStatistic"></div>
<div id="MemberPagination" class="paging"></div>
<textarea  id="MemberTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="check"><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td class="lblName"><s:text name="Name"></s:text></td>
			<td class="lblUsername"><s:text name="lblName"></s:text></td>
			<td class="lblGroup"><s:text name="lblGroup"></s:text></td>
			<td class="lblStatus"><s:text name="lblStatus"></s:text></td>
			<td class="lblParentName"><s:text name="lblParentUsername"></s:text></td>
			<td class="lblSubs"><s:text name="lblSubs"></s:text></td>
			<td class="lblRegistDate"><s:text name="lblRegistDate"></s:text></td>
			<td class="lblEdit"><s:text name="lblEdit"></s:text></td>
			<td class="lblDiscount"><s:text name="lblDiscount"></s:text></td>
			<td class="lblMenus"><s:text name="lblMenus"></s:text></td>
			<td class="lblMenus">收费工艺</td>
			<td class="lblMenus">单耗</td>
			<td class="lblQorderMenus">快下权限</td>
			<td class="lblQorderMenus">面料权限</td>
			<!-- <td class="lblProccessFee"><s:text name="lblProccessFee"></s:text></td> -->
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
			<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
			<td class="center"><a class="edit" onclick="$.csMemberList.openPost('{$T.row.ID}')"><s:text name="lbEdit"></s:text></a></td>
			</s:if>
			<s:else>
			<td class='center'></td>
			</s:else>
			<td class="center">
				{#if $T.row.isDiscount == DICT_YES}
					<a class="discount" onclick="$.csMemberList.blDiscountList('{$T.row.ID}')"><s:text name="blDiscountList"></s:text></a>
				{#/if}
			</td>
			<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
			<td class="center"><a class="menus" onclick="$.csMemberList.openMenus('{$T.row.ID}','{$T.row.name}')"><s:text name="Button_Menus"></s:text></a></td>
			</s:if>
			<s:else>
			<td class='center'></td>
			</s:else>
			<td class="center"><a class="menus" onclick="$.csMemberList.openDictPrice('{$T.row.ID}','{$T.row.username}')">维护</a></td>
			<td class="center"><a class="menus" onclick="$.csMemberList.openFabricConsume('{$T.row.username}')">维护</a></td>
			<s:if test="#session.SessionCurrentMember.username =='rcmtm'">
			<td class="center"><a class="menus" onclick="$.csMemberList.openQorderMenus('{$T.row.ID}','{$T.row.name}')"><s:text name="Button_Menus"></s:text></a></td>
			</s:if>
			<s:else>
			<td class='center'></td>
			</s:else>
			<!-- <td class="center"><a class="edit" onclick="$.csMemberList.openMenus('{$T.row.ID}','{$T.row.name}')"><s:text name="lblOperate"></s:text></a></td> -->
			<td class="center"><a class="menus" onclick="$.csMemberList.openFabricMenus('{$T.row.ID}','{$T.row.name}')"><s:text name="Button_Menus"></s:text></a></td>
		</tr>
		{#/for}
	</table>
</textarea >