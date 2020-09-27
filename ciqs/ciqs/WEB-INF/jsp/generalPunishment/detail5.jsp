<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>法制受理</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
<script type="text/javascript">
	function submitForm() {
		if(confirm("确认提交？")){
			$("#form").submit();
		}
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
				href="${cxt}/ciqs/generalPunishment/list?step=5">法制受理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">详情</div>
		<div class="form">
			<div class="main">
				<form action="/ciqs/generalPunishment/update" method="post" id="form" enctype="multipart/form-data">
					<input type="hidden" id="id" name="id" value="${model.id}"/>
					<input type="hidden" id="main_id" name="main_id" value="${model.main_id}"/>
			    	<input type="hidden" id="pre_report_no" name="pre_report_no" value="${model.pre_report_no}"/>
			    	<input type="hidden" id="step" name="step" value="${step }"/>
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%">
									立案号：
								</th>
								<td width="25%">
									${model.case_no}
								</td>
								<th width="25%">
									单位名称：
							  	</th>
								<td width="25%">
									${model.comp_name}
								</td>
							</tr>
							<tr>
								<th width="25%">
									姓名：
							  	</th>
								<td class="right" width="25%">
									${model.psn_name}
				       			</td>
				       			<th width="25%">
									性别：
							  	</th>
								<td class="right" width="25%">
									<c:if test="${empty model.gender or '0' == model.gender}">不详</c:if>
									<c:if test="${'1' == model.gender}">男</c:if>
									<c:if test="${'2' == model.gender}">女</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									出生年月：
							  	</th>
								<td class="right" width="25%">
									${model.birth}
								</td>
								<th width="25%">
									国籍：
							  	</th>
								<td class="right" width="25%">
									${model.nation}
								</td>
							</tr>
							<tr>
								<th width="25%">
									法定代表人：
							  	</th>
								<td width="25%">
									${model.corporate_psn}
								</td>
								<th width="25%">
									住址或地址：
							  	</th>
								<td width="25%">
									${model.addr}
								</td>
							</tr>
							<tr>
								<th width="25%">
									电话：
							  	</th>
								<td width="25%">
									${model.tel}
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
									线索预审核时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_2_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
								<th width="25%">
									线索预审核人：
							  	</th>
								<td width="25%">
									${model.step_2_psn}
								</td>
							</tr>
							<tr>
								<th width="25%">
									业务处/办事处：
							  	</th>
								<td width="25%">
									${model.step_1_org}
								</td>
								<th width="25%">
									稽查审核状态：
							  	</th>
								<td width="25%">
									<c:if test="${empty model.step_4_status}"></c:if>
									<c:if test="${'0' == model.step_4_status}">未审核</c:if>
									<c:if test="${'1' == model.step_4_status}">通过</c:if>
									<c:if test="${'2' == model.step_4_status}">不通过</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									稽查审核时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_4_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
								<th width="25%">
									稽查审核人：
							  	</th>
								<td width="25%">
									${model.step_4_psn}
								</td>
							</tr>
							<tr>
								<th width="25%">
									立案审批状态：
							  	</th>
								<td width="25%">
									<c:if test="${empty model.step_7_status}"></c:if>
									<c:if test="${'0' == model.step_7_status}">未审核</c:if>
									<c:if test="${'1' == model.step_7_status}">通过</c:if>
									<c:if test="${'2' == model.step_7_status}">不通过</c:if>
								</td>
								<th width="25%">
									立案审批时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_7_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<tr>
								<th width="25%">
									立案审批人：
							  	</th>
								<td width="25%">
									${model.step_7_psn}
								</td>
								<th width="25%">
									立案审批表：
							  	</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=5&page=gp_lian_spb_input&subStep=0");'>
							      		<span class="data-btn margin-auto">立案审批表</span>
							      	</a>
								</td>
							</tr>
							<tr>
								<th width="25%">
									检验检疫涉嫌案件申报单
								</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=5&page=gp_shexiananjian_sbd_input&subStep=0");'>检验检疫涉嫌案件申报单</a>
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
									行政处罚案件办理审批表：
							  	</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=5&page=gp_anjian_spb_input&subStep=0");'>
							      		<span class="data-btn margin-auto">行政处罚案件办理审批表</span>
							      	</a>
								</td>
								<th width="25%">
									案件移送函：
							  	</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=5&page=gp_anjian_ysh_input&subStep=0");'>
							      		<span class="data-btn margin-auto">案件移送函</span>
							      	</a>
								</td>
							</tr>
							<tr>
								<th width="25%">
									调查报告：
							  	</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=5&page=gp_diaochabaogao&subStep=0");'>
							      		<span class="data-btn margin-auto">调查报告</span>
							      	</a>
								</td>
							</tr>
							<tr>
								<th width="25%">
									调查询问附件：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_dcxw }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_dcxw.file_location }">${gp_file_dcxw.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_9_status }">
										<input type="file" name="gp_file_dcxw"/>
									</c:if>
								</td>
								<th width="25%">
									现场勘验附件：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_xcky }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_xcky.file_location }">${gp_file_xcky.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_9_status }">
										<input type="file" name="gp_file_xcky"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									查封扣押附件：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_cfky }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_cfky.file_location }">${gp_file_cfky.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_9_status }">
										<input type="file" name="gp_file_cfky"/>
									</c:if>
								</td>
								<th width="25%">
									其他附件：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_qt }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_qt.file_location }">${gp_file_qt.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_9_status }">
										<input type="file" name="gp_file_qt"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									案件集中审理：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_ajjzsl }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_ajjzsl.file_location }">${gp_file_ajjzsl.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_10_status }">
										<input type="file" name="gp_file_ajjzsl"/>
									</c:if>
								</td>
								<th width="25%">
									送达回证：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_sdhz }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_sdhz.file_location }">${gp_file_sdhz.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_10_status }">
										<input type="file" name="gp_file_sdhz"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									听证程序：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_tzcx }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_tzcx.file_location }">${gp_file_tzcx.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_10_status }">
										<input type="file" name="gp_file_tzcx"/>
									</c:if>
								</td>
								<th width="25%">
									送达回证（送达执行）：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_sdhz_sdzx }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_sdhz_sdzx.file_location }">${gp_file_sdhz_sdzx.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_13_status }">
										<input type="file" name="gp_file_sdhz_sdzx"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									其他（送达执行）：
							  	</th>
								<td width="25%">
									<c:choose>
							      		<c:when test="${not empty gp_file_qt_sdzx }">
							      			<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_qt_sdzx.file_location }">${gp_file_qt_sdzx.file_name }</a><br/>
							      		</c:when>
							      		<c:otherwise>暂无</c:otherwise>
							      	</c:choose>
							      	<c:if test="${'0' == model.step_13_status }">
										<input type="file" name="gp_file_qt_sdzx"/>
									</c:if>
								</td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input onclick="javascript:submitForm();" style="text-align: center;width: 50px;"
									class="button" value="提交" type="button" />
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
