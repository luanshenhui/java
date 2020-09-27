<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>口岸许可证状态查询</title>
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
			$("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/xkzDoStatus?page="+page);
			$("#xk_form").submit();
		}
		
		function byWinShow(id,obj,license_dno,comp_name){
	 		window.open("<%=request.getContextPath()%>/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
		}
		
		function gzs(id){							
			var aa = $("#zz_"+id).val();
			if(aa ==1 || aa ==2 || aa==3 ){
			    $("#a_byjd_"+id).hide();
				$("#a_bysl_"+id).show();
			}else if(aa ==5 ){
				$("#a_bysl_"+id).hide();
				$("#a_byjd_"+id).show();
			}else{
				$("#a_bysl_"+id).hide();
				$("#a_byjd_"+id).hide();
			}
		}
		
		function byjdWinShow(id,comp_name,legal_name,management_addr,declare_date,approval_date){
	 		location = "<%=request.getContextPath()%>/xk/byjdsShowOld?"
		 	+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date;
		}
		
		function doSubmit(id,license_dno){
		     var status = $("#status_"+id).val();
		     if(status == 7){
			     $("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/doSubmit?license_dno="+license_dno+
				"&result="+$("#zz_"+id).val()+"&status="+status);
		     }else{
			     $("#xk_form").attr("action", "<%=request.getContextPath()%>/xk/doSubmit?license_dno="+license_dno+
				"&result="+$("#zx_"+id).val()+"&status="+status);
		     }
			
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="/xk/xkzDoStatus">口岸许可证状态查询</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>	
<!-- 		<div class="title">现场评审查询</div> -->
		<div class="search">
			<div class="main">
				<form action="<%=request.getContextPath()%>/xk/xkzDoStatus"  method="post" id="xk_form">
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
								<td style="width:80px">企业名称</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td style="width:80px">经营类别</td>
								<td style="width:80px">经营范围</td>
								<td style="width:80px">申请类型</td>
								<td style="width:120px">原卫生许可证号</td>		
								<td style="width:100px">终止撤销与注销</td>
								<td style="width:80px">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<input type="hidden" id="status_${row.id}" value="${row.status}"/>
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
									<td>${row.contacts_name}</td>
									<td>${row.contacts_phone}</td>
									<td>
										<c:if test="${row.management_type == 1}">
											食品生产
										</c:if>
										<c:if test="${row.management_type == 2}">
											食品流通
										</c:if>
										<c:if test="${row.management_type == 3}">
											餐饮服务
										</c:if>
										<c:if test="${row.management_type == 4}">
											饮用水供应
										</c:if>
										<c:if test="${row.management_type == 5}">
											公共场所
										</c:if>
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
									<c:if test="${row.status == 7}">
									<td>
										<select id="zz_${row.id}" onchange="gzs('${row.id}')">
					            			<option value="1">检验检疫机构工作人员滥用职权、玩忽职守作出准予卫生许可决定的</option>
											<option value="2">超越法定职权作出卫生许可决定的</option>
											<option value="3">违反法定程序作出卫生许可决定的</option>
											<option value="4">对不具备申请资格或者不符合法定条件的申请人准予卫生许可的</option>
											<option value="5">申请人以欺骗、贿赂等非法手段骗取卫生许可证的</option>
											<option value="6">依法可以撤销卫生许可的其他情形</option>
					            		</select>
					            		<br/>
										<a href = "#" id="a_bysl_${row.id}" style="display: none" onclick="byWinShow('${row.id}','${row.declare_date}',
										'${row.license_dno}','${row.comp_name}')">不予受理决定书</a>										
										<a href = "#" id="a_byjd_${row.id}" style="display: none" onclick="byjdWinShow('${row.id}','${row.comp_name}',
										'${row.legal_name}','${row.management_addr}',
										'${row.declare_date}','${row.approval_date}')">不准予许可决定书</a>
									</td>
									</c:if>
									<c:if test="${row.status == 12}">
							            <td>
							            	<select id="zx_${row.id}">
						            			<option value="1">卫生许可有效期届满未延续的</option>
												<option value="2">法人或者其他组织依法终止的</option>
												<option value="3">被许可人申请注销卫生许可的</option>
												<option value="4">卫生许可依法被撤销、撤回，或者卫生许可证件依法被吊销的</option>
												<option value="5">因不可抗力导致卫生许可事项无法实施的</option>
												<option value="6">法律、法规规定的应当注销卫生许可的其他情形</option>
						            		</select>
										</td>
									</c:if>
						            <td>
					            		<a href='#' onclick="doSubmit('${row.id}','${row.license_dno}')">提交</a>
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
								<td style="width:80px">终止撤销与注销</td>
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
