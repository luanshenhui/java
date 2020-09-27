<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.model.define.Activity"%>
<%
	String webpath = request.getContextPath();
	Object obj = request.getAttribute("postActList");
	List<Activity> postActList = (List<Activity>)obj;
	if (obj == null) {
		postActList = new ArrayList<Activity>();
	} else {
		postActList = (List<Activity>)obj;
	}
%>
<html>
<head>
<title>普送</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/management/workitem/SendTo.js">
</script>
<script type="text/javascript">
	var procInstanceId = "${requestScope.procInstanceId}";
	var activityInstId = "${requestScope.activityInstId}";
	var workitemId = "${requestScope.workitemId}";
</script>
</head>

<body class="popUp-body">
	<form id="normalSendForm" action="">
	<div style="margin: 5px auto auto 5px;" class="main_label_outline">

		<table width="100%">
			<tr>
				<td class="popUp-treeTitle">
				可普送节点：
				</td>
			</tr>
			<tr>
				<td colspan=2><select id="sendtos">
				<%for (Activity activity : postActList) { %>
					<option value="<%=activity.getActId()%>"><%=activity.getActName()%></option>
				<%} %>
				</select></td>
			</tr>
			<tr>
				<td align="left" valign="center"><label
					style="color: red; display: none;" id="warning">没有任何后续节点被选中！</label>
				</td>
			</tr>
		</table>
		<input type="hidden" id="action" /> <input type="hidden"
			id="workitemID" /> <input type="hidden" id="nextActString" /> <input
			type="hidden" id="selectedNexts" />
	</form>
	</div>
	<input type="button" value="取消" style="float: right; margin: 5px auto auto 5px;" onClick="cancel_click()">
	<input type="button" value="确定" style="float: right; margin: 5px auto auto 5px;" onClick="ok_click()">
</body>
</html>
