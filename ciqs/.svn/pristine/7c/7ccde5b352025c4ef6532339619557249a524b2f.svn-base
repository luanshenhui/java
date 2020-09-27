<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>口岸卫生许可证核发</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">

/**
 * 打开上传说明新窗口
 * url 新窗口请求地址
 * name 窗口的名称
 * iWidth 窗口宽度
 * iHeigth 窗口高度
 */
 function openWin(url,name,iWidth,iHeigth){
    var type = $("input[name='management_type']:checked").val();
    if(typeof type == 'undefined' || type == ''){
      alert("请选择一个经营类别!");
      return;
    }
    url = url + "?type="+type;
    // 获得窗口的垂直位置
    var itop = (window.screen.availHeight - 30 - iHeigth) / 2;
    // 获得窗口的水平位置
    var ileft = (window.screen.availWidth - 10 - iWidth) / 2;
    // 打开window.open新窗口
    window.open(url,name,'height='+iHeigth+'innerHeight='+iHeigth+
    ',width='+iWidth+',innerWidth='+iWidth+',top='+itop+',left='+ileft+
    ',toolbar=no,menubar=no,resizeable=no,location=no,status=no');
 }
 
/**
 * 动态改变是否必填在span标签里添加*
 * obj 当前标签对象
 */
 function applyOnclick(obj){
    var hSpan = document.getElementById("hygieneLicenseSpan");

 	if(obj.value == 3){
 		hSpan.innerHTML = "*";
 	}else{
 		hSpan.innerHTML = "";
 	}
 }
 
/**
 * 卫生许可证申报表单提交
 */
jQuery (function () {
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
	
	$("#smt").click (function () {
		var apply_type = $("input[name='apply_type']:checked").val();
		if((apply_type == 2 || apply_type == 3) && $("#hygiene_license_number").val() ==""){
			alert("原卫生许可证证号不能为空!");
			return;
		}
		var filepath = $("#fileUpload").val();
	    var type = filepath.substring(filepath.lastIndexOf('.')+1,filepath.length);
		if(type != 'rar' && type != 'zip' && filepath != ''){
			alert("请选择上传rar或zip格式的文件!");
			return;
		}
		if ($("#licenseDecForm").valid()) {
			$("#licenseDecForm").submit();
			lockScreen();
		}
	});
	
	$("#licenseDecForm").validate({
		rules : {
			comp_name : {
				required : true
			},
			comp_addr : {
				required : true
			},
			management_addr : {
				required : true
			},
			management_area : {
				required : true
			},
			legal_name : {
				required : true
			},
			contacts_name : {
				required : true
			},
			contacts_phone : {
				required : true
			},
			employee_num : {
				required : true
			},
			certificate_numver : {
				required : true
			},
			management_type : {
				required : true
			},
			apply_scope : {
				required : true
			},
			apply_type : {
				required : true
			},
			hygiene_license_number:{
				required : true
			}
		},
		messages : {
			
		}
	});
	
});

 function byWinShow(){
 	location = "<%=request.getContextPath()%>/dc/printXzBysl.jsp?declare_date="+$("#declare_date").val();
 }
 
 function slWinShow(){
 	location = "<%=request.getContextPath()%>/dc/printXzSljds.jsp?declare_date="+$("#declare_date").val()
 	+"&comp_name="+$("#comp_name").val()
 	+"&legal_name="+$("#legal_name").val()
 	+"&management_addr="+$("#management_addr").val()
 	+"&contacts_name="+$("#contacts_name").val()
 	+"&contacts_phone="+$("#contacts_phone").val();
 }
 
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
	 	location = "<%=request.getContextPath()%>/dc/downloadFile?path="+filePath;
	 }else{
	 	location = "<%=request.getContextPath()%>/dc/downloadFile?path="+filePath2;
	 }
 } 
 
 jQuery(document).ready(function(){
	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
	$(".user-info").css("color","white");
		
	// 申请类型默认选中
	if($("#type").val()=="1"){
		$("#apply_type2").attr("checked",true);
	}
	if($("#type").val()=="2"){
		$("#apply_type3").attr("checked",true);
	}
});
</script>

