<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@ include file="/common/resource.jsp"%>
<script language="javascript" type="text/javascript">
	function dayin() {
		window.print();
	}
	$(function(){
	    if($("#ok").val()=="ok"){
	        alert("提交成功!");
	    	window.close();
	    }
	    if($("#sxmc").val()==""){
	    	$("#sxmc").val("国境口岸卫生许可证核发");
	    }
		if($("#o25").val()==""){
	    	$("#o25").val($("#comp_name_text").val());
	    }
	    if($("#o26").val()==""){
			$("#o26").val($("#legal_name_text").val());
		}
		if($("#o27").val()==""){
			$("#o27").val($("#management_addr_text").val());
		}
		if($("#o28").val()==""){
			$("#o28").val($("#contacts_name_text").val());
		}
		if($("#o29").val()==""){
			$("#o29").val($("#contacts_phone_text").val());
		}
	    var date = new Date();
	    var year = date.getFullYear();
	    var month = date.getMonth()+1;
	    if(month<10){
	   		month = "0"+month;
	    }
	    var day = date.getDate();
	    if(day<10){
	   		day = "0"+day;
	    }
	    if($("#o21").val()==""){
	   		$("#o21").val(year);
	    }
	    if($("#o23").val()==""){
	   		$("#o23").val(month);
	    }
	    if($("#o24").val()==""){
	   		$("#o24").val(day);
	    }
		if($("#t8").val()==""){
	   		$("#t8").val($("#h8").val());
	    }
	    if($("#t9").val()==""){
	   		$("#t9").val($("#h9").val());
	    }
	    var slsj_date = new Date();
	    var slsj_date_text = slsj_date.getFullYear() +"年"+ (slsj_date.getMonth()+1) +"月"+ slsj_date.getDate() +"日";
	    $("#slsj").val(slsj_date_text);
	    var declare_date = new Date($("#declare_date").val());
	    var slsj_date_text2 = declare_date.getFullYear() +"年"+ (declare_date.getMonth()+1) +"月"+ declare_date.getDate() +"日";
	    $("#tdeclare_date").val(slsj_date_text2);
	    if($("#docId").val()!=""){
	    	$("#submit").hide();
	    }
	})
</script>

