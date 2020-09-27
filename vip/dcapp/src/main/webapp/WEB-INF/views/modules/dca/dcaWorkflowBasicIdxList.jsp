<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>告警指标管理管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {

	});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/dca/dcaWorkflowBasicIdx/">告警指标管理列表</a></li>
		<shiro:hasPermission name="dca:dcaWorkflowBasicIdx:edit"><li><a href="${ctx}/dca/dcaWorkflowBasicIdx/form">告警指标管理添加</a></li></shiro:hasPermission>
	</ul> --%>
	<form:form id="searchForm" modelAttribute="dcaWorkflowBasicIdx"
		action="${ctx}/dca/dcaWorkflowBasicIdx/" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li><label class="font-normal">指标名称：</label> <form:input
					path="idxName" htmlEscape="true" maxlength="100"
					class="input-medium" /></li>
			<li><label class="font-normal">业务类型：</label> <form:select
					path="idxDataType" class="input-medium">
					<form:option value="" label=" " />
					<form:options items="${fns:getDictList('idx_data_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
			<li class="btns"><button id="btnSubmit" type="submit" value="查询"
					class="btn btn-s btn-opear">
					<i class="icon-search-1"></i>查询
				</button> <shiro:hasPermission name="dca:dcaWorkflowBasicIdx:edit">
					<li class="btns pull-right"><a
						href="${ctx}/dca/dcaWorkflowBasicIdx/form" class="btn-s btn-add"><i>+</i>新建</a></li>
				</shiro:hasPermission>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}" />
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="20%">指标名称</th>
				<th width="20%">指标业务类型</th>
				<th title="鼠标置于“查看”上显示对应的sql语句" width="20%">SQL语句</th>
				<th width="20%">更新时间</th>
				<shiro:hasPermission name="dca:dcaWorkflowBasicIdx:edit">
					<th width="20%">操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="dcaWorkflowBasicIdx"
				varStatus="status">
				<tr>
					
					<td><c:out value="${status.count + (page.pageNo - 1)*page.pageSize}" /></td>	
					<td title="${dcaWorkflowBasicIdx.idxName}"><a
						href="${ctx}/dca/dcaWorkflowBasicIdx/form?id=${dcaWorkflowBasicIdx.idxId}">
							${dcaWorkflowBasicIdx.idxName} </a></td>
					<td><c:out
							value="${fns:getDictLabel(dcaWorkflowBasicIdx.idxDataType, 'idx_data_type', '')}" />
					</td>
					<td title="${dcaWorkflowBasicIdx.idxSql}" htmlEscape="true" style = "color:blue">
						查看 <%-- 					<c:out value = "${dcaWorkflowBasicIdx.idxSql}" /> --%>
					</td>
					<td><fmt:formatDate value="${dcaWorkflowBasicIdx.updateDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<shiro:hasPermission name="dca:dcaWorkflowBasicIdx:edit">
						<td><a
							href="${ctx}/dca/dcaWorkflowBasicIdx/form?id=${dcaWorkflowBasicIdx.idxId}"
							class="btn-s btn-opear">修改</a> <a
							href="${ctx}/dca/dcaWorkflowBasicIdx/delete?id=${dcaWorkflowBasicIdx.idxId}"
							class="btn-s btn-opear"
							onclick="return confirmx('确认要删除该条数据吗？', this.href)">删除</a></td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<div class="text-center">
			<span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span>
		</div>
	</c:if>
	<div class="pagination">${page}</div>
</body>
</html>