<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>国境口岸卫生许可现场审查派员申请书</title>
<%@ include file="/common/resource_new.jsp"%>
</head>
<body>
<script type="text/javascript">

	document.body.onload=function onloads(){
	 	// 签名人员
	   	if($("#o24").val() == ""){
	   		$("#o24").val($("#userId").val());
	   	}else if($("#o36").val() == "" && $("#userId").val() !=$("#o24").val()){
			$("#o36").val($("#userId").val());
		}else if($("#o41").val() == "" && $("#userId").val() !=$("#o36").val() 
				&& $("#userId").val() !=$("#o24").val()){
			$("#o41").val($("#userId").val());	
		}else if($("#o46").val() == "" && $("#userId").val() !=$("#o36").val() 
				&& $("#userId").val() !=$("#o24").val() && $("#userId").val() !=$("#o41").val()){
			$("#o46").val($("#userId").val());
		}else if($("#o51").val() == "" && $("#userId").val() !=$("#o36").val() 
				&& $("#userId").val() !=$("#o24").val() && $("#userId").val() !=$("#o41").val()
				&& $("#userId").val() !=$("#o46").val()){
			$("#o51").val($("#userId").val());
		}
   		// 签名受理局
	   	if($("#o35").val() == ""){
	   		$("#o35").val($("#orgCode").val());
	   	}else if($("#o40").val() == "" && $("#orgCode").val() !=$("#o35").val() ){
			$("#o40").val($("#orgCode").val());
		}else if($("#o45").val() == "" && $("#orgCode").val() !=$("#o35").val()
				&& $("#orgCode").val() !=$("#o40").val()){
			$("#o45").val($("#orgCode").val());	
		}else if($("#o50").val() == "" && $("#orgCode").val() !=$("#o35").val()
				&& $("#orgCode").val() !=$("#o40").val() && $("#orgCode").val() !=$("#o45").val()){
			$("#o50").val($("#orgCode").val());
		}else if($("#o55").val() == "" && $("#orgCode").val() !=$("#o35").val()
				&& $("#orgCode").val() !=$("#o40").val() && $("#orgCode").val() !=$("#o45").val()
				&& $("#orgCode").val() !=$("#o50").val()){
			$("#o55").val($("#orgCode").val());
		}
/* 	   	var nowate =new Date();
	    var yyyy = nowate.getFullYear();
	    var mm = (nowate.getMonth()+1);
	    var dd = nowate.getDate();
	 	// 签名年月日
	   	if($("#o35").val() == ""){
	   		$("#o35").val($("#orgCode").val());
	   	}else if($("#o40").val() == ""){
			$("#o40").val($("#orgCode").val());
		}else if($("#o45").val() == ""){
			$("#o45").val($("#orgCode").val());	
		}else if($("#o50").val() == ""){
			$("#o50").val($("#orgCode").val());
		}else if($("#o55").val() == ""){
			$("#o55").val($("#orgCode").val());
		} */
	 	
        var option_11 = $("#option_11").val();
		var option_17 = $("#option_17").val();
		if(option_11 == 1){
			$("#o11s").attr("checked",true);
		}
		if(option_11 == 0){
			$("#o11f").attr("checked",true);
		}
		if(option_17 == 1){
			$("#o17yj").attr("checked",true);
		}
		if(option_17 == 0){
			$("#o17zq").attr("checked",true);
		}
	};
	
	$(function(){
		if($("#comp_name").val() == ""){
			$("#comp_name").val($("#comp_name_hide").val());
		}
		if($("#comp_addr").val() == ""){
			$("#comp_addr").val($("#comp_addr_hide").val());
		}
		if($("#management_addr").val() == ""){
			$("#management_addr").val($("#management_addr_hide").val());
		}
		if($("#management_area").val() == ""){
			$("#management_area").val($("#management_area_hide").val());
		}
		if($("#contacts_name").val() == ""){
			$("#contacts_name").val($("#contacts_name_hide").val());
		}
		if($("#contacts_phone").val() == ""){
			$("#contacts_phone").val($("#contacts_phone_hide").val());
		}
		if($("#mailbox").val() == ""){
			$("#mailbox").val($("#mailbox_hide").val());
		}
		if($("#fax").val() == ""){
			$("#fax").val($("#fax_hide").val());
		}
		if($("#employee_num").val() == ""){
			$("#employee_num").val($("#employee_num_hide").val());
		}
		
		//if($("#zz").val() == ""){
		    var approval_users_name =$("#approval_users_name_hide").val();
		    if(approval_users_name == null || approval_users_name == ""){
		    	approval_users_name=$("#sczry").val();
		    }
		    approval_users_name = approval_users_name.substring(0,approval_users_name.length);
		    if(approval_users_name !=null && approval_users_name.length > 0){
			    var arr = approval_users_name.split(',');
			    
			    var str = "";
			    for (var i = 1; i < arr.length; i++) {
					if(i!=1){
						str+=","+arr[i];	
					}else{
						str+=arr[i];
					}
				}
			    var str2="";
			    if(arr[0]==""){
			    	var arr2 = str.split(',');
			    	for (var i = 1; i < arr2.length; i++) {
						if(i!=1){
							str2+=","+arr2[i];	
						}else{
							str2+=arr2[i];
						}
					}
			    }
			    if(arr[0]==""){
			    	$("#zz").val(arr[1]);
			    	$("#zy").val(str2);
			    }else{
					$("#zz").val(arr[0]);
					$("#zy").val(str);
			    }
			}
		//}
		if($("#tuser").val()==""){
			$("#tuser").val($("#userId").val());
		}
		if($("#torg").val()==""){
			$("#torg").val($("#orgname").val());
		}
		var slsj_date = new Date();
	    var slsj_date_text = slsj_date.getFullYear() +"年"+ (slsj_date.getMonth()+1) +"月"+ slsj_date.getDate() +"日";
		if($("#tdate").val()==""){
			$("#tdate").val(slsj_date_text);
		}
		
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

<form action="/ciqs/dc/submitDoc"  method="post">
<input type ="hidden" id="comp_name_hide" value="${dto.comp_name}" />
<input type ="hidden" id="comp_addr_hide" value="${dto.comp_addr}" />
<input type ="hidden" id="management_addr_hide" value="${dto.management_addr}" />
<input type ="hidden" id="contacts_name_hide" value="${dto.contacts_name}" />
<input type ="hidden" id="contacts_phone_hide" value="${dto.contacts_phone}" />
<input type ="hidden" id="mailbox_hide" value="${dto.mailbox}" />
<input type ="hidden" id="fax_hide" value="${dto.fax}" />
<input type ="hidden" id="employee_num_hide" value="${dto.employee_num}" />
<input type ="hidden" id="approval_users_name_hide" value="${dto.approval_users_name}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_SQ_SHRY" />
<input type ="hidden" name="DocId" value="${doc.docId}" />
<input type ="hidden" id="userId" value="${userId}" />
<input type ="hidden" id="orgname" value="${orgname}" />
<input type ="hidden" id="orgCode" value="${orgCode}" />
<input type ="hidden" id="sczry" value="${sczry}" />
<input type="hidden" id="management_type_hide" value="${dto.management_type}"/>
	<div id="content">
    <table width="763" align="center">
        <tr>
          <td colspan="3" align="center" style="height:60px;font-size:25px;font-family:'楷体_GB2312';font-weight: bold;">
          	国境口岸卫生许可现场审查派员申请书
          </td>
        </tr>
        <tr>
          <td style="height:40px;text-align:left">申请分支机构：<input readonly="readonly" id="torg" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option1}" name="option1"/></td>
          <td style="text-align:left">填报人：<input readonly="readonly" id="tuser" style="text-align:left;padding-left:5px;width:120px" type ="text" value="${doc.option2}" name="option2"/></td>
          <td style="text-align:left">日期：<input readonly="readonly" id="tdate" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option3}" name="option3"/></td>
        </tr>
        <tr>
          <td style="height:40px;text-align:left" width="257">联系电话：
            <input readonly="readonly" style="text-align:left;padding-left:5px;width:120px;margin-left:24px;" type ="text" value="${doc.option4}" name="option4"/>
          </td>
          <td style="text-align:left" width="191">传  真：
          	<input readonly="readonly" style="text-align:left;width:120px;margin-left:2px;" type ="text" value="${doc.option5}" name="option5"/>
          </td>
          <td style="text-align:left" width="305">
          
          </td>
        </tr>
    </table>
    <table width="760"  border="0" align="center" style="font-size: 14px; line-height: 30px; text-align: left;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
        <td height="44" align="center" class="tableLine">单位名称</td>
        <td colspan="3" align="center" class="tableLine" style="text-align:left;padding-left:10px;">
        	<input readonly="readonly" id="comp_name" style="text-align:left;padding-left:5px;width:500px" type ="text" value="${doc.option6}" name="option6"/>
        </td>
      </tr>
      <tr>
         <td width="195" height="44" align="center" class="tableLine">单位地址</td>
         <td colspan="3" align="center" class="tableLine" style="text-align:left;padding-left:10px;">
           <input readonly="readonly" id="comp_addr" style="text-align:left;padding-left:5px;width:500px" type ="text" value="${doc.option7}" name="option7"/>
         </td>
      </tr>
      <tr>
         <td height="44" align="center" class="tableLine">经营地址及办公电话</td>
         <td colspan="3" align="center" class="tableLine" style="text-align:left;padding-left:10px;">
           <input readonly="readonly" id="management_addr" style="text-align:left;padding-left:5px;width:500px" type ="text" value="${doc.option8}" name="option8"/>
         </td>
      </tr>
      <tr>
        <td height="44" align="center" class="tableLine">联系人</td>
        <td width="176" align="center" class="tableLine">
        	<input readonly="readonly" id="contacts_name" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option9}" name="option9"/>
        </td>
        <td width="187" align="center" class="tableLine">联系人电话</td>
        <td width="202" align="center" class="tableLine">
        	<input readonly="readonly" id="contacts_phone" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option10}" name="option10"/>
        </td>
      </tr>
      <tr>
        <td height="44" align="center" class="tableLine">传  真</td>
        <td align="center" class="tableLine">
        	<input readonly="readonly" id="fax" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option11}" name="option11"/>
        </td>
        <td align="center" class="tableLine">电子邮箱</td>
        <td align="center" class="tableLine">
        	<input readonly="readonly" id="mailbox" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option12}" name="option12"/>
        </td>
      </tr>
      <tr>
        <td height="44" align="center" class="tableLine">从业人员人数</td>
        <td align="center" class="tableLine">
        	<input readonly="readonly" id="employee_num" style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option13}" name="option13"/>
        </td>
        <td align="center" class="tableLine">应体检人数</td>
        <td align="center" class="tableLine">
       		<input readonly="readonly" style="text-align:left;padding-left:5px;width:180px" type ="text" value="${doc.option14}" name="option14"/>
        </td>
      </tr>
      <tr>
        <td height="44" colspan="4" style="text-align:left;padding-left:50px" class="tableLine">
        	经营类别：
        	
        	<input type="checkbox" id="management_type1" name="option30" value="1" />食品生产   
        	<input type="checkbox" id="management_type2" name="option34" value="2" />食品流通
        	<input type="checkbox" id="management_type3" name="option32" value="3" />餐饮服务  
        	<input type="checkbox" id="management_type4" name="option31" value="4" />饮用水供应 
        	<input type="checkbox" id="management_type5" name="option33" value="5" />公共场所  
                
        </td>
      </tr>
      <tr>
        <td height="44" colspan="4" style="text-align:left;padding-left:50px" class="tableLine">
        	申请性质：
        	<input disabled="disabled" type="radio" name="option16" value="1" <c:if test="${dto.apply_type == 1}">checked="checked"</c:if> />初次申请   
        	<input disabled="disabled" type="radio" name="option16" value="2" <c:if test="${dto.apply_type == 2}">checked="checked"</c:if> />变更申请   
        	<input disabled="disabled" type="radio" name="option16" value="3" <c:if test="${dto.apply_type == 3}">checked="checked"</c:if> />延续申请    
        	<input disabled="disabled" type="radio" name="option16" value="4" <c:if test="${dto.apply_type == 4}">checked="checked"</c:if> />评级申请
        </td>
      </tr>
      <tr>
        <td colspan="4" style="text-align:left;padding:20px 50px 20px 50px" height="30" class="tableLine">
       		<p>受理部门批复意见： </p>
        	<p>根据被审查方的申请，我局组织审查组对该申请企业进行国境口岸卫生许可现场审查。</p>
        	<p>请审查组成员做好审查前的准备工作，并按审查组组长的安排准时到被审查单位报到，审查组成员的交通费、食宿费由所在单位承担。 </p>
	        	<p style="padding-left:100px;margin-top:10px;">
	        	卫生处/科负责人签字：<input readonly="readonly" style="margin-right:50px;text-align:left;padding-left:5px;width:100px" type ="text" value="${doc.option17}" name="option17"/>
	        	<input readonly="readonly" style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option18}" name="option18"/>年<input readonly="readonly" style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option19}" name="option19"/>月<input readonly="readonly" style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option20}" name="option20"/>日
	        	</p>
			<p style="padding-left:100px;">（公章）</p>   
        </td>
      </tr>
      <tr>
      	<td colspan="4" style="text-align:left;padding:20px 50px 20px 50px" height="44" class="tableLine">
      		<p>审查组成员名单       姓  名           单位          </p>
      		<p>审查组长：<input id="zz" readonly="readonly" style="text-align:left;padding-left:5px;width:300px;margin-left:13px;" type ="text" value="${doc.option21}" name="option21"/></p>
			<p>审查组成员：<input id="zy" readonly="readonly" style="text-align:left;padding-left:5px;width:500px" type ="text" value="${doc.option22}" name="option22"/></p>
		</td>
      </tr>
      <tr>
      	<td height="92" align="center" class="tableLine"><p align="center">审查组成员所在单位意见</p></td>
    	<td colspan="3" style="text-align:left;padding-left:10px;" align="center" class="tableLine">
    		<p>
    			同意<input type="radio" value="1"  name="option23" <c:if test="${doc.option23 == 1}">checked="checked"</c:if>/>       
    			不同意 <input type="radio" name="option23" value="0" <c:if test="${doc.option23 == 0}">checked="checked"</c:if> />
    		</p>
    		<p style="height:20px"></p>
    		
    		
			<p>领导签名： <input id="o24" readonly="readonly" style="text-align:left;padding-left:5px;width:100px" type ="text" value="${doc.option24}" name="option24"/>
			（公章）<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option25}" name="option25"/>年<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option26}" name="option26"/>月<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option27}" name="option27"/>日</p>
			<input id="o35" type ="hidden" value="${doc.option35}" name="option35" />
			
			<p>领导签名： <input id="o36" readonly="readonly" style="text-align:left;padding-left:5px;width:100px" type ="text" value="${doc.option36}" name="option36"/>
			（公章）<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option37}" name="option37"/>年<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option38}" name="option38"/>月<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option39}" name="option39"/>日</p>
			<input id="o40" type ="hidden" value="${doc.option40}" name="option40" />
			
			<p>领导签名： <input id="o41" readonly="readonly" style="text-align:left;padding-left:5px;width:100px" type ="text" value="${doc.option41}" name="option41"/>
			（公章）<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option42}" name="option42"/>年<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option43}" name="option43"/>月<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option44}" name="option44"/>日</p>
			<input id="o45" type ="hidden" value="${doc.option45}" name="option45" />
			
			<p>领导签名： <input id="o46" readonly="readonly" style="text-align:left;padding-left:5px;width:100px" type ="text" value="${doc.option46}" name="option46"/>
			（公章）<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option47}" name="option47"/>年<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option48}" name="option48"/>月<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option49}" name="option49"/>日</p>
			<input id="o50" type ="hidden" value="${doc.option50}" name="option50" />
			
			<p>领导签名： <input id="o51" readonly="readonly" style="text-align:left;padding-left:5px;width:100px" type ="text" value="${doc.option51}" name="option51"/>
			（公章）<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option52}" name="option52"/>年<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option53}" name="option53"/>月<input style="text-align:left;padding-left:5px;width:60px" type ="text" value="${doc.option54}" name="option54"/>日</p>
    		<input id="o55" type ="hidden" value="${doc.option55}" name="option55" />
    		
    	</td>
      </tr>
	  <tr>
	    <td height="77" colspan="4" style="text-align:left;padding-left:10px;"  class="tableLine">
	   	 保密要求：参加现场审查的审查组人员应对有关被审查方的文件、资料以及在审查过程中所获得的被审查方的需保密的信息保密。
	    </td>
</table>
<div style="text-align:left;padding-left:10px;width:763px;margin:0px auto">
	<p>请审查组成员所在单位签署意见后二日内传真给受理单位。 </p>
	<p>联系电话：<input style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option28}" name="option28"/>
	传真：<input style="text-align:left;padding-left:5px;width:150px" type ="text" value="${doc.option29}" name="option29"/></p>
</div>
<div style="text-align: center;" class="noprint">
    <span>
    	<input type="submit" value="保存" type="button" onclick="javascript:save()" />
		<input type="button" value="打印" type="button" onclick="javascript:window.print()" />
    </span>
</div>

</div>
</form>
</body>
</html>
