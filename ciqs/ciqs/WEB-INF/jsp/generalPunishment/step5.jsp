
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<table>
					<thead>
						<tr>
							<td><input type="checkbox" id="checkAll" style="width: 50px;" onchange="checkAllChange()"/></td>
							<td>预申报号</td>
						    <td>单位名称</td>
						    <td>姓名</td>
						    <td>稽查审批时间</td>
						    <td>业务处/办事处</td>
						    <td>法制受理一</td>
						    <td>法制受理二</td>
						    <td>法制审批</td>
							<td>立案审批状态</td>
							<td>立案审批表</td>
							<td>案件移送函</td>
							<!-- 
							<td>操作</td>
							 -->
						</tr>
					</thead>
					<c:if test="${not empty list }">
						<c:forEach items="${list}" var="row">
							<tr>
							  <td>
							  	<input type="checkbox" class="checkbox" name="check"
								  	<c:if test="${!(('0' != row.STEP_4_STATUS && '0' == row.STEP_5_STATUS) || ('0' != row.STEP_5_STATUS && '0' == row.STEP_17_STATUS) || ('0' != row.STEP_17_STATUS && '0' == row.STEP_6_STATUS))}">
										disabled								  	
								  	</c:if>
							  	/>
							  </td>
							  <td>
							  	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=5");'>${row.PRE_REPORT_NO}</a>
							 </td>
							  <td>${row.COMP_NAME }</td>
						      <td>${row.PSN_NAME }</td>
						      <td><fmt:formatDate value="${row.STEP_4_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
						      <td>${row.DECLARE_ORG_NAME }</td>
						      <td>
						      	<c:choose>
							      	<c:when test="${'0' != row.STEP_4_STATUS && '0' == row.STEP_5_STATUS}">
										<select id="${row.ID}|${row.PRE_REPORT_NO}" name="status5" style="width:80px;">
											<option selected="selected" value="0">未审核</option>
											<option value="1">建议立案</option>
											<option value="2">建议不立案</option>
											<option value="15">移送</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_5_STATUS }">未审核</c:if>
										<c:if test="${'1' == row.STEP_5_STATUS}">建议立案</c:if>
										<c:if test="${'2' == row.STEP_5_STATUS}">建议不立案</c:if>
										<c:if test="${'15' == row.STEP_5_STATUS}">移送</c:if>
									</c:otherwise>
								</c:choose>
						      </td>
    						  <td>
						      	<c:choose>
							      	<c:when test="${'0' != row.STEP_5_STATUS && '0' == row.STEP_17_STATUS}">
										<select id="${row.ID}|${row.PRE_REPORT_NO}" name="status17" style="width:80px;">
											<option selected="selected" value="0">未审核</option>
											<option value="1">建议立案</option>
											<option value="2">建议不立案</option>
											<option value="15">移送</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_17_STATUS }">未审核</c:if>
										<c:if test="${'1' == row.STEP_17_STATUS}">建议立案</c:if>
										<c:if test="${'2' == row.STEP_17_STATUS}">建议不立案</c:if>
										<c:if test="${'15' == row.STEP_17_STATUS}">移送</c:if>
									</c:otherwise>
								</c:choose>
						      </td>
						      <td>
						      	<c:choose>
							      	<c:when test="${'0' != row.STEP_17_STATUS && '0' == row.STEP_6_STATUS}">
										<select id="${row.ID}|${row.PRE_REPORT_NO}" name="status6" style="width:80px;">
											<option selected="selected" value="0">未审核</option>
											<option value="1">建议立案</option>
											<option value="2">建议不立案</option>
											<option value="15">移送</option>
										</select>
									</c:when>
									<c:otherwise>
										<c:if test="${empty row.STEP_6_STATUS }">未审核</c:if>
										<c:if test="${'1' == row.STEP_6_STATUS}">建议立案</c:if>
										<c:if test="${'2' == row.STEP_6_STATUS}">建议不立案</c:if>
										<c:if test="${'15' == row.STEP_6_STATUS}">移送</c:if>
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
						      		<c:when test="${'0' == row.STEP_5_STATUS || empty row.STEP_5_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=5&page=gp_lian_spb_input&subStep=5");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:when test="${ '0' == row.STEP_17_STATUS || empty row.STEP_17_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=17&page=gp_lian_spb_input&subStep=6");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:when test="${ '0' == row.STEP_6_STATUS || empty row.STEP_6_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=6&page=gp_lian_spb_input&subStep=6");'>
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
						      <td>
						      	<c:choose>
						      		<c:when test="${'0' == row.STEP_5_STATUS || empty row.STEP_5_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=5&page=gp_anjian_ysh_input&subStep=5");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:when test="${'0' == row.STEP_6_STATUS || empty row.STEP_6_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=6&page=gp_anjian_ysh_input&subStep=6");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:when test="${'0' == row.STEP_17_STATUS || empty row.STEP_17_STATUS}">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=17&page=gp_anjian_ysh_input&subStep=6");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:otherwise>
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=3&page=gp_anjian_ysh_input&subStep=0");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
						      		</c:otherwise>
						      	</c:choose>
						      </td>
						      <!-- 
							  <td>
							      <a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=5");'>
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
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm5();" />
			</div>

</html>
				
				