<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>RCMTM</title>
<link rel="shortcut icon"
	href="<%=request.getContextPath()%>/pages/common/rcmtm.ico" />
<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
<meta http-equiv='pragma' content='no-cache' />
<meta http-equiv='cache-control' content='no-store' />
<meta http-equiv='expires' content='0' />

<link href="<%=request.getContextPath()%>/themes/default/style.css"
	rel="stylesheet" type="text/css" />
<script language="javascript"
	src="<%=request.getContextPath()%>/scripts/jsp.js"></script>
<script language="javascript"
	src="<%=request.getContextPath()%>/pages/size/sizejsp.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/pages/customer/customerjsp.js"></script>
<script language="javascript" type="text/javascript">
	var member = $.csCore.getCurrentMember();
	if (member.username == undefined) {
		var realm = window.location.href.split("hongling");
		window.location.href = realm[0] + "hongling";
	}
</script>

<script language="javascript"
	src="<%=request.getContextPath()%>/pages/orden/commonlist.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/pages/orden/addpostjsp.js"></script>
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

body {
	color: #FFFFFF
}

.partModel {
	border-style: solid;
	border-width: 1px;
	border-color: #626061;
	border-color: black;
	margin-bottom: 5px;
	padding: 5px
}

.titleFont {
	font-size: 14px;
	font-weight: bold;
}
.ac_results{
	color:  #FE6003;
}
.dialog-tc2{height:34px; line-height:34px; font-size:14px; width:100%; clear:both;background:#000000; text-align:left;}
.dialog-close{float:right;cursor:pointer;margin:4px 4px 0 0;	height:29px; width:25px;}
#bg{position: absolute;  top: 0%;  left: 0%;  width: 100%;  height: 100%;  background-color: black;  z-index:1001;  -moz-opacity: 0.7;  opacity:.70;  filter: alpha(opacity=70);}
#show{position: absolute;  top: 25%;  left: 32%;  width: 30%;  height: 5%;  padding: 8px;  border: 8px solid #E8E9F7;  background-color: white;  z-index:1002;  overflow: auto;font-weight: bold;color: black;text-align: center;}
</style>
</head>
<body>
	<s:hidden id="ordenID2" name="ordenID2"></s:hidden>
	<s:hidden id="copyFlag" name="copyFlag"></s:hidden>
	<div style="width:1400px;">
		<div
			style="height:50px; margin-top: 20px;margin-bottom: 30px;padding-left:550px;">
		</div>
		<div id="page_url" style="width:1010px;padding-left:200px;"></div>
	</div>
	
	<div id="shade" style="display: none;">
		<div id="bg"></div>
		<div id="show">
			<s:text name="lblSubmit"></s:text>
		</div>
	</div>
	<div id="containter_out" style="border-style:solid;border-width:1px;border-color: #626061;margin-bottom:5px;padding: 40px">
		<div class="dialog-tc2">
			<a class="dialog-close" title="返回"
				onclick="javascript:self.location=document.referrer;"><img src="<%=request.getContextPath()%>/themes/default/img/dialog_close1.png" /></a>
			<span class="dialog-title"></span>
		</div>
		<div id="shade" style="display: none;"><div id="bg"></div><div id="show"><s:text name="lblSubmit"></s:text></div></div>
		<!-- 遮罩层 -->
		<form id="form" class="form_template">
			<input type="hidden" name="ordenID" id="ordenID" /> <input
				type="hidden" id="isAlipay" /> <input type="hidden" id="isPay" />
			<input type="hidden" id="addText"
				value="<s:text name="btnCreateFabric"></s:text>" /> <input
				type="hidden" id="pleaseSelect"
				value="<s:text name="lblPleaseSelect"></s:text>" />
			<h1>
				<s:text name="add"></s:text>
			</h1>

				<table class="hline">
					<tr>
						<td width="50%" align="left">
							<!-- 产品信息 -->
							<div class="label lblClothingInfo">
								<s:text name="lblClothingInfo"></s:text>
							</div>
							<div id="container_clothings"></div> <!-- 客户信息 -->
							<div class="label lblCustomer clear">
								<s:text name="lblCustomer"></s:text>
							</div>
							<div id="container_customer"></div> <!-- 面料信息 -->
							<div class="label clear lblFabricInfo">
								<s:text name="lblFabricInfo"></s:text>
							</div>
							<table>
								<tr>
									<td class="lblFabric star label" style="width:80px;"><s:text
											name="lblFabric"></s:text>
									</td>
									<td><input type="text" id="fabricCode" name="fabricCode"
										style="width:150px;" class="textbox" /><span></span>
										<div id="fabric_result"></div>
										<div id="autoContainer"></div></td>
								</tr>
							</table></td>
						<!-- 产品工艺 -->
						<td class="padding_left20">
							<div class="label lblDetail">
								<s:text name="lblDetail"></s:text>
							</div>
							<div id="container_component"></div></td>
					</tr>
				</table>
			
			<!-- 刺绣信息 -->
			<div class="titleFont">
				<s:text name="lblEmbroid"></s:text>
			</div>
			<div id="container_embroid"></div>

			<!-- 尺寸信息 -->
			<div class="titleFont" style="margin-top:5px;">
				<s:text name="lblSizeInfo"></s:text>
			</div>
			<div id="container_size" style="width: auto;height: auto"></div>

			<div class="operation">
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
			<div class="pay_close" onclick="$.csOrdenPost.ordenSrPay(0)"></div>
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
	<s:debug></s:debug>
</body>
</html>