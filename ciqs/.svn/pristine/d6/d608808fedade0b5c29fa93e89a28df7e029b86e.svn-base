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

 	if(obj.value == 2 || obj.value == 3){
 		hSpan.innerHTML = "*";
 	}else{
 		hSpan.innerHTML = "";
 	}
 }
 
/**
 * 卫生许可证申报表单提交
 */
$(function () {

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
			fax : {
				required : true
			},
			mailbox : {
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
			port_org_code: {
				required : true
			}
		},
		messages : {
			
		}
	});
	
});

function showsm(){
    var types = $("input[name=management_type]:checked");
    var div = document.getElementById("sm");
    div.innerHTML ="";
    $.each(types,function(i,n){
        var type = n.value;
	    if(type == 1){
		     div.innerHTML +="（一）从事国境口岸食品生产的，申请卫生许可时，应当提供以下材料： <br/>"
			 +"1. 卫生许可证申请书； <br/>"
			 +"2. 营业执照复印件； <br/>"
			 +"3. 法定代表人（负责人或者经营者）资格及身份证明（委托他人代为办理的，应当同时提交委托书及受委托人身份证明）； <br/>"
			 +"4. 本单位实际相适应的保证食品安全的卫生管理制度，包括环境清洁卫生管理制度、食品安全自查管理制度、食品进货查验记录制度、从业人员健康管理制度等有关资料； <br/>"
			 +"5. 场所及其周围环境平面图、生产加工各功能区间布局平面图、生产工艺流程图、设备布局图； <br/>"
			 +"6. 食品生产设备设施清单； <br/>"
			 +"7. 食品生产的执行标准； <br/>"
			 +"8. 具备资质的检测机构出具的生产用水卫生检验报告; <br/>"
			 +"9. 生产加工过程食品安全管理制度、出厂检验记录制度、不合格产品管理制度； <br/>"
			 +"10. 航空配餐企业还应当提供符合冷链运输要求的专用食品运输车辆、冷冻冷藏设施的证明材料。<br/><br/>";
		   }else if(type == 2){
		     div.innerHTML += "（二）从事国境口岸食品销售的，申请卫生许可时，应当提供以下材料：<br/> "
			 +"1. 卫生许可证申请书； <br/>"
			 +"2. 营业执照复印件； <br/>"
			 +"3. 法定代表人（负责人或者经营者）资格及身份证明（委托他人代为办理的，应当同时提交委托书及受委托人身份证明）； <br/>"
			 +"4. 本单位实际相适应的保证食品安全的卫生管理制度，包括环境清洁卫生管理制度、食品安全自查管理制度、食品进货查验记录制度、从业人员健康管理制度等有关资料； <br/>"
			 +"5. 与食品销售相适应的经营设施空间布局平面图、经营设施设备清单； <br/>"
			 +"6. 入/出境交通工具食品供应企业还应当提供符合冷链运输要求的专用食品运输车辆、冷冻冷藏设施的证明材料； <br/>"
			 +"7. 利用自动售货设备进行食品销售的，申请人还应当提交自动售货设备的产品合格证明、具体放置地点，经营者名称、住所、联系方式、食品经营许可证的公示方法等材料。<br/><br/> ";
		   }else if(type == 3){
		   	 div.innerHTML +="（三）从事国境口岸餐饮服务的，申请卫生许可时，应当提供以下材料： <br/>"
		   	 +"1. 卫生许可证申请书； <br/>"
		   	 +"2. 营业执照复印件； <br/>"
		   	 +"3. 法定代表人（负责人或者经营者）资格及身份证明（委托他人代为办理的，应当同时提交委托书及受委托人身份证明）； <br/>"
		   	 +"4. 本单位实际相适应的保证食品安全的卫生管理制度，包括环境清洁卫生管理制度、食品安全自查管理制度、食品进货查验记录制度、从业人员健康管理制度等有关资料； <br/>"
			 +"5. 经营场所和设备布局、加工流程、卫生设施等示意图； <br/>"
			 +"6. 具备资质的检测机构出具的用水卫生检验报告； <br/>"
			 +"7. 设施设备卫生管理制度、清洗消毒制度、加工操作规程、食品添加剂的管理制度； <br/>"
			 +"8. 有送餐服务的，应当提供符合保温或者冷链运输要求的专用食品运输设施的证明材料; <br/>"
			 +"9. 集中用餐的非盈利性食堂可免予提供营业执照，但应当提供场所合法使用证明。 <br/><br/>";
		   }else if(type == 4){
		   	 div.innerHTML +="（四）从事国境口岸饮用水供应的，申请卫生许可时，应当提供以下材料： <br/>"
			 +"1. 卫生许可证申请书； <br/>"
			 +"2. 营业执照复印件； <br/>"
			 +"3. 法定代表人（负责人或者经营者）资格及身份证明（委托他人代为办理的，应当同时提交委托书及受委托人身份证明）； <br/>"
			 +"4. 本单位卫生管理制度，包括从业人员卫生培训，专（兼）职卫生管理人员，供水设备设施维护，卫生管理档案等有关内容； <br/>"
			 +"5. 涉及饮用水卫生安全产品的卫生许可批件； <br/>"
			 +"6. 设计图纸及相关文字说明，如平面布局图、设备布局图、管网平面布局图、管网系统图等； <br/>"
			 +"7. 具备资质的检测机构出具的一年内水质检测合格报告； <br/>"
			 +"8. 自备水源的应当提供制水工艺流程文件。<br/><br/>";
		   }else{
		   	 div.innerHTML += "（五）从事国境口岸公共场所经营的，申请卫生许可时，应当提供以下材料：  <br/>"
			 +"1. 卫生许可证申请书；  <br/>"
			 +"2. 营业执照复印件；  <br/>"
			 +"3. 法定代表人（负责人或者经营者）资格及身份证明（委托他人代为办理的，应当同时提交委托书及受委托人身份证明）；  <br/>"
			 +"4. 本单位卫生管理制度，包括从业人员卫生培训，专（兼）职卫生管理人员，卫生设施设备维护，公共场所危害健康事故应急，卫生管理档案等内容；  <br/>"
			 +"5. 营业场所平面图和卫生设施平面布局图；  <br/>"
			 +"6. 公共场所卫生检测或者评价报告；  <br/>"
			 +"7. 使用集中空调通风系统的，应当提供集中空调通风系统卫生检测或者评价报告。 <br/><br/>";
		   }
    
    });

    
	
}

jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
		});
</script>
</head>
<body>
<%@ include file="/common/headMenu_XkDec.jsp"%>
<div class="dpn-content">
    <div class="crumb">
	             当前位置：口岸卫生许可证核发 &gt;<span class="need">新增许可证申报  </span>
    </div>
    <jsp:include page="/common/message.jsp" flush="true"/>
    <div class="form">
		<div class="main">
    	<form action="<%=request.getContextPath()%>/dc/addLicenseDec" method="post" id="licenseDecForm"  enctype="multipart/form-data">
		<%-- <form styleId="LicenseDecForm" action="/addLicenseDec.do?doType=addLicenseDec" enctype="multipart/form-data" method="post"> --%>

		<table id="form_table">
		    <tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>单位名称：</th>
				<td style="width:30%;">
					<input type = "text" id = "comp_name" name = "comp_name" maxlength="50"/>
				</td>
				<th style = "width:30%;"><span class="need">*</span>单位地址：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "comp_addr" name = "comp_addr" maxlength="100"/>
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>经营地址：</th>
				<td style="width:30%;">
					<input type = "text" id = "management_addr" name = "management_addr" maxlength="100"/>
				</td>
				<th style = "width:30%;"><span class="need">*</span>经营面积：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "management_area" name = "management_area" maxlength="50"/>
				</td>
			</tr>
		    <tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>法定代表人（负责人或业主）：</th>
				<td style="width:30%;">
					<input type = "text" id = "legal_name" name = "legal_name" maxlength="50"/>
				</td>
				<th style = "width:30%;"><span class="need">*</span>联系人：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "contacts_name" name = "contacts_name" maxlength="50"/>
				</td>
			</tr>
		    <tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>联系电话：</th>
				<td style="width:30%;">
					<input type = "text" id = "contacts_phone" name = "contacts_phone" maxlength="50"/>
				</td>
				<th style = "width:30%;"><span class="need">*</span>电子邮箱：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "mailbox" name = "mailbox" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>传真：</th>
				<td style="width:30%;">
					<input type = "text" id = "fax" name = "fax" maxlength="50"/>
				</td>
				<th style = "width:30%;"><span class="need">*</span>从业人员人数：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "employee_num" name = "employee_num" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>是否通过体系认证、验证（证书号）：</th>
				<td style="width:30%;">
					<select style="width:184px" id="certificate_numver" name="certificate_numver" onchange="terminalChange(this);">
                        <option value="" ${declForm.TERMINAL_CODE==''?'selected':''}>--请选择--</option>
                        <option value="1" ${declForm.TERMINAL_CODE=='1'?'selected':''}>是</option>
                        <option value="0" ${declForm.TERMINAL_CODE=='0'?'selected':''}>否</option>
                    </select>
				</td>
				<th style = "width:30%;"><span class="need">*</span>申请经营范围：</th>
				<td id="right_noline" style="width:40%;">
					<input type = "text" id = "apply_scope" name = "apply_scope" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>经营类别：</th>
				<td id="right_noline" colspan="3">
					<input type="checkbox" name="management_type" id="management_type1" value="1" onchange="showsm()"/> 食品生产
					<input type="checkbox" name="management_type" id="management_type2" value="2" onchange="showsm()"/> 食品流通
					<input type="checkbox" name="management_type" id="management_type3" value="3" onchange="showsm()"/> 餐饮服务
					<input type="checkbox" name="management_type" id="management_type4" value="4" onchange="showsm()"/> 饮用水供应
					<input type="checkbox" name="management_type" id="management_type5" value="5" onchange="showsm()"/> 公共场所
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>申请类型：</th>
				<td id="right_noline" colspan="3">
					<input type="radio" name="apply_type" id="apply_type1" value="1" onclick="applyOnclick(this)"/> 初次
					<input type="radio" name="apply_type" id="apply_type2" value="2" onclick="applyOnclick(this)"/> 变更
					<input type="radio" name="apply_type" id="apply_type3" value="3" onclick="applyOnclick(this)"/> 延续
					<input type="radio" name="apply_type" id="apply_type4" value="4" onclick="applyOnclick(this)"/> 临时经营
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span class="need">*</span>受理局：</th>
				<td id="right_noline" colspan="3">
					<select id="port_org_code" class="search-input input-175px" name="port_org_code">
						<option value=""></option>
						<c:if test="${not empty allorgList }">
							<c:forEach items="${allorgList}" var="row">
								<option value="${row.org_code}">${row.name}</option>
							</c:forEach>
						</c:if>
					</select>
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline"><span id="hygieneLicenseSpan" class="need"></span>原卫生许可证证号：</th>
				<td id="right_noline" colspan="3">
					<input type = "text" id = "hygiene_license_number" style="width:175px;" name = "hygiene_license_number" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th style = "width:40%;" id="left_noline">申请人承诺：</th>
				<td id="right_noline" colspan="3">
					申请人承诺：<br/>
