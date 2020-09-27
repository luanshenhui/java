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
			$("#xk_form").attr("action", "${ctx}/xk/findReviews?page="+page);
			$("#xk_form").submit();
		}
		
		function doApproval(id,license_dno){
			$("#xk_form").attr("action", "${ctx}/xk/doReview?id="+id+"&reviewResult="+$("#review_result"+id).val()
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
		
		function zyWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date,add){
			window.open("${ctx}/xk/zyjdsShowOld?"
	 		+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date+"&comp_addr="+add);
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
	    var wsType ="4";
	    function showWs(selectid,rowid){
	    	var value = $("#"+selectid).val();
	    	if(value == 2){
	    		$("#a_zy_"+rowid).hide();
	    		$("#a_by_"+rowid).show();
	    		$("#d_bu_sl").show();
	    		$("#d_sq_sl").hide();
	    		wsType = 5;
	    	}else{
	    		$("#a_by_"+rowid).hide();
	    		$("#a_zy_"+rowid).show();
	    		$("#d_sq_sl").show();
	    		$("#d_bu_sl").hide();
	    		wsType = 4;
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
		    					 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&type=sdhz2&ws_type="+wsType);
		    			}else{
		    				alert("未收到企业端送达回证!");
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
		
	  function sqsDpf(no,ws_type){
	       location="<%=request.getContextPath()%>/xk/toDpf?license_dno="+no+"&doc_type="+ws_type;		
	  }
	  
	  function downloadFile(filePath){
		     if(filePath !=null){
		      filePath = filePath.substring(14,filePath.length);
		     }
			 location = "<%=request.getContextPath()%>/dc/downloadFile2?path="+filePath;
		} 
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="${cxt}${ctx}/xk/findReviews">决定与送达</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>	
<!-- 		<div class="title">现场评审查询</div> -->
		<div class="search">
			<div class="main">
				<form action="${ctx}/xk/findReviews"  method="post" id="xk_form">
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
							<td style="width: 250px;" align="left">评审结果:</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td align="left">
								<select name="review_result" id="review_result">
									<option value=""></option>
									<option value="0" <c:if test="${review_result == '0'}" >selected="selected"</c:if>>合格</option>
									<option value="1" <c:if test="${review_result == '1'}" >selected="selected"</c:if>>不合格</option>
								</select>
							</td>
							<td></td>
							<td></td>						
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
								<td style="width:120px">企业名称</td>
								<td style="width:80px">经营类别</td>
								<td style="width:80px">经营范围</td>
								<td style="width:60px">申请类型</td>
								<td style="width:100px">原卫生许可证号</td>
								<td style="width:60px">评审组人员</td>
								<td style="width:50px">评审结果</td>
								<td style="width:80px">评审时间</td>
								<td style="width:120px">整改书及送达回证</td>
								<td style="width:40px">申请书</td>
								<td style="width:160px">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<c:if test = "${row.jb_date >= 20 && empty row.review_result}" >
									<tr style="color:red">
								</c:if>
								<c:if test = "${not empty row.review_result}" >
									<tr>
								</c:if>
								<c:if test = "${row.jb_date < 20 && empty row.review_result}" >
									<tr>
								</c:if>
									<td style="width:80px;">${row.comp_name}</td>
									<%-- <td>${row.contacts_name}</td>
									<td>${row.contacts_phone}</td> --%>
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
									<td  style="width:150px">${row.approval_users_name2}</td>
									<td>
										<c:if test="${row.review_result == 0}">
											合格
										</c:if>
										<c:if test="${row.review_result == 1}">
											不合格
										</c:if>
									</td>
						            <td>${row.review_date}</td>
						            <td>
						            	<c:if test="${not empty row.iszg}">
						            	<a href = "#" onclick="zgsShow('${row.license_dno}')">整改书</a><br/>
						            	<a href = "#" onclick="winShow2('${row.license_dno}','D_PT_H_L_13','${row.comp_name}','${row.review_result}')">送达回证</a>
						            	<%-- <a href = "#" onclick="gaizhang('${row.license_dno}','D_PT_H_L_13')">(盖章)</a> --%><br/>
						            	<c:if test="${not empty row.filePath}">
						            		<a href = "#" onclick="downloadFile('${row.filePath}')" >整改报告查看</a>
						            	</c:if>
						            	</c:if>
								    </td>
						            <td>
						            	<a href = "#" onclick="sqsWinShow('${row.id}','${row.license_dno}')">查看</a><br/>
						            	<a href = "#"  onclick="sqsDpf('${row.license_dno}','D_SQS')">(盖章)</a>	
								    </td>     
						            <td>
						            	<c:if test="${row.status == 4}">
							            	<select style="width:80px" id="review_result${row.id}" onchange="showWs('review_result${row.id}','${row.id}')">
												<option value="1" >准予许可</option>
												<option value="2" >不予许可</option>
									        </select>
								            <br/>
						            		<a href = "#" id="a_zy_${row.id}" onclick="zyWinShow('${row.id}','${row.comp_name}',
											'${row.legal_name}','${row.management_addr}',
											'${row.declare_date}','${row.approval_date}','${row.comp_addr}')">准予许可决定书</a>
											<a href = "#" id="a_by_${row.id}" style="display: none" onclick="byWinShow('${row.id}','${row.comp_name}',
											'${row.legal_name}','${row.management_addr}',
											'${row.declare_date}','${row.approval_date}')">不准予许可决定书</a>
											<a href = "#"  id="d_sq_sl" onclick="gaizhang('${row.license_dno}','D_SQ_SL')">(盖章)</a>
											<a href = "#"  id="d_bu_sl" style="display: none" onclick="gaizhang('${row.license_dno}','D_BU_SL')">(盖章)</a><br/>
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ2','${row.comp_name}','${row.review_result}')">送达回证</a><br/>
											<%-- <a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ2')">(盖章)</a><br/>	 --%>
						            		<a href='#' onclick="doApproval('${row.id}','${row.license_dno}')">提交</a>
						            	</c:if>
						            	<c:if test="${row.status == 5 || row.status == 6}">
						            		已审批
						            	</c:if>
						            	
						            	|&nbsp;<a href='#' onclick="javascript:location='${ctx}/xk/doDetail?license_dno=${row.license_dno}'">详情 </a>
						            </td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>企业名称</td>
								<td>经营类别</td>
								<td>经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证号</td>
								<td>评审人员</td>
								<td>评审结果</td>
								<td>评审时间</td>
								<td>整改书及送达回证</td>
								<td>申请书</td>
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
					确定通过提交吗?
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
