<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/message/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/message/listjsp.js"></script>
<div id="MessageSearch" class="list_search">
	<input type="hidden" id="inOrSent">
	<h1></h1>
	<s:label value="%{getText('lblKeyword')}"></s:label><input type="text" id="keyword"/>
	<a id="btnSearch"><s:text name="btnSearch"></s:text></a>
	<a id="btnInbox"><s:text name="btnInbox"></s:text></a>
	<a id="btnSentbox"><s:text name="btnSentbox"></s:text></a>
	<a id="btnRemove"><s:text name="btnRemoveFabric"></s:text></a>
	<a id="btnSendMessage"><s:text name="btnSendMessage"></s:text></a>
</div>
<div id="MessageResult"></div>
<div id="MessageStatistic"></div>
<div id="MessagePagination" class="paging"></div>
<textarea  id="MessageTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class='check'><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></td>
			<td class="lblTitle"><s:text name="lblTitle"></s:text></td>
			<td class="lblPubDate"><s:text name="PubDate"></s:text></td>
			<td class="lblPubMember"><s:text name="lblPubMember"></s:text></td>
			<td class="lblReceiver"><s:text name="lblReceiver"></s:text></td>
			<td class="lblReadDate"><s:text name="lblReadDate"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ID}">
			<td class="center check"><input type="checkbox" value="{$T.row.ID}" name="chkRow"/></td>
			<td class="link" onclick="$.csMessageList.openView('{$T.row.ID}')">{$T.row.title}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.pubDate)}</td>
			<td>{$T.row.pubMemberName}</td>
			<td>{$T.row.receiverName}</td>
			<td class="center">{$.csDate.formatMillisecondDate($T.row.readDate)}</td>
		</tr>
		{#/for}
	</table>
</textarea >