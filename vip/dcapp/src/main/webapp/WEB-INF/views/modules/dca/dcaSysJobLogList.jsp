<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>数据加载结果</title>
	<dca:resources />
	<script src="/assets/dca/js/jquery.sysJobLog.js" type="text/javascript"></script>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	$(document).ready(function() {
		
	});
	

		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		
		<li class="active"><a href="${ctx}/dca/dcaSysJobLog/">数据加载结果</a></li>
	</ul><br/> --%>
	<sys:message content="${message}"/>
	
	<form:form id="searchForm" modelAttribute="dcaSysJobLog" action="${ctx}/dca/dcaSysJobLog/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form" id="data-select">
			<li>
			<label class="font-normal">执行日期：</label>
				<input id="startdate" name="startdate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate"
				value="<fmt:formatDate value="${dcaSysJobLog.startdate}" pattern="yyyy-MM-dd"/>"/>
				<span>--</span> 
			<input id="enddate" name="enddate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate"
				value="<fmt:formatDate value="${dcaSysJobLog.enddate}" pattern="yyyy-MM-dd"/>" />
			</li>
		<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed ">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="15%">执行开始时间</th>
				<th width="15%">执行结束时间</th>
				<th width="20%">任务名称</th>
				<th width="10%">执行是否成功</th>
				<th width="15%">执行结果</th>
				<shiro:hasPermission name="dca:dcaSysJobLog:view"><th width="20%">操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
	
		<c:forEach items="${page.list}" var="dcaSysJobLog" step="1" varStatus="sysJobLogStatus">
			<tr>
				<td>
					<c:out value="${sysJobLogStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/>
				</td>
				<td>
					<fmt:formatDate value="${dcaSysJobLog.startdate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<fmt:formatDate value="${dcaSysJobLog.enddate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<c:out value="${dcaSysJobLog.jobname}"></c:out>
				</td>
				<td>
				<c:choose>
				<c:when test="${dcaSysJobLog.errors == 0}">
					<c:out value="执行成功"></c:out>
				</c:when>
				<c:otherwise>
					<c:out value="执行失败"></c:out>
				</c:otherwise>
				</c:choose>
				</td>
				<td>
					<shiro:hasPermission name="dca:dcaSysJobLog:view"><a href="${ctx}/dca/dcaSysJobLog/show?id=${dcaSysJobLog.idJob}" class="btn-s btn-opear">查看日志</a></shiro:hasPermission>
				</td>
				<shiro:hasPermission name="dca:dcaSysJobLog:view">
				<td>
    				<a href="${ctx}/dca/dcaSysJobLog/showdetial?id=${dcaSysJobLog.idJob}" class="btn-s btn-opear">查看详细</a>
				</td>
				</shiro:hasPermission>
			</tr>
		</c:forEach>
	
		
		</tbody>
	</table>
		<c:if test="${empty page.list}">
			<div class="text-center font-normal">没有符合条件的信息，请尝试其他查询条件。</div>
		</c:if>
	<div class="pagination">${page}</div>
	
</body>
</html>