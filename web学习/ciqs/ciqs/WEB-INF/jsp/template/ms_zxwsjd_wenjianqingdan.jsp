<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>船舶卫生监督检查记录表
</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css">
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css">
<style type="text/css">
body div{
   width:1000px;
   margin: 5px auto;
}
/* div{
   overflow:auto;
   font-size: 22px;
} */
.chatTitle{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
}
.tableheadLine {
	border: 1px solid #000;
	font-weight:bold;
}
.tableLine{
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
	<div class="chatTitle">船舶检查文件清单</div>
	<div class="chatTitle">List of  certificate and documents required for ship sanitation inspections</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td  height="44" align="center" class="tableheadLine"  colspan="2">
				种类
			</td>
			<td  height="44" align="center" class="tableheadLine" colspan="4" >
				名称
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine" >
				检查结果Results			
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine" >
				所在位置Location
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" colspan="2" rowspan="2">
				A（卫生条例相关文件）IHR-related documents
			</td>
			<td height="44" align="center" class="tableheadLine" colspan="4">
				已办理的船舶卫生证书/船舶免予卫生证书/船舶卫生证书延期证明 <br/>
				Ship Sanitation control (/exemption)Certificate,<br/>
				Extension of the ship sanitation certificate<br/>
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_1 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_1 == '1'}">checked="checked"</c:if>/> <br/>   
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_2}
			</td>
		</tr>
		<tr>
				
			<td height="44" align="center" class="tableheadLine" colspan="4">
				国际疫苗接种证书清单Vaccination list
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_3 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_3 == '1'}">checked="checked"</c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_4}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" rowspan="4" colspan="2">
				B[国际海事组织（IMO）《1965年便利国际海上运输公约》（2006年修订版）中有关评价公共卫生风险所需的其它文件] Other documents, <br/>
				as listed on the IMO convention on facilitation of international maritime traffic 1965(as amended,2006 edition),<br/>
				might be requested for assessment of public health risks<br/>
			</td>
			<td height="44" align="center" class="tableheadLine" colspan="2">
				申报材料Declaration materials
			</td>
			<td height="44" align="center" class="tableheadLine" colspan="2">
				航次摘要Port of call list
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_5 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_5 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_6}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" colspan="2" rowspan="3">
				固液体废弃物solid,medical waste and sewage
			</td>
			<td height="44" align="center" class="tableheadLine"  colspan="2">
				国际防止生活污水污染证书International Sewage Pollution Prevention Certificate 
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_7 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_7 == '1'}">checked="checked"</c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_8}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" colspan="2">
				垃圾管理计划garbage management plan
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_9 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_9 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_10}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" colspan="2">
				垃圾记录簿 Garbage record book
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_11 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_11 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_12}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" colspan="2" rowspan="15">
				C（关于船舶卫生的其它管理计划和材料） Other management plans concerning onboard hygiene
			</td>
			<td height="44" align="center" class="tableheadLine" rowspan="9" colspan="2">
				饮用水Potable water
			</td>
			<td height="44" align="center" class="tableLine" colspan="2" >
				水质安全计划Water safety plan
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_13 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_13 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_14}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				饮用水分析报告Water analysis report
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_15 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_15 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_16}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				饮用水系统定期检查记录Record of routine checks of the potable water system 
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_17 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_17 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_18}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				防回流装置监测记录Record of testing backflow-prevention devices 
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_19 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_19 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_20}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				港口水质报告Port water quality report
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_21 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_21 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_22}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				船舶有饮用水消毒设备吗？Is there disinfection device to treat produced water or bunkered water?
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_23 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_23 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_24}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				对所有水舱进行检查、清洗、冲刷以及消毒的记录。Record of inspecting,cleaning,
				flushing and disinfecting the tank
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_25 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_25 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_26}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				直饮水机清洗和消毒记录record of cleaning and disinfectiing drinking water fountain
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_27 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_27 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_28}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				船舶自制淡水吗？Does the vessel produce fresh water on board
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_29 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_29 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_30}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" rowspan="2" colspan="2">
				食品Food
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				食品安全管理计划Food safety plan
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_31 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_31 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_32}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				厨房常规清洁计划和时间表 Routine cleaning program and schedule of gally.
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_33 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_33 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_34}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" colspan="2">
				媒介生物Vector
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				媒介生物控制管理计划 Management plan for vector control
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_35 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_35 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_36}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" rowspan="3" colspan="2">
				压舱水Ballast water
			</td>
			<td height="44" align="center" class="tableLine" colspan="2">
				国际海事组织（IMO）压舱水清单IMO ballast water reporting form
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_37 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_37 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_38}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				压舱水记录簿Ballast-water record book
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_39 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_39 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_40}
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" colspan="2">
				压舱水管理证书Ballast Water Management Certificate
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" <c:if test="${doc.option_41 == '0'}">checked="checked"</c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${doc.option_41 == '1'}">checked="checked"</c:if>/> <br/> 
			</td>
			<td height="44" align="center" class="tableLine">
				${doc.option_42}
			</td>
		</tr>
	</table>
	<input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
	<input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.close()"/>
</div>
</body>
</html>