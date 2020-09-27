<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>告警信息表</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/reportCount.css">
</head>
<body><br/>
	<h2 class="text-center">告警信息表</h2>
	<div class="pull-right mt-10" >报表生成日期：
		<c:if test="${not empty page.list}">
			<span class="date-width"><c:out value="${dateSys}"/></span>
		</c:if>
		<c:if test="${empty page.list}"><span class="date-width">----</span></c:if>
	</div>
	<table id="contentTable2" class="table table-striped table-bordered table-condensed" >
		<thead>
			<tr>
				<th width="5%">NO.</th>
				<th width="15%">业务事项</th>
				<th width="10%">操作人</th>
				<th width="15%">操作人所属部门</th>
            	<th width="15%">办理事项</th>
            	<th width="10%">告警等级</th>
            	<th width="10%">告警状态</th>
            	<th width="15%">告警信息</th>
            </tr>
        </thead>
		<tbody>
			<c:forEach items="${page.list}" var="dcaReportAlarmMsg">
				<tr>
					<td><c:out value="${dcaReportAlarmMsg.NO}"/></td>
					<td title="<c:out value="${dcaReportAlarmMsg.flowName}"/>"><c:out value="${dcaReportAlarmMsg.flowName}"/></td>
					<td><c:out value="${dcaReportAlarmMsg.operPerson}"/></td>
					<td><c:out value="${dcaReportAlarmMsg.operPost}"/></td>
					<td title="<c:out value="${dcaReportAlarmMsg.dataName}"/>"><c:out value="${dcaReportAlarmMsg.dataName}"/></td>
					<td><c:out value="${dcaReportAlarmMsg.alarmLevel}"/></td>
					<td><c:out value="${dcaReportAlarmMsg.alarmStatus}"/></td>
					<td title="<c:out value="${dcaReportAlarmMsg.alarmMsg}"/>"><c:out value="${dcaReportAlarmMsg.alarmMsg}"/></td>
				</tr>
        	</c:forEach>
		</tbody>
	</table>
</body>
</html>