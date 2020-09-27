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
	    $("#sqdate").text(declare_date_text)
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
<body>
<input type="hidden" id="management_type_hide" value="${dto.management_type}"/>
<input type ="hidden" id="declare_date_hide" value="${dto.declare_date}" />
	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td colspan="4" align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center"><strong>国境口岸卫生许可证 </strong><br>
            <strong>申请书 </strong></p></td>
        </tr>
        <tr align="center">
          <td colspan="4">
          	<input type ="checkbox" <c:if test ="${dto.apply_type==1}">checked="checked"</c:if>  /><strong>初次</strong>
          </td>
        </tr>
        <tr align="center">
          <td colspan="4">
          <input type ="checkbox" <c:if test ="${dto.apply_type==2}">checked="checked"</c:if>  /><strong>变更</strong>
          </td>
        </tr>
        <tr align="center">
          <td colspan="4">
          <input type ="checkbox" <c:if test ="${dto.apply_type==3}">checked="checked"</c:if>  /><strong>延续</strong>
          
          </td>
        </tr>
        <tr align="center">
            <td colspan="4">
            <input type ="checkbox" <c:if test ="${dto.apply_type==4}">checked="checked"</c:if>  /><strong>临时经营</strong>
            </td>
        </tr>
        <tr>
          <td colspan="4">
          	<div style="text-align:left;float: left;"><strong>原卫生许可证号：
       	    <bean:write name="paperlessDeclGoodsDTO" property="ent_cname"/>
          	</strong>${dto.hygiene_license_number}</div>
          	<div style="text-align: right;"><strong>
       	    <bean:write name="paperlessDeclGoodsDTO" property="decl_no"/>
          	</strong></div>
          </td>
      </tr>
        <tr>
          <td colspan="4" style="text-align:left;"><strong>申请单位：</strong>${dto.comp_name}</td>
        </tr>
        <tr>
          <td colspan="4" style="text-align:left;"><strong>经营地址：</strong>${dto.management_addr}</td>
        </tr>
        <tr>
          <td colspan="4" style="text-align:left;"><strong>申请日期：</strong><fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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
              <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">${dto.comp_name}</td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">单位地址</td>
              <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">${dto.comp_addr}</td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">经营地址</td>
              <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">${dto.management_addr}</td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">经营面积</td>
              <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">${dto.management_area}</td>
      </tr>
      <tr>
            <td align="center" valign="middle" class="tableLine"><p>法定代表人</p>              (负责人或业主）</td>
              <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">${dto.legal_name}</td>
      </tr>
      <tr>
            <td height="30" rowspan="3" align="center" class="tableLine">联系人</td>
              <td width="119" rowspan="3" style="text-align:left;padding-left:10px;" class="tableLine">${dto.contacts_name}</td>
              <td width="131" style="text-align:center;" class="tableLine"><p>联系电话<br></p></td>
              <td width="221" style="text-align:left;padding-left:10px;" class="tableLine">${dto.contacts_phone}</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">电子邮箱</td>
        <td width="221" style="text-align:left;padding-left:10px;" class="tableLine">${dto.mailbox}</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">传真</td>
        <td width="221" style="text-align:left;padding-left:10px;" class="tableLine">${dto.fax}</td>
      </tr>
      <tr>
            <td height="44" style="text-align:left;padding-left:10px;" colspan="4" class="tableLine">从业人员人数：${dto.employee_num}</td>
      </tr>
      <tr>
            <td height="45" align="center" class="tableLine"><p align="center">是否通过体系认证</p>验证 （证书号）</td>
            <td colspan="3" style="text-align:left;padding-left:10px;" class="tableLine">
            	<c:if test="${dto.certificate_numver == 0}">
					否
				</c:if>
				<c:if test="${dto.certificate_numver == 1}">
					是
				</c:if>
            </td>
      </tr>
      <tr>
        <td height="44" colspan="4" align="left" class="tableLine" style="text-align:left;padding-left:10px"> 经营类别：
        	<input type ="checkbox" id="management_type1"/>食品生产
			<input type ="checkbox" id="management_type2"/>食品流通
			<input type ="checkbox" id="management_type3"/>餐饮服务
			<input type ="checkbox" id="management_type4"/>饮用水供应
			<input type ="checkbox" id="management_type5"/>公共场所
        </td>
      </tr>
        <tr>
          <td height="46" style="text-align:left;padding-left:10px" colspan="4" class="tableLine">申请经营范围： ${dto.apply_scope}</td>
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
                         	签字（法定代表人/负责人或业主）：${dto.legal_name} <br>
                      <p>&nbsp;</p>
                     	           日期：<span id="sqdate"></span></p>
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
        	签名：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
        	<p>&nbsp;</p> 
        	电子签名 （各局默认各自的签字）         日期： 
        	<p>&nbsp;</p>
        	<p>&nbsp;</p>  
        </td>
      </tr>
      <tr>
        <td height="53" colspan="2" style="text-align:left;padding-left:10px" valign="middle" class="tableLine">审批项目：</td>
      </tr>
      <tr>
        <td height="39" valign="middle" class="tableLine">初审</td>
        <td valign="top" class="tableLine">
          <p style="text-align:left;padding:10px 18px">材料审查</p>
          <p style="text-align:left;padding-left:170px"><span style="margin-right:100px">签名：</span> 日期：&nbsp;&nbsp; <br>
          <p style="text-align:left;padding:10px 18px">现场审核 </p>
          <p style="text-align:left;padding-left:170px"><span style="margin-right:100px">签名：</span> 日期：&nbsp;&nbsp; </p>
          <p style="text-align:left;padding:10px 18px">结论： </p>
        </td>
      </tr>
      <tr>
        <td height="39" valign="middle" class="tableLine">复审</td>
        <td align="left" valign="middle" class="tableLine"><blockquote>
          <blockquote>
            <blockquote>
              <blockquote>
                <blockquote>
                  <p style="text-align:left;padding:10px 18px"><span style="margin-right:110px">签名：</span>日期: </p>
                </blockquote>
              </blockquote>
            </blockquote>
          </blockquote>
        </blockquote></td>
      </tr>
      <tr>
        <td height="137" valign="middle" class="tableLine">决定</td>
        <td class="tableLine"><blockquote>
          <blockquote>
            <blockquote>
              <blockquote>
                <blockquote>
                  <p>签名：                 日期：         </p>
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
          	<span style="margin-left:100px;padding-right:40px">制证日期：</span>
          	&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;制证人： 
          </p>
          <p>&nbsp;</p>
          <p>
          	<span style="margin-left:100px;padding-right:40px">有效期限：</span>
            &nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;至&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日
          </p>
          <p>&nbsp;</p>
          <p><span style="margin-left:100px;padding-right:40px">发证日期：</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;    证书编号：        </p>
          <p>&nbsp;</p>
        </td>
      </tr>
      <tr>
        <td height="200px" colspan="2" >
       	 <p style="text-align:left;padding:10px">备注：</p>
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
     <!--  <input onClick="javascript:history.back();" type="button" class="btn" value="返回" /> -->
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      </span>
    </div>
</div>
</body>
