<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../fabricwareroom/view.js">	
</script>

<form class="form_template">
<h1>预览面料库存</h1>
<div style="margin-right:60px;">
<table>
	<tr>
		<td class="label">面料编码:</td>
		<td id="viewFabricNo" class="value"></td>
		<td class="label">库存:</td>
		<td id="viewStock" class="value"></td>
	</tr>
	<tr>
		<td class="label">分类:</td>
		<td id="viewCategory" class="value"></td>
		<td class="label">价格:</td>
		<td id="viewMoney" class="value"></td>
	</tr>
	<tr>
		<td class="label">颜色:</td>
		<td id="viewColor" class="value"></td>
		<td class="label">属性:</td>
		<td id="viewProperty" class="value"></td>
	</tr>
	<tr>
		<td class="label">花色:</td>
		<td id="viewFlower" class="value"></td>
		<td class="label">纱支:</td>
		<td id="viewShazhi" class="value"></td>
	</tr>
	<tr>
		<td class="label">成分:</td>
		<td id="viewComposition" class="value"></td>
		<td class="label">产地:</td>
		<td id="viewAddress" class="value"></td>
	</tr>
	<tr>
		<td class="label">品牌:</td>
		<td id="viewBrands" class="value"></td>
		<td class="label">单位:</td>
		<td id="viewBelong" class="value"></td>
	</tr>
	<tr>
		<td class="label">是否有效</td>
		<td id="viewStatus" class="value"></td>
		<td class="label">重量:</td>
		<td id="viewWeight" class="value"></td>
	</tr>
</table>
</div>
</form>
