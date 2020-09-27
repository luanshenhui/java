<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="../fabricwareroom/changeRate.js"></script>
<form id="form" class="form_template">
<input type="hidden" id="ID"/>
<h1>更改汇率</h1>
<table>
	<tr>
		<td class="label star">人民币对美元汇率</td>
		<td><input type="text" id="usrate"  class="textbox" style="width:100px;"/></td>
	</tr>
	<tr>
		<td class="label star">美元对人民币汇率</td>
		<td><input type="text" id="cnrate"  class="textbox" style="width:100px;"/></td>
	</tr>
</table>
<div class="operation">
	<a id="btnSave">提交</a>
</div>
<br/><br/>
<div id="info" align="center" style="color:orange; font-size: 11px;"></div>
</form>