<style type="text/css">
input[type="text"]{
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
</head>
<body>
<form action="/ciqs/xk/submitslDoc"  method="post">
<input type ="hidden" id="ok" value="${ok}" />
<input type ="hidden" id="comp_name_text" value="${comp_name}" />
<input type ="hidden" id="legal_name_text" value="${legal_name}" />
<input type ="hidden" id="contacts_phone_text" value="${contacts_phone}" />
<input type ="hidden" id="contacts_name_text" value="${contacts_name}" />
<input type ="hidden" id="management_addr_text" value="${management_addr}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_SL_GZ" />
<input type ="hidden" id="docId" name="DocId" value="${doc.docId}" />
<input type ="hidden" id="h8" value="${org_name}" />
<input type ="hidden" id="h9" value="${sl_user}" />
<input type ="hidden" id="declare_date" value="${declare_date}" />

	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">质量监督检验检疫 <br>
行政许可受理单 </p></td>
        </tr>
        <tr>
          <td><p align="left"> 受理单号：（<input type="text" value="${doc.option1}" style="width:120px;border-bottom:0px" name="Option1"/>）<span style="text-decoration:line-through;">质</span>检（<input type="text" style="width:120px;border-bottom:0px" value="${doc.option2}" name="Option2"/>）许受字〔<input type="text" value="${doc.option3}" style="width:120px;border-bottom:0px" name="Option3"/>〕<input type="text" value="${doc.option60}" style="width:120px;border-bottom:0px" name="Option60"/>  号 </p></td>
        </tr>
    </table>
    <table width="760"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
            <td width="122" height="44" align="center" class="tableLine">事项名称</td>
            <td colspan="6" style="text-align:left;"  class="tableLine">
               <input id="sxmc" type="text" value="${doc.option4}" name="Option4" style="margin-left:10px;text-align:left;width: 90%; "/>
            </td>
      </tr>
      <tr>
            <td height="44" rowspan="9" align="center" class="tableLine"><p align="center">申请人信息</p></td>
        <td width="96" rowspan="3" align="center" class="tableLine">自然人</td>
              <td width="219" align="center" class="tableLine" style="width: 205px; ">姓    名</td>
              <td colspan="4" style="text-align:left;" class="tableLine"><input type="text" style="margin-left:10px;text-align:left;width: 250px; " value="${doc.option5}" name="Option5"/></td>
      </tr>
      <tr>
        <td align="center" class="tableLine">（境内自然人）身份证号</td>
        <td colspan="4" style="text-align:left;" class="tableLine"><input type="text" value="${doc.option6}" style="margin-left:10px;text-align:left;width: 250px; " name="Option6"/></td>
      </tr>
      <tr>
        <td align="center" class="tableLine">住    址</td>
        <td colspan="4" style="text-align:left;" class="tableLine"><input type="text" value="${doc.option7}" name="Option7" style="margin-left:10px;text-align:left;width: 250px; "/></td>
      </tr>
      <tr>
        <td rowspan="4" align="center" class="tableLine"><p>法人或者</p>
        <p>其他组织</p></td>
        <td align="center" class="tableLine">名    称</td>
        <td id="comp_name" colspan="4" style="text-align:left;padding-left:10px;" class="tableLine">
        	<input type="text" id="o25" style="width:250px;text-align:left;" value="${doc.option25}" name="Option25"/>
        </td>
      </tr>
      <tr>
        <td align="center" class="tableLine">法定代表人或负责人</td>
        <td id="legal_name" colspan="4" style="text-align:left;padding-left:10px;" class="tableLine">
        	<input type="text" id="o26" style="width:250px;text-align:left;" value="${doc.option26}" name="Option26"/>
        </td>
      </tr>
      <tr>
        <td height="93" align="center" class="tableLine"><p>（境内企业或者其他组织）统</p>
        <p>一社会信用代码或营业执照编号</p></td>
        <td colspan="4" style="text-align:left;" class="tableLine">
        	<input type="text" value="${doc.option22}" name="Option22" style="margin-left:10px;text-align:left;width: 250px; "/>
        </td>
      </tr>
      <tr>
        <td align="center" class="tableLine">住所/商业登记地址</td>
        <td id="management_addr" colspan="4" style="text-align:left;padding-left:10px;" class="tableLine">
       		<input type="text" id="o27" style="width:250px;text-align:left;" value="${doc.option27}" name="Option27"/>
        </td>
      </tr>
      <tr>
        <td rowspan="2" align="center" class="tableLine"><p align="center">联系人信息</p></td>
        <td align="center" class="tableLine">姓  名</td>
        <td id="contacts_name" colspan="4" style="text-align:left;padding-left:10px;" class="tableLine">
        	<input type="text" id="o28" style="width:250px;text-align:left;" value="${doc.option28}" name="Option28"/>
        </td>
      </tr>
      <tr>
        <td align="center" class="tableLine">电  话</td>
        <td id="contacts_phone" colspan="4" style="text-align:left;padding-left:10px;" class="tableLine">
        	<input type="text" id="o29" style="width:250px;text-align:left;" value="${doc.option29}" name="Option29"/>
        </td>
      </tr>
      <tr>
         <td height="86" align="center" class="tableLine">受理机构</td>
         <td colspan="2" style="text-align:left" class="tableLine"><input id="t8" type="text" value="${doc.option8}" name="Option8" style="margin-left:10px;text-align:left;width: 90%; "/></td>
         <td width="50" style="text-align:center" class="tableLine">受理人</td>
         <td width="81" style="text-align:left;" class="tableLine"><input id="t9" type="text" value="${doc.option9}" name="Option9" style="margin-left:10px;text-align:left;width: 60%; "/></td>
         <td width="87" align="center" class="tableLine" style="width: 23px; ">联系电话</td>
         <td width="103" style="text-align:left;" class="tableLine"><input type="text" value="${doc.option10}" name="Option10" style="margin-left:10px;text-align:left;width: 90%; "/></td>
      </tr>
      <tr>
            <td height="37" align="center" class="tableLine">是否收费</td>
            <td colspan="6" style="text-align:left;padding-left:10px;" class="tableLine">是<input type="radio" value="1" name="Option11" <c:if test="${doc.option11 == 1}"> checked="checked" </c:if>/>
                否
            <input type="radio" value="0" name="Option11" <c:if test="${doc.option11 == 0}"> checked="checked" </c:if>/></td>
      </tr>
      </table>
    <table width="760"  border="0" align="center" cellpadding="0" cellspacing="0"   class="tableLine" style="font-size: 14px;line-height: 30px;">
      <tr>
    <td width="133" height="105" align="center" class="tableLine"><p align="center">接收材料时间</p></td>
    <td width="236" style="text-align:left;padding-left:5px;" class="tableLine"><p align="center">
 <!--    年   月   日 </p>默认企业申报时间 -->
    <input type="text" id="tdeclare_date" value="${doc.option12}" name="Option12" style="margin-left:10px;text-align:left;width: 90%; "/></td>
    <td width="126" colspan="-1" align="center" class="tableLine"><p align="center">法定办结时限</p></td>
    <td width="301" style="text-align:left;" class="tableLine"><p align="center">
  <!--   在<u>      </u>个工作日办结。办理过程中所需的（听证、检验、检测、检疫、鉴定、专家评审）时间不超过<u>  </u>个工作日/自然日，此项不计入办结时限。 -->
    
    在<input type="text" value="${doc.option13}" name="Option13" style="margin-left:10px;text-align:left;width: 50px; "/>个工作日办结。
办理过程中所需的（听证、检验、检测、检疫、鉴定、专家评审）时间不超过<input type="text" value="${doc.option35}" name="Option35" style="margin-left:10px;text-align:left;width: 50px; "/>个工作日/自然日，此项不计入办结时限。
    
    </p>
    </td>
  </tr>
  <tr>
    <td height="105" align="center" class="tableLine">受理时间</td>
    <td style="text-align:left;" class="tableLine"><p align="center">
     <!-- 年   月   日 </p> 默认生成文书时间 -->
      <input type="text" id="slsj" value="${doc.option14}" name="Option14" style="margin-left:10px;text-align:left;width: 90%; "/></td>
    <td colspan="-1" align="center" class="tableLine"><p align="center">承诺办结时限</p></td>
    <td style="text-align:left;" class="tableLine"><p align="center">
 在<input type="text" value="${doc.option15}" name="Option15" style="margin-left:10px;text-align:left;width: 50px; "/>个工作日办结。办理过程中所需的（听证、检验、检测、检疫、鉴定、专家评审）时间不超过<input type="text" value="${doc.option36}" name="Option36" style="margin-left:10px;text-align:left;width: 50px; "/>个工作日/自然日，此项不计入办结时限。</p>
    </td>
  </tr>
  <tr>
    <td height="92" colspan="2" align="center" class="tableLine"><p align="center">办理进度查询方式</p></td>
    <td colspan="2" align="center" class="tableLine"><p align="center">申请人可自受理之日起5个工作日后，通过互联网登录“行政执法全过程监管平台”（http://218.25.158.55:5577/ciqs-dec/login.jsp）查询审批状态和结果。</p><input type="text" value="${doc.option16}" name="Option16"/></td>
  </tr>
  <tr>
    <td height="77" colspan="2" align="center" class="tableLine">许可文书发放方式</td>
    <td colspan="2" style="text-align:left;padding-left:10px;" class="tableLine">邮寄
      <input type="radio" value="1" name="Option17" <c:if test="${doc.option17 == 1}"> checked="checked" </c:if> />
      自取
      <input type="radio" value="0" name="Option17" <c:if test="${doc.option17 == 0}"> checked="checked" </c:if> />
<c:if test="${xkspwj!='1' }">其他：<input type="text" value="${doc.option18}" name="Option18" style="margin-left:5px;text-align:left;"/></c:if></td>
  </tr>
  <tr>
    <td height="75" colspan="2" align="center" class="tableLine">邮寄地址及邮编</td>
    <td colspan="2" align="center" class="tableLine"><input type="text" value="${doc.option19}" name="Option19" style="margin-left:5px;text-align:left;width: 90%; "/></td>
  </tr>
  <tr>
    <td height="92" colspan="2" align="center" class="tableLine"><p align="center">自取地点 </p>
（凭本受理单及有效身份证件领取）</td>
    <td colspan="2" align="center" class="tableLine"><input type="text" value="${doc.option20}" name="Option20" style="margin-left:5px;text-align:left;width: 90%; "/></td>
  </tr>
  <tr>
    <td height="92" colspan="3" align="left" valign="top" class="tableLine"><p align="center">（此处加盖“申请材料齐全”印章  </p>
      <p align="center">或后附《行政许可申请材料接收清单》） </p>
<p align="center">&nbsp;</p></td>
    <td height="92" align="center" class="tableLine"><p>（行政许可专用印章）</p>
      <p><input type="text" id="o21" style="width:50px" value="${doc.option21}" name="Option21"/>年<input type="text" id="o23" style="width:50px" value="${doc.option23}" name="Option23"/>月<input type="text" id="o24" style="width:50px" value="${doc.option24}" name="Option24"/>日</td>
    </tr>
</table>
<p>&nbsp;</p>

<div style="text-align: center;" class="noprint"><span>
<!-- <input onclick="javascript:history.back();" type="button" class="btn" value="返回" /> -->
           <input type="submit" id="submit" value="提交"  />
      </span>
    </div>
</div>
</form>
</body>
</html>