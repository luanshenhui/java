<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>委托检验申请单</title>
<%@ include file="/common/resource_new.jsp"%>
</head>
<body>
<script type="text/javascript">

	$(function(){
		if($("#saveflag").val()=="ok"){
			alert("保存成功!");
			window.close();
		}
		if($("#submitflag").val()=="ok"){
			alert("提交成功!");
			window.close();
		}
		if($("#txt_o2").val() ==""){
			$("#txt_o2").val("大连局港湾办邮检科");
		}
		var package_no = $("#package_no").val();
		if($("#txt_o8").val() ==""){
			$("#txt_o8").val(package_no);
		}
		var consignor_country = $("#consignor_country").val();
		if($("#txt_o11").val() ==""){
			$("#txt_o11").val(consignor_country);
		}
	})
</script>

<style type="text/css">
input{
    border: 0px;
    outline: none;
    text-align: center;    
/*     border-bottom: 1px solid #000; */
}
<!--
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
@media print {
.noprint{display:none}
}
-->
</style>

<form action="/ciqs/mail/submitDoc?type=1"  method="post">
	<input type ="hidden" id="consignor_country" value="${dto.consignor_country}" />
	<input type ="hidden" id="consignee_name" value="${dto.consignee_name}" />
	<input type ="hidden" id="cago_name" value="${dto.cago_name}" />
	<input type ="hidden" id="package_no" name="ProcMainId" value="${dto.package_no}" />
	<input type ="hidden" name="DocType" value="D_WTJY" />
	<input type ="hidden" name="DocId" value="${doc.docId}" />
	<input type ="hidden" id="saveflag" value="${save}" />
	<input type ="hidden" id="submitflag" value="${submit}" />
	<div id="content">
	    <table width="900" align="center">
	        <tr>
	          <td colspan="3" align="center" style="height:60px;font-size:25px;font-family:'楷体_GB2312';font-weight: bold;">
	          	辽宁出入境检验检疫局检验检疫技术中心委托检验申请单
	          </td>
	        </tr>
	        <tr>
	          <td style="text-align:right" colspan="3">委托单编号：<input id="t_package_no" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option1}" name="option1"/></td>
	        </tr>
	    </table>
	    <table width="900"  border="0" align="center" style="margin-top:5px;font-size: 14px; line-height: 30px; text-align: left;" cellpadding="0" cellspacing="0"   class="tableLine">
	      <tr>
	        <td height="44" align="center" class="tableLine">*委 托 单 位（中文/英文）</td>
	        <td align="left" class="tableLine" style="text-align:left;padding:2px" colspan="3">
	        	<input id="txt_o2" style="text-align:left;padding-left:5px;width:300px" type ="text" value="${doc.option2}" name="option2"/>
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine">*委 托 地 址（中文/英文）</td>
	        <td align="left" class="tableLine" style="text-align:left;padding:2px" colspan="3">
	        	<input id="txt_o3" style="text-align:left;padding-left:5px;width:300px" type ="text" value="${doc.option3}" name="option3"/>
	        </td>
	      </tr>
	      <tr>
	        <td align="left" class="tableLine" style="text-align:left;padding:2px" colspan="4">
	        	<span style="margin-left:5px;">*联 系 人： </span><input id="txt_o4" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option4}" name="option4"/>
	        	<span style="margin-left:5px;">电  话： </span><input id="txt_o5" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option5}" name="option5"/>
	        	<span style="margin-left:5px;">邮箱（E-mail）: </span><input id="txt_o6" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option6}" name="option6"/>
	        </td>
	      </tr>
	      <tr>
	        <td style="width:25%;height:44px" align="center" class="tableLine">*商品/样品名称（中文/英文）</td>
	        <td align="left" class="tableLine" style="width:30%;text-align:left;padding-left:10px;">
	        	<input id="txt_o7" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option7}" name="option7"/>
	        </td>
	        <td style="width:20%;height:44px" height="44" align="center" class="tableLine">原 始 编 号</td>
	        <td align="left" class="tableLine" style="width:30%;text-align:left;padding-left:10px;">
	        	<input id="txt_o8" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option8}" name="option8"/>
	        </td>
	      </tr>
     	  <tr>
	        <td height="44" align="center" class="tableLine">*样品数量/重量</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px;">
	        	<input id="txt_o9" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option9}" name="option9"/>
	        </td>
	        <td height="44" align="center" class="tableLine">型号/规格/等级/牌号</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px;">
	        	<input id="txt_o10" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option10}" name="option10"/>
	        </td>
	      </tr>
     	  <tr>
	        <td height="44" align="center" class="tableLine">制造商/产地</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px;">
	        	<input id="txt_o11" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option11}" name="option11"/>
	        </td>
	        <td height="44" align="center" class="tableLine">标识标记（批次号/商标/款号/炉号）</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px;">
	        	<input id="txt_o12" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option12}" name="option12"/>
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine">□原产国别/ □输往国别</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px;">
	        	<input id="txt_o13" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option13}" name="option13"/>
	        </td>
	        <td height="44" align="center" class="tableLine">存 放 条 件</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px;">
	        	<input id="txt_o1401" type ="checkbox"  name="option14" value="1" <c:if test="${doc.option14==1}">checked="checked"</c:if> />室温
	        	<input id="txt_o1402" type ="checkbox"  name="option15" value="2" <c:if test="${doc.option15==2}">checked="checked"</c:if> />冷藏
	        	<input id="txt_o1403" type ="checkbox"  name="option16" value="3" <c:if test="${doc.option16==3}">checked="checked"</c:if> />冷冻
	        	<input id="txt_o1404" type ="checkbox"  name="option17" value="4" <c:if test="${doc.option17==4}">checked="checked"</c:if> />其他
	        	<input id="txt_o18" type ="text"  name="option18" style="text-align:left;padding-left:5px;width:50px" value="${doc.option18}"/>
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine">样 品 描 述<br/>（如状态、外观、包装等）</td>
	        <td align="left" class="tableLine" style="text-align:left;padding:2px" colspan="3">
	        	<textarea rows="5" cols="92" name="option19">${doc.option19}</textarea>
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine">*检验目的</td>
	        <td align="left" class="tableLine" style="text-align:left;padding:2px" colspan="3">
	        	<span style="margin-left:10px;"><strong>进口检验：</strong></span> 
	        	<input id="txt_o1701" type ="checkbox"  name="option20" value="1" <c:if test="${doc.option20==1}">checked="checked"</c:if> />国抽   
	        	<input id="txt_o1702" type ="checkbox"  name="option21" value="2" <c:if test="${doc.option21==2}">checked="checked"</c:if> />地抽   
	        	<input id="txt_o1703" type ="checkbox"  name="option22" value="3" <c:if test="${doc.option22==3}">checked="checked"</c:if> />E抽   
	        	<input id="txt_o1704" type ="checkbox"  name="option23" value="4" <c:if test="${doc.option23==4}">checked="checked"</c:if> />监测   
	        	<span style="margin-left:10px;"><strong>出口检验：</strong></span> 
	        	<input id="txt_o1801" type ="checkbox"  name="option24" value="1" <c:if test="${doc.option24==1}">checked="checked"</c:if> />国抽   
	        	<input id="txt_o1802" type ="checkbox"  name="option25" value="2" <c:if test="${doc.option25==2}">checked="checked"</c:if> />地抽   
	        	<input id="txt_o1803" type ="checkbox"  name="option26" value="3" <c:if test="${doc.option26==3}">checked="checked"</c:if> />E抽   
	        	<input id="txt_o1804" type ="checkbox"  name="option27" value="4" <c:if test="${doc.option27==4}">checked="checked"</c:if> />监测<br/>
	        	<span style="margin-left:10px;"><strong>委托检验：</strong></span> 
	        	<input id="txt_o1901" type ="checkbox"  name="option28" value="1" <c:if test="${doc.option28==1}">checked="checked"</c:if> />社会委托  
	        	<input id="txt_o1902" type ="checkbox"  name="option29" value="2" <c:if test="${doc.option29==2}">checked="checked"</c:if> />周期检   
	        	<input id="txt_o1903" type ="checkbox"  name="option30" value="3" <c:if test="${doc.option30==3}">checked="checked"</c:if> />内部品管    
	        	<input id="txt_o1904" type ="checkbox"  name="option31" value="4" <c:if test="${doc.option31==4}">checked="checked"</c:if> />其他: 
	        	<input id="txt_o32" type ="text"  name="option32" style="text-align:left;padding-left:5px;width:200px" value="${doc.option32}"/>                        
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine">随附单据</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px" colspan="3">
	        	<input id="txt_o2101" type ="checkbox"  name="option33" value="1" <c:if test="${doc.option33==1}">checked="checked"</c:if> />入境货物报检单  
	        	<input id="txt_o2102" type ="checkbox"  name="option34" value="2" <c:if test="${doc.option34==2}">checked="checked"</c:if> />合同  
	        	<input id="txt_o2103" type ="checkbox"  name="option35" value="3" <c:if test="${doc.option35==3}">checked="checked"</c:if> />产品标准 
	        	<input id="txt_o2104" type ="checkbox"  name="option36" value="4" <c:if test="${doc.option36==4}">checked="checked"</c:if> />厂检单  
	        	<input id="txt_o2105" type ="checkbox"  name="option37" value="5" <c:if test="${doc.option37==5}">checked="checked"</c:if> />产品检验依据  
	        	<input id="txt_o2106" type ="checkbox"  name="option38" value="6" <c:if test="${doc.option38==6}">checked="checked"</c:if> />其他 :      
	        	<input id="txt_o22" type ="text"  name="option39" style="text-align:left;padding-left:5px;width:150px" value="${doc.option39}"/> 
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine" rowspan="2">*委托检验项目和方法<br/>（可附页）</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px" colspan="3">
	        	<textarea rows="5" cols="92" name="option40">${doc.option40}</textarea>
	        </td>
	      </tr>
	      <tr>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px" colspan="3">
	        	备注：如委托方未指定或未填写检测方法、指定限量值和结果单位，则视为同意本中心所选检测依据、<br/>限量值和结果单位。
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine">检验报告要求</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px" colspan="3">                                  
	        	<input id="txt_o2401" type ="checkbox"  name="option41" value="1" <c:if test="${doc.option41==1}">checked="checked"</c:if> />中文报告  
	        	<input id="txt_o2402" type ="checkbox"  name="option42" value="2" <c:if test="${doc.option42==2}">checked="checked"</c:if> />英文报告
	        	<input id="txt_o2403" type ="checkbox"  name="option43" value="3" <c:if test="${doc.option43==3}">checked="checked"</c:if> />中英文报告
	        	<input id="txt_o2404" type ="checkbox"  name="option44" value="4" <c:if test="${doc.option44==4}">checked="checked"</c:if> />自取  
	        	<input id="txt_o2405" type ="checkbox"  name="option45" value="5" <c:if test="${doc.option45==5}">checked="checked"</c:if> />快递到付(快递同委托单位地址)<br/>  
	        	<input id="txt_o2406" type ="checkbox"  name="option46" value="6" <c:if test="${doc.option46==6}">checked="checked"</c:if> />其他 :      
	        	<input id="txt_o25" type ="text"  name="option47" style="text-align:left;padding-left:5px;width:150px" value="${doc.option47}"/> 
	        	<br/>备注:如需英文或中英对照检验报告,请准确填写相关信息。
	        </td>
	      </tr>
	      <tr>
	        <td height="44" align="center" class="tableLine" >其他要求</td>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:10px" colspan="3">
	        	<textarea rows="5" cols="92" name="option48">${doc.option48}</textarea>
	        </td>
	      </tr>
	      <tr>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:30px" colspan="4">
	        	<strong>双方约定条款:</strong>
	        </td>
	      </tr>
	      <tr>
	        <td align="left" class="tableLine" style="text-align:left;padding-left:30px" colspan="4">
	        	1. 委托单位应认真填写本检验申请单内容，以□标记的栏目用“√”选择，*为必填项目。<br/>
				2. 委托单位对样品的代表性、真实性负责；检验单位的检测结果仅对委托单位送检样品负责。<br/>
				委托单位对送检样品中包含的任何已知或潜在危害如放射性、有毒、爆炸性样品，应事先声明，否则应对产生的后果负全部责任。<br/>
				3. 委托单位如需返还验余样品，须在其它要求栏中注明，且样品须在验毕日期起五个工作日后由客户自行取回；<br/>
				如不需返还，本中心有权利在完成检测工作后处置送检样品。<br/>
				4. 委托单位请提供足够的样品数量或重量，以避免检验因样品量不足耽误检验周期或检验中止。<br/>
				<input id="txt_o27" type ="checkbox"  name="option49" <c:if test="${doc.option49==1}">checked="checked"</c:if>  value="1"/>双方一致确认   
				<input id="txt_o28" type ="checkbox"  name="option50" <c:if test="${doc.option50==1}">checked="checked"</c:if>  value="1"/>以《合同评审记录》确认
				（记录编号：<input type ="text"  name="option51" style="width:150px" value="${doc.option51}"/>）  
				<input id="txt_o30" type ="checkbox"  name="option60" <c:if test="${doc.option60==1}">checked="checked"</c:if>  value="1"/>解除委托<br/>
				委托方代表：（签字）   <input type ="text"  name="option52" style="width:150px" value="${doc.option52}"/>
				实验室代表：（签字）   <input type ="text"  name="option53" style="width:150px" value="${doc.option53}"/><br/>
                                               日期：  <input type ="text"  name="option54" style="width:30px" value="${doc.option54}"/>年 
                <input type ="text"  name="option55" style="width:20px" value="${doc.option55}"/>月   
                <input type ="text"  name="option56" style="width:20px" value="${doc.option56}"/>日              
                <span style="margin-left:125px">日期：</span><input type ="text"  name="option57" style="width:30px" value="${doc.option57}"/>年 
                <input type ="text"  name="option58" style="width:20px" value="${doc.option58}"/>月   
                <input type ="text"  name="option59" style="width:20px" value="${doc.option59}"/>日        
	        </td>
	      </tr>
      </table>
      <div style="text-align: left;padding-left:400px" class="noprint">
      	辽宁出入境检验检疫局检验检疫技术中心    地址：辽宁省大连市中山区长江东路60号  <br/>
   		咨询电话：0411-82583017，82583012，82729937（金属材料），87515279（石油）  <br/>
		报告查询：0411-82583915，82583926    传真：82583936，82583674   <br/>
		投诉电话：0411-82583821，82583539，82583663
      </div>
		<div style="text-align: center;margin-top:5px" class="noprint">
		    <span>
		    	<input type="submit" value="保存" type="button" style="width: 50px"/>
		    	<input type="button" value="提交" type="button" onclick="tjiao()" style="margin-left: 25px;width: 50px"/>
				<input type="button" value="打印" type="button" onclick="javascript:window.print()" style="margin-left: 25px;width: 50px"/>
				<input type="button" value="返回" type="button" onclick="javascript:window.close()" style="margin-left: 25px;width: 50px"/>
		    </span>
		</div>
	</div>
</form>

</body>
</html>
