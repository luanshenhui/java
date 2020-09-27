<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.model.define.Activity"%>
<%
	String webpath = request.getContextPath();
	Object obj = request.getAttribute("paralActList");
	List<Activity> paralActList = (List<Activity>)obj;
	if (obj == null) {
		paralActList = new ArrayList<Activity>();
	} else {
		paralActList = (List<Activity>)obj;
	}
%>
<html>
<head>
<title>特送</title>
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/workflow/management/workitem/SendTo.js"></script>
	<script type="text/javascript">
		var procInstanceId = "${requestScope.procInstanceId}";
		var activityInstId = "${requestScope.activityInstId}";
		var workitemId = "${requestScope.workitemId}";
	</script>
</head>
<body class="popUp-body">
	<form id="sendToForm">
		<div style="margin: 5px auto auto 5px;" class="main_label_outline">
			<table>
				<tr>
					<td>
						<div class="popUp-treeTitle">目标节点选择：</div>
					</td>
					<td><select id="sendtos" style="float: left;"
						onChange="comboClick()">
							<%for(Activity activity : paralActList) { %>
							<option value="<%=activity.getActId()%>"><%=activity.getActName()%></option>
							<%} %>
					</select></td>
				</tr>
			</table>
		</div>
		<div id="personSet" style="margin: 5px auto auto 5px;"
			class="main_label_outline">
			<table width="100%" height="300" border="0">
				<tr height=150>
					<td class="popUp-treeTitle" valign="top" rowspan=2 width=45%><label>组织机构：</label>
						<ul id="treeDemo" class="h300 ztree popUp-treeBox popUp-edit"></ul></td>
					<td width=10% align="center" valign="center">
						<table>
							<tr>
								<td><input type="button" style="margin: 5px auto 5px auto;"
									id="addMain" value='>>' onClick="addMainto()">
										</div></td>
							</tr>
							<tr>
								<td><input type="button" style="margin: 5px auto 5px auto;"
									id="deleteMain" value='&lt;&lt;' onClick="removeMainto()">
										</div></td>
							</tr>
						</table>
					</td>
					<td class="popUp-treeTitle" cellpadding="5" width=45%><label>主送：</label>
						<select name="sendtoForm" id="sendToParts" multiple="true"
						style="width: 255px; height: 155px">

					</select></td>
				</tr>
				<tr height=150>
					<td width=10% align="center" valign="center">
						<table>
							<tr>
								<td><input type="button" style="margin: 5px auto 5px auto;"
									id="addCopy" value='>>' onClick="addCopyto()"></div></td>
							</tr>
							<tr>
								<td><input type="button" style="margin: 5px auto 5px auto;"
									id="deleteCopy" value='&lt;&lt;' onClick="removeCopyto()">
										</div></td>
							</tr>
						</table>
					</td>
					<td class="popUp-treeTitle" cellpadding="5" width=45%><label>抄送：</label>
						<select name="sendtoForm" id="copyToParts" multiple="true"
						style="width: 255px; height: 155px">

					</select></td>
				</tr>
			</table>
		</div>
		<label
			style="color: red; display: none; float: left; margin: 10px auto auto 5px;"
			id="warning"></label> <input type="button"
			style="float: right; margin: 5px auto auto 5px;" value="取消"
			onClick="cancel_onclick()" /><input type="button"
			style="float: right; margin: 5px 5px auto auto;" value="确定"
			onClick="ok_onclick()" /> <input type="hidden" id="action" /> <input
			type="hidden" id="workitemID" /> <input type="hidden"
			id="sendtoString" /> <input type="hidden" id="sendtoId" /> <input
			type="hidden" id="approvalinfo" />
	</form>
</body>
</html>