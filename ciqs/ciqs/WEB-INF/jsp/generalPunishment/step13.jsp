
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
						    <td>审理决定时间</td>
						    <td>行政处罚决定书</td>
							<td>送达回证</td>
							<td>缴款收据</td>
							<td>其他</td>
						</tr>
					</thead>
					<c:if test="${not empty list }">
						<c:forEach items="${list}" var="row">
							<tr>
							  <td style="display: none;">${row.PRE_REPORT_NO}</td>
							  <td>
							  	<input type="checkbox" class="checkbox" name="check" id="${row.ID }|${row.PRE_REPORT_NO}"
							  		<c:if test="${'0' != row.STEP_13_STATUS}">disabled</c:if>/>
							  </td>
							  <td><a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=13");'>${row.CASE_NO}</a></td>
							  <td>${row.COMP_NAME }</td>
						      <td>${row.PSN_NAME }</td>
						      <td><fmt:formatDate value="${row.STEP_12_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
						      <td>
						      	<c:choose>
						      		<c:when test="${'0' != row.STEP_12_STATUS && '0' == row.STEP_13_STATUS }">
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=13&page=gp_xzcf_jds&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">在线填写</span>
								      	</a>
						      		</c:when>
						      		<c:otherwise>
						      			<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=13&page=gp_xzcf_jds&subStep=0&pre_report_no=${row.PRE_REPORT_NO }");'>
								      		<span class="data-btn margin-auto">查看</span>
								      	</a>
						      		</c:otherwise>
						      	</c:choose>
							  </td>
							  <td>
							  	<c:choose>
							      	<c:when test="${empty row.GP_FILE_SDHZ_SDZX }">
							      		<c:if test="${'0' == row.STEP_13_STATUS}">
									      	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=13");'>
									      		上传
									      	</a>
									    </c:if>
								    </c:when>
								    <c:otherwise>
								    	<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_SDHZ_SDZX_LOCATION }">查看</a>
								    </c:otherwise>
							    </c:choose>
						      </td>
							  <td>
						      	<c:choose>
							      	<c:when test="${'0' == row.STEP_13_STATUS }">
									      	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=13");'>
									      		上传
									      	</a>
								    </c:when>
								    <c:otherwise>
								    	<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_JFSJ_SDZX_LOCATION }">查看</a>
								    </c:otherwise>
							    </c:choose>
						      </td>
							  <td>
						      	<c:choose>
							      	<c:when test="${empty row.GP_FILE_QT_SDZX }">
							      		<c:if test="${'0' == row.STEP_13_STATUS}">
									      	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=13");'>
									      		上传
									      	</a>
									    </c:if>
								    </c:when>
								    <c:otherwise>
								    	<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${row.GP_FILE_QT_SDZX_LOCATION }">查看</a>
								    </c:otherwise>
							    </c:choose>
						      </td>
							</tr>
						</c:forEach>
					</c:if>
					<tfoot>
						<jsp:include page="/common/pageNewUtil.jsp" flush="true"/>
                   	</tfoot>
				</table>
			<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm13();" />
			</div>
</html>
				
				