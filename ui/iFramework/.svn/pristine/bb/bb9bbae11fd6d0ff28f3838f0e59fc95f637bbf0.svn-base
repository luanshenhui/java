<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.helper.StringUtils"%>
<%@ page import="com.dhc.workflow.model.define.Transition"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ page import="com.dhc.workflow.model.define.RelateData"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String xmlStr = ((String) request.getAttribute("xmlStr"));
	String id = ((String) request.getAttribute("id"));
	String closeflag = ((String) request.getAttribute("close_flag"));

	String processId = request.getParameter("processId");
	String processVersion = request.getParameter("processVersion");
	String transId = request.getParameter("transId");
	String fromActId = request.getParameter("fromActId");
	String toActId = request.getParameter("toActId");
	Transition transition = new Transition();
	List<RelateData> relatedataList = new ArrayList<RelateData>();
	
	if (!StringUtils.isEmpty(processId) && !StringUtils.isEmpty(processVersion) && !StringUtils.isEmpty(transId) && 
			!StringUtils.isEmpty(fromActId) && !StringUtils.isEmpty(toActId)) {
		Process process = (Process) session.getAttribute(processId + ","
				+ processVersion);
		
		if (process != null){
			if (process.getTransList() != null) {
				for (Transition trans : process.getTransList()){
					if (trans.getTransId().equals(transId))
						transition = trans;
				}
			}
			relatedataList = process.getRdataList();
			if (relatedataList == null)
				relatedataList = new ArrayList<RelateData>();
		}
		
	}
%>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript"
	src="<%=path%>/view/workflow/wftransition/wfTransition.js"></script>

<html>
<head>
    <title>传输线属性</title>	
</head>

<body class="popUp-body" onLoad="LoadName()"><br>

<form action="" name="transitionForm">
<div class="w520 main_label_outline mt15">
  	<table class="main_label_table">
		<tr>
			<td class="popUp-name">
			<font color="#ff0000">*</font>
			名称：
			</td>
			<td>
			<input type="text" id="transName" name="transName" class="w400 popUp-edit" styleClass="input_underline" value="<%=transition.getTransName()%>">
			</td>
		</tr>
		
		<tr>
			<td class="popUp-name">描述：</td>
			<td>
				<textarea class="w400 popUp-describe" id="transDesc" name="transDesc" rows="5" ><%=transition.getTransDesc() == null ? "" : transition.getTransDesc()%></textarea>
			</td>
		</tr>
		
		<tr>
			<td class="popUp-name">
			<font color="#ff0000">*</font>
			优先级:
			</td>
			<td>
				<input class="w400 popUp-edit" type="text" id="routePriority" name="routePriority" styleClass="input_text" value='<%=transition.getRoutePriority() == null?"":transition.getRoutePriority()%>'>
			</td>
		</tr>
		
		<tr>
			<td valign="top" class="popUp-name">条件表达式:</td>
			<td>
				<input class="w400 popUp-edit" type="text" readonly="true" 
				value='<%=transition.getRouteCondition() == null ? "数值直接填写，字符串型使用英文半角双引号。" : transition.getRouteCondition()%>' >
			</td>
		</tr>
		
		<tr>
			<td class="popUp-name fl">&nbsp;</td>
			<td class="popUp-textareaBox fl">
				  <textarea id="routeCondition" name="routeCondition"  rows="4" ></textarea>
			</td>
			<td valign="bottom"></td>
		</tr>
	</table>
	
	<table class="main_label_table">
		<tr>
				<td class="popUp-name" valign="top">表达式设置:</td>
				<td>
					<div>
						<SELECT class="popUp-selectBox popUp-edit" multiple="true" id="selectVariable" >
							<% for (RelateData rData : relatedataList) { %>
							<option value="<%=rData.getRdataId()%>"><%=rData.getRdataName()%></option>
							<% } %>
						</SELECT>
					</div>
				</td>
				
				<td valign="top">
					<table  class="main_label_table" style="width:248px">
						<tr>
							<td><input id="btn1" value="+" type = 'button'  class="btn_small"  onclick = "setValue(' + ')"></td>
							<td><input id="btn2" value="-" type = 'button'  class="btn_small"  onclick = "setValue(' - ')"></td>
							<td><input id="btn3" value="*" type = 'button'  class="btn_small"  onclick = "setValue(' * ')"></td>
							<td><input id="btn4" value="/" type = 'button'  class="btn_small"  onclick = "setValue(' / ')"></td>
							<td><input id="btn5" value="<" type = 'button'  class="btn_small"  onclick = "setValue(' < ')"></td>
							<td><input id="btn6" value=">" type = 'button'  class="btn_small"  onclick = "setValue(' > ')"></td>
						</tr>
						<tr>
							<td><input id="btn7" value="<=" type = 'button' class="btn_small" onclick = "setValue(' <= ')"></td>
							<td><input id="btn8" value=">=" type = 'button' class="btn_small" onclick = "setValue(' >= ')"></td>
							<td><input id="btn9" value="=="  type = 'button' class="btn_small" onclick = "setValue(' == ')"></td>
							<td><input id="btn10" value="!=" type = 'button' class="btn_small" onclick = "setValue(' != ')"></td>
							<td><input id="btn11" value='('  type = 'button' class="btn_small" onclick = "setValue('(')"></td>
							<td><input id="btn12" value=")"  type = 'button' class="btn_small" onclick = "setValue(')')"></td>
						</tr>
						<tr>
							<td colspan="2"><input id="btn14" value="and" type = 'button' class="btn_normal" onclick = "setValue(' && ')"></td>
							<td colspan="2"><input id="btn15" value="or" type = 'button' class="btn_normal" onclick = "setValue(' || ')"></td>
							<td colspan="2"><input id="btn13" value="not" type = 'button' class="btn_normal" onclick = "setValue('!')"></td>
