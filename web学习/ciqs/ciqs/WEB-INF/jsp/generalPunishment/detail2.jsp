<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>立案预审核</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
<script type="text/javascript">
	function submit() {
		if($("#id").val()){
			$("#form").attr("action", "/ciqs/generalPunishment/update");
		}else{
			$("#form").attr("action", "/ciqs/generalPunishment/add");
		}
		$("#form").submit();
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
				href="${cxt}/ciqs/generalPunishment/list?step=2">立案预审核</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="form">
			<div class="main">
				<form action="/ciqs/generalPunishment/add" method="post" id="form" enctype="multipart/form-data">
					<input type="hidden" id="id" name="id" value="${model.id}"/>
			    	<input type="hidden" id="pre_report_no" name="pre_report_no" value="${model.pre_report_no}"/>
			    	<input type="hidden" id="step" name="step" value="2"/>
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%">
									单位名称：
								</th>
								<td width="25%">
									${model.comp_name}
								</td>
								<th width="25%">
									姓名：
							  	</th>
								<td width="25%">
									${model.psn_name}
								</td>
							</tr>
							<tr>
								<th width="25%">
									性别：
							  	</th>
								<td class="right" width="25%">
									<c:if test="${empty model.gender or '0' == model.gender}">不详</c:if>
									<c:if test="${'1' == model.gender}">男</c:if>
									<c:if test="${'2' == model.gender}">女</c:if>
								</td>
								<th width="25%">
									出生年月：
							  	</th>
								<td class="right" width="25%">
									${model.birth}
								</td>
							</tr>
							<tr>
								<th width="25%">
									国籍：
							  	</th>
								<td class="right" width="25%">
									${model.nation}
								</td>
								<th width="25%">
									法定代表人：
							  	</th>
								<td width="25%">
									${model.corporate_psn}
								</td>
							</tr>
							<tr>
								<th width="25%">
									住址：
							  	</th>
								<td width="25%">
									${model.per_addr}
								</td>
								<th width="25%">
									单位地址：
							  	</th>
								<td width="25%">
									${model.addr}
								</td>
							</tr>
							<tr>
								<th width="25%">
									联系人：
							  	</th>
								<td width="25%">
									${model.contacts_name}
								</td>
								<th width="25%">
									联系电话：
							  	</th>
								<td width="25%">
									${model.tel}
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
									申报时间：
								</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_1_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<tr>
								<th width="25%">
									线索审核状态：
							  	</th>
								<td width="25%">
									<c:if test="${empty model.step_2_status}"></c:if>
									<c:if test="${'0' == model.step_2_status}">未审核</c:if>
									<c:if test="${'1' == model.step_2_status}">通过</c:if>
									<c:if test="${'2' == model.step_2_status}">不通过</c:if>
								</td>
								<th width="25%">
									线索审核时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_2_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<tr>
								<th width="25%">
									线索审核人：
							  	</th>
								<td width="25%">
									${model.step_2_psn}
								</td>
								<th width="25%">
									立案审批状态：
							  	</th>
								<td width="25%">
									<c:if test="${empty model.step_7_status}"></c:if>
									<c:if test="${'0' == model.step_7_status}">未审核</c:if>
									<c:if test="${'1' == model.step_7_status}">通过</c:if>
									<c:if test="${'2' == model.step_7_status}">不通过</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									立案审批时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_7_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
								<th width="25%">
									立案审批人：
							  	</th>
								<td width="25%">
									${model.step_7_psn}
								</td>
							</tr>
							<tr>
								<th width="25%">
									《检验检疫涉嫌案件申报单》
								</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=2&page=gp_shexiananjian_sbd&update=update&isSee=true");'>查看</a>
								</td>
								<th width="25%">
									附件：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_fj }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_fj.file_location }">${gp_file_fj.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
								</td>
							</tr>
							<tr>
								<th width="25%">
									《行政处罚案件反馈表》
								</th>
								<td width="25%">
									<c:if test="${ not empty D_GP_XZCF_AJFKB }">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=1&page=gp_xzcf_ajfkb&subStep=0");'>查看</a>
									</c:if>
								</td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input onclick="javascript:history.go(-1);" style="text-align: center;width: 50px;"
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
