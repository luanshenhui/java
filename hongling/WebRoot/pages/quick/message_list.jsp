<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/message/commonjsp.js"></script>
<script src="<%=request.getContextPath() %>/pages/message/listjsp.js"></script>
<style>
a:HOVER{text-decoration: underline;}
.dybody{width:1200px;margin: 0px auto;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>

<div id="MessageSearch">
	<input type="hidden" id="inOrSent">
	<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="mymessage"></s:text></h1>
	<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
		<s:label value="%{getText('lblKeyword')}"></s:label>:<input type="text" id="keyword"/>
		<a id="btnSearch" style="float: right;"><s:text name="btnSearch"></s:text></a>
	</div>
	<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
		<a id="btnInbox"><s:text name="btnInbox"></s:text></a>　　
		<a id="btnSentbox"><s:text name="btnSentbox"></s:text></a>　　
		<a id="btnRemove"><s:text name="btnRemoveFabric"></s:text></a>　　
		<a id="btnSendMessage"><s:text name="btnSendMessage"></s:text></a>
	</div>
</div>
<div id="MessageResult" class="dytable" style="float: left;width: 100%;margin-bottom: 10px;"></div>
<div id="MessageStatistic" class="pagingleft" style="color:#000000;"></div>
<div id="MessagePagination" class="paging"></div>
<textarea  id="MessageTemplate" class="list_template">
	<table style="width: 100%;">
		<tr style="background-color: #c69b6e;color: #fff;">
			<th class='check'><input type="checkbox" onclick="$.csControl.checkAll('chkRow', this.checked);"/></th>
			<th class="lblTitle"><s:text name="lblTitle"></s:text></th>
			<th class="lblPubDate"><s:text name="PubDate"></s:text></th>
			<th class="lblPubMember"><s:text name="lblPubMember"></s:text></th>
			<th class="lblReceiver"><s:text name="lblReceiver"></s:text></th>
			<th class="lblReadDate"><s:text name="lblReadDate"></s:text></th>
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