<!-- 							<td><input id="btn16" value="in" type = 'button' class="btn_small" onclick = "setValue(' in ()')"></td> -->
<!-- 							<td colspan='2'><input id="btn17" value='include' type = 'button' class="btn_normal" onclick = 'setValue(" include \"args\"")'></td> -->
						</tr>
<!-- 						<tr>
							<td colspan='2'><input id="btn18" value="like" type = 'button' class="btn_normal" onclick = 'setValue(" like \"*args*\"")'></td>
							<td colspan='2'><input id="btn19" value="subStr" type = 'button' class="btn_normal" onclick = 'setValue("substr(\"args\", beginIndex, endIndex)")'></td>
							<td colspan='2'><input id="btn20" value="tonumber" type = 'button' class="btn_normal" onclick = 'setValue("tonumber(\"args\")")'></td>
						</tr> -->
<!-- 						<tr> -->
<!-- 							<td colspan='6'><input id="btn19" value="校验" type = 'button' class="btn_large"  onclick = 'checkForm()' ></td> -->
<!-- 						</tr> -->
					</table>
				</td>
			</tr>
	</table>
</div>
  <input type="hidden" id="transType"  value=''/>
  <input type="hidden" id="path" value=""/>
  <input type="hidden" id="num" value=""/>	
  <input type="hidden" id="xmlStr"  value=''/>
  <!-- 流程id  -->
  <input type="hidden" id="procid"  name="procid" value='<%=processId%>'/>
  <!-- 流程版本  -->
  <input type="hidden" id="procversion" value='<%=processVersion%>'/>
  <!-- 传输线id -->
  <input type="hidden" id="transId" value='<%=transId%>'/>
  <!-- 来源活动 -->
    <input type="hidden" id="fromActId" name="<%=fromActId%>"/>
  <!-- 目标活动 -->
    <input type="hidden" id="toActId" name="<%=toActId%>"/>
  </form>
  <input type="hidden" id="transitionVariables" value='' />
  <table class="w540 popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width:540px" align="right">
				<input class="popUp-button" type="button" value="取消"  onclick="window.close()">
				<input class="popUp-button" type="button" id="sub" value="提交" onclick="submit_onclick()"/>
			</td>
		</tr>
	</table>
  </body>
</html>