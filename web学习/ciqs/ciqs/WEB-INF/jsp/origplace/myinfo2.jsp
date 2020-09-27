<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>发票信息</title>
<%@ include file="/common/resource_show.jsp"%>
<style type="text/css">
<!--
.tableLine {
	border: 1px solid #000;
}

.fangxingLine {
	font-size: 10;
	margin-left: 5px;
	margin-right: 5px;
	border: 2px solid #000;
	font-weight: 900;
	padding-left: 3px;
	padding-right: 3px;
}

.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px;
}

.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}

.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}
/* @media print { */
/* .noprint{display:none} */
/* } */
-->
.title a:link,a:visited {
	color: white;
	text-decoration: none;
}
</style>
</head>
<body class="bg-gary">
	<div class="title-bg">
		<div class=" title-position margin-auto white">
			<div class="title">
				<a href="nav.html" class="white"><span class="font-24px">发票信息</span></a>
			</div>
			<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
		</div>
	</div>
	<div class="blank_div_dtl"></div>
	<div>
		<table width="980px" border="0" align="center"
			style="font-size:14px;line-height:30px;margin-top: 50px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr><td colspan="8">${obj.dec_org_name}</td></tr>
			<tr><td colspan="8">${obj.dec_org_ename}</td></tr>
			<tr>
				<td  align="left" width="50%" style="padding-left: 26px;" colspan="3">TO:${obj.consignee_cname}<br />
				<br />CONTACT PERSON:${obj.contact_person}<br />
				FROM ${obj.from_country}<br/> ${obj.purpose_address}
				</td>
				<td colspan="2"></td>	
				<td  align="left"  width="50%" colspan="3">证书号:${obj.cert_no}
				<br />NO: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${obj.receipt_no}
				<br />DATE:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${obj.receipt_date}
				<br />L/C NO. :${obj.lc_number}
				<br />Contract :${obj.contract_number}
				<br />
				</td>
			</tr>
			<tr><td colspan="8">===========================================================================================</td></tr>
			<tr><td colspan="2">Shipping Marks</td><td colspan="3">Quantities/Descriptions</td><td colspan="3">Unit/Price Amount</td></tr>
			<c:if test="${not empty list}">
				<c:forEach items="${list}" var="row">
					<tr>
						<td colspan="2">${row.mat_no}</td>
						<td colspan="3">${row.num_cag_disc}</td>
						<td colspan="3">${row.fob_type}${row.fob_val}  ${row.fob_type}${row.fob_val_sum}</td>
					</tr>
				</c:forEach>
			</c:if>
			<tr><td colspan="2"></td>
				<td colspan="3">Price Clause:${obj.pric_item}</td>
				<td colspan="3">TOTAL:${list[0].fob_type}${obj.fob_sum}</td>
			</tr>
			<tr><td colspan="2"></td>
				<td colspan="6">---------------------------------------------------------------------------------------------------</td>
			</tr>
			<tr><td colspan="3"></td>
				<td colspan="5" align="left">TOTAL:${obj.m_weight}</td>
			</tr>
			<tr><td colspan="3"></td>
				<td colspan="5" align="left">TOTAL:${obj.pack_num}</td>
			</tr>
			<tr><td colspan="3"></td>
				<td colspan="5" align="left">Special Clause:${obj.spec_item}</td>
			</tr>
		</table>
		<br />
		<p></p>
	</div>
</body>
</html>
