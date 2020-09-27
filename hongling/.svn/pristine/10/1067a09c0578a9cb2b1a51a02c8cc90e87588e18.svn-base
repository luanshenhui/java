<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="../distribution/edit.js">
</script>
<%
	java.util.HashMap map=new HashMap();
	map.put(1, "陆运");
	map.put(2, "海运");
	map.put(3, "空运");
	request.setAttribute("map", map);
	
	java.util.HashMap st=new HashMap();
	st.put(1, "是");
	st.put(2, "否");
	request.setAttribute("st", st);
 %>
<form id="form_edit" class="form_template">
<input type="hidden" id="ID" name="ID" >
<h1>添加物流方式</h1>
<table>
	<tr>
		<td class="label star">始发地</td>
		<td><input type="text"  id="sendto"  value="红领" readonly="readonly" class="textbox"/></td>
		<td class="label star">目的地</td>
		<td><input type="text"  id="sendend"  class="textbox"/></td>
	</tr>
	<tr>
		<td class="label star">物流公司</td>
		<td><select id="company" ></select></td>
		<td class="label star">物流方式</td>
		<td>
		<s:select list="#request.map"  name="sendmode" id="sendmode" listKey="key" listValue="value" >
		</s:select>
		</td>
	</tr>
	<tr>
		<td class="label">订单数量</td>
		<td><input type="text" id="sendcount"   class="textbox"/></td>
		<td class="label star">是否有效</td>
		<td>
			<s:select list="#request.st"  name="status" id="status" listKey="key" listValue="value" >
		</s:select>
		</td>
	</tr>
	<tr>
		<td class="label star">套装运费</td>
		<td><input type="text"  id="MT_Price"   class="textbox"/></td>
		<td class="label star">上衣运费</td>
		<td><input type="text"  id="MXF_Price"   class="textbox"/></td>
	</tr>
	<tr>
		<td class="label star">西裤运费</td>
		<td><input type="text"  id="MXK_Price"   class="textbox"/></td>
		<td class="label star">大衣运费</td>
		<td><input type="text"  id="MDY_Price"   class="textbox"/></td>
	</tr>
	<tr>
		<td class="label star">马甲运费</td>
		<td><input type="text"  id="MMJ_Price"   class="textbox"/></td>
		<td class="label star">西裙运费</td>
		<td><input type="text"  id="MXQ_Price"   class="textbox"/></td>
	</tr>
	<tr>
		<td class="label star">衬衣运费</td>
		<td><input type="text"  id="MCY_Price"   class="textbox"/></td>
		<td class="label star">配饰运费</td>
		<td><input type="text"  id="MPO_Price"   class="textbox"/></td>
	</tr>
</table>
<div class="operation">
	<a id="btnSave">提交</a> <a id="btnCancel" onclick="$.csCore.close();">取消</a>
</div>
</form>

