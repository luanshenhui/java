<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/orden/pre_commit.js"></script>
<form id="form" class="form_template">
<input type="hidden" id="pre_ordenID"/>
<input type="hidden" id="type"/>
<div style="padding-left:100px;padding-bottom: 10px;">
	<label><input type="radio" name="fabric" onclick="$.csPre_commit.hongling_show()" value="1"/><s:text name="pre_fabricHL"/></label>
	<label><input type="radio" name="fabric" onclick="$.csPre_commit.kg_show()" value="2"/><s:text name="pre_fabricKG"/></label>
</div>
<div id="kgxx" style="display: none;">
	<table style="width:350px;">
		<tr>
			<td><s:text name="pre_tg"/></td>
			<td>
				<select id="tg" style="width:160px;">
					<option value="素色" title="<s:text name="pre_tgSe"/>"><s:text name="pre_tgSe"/></option>
					<option value="条纹" title="<s:text name="pre_tgTw"/>"><s:text name="pre_tgTw"/></option>
					<option value="横条纹" title="<s:text name="pre_tgHtw"/>"><s:text name="pre_tgHtw"/></option>
					<option value="方格" title="<s:text name="pre_tgFg"/>"><s:text name="pre_tgFg"/></option>
					<option value="阴阳纹" title="<s:text name="pre_tgYyw"/>"><s:text name="pre_tgYyw"/></option>
					<option value="花色" title="<s:text name="pre_tgHs"/>"><s:text name="pre_tgHs"/></option>
					<option value="斜纹" title="<s:text name="pre_tgXw"/>"><s:text name="pre_tgXw"/></option>
					<option value="提花" title="<s:text name="pre_tgTh"/>"><s:text name="pre_tgTh"/></option>
					<option value="素色倒顺毛" title="<s:text name="pre_tgSeDsm"/>"><s:text name="pre_tgSeDsm"/></option>
					<option value="条纹倒顺毛" title="<s:text name="pre_tgTwDsm"/>"><s:text name="pre_tgTwDsm"/></option>
					<option value="方格倒顺毛" title="<s:text name="pre_tgTwDsm"/>"><s:text name="pre_tgFgDsm"/></option>
					<option value="阴阳纹倒顺毛" title="<s:text name="pre_tgYywDsm"/>"><s:text name="pre_tgYywDsm"/></option>
					<option value="花色倒顺毛" title="<s:text name="pre_tgHsDsm"/>"><s:text name="pre_tgHsDsm"/></option>
					<option value="斜纹倒顺毛" title="<s:text name="pre_tgXwDsm"/>"><s:text name="pre_tgXwDsm"/></option>
					<option value="提花倒顺毛" title="<s:text name="pre_tgThDsm"/>"><s:text name="pre_tgThDsm"/></option>
					<option value="横阴阳条纹" title="<s:text name="pre_tgHyytw"/>"><s:text name="pre_tgHyytw"/></option>
				</select>
				</td>
		</tr>
		<tr>
			<td><s:text name="pre_tgkd"/></td>
			<td><input type="text" id="tgkd"/> (cm)</td>
		</tr>
		<tr>
			<td><s:text name="pre_fk"/></td>
			<td><input type="text" id="fk"/> (m)</td>
		</tr>
	</table>
</div>
<div class="operation" style="padding-top: 20px;">
	<a id="btnSubmit" onclick="$.csPre_commit.commit()"><s:text name="btnSubmitOrden"></s:text></a> <a id="btnCancel" onclick="$.csCore.close()"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>


