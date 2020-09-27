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
			$("#xk_form").attr("action", "${ctx}/xk/findLicenseDecs?page="+page);
			$("#xk_form").submit();
		}
		
		function doApproval(id,no){
			$("#xk_form").attr("action", "${ctx}/xk/doApproval?id="+id+"&do_approval_result="+$("#approval_result"+id).val()
			+"&license_dno="+no);
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
		
		function byWinShow(id,obj,license_dno,comp_name){
	 		window.open("${ctx}/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
		}
		
		function bzWinShow(id,obj,license_dno,comp_name,sq_status){
	 		window.open("${ctx}/xk/toBzgzsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name+"&sq_status="+sq_status);
		}
	
		function slWinShow(id,comp_name,legal_name,management_addr,contacts_name,contacts_phone,license_dno){
		 	window.open("${ctx}/xk/toSlgzsOld?"
		 	+"id="+id
		 	+"&license_dno="+license_dno
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&contacts_name="+contacts_name
		 	+"&contacts_phone="+contacts_phone);
	    }
	    
	    function sdhzWinShow(id,comp_name,mailbox,declare_date,approval_users_name,license_dno){
	 		window.open("${ctx}/xk/toSdhz?&comp_name="+comp_name
	 		+"&mailbox="+mailbox
		 	+"&declare_date="+declare_date
		 	+"&approval_users_name="+approval_users_name);
		}
		var ws_type ="3";
		function showWs(selectid,rowid){
	    	var value = $("#"+selectid).val();
	    	if(value == 1){
	    		$("#a_s_"+rowid).show();
	    		$("#a_zy_"+rowid).hide();
	    		$("#a_by_"+rowid).hide();
	    		ws_type = 1;
	    		onchangeWs_type = "D_SQ_BZ";
	    	}else if(value == 2 || value == 4){
	    		$("#a_s_"+rowid).hide();
	    		$("#a_zy_"+rowid).hide();
	    		$("#a_by_"+rowid).show();
	    		ws_type = 2;
	    		onchangeWs_type = "D_BY_GZ";
	    	}else{
	    		$("#a_s_"+rowid).hide();
	    		$("#a_zy_"+rowid).show();
	    		$("#a_by_"+rowid).hide();
	    		ws_type = 3;
	    		onchangeWs_type = "D_SL_GZ";
	    	}	    	
	    }
	    
	    function winShow(no,type,comp_name,num,sq_status){
	 
		   $.ajax({
	    		url:"${ctx}/xk/getResult2?ProcMainId="+no+"&DocType=D_SDHZ",
	    		type:"get",
	    		dataType:"json",
	    		success:function(data){
	    			if(data.results == 0 || data.results == 2 /* || sq_status =="new" */){
	    				window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
							 	+no+"&doc_type="+type+"&comp_name="+comp_name+"&ws_type="+ws_type+"&sq_status="+sq_status);
	    			}else{
	    				alert("未收到企业送达回证!");
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
		var onchangeWs_type = "D_SL_GZ";
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
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="<%=request.getContextPath()%>/xk/findLicenseDecs">卫生许可证受理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">卫生许可证查询</div> -->
		<div class="search">
			<div class="main">
				<form action="${ctx}/xk/findLicenseDecs"  method="post" id="xk_form">
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
							<td align="right">审批结果:</td>
							<td></td>
							<td></td>
						</tr>
						<tr>	
							<td align="left">
								<select name="approval_result" id="approval_result" style="height: 30px;width:180px">
									<option value=""></option>
									<c:if test="${approval_result == 1}">
										<option value="1" selected="selected">材料不全</option>
									</c:if>
									<c:if test="${approval_result != 1}">
										<option value="1">材料不全</option>
									</c:if>
									<c:if test="${approval_result == 2}">
										<option value="2" selected="selected">不符合受理条件</option>
									</c:if>
									<c:if test="${approval_result != 2}">
										<option value="2" >不符合受理条件</option>
									</c:if>
									<c:if test="${approval_result == 3}">
										<option value="3" selected="selected">符合受理条件</option>
									</c:if>
									<c:if test="${approval_result != 3}">
										<option value="3">符合受理条件</option>
									</c:if>
									<option value = "4" <c:if test="${approval_result == 4}" >selected="selected"</c:if>>不需要取得行政许可</option>
								</select>
							</td>
							<td></td>
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
								<td style="width:120px">单位名称</td>
								<!-- <td>单位地址</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>从业人数</td> -->
								<td style="width:50px">通过体系认证</td>
								<td>经营类别</td>
								<td>经营范围</td>
								<td>申请类型</td>
								<td style="width:110px">原卫生许可证号</td>
								<td style="width:110px">审批结果</td>
								<td style="width:150px">告知书</td>
								<td style="width:90px">查看附件</td>
								<td style="width:70px">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
								<%-- <c:if test = "${row.jb_date >= 20 && empty row.approval_result}" >
									<tr style="color:red">
								<%-- </c:if>
								<c:if test = "${not empty row.approval_result}" >
									<tr>
								</c:if>
								<c:if test = "${row.jb_date < 20 && empty row.approval_result}" >
									<tr>
								</c:if> --%>
									<td style="width:80px">${row.comp_name}</td>
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
									<td>
										<c:if test="${empty row.approval_result}" >
										    <select name="approval_result" id="approval_result${row.id}" style="width:103px;height:30px" onchange="showWs('approval_result${row.id}','${row.id}')">
										    	<option value="3">符合受理条件</option>
												<option value="1">材料不全</option>
												<option value="2">不符合受理条件</option>
												<option value="4">不需要取得行政许可</option>
									        </select>
								        </c:if>
										<c:if test="${row.approval_result == 1}">
											材料不全
										</c:if>
										<c:if test="${row.approval_result == 2}">
											不符合受理条件
										</c:if>
										<c:if test="${row.approval_result == 3}">
											符合受理条件
										</c:if>
										<c:if test="${row.approval_result == 4}">
											不需要取得行政许可
										</c:if>
						            </td>
						            <td>
						            	<c:if test="${empty row.approval_result}">
											<a href = "#" id="a_s_${row.id}" style="display: none" onclick="bzWinShow('${row.id}','${row.declare_date}','${row.license_dno}','${row.comp_name}','new')">申请材料补正告知书</a>
											<a href = "#" id="a_by_${row.id}" style="display: none" onclick="byWinShow('${row.id}','${row.declare_date}','${row.license_dno}','${row.comp_name}')">不予受理决定书</a>
											<a href = "#" id="a_zy_${row.id}" onclick="slWinShow('${row.id}','${row.comp_name}',
											'${row.legal_name}','${row.management_addr}',
											'${row.contacts_name}','${row.contacts_phone}','${row.license_dno}')">准予受理决定书</a>
											<a href = "#"  onclick="gaizhang('${row.license_dno}')">(盖章)</a><br/>	
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ','${row.comp_name}','1','new')">送达回证</a>
											<%-- <a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ')">(盖章)</a>	 --%>									
										</c:if>
										<c:if test="${row.approval_result == 1}">
											<a href = "#" onclick="bzWinShow('${row.id}','${row.declare_date}','${row.license_dno}','${row.comp_name}')">申请材料补正告知书</a>
											<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SQ_BZ')">(盖章)</a><br/>	
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ','${row.comp_name}','2')">送达回证</a>
											<%-- <a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ')">(盖章)</a>	 --%>
										</c:if>
										<c:if test="${row.approval_result == 2}">
											<a href = "#" onclick="byWinShow('${row.id}','${row.declare_date}','${row.license_dno}','${row.comp_name}')">不予受理决定书</a>
											<a href = "#"  onclick="gaizhang('${row.license_dno}','D_BY_GZ')">(盖章)</a><br/>
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ','${row.comp_name}','3')">送达回证</a>
<%-- 											<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ')">(盖章)</a>	 --%>
										</c:if>
										<c:if test="${row.approval_result == 3}">
											<a href = "#" onclick="slWinShow('${row.id}','${row.comp_name}',
											'${row.legal_name}','${row.management_addr}',
											'${row.contacts_name}','${row.contacts_phone}','${row.license_dno}')">准予受理决定书</a>
											<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SL_GZ')">(盖章)</a><br/>
											<a href = "#"  onclick="winShow('${row.license_dno}','D_SDHZ','${row.comp_name}','4')">送达回证</a>
											<%-- <a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ')">(盖章)</a>	 --%>
										</c:if>	
						            </td>
						            <td>
						            	<c:if test="${not empty row.file_name}">     
					            			<a href='#' onclick="wenshudownloadFile('${row.file_name}')">下载查看</a>
					            		</c:if>
					            	</td>
									<td>
										<a href='#' onclick="javascript:location='${ctx}/xk/doDetail?license_dno=${row.license_dno}'">详情 </a>
										<c:if test="${empty row.approval_result}">
											|&nbsp;<a href='#' onclick="doApproval('${row.id}','${row.license_dno}')">审批 </a>
										    <%-- <a href = "#" onclick="sdhzWinShow('${row.id}','${row.comp_name}','${row.mailbox}',
											'${row.declare_date}','${row.approval_user}','${row.license_dno}')">送达回证 </a>
											<br/> --%>
										</c:if>
										
										<%-- <a href='javascript:jumpPage("${ctx}/users/delUsers?uid=${row.id}");' 
											onclick="javascript:return confirm('是否确定执行此操作？');">
											删除
										</a>
										|
										<a href='javascript:jumpPage("${ctx}/users/showUser?uid=${row.id}");'>查看</a> |
										<a href='javascript:jumpPage("${ctx}/users/toAddUserAuth?uid=${row.id}");'>添加角色</a>
										|
										<a href='javascript:jumpPage("${ctx}/users/resetPwd?uid=${row.id}");'
											onclick="javascript:return confirm('是否确定将此用户密码重置为”111111“？');">
											密码重置
										</a> --%>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>单位名称</td>
								<!-- <td>单位地址</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>从业人员人数</td> -->
								<td>通过体系认证</td>
								<td>经营类别</td>
								<td>经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证号</td>
								<td>审批结果</td>
								<td>告知书</td>
								<td style="width:90px">查看附件</td>
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
					确定审批吗?
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
