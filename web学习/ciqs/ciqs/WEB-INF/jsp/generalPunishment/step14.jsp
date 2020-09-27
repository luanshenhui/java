
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<table>
					<thead>
						<tr>
							<td style="display: none;"></td>
							<td><input type="checkbox" id="checkAll" style="width: 50px;" onchange="checkAllChange()"/></td>
							<td>立案号</td>
						    <td>单位名称</td>
						    <td>姓名</td>
						    <td>结案归档时间</td>
						    <td>行政处罚结案报告</td>
							<td>行政处罚案件反馈表</td>
							<td>案件类型</td>
						</tr>
					</thead>
					<c:if test="${not empty list }">
						<c:forEach items="${list}" var="row">
							<tr>
							  <td style="display: none;">${row.PRE_REPORT_NO}</td>
							  <td>
							  	<input type="checkbox" class="checkbox" name="check" id="${row.ID }|${row.PRE_REPORT_NO}"
							  		<c:if test="${'0' != row.STEP_14_STATUS}">disabled</c:if>/>
							  </td>
							  <td>
  							  	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=14&main_id=${row.MAIN_ID}");'>${row.CASE_NO}</a>
							  </td>
							  <td>${row.COMP_NAME }</td>
						      <td>${row.PSN_NAME }</td>
						      <td><fmt:formatDate value="${row.STEP_14_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
						      <td>${row.isExtisJABG }
						      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=14&page=gp_xzcf_jabg&pre_report_no=${row.PRE_REPORT_NO }<c:if test="${row.STEP_14_STATUS != '0' }">&subStep=0</c:if>");'>
						      		<span class="data-btn margin-auto">
						      			<c:choose>
						      				<c:when test="${row.STEP_14_STATUS == '0' }">在线填写</c:when>
						      				<%-- <c:when test="${row.isExtisJABG == '0' }">在线填写</c:when> --%>
						      				<c:otherwise>查看</c:otherwise>
						      			</c:choose>
						      		</span>
						      	</a>
							  </td>
							  <td>
						      	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=14&page=gp_xzcf_ajfkb&pre_report_no=${row.PRE_REPORT_NO }<c:if test="${row.STEP_14_STATUS != '0' }">&subStep=0</c:if>");'>
						      		<span class="data-btn margin-auto">
										<c:choose>
											<c:when test="${row.STEP_14_STATUS == '0' }">在线填写</c:when>
						      				<%-- <c:when test="${row.isExtisAJFKB == '0' }">在线填写</c:when> --%>
						      				<c:otherwise>查看</c:otherwise>
						      			</c:choose>
									</span>
						      	</a>
						      </td>
						      <td style="max-width: 200px;">
						      <c:choose>
							      	<c:when test="${'0' == row.STEP_14_STATUS}">
										<select id="${row.ID}_forward" style="width:80px;">
											<option value="">未选择</option>
											<c:forEach items="${esList}" var="v">
												<c:if test="${v.code >= 21 }"><option value="${v.code }">${v.name }</option></c:if>
											</c:forEach>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_14_STATUS }">未审核</c:if>
										<c:forEach items="${esList}" var="v">
											<c:if test="${v.code == row.STEP_14_STATUS }">${v.name }</c:if>
										</c:forEach>
									</c:otherwise>
								</c:choose>
						      </td>
						      <!-- 
							  <td>
						      	<a href='javascript:fk("${row.ID}");'>
						      		<span class="data-btn margin-auto">反馈</span>
						      	</a>
						      </td>
						       -->
							</tr>
						</c:forEach>
					</c:if>
					<tfoot>
						<jsp:include page="/common/pageNewUtil.jsp" flush="true"/>
                   	</tfoot>
				</table>
			<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm14();" />
			</div>

</html>
				
				