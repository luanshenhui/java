<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证受理查询</title>
<style  type="text/css">
div.dpn-content div.form div.main table td {
    height: 30px;
    text-align: left;
    line-height: 22px;
    padding: 4px 5px 4px 5px;
}
</style>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">
/**
 * 初始化加载
 */
 document.body.onload=function onloads(){
   //setDiv(11);
 };
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
	 if(type == 1){
	 	$("#form1").attr("action","<%=request.getContextPath()%>/xk/downloadFile?path="+filePath);
	 }else{
	 	$("#form1").attr("action","<%=request.getContextPath()%>/xk/downloadFile?path="+filePath2);
	 }
	 $("#form1").submit();
 } 
/**
 * 卫生许可证申报表单提交
 */
jQuery (function () {	
	$("#smt").click (function () {
	    var filepath = $("#zgbgFileUpload").val();
	    var type = filepath.substring(filepath.lastIndexOf('.')+1,filepath.length);
		if(type != 'rar' && type != 'zip' && filepath != ''){
			alert("请选择上传rar或zip格式的文件!");
			return;
		}
		$("#licenseDecForm").submit();
		lockScreen();
	});
	
});

jQuery(document).ready(function(){
	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
	$(".user-info").css("color","white");
});

function zgsShow(no){
	window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+no);
}

function looktext(license_dno,id){
	window.open("<%=request.getContextPath()%>/cp/lookbook?license_dno="+license_dno+"&id="+id);
}

