<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证受理查询</title>
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
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/findScs1?page="+page);
			$("#xk_form").submit();
		}
		
		function doExamination(id,no){
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/doExamination1?id="+id
			+"&exam_result="+$("#exam_result_"+id).val()+"&license_dno="+no);
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
		
		function byWinShow(id,obj,license_dno,comp_name){
	 		window.open("<%=request.getContextPath()%>/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
		}
		
		function bzWinShow(id,obj,license_dno,comp_name){
	 		window.open("<%=request.getContextPath()%>/xk/toBzgzsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
		}
	
		function slWinShow(id,comp_name,legal_name,management_addr,contacts_name,contacts_phone,license_dno){
		 	window.open("<%=request.getContextPath()%>/xk/toSlgzsOld?"
		 	+"id="+id
		 	+"&license_dno="+license_dno
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&contacts_name="+contacts_name
		 	+"&contacts_phone="+contacts_phone);
	    }
	    
	    function sdhzWinShow(id,comp_name,mailbox,declare_date,approval_users_name,license_dno){
	 		window.open("<%=request.getContextPath()%>/xk/toSdhz?&comp_name="+comp_name
	 		+"&mailbox="+mailbox
		 	+"&declare_date="+declare_date
		 	+"&approval_users_name="+approval_users_name);
		}
		
		function showWs(selectid,rowid){
	    	var value = $("#"+selectid).val();
	    	if(value == 1){
	    		$("#a_s_"+rowid).show();
	    		$("#a_zy_"+rowid).hide();
	    		$("#a_by_"+rowid).hide();
	    	}else if(value == 2){
	    		$("#a_s_"+rowid).hide();
	    		$("#a_zy_"+rowid).hide();
	    		$("#a_by_"+rowid).show();
	    	}else{
	    		$("#a_s_"+rowid).hide();
	    		$("#a_zy_"+rowid).show();
	    		$("#a_by_"+rowid).hide();
	    	}	    	
	    }
	    function winShow(no,type,comp_name){
		 	window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
		 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&type=sdhz");
        }
	    jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
		});
		
		function wenshudownloadFile(path){
	
     	    if(path !=null){
      			path = path.substring(14,path.length);
				location = "<%=request.getContextPath()%>/xk/downloadFile?path="+path;
			}
	    }
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="<%=request.getContextPath()%>/xk/findScs1">初审</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">卫生许可证查询</div> -->
		<div class="search">
			<div class="main">
				<form action="<%=request.getContextPath()%>/xk/findScs1"  method="post" id="xk_form">
					<table class="table_search" id="aa">
						<tr>
							<td style="width: 250px;" align="left">企业名称:</td>
							<td style="width: 250px;" align="left">开始时间:</td>
							<td style="width: 250px;" align="left">结束时间:</td>
						</tr>
						<tr>
							<td align="left">
								<input type="text" style="height: 24px;width:180px" name="comp_name" id="comp_name" size="14" value="${comp_name}"/>
							</td>
							<td align="left">
								<input type="text" class="datepick" style="height: 24px;width:180px" size="14" name="startDeclare_date" id="startDeclare_date" value="${startDeclare_date}"/>
							</td>
							<td align="left">
								<input type="text" class="datepick" style="height: 24px;width:180px" size="14" name="endDeclare_date" id="endDeclare_date" value="${endDeclare_date}"/>
							</td>
						</tr>
						<tr>
							<td align="right" colspan="3" style="padding-top: 15px;margin-left: 320px;"><input name="searchF" type="submit" class="abutton"
								 value="查 询" /></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data">
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
								<td style="width:110px">单位名称</td>
								<!-- <td>单位地址</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>从业人数</td> -->
								<td style="width:50px">通过体系认证</td>
								<td style="width:80px">经营类别</td>
								<td>经营范围</td>
								<td style="width:80px">申请类型</td>
								<td>原卫生许可证号</td>
								<td>受理人员</td>
								<td style="width:90px">受理时间</td>
								<td style="width:90px">申请时间</td>
								<td style="width:90px">查看附件</td>
								<td style="width:100px">审核</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<c:if test = "${row.jb_date >= 20 && empty row.approval_result}" >
									<tr style="color:red">
								</c:if>
								<c:if test = "${not empty row.approval_result}" >
									<tr>
								</c:if>
								<c:if test = "${row.jb_date < 20 && empty row.approval_result}" >
									<tr>
								</c:if>
									<td>${row.comp_name}</td>
									<%-- <td style="width:100px">${row.comp_addr}</td>
									<td>${row.contacts_name}</td>
									<td>${row.contacts_phone}</td>
									<td>${row.employee_num}</td> --%>
									<td>
										<c:if test="${row.certificate_numver == 0}">
											否
										</c:if>
										<c:if test="${row.certificate_numver == 1}">
											是
										</c:if>
									</td>
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
									<td>${row.approval_user}</td>
						            <td>
										<fmt:formatDate value="${row.approval_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
						            </td>
						            <td>
										<fmt:formatDate value="${row.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
						            </td>
						            <td>
						            	<c:if test="${not empty row.file_name}">     
					            			<a href='#' onclick="wenshudownloadFile('${row.file_name}')">下载查看</a>
					            		</c:if>
					            	</td>
									<td>
										<c:if test="${empty row.exam_result}">
										  <select style="width:65px" id="exam_result_${row.id}">
										  	<option value="1">合格</option>
										  	<option value="0">不合格</option>
										  </select><br/>
										  <a href='#' id="doExamination" onclick="doExamination('${row.id}','${row.license_dno}')">提交</a>
										</c:if>
										<c:if test="${not empty row.exam_result}">
										    已审查
										</c:if>
										|&nbsp;<a href='#' onclick="javascript:location='${ctx}/xk/doDetail?license_dno=${row.license_dno}'">详情 </a>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td style="width:120px">单位名称</td>
								<!-- <td>单位地址</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>从业人数</td> -->
								<td>通过体系认证</td>
								<td>经营类别</td>
								<td>经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证号</td>
								<td>受理人员</td>
								<td>受理时间</td>
								<td>申请时间</td>
								<td>查看附件</td>
								<td>审核</td>
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
					确定提交吗?
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
    
	<script type="text/javascript"> 
		jQuery(document).ready(function(){
			if($("#msg").val()=="success"){
				$("#msg").val('');
				alert("操作成功");
			};
		});
	</script>
</body>
</html>
