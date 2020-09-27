<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ page import="com.dhc.workflow.model.define.RelateData"%>
<%@ taglib uri="/WEB-INF/tlds/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tlds/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
 	String conditionValue=java.net.URLDecoder.decode(request.getParameter("conditionValue"), "utf-8");
 	if("".equals(conditionValue)||conditionValue==null){
 		conditionValue = "数值直接填写，字符串型使用英文半角双引号。";
 	}

	List<RelateData> relatedataList = new ArrayList<RelateData>();
	try {
		//防跨站脚本编制
		//返回选择结果时，确定哪一列是要返回显示的。此参数必填！
		String displayColumnName = (String)request.getParameter("displayColumnName");
		String processId = (String)request.getParameter("processId");
		String processVersion =(String)request.getParameter("processVersion");
		//System.out.println(processId);
		//System.out.println(processVersion);
		Process process = (Process)request.getSession().getAttribute(processId + "," + processVersion);
		relatedataList = process.getRdataList();
		if (relatedataList == null)
			relatedataList = new ArrayList<RelateData>();
		//System.out.println(relatedataList.size());
	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>	
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfprocess/WfConditions.js"></script>

<html>
	<title>条件设置</title>
	<body class="popUp-body">
		<!-- 条件类型：前置条件，后置条件 -->
		<input type="hidden" id="conditionType" value="<%=request.getParameter("conditionType")%>">
		<div class="main_label_outline mt15" style="width: 520px">
			<table style="width: 500px" class="main_label_table">
				<tr>
					<td class="popUp-name">
						条件表达式:
					</td>
					<td>
						<input class="w400 popUp-edit" type="text" readonly="true" value="<%=conditionValue%>">
					</td>
				</tr>
				<tr>
					<td class="popUp-name fl">&nbsp;</td>
					<td class="popUp-textareaBox fl">
						<html:textarea property="conditionValue"
							value=""
							 rows="4" >
							</html:textarea>
					</td>
					<td valign="bottom"></td>
				</tr>
			</table>
			<table class="main_label_table">

				<tr>
					<td class="popUp-name" valign="top">
						表达式设置:
					</td>
					<td style="valign: top">
						<div>
							<SELECT class="popUp-selectBox popUp-edit" multiple="true" id="selectVariable">
							<% for (RelateData rData : relatedataList) { %>
							<option value="<%=rData.getRdataId()%>"><%=rData.getRdataName()%></option>
							<% } %>
							</SELECT>
						</div>
					</td>
					<td width="10" />
					<td valign="top">
						<table style="width: 150px" class="main_label_table">
							<tr>
								<td>
									<input id="btn1" value="+" type='button' class="btn_small"
										onclick="setValue(' + ')">
								</td>
								<td>
									<input id="btn2" value="-" type='button' class="btn_small"
										onclick="setValue(' - ')">
								</td>
								<td>
									<input id="btn3" value="*" type='button' class="btn_small"
										onclick="setValue(' * ')">
								</td>
								<td>
									<input id="btn4" value="/" type='button' class="btn_small"
										onclick="setValue(' / ')">
								</td>
								<td>
									<input id="btn5" value='&lt;' type='button' class="btn_small"
										onclick="setValue(' < ')">
								</td>
								<td>
									<input id="btn6" value=">" type='button' class="btn_small"
										onclick="setValue(' > ')">
								</td>
							</tr>
							<tr>
								<td>
									<input id="btn7" value="<=" type='button' class="btn_small"
										onclick="setValue(' <= ')">
								</td>
								<td>
									<input id="btn8" value=">=" type='button' class="btn_small"
										onclick="setValue(' >= ')">
								</td>
								<td>
									<input id="btn9" value="==" type='button' class="btn_small"
										onclick="setValue(' == ')">
								</td>
								<td>
									<input id="btn10" value="!=" type='button' class="btn_small"
										onclick="setValue(' != ')">
								</td>
								<td>
									<input id="btn11" value='(' type='button' class="btn_small"
										onclick="setValue('(')">
								</td>
								<td>
									<input id="btn12" value=")" type='button' class="btn_small"
										onclick="setValue(')')">
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<input id="btn14" value="and" type='button' class="btn_normal"
										onclick="setValue(' && ')">
								</td>
								<td colspan="2">
									<input id="btn15" value="or" type='button' class="btn_normal"
										onclick="setValue(' || ')">
								</td>
								<td colspan="2">
									<input id="btn13" value="not" type='button' class="btn_normal"
										onclick="setValue('!')">
								</td>
<!-- 								<td> -->
<!-- 									<input id="btn16" value="in" type='button' class="btn_small" -->
<!-- 										onclick="setValue(' in ()')"> -->
<!-- 								</td> -->
<!-- 								<td colspan='2'> -->
<!-- 									<input id="btn17" value='include' type='button' -->
<!-- 										class="btn_normal" onclick='setValue(" include \"args\"")'> -->
<!-- 								</td> -->
							</tr>
							<!-- <tr>
								<td colspan='2'>
									<input id="btn18" value="like" type='button' class="btn_normal"
										onclick='setValue(" like \"*args*\"")'>
								</td>
								<td colspan='2'>
									<input id="btn19" value="subStr" type='button'
										class="btn_normal"
										onclick='setValue("substr(\"args\", beginIndex, endIndex)")'>
								</td>
								<td colspan='2'>
									<input id="btn20" value="tonumber" type='button'
										class="btn_normal" onclick='setValue("tonumber(\"args\")")'>
								</td>
							</tr> -->
<!-- 							<tr> -->
<!-- 								<td colspan='6'> -->
<!-- 									<input id="btn19" value="校验" type='button' class="btn_large" -->
<!-- 										onclick='checkForm()'> -->
<!-- 								</td> -->
<!-- 							</tr> -->
						</table>
					</td>
				</tr>
			</table>
		</div>
		<table class="w540  popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td style="width: 500px" align="right">
					<input class="popUp-button" type="button"  value='取消' onclick="window.close()" />
					<input class="popUp-button" type="button" id="sub" value='提交'  onclick="checkCon()" />
					
				</td>
			</tr>
		</table>
	</body>
</html>
