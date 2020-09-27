<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
 <script src="<%=request.getContextPath() %>/pages/orden/commonlist.js"></script> 
<script src="<%=request.getContextPath() %>/pages/orden/postjsp.js"></script>
<!-- 遮罩层--正在提交... -->
<style type="text/css">
    #bg{position: absolute;  top: 0%;  left: 0%;  width: 100%;  height: 100%;  background-color: black;  z-index:1001;  -moz-opacity: 0.7;  opacity:.70;  filter: alpha(opacity=70);}
    #show{position: absolute;  top: 25%;  left: 32%;  width: 30%;  height: 5%;  padding: 8px;  border: 8px solid #E8E9F7;  background-color: white;  z-index:1002;  overflow: auto;font-weight: bold;color: black;text-align: center;}
</style>
<div id="shade" style="display: none;"><div id="bg"></div><div id="show"><s:text name="lblSubmit"></s:text></div></div>
<!-- 遮罩层 -->
<form id="form" class="form_template">
<input type="hidden" name="ordenID" id="ordenID"/>
<input type="hidden" id="isAlipay"/>
<input type="hidden" id="isPay"/>
<input type="hidden" id="addText" value="<s:text name="btnCreateFabric"></s:text>"/>
<input type="hidden" id="pleaseSelect" value="<s:text name="lblPleaseSelect"></s:text>"/>
<h1><s:text name="add"></s:text></h1>
<table class="hline">
	<tr>
		<td>
			<div class="label lblClothingInfo"><s:text name="lblClothingInfo"></s:text></div>
			<div id="container_clothings"></div>
			<div class="label lblCustomer clear"><s:text name="lblCustomer"></s:text></div>
			<div id="container_customer"></div>
			<div class="label clear lblFabricInfo"><s:text name="lblFabricInfo"></s:text></div> 
			<table>
				<tr>
					<td class="lblFabric star label" style="width:80px;"><s:text name="lblFabric"></s:text></td>
					<td>
						<input type="text" id="fabricCode" name="fabricCode" style="width:150px;" class="textbox"/><span></span>
						<div id="fabric_result"></div>
						<div id="autoContainer"></div>
					</td>
				</tr>
			</table>
		</td>
		<td class="padding_left20">
			<div class="label lblDetail"><s:text name="lblDetail"></s:text></div>
			<div id="container_component">
			</div>
		</td>
	</tr>
</table>
<div class="label lblEmbroid"><s:text name="lblEmbroid"></s:text></div><div id="container_embroid"></div>
<div class="label lblSizeInfo" style="margin-top:5px;"><s:text name="lblSizeInfo"></s:text></div>
<div id="container_size"></div>
<div id="submitWait" class="operation">
	<a id="btnSaveOrden" ><s:text name="btnSaveOrden"></s:text></a>
	<s:if test="#session.company.submit==10051">
	</s:if>
	<s:else>
	    <a id="btnSubmitOrden"><s:text name="btnSubmitOrden"></s:text></a> 
	</s:else> 
	<a id="btnCancelOrden"><s:text name="btnCancelOrden"></s:text></a>
</div>
</form>
<div class="pay_bj" id="pay_bj" style="display: none;">
	<div>
		<div class="pay_close" onclick="$.csOrdenPost.ordenPay(0)"></div>
		<div id="pay_title" class="pay_title"><s:text name="pay_title"></s:text></div>
	</div>
	<div>
		<div id="pay_zfb" class="pay_zfb" onclick="$.csOrdenPost.ordenPay(1)"><s:text name="pay_zfb"></s:text></div>
		<div id="pay_paypail" class="pay_paypail" onclick="$.csOrdenPost.ordenPay(2)"><s:text name="pay_paypail"></s:text></div>
	</div>
</div>
<div class="pay_bj" id="pay_srbj" style="display: none;">
	<div>
		<div class="pay_close" onclick="$.csOrdenPost.ordenSrPay(0)"></div>
		<div id="pay_srtitle" class="pay_title"><s:text name="pay_title"></s:text></div>
	</div>
	<div>
		<div id="pay_srjh" class="pay_zfb" onclick="$.csOrdenPost.ordenSrPay(1)"><s:text name="pay_srjh"></s:text></div>
		<div id="pay_qt" class="pay_paypail" onclick="$.csOrdenPost.ordenSrPay(2)"><s:text name="pay_hongling"></s:text></div>
	</div>
</div>
<div id="alipay_submit"></div>