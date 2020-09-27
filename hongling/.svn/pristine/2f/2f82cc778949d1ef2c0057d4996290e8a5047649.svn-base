<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<script type="text/javascript" src="../fabricwareroom/import.js"></script>
<script type="text/javascript" src="../fabricwareroom/ajaxfileupload.js"></script>

<form id="import" enctype="multipart/form-data"
	class="form_template">
	<input type="hidden" name="ID" id="ID" /> <input type="hidden"
		id="ID" />
	<h1></h1>
	<table>
		<tr>
			<td align="left"><s:label value="标准模板Excel从左到右如下："></s:label></td>
		</tr>
		<tr>
			<td align="left">电商编码,成份,纱支,克重,分类,花型,色系,属性,单价,产地,单位,状态,品牌,备注</td>
		</tr>
		<tr>
			<td><input   type="file" id="uploadFile" name="uploadFile">
			</td>
		</tr>
		<tr>
			<td></td>
		</tr>
	</table>
	<div id="upbar" class="operation">
		<a id="btnSave" /> <a id="btnCancel" />
	</div>
	<div id="loadShow" style="display: none">
		<label>正在检验数据,请不要关闭页面</label><Br/> <img alt=""
			src="<%=request.getContextPath()%>/pages/fabricwareroom/loadimg.gif">
	</div>
</form>