</head>
<body>
<%@ include file="/common/headMenu_XkDec.jsp"%>
<div class="dpn-content">
    <div class="crumb">
	             当前位置：口岸卫生许可证核发 &gt;<span class="need">许可证申报 </span>
    </div>
     <div class="form">
		<div class="main">
		
    <form action="<%=request.getContextPath()%>/dc/addLicenseDec" method="post" id="licenseDecForm"  enctype="multipart/form-data">
	<%-- <form styleId="LicenseDecForm" action="/addLicenseDec.do?doType=addLicenseDec" enctype="multipart/form-data" method="post"> --%>
        <input type = "hidden" id = "license_dno" name="license_dno" value="${dto.license_dno}" />
        <input type="hidden" id="declare_date" value="${dto.declare_date}"/>
        <input type="hidden" id="filePath" value="${dto.filePath}"/>
        <input type="hidden" id="filePath2" value="${dto.filePath2}"/>
        <input type="hidden" id="management_type_hide" value="${dto.management_type}"/>
        <input type = "hidden" id = "type" value="${type}" />
		<table id="form_table">
		    <tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>单位名称：</th>
				<td style="width:25%;">
					<input type = "text" id = "comp_name" name = "comp_name" 
					value="${dto.comp_name}" maxlength="50"/>
				</td>
				<th style = "width:20%;"><span class="need">*</span>单位地址：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "comp_addr" name = "comp_addr" value="${dto.comp_addr}" 
					maxlength="100"/>
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>经营地址：</th>
				<td style="width:25%;">
					<input type = "text" id = "management_addr" name = "management_addr"  value="${dto.management_addr}" maxlength="100"/>
				</td>
				<th style = "width:20%;"><span class="need">*</span>经营面积：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "management_area" name = "management_area" value="${dto.management_area}" maxlength="50"/>
				</td>
			</tr>
		    <tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>法定代表人（负责人或业主）：</th>
				<td style="width:25%;">
					<input type = "text" id = "legal_name" name = "legal_name" value="${dto.legal_name}" maxlength="50"/>
				</td>
				<th style = "width:20%;"><span class="need">*</span>联系人：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "contacts_name" name = "contacts_name" value="${dto.contacts_name}" maxlength="50"/>
				</td>
			</tr>
		    <tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>联系电话：</th>
				<td style="width:25%;">
					<input type = "text" id = "contacts_phone" name = "contacts_phone" value="${dto.contacts_phone}" maxlength="50"/>
				</td>
				<th style = "width:20%;">电子邮箱：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "mailbox" name = "mailbox" value="${dto.mailbox}" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline">传真：</th>
				<td style="width:25%;">
					<input type = "text" id = "fax" name = "fax" value="${dto.fax}" maxlength="50"/>
				</td>
				<th style = "width:20%;"><span class="need">*</span>从业人员人数：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "employee_num" value="${dto.employee_num}" name = "employee_num" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>是否通过体系认证、验证（证书号）：</th>
				<td style="width:25%;">
					<select style="width:184px" id="certificate_numver" name="certificate_numver" onchange="terminalChange(this);">
                        <option value="" >--请选择--</option>
                        <c:if test="${dto.certificate_numver == 1}">
							<option value="1" selected="selected">是</option>
                        	<option value="0">否</option>
                        </c:if>
			            <c:if test="${dto.certificate_numver == 0}">
							<option value="1">是</option>
                        	<option value="0" selected="selected">否</option>
			            </c:if>
                    </select>
				</td>
				<th style = "width:20%;"><span class="need">*</span>申请经营范围：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "apply_scope" name = "apply_scope" value="${dto.apply_scope}" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>经营类别：</th>
				<td id="right_noline" colspan="3">
						<input type="checkbox" name="management_type" id="management_type1" value="1" /> 食品生产
						<input type="checkbox" name="management_type" id="management_type2" value="2" /> 食品流通
						<input type="checkbox" name="management_type" id="management_type3" value="3" /> 餐饮服务
						<input type="checkbox" name="management_type" id="management_type4" value="4" /> 饮用水供应
						<input type="checkbox" name="management_type" id="management_type5" value="5" /> 公共场所
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>申请类型：</th>
				<td id="right_noline" colspan="3">
					
					<input type="radio" name="apply_type" id="apply_type1" value="1" onclick="applyOnclick(this)" <c:if test ="${dto.apply_type == 1}">checked="checked"</c:if>/> 初次
					<input type="radio" name="apply_type" id="apply_type2" value="2" onclick="applyOnclick(this)" <c:if test ="${dto.apply_type == 2}">checked="checked"</c:if>/> 变更
					<input type="radio" name="apply_type" id="apply_type3" value="3" onclick="applyOnclick(this)" <c:if test ="${dto.apply_type == 3}">checked="checked"</c:if>/> 延续
					<input type="radio" name="apply_type" id="apply_type4" value="4" onclick="applyOnclick(this)" <c:if test ="${dto.apply_type == 4}">checked="checked"</c:if>/> 临时经营
			       
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>受理局：</th>
				<td id="right_noline" colspan="3">
					<select id="port_org_code" class="search-input input-175px" name="port_org_code">
						<option value=""></option>
						<c:if test="${not empty allorgList }">
							<c:forEach items="${allorgList}" var="row">
								<option value="${row.org_code}" <c:if test="${row.org_code == dto.admissible_org_code}">selected="selected"</c:if>>${row.name}</option>
							</c:forEach>
						</c:if>
					</select>
				</td>
			</tr>
			<tr>
				<th style="width:30%;" id="left_noline"><span class="need">*</span>原卫生许可证证号：</th>
				<td id="right_noline" colspan="3">
					<input type = "text" id = "hygiene_license_number" name = "hygiene_license_number" value="${dto.hygiene_license_number}" maxlength="50"/>
				</td>
			</tr>
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
 