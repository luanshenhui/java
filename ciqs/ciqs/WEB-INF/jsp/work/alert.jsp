<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证受理查询</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
		/* 分页 */
		function pageUtil(page) {
			$("#xk_form").attr("action", "${ctx}/work/alert?page="+page);
			$("#xk_form").submit();
		}
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
		
		function doApproval(id){
			$("#xk_form").attr("action", "${ctx}/xk/doApproval?id="+id+"&do_approval_result="+$("#approval_result"+id).val());
			$.blockUI({ message: $('#showDel'), css: { width: '275px' } });
		}
		
		function byWinShow(id,obj,license_dno,comp_name){
	 		window.open("${ctx}/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
		}
		
		function bzWinShow(id,obj,license_dno,comp_name){
	 		window.open("${ctx}/xk/toBzgzsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
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
				location = "${ctx}/xk/downloadFile?path="+path;
			}
	    }
		function checkform(f){
			if(f.prolong.value ==""){
				alert("请输入延长期理由!");
				return false;
			}
			return true;
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
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a
				href="${cxt}/xk/findLicenseDecs">工作提醒查询</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="search">
			<div class="main">
				<form action="${ctx}/work/alert"  method="post" id="xk_form" >
					<table class="table_search" id="aa">
						<tr>
							<td style="width: 250px;" align="left">企业名称:</td>
							<td style="width: 250px;" align="left">开始时间:</td>
							<td style="width: 250px;" align="left">结束时间:</td>
						</tr>
						<tr>
							<td align="left">
								<input type="text" style="height: 24px;width:180px" name="compName" id="compName" size="14" value="${compName}"/>
							</td>
							<td align="left">
								<input type="text" class="datepick" style="height: 24px;width:180px" size="14" name="starApproval_date" id="starApproval_date" value="${starApproval_date}"/>
							</td>
							<td align="left">
								<input type="text" class="datepick" style="height: 24px;width:180px" size="14" name="endApproval_date" id="endApproval_date" value="${endApproval_date}"/>
							</td>
						</tr>
						<tr>	
							<td align="right">受理局:</td>
							<td>延长</td>
							<td></td>
						</tr>
						<tr>	
							<td align="left">
								<select name="admissibleOrgCode" id="admissibleOrgCode" style="height: 30px;width:180px">
									<option></option>
									<c:if test="${not empty portOrgCode}"><c:forEach items="${portOrgCode}" var="row">
										<option value="${row.org_code}" <c:if test="${row.org_code==admissibleOrgCode}">selected="selected"</c:if>>${row.name}</option>
									</c:forEach></c:if>
								</select>
							</td>
							<td>
								<select name="prolong" id="prolong" style="height: 30px;width:180px">
									<option value="1" <c:if test="${prolong==1}">selected="selected"</c:if>>未延长</option>
									<option value="2" <c:if test="${prolong==2}">selected="selected"</c:if>>延长</option>
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
				分为&nbsp;<span class="number">${allPage}</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录
				<input type="hidden" id="msg" value="${msg}"/>
			</span>	
			</div>
			
			<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:9%">单位名称</td>
								<td style="width:5%">联系人</td>
								<td style="width:9%">联系电话</td>
								<td style="width:9%">经营类别</td>
								<td style="width:4%">申请经营范围</td>
								<td style="width:9%">申请类型</td>
								<td style="width:7%">原卫生许可证号</td>
								<td style="width:9%">审查组人员</td>
								<td style="width:7%">评审结果</td>
								<td style="width:10%">评审时间</td>
								<td style="width:7%">整改书</td>
								<td style="width:7%">申请书及其附件</td>
								<td>公示上传</td>
								<td style="width:1%">延长期理由</td>
								<td style="width:1%">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty alertList }"><c:forEach items="${alertList}" var="row">
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
								<td>${row.approval_users_name2}</td>
								<td>${row.review_result}</td>
								<td>${row.review_date}</td>
								<td><a href = "#" onclick="zgsShow('${row.license_dno}')">查看</a></td>
								<td><a href = "#" onclick="sqsWinShow('${row.id}','${row.license_dno}')">查看</a></td>
								<td>
								<form action="${ctx}/work/uploadFile" method="post"  enctype="multipart/form-data">
									<div><input  type="file" name="file" style="float: left;width: 70px;"/></div>
									<input type="hidden" name="main_id" value="${row.license_dno}" />
									<input type="submit" value="上传" />
								</form>
								<input type="button" onclick="look('${row.license_dno}')"  value="查看" />
								</td>
								<form action="${ctx}/work/insertProlong" method="post" onsubmit="return checkform(this)">
								<td>
									<c:if test="${row.prolong!=null}">
									${row.prolong}
 									</c:if> 
										<input type="hidden" name="id" value="${row.id}" />
										<input type="hidden" name="license_dno" value="${row.license_dno}" />
									<c:if test="${row.prolong==null}">
										<input type="text" name="prolong" value="${row.prolong}" />
									</c:if>
									<c:if test="${not empty row.prolong }">
										<input type="hidden" name="prolong" value="${row.prolong}" />
									</c:if>
								</td>
								<td><input type="submit" value="提交" /></td>
								</form>
							</tr>
						</c:forEach></c:if>
						<thead>
							<tr>
								<td>单位名称</td>
								<td>联系人</td>
								<td>联系电话</td>
								<td>经营类别</td>
								<td>申请经营范围</td>
								<td>申请类型</td>
								<td>原卫生许可证号</td>
								<td>审查组人员</td>
								<td>评审结果</td>
								<td>评审时间</td>
								<td>整改书</td>
								<td>申请书及其附件</td>
								<td>上传</td>
								<td>延长期理由</td>
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
		function zgsShow(no){
			window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+no);
		}
		
		function sqsWinShow(id,license_dno){
			window.open("<%=request.getContextPath()%>/xk/sqsWinShow?id="+id+"&license_dno="+license_dno);
		}
	</script>
</body>
</html>
