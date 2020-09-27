<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>RCMTM</title>
<link href='<%=request.getContextPath()%>/themes/default/orden.css' type='text/css' rel='stylesheet' />
<script language="javascript" src="<%=request.getContextPath()%>/scripts/jsp9.js"></script>
<link rel="shortcut icon" href="<%=request.getContextPath()%>/pages/common/rcmtm.ico" />
<script language="javascript" src="<%=request.getContextPath()%>/pages/size/sizejsp9.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/pages/customer/customerjsp.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/pages/orden/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/pages/orden/editOrden1.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/pages/orden/orderProcess.js"></script>
<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
<meta http-equiv='pragma' content='no-cache' />
<meta http-equiv='cache-control' content='no-store' />
<meta http-equiv='expires' content='0' />
<style type="text/css">
#bg {
	position: absolute;
	top: 0%;
	left: 0%;
	width: 100%;
	height: 100%;
	background-color: black;
	z-index: 1001;
	-moz-opacity: 0.7;
	opacity: .70;
	filter: alpha(opacity =     70);
}

#show {
	position: absolute;
	top: 25%;
	left: 32%;
	width: 30%;
	height: 5%;
	padding: 8px;
	border: 8px solid #E8E9F7;
	background-color: white;
	z-index: 1002;
	overflow: auto;
	font-weight: bold;
	color: black;
	text-align: center;
}

.partModel {
	border-style: solid;
	border-width: 1px;
	border-color: #626061;
	border-color: black;
	margin-bottom: 5px;
	padding: 5px
}

