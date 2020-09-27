
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<table>
					<thead>
						<tr>
							<td style="display: none;"></td>
							<td style="display: none;">预申报号</td>
							<td><input type="checkbox" id="checkAll"
								style="width: 50px;" onchange="checkAllChange()" /></td>
							<td>立案号</td>
							<td>单位名称</td>
							<!-- <td>姓名</td> -->
							<td>立案审批时间</td>
							<td>调查询问</td>
							<td>现场勘验</td>
							<td>查封扣押</td>
							<td>其他</td>
							<td>调查报告</td>
							<td>行政处罚案件办理审批表</td>
							<td>延期办理审批表</td>
							<!--
							<td>调查取证状态</td>
							<td>详细</td>
							 -->
						</tr>
					</thead>
					<c:if test="${not empty list }">
						<c:forEach items="${list}" var="row">
							<tr>
								<td style="display: none;">${row.ID}</td>
								<td style="display: none;">${row.PRE_REPORT_NO}</td>
								<td><input type="checkbox" class="checkbox" name="check"
									id="${row.ID }|${row.PRE_REPORT_NO}"
									<c:if test="${'1' == row.STEP_18_STATUS || '2' == row.STEP_18_STATUS}">disabled</c:if> />
								</td>
								<td><a
									href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=18");'>
										${row.CASE_NO} </a></td>
								<td>${row.COMP_NAME }</td>
								<%-- <td>${row.PSN_NAME }</td> --%>
								<td><fmt:formatDate value="${row.STEP_7_DATE }" type="both"
										pattern="yyyy-MM-dd" /></td>
								<!--调查询问 -->
								<td>
<%-- 								<c:choose>
										<c:when test="${'0' == row.STEP_18_STATUS }">
 												<a
													href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=18");'>
													上传 </a>
										</c:when>
										<c:otherwise> --%>
											<c:if test="${not empty row.GP_FILE_DCXW }">
											<a style="cursor: pointer;"
												href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_DCXW_LOCATION }">查看</a>
											</c:if>
									</td>
<!-- 								现场勘验 -->
								<td>
<%-- 								<c:choose>
										<c:when test="${'0' == row.STEP_18_STATUS}">
												 <a
													href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=18");'>
													上传 </a> 
										</c:when>
										<c:otherwise> --%>
											<c:if test="${not empty row.GP_FILE_XCKY }">
											<a style="cursor: pointer;"
												href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_XCKY_LOCATION }">查看</a>
											</c:if>

									</td>
<!-- 								查封扣押 -->
								<td>
<%-- 								<c:choose>
										<c:when test="${'0' ==  row.STEP_18_STATUS }">
												 <a
													href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=18");'>
													上传 </a>
										</c:when>
										<c:otherwise> --%>
										<c:if test="${not empty row.GP_FILE_CFKY}">
											<a style="cursor: pointer;"
												href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_CFKY_LOCATION }">查看</a>
											</c:if>

									</td>
<!-- 								其他 -->
								<td>
<%-- 								<c:choose>
										<c:when test="${'0' == row.STEP_18_STATUS }">
												 <a
													href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=18");'>
													上传 </a>
										</c:when>
										<c:otherwise> --%>
											<c:if test="${not empty row.GP_FILE_QT_DCQZ }">
											<a style="cursor: pointer;"
												href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_QT_DCQZ_LOCATION }">查看</a>
											</c:if>

									</td>
<!-- 								调查报告 -->
								<td>
<%-- 								<c:choose>
										<c:when test="${'0' == row.STEP_9_STATUS}">
											<a
												href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=8&page=gp_diaochabaogao");'>
												<span class="data-btn margin-auto">在线填写</span>
											</a>
										</c:when>
										<c:otherwise> --%>
											<c:if test="${row.D_GP_DCBG != '0' }">
											<a
												href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=18&page=gp_diaochabaogao&subStep=0&pre_report_no=${row.PRE_REPORT_NO }");'>
												<span class="data-btn margin-auto">查看</span>
											</a>
											</c:if>

									</td>
						       <td>
     						       <c:if test="${row.STEP_18_STATUS == '0' && row.D_GP_DCBG_XZCFAJ_SPB != '0' }">
								      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=18&page=gp_anjian_spb_input&docType=dcbg&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						       		</c:if>
						       		<c:if test="${row.D_GP_DCBG_XZCFAJ_SPB != '0' && row.STEP_18_STATUS != '0' }">
								      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=18&page=gp_anjian_spb_input&docType=dcbg&subStep=0&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
						       		</c:if>
						       </td>
						       <td>
						       		<c:if test="${row.STEP_18_STATUS == '0' && row.D_GP_DCBG_Y_S_1 != '0' }">
								      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=18&page=gp_anjian_spb_input&subStep=18&docType=dcbg_yq&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
							      	</c:if>
						       		<c:if test="${row.STEP_18_STATUS != '0' && row.D_GP_DCBG_Y_S_1 != '0' }">
								      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=18&page=gp_anjian_spb_input&subStep=0&docType=dcbg_yq&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
							      	</c:if>
							   </td>
							</tr>
						</c:forEach>
					</c:if>
					<tfoot>
						<jsp:include page="/common/pageNewUtil.jsp" flush="true" />
					</tfoot>
				</table>
			<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm18();" />
			</div>
</html>
				
				