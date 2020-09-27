<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/pages/member/postjsp.js"></script>
<form id="form" class="form_template">
<input type="hidden" name="ID" id="ID"/>
<h1></h1>
<br/>
<div style="padding-right: 55px;" align="right">
	<label>
		cameo logo<input type="checkbox" id="isCameoLogo" name="isCameoLogo" class="textbox"/>
	</label>
	&nbsp;&nbsp;&nbsp;
	<label>
		<s:text name="blLblDiscount"/>
		<input type="checkbox" id="isDiscount" name="isDiscount" class="textbox"/>
	</label>
	&nbsp;&nbsp;&nbsp;
	<label>
		<s:text name="lblCustomerNo"/>
		<input type="checkbox" id="isUserNo" name="isUserNo" class="textbox"/>
	</label>
	&nbsp;&nbsp;&nbsp;
	<label>
		<s:text name="blSemiFinished"/>
		<input type="checkbox" id="semiFinished" name="semiFinished" class="textbox"/>
	</label>
</div>
<br/>
<table>
	<tr>
		<td class="label star lblParentName"><s:text name="lblParentUsername"></s:text></td>
		<td><input type="text" id="parentName" name="parentName" class="textbox" style="width:160px"/><input type="hidden" id="parentID"/></td>
		<td class="label star lblUsername"><s:text name="lblName"></s:text></td>
		<td><input type="text" id="username" class="textbox" class="textbox" style="width:160px"/></td>
		<td class="label star lblHomePage"><s:text name="lblHomePage"></s:text></td>
		<td><select id="homePage" style="width:162px"></select></td>
	</tr>
	<tr>
		<td class="label lblGroup"><s:text name="lblGroup"></s:text></td>
		<td><select id="groupID" style="width:162px"></select></td>
		<td class="label star lblPayType"><s:text name="lblPayType"></s:text></td>
		<td><select id="payTypeID" style="width:162px"></select></td>
		<td class="label lblMto"><s:text name="lblMto"></s:text></td>
		<td><select id="isMTO" style="width:162px"></select></td>
	</tr>
	<tr>
		<td class="label star lblName"><s:text name="Name"></s:text></td>
		<td><input type="text" id="name" class="textbox" style="width:160px"/></td>
		<td class="label star lblContact"><s:text name="lblContact"></s:text></td>
		<td><input type="text" id="phoneNumber" class="textbox" style="width:160px"/></td>
		<td class="label lblStatus"><s:text name="lblStatus"></s:text></td>
		<td><select id="statusID" style="width:162px"></select></td>
	</tr>
	<tr>
		<td class="label star lblPassword"><s:text name="lblPassword"></s:text></td>
		<td><input id="password" type="password" class="textbox" style="width:160px"/></td>
		<td class="label star lblVerifyPassword"><s:text name="lblVerifyPassword"></s:text></td>
		<td><input id="verifyPassword" type="password" class="textbox" style="width:160px"/></td>
		<td class="label blLblMoneyKind"><s:text name="blLblMoneyKind"></s:text></td>
		<td><select id="moneySignID" style="width:162px;"></select></td>
	</tr>
	<tr>
		<td class="label star lblNoticeNum"><s:text name="lblNoticeNum"></s:text></td>
		<td><input id="noticeNum" name="noticeNum" type="text" class="textbox"  style="width:160px"/><span id="tip_noticeUnit"></span></td>
		<td class="label star lblStopNum"><s:text name="lblStopNum"></s:text></td>
		<td><input id="stopNum" name="stopNum" type="text" class="textbox"  style="width:160px"/><span id="tip_stopUnit"></span></td>
		<td class="label star blLblRetailDiscountRate"><s:text name="blLblRetailDiscountRate"></s:text></td>
		<td><input type="text" id="retailDiscountRate" class="textbox"  style="width:160px"/><s:text name="blLblReTailMemo"></s:text></td>
	</tr>
	<tr>
		<td class="label star lblOrdenPre"><s:text name="lblOrdenPre"></s:text></td>
		<td><input maxlength="8" type="text" id="ordenPre" class="textbox" style="width:160px"/></td>
		<td class="label lblFabricPre"><s:text name="lblFabricPre"></s:text></td>
		<td><input type="text" id="fabricPre" class="textbox" style="width:160px"/></td>
		<td class="label lblCompanyShortName"><s:text name="lblCompanyShortName"></s:text></td>
		<td><input type="text" id="companyShortName" class="textbox" style="width:160px"/></td>
	</tr>
	<tr>
		<td class="label star lblCompanyName nowrap"><s:text name="lblCompanyName"></s:text></td>
		<td><input type="text" id="companyName" class="textbox" style="width:160px"/></td>
		<td class="label lblAccount"><s:text name="lblAccount"></s:text></td>
		<td><input type="text" id="account" class="textbox" style="width:160px"/></td>
		<td class="label  lblOwnedPartner"><s:text name="lblOwnedPartner"></s:text></td>
		<td><input type="text" id="ownedPartner" class="textbox"  style="width:160px"/></td>
	</tr>
	<tr>
		<td class="label lblOwnedStore"><s:text name="lblOwnedStore"></s:text></td>
		<td><input type="text" id="ownedStore" class="textbox" style="width:160px"/></td>
		<td class="label lblContractNo"><s:text name="lblContractNo"></s:text></td>
		<td><input type="text" id="contractNo" class="textbox" style="width:160px"/></td>
		<td class="label lblMemo"><s:text name="lblMemo"></s:text></td>
		<td><input type="text" id="memo" class="textbox" style="width:160px"/></td>
	</tr>
	<tr>
		<td class="label star blLblBusinessUnit"><s:text name="blLblBusinessUnit"></s:text></td>
		<td><select id="businessUnit" style="width:162px"></select></td>
		<td class="label star lblPayMode"><s:text name="lblPayMode"></s:text></td>
		<td><select id="shippingPaymentType" style="width:162px"></select></td>
		<td class="label star blLblPriceType"><s:text name="blLblPriceType"></s:text></td>
		<td><select id="priceType" style="width:162px"></select></td>
	</tr>
	<tr>
		<td class="label star blLblBusinessUnit"><s:text name="SSB_MCGYLX"></s:text></td>
		<td><select id="liningType" style="width:162px">
			<option value="000B">半毛衬</option>
			<option value="000A">全毛衬</option>
			<option value="00AA">半手工全毛衬</option>
			<option value="0AAA">全手工全毛衬</option>
			<option value="0AAB">全手工半毛衬</option>
			<option value="0BAA">半手工半毛衬</option>
			<option value="00C1">高档粘合衬</option>
			<option value="00C2">中档粘合衬</option>
			<option value="00C3">单层炭衬、单层肩棉</option>
			<option value="00D1">无组合胸衬</option>
			<option value="001T">单层炭衬、正常垫肩</option>
			<option value="0AAD">全手工、无组合胸衬</option>
			<option value="00AD">半手工、无组合胸衬</option>
		</select></td>
		<td class="label star blLblBusinessUnit"><s:text name="blFabricType"></s:text></td>
		<td><select id="fabricType" style="width:162px">
			<option value="0">MTM面料</option>
			<option value="1">客供成批料</option>
		</select></td>
		<td class="label star lblLTNo nowrap"><s:text name="lblLTNo"></s:text></td>
		<td><input type="text" id="LTNo" class="textbox" style="width:160px"/></td>
	</tr>
	<tr>
		<td class="label star lblCmtPrice"><s:text name="lblCmtPrice"></s:text></td>
		<td colspan="5" >
			<textarea id="cmtPrice" class="textbox" style="width: 700px; margin: 0px; height: 130px;"></textarea>
			<label title="000A:280,000B:210,00C1:160,00C2:160,00C3:160,&#13;00D1:160,0AAA:500,00AA:350,0AAB:450,0BAA:300,&#13;&#13;MXF_000A:230,MXF_000B:150,MXF_00C1:110,&#13;MXF_00C2:110,MXF_00C3:110,MXF_00D1:110,&#13;MXF_0AAA:425,MXF_00AA:298,MXF_0AAB:382,&#13;MXF_0BAA:255,MXF_0AAA:425,MXF_00AA:298,&#13;MXF_0AAB:382,MXF_0BAA:255,&#13;&#13;MXK_000B:50,MXK_0AAA:85,MXK_00AA:52,&#13;MXK_0AAB:68,MXK_0BAA:50,&#13;&#13;MMJ_000A:50,MMJ_000B:50,MMJ_00C1:50,&#13;MMJ_0AAA:80,MMJ_00AA:60,MMJ_0AAB:80,&#13;MMJ_0BAA:60,MMJ_00C2:50,MMJ_00C3:50,&#13;MMJ_00D1:50,&#13;&#13;MCY:32,&#13;&#13;MDY_000A:252,MDY_000B:180,MDY_00C1:144,&#13;MDY_00D1:144,&#13;"><a id="CMT" onclick="$.csMemberPost.copyCMT();"><img src="../../themes/default/images/ts.gif"/></a></label>
		</td>
	</tr>
</table>
<div class="operation">
	<a id="btnSaveMember"><s:text name="btnSubmitOrden"></s:text></a> <a id="btnCancelMember"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>