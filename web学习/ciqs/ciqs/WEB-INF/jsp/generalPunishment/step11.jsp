
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<table>
					<thead>
						<tr>
							<td style="display: none;"></td>
							<td><input type="checkbox" id="checkAll" style="width: 50px;" onchange="checkAllChange()"/></td>
							<td>立案号</td>
							<td>业务处/办事处</td>
						    <td>单位名称</td>
						    <td>姓名</td>
						    <td>初审时间</td>
						    <td>案件集中审理</td>
							<td>行政处罚告知书</td>
							<td>送达回证</td>
							<td>听证程序</td>
							<td>行政处罚案件办理审批表</td>
							<td>案件移送函</td>
							<td>审理建议</td>
							<!-- <td>审批状态</td> -->
						</tr>
					</thead>
					<c:if test="${not empty list }">
						<c:forEach items="${list}" var="row">
							<tr>
							  <td style="display: none;">${row.PRE_REPORT_NO}</td>
							  <td>
							  	<input type="checkbox" class="checkbox" name="check" id="${row.ID }|${row.PRE_REPORT_NO}"
							  		<c:if test="${'0' != row.STEP_11_STATUS}">disabled</c:if>/>
							  </td>
							  <td>
							  	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=11");'>
							  		${row.CASE_NO}
							  	</a>
							  </td>
							  <td></td>
							  <td>${row.COMP_NAME }</td>
						      <td>${row.PSN_NAME }</td>
						      <td><fmt:formatDate value="${row.STEP_10_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
						      <td>
						       	 <c:choose>
								      	<c:when test="${empty row.GP_FILE_AJJZSL }">
								      		
									    </c:when>
									    <c:otherwise>
									    	<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_AJJZSL_LOCATION }">查看</a>
									    </c:otherwise>
								    </c:choose>
						       </td>
							  <td>
						      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=11&page=gp_xzcf_gzs&subStep=0");'>
						      		<span class="data-btn margin-auto">查看</span>
						      	</a>
						      </td>
						      <td>
						       	 <c:choose>
								      	<c:when test="${empty row.GP_FILE_SDHZ }">
								      		<c:if test="${'0' == row.STEP_11_STATUS}">
										      	
										    </c:if>
									    </c:when>
									    <c:otherwise>
									    	<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_SDHZ_LOCATION }">查看</a>
									    </c:otherwise>
								    </c:choose>
						       </td>
						       <td>
						       	 <c:choose>
								      	<c:when test="${empty row.GP_FILE_TZCX }">
								      		<c:if test="${'0' == row.STEP_11_STATUS}">
										      	
										    </c:if>
									    </c:when>
									    <c:otherwise>
									    	<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_TZCX_LOCATION }">查看</a>
									    </c:otherwise>
								    </c:choose>
						       </td>
						      <td>
						      	<c:choose>
						      		<c:when test="${'0' != row.STEP_10_STATUS && '0' == row.STEP_11_STATUS }">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=11&page=gp_anjian_spb_input&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:otherwise>
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=11&page=gp_anjian_spb_input&subStep=0");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
						      		</c:otherwise>
						      	</c:choose>
						      </td>
						      <td>
						      	<c:choose>
						      		<c:when test="${'0' != row.STEP_10_STATUS && '0' == row.STEP_11_STATUS }">
								      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=11&page=gp_anjian_ysh_input&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
								    </c:when>
						      		<c:otherwise>
								      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=11&page=gp_anjian_ysh_input&subStep=0&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
						      		</c:otherwise>
						      	</c:choose>
						      </td>
							  <td>
<%-- 							  	<c:if test="${'13' == row.forward_step }">送达执行</c:if>
								<c:if test="${'14' == row.forward_step}">结案归档</c:if>
								<c:if test="${'15' == row.forward_step}">移送</c:if> --%>
								
							  	<c:choose>
							      	<c:when test="${(row.STEP_20_STATUS == '1' || row.STEP_20_STATUS == '13' || row.STEP_20_STATUS == '14' || row.STEP_20_STATUS == '15') && '0' == row.STEP_11_STATUS}">
										<select id="${row.ID}_forward" style="width:80px;">
											<option <c:if test="${empty row.STEP_20_STATUS }"> selected="selected" </c:if> value="">未选择</option>
											<option <c:if test="${row.STEP_20_STATUS == '13' }"> selected="selected" </c:if> value="13">送达执行</option>
											<option <c:if test="${row.STEP_20_STATUS == '14' }"> selected="selected" </c:if> value="14">结案归档</option>
											<option <c:if test="${row.STEP_20_STATUS == '15' }"> selected="selected" </c:if> value="15">移送</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_11_STATUS }">未审核</c:if>
										<c:if test="${'13' == row.STEP_11_STATUS }">送达执行</c:if>
										<c:if test="${'14' == row.STEP_11_STATUS}">结案归档</c:if>
										<c:if test="${'15' == row.STEP_11_STATUS}">移送</c:if>
									</c:otherwise>
								</c:choose>
							  </td>
<%-- 							  <td>
 							  	<c:if test="${'1' == row.step_10_status && '0' == row.step_11_status}">
									<select id="${row.ID}_status" name="status" style="width:80px;">
										<option selected="selected" value="0">未审核</option>
										<option value="1">通过</option>
										<option value="2">不通过</option>
									</select>
								</c:if>
								<c:if test="${'1' == row.step_11_status}">通过</c:if>
								<c:if test="${'2' == row.step_11_status}">不通过</c:if>
							  </td> --%>
							</tr>
						</c:forEach>
					</c:if>
					<tfoot>
						<jsp:include page="/common/pageNewUtil.jsp" flush="true"/>
                   	</tfoot>
				</table>
			<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm11();" />
			</div>

</html>
				
				