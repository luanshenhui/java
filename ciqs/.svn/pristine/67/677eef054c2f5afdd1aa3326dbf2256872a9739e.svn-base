<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>一般处罚</title>
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
			<c:if test="${step == '1' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=1">线索申报</a>
			</c:if>
			<c:if test="${step == '2' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=2">线索预审批</a>
			</c:if>
			<c:if test="${step == '3' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=3">稽查受理</a>
			</c:if>
			<c:if test="${step == '5' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=5">法制受理</a>
			</c:if>
			<c:if test="${step == '7' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=7">立案审批</a>
			</c:if>
			<c:if test="${step == '9' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=9">调查取证/初审</a>
			</c:if>
			<c:if test="${step == '18' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=18">调查取证/复审</a>
			</c:if>
			<c:if test="${step == '19' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=19">调查取证/终审</a>
			</c:if>
			<c:if test="${step == '10' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=10">审理决定/初审</a>
			</c:if>
			<c:if test="${step == '11' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=11">审理决定/复审</a>
			</c:if>
			<c:if test="${step == '12' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=12">审理决定/终审</a>
			</c:if>
			<c:if test="${step == '13' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=13">送达执行</a>
			</c:if>
			<c:if test="${step == '14' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=14">结案归档</a>
			</c:if>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
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
								<th width="100%" colspan="4" style="text-align: left">线索信息</th>
							</tr>
							<tr>
<%-- 				      			<th width="25%">
									立案号：
								</th>
								<td width="25%">
									${model.case_no}
								</td> --%>
								<th width="25%">
									单位名称：
							  	</th>
								<td width="25%">
									${model.comp_name}
								</td>
								<th width="25%">
									姓名：
							  	</th>
								<td class="right" width="25%">
									${model.psn_name}
				       			</td>
							</tr>
							<tr>
								<th width="25%">
									年龄：
							  	</th>
								<td class="right" width="25%">
									${model.age}
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
									单位地址：
							  	</th>
								<td width="25%">
									${model.addr}
								</td>
								<th width="25%">
									住址：
							  	</th>
								<td width="25%">
									${model.per_addr}
								</td>
							</tr>
							<tr>
								<th width="25%">
									法定代表人：
							  	</th>
								<td width="25%">
									${model.corporate_psn}
								</td>
							</tr>
							<tr>
								<th width="25%">
									联系电话：
							  	</th>
								<td width="25%">
									${model.tel}
								</td>
								<th width="25%">
									联系人：
							  	</th>
								<td width="25%">
									${model.contacts_name}
								</td>
							</tr>
							<tr>
								<th width="25%">
									检验检疫涉嫌案件申报单
								</th>
								<td width="25%">
									<c:if test="${not empty GP_AJ_SBD }">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=3&page=gp_shexiananjian_sbd_input&subStep=0");'>检验检疫涉嫌案件申报单</a>
									</c:if>
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
									申报时间：
								</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_1_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<tr>
								<th width="100%" colspan="4" style="text-align: left">线索预审核</th>
							</tr>
							<tr>
								<th width="25%">
									线索预审核状态：
							  	</th>
								<td width="25%">
									<c:choose>
										<c:when test="${model.step_2_status == '0'}">未审核</c:when>
										<c:when test="${model.step_2_status == '1'}">通过</c:when>
										<c:when test="${model.step_2_status == '2'}">不通过</c:when>
										<c:otherwise>
											未审核
										</c:otherwise>
									</c:choose>
								</td>
								<th width="25%">
									线索预审核时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_2_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<tr>
								<th width="25%">
									线索预审核人：
							  	</th>
								<td width="25%">
									${model.step_2_psn}
								</td>
							</tr>
							
<%-- 							<tr>
								<th width="100%" colspan="4" style="text-align: left">稽查审核</th>
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
									<c:if test="${'1' == model.step_4_status}">建议立案</c:if>
									<c:if test="${'2' == model.step_4_status}">建议不立案</c:if>
									<c:if test="${'3' == model.step_4_status}">移送</c:if>
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
							</tr> --%>
							
							
							<tr>
								<th width="100%" colspan="4" style="text-align: left">立案申报</th>
							</tr>							
							<tr>
								<th width="25%">
									立案审批结果：
							  	</th>
								<td width="25%">
									<c:if test="${empty model.step_7_status}"></c:if>
									<c:if test="${'0' == model.step_7_status}">未审核</c:if>
									<c:if test="${'1' == model.step_7_status}">立案</c:if>
									<c:if test="${'2' == model.step_7_status}">不立案</c:if>
									<c:if test="${'15' == model.step_7_status}">移送</c:if>
								</td>
								<th width="25%">
									立案审批时间：
							  	</th>
								<td width="25%">
									<fmt:formatDate value="${model.step_7_date}" type="both" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<%-- <tr>
								<th width="25%">
									立案审批人：
							  	</th>
								<td width="25%">
									${model.step_7_psn}
								</td>

							</tr> --%>
							<tr>
