<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<script language= "javascript" src="<%=request.getContextPath()%>/pages/fabric/occupylistjsp.js"></script>
<div id="fabric_occupy_result" class="list_search">
<h1></h1>
<div id="FabricOccupyResult"></div>
<textarea  id="FabricOccupyTemplate" class="list_template">
	<table class="list_result">
		<tr class="header">
			<td class="lblCode"><s:text name="lbclCode"></s:text></td>
			<td class="lblOccupyAmount"><s:text name="lblOccupyAmount"></s:text></td>
			<td class="lblMemo"><s:text name="lblMemo"></s:text></td>
			<td class="lblFromDate"><s:text name="lblFromDate"></s:text></td>
			<td class="lblToDate"><s:text name="lblToDate"></s:text></td>
		</tr>
		{#foreach $T.data as row}
		<tr>
			<td>{$T.row.xttxhm}</td>
			<td>{$T.row.xtzysl}</td>
			<td>{$T.row.xtzybz}</td>
			<td>{$T.row.xtzysj}</td>
			<td>{$T.row.xtsfsj}</td>
		</tr>
		{#/for}
	</table>
</textarea>
</div>