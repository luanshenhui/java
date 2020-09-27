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
		$("#comp_name").text($("#comp_name_text").val());
		$("#legal_name").text($("#legal_name_text").val());
		$("#management_addr").text($("#management_addr_text").val());
		$("#contacts_name").text($("#contacts_name_text").val());
		$("#contacts_phone").text($("#contacts_phone_text").val());
	})
</script>

<style type="text/css">
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
<input type ="hidden" id="comp_name_text" value="${comp_name}" />
<input type ="hidden" id="legal_name_text" value="${legal_name}" />
<input type ="hidden" id="contacts_phone_text" value="${contacts_phone}" />
<input type ="hidden" id="contacts_name_text" value="${contacts_name}" />
<input type ="hidden" id="management_addr_text" value="${management_addr}" />
	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">质量监督检验检疫 <br>
行政许可受理单 </p></td>
        </tr>
        <tr>
          <td><p align="left"> 受理单号：（&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;）<span style="text-decoration:line-through;">质</span>检（&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;）许受字〔&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;〕  号 </p></td>
        </tr>
    </table>
    <table width="760"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
            <td width="122" height="44" align="center" class="tableLine">事项名称</td>
              <td colspan="6" align="center" class="tableLine">&nbsp;</td>
      </tr>
      <tr>
            <td height="44" rowspan="9" align="center" class="tableLine"><p align="center">申请人信息</p></td>
        <td width="96" rowspan="3" align="center" class="tableLine">自然人</td>
              <td width="219" align="center" class="tableLine">姓    名</td>
              <td colspan="4" align="center" class="tableLine">&nbsp;</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">（境内自然人）身份证号</td>
        <td colspan="4" align="center" class="tableLine">&nbsp;</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">住    址</td>
        <td colspan="4" align="center" class="tableLine">&nbsp;</td>
      </tr>
      <tr>
        <td rowspan="4" align="center" class="tableLine"><p>法人或者</p>
        <p>其他组织</p></td>
        <td align="center" class="tableLine">名    称</td>
        <td id="comp_name" colspan="4" align="center" class="tableLine"></td>
      </tr>
      <tr>
        <td align="center" class="tableLine">法定代表人或负责人</td>
        <td id="legal_name" colspan="4" align="center" class="tableLine"></td>
      </tr>
      <tr>
        <td height="93" align="center" class="tableLine"><p>（境内企业或者其他组织）统</p>
        <p>一社会信用代码或营业执照编号</p></td>
        <td colspan="4" align="center" class="tableLine">&nbsp;</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">住所/商业登记地址</td>
        <td id="management_addr" colspan="4" align="center" class="tableLine"></td>
      </tr>
      <tr>
        <td rowspan="2" align="center" class="tableLine"><p align="center">联系人信息</p></td>
        <td align="center" class="tableLine">姓  名</td>
        <td id="contacts_name" colspan="4" align="center" class="tableLine"></td>
      </tr>
      <tr>
        <td align="center" class="tableLine">电  话</td>
        <td id="contacts_phone" colspan="4" align="center" class="tableLine"></td>
      </tr>
      <tr>
            <td height="86" align="center" class="tableLine">受理机构</td>
              <td colspan="2" align="center" class="tableLine">默认受理分支局</td>
              <td width="50" align="center" class="tableLine">受理人</td>
              <td width="81" align="center" class="tableLine"></td>
              <td width="87" align="center" class="tableLine">联系电话</td>
              <td width="103" align="center" class="tableLine">&nbsp;</td>
      </tr>
      <tr>
            <td height="37" align="center" class="tableLine">是否收费</td>
              <td colspan="6" align="center" class="tableLine">是<c:if test="${xkspwj!='1' }"><span class="fangxingLine">&nbsp;</span></c:if>
                否
                <c:if test="${xkspwj!='1' }"><span class="fangxingLine">&nbsp;&nbsp;</span></c:if>                <c:if test="${xkspwj!='1' }"></c:if></td>
      </tr>
      </table>
    <table width="760"  border="0" align="center" cellpadding="0" cellspacing="0"   class="tableLine" style="font-size: 14px;line-height: 30px;">
      <tr>
    <td width="95" height="105" align="center" class="tableLine"><p align="center">接收材料时间</p></td>
    <td width="236" align="center" class="tableLine"><p align="center">年   月   日 </p>
      默认企业申报时间</td>
    <td width="126" colspan="-1" align="center" class="tableLine"><p align="center">法定办结时限</p></td>
    <td width="301" align="center" class="tableLine"><p align="center">在<u>      </u>个工作日办结。办理过程中所需的（听证、检验、检测、检疫、鉴定、专家评审）时间不超过<u>  </u>个工作日/自然日，此项不计入办结时限。</p></td>
  </tr>
  <tr>
    <td height="105" align="center" class="tableLine">受理时间</td>
    <td align="center" class="tableLine"><p align="center"> 年   月   日 </p>
      默认生成文书时间</td>
    <td colspan="-1" align="center" class="tableLine"><p align="center">承诺办结时限</p></td>
    <td align="center" class="tableLine"><p align="center">在<u>       </u>个工作日办结。办理过程中所需的（听证、检验、检测、检疫、鉴定、专家评审）时间不超过<u>  </u>个工作日/自然日，此项不计入办结时限。</p></td>
  </tr>
  <tr>
    <td height="92" colspan="2" align="center" class="tableLine"><p align="center">办理进度查询方式</p></td>
    <td colspan="2" align="center" class="tableLine"><p align="center">申请人可自受理之日起5个工作日后，通过互联网登录“进口可用作原料的固体废物检验检疫电子监管系统”（http://scrap.eciq.cn）查询审批状态和结果。</p></td>
  </tr>
  <tr>
    <td height="77" colspan="2" align="center" class="tableLine">许可文书发放方式</td>
    <td colspan="2" align="center" class="tableLine">邮寄
      <c:if test="${xkspwj!='1' }"><span class="fangxingLine">&nbsp;</span></c:if>
      自取
      <c:if test="${xkspwj!='1' }"><span class="fangxingLine">&nbsp;&nbsp;</span></c:if>