</style>
</head>
<body>
	<s:hidden id="ordenID2" name="orden.OrdenID"></s:hidden>
	<s:hidden id="copyFlag" name="copyFlag"></s:hidden>
	<s:hidden id="isInit" name="isInit" ></s:hidden>
	<div style="width:1400px;">
		<div
			style="height:10px;padding-left:550px;">
		</div>
		<div id="page_url" style="width:1010px;padding-left:200px;"></div>
	</div>
	<%-- 遮罩层 --%>
	<div id="shade" style="display: none;position:fixed;top: 0%;width: 100%;height: 100%">
		<div id="bg"></div>
		<div id="show">
			<s:text name="lblSubmit"></s:text>
		</div>
	</div>
	<!-- 返回订单列表 -->
	<div id="containter_out"
		style="border-style:solid;border-width:1px;border-color: #626061;margin-bottom:5px;padding: 10px 40px;">
		<div class="dialog-tc2">
			<div style="float:right;">
				<a onclick="javascript:self.location=document.referrer;"> &lt;&lt; <s:text
						name="returnOrdenList" /> </a> <span class="dialog-title"></span>
			</div>
		</div>

		<form id="form" class="form_template">
			<input type="hidden" name="ordenID" id="ordenID" /> <input
				type="hidden" id="isAlipay" /> <input type="hidden" id="isPay" />
			<input type="hidden" id="addText"
				value="<s:text name="btnCreateFabric"></s:text>" /> <input
				type="hidden" id="pleaseSelect"
				value="<s:text name="lblPleaseSelect"></s:text>" />
			<h1>
				<s:if test=" 0== copyFlag">
					<s:text name="Common_Edit"></s:text>
				</s:if>
				<s:else>
					<s:text name="Orden_Redo"></s:text>
				</s:else>
			</h1>

			<table>
				<tr>
					<td align="left">
						<!-- 产品信息 -->
						<div class="label ordentitle">
							<s:text name="lblClothingInfo"></s:text>
						</div>
						<div id="container_clothings">
							<ul>
								<s:iterator value="dicts" var="dict_temp">
									<li>
									<s:if test="#dict_temp.ID==orden.ClothingID">
										<label class="clothRadioChecked">
									</s:if>
									<s:else>
										<label>
									</s:else>
									<s:if test="#dict_temp.ID==orden.ClothingID">
										<input type='radio' name='clothingID' checked="checked"
													value='${ID}' onclick='$.csOrdenPost.clothingChange(${ID});' />
									</s:if>
									
									<s:else>
										<input type='radio' name='clothingID'
												value='${ID}' onclick='$.csOrdenPost.clothingChange(${ID});' />
									</s:else>
											<s:property value="name" /> </label>
									</li>
								</s:iterator>
							</ul>
						</div>
						<!-- 客户信息 -->
						<div class="label lblCustomer clear ordentitle">
							<s:text name="lblCustomer"></s:text>
						</div>
						<div id="container_customer" style="padding-left: 40px">
							<table style="width: 70%;" align="left">
								<tr>
									<td class="label lblCustomerNo" width="25%"><s:text
											name="lblCustomerNo"></s:text></td>
									<td colspan="2"><input type="text" id="userNo" name="userNo" class="textbox" value="${orden.userordeNo}" maxlength="32"/></td>
								</tr>
								<tr>
									<td class="label lblName star"><s:text name="lblCustomerName"></s:text></td>
									<td colspan="2">
										<input type="hidden" name="ID" id="ID" value="${customer.ID}"/>
										<s:if test="#session.company.iscompany == 10051 && #session.company.singOnBean.customerName != '' && #session.company.singOnBean.customerName != null">
											<input type="text" id="name" name="name" class="textbox" maxlength="50" value="<s:property value='#session.company.singOnBean.customerName'/>"  disabled />
										</s:if>
										<s:else>
											<input type="text" id="name" name="name" class="textbox" maxlength="50" value="<s:property value='customer.name'/>"/>
										</s:else></td>
								</tr>
								<tr>
									<td class="label lblGender star"><s:text name="lblGender"></s:text>
									</td>
									<td colspan="2"><select id="genderID" name="genderID">
									<s:if test='customer.GenderID == 10040'>
										<option value="10040" selected="selected"><s:text name="Gender_Man"></s:text></option>
										<option value="10041"><s:text name="Gender_Woman"></s:text></option>
									</s:if>
									<s:else>
										<option value="10041" selected="selected"><s:text name="Gender_Woman"></s:text></option>
										<option value="10040"><s:text name="Gender_Man"></s:text></option>
									</s:else>	
											<!-- <option value="10040">
												<s:text name="Gender_Man"></s:text>
											</option>
											<option value="10041"><s:text name="Gender_Woman"></s:text></option> -->
									</select></td>
								</tr>
								<tr>
									<td class="label lblHeight star"><s:text name="lblHeight"></s:text>
									</td>
									<td>
										<input type="text" id="height" name="height" class="textbox" oncontextmenu="return false;" onkeyup="$.csOrdenPost.clearNoNum(this)" style="width:120px;height:18px;" value="<s:property value='customer.Height'/>"/>
									</td>
									<td>
									<select id="heightUnitID" name="heightUnitID"
										class="w80">
											<s:if test='customer.heightUnitID == 10266'>
												<option value="10266" selected="selected">
											</s:if>
											<s:else>
												<option value="10266">
											</s:else>	
											
												<s:text name="HeightUnit_CM"></s:text>
											</option>
											<s:if test='customer.heightUnitID == 10265'>
												<option value="10265" selected="selected">
											</s:if>
											<s:else>
												<option value="10265">
											</s:else>	
												<s:text name="HeightUnit_IN"></s:text>
											</option>
									</select>
									</td>
								</tr>
								<tr>
									<td class="label lblWeight"><s:text name="lblWeight"></s:text>
									</td>
									<td style="width:100px;">
										<input type="text" id="weight" name="weight" class="textbox" oncontextmenu="return false;" onkeyup="$.csOrdenPost.clearNoNum(this)" style="width:120px;height:18px;" value="<s:property value='customer.Weight'/>"/>
									</td>
									<td><select id="weightUnitID" name="weightUnitID"
										class="w80">
											<s:if test='customer.WeightUnitID == 10261'>
												<option value="10261" selected="selected">
											</s:if>
											<s:else>
												<option value="10261">
											</s:else>	
												
												<s:text name="WeightUnit_KG"></s:text>
											</option>
											
											<s:if test='customer.WeightUnitID == 10260'>
												<option value="10260" selected="selected">
											</s:if>
											<s:else>
												<option value="10260">
											</s:else>	
												<s:text name="WeightUnit_GBP"></s:text>
											</option>
									</select>
									</td>
								</tr>
								<tr>
									<td class="label lblEmail"><s:text name="lblEmail"></s:text>
									</td>
									<td colspan="2">
										<input type="text" id="email" name="email" class="textbox" maxlength="100" value="<s:property value='customer.email'/>"/>
									</td>
								</tr>
								<tr>
									<td class="label lblTel star"><s:text name="lblTel"></s:text>
									</td>
									<td colspan="2">
										<input type="text" id="tel" name="tel" class="textbox" maxlength="50" value="<s:property value='customer.tel'/>"/>
									</td>
								</tr>
								<tr>
									<td class="label lblAddress"><s:text name="lblAddress"></s:text>
									</td>
									<td colspan="2">
										<input type="text" id="address" name="address" class="textbox" value="<s:property value='customer.address'/>"  maxlength="300"/>
									</td>
								</tr>
								<tr>
									<td class="label lblLtName"><s:text name="lblLtName"></s:text>
									</td>
									<td colspan="2">
										<input type="text" id="ltName" name="ltName" value="${customer.ltName}" class="textbox" maxlength="4"/>
									</td>
								</tr>
								<tr>
									<td class="label lblMemo"><s:text name="lblMemo"></s:text></td>
										<td colspan="2">
										<textarea id="memos" name="memos" rows="3" cols="25" style="background-color: #FFFAFA;">${customer.memos}</textarea>
									</td>
								</tr>
							</table>
						
						</div> <%-- 面料信息 --%>
						<div class="label clear ordentitle">
							<s:text name="lblFabricInfo"></s:text>
						</div>
						<div style="width: 50%">
							<table class="fabricCode">
							<tr>
								<td class="star label" width="40%"><s:text name="lblFabric"></s:text>
								</td>
								<td>
									<input type="text" id="fabricCode" name="fabricCode"style="width:150px;" value="${orden.fabricCode}" class="textbox" />
									<span></span>
									<div id="fabric_result">${fabric_resultHtml}</div>
									<div id="autoContainer">${autoContainerHtml}</div></td>
							</tr>
						</table>
						</div>
						</td>

					<!-- 产品工艺 -->
					<td class="padding_left20">
						<div class="label lblDetail ordentitle">
							<s:text name="lblDetail"></s:text>
						</div>
						<div id="container_component">
							<s:iterator value="cloth_process" var="cp_temp" id="cp">
								
								<div class='list_search'>
									<s:property value="key_obj.name" />
								</div>
								
								<table id='category_${key_obj.ID}' class='list_result'>
									<tbody>
									${value_obj}
									</tbody>
								</table>
							</s:iterator>
						</div></td>
				</tr>
			</table>

			<%-- 刺绣信息 --%>
			<div class="titleFont">
				<s:text name="lblEmbroid"></s:text>
			</div>
			<div id="container_embroid" style="padding-left: 50px">
				<s:iterator value="cloth_embroid">
					<div class='list_search'>
						<s:property value="key_obj.name" />
						<a onclick='$.csOrdenPost.addEmbroidRow(${key_obj.ID})'><s:text
								name="btnCreateFabric"></s:text> </a>
								<input id='clothing${key_obj.ID}' style='display:none;' value="${temp_obj}"/>
					</div>
					${value_obj}
				</s:iterator>
			</div>

			<%-- 尺寸信息 --%>
			<div class="titleFont" style="margin-top:5px;">
				<s:text name="lblSizeInfo"></s:text>
			</div>
			<div id="container_size" style="width: auto;height: auto;padding-left: 50px">
				<input id="3PCS" type="text" style="display: none;">
				
				<table id="size" style="clear:both;width:100%">
					<tr>
						<td id="size_info">
							<div id="size_category"  style="width:400px;float:left;">
								<ul><li><label><s:text name='Size_Category'/></label></li></ul>
								<ul id="size_categoryUL">${size_category}</ul>
							</div>
							<div id="size_unit"  style="float:right;"><span class="sizeUnit"></span><span id="unitContainer">
								${size_unit}
							</span></div>
							
							<div id="size_area" class="horizontal">
								<s:if test='10054 == orden.sizeCategoryID'>
									${size_area}
								</s:if>
							</div>
							<div id="size_message"></div>
							
							<div id="size_spec_part" class="horizontal">${size_spec_part}</div>
							<div id="jt_size" class="horizontal">${jtSize}</div>
							<div id="size_bodytype" class="horizontal">${size_bodytype}</div>
							
							<div id="style_title" class="horizontal" style="float:left;">
								<span id="styleContainer">
									<s:if test='orden.sizeCategoryID == 10052 && "3000" != orden.ClothingID && "4000" != orden.ClothingID && "2000" != orden.ClothingID && "5000" != orden.ClothingID'>
									${style_title}	
									</s:if>					
								</span>
							</div>
							
							<div class="horizontal">
								<s:if test="orden.morePants == 10050"><%--加单裤--%>
									<s:if test=' "1" == orden.ClothingID || "2" == orden.ClothingID || "4" == orden.ClothingID || "2000" == orden.ClothingID '>
										<label id="more_pants"><input type="checkbox" id="morePants" onclick="$.csSize.changeAmount();" checked="checked" /><p style="display:inline;"><s:text name="more_pants"></s:text></p></label>
									</s:if>
									<label id="more_shirt" style="color: #F54343;font-weight: bold;">
										<s:text name="more_shirt"></s:text>&nbsp;&nbsp;
										<input id="shirtAmount" type="text" value="1" style="width:30px;" onkeypress="if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return false;} " disabled="disabled"/>
									</label>
								</s:if>
								
								<s:else><%--不加单裤--%>
									<s:if test='"1" == orden.ClothingID || "2" == orden.ClothingID || "4" == orden.ClothingID || "2000" == orden.ClothingID '>
										<label id="more_pants"><input type="checkbox" id="morePants" onclick="$.csSize.changeAmount();"/><p style="display:inline;"><s:text name="more_pants"></s:text></p></label>
									</s:if>
									<label id="more_shirt" style="color: #F54343;font-weight: bold;">
										<s:text name="more_shirt"></s:text>&nbsp;&nbsp;
										<input id="shirtAmount" type="text" value="${orden.morePants}" style="width:30px;" onkeypress="if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return false;} "/>
									</label>		
								</s:else>
							</div>
						</td>
						
						<td>
							<div id="size_video">
								<s:if test="orden.sizeCategoryID != 10054">${imgHtml}</s:if>
							</div>
						</td>
						
					</tr>
				</table>
			</div>

			<div id="submitWait" class="operation">
				<a id="btnSaveOrden"><s:text name="btnSaveOrden"></s:text> </a>
				<s:if test="#session.company.submit==10051">
				</s:if>
				<s:else>
					<a id="btnSubmitOrden"><s:text name="btnSubmitOrden"></s:text>
					</a>
				</s:else>
				<a id="btnCancelOrden"><s:text name="btnCancelOrden"></s:text> </a>
			</div>
		</form>
	</div>
	<div class="pay_bj" id="pay_bj" style="display: none;">
		<div>
			<div class="pay_close" onclick="$.csOrdenPost.ordenPay(0)"></div>
			<div id="pay_title" class="pay_title">
				<s:text name="pay_title"></s:text>
			</div>
		</div>
		<div>
			<div id="pay_zfb" class="pay_zfb" onclick="$.csOrdenPost.ordenPay(1)">
				<s:text name="pay_zfb"></s:text>
			</div>
			<div id="pay_paypail" class="pay_paypail"
				onclick="$.csOrdenPost.ordenPay(2)">
				<s:text name="pay_paypail"></s:text>
			</div>
		</div>
	</div>

	<div class="pay_bj" id="pay_srbj" style="display: none;">
		<div>
			<div class="pay_close" onclick="$.csOrdenPost.ordenSrPay(0);"></div>
			<div id="pay_srtitle" class="pay_title">
				<s:text name="pay_title"></s:text>
			</div>
		</div>
		<div>
			<div id="pay_srjh" class="pay_zfb"
				onclick="$.csOrdenPost.ordenSrPay(1)">
				<s:text name="pay_srjh"></s:text>
			</div>
			<div id="pay_qt" class="pay_paypail"
				onclick="$.csOrdenPost.ordenSrPay(2)">
				<s:text name="pay_hongling"></s:text>
			</div>
		</div>
	</div>
	<div id="alipay_submit">${param.error}</div>
	<s:if test="#session.SessionKey_srUserID!=null">
		<iframe id="ccbMall" src="http://mall.ccb.com/alliance/getH.htm" height="0" width="0" frameborder="0" style="display:none" ></iframe>
		<script type="text/javascript">
		  var my_width  = Math.max(document.documentElement.clientWidth,document.body.clientWidth);
		  var my_height = Math.max(document.documentElement.clientHeight,document.body.clientHeight);
		  var ccbMall_iframe = document.getElementById("ccbMall");
		  ccbMall_iframe.src = ccbMall_iframe.src+"#"+my_height+"|"+my_width;
		</script>
	</s:if>
</body>
</html>