<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
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
		<li class="active"><a href="${ctx}/sys/dict/">字典列表</a></li>
		<shiro:hasPermission name="sys:dict:edit"><li><a href="${ctx}/sys/dict/form?sort=10">字典添加</a></li></shiro:hasPermission>
	</ul> --%>
	<form:form id="searchForm" modelAttribute="dict" action="${ctx}/sys/dict/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label class="font-normal">类型：</label><form:select id="type" path="type" class="input-medium"><form:option value="" label=""/><form:options items="${typeList}" htmlEscape="false"/></form:select>
		&nbsp;&nbsp;<label class="font-normal">描述 ：</label><form:input path="description" htmlEscape="false" maxlength="50" class="input-medium"/>
		&nbsp;<button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button>
		<shiro:hasPermission name="sys:dict:edit"><a href="${ctx}/sys/dict/form?sort=10" class="btn-s btn-add pull-right"><i>+</i>字典添加</a></shiro:hasPermission>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>键值</th><th>标签</th><th>类型</th><th>描述</th><th>排序</th><shiro:hasPermission name="sys:dict:edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="dict">
			<tr>
				<td>${dict.value}</td>
				<td><a href="${ctx}/sys/dict/form?id=${dict.id}">${dict.label}</a></td>
				<td><a href="javascript:" onclick="$('#type').val('${dict.type}');$('#searchForm').submit();return false;">${dict.type}</a></td>
				<td>${dict.description}</td>
				<td>${dict.sort}</td>
				<shiro:hasPermission name="sys:dict:edit"><td>
    				<a href="${ctx}/sys/dict/form?id=${dict.id}" class="btn-s btn-opear">修改</a>
					<a href="${ctx}/sys/dict/delete?id=${dict.id}&type=${dict.type}" class="btn-s btn-opear" onclick="return confirmx('确认要删除该字典吗？', this.href)">删除</a>
    				<a href="<c:url value='${fns:getAdminPath()}/sys/dict/form?type=${dict.type}&sort=${dict.sort+10}'><c:param name='description' value='${dict.description}'/></c:url>" class="btn-s btn-opear">添加键值</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>