<%-- 								<th width="25%">
									行政处罚案件办理审批表：
							  	</th>
								<td width="25%">
									<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=3&page=gp_anjian_spb_input&subStep=0");'>
							      		<span class="data-btn margin-auto">行政处罚案件办理审批表</span>
							      	</a>
								</td> --%>
								<th width="25%">
									立案审批表：
							  	</th>
								<td width="25%">
									<c:if test="${not empty D_GP_L_S_1}">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=3&page=gp_lian_spb_input&subStep=0");'>
								      		<span class="data-btn margin-auto">立案审批表</span>
								      	</a>
							      	</c:if>
								</td>
								<th width="25%">
									案件移送函：
							  	</th>
								<td width="25%">
									<c:if test="${not empty D_GP_A_Y_1 && empty model.step_10_status}">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=3&page=gp_anjian_ysh_input&subStep=0");'>
								      		<span class="data-btn margin-auto">案件移送函</span>
								      	</a>
							      	</c:if>
								</td>
							</tr>
							<tr>
								<th width="100%" colspan="4" style="text-align: left">调查取证</th>
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
									调查报告：
							  	</th>
								<td width="25%">
									<c:if test="${not empty D_GP_DCBG }">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=3&page=gp_diaochabaogao&subStep=0");'>
								      		<span class="data-btn margin-auto">调查报告</span>
								      	</a>
									</c:if>
								</td>
								<th width="25%">行政处罚案件立案审批表：</th>
								<td width="25%">
									<c:if test="${not empty D_GP_DCBG_XZCFAJ_SPB }">
								    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_anjian_spb_input&docType=dcbg&subStep=0");'>
								      		<span class="data-btn margin-auto">点击查看</span>
								      	</a>
								     </c:if>
								</td>
							</tr>
							<tr>
								<th width="25%">
									延期办理审批表：
							  	</th>
								<td width="25%">
									<c:if test="${not empty D_GP_DCBG_Y_S_1}">
								    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_anjian_spb_input&docType=dcbg_yq&subStep=0&doc_id=${model.step_9_doc_id }");'>
								      		<span class="data-btn margin-auto">点击查看</span>
								      	</a>
								     </c:if>
								</td>
							</tr>	
							<c:if test="${not empty step9s }">
								<tr>
									<th rowspan="${fn:length(step9s)+1}">历史延期办理审批表：</th>
									<th style="text-align: center;">延期办理审批表</th>
									<th style="text-align: center;">创建人</th>
									<th style="text-align: center;">创建时间</th>
								</tr>
										<c:forEach items="${step9s}" var="row">
										<tr>
												<td style="text-align: center;">
											    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_anjian_spb_input&docType=dcbg_yq&subStep=0&doc_id=${row.doc_id }");'>
											      		<span class="data-btn margin-auto">点击查看</span>
											      	</a>
												</td>
												<td style="text-align: center;">
													${row.audit_psn }
												</td>
												<td style="text-align: center;">
													<fmt:formatDate value="${row.audit_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
												</td>
											</tr>
										</c:forEach>
							</c:if>
							<tr>
								<th width="100%" colspan="4" style="text-align: left">审理决定</th>
							</tr>
							<tr>
								<th width="25%">
									案件集中审理附件：
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
							</tr>
							<tr>
								<th width="25%">行政处罚告知书</th>
								<td width="25%">
							    	<c:if test="${not empty D_GP_XZCF_GZS }">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_xzcf_gzs&subStep=0");'>
								      		<span  class="data-btn margin-auto">点击查看</span>
								      	</a>
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
								<th width="25%">行政处罚案件办理审批表：</th>
								<td width="25%">
							    	<c:if test="${not empty D_GP_XZCFAJ_SPB }">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_anjian_spb_input&subStep=0");'>
								      		<span  class="data-btn margin-auto">点击查看</span>
								      	</a>
							    	</c:if>
								</td>
								<th width="25%">案件移送函</th>
								<td width="25%">
							    	<c:if test="${not empty D_GP_A_Y_1 }">
							    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_anjian_ysh_input&subStep=0");'>
							      		<span class="data-btn margin-auto">点击查看</span>
							      	</a>
							      	</c:if>
								</td>
							</tr>
							<tr>
								<th width="100%" colspan="4" style="text-align: left">送达执行</th>
							</tr>
							<tr>
								<th width="25%">
									送达回证：
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
								<th width="25%">
									缴款收据：
							  	</th>
							  	<td width="25%">
							    	<c:if test="${not empty gp_file_jfsj_sdzx}">
											<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_jfsj_sdzx.file_location }">查看</a>
							    	</c:if>
  								    <c:if test="${'0' == model.step_13_status }">
										<input type="file" name="gp_file_jfsj_sdzx"/>
									</c:if>
							  	</td>
							</tr>
							<tr>
								<th width="25%">
									送达执行其他附件：
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
								<th width="25%">
									行政处罚决定书：
							  	</th>
							  	<td width="25%">
							    	<c:if test="${not empty D_GP_XZCF_JDS }">
							    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=13&page=gp_xzcf_jds&subStep=0");'>
							      		<span class="data-btn margin-auto">点击查看</span>
							      	</a>
							      	</c:if>
							  	</td>
							</tr>
							<tr>
								<th width="100%" colspan="4" style="text-align: left">结案归档</th>
							</tr>
							<tr>
								<th width="25%">
								行政处罚结案报告
								</th>
								<td width="25%">
							    	<c:if test="${not empty D_GP_XZCF_JABG }">
							    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_xzcf_jabg&subStep=0");'>
							      		<span class="data-btn margin-auto">点击查看</span>
							      	</a>
							      	</c:if>
								</td>
								<th width="25%">
								行政处罚案件反馈表
								</th>
								<td width="25%">
							    	<c:if test="${not empty D_GP_XZCF_AJFKB }">
							    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=13&page=gp_xzcf_ajfkb&subStep=0");'>
							      		<span class="data-btn margin-auto">点击查看</span>
							      	</a>
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
