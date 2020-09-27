<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主题库管理管理</title>
	<meta name="decorator" content="default"/>  
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/topicLibList.css" />
	<script src="/assets/dca/js/jquery.topicLibList.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			
			//topicName: {remote: "${ctx}/dca/dcaTopicLib/checkTopicName?oldTopicName=" + encodeURIComponent('${dcaTopicLib.topicName}')}
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
	<div id="topicLibList">
	<%--  <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/dca/dcaTopicLib/">主题库管理列表</a></li>
		<shiro:hasPermission name="dca:dcaTopicLib:edit"><li><a href="${ctx}/dca/dcaTopicLib/form">主题库管理添加</a></li></shiro:hasPermission>
	</ul>  --%>
	<form:form id="searchForm" modelAttribute="dcaTopicLib" action="${ctx}/dca/dcaTopicLib/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label class="font-normal label-width">主题库名称：</label>
				<form:input path="topicName" htmlEscape="true" maxlength="30" class="input-medium"/>
			</li>
			<li><label class="font-normal">状态：</label>
				<form:select path="topicStatus" class="input-medium">
						<form:option value="" label=" " />
						<form:options items="${fns:getDictList('topicStatus')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value=""><i class="icon-search-1"></i>查询</button></li>
			<shiro:hasPermission name="dca:dcaTopicLib:edit"><li class="btns pull-right"><a href="${ctx}/dca/dcaTopicLib/form" class="btn-s btn-add"><i>+</i>新 建</a></li></shiro:hasPermission>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="30%">主题库名称</th>
				<th width="25%">说明</th>
				<th width="10%">状态</th>
				<shiro:hasPermission name="dca:dcaTopicLib:edit"><th width="30%">操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaTopicLib" step="1" varStatus="topicLibStatus">
			<tr>
				<td>
					<c:out value="${topicLibStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/>
				</td>
				<td><a href="${ctx}/dca/dcaTopicLib/form?id=${dcaTopicLib.topicId}">
					
					<c:out value="${dcaTopicLib.topicName}"/>
				</a></td>
				<td title="<c:out value="${dcaTopicLib.remarks}"/>">
				<c:out value="${dcaTopicLib.remarks}"/>
					
				</td>
				<td>
					
					<c:out value="${dcaTopicLib.isShow eq '0'?'停用':'启用'}"/>
					
					
				</td>
				<shiro:hasPermission name="dca:dcaTopicLib:edit"><td>
					
					<input value="${dcaTopicLib.topicId}" type="hidden" data-id="topic-id"/>
					<a  class="btn-s btn-opear showRef" >关联物理表</a>
    				<a href="${ctx}/dca/dcaTopicLib/form?id=${dcaTopicLib.topicId}" class="btn-s btn-opear">编辑</a>
					<a href="${ctx}/dca/dcaTopicLib/delete?id=${dcaTopicLib.topicId}" class="btn-s btn-opear" onclick="return confirmx('确认要删除该主题库管理吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<div class="text-center" ><span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span></div>
	</c:if>
	<div class="pagination">${page}</div>
	</div>
</body>
</html>