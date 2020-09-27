<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="../customer/customerjsp.js"></script>
<table>
	<tr>
		<td class="label lblCustomerNo"><s:text name="lblCustomerNo"></s:text></td>
		<td colspan="2" ><input type="text" id="userNo" name="userNo" class="textbox" maxlength="32"/></td>
	</tr>
	<tr>
		<td class="label lblName star"><s:text name="lblCustomerName"></s:text></td>
		<td colspan="2" ><input type="hidden" name="ID" id="ID"/>
		<s:if test="#session.company.iscompany == 10051 && #session.company.singOnBean.customerName != '' && #session.company.singOnBean.customerName != null">
		<input type="text" id="name" name="name" class="textbox" maxlength="50" value="<s:property value="#session.company.singOnBean.customerName" />" disabled/>
		</s:if>
		<s:else>
		   <input type="text" id="name" name="name" class="textbox" maxlength="50"/>
		</s:else> 
		</td>
	</tr>
	<tr>
		<td class="label lblGender star"><s:text name="lblGender"></s:text></td>
		<td colspan="2"><select id="genderID" name="genderID">
							<option value="10040"><s:text name="Gender_Man"></s:text></option>
							<!-- <option value="10041"><s:text name="Gender_Woman"></s:text></option> -->
						</select>
		</td>
	</tr>
	<tr>
		<td class="label lblHeight star"><s:text name="lblHeight"></s:text></td>
		<td><input type="text" id="height" name="height" class="textbox" oncontextmenu="return false;" onkeyup="$.csCustomer.clearNoNum(this)" style="width:120px;height:18px;"/></td>
		<td><select id="heightUnitID" name="heightUnitID" class="w80">
				<option value="10266"><s:text name="HeightUnit_CM"></s:text></option>
				<option value="10265"><s:text name="HeightUnit_IN"></s:text></option>
		</select></td>
	</tr>
	<tr>
		<td class="label lblWeight"><s:text name="lblWeight"></s:text></td>
		<td style="width:100px;"><input type="text" id="weight" name="weight" oncontextmenu="return false;" onkeyup="$.csCustomer.clearNoNum(this)" class="textbox" style="width:120px;height:18px;"/></td>
		<td><select id="weightUnitID" name="weightUnitID" class="w80">
				<option value="10261"><s:text name="WeightUnit_KG"></s:text></option>
				<option value="10260"><s:text name="WeightUnit_GBP"></s:text></option>
		</select></td>
	</tr>
	<tr>
		<td class="label lblEmail"><s:text name="lblEmail"></s:text></td>
		<td colspan="2"><input type="text" id="email" name="email" class="textbox" maxlength="100"/></td>
	</tr>
	<tr>
		<td class="label lblTel star"><s:text name="lblTel"></s:text></td>
		<td colspan="2"><input type="text" id="tel" name="tel" class="textbox" maxlength="50"/></td>
	</tr>
	<tr>
		<td class="label lblAddress"><s:text name="lblAddress"></s:text></td>
		<td colspan="2"><input type="text" id="address" name="address" class="textbox"  maxlength="300"/></td>
	</tr>
	<tr>
		<td class="label lblLtName"><s:text name="lblLtName"></s:text></td>
		<td colspan="2"><input type="text" id="ltName" name="ltName" class="textbox" maxlength="4"/></td>
	</tr>
	<tr>
		<td class="label lblMemo"><s:text name="lblMemo"></s:text></td>
		<td colspan="2"><input type="text" id="memos" name="memos" class="textbox"/></td>
	</tr>
</table>