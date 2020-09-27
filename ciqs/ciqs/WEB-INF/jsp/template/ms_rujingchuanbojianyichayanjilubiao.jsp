<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>入境船舶检疫查验记录表</title>
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
<div class="chatTitle">入境船舶检疫查验记录表</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td  height="44" align="center" class="tableLine" rowspan="2">
				船名
			</td>
			<td  height="44" align="left" class="tableLine" >
				（中文）${ms.cn_vsl_m }
			</td>
			<td  height="44" align="center" class="tableLine" rowspan="2">
				国籍
			</td>
			<td  height="44" align="left" class="tableLine" >
				（中文）${ms.vsl_registry_cn }
			</td>
			<td  height="44" align="center" class="tableLine" >
				总吨 
			</td>
			<td  height="44" width="200" align="center" class="tableLine"  >
				${ms.vsl_grt }
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine" >
				（英文）${ms.full_vsl_m }
			</td>
			<td  height="44" align="left" class="tableLine" >
				（英文）${ms.vsl_registry_en }
			</td>
			<td  height="44" align="center" class="tableLine"  >
				净吨 
			</td>
			<td  height="44" width="200" align="center" class="tableLine"   >
				${ms.vsl_nrt }
			</td>
		</tr>
		<tr>
			<td  height="44" align="center" class="tableLine" >
				IMO编号
			</td>
			<td  height="44" align="left" class="tableLine" >
				
			</td>
			<td  height="44" align="center" class="tableLine"  >
				呼号
			</td>
			<td  height="44" width="200" align="center" class="tableLine"   >
				${ms.vsl_callsign }
			</td>
			<td  height="44" align="center" class="tableLine"  >
				代理
			</td>
			<td  height="44" width="200" align="center" class="tableLine"   >
				
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="3">
				发航港及日期：${ms.previous_port_date }
			</td>
			<td  height="44" align="left" class="tableLine"  colspan="4" >
					目的港及日期：${ms.pass_port_date }
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="3">
				船员人数：(中)${ms.sailor_total_china }  (外)${ms.sailor_total_foreign }
			</td>
			<td  height="44" align="left" class="tableLine"  colspan="4" >
				旅客人数：(中)${ms.imp_travel_total_china }  (外)${ms.imp_travel_total_foreign }
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="3">
				健康证书： 
				有效 <input type="checkbox" <c:if test="${'0' eq doc.option_1 }">checked="checked"</c:if>/> 
				无效<input type="checkbox" <c:if test="${'1' eq doc.option_1 }">checked="checked"</c:if>/> 
				无<input type="checkbox" <c:if test="${'2' eq doc.option_1 }">checked="checked"</c:if>/>
			</td>
			<td  height="44" align="left" class="tableLine"  colspan="4" >
				预防接种证书：
				有效 <input type="checkbox" <c:if test="${'0' eq doc.option_2 }">checked="checked"</c:if>/> 
				无效<input type="checkbox" <c:if test="${'1' eq doc.option_2 }">checked="checked"</c:if>/> 
				无<input type="checkbox" <c:if test="${'2' eq doc.option_2 }">checked="checked"</c:if>/>
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="3">
				伴侣动物/鸟类： 
				有 <input type="checkbox" <c:if test="${'0' eq doc.option_3 }">checked="checked"</c:if>/>
				否<input type="checkbox" <c:if test="${'1' eq doc.option_3 }">checked="checked"</c:if>/>
			</td>
			<td  height="44" align="left" class="tableLine"  colspan="4" >
				植物/植物产品： 
				有 <input type="checkbox" <c:if test="${'0' eq doc.option_4 }">checked="checked"</c:if>/>
				否<input type="checkbox" <c:if test="${'1' eq doc.option_4 }">checked="checked"</c:if>/>
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				途经传染病流行区 
				<input type="checkbox" <c:if test="${'0' eq doc.option_5 }">checked="checked"</c:if>/>动物疫区
				<input type="checkbox" <c:if test="${'1' eq doc.option_5 }">checked="checked"</c:if>/>植物疫区 
				<input type="checkbox" <c:if test="${'2' eq doc.option_5 }">checked="checked"</c:if>/>其它 
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				危害人体健康的因素：
				<input type="checkbox" <c:if test="${'0' eq doc.option_6 }">checked="checked"</c:if>/>否  
				<input type="checkbox" <c:if test="${'1' eq doc.option_6 }">checked="checked"</c:if>/>有
				<input type="checkbox" <c:if test="${'2' eq doc.option_6 }">checked="checked"</c:if>/>种类
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				免予/卫生控制证书：${ms.scc_cert_seq }&nbsp;&nbsp;&nbsp;&nbsp; 签发港及日期：${ms.ship_sanit_cert }
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				交通工具卫生证书编号：${ms.scfc_cert_seq }&nbsp;&nbsp;&nbsp;&nbsp;签发港及日期： ${ms.traf_cert }
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				检疫方式/地点：
				锚地 <input type="checkbox" <c:if test="${'0' eq doc.option_7 }">checked="checked"</c:if> disabled="disabled"/> 
				随船 <input type="checkbox" <c:if test="${'1' eq doc.option_7 }">checked="checked"</c:if> disabled="disabled"/> 
				电讯 <input type="checkbox" <c:if test="${'2' eq doc.option_7 }">checked="checked"</c:if> disabled="disabled"/> 
				靠泊 <input type="checkbox" <c:if test="${'3' eq doc.option_7 }">checked="checked"</c:if> disabled="disabled"/>  
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				医学及动植物检查结果：<br/>
				<br/>
				${doc.option_8 }
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				应受处理事项：<br/>
				<br/>
				${doc.option_9 }
				<br/>
				检验检疫员签字：<img style="width:50px;height:50px" src="/ciqs/showVideo?imgPath=${doc.option_10 }"/>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核人签字：<img style="width:50px;height:50px" src="/ciqs/showVideo?imgPath=${doc.option_11 }"/>
			</td>
		</tr>
		<tr>
			<td  height="44" align="left" class="tableLine"  colspan="7">
				签字日期/时间：<fmt:formatDate value="${doc.dec_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
			</td>
		</tr>
	</table>
 	<input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
    <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();"/>
</div>
</body>
</html>