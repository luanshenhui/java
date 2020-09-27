
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<table>
					<thead>
						<tr>
							<td><input type="checkbox" id="checkAll"
							style="width: 50px;" onchange="checkAllChange()" /></td>
							<td>预申报号</td>
							<td>立案号</td>
						    <td>单位名称</td>
						    <td>姓名</td>
						    <td>法制审批时间</td>
						    <td>业务处/办事处</td>
						    <td>稽查审核状态</td>
						    <td>法制审核状态</td>
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
									id="${row.ID }|${row.PRE_REPORT_NO}"
									<c:if test="${!(empty row.STEP_7_STATUS or '' == row.STEP_7_STATUS or '0' == row.STEP_7_STATUS)}">disabled</c:if> />
									</td>
							  <td>
							  	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=7");'>${row.PRE_REPORT_NO}</a>
							  </td>
							  <td>${row.CASE_NO}</td>
							  <td>${row.COMP_NAME }</td>
						      <td>${row.PSN_NAME }</td>
						      <td><fmt:formatDate value="${row.STEP_6_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
						      <td>${row.DECLARE_ORG_NAME }</td>
						      <td>
						      	<c:if test="${empty row.STEP_3_STATUS}"></c:if>
								<c:if test="${'0' == row.STEP_3_STATUS}">未审核</c:if>
								<c:if test="${'1' == row.STEP_3_STATUS}">建议立案</c:if>
								<c:if test="${'2' == row.STEP_3_STATUS}">建议不立案</c:if>
								<c:if test="${'15' == row.STEP_3_STATUS}">移送</c:if>
						      </td>
    						  <td>
						      	<c:if test="${empty row.STEP_6_STATUS}"></c:if>
								<c:if test="${'0' == row.STEP_6_STATUS}">未审核</c:if>
								<c:if test="${'1' == row.STEP_6_STATUS}">建议立案</c:if>
								<c:if test="${'2' == row.STEP_6_STATUS}">建议不立案</c:if>
								<c:if test="${'15' == row.STEP_6_STATUS}">移送</c:if>
						      </td>
						      <td>
							  	<c:if test="${empty row.STEP_7_STATUS or '0' == row.STEP_7_STATUS}">
									<select id="${row.ID }_status" name="status" style="width:80px;">
										<option selected="selected" value="0">未审核</option>
										<option value="1">立案</option>
										<option value="2">不立案</option>
										<option value="15">移送</option>
									</select>
								</c:if>
								<c:if test="${'0' != row.STEP_7_STATUS && not  empty row.STEP_7_STATUS}">
								
										<% request.setAttribute("esList", YbcfStatusEnum.toList()); %>
<%-- 										<c:forEach items="${esList}" var="v">
											<c:if test="${v.code == row.STEP_9_STATUS }">${v.name }</c:if>
										</c:forEach> --%>
							      	<c:if test="${empty row.STEP_7_STATUS}"></c:if>
									<c:if test="${'0' == row.STEP_7_STATUS}">未审核</c:if>
									<c:if test="${'1' == row.STEP_7_STATUS}">立案</c:if>
									<c:if test="${'2' == row.STEP_7_STATUS}">不立案</c:if>
									<c:if test="${'15' == row.STEP_7_STATUS}">移送</c:if>
								</c:if>
							  </td>
							  <td>
							  	<c:choose>
							      	<c:when test="${'0' != row.STEP_6_STATUS && '0' == row.STEP_7_STATUS}">
										<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=7&page=gp_lian_spb_input&subStep=7&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
							      	</c:when>
							      	<c:otherwise>
							      		<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=7&page=gp_lian_spb_input&subStep=0");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
							      	</c:otherwise>
						      	</c:choose>
						      </td>
						      <td>
						      	<c:choose>
							      	<c:when test="${'0' != row.STEP_6_STATUS && '0' == row.STEP_7_STATUS}">
							      		<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=7&page=gp_anjian_ysh&pre_report_no=${row.PRE_REPORT_NO }");'>查看</a>
							      	</c:when>
									<c:otherwise>
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=7&page=gp_anjian_ysh&subStep=0&pre_report_no=${row.PRE_REPORT_NO }");'>查看</a>
						      		</c:otherwise>
						      	</c:choose>
						      </td>
							  <!-- 
						      <td>
							      <a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=7");'>
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
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm7();" />
			</div>
</html>
				
				