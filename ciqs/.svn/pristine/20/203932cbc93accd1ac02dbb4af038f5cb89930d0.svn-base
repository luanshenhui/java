<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>随机人员查询</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 

		function pageUtil(page) {
			$("#xk_form").attr("action", "/ciqs/xk/findAddpesons2?page="+page);
			$("#xk_form").submit();
		}
		
		function userShow(url,id,org_code,approval_users_name) {
			url+="&pid="+id+"&sl_org_code="+org_code+"&approval_users_name="+approval_users_name;			
			window.open(url);
		}
		
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
			
			$("#toApproval").click(function() {
				$("#xk_form").submit();
				$.unblockUI();
			});
			
			$("#toApproval2").click(function() {
				$("#xk_form").submit();
				$.unblockUI();
			});
		});

        function setPeson(namesid,license_dno){
            
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/setPeson?names="+$("#"+namesid).val()+"&license_dno="+license_dno);
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
		
		function setTy(license_dno,namesid){
			var approval_users_name = $("#"+namesid).val();
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/setTy?license_dno="+license_dno+"&approval_users_name="+approval_users_name);
			$.blockUI({ message: $('#showDel2'), css: { width: '275px' } });
		}
		
		function scsShow(no,id){
		    var url = "<%=request.getContextPath()%>/xk/toPsyEdit?license_dno="+no+"&sczry="+$("#"+id).val()+"&approval_users_name2="+$("#"+id).val();
			window.open(url);
		}
		
		function gaizhang(no,ws_type){
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
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; 
			<a href="${cxt}/ciqs/xk/findAddpesons2">随机人员领导查询</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">卫生许可证查询</div> -->
		<div class="search">
			<div class="main">
				<form action="/ciqs/xk/findAddpesons2"  method="post" id="xk_form">
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
							<td align="right">受理局:</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td align="left">
								<select id="port_org_code" class="search-input input-175px" name="port_org_code">
									<option value="">请选择</option>
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
						<td></td>
						<td></td>
						</tr>
						<tr>
							<td align="right" colspan="3"><input name="searchF" type="submit" 
								class="abutton" value="查 询" />
							</td>
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
								<td style="width:130px">单位名称</td>
								<!-- <td>联系人</td>
								<td>联系电话</td> -->
								<td>经营类别</td>
								<td>申请经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证证号</td>
								<td>受理局</td>
								<td>人员姓名</td>
								<td>审查派员申请书</td>
								<td>随机分配</td>
								<td>操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
									<tr>
									<td>
										<a href='#' onclick="javascript:location='${ctx}/xk/doDetail?license_dno=${row.license_dno}'">${row.comp_name}</a>
									</td>
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
									<td>${row.admissible_org_code}</td>
									
									<td>
										<input id="peson_name_2${row.id}" type="text" style="width:200px" value="${row.approval_users_name2}" readonly="readonly"/>
										<input id="peson_name_${row.id}" readonly="readonly" type="hidden" style="width:160px" value="${row.approval_users_name}"/>
										<%-- <input id="peson_name_${row.id}" readonly="readonly" type="text" style="width:160px" value="${fn:substring(row.approval_users_name,1,fn:length(row.approval_users_name))}"/> --%>
									</td>
									<td>
										<input type="button" style="width:60px" value="点击编制" onclick="scsShow('${row.license_dno}','peson_name_${row.id}')"/>
										<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SQ_SHRY')">(盖章)</a>
									</td>
						            <td>
						            	<input type="button" style="width:60px" value="随机分配" onclick="userShow('/ciqs/xk/addpeson2?apply_no=${row.license_dno}','${row.id}','${row.org_code}','${row.approval_users_name}')" <c:if test ="${row.status ==4}">disabled="disabled"</c:if>/>
										<%-- <input type="button" style="width:60px" value="随机分配" onclick="userShow('/ciqs/xk/peson?apply_no=${row.license_dno}')"/> --%>
						            </td>
						            <td>	            	
						            	<c:if test="${row.status == 3}">
						            		<a href="#" onclick="setTy('${row.license_dno}','peson_name_${row.id}')">同意</a>
						            	</c:if>
						            	<c:if test="${row.status >= 4}">
						            		已同意
						            	</c:if>
						            </td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>单位名称</td>
								<!-- <td>联系人</td>
								<td>联系电话</td> -->
								<td>经营类别</td>
								<td>申请经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证证号</td>
								<td>受理局</td>
								<td>人员姓名</td>
								<td>审查派员申请书</td>
								<td>随机分配</td>
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
    
    <div style="width: 400px;margin-left:5px; display: none; text-align:center;" id="showDel2">
		<table style="width: 200px; height:100px" >
			<tr>
				<th  style="text-align:left;font-size:16px">
					确定同意吗?
				</th>
			</tr>
			<tr>
				<td colspan="2" style="text-align:left">
					<input id="toApproval2" type="button" class="btn" style="width:35px;height:30px" value="确定" />
					<input onclick="$.unblockUI();" type="button" style="width:35px;height:30px" class="btn" value="取消" />
				</td>
			</tr>
		</table>
    </div>
</body>

</html>