function dfbWinShow(license_dno,id,doc_type){
	window.open("<%=request.getContextPath()%>/cp/dfbWinShow?license_dno="+license_dno+"&id="+id+"&doc_type="+doc_type);
}
</script>
</head>
<body>
	<%@ include file="/common/headMenu_Xk.jsp"%>
    <div class="dpn-content">
		<div class="crumb">
			 当前位置：<a href="<%=request.getContextPath()%>/xk/findLicenseDecs">卫生许可证受理</a> 
			 &gt;<span class="tpinfo">详情  </span>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">卫生许可证详情</div> -->
		<div class="form">
			<div class="main">
			<form id="form1" action="" method="post" enctype="multipart/form-data"></form>
   <!--  <html:form action="/wsFileUpload.do" method="post" styleClass="min-height" styleId="licenseDecForm"  enctype="multipart/form-data"> -->
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
		<table class="table_base table_form">
		    <tr>
				<th style="width:25%;" id="left_noline">单位名称：</th>
				<td style="width:25%;">
					${dto.comp_name}
				</td>
				<th style = "width:20%;">单位地址：</th>
				<td id="right_noline" style="width:25%;">
					${dto.comp_addr}
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">经营地址：</th>
				<td style="width:25%;">
					${dto.management_addr}
				</td>
				<th style = "width:20%;">经营面积：</th>
				<td id="right_noline" style="width:25%;">
					${dto.management_area}
				</td>
			</tr>
		    <tr>
				<th style="width:25%;" id="left_noline">法定代表人（负责人或业主）：</th>
				<td style="width:25%;">
					${dto.legal_name}
				</td>
				<th style = "width:20%;">联系人：</th>
				<td id="right_noline" style="width:25%;">
					${dto.contacts_name}
				</td>
			</tr>
		    <tr>
				<th style="width:25%;" id="left_noline">联系电话：</th>
				<td style="width:25%;">
					${dto.contacts_phone}
				</td>
				<th style = "width:20%;">电子邮箱：</th>
				<td id="right_noline" style="width:25%;">
					${dto.mailbox}
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">传真：</th>
				<td style="width:25%;">
					${dto.fax}
				</td>
				<th style = "width:20%;">从业人员人数：</th>
				<td id="right_noline" style="width:25%;">
					${dto.employee_num}
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">是否通过体系认证、验证（证书号）：</th>
				<td style="width:25%;">
                    ${dto.certificate_numver}
				</td>
				<th style = "width:20%;">申请经营范围：</th>
				<td id="right_noline" style="width:25%;">
					${dto.apply_scope}
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">经营类别：</th>
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
				<th style="width:25%;" id="left_noline">申请类型：</th>
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
				<th style="width:25%;" id="left_noline"><span id="hygieneLicenseSpan" class="tpinfo"></span>原卫生许可证证号：</th>
				<td id="right_noline" colspan="3">
					${dto.hygiene_license_number}
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">受理结果</th>
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
			<c:if test="${not empty dto.filePath}">
				<tr>
					<th style = "width:25%;" id="left_noline">查看附件：</th>
					<td id="right_noline" colspan="3">
						<input type = "button" value="查看附件" onclick="downloadFile(1)"/>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty dto.iszg}">
			<tr>
				<th style="width:20%;" id="left_noline">整改通知书：</th>
				<td id="right_noline" colspan="3">
					<a href = "#" onclick="zgsShow('${dto.license_dno}')">查看</a>
				</td>
			</tr>
			</c:if>
			
			<tr>
			    <th style="width:20%;" id="left_noline">现场审查表：</th>
		    	<td id="right_noline" colspan="3">
		    	<c:if test="${not empty dto.review_result}">
			    	<c:forEach items="${dto.management_type}" var="items" varStatus="aa">
						<c:if test="${aa.index != 0}">
							<br/>
						</c:if>
						<c:if test="${items == 1}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_7')">食品生产现场审查表</a>
						</c:if>
						<c:if test="${items == 2}">
							<c:forEach items="${scbList}" var="cbitems" varStatus="cbitem">
								<c:if test="${cbitems == 'D_PT_H_L_8'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_8')">食品流通现场审查表(一)</a>
								</c:if>
								<c:if test="${cbitems == 'D_PT_H_L_9'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_9')">食品流通现场审查表(二)</a>
								</c:if>						
							</c:forEach>
						</c:if>
						<c:if test="${items == 3}">
							<c:forEach items="${scbList}" var="cbitems" varStatus="cbitem">
								<c:if test="${cbitems == 'D_PT_H_L_1'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_1')">餐饮服务现场审查表(一)</a>
								</c:if>
								<c:if test="${cbitems == 'D_PT_H_L_2'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_2')">餐饮服务现场审查表(二)</a>
								</c:if>
								<c:if test="${cbitems == 'D_PT_H_L_3'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_3')">餐饮服务现场审查表(三)</a>
								</c:if>
								<c:if test="${cbitems == 'D_PT_H_L_4'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_4')">餐饮服务现场审查表(四)</a>
								</c:if>
								<c:if test="${cbitems == 'D_PT_H_L_5'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_5')">餐饮服务现场审查表(五)</a>
								</c:if>
								<c:if test="${cbitems == 'D_PT_H_L_6'}">
									<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_6')">餐饮服务现场审查表(六)</a>
								</c:if>
							</c:forEach>	
						</c:if>
						<c:if test="${items == 4}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_10')">饮用水供应现场审查表</a>
						</c:if>
						<c:if test="${items == 5}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_11')">公共场所现场审查表</a>
						</c:if>
					</c:forEach>
					</c:if>
				</td>
	      </tr>
	      <tr>
			<th style="width:20%;" id="left_noline">电子笔录：</th>
			<td id="right_noline" colspan="3">
				<c:if test="${not empty dto.isdzbl}">
					<a href="#" onclick="looktext('${dto.license_dno}','${dto.id}')">电子笔录</a>
				</c:if>
			</td>
		  </tr>
		</table>

		<div class = "table_spacing"></div>
		<div class = "action" style="margin-top:20px">
			<input onclick="javascript:history.go(-1);" style="width:50px;text-align: center" value="返回" type="button"/>
		</div>		
	<!-- </html:form> -->
	</div>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
				$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政许可 /口岸卫生检疫</span><div>");
				$(".user-info").css("color","white");
		});
	</script> 
	</div>
</body>
</html>