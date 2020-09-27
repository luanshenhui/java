<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>物理表管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<script src="/assets/dca/js/jquery.autocompleter.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/basicDataManage.css">
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

	<style type="text/css" mce_bogus="1">

	</style>

</head>
<body>
	<form:form id="searchForm" modelAttribute="dcaTopicPhysics" action="${ctx}/dca/dcaBasicDataManage/getBasicDataDetail"
			   method="post" class="breadcrumb form-search">
		<input id="id" name="id" type="hidden" value="${dataEntity.tableName}"/>
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li>
				<c:if test="${dataEntity.topicName != null}">
					<span class="font-normal">主题库：<c:out value="${dataEntity.topicName}"/></span>
				</c:if>
			</li>

			<li>
				<c:if test="${dataEntity.tableName != null}">
					<span class="font-normal m-l-medium">物理表英文名：<c:out value="${dataEntity.tableName}"/></span>
				</c:if>
			</li>

			<li>
				<c:if test="${dataEntity.tableComment != null}">
					<span class="font-normal m-l-medium">物理表中文名：<c:out value="${dataEntity.tableComment}"/></span>
				</c:if>
			</li>

			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<div class="overflow-x">
		<table id="contentTable" class="table table-striped table-bordered table-condensed tab_css_1">
			<thead>
				<tr>
					<th width="5%">序号</th>
					<c:forEach items="${columnList}" var="column">
						<th>
							<c:out value="${column}"/>
						</th>
					</c:forEach>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="dataItem" varStatus="status">
					<tr>
						<td>
							<c:out value="${status.count + (page.pageNo - 1)*page.pageSize}"/>
						</td>
						<c:forEach items="${columnList}" var="column">
							<td title="<c:out value="${dataItem[column]}"/>">
								<c:out value="${dataItem[column]}"/>
							</td>
						</c:forEach>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<c:if test="${empty page.list}">
		<p class="text-center font-normal">没有符合条件的信息，请尝试其他搜索条件。</p>
	</c:if>
	<div class="pagination">${page}</div>
</body>
</html>