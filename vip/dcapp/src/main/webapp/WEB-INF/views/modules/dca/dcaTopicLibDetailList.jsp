<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主题库详情查看</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<script src="/assets/dca/js/jquery.autocompleter.js" type="text/javascript"></script>
	<script src="/assets/dca/js/jquery.topicPhysicsList.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/topicPhysicsList.css"> 
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
	<form:form id="searchForm" modelAttribute="dcaTopicLib" action="${ctx}/dca/dcaTopicLib/topicLibDetail" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="topicId" name="topicId" type="hidden" value="${dcaTopicLib.topicId}"/>
		<ul class="ul-form">
			<li><label class="font-normal label-width">物理表中文名：</label>
				<form:input path="tableComment" id="auto" htmlEscape="true" maxlength="200" class="input-medium required" />
				<div class="intelSearchDiv">
					<c:forEach items="${page.list}" var="dcaTopicLib">
						<p class="intelSearch">${dcaTopicLib.tableComment}</p>
					</c:forEach>
				</div>
			</li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value=""><i class="icon-search-1"></i>查询</button>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="20%">主题库</th>
				<th width="30%">物理表英文名</th>
				<th width="20%">物理表中文名</th>
				<th width="20%">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="dcaTopicLib" step="1" varStatus="dcaTopicLibStatus">
				<tr>
					<td>
						<c:out value="${dcaTopicLibStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/>
					</td>
					<td>
						<c:out value="${dcaTopicLib.topicName}"/>
					</td>
					<td>
						<c:out value="${dcaTopicLib.tableName}"/>
					</td>
					<td>
						<c:out value="${dcaTopicLib.tableComment}"/>
					</td>
					<td>
	    				<a href="${ctx}/dca/dcaTopicPhysics/showDetail?id=${dcaTopicLib.tableName}" class="btn-s btn-opear">详情</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<p class="text-center font-normal">没有符合条件的信息，请尝试其他搜索条件。</p>
	</c:if>
	<div class="pagination">${page}</div>
</body>
</html>