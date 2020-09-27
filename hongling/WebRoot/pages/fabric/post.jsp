<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../fabric/common.js"></script>
<script src="../fabric/postjsp.js"></script>
<form id="form" class="form_template">
<input type="hidden" id="ID"/>
<h1><s:text name="form_occupy"></s:text></h1>
<table>
	<tr>
		<td class="label lblFabricSupplyCategory"><s:text name="lblFabricSupplyCategory"></s:text></td>
		<td><select id="fabricSupplyCategoryID"></select></td>
		<td class="label lblIsStop"><s:text name="lblIsStop"></s:text></td>
		<td><select id="isStop"></select></td>
	</tr>
	<tr>
		<td class="label lblCategory"><s:text name="lblCommon_Category"></s:text></td>
		<td><select id="categoryID"></select></td>
		<td class="label lblCode star"><s:text name="lbclCode"></s:text></td>
		<td><input type="text" id="code"  class="textbox"/></td>
	</tr>
	<tr>
		<td class="label lblPrice"><s:text name="lblPrice"></s:text></td>
		<td><input type="text" style="width: 80px" id="price"  class="textbox"/>(RMB)<input type="text" style="width: 80px" id="dollarPrice"  class="textbox"/>($)</td>
		<td class="label lblWeight"><s:text name="lblcWeight"></s:text></td>
		<td><input type="text" id="weight"  class="textbox"/></td>
	</tr>
	<tr>
		<td class="label lblSeries star"><s:text name="lblSeries"></s:text></td>
		<td><select id="seriesID"></select></td>
		<td class="label lblColor star"><s:text name="lblColor"></s:text></td>
		<td><input type="text" id="colorName" class="textbox" value="" /><input type="hidden" id="colorID" value=""/></td>
	</tr>
	<tr>
		<td class="label lblFlower star"><s:text name="lblFlower"></s:text></td>
		<td><input type="text" id="flowerName" class="textbox" value="" /><input type="hidden" id="flowerID" value=""/></td>
		<td class="label lblComposition star"><s:text name="lblComposition"></s:text></td>
		<td><input type="text" id="compositionName" class="textbox" value="" /><input type="hidden" id="compositionID" value=""/></td>
	</tr>
	<tr>
		<td class="label lblFabricSupply"><s:text name="lblFabricSupply"></s:text></td>
		<td><input type="text" id="fabricSupplyID" class="textbox"/></td>
		<td class="label lblFabricSupplyCode"><s:text name="lblFabricSupplyCode"></s:text></td>
		<td><input type="text" id="fabricSupplyCode" class="textbox"/></td>
	</tr>
	<tr>
		<td class="label lblShaZhi"><s:text name="lblShaZhi"></s:text></td>
		<td><input type="text" id="shaZhi" class="textbox"/></td>
		<td class="label lblSequenceNo"><s:text name="lblSequenceNo"></s:text></td>
		<td><input type="text" id="sequenceNo" class="textbox"/></td>
	</tr>
	<tr>
		<td class="label lblvFlower star"><s:text name="lblvFlower"></s:text></td>
		<td><input type="text" id="vflowerName" class="textbox" value="" /><input type="hidden" id="vflowerID" value=""/></td>
		<td class="label lblvColor star"><s:text name="lblvColor"></s:text></td>
		<td><input type="text" id="vcolorName" class="textbox" value="" /><input type="hidden" id="vcolorID" value=""/></td>
	</tr>
	<tr>
		<td class="label lblvComposition star"><s:text name="lblvComposition"></s:text></td>
		<td><input type="text" id="vcompositionName" class="textbox" value="" /><input type="hidden" id="vcompositionID" value=""/></td>
		<td class="label lblvSeriesid star"><s:text name="lblvSeriesid"></s:text></td>
		<td><input type="text" id="vseriesID"  class="textbox"/></td>
	</tr>
	<tr>
		<td class="label">拥有者</td>
		<td><input type="text" id="owners"  class="textbox"/></td>
	</tr>
</table>
<div class="operation">
	<a id="btnSaveFabric"><s:text name="Button_Submit"></s:text></a> <a id="btnCancelFabric"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>