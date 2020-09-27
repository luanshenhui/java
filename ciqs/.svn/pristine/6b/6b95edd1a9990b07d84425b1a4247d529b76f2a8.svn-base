<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">
<%-- /**
 * 打开不予受理告知书
 */
 function byWinShow(){
 	location = "<%=request.getContextPath()%>/dc/printXzBysl.jsp?declare_date="+$("#declare_date").val();
 }
 
/**
 * 打开受理告知书
 */
 function slWinShow(){
 	location = "<%=request.getContextPath()%>/dc/printXzSljds.jsp?declare_date="+$("#declare_date").val()
 	+"&comp_name="+$("#comp_name").val()
 	+"&legal_name="+$("#legal_name").val()
 	+"&management_addr="+$("#management_addr").val()
 	+"&contacts_name="+$("#contacts_name").val()
 	+"&contacts_phone="+$("#contacts_phone").val();
 } --%>
 
 function winShow(no,type){
	 	window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
	 	+no+"&doc_type="+type);
 }
/**
 * 下载文件
 */
 function downloadFile(type){

     var filePath = $("#filePath").val();
     var filePath2 = $("#filePath2").val();
     if(filePath !=null){
      filePath = filePath.substring(14,filePath.length);
     }
     if(filePath2 !=null){
      filePath2 = filePath2.substring(14,filePath2.length);
     }
     if(type ==1){
	  	 location = "<%=request.getContextPath()%>/dc/downloadFile?path="+filePath;
     }else{
    	 location = "<%=request.getContextPath()%>/dc/downloadFile?path="+filePath2;
     }
 } 
 function zgsShow(no){
			window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+no);
 }
 jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
		});
/**
 * 卫生许可证申报表单提交
 */
jQuery (function () {	
	$("#smt").click (function () {
	    var filepath = $("#fileUpload").val();
	    var type = filepath.substring(filepath.lastIndexOf('.')+1,filepath.length);
		if(type != 'rar' && type != 'zip' && filepath != ''){
			alert("请选择上传rar或zip格式的文件!");
			return;
		}
		$("#licenseDecForm").submit();
		lockScreen();
	});
});

function winShow2(no,type,comp_name,ws_type){	
	var ws_type = 0;
	if($("#jd_result").val() == "0"){
   		ws_type =4;
    }
	if($("#jd_result").val() == "1"){
   		ws_type =5;
    }
   	window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
   		+no+"&doc_type="+type+"&comp_name="+comp_name+"&type=sdhz4&ws_type="+ws_type);
}