<c:if test="${xkspwj!='1' }">其他：______________</c:if></td>
  </tr>
  <tr>
    <td height="75" colspan="2" align="center" class="tableLine">邮寄地址及邮编</td>
    <td colspan="2" align="center" class="tableLine"></td>
  </tr>
  <tr>
    <td height="92" colspan="2" align="center" class="tableLine"><p align="center">自取地点 </p>
（凭本受理单及有效身份证件领取）</td>
    <td colspan="2" align="center" class="tableLine">&nbsp;</td>
  </tr>
  <tr>
    <td height="92" colspan="3" align="left" valign="top" class="tableLine"><p align="center">（此处加盖“申请材料齐全”印章  </p>
      <p align="center">或后附《行政许可申请材料接收清单》） </p>
<p align="center">&nbsp;</p></td>
    <td height="92" align="center" class="tableLine"><p>（行政许可专用印章）</p>
      <p>年   月   日</p></td>
    </tr>
</table>
<p align="left">&nbsp;</p>
<p>&nbsp;</p>
<p>
  <c:if test="${clistSize>3 }">
    <logic:notEmpty name="clist">
      <logic:iterate indexId="rowIdx" id="paperlessDeclGoodsDTO" name="clist" type="com.dpn.ciq.model.PaperlessDeclGoodsDTO">
        <bean:write name="paperlessDeclGoodsDTO" property="container_code"/>
      </logic:iterate>
    </logic:notEmpty>
  </c:if>
  
</p>
<div style="text-align: center;" class="noprint"><span>
<input onClick="javascript:history.back();" type="button" class="btn" value="返回" />
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      </span>
    </div>
</div>
</body>
</html>
