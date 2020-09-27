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
	 
	 location = "<%=request.getContextPath()%>/dc/downloadFile?path="+filePath2;
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
</script>
</head>
<body>
<%@ include file="/common/headMenu_XkDec.jsp"%>
<div class="dpn-content">
    <div class="crumb">
	             当前位置：卫生许可证 &gt;<span class="tpinfo">注销  </span>
    </div>
     <jsp:include page="/common/message.jsp" flush="true"/>
    <div class="form">
		<div class="main">
    <form action="<%=request.getContextPath()%>/dc/wsFileUpload2" method="post" id="licenseDecForm"  enctype="multipart/form-data">
	<%-- <html:form styleId="LicenseDecForm" action="/addLicenseDec.do?doType=addLicenseDec" enctype="multipart/form-data" method="post"> --%>
        <input type = "hidden" name="license_dno" value="${dto.license_dno}">
        <input type="hidden" id="declare_date" value="${dto.declare_date}"/>
        <input type="hidden" id="filePath" value="${dto.filePath}"/>
        <input type="hidden" id="filePath2" value="${dto.filePath2}"/>
        <input type="hidden" id="comp_name" value="${dto.comp_name}"/>
        <input type="hidden" id="legal_name" value="${dto.legal_name}"/>
        <input type="hidden" id="management_addr" value="${dto.management_addr}"/>
        <input type="hidden" id="contacts_name" value="${dto.contacts_name}"/>
        <input type="hidden" id="contacts_phone" value="${dto.contacts_phone}"/>
		<table id="form_table">
		    <tr>
				<th style="width:30%;" id="left_noline">单位名称：</th>
				<td style="width:25%;">
					${dto.comp_name}
				</td>
				<th style = "width:20%;">单位地址：</th>
				<td id="right_noline" style="width:30%;">
					${dto.comp_addr}
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">经营地址：</th>
				<td style="width:25%;">
					${dto.management_addr}
				</td>
				<th style = "width:20%;">经营面积：</th>
				<td id="right_noline" style="width:30%;">
					${dto.management_area}
				</td>
			</tr>
		    <tr>
				<th style="width:30%;" id="left_noline">法定代表人（负责人或业主）：</th>
				<td style="width:25%;">
					${dto.legal_name}
				</td>
				<th style = "width:20%;">联系人：</th>
				<td id="right_noline" style="width:30%;">
					${dto.contacts_name}
				</td>
			</tr>
		    <tr>
				<th style="width:30%;" id="left_noline">联系电话：</th>
				<td style="width:25%;">
					${dto.contacts_phone}
				</td>
				<th style = "width:20%;">电子邮箱：</th>
				<td id="right_noline" style="width:30%;">
					${dto.mailbox}
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">传真：</th>
				<td style="width:25%;">
					${dto.fax}
				</td>
				<th style = "width:20%;">从业人员人数：</th>
				<td id="right_noline" style="width:30%;">
					${dto.employee_num}
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">是否通过体系认证、验证（证书号）：</th>
				<td style="width:25%;">
                    <c:if test="${dto.certificate_numver == 1}">
                    	是
                    </c:if>
                    <c:if test="${dto.certificate_numver == 0}">
                    	否
                    </c:if>
				</td>
				<th style = "width:20%;">申请经营范围：</th>
				<td id="right_noline" style="width:30%;">
					${dto.apply_scope}
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">经营类别：</th>
				<td id="right_noline" colspan="3">
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
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">申请类型：</th>
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
				<th style="width:40%;" id="left_noline">受理局：</th>
				<td id="right_noline" colspan="3">
					${dto.admissible_org_name}	
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline"><span id="hygieneLicenseSpan" class="tpinfo"></span>原卫生许可证证号：</th>
				<td id="right_noline" colspan="3">
					${dto.hygiene_license_number}
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">受理结果</th>
				<td id="right_noline" colspan="3">
					<c:if test="${dto.approval_result == 1}">
						材料不全
					</c:if>
					<c:if test="${dto.approval_result == 2}">
						不符合受理条件
					</c:if>
					<c:if test="${dto.approval_result == 3}">
						符合受理条件
					</c:if>
				</td>
			</tr>
			<c:if test="${not empty dto.filePath2}">
				<tr>
					<th style = "width:30%;" id="left_noline">查看附件：</th>
					<td id="right_noline" colspan="2">
						<input type = "button" value="查看附件" onclick="downloadFile(1)"/>
					</td>
				</tr>
			</c:if>
			<tr>
				<th style="width:30%;" id="left_noline">上传附件(文件请打包上传)：</th>
				<td id="right_noline" colspan="3">
					<input type = "file" id = "fileUpload" name = "file"  />
				</td>
			</tr>
		</table>

		<div class = "table_spacing"></div>
		<div class = "action">
			<input  class="btn" value="提交" id = "smt" name = "smt"  type="button" >
			<input onclick="javascript:history.go(-1);" class="btn" value="返回" type="button">
		</div>
	</form>
	</div>
	</div>
</div>
</body>
</html>
 