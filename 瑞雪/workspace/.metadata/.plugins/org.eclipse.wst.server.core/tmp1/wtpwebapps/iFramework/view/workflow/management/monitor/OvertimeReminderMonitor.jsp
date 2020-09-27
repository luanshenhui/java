<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%@ page import="java.util.*" %>

<%
	String webpath = request.getContextPath();
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>超时监控</title>
		<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
		<jsp:include page="/view/common/jsp/EcCommon.jsp" flush="true" />
		<link rel="stylesheet" type="text/css" href="<%=webpath %>/view/common/css/jquery-ui.css" />
		<script type="text/javascript" src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery-ui.min.js" ></script>
		<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/util.js" ></script>	
		<script type="text/javascript" src="<%=webpath%>/view/workflow/management/monitor/OvertimeReminderMonitor.js"></script>
	</head>
	<body style="margin:10px;">
			<form method="post">
			<div>
				<table  cellpadding="0" cellspacing="0">
					<tr>
						<td  width=80px align="right"><span>开始时间</span></td>
				   		<td ><span style="color:red">&nbsp;*&nbsp;<span></td>
						<td colspan=3>
							<input type="text" id="startDateStart" name="startDateStart" readonly="readonly" onclick="WdatePicker()"/>
							～<input type="text" id="startDateEnd" name="startDateEnd" readonly="readonly"  onclick="WdatePicker()"/>
						</td>
						<td style="display:none;" width=80px align="right"><span>结束时间</span></td>
				   		<td style="display:none;" ><span style="color:red">&nbsp;&nbsp;&nbsp;<span></td>
						<td style="display:none;" colspan="4">
							<input type="text" id="endDateStart" name="endDateStart" readonly="readonly" onclick="WdatePicker()"/>
							～<input type="text" id="endDateEnd" name="endDateEnd" readonly="readonly"  onclick="WdatePicker()"/>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<br>
		<table cellpadding="0" cellspacing="0" width="804px">
			<tr>
				<td align="right">	
					<input type="button" style="width:60px" value="查   询" onclick="doQuery()"/>&nbsp;&nbsp;	
					<input type="button" style="width:60px" value="重   置" onclick="doResert()"/>&nbsp;&nbsp;
					<input type="button" style="width:60px" value="删   除" onclick="doDelete()" /><!-- &nbsp;&nbsp;
					<input type="button" style="width:60px" value="恢   复 " onclick="doResume()" />&nbsp;&nbsp;
					<input type="button" style="width:60px" value="详   情" onclick="doDetail()" /> -->
				</td>
			</tr>
		</table>
		<div id="tabs" style="width:804px;height:400px;">
			<ul>    
				<li><a href="#1" >流程超时任务</a></li>    
				<li><a href="#2" >活动超时任务</a></li> 
			</ul>
			<div id="1" class="menu">
				<ec:table
					items="recordList" var="record" style="table-layout:fixed"
					toolbarContent="status" minHeight="290" height="290" width="765"
					action="${pageContext.request.contextPath}/OvertimeReminderMonitorAction.do?method=OvertimeLCReminderMonitor"
					listWidth="100%" classic="true">
					<ec:row>  
						<ec:column property="_0" width="93" title="序号" value="${GLOBALROWCOUNT}" />
						<ec:column style="text-align:center;" width="95" property="instName" title="模板名称"/>
						<ec:column style="text-align:center;" width="95" property="instStatus" title="流程状态" />
						<ec:column style="text-align:center;" width="95" property="bizCategoryName" title="业务分类"/>
						<ec:column style="text-align:center;" width="95" property="instStartTime" cell="date" sortable="true" title="开始时间" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="instCompleteTime" cell="date" sortable="true" title="完成时间" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="isOvertime" cell="date" sortable="true" title="超时" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="isReminde" title="业务分类"/>
						<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="instID" title="主键" />
					</ec:row>
				</ec:table>
			</div>
			<div id="2">
				<ec:table tableId="ec2"
					items="recordList2" var="record" style="table-layout:fixed"
					toolbarContent="status" minHeight="290" height="290" width="765"
					action="${pageContext.request.contextPath}/OvertimeReminderMonitorAction.do?method=OvertimeHDReminderMonitor"
					listWidth="100%" classic="true">
					<ec:row>  
						<ec:column property="_0" width="93" title="序号" value="${GLOBALROWCOUNT}" />
						<ec:column style="text-align:center;" width="95" property="instName" title="模板名称"/>
						<ec:column style="text-align:center;" width="95" property="instStatus" title="流程状态" />
						<ec:column style="text-align:center;" width="95" property="bizCategoryName" title="业务分类"/>
						<ec:column style="text-align:center;" width="95" property="instStartTime" cell="date" sortable="true" title="开始时间" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="instCompleteTime" cell="date" sortable="true" title="完成时间" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="isOvertime" cell="date" sortable="true" title="超时" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="isReminde" title="业务分类"/>
						<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="instID" title="主键" />
					</ec:row>
				</ec:table>
			</div>
			<div id="3" style="display:none;">
				<ec:table tableId="ec3"
					items="recordList3" var="record" style="table-layout:fixed"
					toolbarContent="status" minHeight="290" height="290" width="765"
					action="${pageContext.request.contextPath}/OvertimeReminderMonitorAction.do?method=OvertimeGZXReminderMonitor"
					listWidth="100%" classic="true">
					<ec:row>  
						<ec:column property="_0" width="93" title="序号" value="${GLOBALROWCOUNT}" />
						<ec:column style="text-align:center;" width="95" property="instName" title="模板名称"/>
						<ec:column style="text-align:center;" width="95" property="instStatus" title="流程状态" />
						<ec:column style="text-align:center;" width="95" property="bizCategoryName" title="业务分类"/>
						<ec:column style="text-align:center;" width="95" property="instStartTime" cell="date" sortable="true" title="开始时间" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="instCompleteTime" cell="date" sortable="true" title="完成时间" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="isOvertime" cell="date" sortable="true" title="超时" format="yyyy-MM-dd HH:mm:ss" />
						<ec:column style="text-align:center;" width="95" property="isReminde" title="业务分类"/>
						<ec:column style="display: none;" width="0%" headerStyle="display: none;" property="instID" title="主键" />
					</ec:row>
				</ec:table>
			</div>
		</div>
									
	</body>
</html>
		                    