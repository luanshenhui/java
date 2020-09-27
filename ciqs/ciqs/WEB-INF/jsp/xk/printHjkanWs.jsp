<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/resource_new.jsp"%>
</head>
<script language="javascript" type="text/javascript">
	function dayin() {
		window.print();
	}
	
	$(function(){
		var management_type_hide = $("#management_type_hide").val();
		
		var management_types = [];
		if(management_type_hide.indexOf(',') !=-1){
			management_types = management_type_hide.split(',');

			for (var i = 0; i < management_types.length; i++) {
		
				if(management_types[i] == 1){
					$("#management_type1").attr("checked",true);
				}
				if(management_types[i] == 2){
					$("#management_type2").attr("checked",true);
				}
				if(management_types[i] == 3){
					$("#management_type3").attr("checked",true);
				}
				if(management_types[i] == 4){
					$("#management_type4").attr("checked",true);
				}
				if(management_types[i] == 5){
					$("#management_type5").attr("checked",true);
				}
			}
		}else{
			if(management_type_hide == 1){
				$("#management_type1").attr("checked",true);
			}
			if(management_type_hide == 2){
				$("#management_type2").attr("checked",true);
			}
			if(management_type_hide == 3){
				$("#management_type3").attr("checked",true);
			}
			if(management_type_hide == 4){
				$("#management_type4").attr("checked",true);
			}
			if(management_type_hide == 5){
				$("#management_type5").attr("checked",true);
			}
		}
		
		var declare_date = new Date($("#declare_date_hide").val());
	    var declare_date_text = declare_date.getFullYear() +"年"+ (declare_date.getMonth()+1) +"月"+ declare_date.getDate() +"日";
	    $("#sqdate").val(declare_date_text);
	    
	    if($("#option1").val()==""){
	    	if($("#apply_type").val()=="1"){
	    		$("#option1_txt_01").attr("checked",true);
		    }else if($("#apply_type").val()=="2"){
		    	$("#option1_txt_02").attr("checked",true);
		    }else if($("#apply_type").val()=="3"){
		    	$("#option1_txt_03").attr("checked",true);
		    }else if($("#apply_type").val()=="4"){
		    	$("#option1_txt_04").attr("checked",true);
		    }
	    }
	    
	    var hygiene_license_number = $("#hygiene_license_number").val();
	    if($("#hygiene_license_number_txt").val() == ""){
	    	$("#hygiene_license_number_txt").val(hygiene_license_number);
	    }
	    var comp_name = $("#comp_name").val();
	    if($("#comp_name_txt").val() == ""){
	    	$("#comp_name_txt").val(comp_name);
	    }
	    var management_addr = $("#management_addr").val();
	    if($("#management_addr_txt").val() == ""){
	    	$("#management_addr_txt").val(management_addr);
	    }
	    var declare_date = $("#declare_date").val();
	    if($("#declare_date_txt").val() == ""){
	    	$("#declare_date_txt").val(declare_date);
	    }
	    
	    var comp_name = $("#comp_name").val();
	    if($("#comp_name_txt_02").val() == ""){
	    	$("#comp_name_txt_02").val(comp_name);
	    }
	    var comp_addr = $("#comp_addr").val();
	    if($("#comp_addr_txt").val() == ""){
	    	$("#comp_addr_txt").val(comp_addr);
	    }	    
	    var management_addr = $("#management_addr").val();
	    if($("#management_addr_txt_02").val() == ""){
	    	$("#management_addr_txt_02").val(management_addr);
	    }
	    var management_area = $("#management_area").val();
	    if($("#management_area_txt").val() == ""){
	    	$("#management_area_txt").val(management_area);
	    }
	    var legal_name = $("#legal_name").val();
	    if($("#legal_name_txt").val() == ""){
	    	$("#legal_name_txt").val(legal_name);
	    }
	    if($("#legal_name_txt_02").val() == ""){
	    	$("#legal_name_txt_02").val(legal_name);
	    }
	    var contacts_name = $("#contacts_name").val();
	    if($("#contacts_name_txt").val() == ""){
	    	$("#contacts_name_txt").val(contacts_name);
	    }
	    var contacts_phone = $("#contacts_phone").val();
	    if($("#contacts_phone_txt").val() == ""){
	    	$("#contacts_phone_txt").val(contacts_phone);
	    }
	    var mailbox = $("#mailbox").val();
	    if($("#mailbox_txt").val() == ""){
	    	$("#mailbox_txt").val(mailbox);
	    }
	    var fax = $("#fax").val();
	    if($("#fax_txt").val() == ""){
	    	$("#fax_txt").val(fax);
	    }
	    var employee_num = $("#employee_num").val();
	    if($("#employee_num_txt").val() == ""){
	    	$("#employee_num_txt").val(employee_num);
	    }
	    var certificate_numver = $("#certificate_numver").val();
	    if($("#certificate_numver_txt").val() == ""){
	    	if(certificate_numver == 1){
	    		$("#certificate_numver_txt").val("是");
	    	}else{
	    		$("#certificate_numver_txt").val("否");
	    	}
	    }
	    var apply_scope = $("#apply_scope").val();
	    if($("#apply_scope_txt").val() == ""){
	    	$("#apply_scope_txt").val(apply_scope);
	    }
	    var spxm = $("#spxm").val();
	    if(spxm == ""){
	    	$("#spxm").val("国境口岸卫生许可证核发");
	    }
	    var slr = $("#slr").val();
	    if(slr == ""){
	    	$("#slr").val($("#st_1_opr_psn").val());
	    }
	    var slsj = $("#slsj").val();
	    if(slsj == ""){
	    	$("#slsj").val($("#st_1_opr_date_str").val());
	    }
	    var slr2 = $("#slr2").val();
	    if(slr2 == ""){
	    	$("#slr2").val($("#st_2_opr_psn").val());
	    }
	    var slsj2 = $("#slsj2").val();
	    if(slsj2 == ""){
	    	$("#slsj2").val($("#st_2_opr_date_str").val());
	    }
	    var jdr = $("#jdr").val();
	    if(jdr == ""){
	    	$("#jdr").val($("#st_6_opr_psn").val());
	    }
	    var jdsj = $("#jdsj").val();
	    if(jdsj == ""){
	    	$("#jdsj").val($("#st_6_opr_date_str").val());
	    }
	    var zz_txt = $("#zz_txt").val();
	    if(zz_txt == ""){
	    	$("#zz_txt").val($("#zz").val());
	    }
	    var xcscDate_txt = $("#xcscDate_txt").val();
	    if(xcscDate_txt == ""){
	    	$("#xcscDate_txt").val($("#xcscDate").val());
	    }
	    if($("#ok").val()=="ok"){
		    alert("提交成功!");
		    window.close();
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
<body>
<form action="<%=request.getContextPath()%>/xk/submitslDoc"  method="post">
<input type ="hidden" name="ProcMainId" value="${dto.license_dno}" />
<input type ="hidden" name="DocType" value="D_SQS" />
<input type ="hidden" name="DocId" value="${doc.docId}" />
<input type ="hidden" id="ok" value="${ok}" />
<input type ="hidden" id="management_type_hide" value="${dto.management_type}"/>
<input type ="hidden" id="declare_date_hide" value="${dto.declare_date}" />
<input type ="hidden" id="st_1_opr_psn" value="${st_1.opr_psn}" />
<input type ="hidden" id="st_1_opr_date_str" value="${st_1.opr_date_str}" />
<input type ="hidden" id="st_2_opr_psn" value="${st_2.opr_psn}" />
<input type ="hidden" id="st_2_opr_date_str" value="${st_2.opr_date_str}" />
<input type ="hidden" id="st_6_opr_psn" value="${st_6.opr_psn}" />
<input type ="hidden" id="st_6_opr_date_str" value="${st_6.opr_date_str}" />
<input type ="hidden" id="zz" value="${zz}" />
<input type ="hidden" id="xcscDate" value="${xcscDate}" />

	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td colspan="4" align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center"><strong>国境口岸卫生许可证 </strong><br>
            <strong>申请书 </strong></p></td>
        </tr>
        <tr align="center">
          <td colspan="4">
            <input type="hidden" id="apply_type" value="${dto.apply_type}"/>
            <input type="hidden" id="option1" value="${doc.option1}"/>
          	<input type="radio" id="option1_txt_01" name="Option1" value="1" <c:if test ="${doc.option1==1}">checked="checked"</c:if>  /><strong>初次</strong>
          </td>
        </tr>
        <tr align="center">
          <td colspan="4">
          <input type ="radio" id="option1_txt_02" name="Option1" value="2" <c:if test ="${doc.option1==2}">checked="checked"</c:if>  /><strong>变更</strong>
          </td>
        </tr>
        <tr align="center">
          <td colspan="4">
          <input type ="radio" id="option1_txt_03" name="Option1" value="3" <c:if test ="${doc.option1==3}">checked="checked"</c:if>  /><strong>延续</strong>
          
          </td>
        </tr>
        <tr align="center">
            <td colspan="4">
            <input type ="radio" id="option1_txt_04" name="Option1" value="4" <c:if test ="${doc.option1==4}">checked="checked"</c:if>  /><strong>临时经营</strong>
            </td>
        </tr>
        <tr>
          <td colspan="4">
          	<div style="text-align:left;float: left;">
	          	<strong>原卫生许可证号：</strong>
	          	<input type="text" style="width:200px;text-align:left" id="hygiene_license_number_txt" name="Option2" value="${doc.option2}"/>
	          	<input type="hidden" id="hygiene_license_number" value="${dto.hygiene_license_number}"/>
          	</div>
          </td>
      </tr>
        <tr>
          <td colspan="4" style="text-align:left;">
          	  <strong>申请单位： </strong>
	          <input type="text" style="margin-top:5px;width:200px;text-align:left" id="comp_name_txt" name="Option3" value="${doc.option3}"/>
	          <input type="hidden" id="comp_name" value="${dto.comp_name}"/>
          </td>
        </tr>
        <tr>
          <td colspan="4" style="text-align:left;">
          	  <strong>经营地址：</strong>
	          <input type="text" style="margin-top:5px;width:200px;text-align:left" id="management_addr_txt" name="Option4" value="${doc.option4}"/>
	          <input type="hidden" id="management_addr" value="${dto.management_addr}"/>
          </td>
        </tr>
        <tr>
          <td colspan="4" style="text-align:left;">
          	<strong>申请日期：</strong>
          	<input type="text" style="margin-top:5px;width:200px;text-align:left" id="declare_date_txt" name="Option5" value="${doc.option5}"/>
          	<input type="hidden" id="declare_date" value="<fmt:formatDate value='${dto.declare_date}' type='both' pattern='yyyy-MM-dd HH:mm:ss'/>"/>
          </td>
        </tr>
        <tr>
          <td colspan="4">
            <p style="text-align:center;padding:5px"><strong>国家质量监督检验检疫总局监制 </strong></p>
          </td>
      </tr>
    </table>
    <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
            <td width="60" rowspan="12" align="center" valign="middle" class="tableLine"><p>基</p>
              <p>本</p>
              <p>情</p>
            <p>况</p></td>
              <td width="167" height="44" align="center" class="tableLine">单位名称</td>
              <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
              	<input type="text" style="width:200px;text-align:left" id="comp_name_txt_02" name="Option6" value="${doc.option6}"/>
              </td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">单位地址</td>
            <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
              	<input type="text" style="width:200px;text-align:left" id="comp_addr_txt" name="Option7" value="${doc.option7}"/>
          		<input type="hidden" id="comp_addr" value="${dto.comp_addr}"/>
            </td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">经营地址</td>
            <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
            	<input type="text" style="width:200px;text-align:left" id="management_addr_txt_02" name="Option8" value="${doc.option8}"/>
            </td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">经营面积</td>
            <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
            	<input type="text" style="width:200px;text-align:left" id="management_area_txt" name="Option9" value="${doc.option9}"/>
          		<input type="hidden" id="management_area" value="${dto.management_area}"/>
            </td>
      </tr>
      <tr>
            <td align="center" valign="middle" class="tableLine"><p>法定代表人</p>(负责人或业主）</td>
            <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
            	<input type="text" style="width:200px;text-align:left" id="legal_name_txt" name="Option10" value="${doc.option10}"/>
          		<input type="hidden" id="legal_name" value="${dto.legal_name}"/>
            </td>
      </tr>
      <tr>
            <td height="30" rowspan="3" align="center" class="tableLine">联系人</td>
            <td width="119" rowspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
            	<input type="text" style="width:140px;text-align:left" id="contacts_name_txt" name="Option11" value="${doc.option11}"/>
          		<input type="hidden" id="contacts_name" value="${dto.contacts_name}"/>
            </td>
            <td width="131" style="text-align:center;" class="tableLine"><p>联系电话<br></p></td>
            <td width="221" style="text-align:left;padding-left:10px;" class="tableLine">
            	<input type="text" style="width:200px;text-align:left" id="contacts_phone_txt" name="Option12" value="${doc.option12}"/>
          		<input type="hidden" id="contacts_phone" value="${dto.contacts_phone}"/>
            </td>
      </tr>
      <tr>
        <td align="center" class="tableLine">电子邮箱</td>
        <td width="221" style="text-align:left;padding-left:10px;" class="tableLine">
        	<input type="text" style="width:200px;text-align:left" id="mailbox_txt" name="Option13" value="${doc.option13}"/>
          	<input type="hidden" id="mailbox" value="${dto.mailbox}"/>
        </td>
      </tr>
      <tr>
        <td align="center" class="tableLine">传真</td>
        <td width="221" style="text-align:left;padding-left:10px;" class="tableLine">
        	<input type="text" style="width:200px;text-align:left" id="fax_txt" name="Option14" value="${doc.option14}"/>
          	<input type="hidden" id="fax" value="${dto.fax}"/>
        </td>
      </tr>
      <tr>
            <td height="44" style="text-align:left;padding-left:10px;" colspan="4" class="tableLine">从业人员人数：
            	<input type="text" style="width:200px;text-align:left" id="employee_num_txt" name="Option15" value="${doc.option15}"/>
          		<input type="hidden" id="employee_num" value="${dto.employee_num}"/>
            </td>
      </tr>
      <tr>
            <td height="45" align="center" class="tableLine"><p align="center">是否通过体系认证</p>验证 （证书号）</td>
            <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
            	<input type="text" style="width:200px;text-align:left" id="certificate_numver_txt" name="Option16" value="${doc.option16}"/>
          		<input type="hidden" id="certificate_numver" value="${dto.certificate_numver}"/>
            </td>
      </tr>
      <tr>
        <td height="44" colspan="4" align="left" class="tableLine" style="text-align:left;padding-left:10px"> 经营类别：
        	<input type ="checkbox" id="management_type1" name="Option47" value="1"/>食品生产
			<input type ="checkbox" id="management_type2" name="Option48" value="2"/>食品流通
			<input type ="checkbox" id="management_type3" name="Option49" value="3"/>餐饮服务
			<input type ="checkbox" id="management_type4" name="Option50" value="4"/>饮用水供应
			<input type ="checkbox" id="management_type5" name="Option51" value="5"/>公共场所
        </td>
      </tr>
        <tr>
          <td height="46" style="text-align:left;padding-left:10px" colspan="4" class="tableLine">
          	申请经营范围 ：
          		<input type="text" style="width:200px;text-align:left" id="apply_scope_txt" name="Option46" value="${doc.option46}"/>
          		<input type="hidden" id="apply_scope" value="${dto.apply_scope}"/>
          </td>
        </tr>
      </table>
<table width="700"  border="0" align="center" style="font-size: 14px;line-height: 20px;" cellpadding="0" cellspacing="0"   class="tableLine">
<logic:iterate indexId="rowIdx" id="paperlessEnclosureDTO" name="elist" type="com.dpn.ciq.model.PaperlessEnclosureDTO">
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='1' }">
      			<c:set value="1" var="ht" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='2' }">
      			<c:set value="1" var="fp" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='3' }">
      			<c:set value="1" var="tyd" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='4' }">
      			<c:set value="1" var="sywszs" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='5' }">
      			<c:set value="1" var="zwjyzs" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='6' }">
      			<c:set value="1" var="dwjyzs" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='7' }">
      			<c:set value="1" var="wszs" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='8' }">
      			<c:set value="1" var="yczs" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='9' }">
      			<c:set value="1" var="xkspwj" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='A' }">
      			<c:set value="1" var="dhtz" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='B' }">
      			<c:set value="1" var="zxd" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='C' }">
      			<c:set value="1" var="zbs" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='D' }">
      			<c:set value="1" var="lhqd" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='E' }">
      			<c:set value="1" var="bmd" scope="application" />
      		</c:if>
      		<c:if test="${paperlessEnclosureDTO.enclosure_code=='F' }">
      			<c:set value="1" var="ysbg" scope="application" />
      		</c:if>
      </logic:iterate>
      <tr>
        <td colspan="2"  class="tableLine"><p style="text-align:left;padding:10px 18px">申请人承诺：</p>
          <blockquote>
            <p style="text-align:left">
              &nbsp;&nbsp;&nbsp;&nbsp;本申请书及其所附资料中的有关内容均真实、合法，复印件与原件一致。<br/>
              &nbsp;&nbsp;&nbsp;&nbsp;如有不实之处，或违反相关法律规定的要求，本申请人愿负相应法律责任，并承担由此造成的一切后果。</p>
            <blockquote>
              <blockquote>
                <blockquote>
                  <blockquote>
                    <p><br/>
                         	签字（法定代表人/负责人或业主）：
                         	<input type="text" style="width:100px;text-align:left" id="legal_name_txt_02" name="Option17" value="${doc.option17}"/>
          					<input type="hidden" id="legal_name" value="${dto.legal_name}"/>
                         	<br>
                      <p>&nbsp;</p>
                     	           日期：
					<input type="text" style="width:150px;text-align:left" id="sqdate" name="Option18" value="${doc.option18}"/></p>
                      <p>&nbsp;</p>
                    <blockquote>
                      <blockquote>
                        <p>            （公章）</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p>
                      </blockquote>
                    </blockquote>
                  </blockquote>
                </blockquote>
              </blockquote>
            </blockquote>
        </blockquote></td>
