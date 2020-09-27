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
			$("#xk_form").attr("action", "${ctx}/xk/findReviewsSp?page="+page);
			$("#xk_form").submit();
		}
		
		function doApproval(id,license_dno,sp_result){
			$("#xk_form").attr("action", "${ctx}/xk/doReviewSp?id="+id+"&sp_result="+sp_result
			+"&license_dno="+license_dno);
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
		
		function byWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date){
	 		window.open("${ctx}/xk/byjdsShowOld?"
		 	+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date);
		}
		
		function zyWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date){
			window.open("${ctx}/xk/zyjdsShowOld?"
	 		+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date);
		}
	
	    function downloadFile(license_dno,file_type){
		    $.ajax({	
				url : "${ctx}/xk/validFile?license_dno=" + license_dno+"&file_type="+file_type,
				method : "post",
				success: function(result){
				    if(result.path != null && result.path !="null"){
				    	location = "${ctx}/xk/downloadFile?path="+result.path;
				    }else{
				    	alert("没有上传该文件!");
				    }
					
				}
			});
	    }
	    
	    function uploadFile(license_dno){
	    	$("#uploadForm").attr("action","${ctx}/xk/uploadFile?license_dno="+license_dno);
	    	$("#uploadForm").submit();
	    	alert("上传成功!");
	    }
	    
	    function wenshudownloadFile(path){
	
     	    if(path !=null){
      			path = path.substring(14,path.length);
				location = "${ctx}/xk/downloadFile?path="+path;
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
		
		function winShow(no,type,comp_name){
			 $.ajax({
		    		url:"${ctx}/xk/getResult2?ProcMainId="+no+"&DocType=D_SDHZ2",
		    		type:"get",
		    		dataType:"json",
		    		success:function(data){
		    			
		    			if(data.results == 0 || data.results == 2){
		    				
		    				window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
		    					 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&type=sdhz2");
		    			}else{
		    				alert("未收到企业端送达回证!");
		    			}
		    		}
		    });			 
		 	
       }
		
		function sqsWinShow(id,license_dno){
			window.open("<%=request.getContextPath()%>/xk/sqsWinShow?id="+id+"&license_dno="+license_dno);
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
		
		function winShow2(no,type,comp_name,ws_type){
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
		
	  function sqsDpf(no,ws_type){
	       location="<%=request.getContextPath()%>/xk/toDpf?license_dno="+no+"&doc_type="+ws_type;		
	  }
	  
	  function gaizhang(no,ws_type){
			if (typeof(ws_type) == "undefined") {
				ws_type = onchangeWs_type;
			}
			$.ajax({
	    		url:"${ctx}/xk/getResult?ProcMainId="+no+"&DocType="+ws_type,
	    		type:"get",
	    		dataType:"json",
	    		success:function(data){
	    			if(data.status == "OK"){
	    				location="<%=request.getContextPath()%>/xk/toDpf?license_dno="+no+"&doc_type="+ws_type;
	    			}else{
	    				alert("未保存文书数据!");
	    			}
	    		}
	    	});		
		}
	  
	  function downloadFile(license_dno,file_type){
		    $.ajax({	
				url : "${ctx}/xk/validFile?license_dno=" + license_dno+"&file_type="+file_type,
				method : "post",
				success: function(result){
				    if(result.path != null && result.path !="null"){
				    	location = "${ctx}/xk/downloadFile?path="+result.path;
				    }else{
				    	alert("没有上传该文件!");
				    }
					
				}
			});
	    }
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="${cxt}${ctx}/xk/findReviewsSp">决定与送达审批</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>	
<!-- 		<div class="title">现场评审查询</div> -->
		<div class="search">
			<div class="main">
				<form action="${ctx}/xk/findReviewsSp"  method="post" id="xk_form">
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
							<td style="width: 250px;" align="left">审批结果:</td>
						</tr>
						<tr>
							<td align="left">
								<select style="width:185px" name="jd_sp">
									<option value="" ></option>
									<option value="1" >同意</option>
									<option value="0">不同意</option>
						        </select>
							</td>
						</tr>		        
						<tr>
							<td align="right" colspan="3"><input name="searchF" type="submit"
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
								<td style="width:20%">企业名称</td>
								<td style="width:20%">原卫生许可证号</td>
								<td style="width:20%">整改书及送达回证</td>
								<td style="width:10%">申请书</td>							
								<td style="width:20%">告知书</td>
								<td style="width:10%">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								 <tr>
									<td style="width:80px;">${row.comp_name}</td>
									<td style="width:80px;">${row.hygiene_license_number}</td>
						            <td>
								    	<c:if test="${not empty atmp.iszg}">
						            	<a href = "#" onclick="zgsShow('${row.license_dno}')">整改书</a><br/>
						            	<a href = "#" onclick="winShow2('${row.license_dno}','D_PT_H_L_13','${row.comp_name}','${row.review_result}')">送达回证</a>
						            	<a href = "#" onclick="gaizhang('${row.license_dno}','D_PT_H_L_13')">(盖章)</a><br/>
						            	<c:if test="${not empty row.filePath}">
						            		<a href = "#" onclick="downloadFile('${row.filePath}')" >整改报告查看</a>
						            	</c:if>
						            	</c:if>
								    </td>		
								    <td>
						            	<a href = "#" onclick="sqsWinShow('${row.id}','${row.license_dno}')">查看</a>
						            	<a href = "#"  onclick="sqsDpf('${row.license_dno}','D_SQS')">(盖章)</a>
								    </td>  	           
						            <td>
						            	<c:if test="${row.jd_result==1}">
							            	<a href = "#" id="a_zy_${row.id}" 
							            	onclick="zyWinShow('${row.id}','${row.comp_name}',
											'${row.legal_name}','${row.management_addr}',
											'${row.declare_date}','${row.approval_date}')">准予许可决定书</a>
											<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SQ_SL')">(盖章)</a><br/>
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ2','${row.comp_name}')">送达回证</a>
											<%-- <a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ2')">(盖章)</a> --%>	
										</c:if>	
										<c:if test="${row.jd_result==2}">
											<a href = "#" id="a_by_${row.id}" 
											onclick="byWinShow('${row.id}','${row.comp_name}',
											'${row.legal_name}','${row.management_addr}',
											'${row.declare_date}','${row.approval_date}')">不准予许可决定书</a>
											<a href = "#"  onclick="gaizhang('${row.license_dno}','D_BU_SL')">(盖章)</a><br/>
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ2','${row.comp_name}')">送达回证</a>
											<%-- <a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ2')">(盖章)</a>	 --%>
						           		</c:if>
						            </td>
						            <td>
							           <c:if test="${row.jd_sp == 1}">
							           		已审批
							           </c:if>
							           <c:if test="${empty row.jd_sp}">
							           		<%-- <select style="width:50px" id="sp_${row.id}">
												<option value="1" >同意</option>
												<option value="0">不同意</option>
								        	</select><br/> --%>
					            			<a href='#' onclick="doApproval('${row.id}','${row.license_dno}','${row.jd_result}')">审批</a>
							           </c:if>
							           |&nbsp;<a href='#' onclick="javascript:location='${ctx}/xk/doDetail?license_dno=${row.license_dno}'">详情 </a>
						            </td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td style="width:80px">企业名称</td>
								<td style="width:120px">原卫生许可证号</td>
								<td>整改书及送达回证</td>
								<td>申请书</td>							
								<td>告知书</td>
								<td style="width:120px">操作</td>
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
