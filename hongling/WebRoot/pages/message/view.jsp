<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/message/viewjsp.js"></script>
<div id="view_message" class="form_template">
	<h1></h1>
	<table>
		<tr>
			<td class="label lblPubMember"><s:text name="lblPubMember"></s:text></td>
			<td id="_view_pubMemberName"></td>
			<td class="label lblReceiver"><s:text name="lblReceiver"></s:text></td>
			<td id="_view_receiverName"></td>
		</tr>
		<tr>
			<td class="label lblPubDate"><s:text name="PubDate"></s:text></td>
			<td id="_view_pubDate"></td>
			<td class="label lblReadDate"><s:text name="lblReadDate"></s:text></td>
			<td id="_view_readDate"></td>
		</tr>
		<tr>
			<td class="label lblTitle"><s:text name="lblTitle"></s:text></td>
			<td colspan="3" id="_view_title"></td>
		</tr>
		<tr>
			<td class="label lblContent"><s:text name="lblContent"></s:text></td>
			<td colspan="3" id="_view_content"></td>
		</tr>
	</table>
</div>