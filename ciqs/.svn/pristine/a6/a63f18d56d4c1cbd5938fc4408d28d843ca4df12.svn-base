<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>归档详细列表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div{
   width:1000px;
   margin: 5px auto;
}
/* div{
   overflow:auto;
   font-size: 22px;
} */

.tableheadLine {
	border: 1px solid #000;
	font-weight:bold;
}
.chatTitle{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
}
.tableLine {
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
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
</style>
</head>
<body>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<div>
	<div class="chatTitle">归档详细列表</div>
	<div style="font-weight:bold" align="left">&nbsp;1国际航行船舶入境检疫申报环节</div>
	<form id="gdFormId" action="docs" method="post">
		<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.国际航行船舶入境检疫申报
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option1" type="radio" value="1" <c:if test="${doc.option_1=='1'}">checked="checked"</c:if>/> 
				未完成<input name="option1" type="radio" value="0" <c:if test="${doc.option_1=='0'}">checked="checked"</c:if>/>
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				2.附件
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option2" type="radio" value="1" <c:if test="${doc.option_2=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option2" type="radio" value="0" <c:if test="${doc.option_2=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				3.航行中发现可疑病例前期处置资料
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option3" type="radio" value="1" <c:if test="${doc.option_3=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option3" type="radio" value="0" <c:if test="${doc.option_3=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;2准备环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.仪器设备领取记录和使用记录
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option4" type="radio" value="1" <c:if test="${doc.option_4=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option4" type="radio" value="0" <c:if test="${doc.option_4=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				2.通知船方准备的文件清单（电子版）
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option5" type="radio" value="1" <c:if test="${doc.option_5=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option5" type="radio" value="0" <c:if test="${doc.option_5=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.1登轮检疫环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.登轮前事项
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option6" type="radio" value="1" <c:if test="${doc.option_6=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option6" type="radio" value="0" <c:if test="${doc.option_6=='0'}">checked="checked"</c:if>/>
			</td>
		</tr>
		<c:forEach items="${dlFile }" var="v" varStatus="status">
			<tr>
				<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
					<span>${v.name }</span>
				</td>
				<td height="44" align="center" class="tableLine" colspan="2"></td>
			</tr>		
		</c:forEach>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.2文件审核流行病学调查医学</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				航海健康申报书Maritime Declaration of Health
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option8" type="radio" value="1" <c:if test="${doc.option_8=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option8" type="radio" value="0" <c:if test="${doc.option_8=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				总申报单General declaration
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option9" type="radio" value="1" <c:if test="${doc.option_9=='1'}">checked="checked"</c:if>/> 
				未完成<input name="option9" type="radio" value="0" <c:if test="${doc.option_9=='0'}">checked="checked"</c:if>/>
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				货物申报单Cargo declaration
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option10" type="radio" value="1" <c:if test="${doc.option_10=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option10" type="radio" value="0" <c:if test="${doc.option_10=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船用物品清单Ships Stores Declaration
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option11" type="radio" value="1" <c:if test="${doc.option_11=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option11" type="radio" value="0" <c:if test="${doc.option_11=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船员名单Crew list
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option12" type="radio" value="1" <c:if test="${doc.option_12=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option12" type="radio" value="0" <c:if test="${doc.option_12=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				旅客名单Passenger list
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option13" type="radio" value="1" <c:if test="${doc.option_13=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option13" type="radio" value="0" <c:if test="${doc.option_13=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				航次表Ports of call
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option14" type="radio" value="1" <c:if test="${doc.option_14=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option14" type="radio" value="0" <c:if test="${doc.option_14=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				食品饮用水清单(注明供应港口及产地)food drinking water list (note the supplied port and produced region)
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option15" type="radio" value="1" <c:if test="${doc.option_15=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option15" type="radio" value="0" <c:if test="${doc.option_15=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				压舱水申报单IMO ballast water reporting form
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option16" type="radio" value="1" <c:if test="${doc.option_16=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option16" type="radio" value="0" <c:if test="${doc.option_16=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				旅客诊疗记录pessengers medical log
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option17" type="radio" value="1" <c:if test="${doc.option_17=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option17" type="radio" value="0" <c:if test="${doc.option_17=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船员诊疗记录crew medical log
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option18" type="radio" value="1" <c:if test="${doc.option_18=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option18" type="radio" value="0" <c:if test="${doc.option_18=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				可疑病例排查记录
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option19" type="radio" value="1"  <c:if test="${doc.option_19=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option19" type="radio" value="0"  <c:if test="${doc.option_19=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				口岸传染病可疑病例流行病学调查表
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option20" type="radio" value="1" <c:if test="${doc.option_20=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option20" type="radio" value="0" <c:if test="${doc.option_20=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				口岸传染病可疑病例医学排查记录表
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option21" type="radio" value="1" <c:if test="${doc.option_21=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option21" type="radio" value="0" <c:if test="${doc.option_21=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				口岸传染病疑似病例转诊单
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option22" type="radio" value="1" <c:if test="${doc.option_22=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option22" type="radio" value="0" <c:if test="${doc.option_22=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
			<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				入境船舶检疫查验记录表
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option23" type="radio" value="1" <c:if test="${doc.option_23=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option23" type="radio" value="0" <c:if test="${doc.option_23=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.3.1一般卫生监督</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船舶卫生监督登记表
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option24" type="radio" value="1"  <c:if test="${doc.option_24=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option24" type="radio" value="0" <c:if test="${doc.option_24=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船舶卫生监督所见证据汇总
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option25" type="radio" value="1" <c:if test="${doc.option_25=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option25" type="radio" value="0" <c:if test="${doc.option_25=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.3.2专项船舶卫生监督</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船舶卫生监督所见证据汇总
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option26" type="radio" value="1" <c:if test="${doc.option_26=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option26" type="radio" value="0" <c:if test="${doc.option_26=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船舶卫生监督检查记录表
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option27" type="radio" value="1"  <c:if test="${doc.option_27=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option27" type="radio" value="0" <c:if test="${doc.option_27=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				船舶卫生监督评分表
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option28" type="radio" value="1" <c:if test="${doc.option_28=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option28" type="radio" value="0" <c:if test="${doc.option_28=='0'}">checked="checked"</c:if> />
			</td>
			</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				证据汇总
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option29" type="radio" value="1"  <c:if test="${doc.option_29=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option29" type="radio" value="0" <c:if test="${doc.option_29=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.4采样环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				采样环节
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option30" type="radio" value="1" <c:if test="${doc.option_30=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option30" type="radio" value="0" <c:if test="${doc.option_30=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<c:forEach items="${sampRes }" var="samp">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				${samp.SAMP_PROJ}
			</td>
			<td height="44" align="center" class="tableLine" colspan="2"></td>
		</tr>		
		</c:forEach>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.5结果判定环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				检疫查验
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option31" type="radio" value="1" <c:if test="${doc.option_31=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option31" type="radio" value="0" <c:if test="${doc.option_31=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				卫生监督
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option32" type="radio" value="1" <c:if test="${doc.option_32=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option32" type="radio" value="0" <c:if test="${doc.option_32=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				样品实验室
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option33" type="radio" value="1" <c:if test="${doc.option_33=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option33" type="radio" value="0" <c:if test="${doc.option_33=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				检疫处理
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option34" type="radio" value="1" <c:if test="${doc.option_34=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option34" type="radio" value="0" <c:if test="${doc.option_34=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	
	<div style="font-weight:bold" align="left">&nbsp;3.6检疫处理环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.检疫处理通知书
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option35" type="radio" value="1" <c:if test="${doc.option_35=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option35" type="radio" value="0" <c:if test="${doc.option_35=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				2.检疫处理结果报单（处理公司提供）
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option36" type="radio" value="1" <c:if test="${doc.option_36=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option36" type="radio" value="0" <c:if test="${doc.option_36=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				3.检疫处理效果评价（如果有）
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option37" type="radio" value="1" <c:if test="${doc.option_37=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option37" type="radio" value="0" <c:if test="${doc.option_37=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				4.检疫处理证据过程等图片和视频
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option38" type="radio" value="1" <c:if test="${doc.option_38=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option38" type="radio" value="0" <c:if test="${doc.option_38=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;3.7签发证书环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.free pratique 
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option39" type="radio" value="1" <c:if test="${doc.option_39=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option39" type="radio" value="0" <c:if test="${doc.option_39=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				2.pratique
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option40" type="radio" value="1" <c:if test="${doc.option_40=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option40" type="radio" value="0" <c:if test="${doc.option_40=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;4报告和通报环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.通报单（如果有）
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option41" type="radio" value="1" <c:if test="${doc.option_41=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option41" type="radio" value="0" <c:if test="${doc.option_41=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				2.SSCEC标注时照片
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option42" type="radio" value="1" <c:if test="${doc.option_42=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option42" type="radio" value="0" <c:if test="${doc.option_42=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<div style="font-weight:bold" align="left">&nbsp;5涉嫌违法案件申报环节</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				1.检验检疫涉嫌案件申报单
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option43" type="radio" value="1" <c:if test="${doc.option_43=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option43" type="radio" value="0" <c:if test="${doc.option_43=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
		<tr>
			<td height="44" align="left" width="200" class="tableheadLine" colspan="6">
				2.证据
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				完成 <input name="option44" type="radio" value="1" <c:if test="${doc.option_44=='1'}">checked="checked"</c:if> /> 
				未完成<input name="option44" type="radio" value="0" <c:if test="${doc.option_44=='0'}">checked="checked"</c:if> />
			</td>
		</tr>
	</table>
	<input name="ProcMainId" type="hidden" value="${proc_main_id }" />
	</form>
	<input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
	<input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="提交" onclick="submitOnlick()"/>
    <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();"/>
</div>
</body>
<script type="text/javascript">
	function submitOnlick(){
		document.getElementById("gdFormId").submit();
	}
</script>
</html>