本申请书及其所附资料中的有关内容均真实、合法，复印件与原件一致。如有不实之处，或违反相关法律规定的要求，本申请人愿负相应法律责任，并承担由此造成的一切后果。

				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline">上传附件(文件请打包上传)：</th>
				<td id="right_noline" colspan="3">
					<input type = "file" id = "fileUpload" name = "file"  />   
				</td>
			</tr>
			<tr>
				<th style="width:40%;" id="left_noline">上传说明：</th>
				<td id="sm" colspan="3">
					（一）从事国境口岸食品生产的，申请卫生许可时，应当提供以下材料： <br/>
					1. 卫生许可证申请书； <br/>
					2. 营业执照复印件； <br/>
					3. 法定代表人（负责人或者经营者）资格及身份证明（委托他人代为办理的，应当同时提交委托书及受委托人身份证明）； <br/>
					4. 本单位实际相适应的保证食品安全的卫生管理制度，包括环境清洁卫生管理制度、食品安全自查管理制度、食品进货查验记录制度、从业人员健康管理制度等有关资料； <br/>
					5. 场所及其周围环境平面图、生产加工各功能区间布局平面图、生产工艺流程图、设备布局图； <br/>
					6. 食品生产设备设施清单； <br/>
					7. 食品生产的执行标准； <br/>
					8. 具备资质的检测机构出具的生产用水卫生检验报告; <br/>
					9. 生产加工过程食品安全管理制度、出厂检验记录制度、不合格产品管理制度； <br/>
					10. 航空配餐企业还应当提供符合冷链运输要求的专用食品运输车辆、冷冻冷藏设施的证明材料。<br/>
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
 