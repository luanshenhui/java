<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../style_assemble/view.js"></script>
<!-- 档案浏览页面 -->
<div id="view_assemble" class="form_template">
	<h1>款式档案浏览</h1>
	<div style="margin-right:20px;">
		<table>
			<tr>
				<td class="label lblParentName" width=80px><s:text name="组合代码"></s:text></td>
				<td id="_view_assembleCode"></td>
				<td class="label lblReceiver"><s:text name="服装分类"></s:text></td>
				<td id="_view_assembleClothing"></td>
			</tr>
			<tr>
				<td class="label lblBodyType" align="left"><s:text name="款式风格"></s:text></td>
				<td colspan="3" id="_view_assembleStyle"></td>
			</tr>
			<tr>
				<td class="label lblBodyType"><s:text name="款式工艺"></s:text></td>
				<td colspan="3" id="_view_assembleProcess"></td>
			</tr>
			<tr>
				<td class="label lblBodyType"><s:text name="特殊工艺"></s:text></td>
				<td colspan="3" id="_view_assemblespecialProcess"></td>
			</tr>
			<tr>
				<td class="label lblPubMember"><s:text name="类似品牌"></s:text>
				</td>
				<td id="_view_assemblebrands"></td>
				<td class="label lblReceiver"><s:text name="默认面料"></s:text>
				</td>
				<td id="_view_assembledefaultFabric"></td>
			</tr>
			<tr>
				<td class="label lblPubMember"><s:text name="适用面料"></s:text></td>
				<td colspan="3" id="_view_assemblefabrics"></td>
			</tr>
			<tr>
				<td class="label lblBodyType"><s:text name="中文标题"></s:text></td>
				<td colspan="3" id="_view_assembletitleCn"></td>
			</tr>
			<tr>
				<td class="label lblBodyType"><s:text name="英文标题"></s:text></td>
				<td colspan="3" id="_view_assembletitleEn"></td>
			</tr>
			<tr>
				<td class="label lblPubDate"><s:text name="创建人"></s:text>
				</td>
				<td id="_view_created" colspan="1"></td>
	
				<td class="label lblPubDate"><s:text name="创建时间"></s:text>
				</td>
				<td id="_view_pubDate" colspan="1"></td>
			</tr>
		</table>
	</div>
</div>