function byWinShow(id,obj,license_dno,comp_name){
		window.open("${ctx}/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
}

function byWinShow2(id,obj,license_dno,comp_name){
	window.open("${ctx}/xk/toByslsOld2?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
}

function look(license_dno){
	$.ajax({
		url : "/ciqs/expFoodPOF/findFile?main_id="+license_dno,
		type : "GET",
		dataType : "json",
		success : function(data) {
			if (data.status == "OK") {
				window.location.href="/ciqs/expFoodPOF/download?fileName="+data.path;
			} else {
				return alert("暂无附件！");
			}
		}
	});
}
</script>
</head>
<body>
<%@ include file="/common/headMenu_XkDec.jsp"%>
<div class="dpn-content">
    <div class="crumb">
	             当前位置：卫生许可证 &gt;<span class="tpinfo">详情</span>
    </div>
     <jsp:include page="/common/message.jsp" flush="true"/>
    <div class="form">
		<div class="main">
    <form action="<%=request.getContextPath()%>/dc/wsFileUpload2" method="post" id="licenseDecForm"  enctype="multipart/form-data">
	<%-- <html:form styleId="LicenseDecForm" action="/addLicenseDec.do?doType=addLicenseDec" enctype="multipart/form-data" method="post"> --%>
        <input type = "hidden" name="license_dno" value="${dto.license_dno}">
        <input type="hidden" id="declare_date" value="${dto.declare_date}"/>
        <input type="hidden" id="filePath" value="${filePath}"/>
        <input type="hidden" id="filePath2" value="${filePath2}"/>
        <input type="hidden" id="comp_name" value="${dto.comp_name}"/>
        <input type="hidden" id="legal_name" value="${dto.legal_name}"/>
        <input type="hidden" id="management_addr" value="${dto.management_addr}"/>
        <input type="hidden" id="contacts_name" value="${dto.contacts_name}"/>
        <input type="hidden" id="contacts_phone" value="${dto.contacts_phone}"/>
        <input type="hidden" id="jd_result" value="${dto.jd_result}"/>
        
		<table id="form_table">
		    <tr>
				<th style="width:20%;" id="left_noline">单位名称：</th>
				<td style="width:30%;">
					${dto.comp_name}
				</td>
				<th style = "width:20%;">单位地址：</th>
				<td id="right_noline" style="width:30%;">
					${dto.comp_addr}
				</td>
			</tr>
			<tr>
				<th id="left_noline">经营地址：</th>
				<td>
					${dto.management_addr}
				</td>
				<th>经营面积：</th>
				<td id="right_noline" ">
					${dto.management_area}
				</td>
			</tr>
		    <tr>
				<th id="left_noline">法定代表人：</th>
				<td>
					${dto.legal_name}
				</td>
				<th>联系人：</th>
				<td id="right_noline" >
					${dto.contacts_name}
				</td>
			</tr>
		    <tr>
				<th id="left_noline">联系电话：</th>
				<td >
					${dto.contacts_phone}
				</td>
				<th >电子邮箱：</th>
				<td id="right_noline" >
					${dto.mailbox}
				</td>
			</tr>
			<tr>
				<th id="left_noline">传真：</th>
				<td>
					${dto.fax}
				</td>
				<th >从业人员人数：</th>
				<td id="right_noline">
					${dto.employee_num}
				</td>
			</tr>
			<tr>
				<th id="left_noline">通过体系认证、验证：</th>
				<td>
                    <c:if test="${dto.certificate_numver == 1}">
                    	是
                    </c:if>
                    <c:if test="${dto.certificate_numver == 0}">
                    	否
                    </c:if>
				</td>
				<th>申请经营范围：</th>
				<td id="right_noline" >
					${dto.apply_scope}
				</td>
			</tr>
			<tr>
				<th id="left_noline">经营类别：</th>
				<td id="right_noline">
					<c:forEach items="${dto.management_type}" var="items" varStatus="aa">
						<c:if test="${aa.index != 0}">
							,
						</c:if>
						<c:if test="${items == 1}">
							食品生产
						</c:if>
						<c:if test="${items == 2}">
							食品流通
						</c:if>
						<c:if test="${items == 3}">
							餐饮服务
						</c:if>
						<c:if test="${items == 4}">
							饮用水供应
						</c:if>
						<c:if test="${items == 5}">
							公共场所
						</c:if>
					</c:forEach>
				</td>
				<th id="left_noline">申请类型：</th>
				<td id="right_noline" colspan="3">				
					<c:if test="${dto.apply_type == 1}">
						初次
					</c:if>
					<c:if test="${dto.apply_type == 2}">
						变更
					</c:if>
					<c:if test="${dto.apply_type == 3}">
						延续
					</c:if>
					<c:if test="${dto.apply_type == 4}">
						临时经营
					</c:if>
				</td>
			</tr>
			
			<tr>
				<th  id="left_noline">受理局：</th>
				<td id="right_noline" >
					${dto.admissible_org_name}	
				</td>
				<th id="left_noline"><span id="hygieneLicenseSpan" class="tpinfo"></span>原卫生许可证证号：</th>
				<td id="right_noline">
					${dto.hygiene_license_number}
				</td>
			</tr>
			
			<tr>
				<th  id="left_noline">变更申请时间：</th>
				<td id="right_noline" >
					<c:if test="${dto.apply_type == 2}">
						<fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					</c:if>
				</td>
				<th id="left_noline">变更申请审批结果：</th>
				<td id="right_noline">
				   <c:if test="${dto.apply_type == 2 && dto.jd_sp == 0}">
						不同意
		           </c:if>
		           <c:if test="${dto.apply_type == 2 && dto.jd_sp == 1}">
		           		同意
		           </c:if>
				</td>
			</tr>
			<tr>
				<th id="left_noline">附件：</th>
				<td id="right_noline" colspan="4">
					<c:if test="${not empty filePath && dto.apply_type == 2}">
						<input type = "button" value="查看附件" onclick="downloadFile(1)"/>
					</c:if>
				</td>
			</tr>
			
			<tr>
				<th  id="left_noline">延续申请时间：</th>
				<td id="right_noline" >
					<c:if test="${dto.apply_type == 3}">
						<fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					</c:if>
				</td>
				<th id="left_noline">延续申请审批结果：</th>
				<td id="right_noline">
				   <c:if test="${dto.apply_type == 3 && dto.jd_sp == 0}">
						不同意
		           </c:if>
		           <c:if test="${dto.apply_type == 3 && dto.jd_sp == 1}">
		           		同意
		           </c:if>
				</td>
			</tr>
			<tr>
				<th id="left_noline">附件：</th>
				<td id="right_noline" colspan="4">
					<c:if test="${not empty filePath && dto.apply_type == 3}">
						<input type = "button" value="查看附件" onclick="downloadFile(1)"/>
					</c:if>
				</td>
			</tr>
			<!-- <tr>
				<th  id="left_noline">决定书：</th>
				<td id="right_noline" >
			
				</td>
				<th id="left_noline">送达回证：</th>
				<td id="right_noline">
					
				</td>
			</tr> -->
			
			
			<tr>
				<th  id="left_noline">补发申请时间：</th>
				<td id="right_noline" >
					<fmt:formatDate value="${bf_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>	
				</td>
				<th id="left_noline">补发申请审批结果：</th>
				<td id="right_noline">
					${bf_result}
				</td>
			</tr>
			<tr>
				<th id="left_noline">附件：</th>
				<td id="right_noline" colspan="4">
					<c:if test="${not empty filePath2 && not empty bf_date}">
						<input type = "button" value="查看附件" onclick="downloadFile(2)"/>
					</c:if>
				</td>
			</tr>
			
			<tr>
				<th  id="left_noline">终止申请时间：</th>
				<td id="right_noline" >
					<fmt:formatDate value="${zz_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>	
				</td>
				<th id="left_noline">终止申请审批结果：</th>
				<td id="right_noline">
					<c:if test ="${zz_result == 1}">申请事项依法不需要取得卫生许可</c:if>
					<c:if test ="${zz_result == 2}">申请事项依法不属于本检验检疫机构职权范围</c:if>
					<c:if test ="${zz_result == 3}">申请人未在规定期限内补正有关申请材料</c:if>
					<c:if test ="${zz_result == 4}">申请人撤回卫生许可申请</c:if>
					<c:if test ="${zz_result == 5}">其他依法应当终止办理卫生许可</c:if>				
				</td>
			</tr>
			
			<tr>
				<th  id="left_noline">决定书：</th>
				<td id="right_noline" >
					<c:if test="${not empty zz_result }">
						<a href = "#" onclick="byWinShow2('${dto.id}','${dto.declare_date}',
							'${dto.license_dno}','${dto.comp_name}')">不予受理决定书</a>	
					</c:if>				
				</td>
				<th id="left_noline">送达回证：</th>
				<td id="right_noline">
					<c:if test="${not empty zz_result }">
						<a href = "#"  onclick="winShow('${dto.license_dno}','D_SDHZ5','${dto.comp_name}')">送达回证</a>
					</c:if>
				</td>
			</tr>
			
			<tr>
				<th  id="left_noline">注销申请时间：</th>
				<td id="right_noline" >
					<fmt:formatDate value="${zx_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>	
				</td>
				<th id="left_noline">注销申请审批结果：</th>
				<td id="right_noline">
					<c:if test ="${zx_result == 1}">卫生许可有效期届满未延续</c:if>
					<c:if test ="${zx_result == 2}">法人或者其他组织依法终止</c:if>
					<c:if test ="${zx_result == 3}">被许可人申请注销卫生许可</c:if>
					<c:if test ="${zx_result == 4}">卫生许可依法被撤销、撤回，或者卫生许可证件依法被吊销</c:if>
					<c:if test ="${zx_result == 5}">因不可抗力导致卫生许可事项无法实施</c:if>				
					<c:if test ="${zx_result == 6}">法律、法规规定的应当注销卫生许可的其他情形</c:if>
				</td>
			</tr>
			<tr>
				<th  id="left_noline">工作提醒附件：</th>
				<td id="right_noline" colspan="3">
					<input type="button" onclick="look('${dto.license_dno}')"  value="查看" />
				</td>
			</tr>
		</table>

		<div class = "table_spacing"></div>
		<div class = "action">
			
			<input onclick="javascript:history.go(-1);" class="btn" value="返回" type="button">
		</div>
	</form>
	</div>
	</div>
</div>
</body>
</html>
 