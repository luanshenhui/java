
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<table>
					<thead>
						<tr>
							<td style="width:50px;"><input type="checkbox" id="checkAll" onchange="checkAllChange()"/></td>
							<td>预申报号</td>
						    <td>单位名称</td>
						    <td>姓名</td>
						    <td>线索预审批时间</td>
						    <td>业务处/办事处</td>
						    <td>稽查受理一</td>
						    <td>稽查受理二</td>
						    <td>稽查审核</td>
							<td>立案审批状态</td>
						    <td>立案审批表</td>
						</tr>
					</thead>
					<c:if test="${not empty list }">
						<c:forEach items="${list}" var="row">
							<tr>
							  <td>
							  	<input type="checkbox" class="checkbox" name="check"
								  	<c:if test="${!(('0' == row.STEP_3_STATUS) || ('0' != row.STEP_3_STATUS && '0' == row.STEP_16_STATUS) || ('0' != row.STEP_16_STATUS && '0' == row.STEP_4_STATUS))}">
										disabled								  	
								  	</c:if>
							  	/>
							  </td>
							  <td>
							  	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=3");'>${row.PRE_REPORT_NO}</a>
							  </td>
							  <td>${row.COMP_NAME }</td>
						      <td>${row.PSN_NAME }</td>
						      <td><fmt:formatDate value="${row.STEP_2_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
						      <td>${row.DECLARE_ORG_NAME }</td>
						      <td>
						      	<c:choose>
							      	<c:when test="${row.STEP_2_STATUS == '1' && '0' == row.STEP_3_STATUS}">
										<select id="${row.ID}|${row.PRE_REPORT_NO}" name="status3" style="width:80px;">
											<option selected="selected" value="0">未审核</option>
											<option value="1">建议立案</option>
											<option value="2">建议不立案</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_3_STATUS }">未审核</c:if>
										<c:if test="${'1' == row.STEP_3_STATUS}">建议立案</c:if>
										<c:if test="${'2' == row.STEP_3_STATUS}">建议不立案</c:if>
									</c:otherwise>
								</c:choose>
						      </td>
						      <td>
						      	<c:choose>
							      	<c:when test="${'0' == row.STEP_16_STATUS}">
										<select id="${row.ID}|${row.PRE_REPORT_NO}" name="status16" style="width:80px;">
											<option selected="selected" value="0">未审核</option>
											<option value="1">建议立案</option>
											<option value="2">建议不立案</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_16_STATUS }">未审核</c:if>
										<c:if test="${'1' == row.STEP_16_STATUS}">建议立案</c:if>
										<c:if test="${'2' == row.STEP_16_STATUS}">建议不立案</c:if>
									</c:otherwise>
								</c:choose>
						      </td>
						      <td>
						      	<c:choose>
						      		<c:when test="${'0' == row.STEP_4_STATUS}">
										<select id="${row.ID}|${row.PRE_REPORT_NO}" name="status4" style="width:80px;">
											<option selected="selected" value="0">未审核</option>
											<option value="1">建议立案</option>
											<option value="2">建议不立案</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_4_STATUS }">未审核</c:if>
										<c:if test="${'1' == row.STEP_4_STATUS}">建议立案</c:if>
										<c:if test="${'2' == row.STEP_4_STATUS}">建议不立案</c:if>
									</c:otherwise>
								</c:choose>
						      </td>
						      <td>
						      	<c:if test="${empty row.STEP_7_STATUS}">未审核</c:if>
								<c:if test="${'0' == row.STEP_7_STATUS}">未审核</c:if> 
								<c:if test="${'1' == row.STEP_7_STATUS}">立案</c:if> 
								<c:if test="${'2' == row.STEP_7_STATUS}">不立案</c:if>
								<c:if test="${'15' == row.STEP_7_STATUS}">移送</c:if>
							  </td>
						      <td>
						      	<c:choose>
						      		<c:when test="${'1' == row.STEP_2_STATUS && '0' == row.STEP_3_STATUS }">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=3&page=gp_lian_spb_input&subStep=3");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:when test="${'0' != row.STEP_3_STATUS && '0' == row.STEP_16_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=16&page=gp_lian_spb_input&subStep=16");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:when test="${'0' != row.STEP_16_STATUS && '0' == row.STEP_4_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=16&page=gp_lian_spb_input&subStep=16");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:otherwise>
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=3&page=gp_lian_spb_input&subStep=0");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
						      		</c:otherwise>
						      	</c:choose>
						      </td>
						      <!-- 
							  <td>
							  	<c:if test="${'0' eq row.step_4_status or '2' eq row.step_4_status }">
							      <a href='javascript:jumpPage("/ciqs/generalPunishment/toUpdate?id=${row.ID}&step=3");'>
							      	<span class="data-btn margin-auto">修改</span>
							      </a>
							      <a href='javascript:jumpPage("/ciqs/generalPunishment/delete?pre_report_no=${row.PRE_REPORT_NO}&step=3");'
							      	onclick="javascript:return confirm('是否确定将此条数据删除？');">
							      	<span class="data-btn margin-auto">删除</span>
							      </a>
							    </c:if>
							      <a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=3");'>
							      	<span class="data-btn margin-auto">详细</span>
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
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm3();" />
			</div>
</html>
				
				