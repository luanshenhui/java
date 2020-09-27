<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险信息表</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/reportCount.css">
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#inputForm").submit();
	    	return false;
	    }
	</script>
</head>
<body>
	
	<form:form method="post" class="form-horizontal" id="inputForm">
		<sys:message content="${message}"/>
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	</form:form>
	<br>
	<h2 class="text-center">风险信息表</h2>
	<div class="pull-right mt-10">
	 报表生成日期：<c:choose>
				    <c:when test="${empty page.list}">
				     <span class="date-width">
				      ----</span>
				    </c:when>
				   <c:otherwise>  
				    <span class="date-width">
				    <c:out value="${today}"/>
				    </span>
				   </c:otherwise>
	 			 </c:choose>
	</div>
	<table id="contentTable2" class="table table-striped table-bordered table-condensed" >
		<thead> 
				<tr>
					<th width="5%">序号</th>
					<th width="10%">业务事项</th>
					<th width="10%">操作人</th>
					<th width="10%">所属部门</th>
	            	<th width="10%">办理事项</th>
	            	<th width="5%">风险等级</th>
	            	<th width="10%">风险内容</th>
	            	<th width="10%">风险界定人</th>
	            	<th width="10%">风险界定状态</th>
	           	</tr>
        </thead>
		<tbody>
			<c:forEach items="${page.list}" var="dcaReportRiskMes" varStatus="status" >
				<tr>
					<td>${status.count + (page.pageNo - 1)*page.pageSize}</td>
					<td title="<c:out value="${dcaReportRiskMes.bizFlowName}"/>"><c:out value="${dcaReportRiskMes.bizFlowName}"/></td>
					<td><c:out value="${dcaReportRiskMes.bizOperPerson}"/></td>
					<td><c:out value="${dcaReportRiskMes.bizOperPost}"/></td>
					<td title="<c:out value="${dcaReportRiskMes.bizDataName}"/>"><c:out value="${dcaReportRiskMes.bizDataName}"/></td>
					<td><c:out value="${dcaReportRiskMes.riskLevel}"/></td>
					<td title="<c:out value="${dcaReportRiskMes.riskMsg}"/>"><c:out value="${dcaReportRiskMes.riskMsg}"/></td>
					<td><c:out value="${dcaReportRiskMes.definePerson}"/></td>
					<td><c:out value="${dcaReportRiskMes.defineStatus}"/></td>
				</tr>
			</c:forEach>
			
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>