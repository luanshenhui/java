<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>稽查受理</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
<script type="text/javascript">
	function submitForm() {
		if(confirm("确认提交？")){
			if($("#id").val()){
				$("#form").attr("action", "/ciqs/generalPunishment/update?random="+Math.random());
			}else{
				$("#form").attr("action", "/ciqs/generalPunishment/add?random="+Math.random());
			}
			$("#form").submit();
		}
	}
	
	function openNewPage1(targetUrl){
		window.open(targetUrl, "附件查看", "height=400, width=500, top=200, left=250, toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no");
	}
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政处罚 /一般处罚</span><div>");
		$(".user-info").css("color","white");
	});
</script>

</head>
<body>
<%@ include file="/common/headMenu_Pn.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">一般处罚</a> &gt; <a
				href="${cxt}/ciqs/generalPunishment/list?step=3">稽查受理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">线索申报</div>
		<div class="form">
			<div class="main">
				<form method="post" id="form" enctype="multipart/form-data">
					<input type="hidden" id="id" name="id" value="${model.id}"/>
			    	<input type="hidden" id="pre_report_no" name="pre_report_no" value="${model.pre_report_no}"/>
			    	<input type="hidden" id="step" name="step" value="3"/>
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%">
									单位名称：
								</th>
								<td width="25%">
									<input type="text" id="comp_name" name="comp_name" size="14" value="${model.comp_name}" class="text"/>
									<p></p>
								</td>
								<th width="25%">
									姓名：
							  	</th>
								<td width="25%">
									<input type="text" id="psn_name" name="psn_name" value="${model.psn_name}" size="14" class="text"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">
									性别：
							  	</th>
								<td class="right" width="25%">
									<select id="gender" name="gender" class="select">
										<c:if test="${empty model.gender}">
											<option selected="selected" value="0">不详</option>
										</c:if>
										<c:if test="${not empty model.gender}">
											<option value="0">不详</option>
										</c:if>
										<c:if test="${'1' == model.gender}">
											<option selected="selected" value="1">男</option>
										</c:if>
										<c:if test="${'1' != model.gender}">
											<option value="1">男</option>
										</c:if>
										<c:if test="${'2' == model.gender}">
											<option selected="selected" value="2">女</option>
										</c:if>
										<c:if test="${'2' != model.gender}">
											<option value="2">女</option>
										</c:if>
									</select>
				       			</td>
								<th width="25%">
									出生年月：
							  	</th>
								<td class="right" width="25%">
									<input name="birth" type="text" class="text datepick" id="birth" value="${model.birth}"/>
								</td>
							</tr>
							<tr>
								<th width="25%">
									国籍：
							  	</th>
								<td class="right" width="25%">
									<input type="text" name="nation" id="nation" size="14" value="${model.nation}" class="text" />
								</td>
								<th width="25%">
									法定代表人：
							  	</th>
								<td class="right" width="25%">
									<input type="text" name="corporate_psn" id="corporate_psn"size="14" value="${model.corporate_psn}" class="text" />
								</td>
							</tr>
							<tr>
								<th width="25%">
									住址或地址：
							  	</th>
								<td width="25%">
									<input type="text" name="addr" id="addr"size="14" value="${model.addr}" class="text" />
								</td>
								<th width="25%">
									电话：
							  	</th>
								<td width="25%">
									<input type="text" name="tel" id="tel"size="14" value="${model.tel}" class="text" />
								</td>
							</tr>
							<tr>
								<th width="25%">
									直属局：
							  	</th>
								<td width="25%">
									<select id="belong_org" class="select" name="belong_org">
										<option selected="selected" value="0">辽宁局</option>
									</select>
								</td>
								<th width="25%">
									《检验检疫涉嫌案件申报单》
								</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=1&page=gp_shexiananjian_sbd&update=update");'>在线填写</a>
								</td>
							</tr>
							<tr>
								<th width="25%">
									附件：
							  	</th>
								<td width="25%">
									<c:if test="${not empty filePath }">
										<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${filePath }">${fileName }</a><br/>
									</c:if>
									<input type="file" name="gp_file_fj"/>
								</td>
								<th width="25%"></th>
								<td width="25%"></td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input class="button" value="提交" id="subb"
									type="button" onclick="javascript:submitForm();"/> 
									<input onclick="javascript:history.go(-1);"
									class="button" value="返回" type="button" />
								</td>
							</tr>
						</tfoot>
					</table>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
