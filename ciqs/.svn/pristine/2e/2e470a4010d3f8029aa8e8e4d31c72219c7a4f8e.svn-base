<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证受理查询</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
	
	jQuery(function() {
	    $("#toDel").click(function() {
			$("#dc_form").submit();
			$.unblockUI();
		});
	});
	
	/**
	 * 点击分页按钮进行处理
	 * obj 当前分页对象
	 */
	function pageUtil(obj){
	 	$("#dc_form").attr("action","<%=request.getContextPath()%>/dc/getLicenseDecs?page="+obj);
	 	$("#dc_form").submit();
	}
	
	/**
	 * 全选checkbox
	 * obj 全选checkbox当前对象
	 */
	function checkAll(obj) {
		var objID;
		if($(obj).attr("checked") == true) {
			objID=document.forms[0].elements;
			for (var i=0 ;i<objID.length;i++) {
				if(!objID[i].disabled) {
					objID[i].checked=true;
				}
			}
		}
		else {
			objID=document.forms[0].elements;
			for (var i=0 ;i<objID.length;i++) {
				if(!objID[i].disabled) {
					objID[i].checked=false;
				}
			}
		}
	}
	
	function licenseDecselete(license_dno){
	    $("#dc_form").attr("action","<%=request.getContextPath()%>/dc/licenseDecsDelete?license_dno="+license_dno);
	    $("#dc_form").submit();
	}
	
	 function byWinShow(obj){
	 	window.open("<%=request.getContextPath()%>/dc/printXzBysl.jsp?declare_date="+obj);
	 }
	 
	 function winShow(no,type,comp_name,ws_type){
		 $.ajax({
	    		url:"${ctx}/xk/getResult2?ProcMainId="+no+"&DocType=D_SDHZ",
	    		type:"get",
	    		dataType:"json",
	    		success:function(data){
	    			if(data.results == 1 || data.results == 2){
	    				window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
							 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&ws_type="+ws_type);
	    			}else{
	    				alert("未收到局端送达回证!");
	    			}
	    			<%-- if(data.status=="OK"){
						window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
			 			+no+"&doc_type="+type+"&comp_name="+comp_name+"&type=sdhz");
						window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
							 	+no+"&doc_type="+type+"&comp_name="+comp_name);
	    			}else{
	    				alert("未收到企业送达回证!");
	    			} --%>
	    		}
	    	});			
     }
	 
	 function winShow3(no,type,comp_name,ws_type){
		 $.ajax({
	    		url:"${ctx}/xk/getResult3?ProcMainId="+no+"&DocType="+type,
	    		type:"get",
	    		dataType:"json",
	    		success:function(data){
	    			if(data.status=="OK"){
	    				 location="<%=request.getContextPath()%>/xk/openPdf?license_dno="
	    						+no+"&doc_type="+type;
	    			}else{
	    				alert("暂无盖章!");
	    			}
	    	   }
	    });
		
	    	<%-- window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
				+no+"&doc_type="+type+"&comp_name="+comp_name+"&ws_type="+ws_type); --%>		
     }
	 
	 function winShow2(no,type,comp_name,ws_type){
		 $.ajax({
	    		url:"${ctx}/xk/getResult2?ProcMainId="+no+"&DocType=D_SDHZ2",
	    		type:"get",
	    		dataType:"json",
	    		success:function(data){
	    			if(data.results == 1 || data.results == 2){
	    				window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
							 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&ws_type="+ws_type);
	    			}else{
	    				alert("未收到局端送达回证!");
	    			}
	    		}
	     });		
     }
	 
	 jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
			
	 });
	
	function byWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date,no,type){
	 		<%-- location = "<%=request.getContextPath()%>/xk/byjdsShowOld?"
		 	+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date
		 	+"&urltype=dc"; --%>
		 	 $.ajax({
		    		url:"${ctx}/xk/getResult3?ProcMainId="+no+"&DocType="+type,
		    		type:"get",
		    		dataType:"json",
		    		success:function(data){
		    			if(data.status=="OK"){
		    				 location="<%=request.getContextPath()%>/xk/openPdf?license_dno="
		    						+no+"&doc_type="+type;
		    			}else{
		    				alert("暂无盖章!");
		    			}
		    	   }
		    });
	}
	
	function zyWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date,no,type){
	 		<%-- location = "<%=request.getContextPath()%>/xk/zyjdsShowOld?"
	 		+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date
		 	+"&urltype=dc"; --%>
		 	 $.ajax({
		    		url:"${ctx}/xk/getResult3?ProcMainId="+no+"&DocType="+type,
		    		type:"get",
		    		dataType:"json",
		    		success:function(data){
		    			if(data.status=="OK"){
		    				 location="<%=request.getContextPath()%>/xk/openPdf?license_dno="
		    						+no+"&doc_type="+type;
		    			}else{
		    				alert("暂无盖章!");
		    			}
		    	   }
		    });
	}
	var qdlicense_dno="";
	var qdstatus ="";
	function doStatus(license_dno,status){
		$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		qdlicense_dno =license_dno;
		qdstatus =status;
	}
	
	function qd(){
		location = "<%=request.getContextPath()%>/xk/insertEvent?license_dno="+qdlicense_dno+"&status="+qdstatus;
	}
	
	function zgsShow(no){
		$.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+no+"&DocType=D_PT_H_L_0",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status == "OK"){
    				window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+no);
    			}else{
    				alert("暂无整改书!");
    			}
    		}
        });			
	}
	
	function zgsdhz(no,type,comp_name,ws_type){
		 if(ws_type == "0"){
	    	ws_type =4;
	     }
		 if(ws_type == "1"){
	    	ws_type =5;
	     }
		 $.ajax({
	    		url:"${ctx}/xk/getResult?ProcMainId="+no+"&DocType=D_PT_H_L_13",
	    		type:"get",
	    		dataType:"json",
	    		success:function(data){
	    			if(data.status == "OK"){
	    				window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
	    					 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&type=sdhz3&ws_type="+ws_type);
	    			}else{
	    				alert("未收到送达回证!");
	    			}
	    	    }
	    });			 
	 	
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
	
	function showDel2(license_dno){
		$("#license_dno").val(license_dno);
		$.blockUI({ message: $('#showDel2'), css: { width: '275px' } });
	}
	
	function downloadFile(filePath){
	     if(filePath !=null){
	      filePath = filePath.substring(14,filePath.length);
	     }
		 location = "<%=request.getContextPath()%>/dc/downloadFile2?path="+filePath;
	} 
	
	function checksubmit(obj){
		var filepath = $("#zgs").val();
	    var type = filepath.substring(filepath.lastIndexOf('.')+1,filepath.length);
		if(type != 'rar' && type != 'zip' && filepath != ''){
			alert("请选择上传rar或zip格式的文件!");
			return;
		}
		if($("#zgs").val() ==""){
			alert("请选择一个文件!");
			return false;
		}
		return true;
	}
</script>
<style type="text/css">
.tips_action {
	height: 17px;
	line-height:17px;
	width: 980px;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 10px;
	margin-left: auto;
	text-align: left;
	border: 1px solid;
	background-color:#00eeaa;
	background-repeat: no-repeat;
	background-position: left;
	text-indent: 25px;
}
.tips_error {
	height: 17px;
	line-height:17px;
	width: 980px;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 10px;
	margin-left: auto;
	text-align: left;
	border: 1px solid;
	background-color:red;
	background-repeat: no-repeat;
	background-position: left;
	text-indent: 25px;
}
</style>
</head>
<body>
<%@ include file="/common/headMenu_XkDec.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="${cxt}/dc/getLicenseDecs">申报信息列表</a>
		</div>
		<% String flag = (String) request.getAttribute("flag"); %>
		<% if("OK".equals(flag)){%>
			<div id = "sucFlag"  class = "tips_action">操作成功</div>
		<% }%>	
		<% if("ERROR".equals(flag)){%>
			<div id = "failFlag" class = "tips_error">操作失败</div>
		<% }%>	
		<jsp:include page="/common/message.jsp" flush="true"/>

		<div class="search">
			<div class="main">
				<form action="<%=request.getContextPath()%>/dc/getLicenseDecs"  method="post" id="dc_form">
					<table class="table_search" id="aa">
					    <tr>
							<th style = "width:20%">受理结果：</th>
							<td style = "text-align:left;">
								<select name = "approval_result" id = "approval_result">
									<option value = "" >全部</option>
									<option value = "1" <c:if test="${approval_result == 1}" >selected="selected"</c:if>>材料不全</option>
									<option value = "2" <c:if test="${approval_result == 2}" >selected="selected"</c:if>>不符合受理条件</option>
									<option value = "3" <c:if test="${approval_result == 3}" >selected="selected"</c:if>>符合受理条件</option>
									<option value = "4" <c:if test="${approval_result == 4}" >selected="selected"</c:if>>不需要取得行政许可</option>
								</select>
							</td>
						</tr>		
						<tr>
							<td align="right" colspan="3" style="padding-top: 15px;margin-left: 320px;">
								<input id="checkone" name="searchF" type="submit" class="abutton" value="查 询" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data" style="text-align:left">
				<span style="float: left;">
					共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
					分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
					每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录
					<input type="hidden" id="msg" value="${msg}"/>
				</span>	
			</div>
			
			<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:10%">单位名称</td>
								<td style="width:5%">联系人</td>
								<td style="width:5%">联系电话</td>
								<td style="width:5%">通过体系认证</td>
								<td style="width:10%">经营类别</td> 
								<td style="width:6%">申请类型</td>
								<td style="width:6%">原卫生许可证号</td>
								<td style="width:10%">经营范围</td>
								<td style="width:15%">告知书</td>
								<td style="width:5%">受理审查结果</td>
								<td style="width:5%">决定与送达审批结果</td>
								<td style="width:10%" id = "right_noline">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="atmp">
							<input type="hidden" id="declare_date" value="${atmp.declare_date}"/>
							<input type="hidden" id="comp_name" value="${atmp.comp_name}"/>
	        				<input type="hidden" id="legal_name" value="${atmp.legal_name}"/>
	        				<input type="hidden" id="management_addr" value="${atmp.management_addr}"/>
	        				<input type="hidden" id="contacts_name" value="${atmp.contacts_name}"/>
	        				<input type="hidden" id="contacts_phone" value="${atmp.contacts_phone}"/>
								<tr>
									<td>
										${atmp.comp_name}
									</td>
									<td>
										${atmp.contacts_name}
									</td>
									<td>
										${atmp.contacts_phone}
									</td>
									<td>
										<c:if test="${atmp.certificate_numver == 0}">
											否
										</c:if>
										<c:if test="${atmp.certificate_numver == 1}">
											是
										</c:if>
									</td>
									<td>
									<c:forEach items="${atmp.management_type}" var="items" varStatus="aa">
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
										<%-- <c:if test="${atmp.management_type == 1}">
											食品生产
										</c:if>
										<c:if test="${atmp.management_type == 2}">
											食品流通
										</c:if>
										<c:if test="${atmp.management_type == 3}">
											餐饮服务
										</c:if>
										<c:if test="${atmp.management_type == 4}">
											饮用水供应
										</c:if>
										<c:if test="${atmp.management_type == 5}">
											公共场所
										</c:if> --%>
									</td>
									<td>
										<c:if test="${atmp.apply_type == 1}">
											初次
										</c:if>
										<c:if test="${atmp.apply_type == 2}">
											变更
										</c:if>
										<c:if test="${atmp.apply_type == 3}">
											延续
										</c:if>
										<c:if test="${atmp.apply_type == 4}">
											临时经营
										</c:if>
										<c:if test="${atmp.apply_type == 5}">
											公共场所
										</c:if>
									</td>
									<td>
										${atmp.hygiene_license_number}
									</td>
									<td>
										${atmp.apply_scope}
									</td>
									<td>
										<%-- <c:if test="${atmp.approval_result == 1}">
											材料不全
										</c:if>
										<c:if test="${atmp.approval_result == 2}">
											不符合受理条件
										</c:if>
										<c:if test="${atmp.approval_result == 3}">
											符合受理条件
										</c:if> --%>
										
										
										<c:if test="${atmp.approval_result == 1}">
											<a href = "#" onclick="winShow3('${atmp.license_dno}','D_SQ_BZ')">申请材料补正告知书</a><br/>
											<a href = "#" onclick="winShow('${atmp.license_dno}','D_SDHZ','${atmp.comp_name}','1')">送达回证</a>
										</c:if>
										<c:if test="${atmp.approval_result == 2 || atmp.approval_result == 4}">
											<a href = "#" onclick="winShow3('${atmp.license_dno}','D_BY_GZ')">不予受理决定书</a><br/>
											<a href = "#" onclick="winShow('${atmp.license_dno}','D_SDHZ','${atmp.comp_name}','2')">送达回证</a>
										</c:if>
										<c:if test="${not empty atmp.exam_result}">
											<c:if test="${atmp.approval_result == 3 && atmp.exam_result == 1}">
												<a href = "#" onclick="winShow3('${atmp.license_dno}','D_SL_GZ')">准予受理决定书</a><br/>
												<a href = "#" onclick="winShow('${atmp.license_dno}','D_SDHZ','${atmp.comp_name}','3')">送达回证</a>
												<br/>
											</c:if>	
										</c:if>
										<c:if test="${not empty atmp.iszg}">
											<a href = "#" onclick="zgsShow('${atmp.license_dno}')">整改书</a><br/>
						            		<a href = "#"  onclick="zgsdhz('${atmp.license_dno}','D_PT_H_L_13','${row.comp_name}','${row.review_result}')">送达回证</a><br/>
						            		<input type="button" onclick="showDel2('${atmp.license_dno}')"  value="整改报告" />
											<input type="button" onclick="downloadFile('${atmp.filePath}')"  value="查看" />
											<br/>
										</c:if>
										<c:if test="${atmp.jd_sp == 1 }">
											<a href = "#" id="a_zy_${atmp.id}" onclick="zyWinShow('${atmp.id}','${atmp.comp_name}',
										'${atmp.legal_name}','${atmp.management_addr}',
										'${atmp.declare_date}','${atmp.approval_date}','${atmp.license_dno}','D_SQ_SL')">准予许可决定书</a><br/>
											<a href = "#"  onclick="winShow2('${atmp.license_dno}','D_SDHZ2','${atmp.comp_name}','4')">送达回证</a>
										</c:if>	
										<c:if test="${atmp.jd_result == 2 && atmp.jd_sp != 1 }">
											<a href = "#" id="a_by_${atmp.id}" onclick="byWinShow('${atmp.id}','${atmp.comp_name}','${atmp.legal_name}','${atmp.management_addr}','${atmp.declare_date}','${atmp.approval_date}','${atmp.license_dno}','D_BY_GZ')">不予许可决定书</a><br/>
											<a href = "#"  onclick="winShow2('${atmp.license_dno}','D_SDHZ2','${atmp.comp_name}','5')">送达回证</a>
										</c:if>	
										
									</td> 
									<td>
									   <c:if test="${atmp.approval_result == 1}">
											材料不全
									   </c:if>
									   <c:if test="${atmp.approval_result == 2}">
											不予受理
									   </c:if>
									   <c:if test="${atmp.approval_result == 4}">
											不需要取得行政许可
									   </c:if>
							           <c:if test="${atmp.exam_result == 1}">
							           		<c:if test="${atmp.approval_result == 3}">
												准予受理
									   		</c:if>
							           </c:if>
							           <c:if test="${atmp.exam_result == 0}">
							           		受理审核未通过
							           </c:if>
									</td>
									<td>
							           <c:if test="${atmp.jd_sp == 1}">
							           		已通过
							           </c:if>
									</td>
									<td>				
										<a href = "javascript:location='<%=request.getContextPath()%>/dc/getLicenseDec.do?license_dno=${atmp.license_dno}'" >详情</a>									
										<c:if test="${atmp.approval_result != 1 && atmp.approval_result != 2 && atmp.approval_result != 3 && atmp.approval_result != 4}">
											|&nbsp;<a href = "javascript:location='<%=request.getContextPath()%>/dc/toLicenseDecUpdateForm.do?license_dno=${atmp.license_dno}'" >修改</a>
											<%-- <a href = "#" onclick="licenseDecselete('${atmp.license_dno}')">删除</a> --%>
										</c:if>
										<c:if test="${atmp.approval_result == 1 || atmp.approval_result == 2 || atmp.approval_result == 3 || atmp.approval_result == 4}">
											|&nbsp;修改
											<!-- |&nbsp;删除 -->
										</c:if>
									</td> 
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>单位名称</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>通过体系认证</td>
								<td>经营类别</td> 
								<td>申请类型</td>
								<td>原卫生许可证号</td>
								<td>经营范围</td>
								<td>告知书</td>
								<td>受理审查结果</td>
								<td>决定与送达审批结果</td>
								<td id = "right_noline">操作</td>
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
			</div>
		</div>
	</div>
	
	<div style="width: 400px;margin-left:5px; display: none; text-align:center;" id="showDel">
		<table style="width: 200px; height:100px" >
			<tr>
				<th  style="text-align:left;font-size:16px">
					确定通过提交吗?
				</th>
			</tr>
			<tr>
				<td colspan="2" style="text-align:left">
					<input id="toApproval" type="button" class="btn" style="width:35px;height:30px" value="确定" onclick="qd()"/>
					<input onclick="$.unblockUI();" type="button" style="width:35px;height:30px" class="btn" value="取消" />
				</td>
			</tr>
		</table>
    </div>
    
    <div style="width: 400px;margin-left:5px; display: none; text-align:center;" id="showDel2">
		<table style="width: 200px; height:100px" >
			<tr>
				<td colspan="2" style="text-align:left">
					<form action="${ctx}/dc/gzsUpload" method="post"  enctype="multipart/form-data" onsubmit="return checksubmit(this)">
						<input  type="file" id="zgs" name="file" style="width:160px;margin-bottom:20px;"/>
						<input type="hidden" id="license_dno" name="license_dno" /><br/>
						<p><input type="submit" value="上传" style="width:35px;height:30px"/>
						<input onclick="$.unblockUI();" type="button" style="width:35px;height:30px" class="btn" value="关闭" /></p>
					</form>
					
				</td>
			</tr>
		</table>
    </div>
</body>
</html>
