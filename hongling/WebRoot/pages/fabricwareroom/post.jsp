<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../fabricwareroom/post.js">
</script>
<form id="form" class="form_template">
<input type="hidden" id="ID"/>
<h1>添加面料库存</h1>
<div style="margin-right: 20px;">
<table>
	<tr>
		<td class="label star">面料编码</td>
		<td><input type="text" id="fabricNo"  class="textbox" /></td>
		<td class="label">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td class="label star">分类</td>
		<td><select id="category" ></select></td>
		<td class="label star">价格</td>
		<td><input type="text" style="width: 80px" id="rmb"  class="textbox"/>(RMB)<input type="text" style="width: 80px" id="dollar" readonly="readonly"  class="textbox"/>($)<span id="rminfo" style="color:orange; font-size: 10px;" ></span></td>
	</tr>
	<tr>
		<td class="label star">颜色</td>
		<td><select id="color" ></select></td>
		<td class="label star">属性</td>
		<td><select id="property"></select></td>
	</tr>
	<tr>
		<td class="label star">花色</td>
		<td><select id="flower" ></select></td>
		<td class="label">纱支</td>
		<td><input type="text"  id="shazhi" class="textbox"/></td>
	</tr>
	<tr>
		<td class="label star">成分</td>
		<td><select id="composition" ></select></td>
		<td class="label">产地</td>
		<td><input type="text"  id="address"  class="textbox"/></td>
	</tr>
	<tr>
		<td class="label star">品牌</td>
		<td><select id="brands" ></select></td>
		<td class="label star">单位</td>
		<td>
			<select id="belong" class="textbox">
				<option>电商</option>
				<option>青岛瑞璞服饰股份有限公司</option>
				<option>青岛rcmtm制衣有限公司</option>
				<option>青岛红领制衣有限公司</option>
				<option>青岛凯妙服饰股份有限公司</option>
				<option>大中华区</option>
				<option>美洲区</option>
				<option>欧洲区</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="label">是否有效</td>
		<td><select id="status" >
			<option value="10050">是</option>
			<option value="10051">否</option>
		</select></td>
		<td class="label">重量</td>
		<td><input type="text"  id="weight"  class="textbox"/></td>
	</tr>
</table>
<div class="operation">
	<a id="btnSave">提交</a> <a id="btnCancel" onclick="$.csCore.close();">取消</a>
</div>
</div>
<br/><br/>
</form>
