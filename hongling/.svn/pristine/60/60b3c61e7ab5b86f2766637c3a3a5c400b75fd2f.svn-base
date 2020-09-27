<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../style_assemble/post.js"></script>
<script src="../style_assemble/assembleCommon.js"></script>

<form id="form" class="form_template">
	<input type="hidden" name="ID" id="ID" />
	<input type="hidden"  id="assembleID" />
	<h1></h1>
	<table>
		<tr>
			<td class="label star nowrap"><s:text name="组合代码" /></td>
			<td><input type="text" id="code" class="textbox" style="width:180px;"/></td>
			<td class="label lblClothingCategory nowrap"><s:text name="类似品牌" /></td>
			<td nowrap="nowrap"><input type="text" id="brands" class="textbox" style="width:180px;"/></td>
		</tr>
		<tr>
			<td class="label star nowrap"><s:text name="适用服装" /></td>
			<td><select id="clothingID" style="width:180px;"></select>
			<td class="label star lblCode nowrap"><s:text name="款式风格" /></td>
			<td colspan="3"><select id="styleID" style="width:180px;"></select></td>
		</tr>
		<tr>
			<td class="label star lblCode nowrap"><s:text name="默认面料"/>
			</td>
			<td><input type="text" id="defaultFabric" readonly="readonly" class="textbox" style="width:180px;"/>
				<span class='list_search'> 
					<a id="addDefaultFabric" onclick="$.csAssemblePost.addFabric(0)">添加</a> 
				</span>
			</td>
			<td class="label lblCode nowrap"><s:text name="适用面料"/></td>
			<td>
				<input type="text" id="fabrics" class="textbox" style="width:180px;"/> 
				<span class='list_search'> 
					<a id="addFabrics" onclick="$.csAssemblePost.addFabric(1)">添加</a> 
				</span>
			</td>
		</tr>
		<tr>
			<td class="label nowrap"><s:text name="中文标题" /></td>
			<td colspan="3"><input type="text" id="titleCn" class="textbox" style="width:570px;"/></td>
		</tr>
		<tr>
			<td class="label nowrap"><s:text name="英文标题" /></td>
			<td colspan="3"><input type="text" id="titleEn" class="textbox" style="width:570px;"/></td>
		</tr>
		<tr>
			<td class="label star lblCode nowrap"><s:text name="款式工艺" /></td>
			<td colspan="3">
				<div class='list_search'>
					<a id="addProcess" onclick="$.csAssemblePost.showTree()">添加工艺</a>
				</div> 
				<textarea id="styleTree" readonly="readonly" style="width: 570px; height: 105px;resize:none; font-size:14px;"></textarea> 
				<input type="hidden" name="process" id="process">
			</td>
		</tr>
		<tr>
			<td class="label lblClothingCategory nowrap"><s:text name="特殊工艺" />
			</td>
			<!-- 产品菜单 -->
			<td nowrap="nowrap" colspan="3">
				<div class='list_search' style="margin-top: 5px;float: left;">
					<a id="addSpecialProcess">添加工艺</a>
				</div>
				<table>
					<tr>
						<td><table id="sppro" class='list_result'></table></td>
						<td style="width:20%"><input type="hidden" id="specialProcess" /></td>
					</tr>
				</table></td>
		</tr>
	</table>
	<div class="operation">
		<a id="btnSave" /> <a id="btnCancel" />
	</div>
</form>