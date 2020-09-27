<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>数据版本管理</title>
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
	<form:form id="searchForm" modelAttribute="dcaEtlJobItemLog" action="${ctx}/dca/dcaEtlJobItemLog/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li>
				<label class="font-normal" style="width: 100px;">物理表英文名：</label>
				<form:input path="stepname" htmlEscape="true" maxlength="85" class="input-small"/>
			</li>
			<li>
				<label class="font-normal">执行结果：</label>
				<form:select path="result" class="input-small">
					<form:option value="" label=""/>
					<form:option value="0" label="失败"/>
					<form:option value="1" label="成功"/>
				</form:select>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="40%">物理表英文名</th>
				<th width="20%">最近更新时间</th>
				<th width="10%">执行结果</th>
				<shiro:hasPermission name="dca:dcaEtlJobItemLog:view">
					<th width="10%">操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaEtlJobItemLog" varStatus="status">
			<tr>
				<td>
					<c:out value="${status.index + (1 + (page.pageNo - 1) * pageSize)}"/>
				</td>
				<td>
					<c:out value="${dcaEtlJobItemLog.stepname}"/>
				</td>
				<td>
					<fmt:formatDate value="${dcaEtlJobItemLog.logDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<c:choose>
						<c:when test="${dcaEtlJobItemLog.result == 0}">
							<c:out value="失败"></c:out>
						</c:when>
						<c:otherwise>
							<c:out value="成功"></c:out>
						</c:otherwise>
					</c:choose>
				</td>
				<shiro:hasPermission name="dca:dcaEtlJobItemLog:view">
					<td>
    					<a href="${ctx}/dca/dcaEtlJobItemLog/findDetailByStepname?stepname=${dcaEtlJobItemLog.stepname}">查看详细</a>
					</td>
				</shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>