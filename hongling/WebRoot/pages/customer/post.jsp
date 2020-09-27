<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="../customer/post.js"></script>
<script language= "javascript" src="../customer/customer.js"></script>
<div id="all">
<div id="orden_temp_list" class="form_myOrden show">
	<div class="orden_label"><h1></h1></div>
	<div id="OrdensResult"></div>
</div>
<form id="customer_form"  class="form_template show">
<div class="customer_label"><h1></h1></div>
<div id="container_customer_info"></div>
</form>
</div>
<div id="orden_do"></div>
<textarea  id="OrdensTemplate" class="list_template">
	 <table class="list_orden_result">
		<tr class="header">
		    <td class="lblNum"></td>
			<td class="lblClothing"></td>
			<td class="lblFabric"></td>
			<td class="lblSizeCategory"></td>
			<td class="lblCount"></td>
			<td class="lblRemove"></td>
		</tr>
		{#foreach $T.data as row}
		<tr id="row{$T.row.ordenID}">
			<td id="num{$T.row.ordenID}"></td>
			<td>{$T.row.clothingName}
				<div id="img{$T.row.ordenID}"></div>
				<div class="preview" onclick="$.csCustomerPost.browseTempOrden('{$T.row.ordenID}')"></div>
			</td>
			<td><input type='text' style="width:80px;" id="fabric_{$T.row.ordenID}" value="{$T.row.fabricCode}"/></td>
			<td>{$T.row.sizeCategoryName}</td>
			<td class="center" id="count{$T.row.ordenID}"></td>
			<td class="center"><a class="remove" onclick="$.csCustomerPost.removeTempOrdenConfirm('{$T.row.ordenID}')"></a></td>
		</tr>
		{#/for}
	</table> 
	<s:if test="#session.company.submit==10051">
		<div style='float:right;width:150px;height:95px;'></div>
	</s:if>
	<s:else>
   		<div id='btnSubmitOrdens' class="submitOrdens" onclick="$.csCustomerPost.submitOrdens()"></div>
	</s:else> 
	<div id="btnSaveOrdens" class="saveOrdens" onclick="$.csCustomerPost.saveOrdens('${company.returnorder}')"></div>
</textarea >

<div class="pay_bj" id="pay_bj" style="display: none;">
	<div>
		<div class="pay_close" onclick="$.csCustomerPost.ordenPay(0)"></div>
		<div id="pay_title" class="pay_title"></div>
	</div>
	<div>
		<div id="pay_zfb" class="pay_zfb" onclick="$.csCustomerPost.ordenPay(1)"></div>
		<div id="pay_paypail" class="pay_paypail" onclick="$.csCustomerPost.ordenPay(2)"></div>
	</div>
</div>
<div class="pay_bj" id="pay_srbj" style="display: none;">
	<div>
		<div class="pay_close" onclick="$.csCustomerPost.ordenSrPay(0)"></div>
		<div id="pay_title" class="pay_title"></div>
	</div>
	<div>
		<div id="pay_srjh" class="pay_zfb" onclick="$.csCustomerPost.ordenSrPay(1)">建行支付</div>
		<div id="pay_qt" class="pay_paypail" onclick="$.csCustomerPost.ordenSrPay(2)">红领支付</div>
	</div>
</div>
<div id="alipay_submit"></div>	
	
	
	