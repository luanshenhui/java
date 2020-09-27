<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<table class="table_search" id="table_search">
		<!-- 第一行 -->
		<c:choose>
			<c:when test="${step == '1' || step == '2' || step == '3' || step == '4' || step == '5' || step == '6' || step == '7' || step == '8'}">
				<tr>
					<td style="width: 250px;" align="left">预申报号:</td>
					<td style="width: 250px;" align="left">姓名:</td>
					<td style="width: 250px;" align="left">单位名称:</td>
				</tr>
				<tr>
					<td align="left"><input type="text" name="t.pre_report_no" id="pre_report_no"
						size="14" value="${t.pre_report_no}"/></td>
					<td align="left"><input type="text" name="t.psn_name" id="psn_name"
						size="14" value="${psn_name}"/></td>
					<td align="left"><input type="text" name="t.comp_name" id="comp_name"
						size="14" value="${comp_name}"/></td>
				</tr>
			</c:when>
			<c:when test="${step == '9' || step == '18' || step == '19' || step == '10' || step == '11' || step == '12' || step == '13' || step == '14'}">
				<tr>
					<td style="width: 250px;" align="left">立案号:</td>
					<td style="width: 250px;" align="left">单位名称:</td>
					<td style="width: 250px;" align="left">姓名:</td>
				</tr>
				<tr>
					<td align="left"><input type="text" name="t.case_no" id="pre_report_no"
						size="14" value="${case_no}"/></td>
					<td align="left"><input type="text" name="t.comp_name" id="case_no"
						size="14" value="${comp_name}"/></td>
					<td align="left"><input type="text" name="t.psn_name" id="psn_name"
						size="14" value="${psn_name}"/></td>
				</tr>
			</c:when>
			<c:otherwise>
			
			</c:otherwise>
		</c:choose>
	
		<!-- 第二行 -->
		<c:choose>
	
			<c:when test="${step == '1' || step == '2'}">
				<tr>
					<td style="width: 250px;" align="left">申报时间（起）:</td>
					<td style="width: 250px;" align="left">申报时间（止）:</td>
					<td style="width: 250px;" align="left">线索审核状态:</td>
				</tr>
				<tr>
					<td align="left"><input type="text" name="sv.step_1_date_begin" id="step_1_date_begin" opera=">=" class="datepick"
						size="14" value="${step_1_date_begin}"/></td>
					<td align="left"><input type="text" name="sv.step_1_date_end" id="step_1_date_end" opera="<=" class="datepick"
						size="14" value="${step_1_date_end}"/></td>
					<td align="left">
						<% request.setAttribute("statusList", YbcfStatusEnum.toList()); %>
						<select id="step_2_status" name="sv.step_2_status" class="select">
							<option <c:if test="${empty step_2_status}"> selected="selected" </c:if> value="">全部</option>
							<option <c:if test="${'0' == step_2_status}"> selected="selected" </c:if> value="0">未审核</option>
							<option <c:if test="${'1' == step_2_status}"> selected="selected" </c:if> value="1">通过</option>
							<option <c:if test="${'2' == step_2_status}"> selected="selected" </c:if> value="2">不通过</option>
						</select>
					</td>
				</tr>
			</c:when>
			
			<c:when test="${step == '3'}">
					<tr>
						<td style="width: 250px;" align="left">线索审核时间（起）:</td>
						<td style="width: 250px;" align="left">线索审核时间（止）:</td>
						<td style="width: 250px;" align="left">稽查审核状态:</td>
					</tr>
					<tr>
						<td  style="width: 250px;" align="left"><input type="text" name="sv.step_2_date_begin" opera=">=" id="step_2_date_begin" class="datepick"
							size="14" value="${step_2_date_begin}"/></td>
						<td  style="width: 250px;" align="left"><input type="text" name="sv.step_2_date_end" opera="<=" id="step_2_date_end" class="datepick"
							size="14" value="${step_2_date_end}"/></td>
						<td  style="width: 250px;" align="left">
							<select id="step_4_status" name="sv.step_4_status" class="select">
								<option <c:if test="${empty step_4_status}"> selected="selected" </c:if> value="">全部</option>
								<option <c:if test="${step_4_status == '0'}"> selected="selected" </c:if> value="0">未审核</option>
								<option <c:if test="${step_4_status == '1'}"> selected="selected" </c:if> value="1">建议立案</option>
								<option <c:if test="${step_4_status == '2'}"> selected="selected" </c:if> value="2">建议不立案</option>
							</select>
						</td>
					</tr>
			</c:when>
			<c:when test="${step == '5'}">
							<tr>
								<td>稽查审批时间（起）:</td>
								<td>稽查审批时间（止）:</td>
								<td>法制审核状态:</td>
							</tr>
							<tr>
								<td align="left"><input type="text" name="sv.step_6_date_begin" opera=">=" id="step_6_date_begin" class="datepick"
									size="14" value="${step_6_date_begin}"/></td>
								<td align="left"><input type="text" name="sv.step_6_date_end" opera="<=" id="step_6_date_end" class="datepick"
									size="14" value="${step_6_date_end}"/></td>
								<td  style="width: 250px;" align="left">
									<select id="step_6_status" name="sv.step_6_status" class="select">
										<option <c:if test="${empty step_6_status}"> selected="selected" </c:if> value="">全部</option>
										<option <c:if test="${step_6_status == '0'}"> selected="selected" </c:if> value="0">未审核</option>
										<option <c:if test="${step_6_status == '1'}"> selected="selected" </c:if> value="1">建议立案</option>
										<option <c:if test="${step_6_status == '2'}"> selected="selected" </c:if> value="2">建议不立案</option>
										<option <c:if test="${step_6_status == '15'}"> selected="selected" </c:if> value="15">移送</option>
									</select>
								</td>
							</tr>
			</c:when>
			<c:when test="${step == '7'}">
					<tr>
						<td >立案号:</td>
						<td >法制审批时间（起）:</td>
						<td >法制审批时间（止）:</td>
					
					</tr>
					
					<tr>
						<td align="left"><input type="text" name="t.case_no" id="case_no"
							size="14" value="${case_no}"/></td>
						<td align="left"><input type="text" name="sv.step_6_date_begin" opera=">=" id="step_6_date_begin" class="datepick"
							size="14" value="${step_6_date_begin}"/></td>
						<td align="left"><input type="text" name="sv.step_6_date_end" opera="<=" id="step_6_date_end" class="datepick"
							size="14" value="${step_6_date_end}"/></td>
					</tr>
			</c:when>
			<c:when test="${step == '9' || step == '18' || step == '19'}">
							<tr>
								<td>立案审批时间（起）:</td>
								<td>立案审批时间（止）:</td>
								<td>提交状态</td>
							</tr>
							<tr>
								<td align="left"><input type="text" name="sv.step_7_date_begin" opera=">="
									id="step_7_date_begin" class="datepick" size="14"
									value="${step_7_date_begin}" /></td>
								<td align="left"><input type="text" name="sv.step_7_date_end" opera="<="
									id="step_7_date_end" class="datepick" size="14"
									value="${step_7_date_end}" /></td>
								<td>
									<select id="submit_status" name="submit_status" class="select">
										<option style="display:none;" <c:if test="${empty submit_status}">selected="selected"</c:if> value=""></option>
										<option <c:if test="${'0' == form.submit_status || empty submit_status}">selected="selected"</c:if> value="0">全部</option>
										<option <c:if test="${'1' == form.submit_status}">selected="selected"</c:if> value="1">未提交</option>
										<option <c:if test="${'2' == form.submit_status}">selected="selected"</c:if> value="2">已提交</option>
									</select>
								</td>
							</tr>
			</c:when>
			<c:when test="${step == '10'}">
							<tr>
								<td style="width: 250px;" align="left">调查取证终审时间（起）:</td>
								<td style="width: 250px;" align="left">调查取证终审时间（止）:</td>
								<td style="width: 250px;" align="left">提交状态</td>
							</tr>
							<tr>
								<td align="left"><input type="text" name="sv.step_19_date_begin" id="step_19_date_begin" class="datepick"
									opera=">=" size="14" value="${step_19_date_begin}"/></td>
								<td align="left"><input type="text" name="sv.step_19_date_end" id="step_19_date_end" class="datepick"
									opera="<=" size="14" value="${step_19_date_end}"/></td>
								<td>
									<select id="submit_status" name="submit_status" class="select">
										<option <c:if test="${'0' == form.submit_status}">selected="selected"</c:if> value="0">全部</option>
										<option <c:if test="${'1' == form.submit_status}">selected="selected"</c:if> value="1">未提交</option>
										<option <c:if test="${'2' == form.submit_status}">selected="selected"</c:if> value="2">已提交</option>
									</select>
								</td>
							</tr>
			</c:when>
			<c:when test="${step == '11'}">
				<tr>
					<td style="width: 250px;" align="left">初审时间（起）:</td>
					<td style="width: 250px;" align="left">初审时间（止）:</td>
				</tr>
				<tr>
					<td align="left"><input type="text" name="sv.step_10_date_begin" id="step_10_date_begin" class="datepick"
						opera=">=" size="14" value="${step_10_date_begin}"/></td>
					<td align="left"><input type="text" name="sv.step_10_date_end" id="step_10_date_end" class="datepick"
						opera="<=" size="14" value="${step_10_date_end}"/></td>
				</tr>
			</c:when>
			<c:when test="${step == '12'}">
				<tr>
					<td style="width: 250px;" align="left">复审时间（起）:</td>
					<td style="width: 250px;" align="left">复审时间（止）:</td>
				</tr>
				<tr>
					<td align="left"><input type="text" name="sv.step_11_date_begin" id="step_11_date_begin" class="datepick"
						opera=">=" size="14" value="${step_11_date_begin}"/></td>
					<td align="left"><input type="text" name="sv.step_11_date_end" id="step_11_date_end" class="datepick"
						opera="<=" size="14" value="${step_11_date_end}"/></td>
				</tr>
			</c:when>
			<c:when test="${step == '13'}">
				<tr>
					<td style="width: 250px;" align="left">审理决定时间（起）:</td>
					<td style="width: 250px;" align="left">审理决定时间（止）:</td>
					<td style="width: 250px;" align="left">提交状态</td>
				</tr>
				<tr>
					
					<td align="left"><input type="text" name="sv.step_12_date_begin" id="step_12_date_begin" class="datepick"
						opera=">=" size="14" value="${step_12_date_begin}"/></td>
					<td align="left"><input type="text" name="sv.step_12_date_end" id="step_12_date_end" class="datepick"
						opera="<=" size="14" value="${step_12_date_end}"/></td>
					<td>
						<select id="submit_status" name="submit_status" class="select">
							<option <c:if test="${'0' == form.submit_status}">selected="selected"</c:if> value="0">全部</option>
							<option <c:if test="${'1' == form.submit_status}">selected="selected"</c:if> value="1">未提交</option>
							<option <c:if test="${'2' == form.submit_status}">selected="selected"</c:if> value="2">已提交</option>
						</select>
					</td>
				</tr>
			</c:when>
			<c:when test="${step == '14'}">
							<tr>
								<td style="width: 250px;" align="left">结案归档时间（起）:</td>
								<td style="width: 250px;" align="left">结案归档时间（止）:</td>
								<td style="width: 250px;" align="left">案件类型:</td>
							</tr>
							<tr>
								<td align="left"><input type="text" name="sv.step_14_date_begin" id="step_13_date_begin" class="datepick"
									opera=">=" size="14" value="${step_14_date_begin}"/></td>
								<td align="left"><input type="text" name="sv.step_14_date_end" id="step_13_date_end" class="datepick"
									opera="<=" size="14" value="${step_14_date_end}"/></td>
								<td>
								<%
							        request.setAttribute("esList",YbcfStatusEnum.toList());
							        /* StringBuilder sb = new StringBuilder(); */
							       /*  for (YbcfStatusEnum b : esSet) {
							            System.out.println(b);
							        } */
								 %>
								<select id="ajlx_status" name="sv.step_14_status" class="select">
									<option value="">全部</option>
									<c:forEach items="${esList}" var="v">
										<c:if test="${v.code >= 21 }"><option value="${v.code }" <c:if test="${step_14_status == v.code }">selected="selected"</c:if>>${v.name }</option></c:if>
									</c:forEach>
								</select>
								</td>
							</tr>
					<tr>
						<td style="width: 250px;" align="left">提交状态:</td>
						<td></td>
						<td></td>
					</tr>
				<tr>
					<td>
						<select id="submit_status" name="submit_status" class="select">
							<option <c:if test="${'0' == form.submit_status}">selected="selected"</c:if> value="0">全部</option>
							<option <c:if test="${'1' == form.submit_status}">selected="selected"</c:if> value="1">未提交</option>
							<option <c:if test="${'2' == form.submit_status}">selected="selected"</c:if> value="2">已提交</option>
						</select>
						<td></td>
						<td></td>
					</td>
				</tr>
			</c:when>
			<c:otherwise>
			
			</c:otherwise>
		</c:choose>
		
		
		
		<!-- 第三行 -->
		<c:choose>
			<c:when test="${ step == '1' || step == '2' || step == '3' || step == '7'}">
				<tr>
					<td style="width: 250px;" align="left">立案审批状态:</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td align="left">
						<select id="step_7_status" name="sv.step_7_status" class="select">
							<option <c:if test="${empty step_7_status}"> selected="selected" </c:if> value="">全部</option>
							<option <c:if test="${step_7_status == '0'}"> selected="selected" </c:if> value="0">未审核</option>
							<option <c:if test="${step_7_status == '1'}"> selected="selected" </c:if> value="1">立案</option>
							<option <c:if test="${step_7_status == '2'}"> selected="selected" </c:if> value="2">不立案</option>
							<option <c:if test="${step_7_status == '15'}"> selected="selected" </c:if> value="15">移送</option>
						</select>
					</td>
					<td align="right" colspan="2">
	<!-- 					<input name="searchF" type="button" onclick="search()" 
							class="abutton" value="查 询" /> -->
						</td>
				</tr>
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
			<tr>
					<td align="right" colspan="3"><input name="searchF" type="button" onclick="search()" 
						class="abutton" value="查 询" /></td>
			</tr>
	</table>
</html>
				