<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>现场评审查询</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
	    jQuery(function() {
		    $("#toApproval").click(function() {
			    try {
					$("#xk_form").submit();
					alert("提交成功!");
				} catch (e) {
					alert("提交失败!");
				}
			});
		});
		function pageUtil(page) {
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/zzList?page="+page);
			$("#xk_form").submit();
		}
		
		function doApproval(id,license_dno){
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/doReview?id="+id+"&reviewResult="+$("#review_result"+id).val()
			+"&license_dno="+license_dno);
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
		
		function byWinShow(id,obj,license_dno,comp_name){
	 		window.open("${ctx}/xk/toByslsOld2?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
		}
		
		function zyWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date){
	 		location = "<%=request.getContextPath()%>/xk/zyjdsShowOld?"
	 		+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date;
		}
	
	    function downloadFile(license_dno,file_type){
		    $.ajax({	
				url : "<%=request.getContextPath()%>/xk/validFile?license_dno=" + license_dno+"&file_type="+file_type,
				method : "post",
				success: function(result){
				    if(result.path != null && result.path !="null"){
				    	location = "<%=request.getContextPath()%>/xk/downloadFile?path="+result.path;
				    }else{
				    	alert("没有上传该文件!");
				    }
					
				}
			});
	    }
	    
	    function uploadFile(license_dno){
	    	$("#uploadForm").attr("action","<%=request.getContextPath()%>/xk/uploadFile?license_dno="+license_dno);
	    	$("#uploadForm").submit();
	    	alert("上传成功!");
	    }
	    
	    function wenshudownloadFile(path){
	
     	    if(path !=null){
      			path = path.substring(14,path.length);
				location = "<%=request.getContextPath()%>/xk/downloadFile?path="+path;
			}
	    }
	    
	    function showWs(selectid,rowid){
	    	var value = $("#"+selectid).val();
	    	if(value == 2){
	    		$("#a_zy_"+rowid).hide();
	    		$("#a_by_"+rowid).show();
	    	}else{
	    		$("#a_by_"+rowid).hide();
	    		$("#a_zy_"+rowid).show();
	    	}	    	
	    }
	    
	    jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
		});
		
		<%-- function winShow(no,type,comp_name){
		 	window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
		 	+no+"&doc_type="+type+"&comp_name="+comp_name);
        } --%>
        
        function sqsWinShow(id){
			window.open("<%=request.getContextPath()%>/cp/sqsWinShow?id="+id);
		}
		
		function zgsShow(no){
			window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+no);
		}
		
		var qdlicense_dno="";
		var qdstatus ="";
		function doStatus(license_dno,id){
		 	var result = $("#zz_"+id).val();
			qdstatus = "8";
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/doSubmit?status="+qdstatus+"&license_dno="+license_dno+"&result="+result);
	   	    $.blockUI({ message: $('#showDel'), css: { width: '275px' } });
			//qdlicense_dno =license_dno;
			
	    }
	    
	    function gzs(id){							
			var aa = $("#zz_"+id).val();
			if(aa ==1 || aa ==2 || aa==3 || aa ==5 ){
				$("#a_bysl_"+id).show();
				$("#a_sdhz_"+id).show();
			}else{
				$("#a_bysl_"+id).hide();
				$("#a_sdhz_"+id).hide();
			}
		}
		
	    function winShow(no,type,comp_name,num,sq_status){
   				window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
					 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&ws_type=2&sq_status="+sq_status);
		 	
	    }
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="${cxt}<%=request.getContextPath()%>/xk/zzList">终止审批</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>	
<!-- 		<div class="title">现场评审查询</div> -->
		<div class="search">
			<div class="main">
				<form action="<%=request.getContextPath()%>/xk/zzList"  method="post" id="xk_form">
					<table class="table_search" id="aa">
						<tr>
							<td style="width: 250px;" align="left">企业名称:</td>
							<td style="width: 250px;" align="left">开始时间:</td>
							<td style="width: 250px;" align="left">结束时间:</td>
						</tr>
						<tr>
							<td align="left">
								<input type="text" name="comp_name" id="comp_name" size="14" value="${comp_name}"/>
							</td>
							<td align="left">
								<input type="text" class="datepick" size="14" name="startDeclare_date" id="startDeclare_date" value="${startDeclare_date}"/>
							</td>
							<td align="left">
								<input type="text" class="datepick" size="14" name="endDeclare_date" id="endDeclare_date" value="${endDeclare_date}"/>
							</td>
						</tr>
						<tr>
							<td style="padding-top:8px;width: 250px;" align="left">受理局:</td>
							<td style="padding-top:8px;width: 250px;" align="left">终止审批状态:</td>
							<td></td>
						</tr>
						<tr>
							<td align="left" >
							    <select id="port_org_code" class="search-input input-175px" name="port_org_code">
									<option value=""></option>
									<c:if test="${not empty allorgList }">
										<c:forEach items="${allorgList}" var="row">
											<c:if test="${port_org_code == row.org_code}">
												<option selected="selected" value="${row.org_code}">${row.name}</option>
											</c:if>
											<c:if test="${port_org_code != row.org_code}">
												<option value="${row.org_code}">${row.name}</option>
											</c:if>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td align="left">
								<select name="status" id="review_result">
									<option value="('1','2','3','4','5','7')">全部</option>
									<option value="('8')" <c:if test="${status == \"('8')\"}" >selected="selected"</c:if>>已审批</option>
									<option value="('1','2','3','4','5','7')" <c:if test="${status == \"('1','2','3','4','5','7')\"}" >selected="selected"</c:if>>未审批</option>
								</select>
							</td>
							<td></td>						
						</tr>
						<tr>
							<td style="padding-top:10px" align="right" colspan="3"><input name="searchF" type="submit"
								class="abutton" value="查 询" /></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data"><span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</span>
			</div>
			
			<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:6%">企业名称</td>
								<td style="width:5%">联系人</td>
								<td style="width:5%">联系电话</td>
								<td style="width:10%">经营类别</td>
								<td style="width:10%">经营范围</td>
								<td style="width:10%">申请类型</td>
								<td style="width:10%">原卫生许可证号</td>
								<td style="width:20%">终止</td>
								<td style="width:10%">附件</td>
								<td style="width:10%">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">								
								<tr>
									<td>
								<a href='#' onclick="javascript:location='${ctx}/xk/doDetail?license_dno=${row.license_dno}'">${row.comp_name}</a>
								</td>
									<td>${row.contacts_name}</td>
									<td>${row.contacts_phone}</td>
									<td>
										<c:forEach items="${row.management_type}" var="items" varStatus="aa">
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
									<td>${row.apply_scope}</td>
									<td>
										<c:if test="${row.apply_type == 1}">
											初次
										</c:if>
										<c:if test="${row.apply_type == 2}">
											变更
										</c:if>
										<c:if test="${row.apply_type == 3}">
											延续
										</c:if>
										<c:if test="${row.apply_type == 4}">
											临时经营
										</c:if>
										<c:if test="${row.apply_type == 5}">
											公共场所
										</c:if>
									</td>
									<td>${row.hygiene_license_number}</td>
						            <td>
						            	<c:if test="${row.status == 7 && empty row.zz_result}">
						            		<select id="zz_${row.id}" onchange="gzs('${row.id}')" >
												<option value="4" selected="selected">申请人撤回卫生许可申请</option>
						            		</select>
					            		</c:if>
					            		<c:if test="${row.status != 7 && row.status != 8 && empty row.zz_result}">
						            		<select id="zz_${row.id}" onchange="gzs('${row.id}')">
						            			<option value="1">申请事项依法不需要取得卫生许可</option>
												<option value="2">申请事项依法不属于本检验检疫机构职权范围</option>
												<option value="3">申请人未在规定期限内补正有关申请材料</option>
												<option value="5">其他依法应当终止办理卫生许可</option>				
						            		</select>
					            		</c:if>
					            		
					            		<c:if test="${not empty row.zz_result}">
						            	
						            			<c:if test ="${row.zz_result == 1}">申请事项依法不需要取得卫生许可</c:if>
												<c:if test ="${row.zz_result == 2}">申请事项依法不属于本检验检疫机构职权范围</c:if>
												<c:if test ="${row.zz_result == 3}">申请人未在规定期限内补正有关申请材料</c:if>
												<c:if test ="${row.zz_result == 4}">申请人撤回卫生许可申请</c:if>
												<c:if test ="${row.zz_result == 5}">其他依法应当终止办理卫生许可</c:if>				
						            		
					            		</c:if>
					            		<br/>
										<a href = "#" id="a_bysl_${row.id}" style="display: none" onclick="byWinShow('${row.id}','${row.declare_date}',
										'${row.license_dno}','${row.comp_name}')">不予受理决定书</a>	
										
										<a href = "#" id="a_sdhz_${row.id}" style="display: none" onclick="winShow('${row.license_dno}','D_SDHZ5','${row.comp_name}','1','new')">送达回证</a>
						            </td>
						            <td>
					            		<c:if test="${not empty row.file_name}">     
					            			<a href='#' onclick="wenshudownloadFile('${row.file_name}')">查看</a>
					            		</c:if>
						            </td>
						            <td>
						            <c:if test="${row.status != 8}"> 
					            		<a href='#' onclick="doStatus('${row.license_dno}','${row.id}')">审批</a>
					            	</c:if>
					            		<c:if test="${row.status == 8}"> 
					            		已审批
					            		</c:if>
					            		<br/>
					            		<!-- <select id="zz">
					            			<option value="1">检验检疫机构工作人员滥用职权、玩忽职守作出准予卫生许可决定的</option>
											<option value="2">超越法定职权作出卫生许可决定的</option>
											<option value="3">违反法定程序作出卫生许可决定的</option>
											<option value="4">对不具备申请资格或者不符合法定条件的申请人准予卫生许可的</option>
											<option value="5">申请人以欺骗、贿赂等非法手段骗取卫生许可证的</option>
											<option value="6">依法可以撤销卫生许可的其他情形</option>
					            		</select>
					            		<br/>
					            		<select id="zx">
					            			<option value="1">卫生许可有效期届满未延续的</option>
											<option value="2">法人或者其他组织依法终止的</option>
											<option value="3">被许可人申请注销卫生许可的</option>
											<option value="4">卫生许可依法被撤销、撤回，或者卫生许可证件依法被吊销的</option>
											<option value="5">因不可抗力导致卫生许可事项无法实施的</option>
											<option value="6">法律、法规规定的应当注销卫生许可的其他情形</option>
					            		</select> -->
					            		
					            		<%-- <a href = "#" id="a_zy_${row.id}" onclick="zyWinShow('${row.id}','${row.comp_name}',
										'${row.legal_name}','${row.management_addr}',
										'${row.declare_date}','${row.approval_date}')">准予许可决定书</a>
										<a href = "#" id="a_by_${row.id}" style="display: none" onclick="byWinShow('${row.id}','${row.comp_name}',
										'${row.legal_name}','${row.management_addr}',
										'${row.declare_date}','${row.approval_date}')">不准予许可决定书</a> --%>
						            </td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>企业名称</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>经营类别</td>
								<td>经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证号</td>
								<td>终止</td>
								<td>附件</td>
								<td>操作</td>
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
					确定通过审批吗?
				</th>
			</tr>
			<tr>
				<td colspan="2" style="text-align:left">
					<input id="toApproval" type="button" class="btn" style="width:35px;height:30px" value="确定" />
					<input onclick="$.unblockUI();" type="button" style="width:35px;height:30px" class="btn" value="取消" />
				</td>
			</tr>
		</table>
    </div>
</body>

</html>
