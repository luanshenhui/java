
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
				<div class="menu">
				<ul>
					<li><a href="javascript:jumpPage('/ciqs/generalPunishment/toAdd?step=1');"><img
							src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
				</ul>
			</div>
			<table>
				<thead>
					<tr>
						<td><input type="checkbox" id="checkAll"style="width: 50px;" onchange="checkAllChange()" /></td>
						<td>预申报号</td>
						<td>单位名称</td>
					    <td>姓名</td>
					    <td>法定代表人</td>
					    <td>电话</td>
					    <td>申报时间</td>
					    <td>线索审核状态</td>
						<td>线索审核人</td>
						<td>立案审批状态</td>
						<td>案件申报单</td>
					    <td>操作</td>
					    <td>反馈查看</td>
					    <td>诚信管理</td>
					</tr>
				</thead>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row">
						<tr>
						<td>
						<input type="checkbox" class="checkbox" name="check"
							id="${row.ID }|${row.PRE_REPORT_NO}"
							<c:if test="${empty row.STEP_1_DOC_ID || '0' !=  row.STEP_1_STATUS}">disabled</c:if> />
							</td>
						  <td>
						  	<a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=1");'>
						  		${row.PRE_REPORT_NO}
						  	</a>
						  </td>
						  <td>${row.COMP_NAME }</td>
					      <td>${row.PSN_NAME }</td>
					      <td>${row.CORPORATE_PSN }</td>
					      <td>${row.TEL }</td>
					      <td><fmt:formatDate value="${row.STEP_1_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
					      <td>
					      	<c:if test="${empty row.STEP_2_STATUS}">未审核</c:if>
							<c:if test="${'0' == row.STEP_2_STATUS}">未审核</c:if>
							<c:if test="${'1' == row.STEP_2_STATUS}">通过</c:if>
							<c:if test="${'2' == row.STEP_2_STATUS}">不通过</c:if>
					      </td>
					      <td>${row.STEP_2_PSN }</td>
					      <td>
					      	<c:if test="${empty row.STEP_7_STATUS}">未审核</c:if>
								<c:if test="${'0' == row.STEP_7_STATUS}">未审核</c:if> 
								<c:if test="${'1' == row.STEP_7_STATUS}">立案</c:if> 
								<c:if test="${'2' == row.STEP_7_STATUS}">不立案</c:if>
								<c:if test="${'15' == row.STEP_7_STATUS}">移送</c:if>
						  </td>
						  <td>
						  	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=1&page=gp_shexiananjian_sbd&update=update&pre_report_no=${row.PRE_REPORT_NO }<c:if test="${row.STEP_2_STATUS == '1' || row.STEP_1_STATUS == '1' }">&subStep=0</c:if>");'>
						  	${row.DOC_GP_AJ_SBD=='0'?'在线填写':'查看' }</a>
						  </td>
					      <td>
					      	<c:if test="${'0' eq row.STEP_2_STATUS || '2' eq row.STEP_2_STATUS || empty row.STEP_2_STATUS  }">
						      <a href='javascript:jumpPage("/ciqs/generalPunishment/toUpdate?id=${row.ID}&step=${form.step }");'>
						      	<span class="data-btn margin-auto">修改</span>
						      </a>
						    </c:if>
						    <c:if test="${'0' eq row.STEP_2_STATUS || '0' eq row.STEP_2_STATUS || empty row.STEP_2_STATUS}">
						    | 
						      <a href='javascript:jumpPage("/ciqs/generalPunishment/delete?pre_report_no=${row.PRE_REPORT_NO}&step=${form.step }");'
						      onclick="javascript:return confirm('是否确定将此条数据删除？');">
						      	<span class="data-btn margin-auto">删除</span>
						      </a>
						    </c:if>  
					      </td>
					      <td>
									<c:choose>
										<c:when test="${not empty row.AJFKB_DOC_ID }">
											<a
												href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${row.ID}&step=1&page=gp_xzcf_ajfkb&subStep=0");'>查看</a>
								  		</c:when>
									</c:choose>
					      </td>
					      <td>
					      <a target="_blank" href="http://10.10.9.236/admin/login"><span>诚信管理</span></a>
					      </td>
						</tr>
					</c:forEach>
				</c:if>
				<tfoot>
					<jsp:include page="/common/pageNewUtil.jsp" flush="true"/>
                  	</tfoot>
			</table>
			<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
				<input type="button" class="search-btn" value="提交" onclick="javascript:submitForm1();" />
			</div>

</html>
				
				