</tr>
      <tr>
        <td height="37" colspan="2" valign="middle" class="tableLine">以下各栏由检验检疫机构填写:</td>
      </tr>
      <tr>
        <td width="78" height="74" align="center" valign="middle" class="tableLine">受理</td>
        <td width="620" colspan="-3" align="center" valign="middle" class="tableLine">
        	<p>&nbsp;</p> 
        	签名：<input id="slr" type="text" style="width:100px;text-align:left" name="Option19" value="${doc.option19}"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
        	<p>&nbsp;</p> 
        	电子签名 （各局默认各自的签字）         日期： <input id="slsj" type="text" style="width:150px;text-align:left" name="Option20" value="${doc.option20}"/>
        	<p>&nbsp;</p>
        	<p>&nbsp;</p>  
        </td>
      </tr>
      <tr>
        <td height="53" colspan="2" style="text-align:left;padding-left:10px" valign="middle" class="tableLine">
        	审批项目：
        <input type="text" style="width:300px;text-align:left" id="spxm" name="Option21" value="${doc.option21}"/></p>
        </td>
      </tr>
      <tr>
        <td height="39" valign="middle" class="tableLine">初审</td>
        <td valign="top" class="tableLine">
          <p style="text-align:left;padding:10px 18px">材料审查</p>
          <p style="text-align:left;padding-left:170px"><span style="margin-right:50px">签名：<input type="text" style="width:100px;text-align:left" id="slr2" name="Option22" value="${doc.option22}"/></span> 日期：&nbsp;&nbsp; <input type="text" style="width:150px;text-align:left" id="slsj2" name="Option23" value="${doc.option23}"/><br>
          <p style="text-align:left;padding:10px 18px">现场审核 </p>
          <p style="text-align:left;padding-left:170px"><span style="margin-right:50px">签名：<input type="text" style="width:100px;text-align:left" id="zz_txt" name="Option24" value="${doc.option24}"/></span> 日期：&nbsp;&nbsp; <input type="text" style="width:150px;text-align:left" id="xcscDate_txt" name="Option25" value="${doc.option25}"/></p>
          <p style="text-align:left;padding:10px 18px">结论： <input type="text" style="width:400px;text-align:left" id="slqm_txt" name="Option26" value="${doc.option26}"/></p>
        </td>
      </tr>
      <tr>
        <td height="39" valign="middle" class="tableLine">复审</td>
        <td align="left" valign="middle" class="tableLine">
                <p style="text-align:left;padding:10px 18px"><span style="margin-right:110px">签名： <input type="text" style="width:100px;text-align:left" id="slqm_txt" name="Option27" value="${doc.option27}"/></span>日期: <input type="text" style="width:150px;text-align:left" id="slqm_txt" name="Option28" value="${doc.option28}"/></p>
        </td>
      </tr>
      <tr>
        <td height="137" valign="middle" class="tableLine">决定</td>
        <td class="tableLine"><blockquote>
          <blockquote>
            <blockquote>
              <blockquote>
                <blockquote>
                  <p>签名： <input type="text" style="width:100px;text-align:left" id="jdr" name="Option29" value="${doc.option29}"/>                日期： <input type="text" style="width:150px;text-align:left" id="jdsj" name="Option30" value="${doc.option30}"/>        </p>
                  <blockquote>
                    <p>&nbsp;</p>
                    <p>(盖章)</p>
                    <p>&nbsp;</p>
                  </blockquote>
                </blockquote>
              </blockquote>
            </blockquote>
          </blockquote>
        </blockquote></td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left" class="tableLine">
          <p>&nbsp;</p>
          <p>
          	<span style="margin-left:70px;padding-right:40px">制证日期：</span>
          	<input type="text" style="width:32px;text-align:left" id="slqm_txt" name="Option31" value="${doc.option31}"/>年
          	<input type="text" style="width:20px;text-align:left" id="slqm_txt" name="Option32" value="${doc.option32}"/>月
          	<input type="text" style="width:20px;text-align:left" id="slqm_txt" name="Option33" value="${doc.option33}"/>日
          	&nbsp;&nbsp;&nbsp;&nbsp;制证人：<input type="text" style="width:100px;text-align:left" id="slqm_txt" name="Option34" value="${doc.option34}"/> 
          </p>
          <p>&nbsp;</p>
          <p>
          	<span style="margin-left:70px;padding-right:40px">有效期限：</span>
            <input type="text" style="width:32px;text-align:left" name="Option35" value="${doc.option35}"/>年
            <input type="text" style="width:20px;text-align:left" name="Option36" value="${doc.option36}"/>月
            <input type="text" style="width:20px;text-align:left" name="Option37" value="${doc.option37}"/>日
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;至
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" style="width:32px;text-align:left" name="Option38" value="${doc.option38}"/>年
            <input type="text" style="width:20px;text-align:left" name="Option39" value="${doc.option39}"/>月
            <input type="text" style="width:20px;text-align:left" name="Option40" value="${doc.option40}"/>日
          </p>
          <p>&nbsp;</p>
          <p><span style="margin-left:70px;padding-right:40px">发证日期：</span>
          <input type="text" style="width:32px;text-align:left" name="Option41" value="${doc.option41}"/>年
          <input type="text" style="width:20px;text-align:left" name="Option42" value="${doc.option42}"/>月
          <input type="text" style="width:20px;text-align:left" name="Option43" value="${doc.option43}"/>日
          &nbsp;&nbsp;&nbsp;&nbsp;    证书编号：   <input type="text" style="width:150px;text-align:left" name="Option44" value="${doc.option44}"/>     </p>
          <p>&nbsp;</p>
        </td>
      </tr>
      <tr>
      <td>
      		备注：
      </td>
        <td height="200px" >
       	 <p style="text-align:left;padding:10px">
       		<textarea rows="10" cols="80" name="Option45" >${doc.option45}</textarea>
       	 </p>
        </td>
      </tr>
      </table>
    <table width="700"  border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>&nbsp;</td>
      </tr>
    </table>
<c:if test="${clistSize>3 }">
    <logic:notEmpty name="clist">
      <logic:iterate indexId="rowIdx" id="paperlessDeclGoodsDTO" name="clist" type="com.dpn.ciq.model.PaperlessDeclGoodsDTO">
        <bean:write name="paperlessDeclGoodsDTO" property="container_code"/>
      </logic:iterate>
    </logic:notEmpty>
    </c:if>
    
    <div style="text-align: center;" class="noprint"><span>
            <input type="submit" id="submit" value="保存"  />
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      </span>
    </div>
</div>
</form>
</body>
