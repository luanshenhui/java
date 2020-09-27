<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日志管理</title>
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
<!-- 	<ul class="nav nav-tabs"> -->
<%-- 		<li class="active"><a href="${ctx}/sys/log/">日志列表</a></li> --%>
<!-- 	</ul> -->
	<form:form id="searchForm" action="${ctx}/sys/log/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label class="font-normal">操作菜单：</label><input id="title" name="title" type="text" maxlength="50" class="input-mini" value="${log.title}"/>
			<label class="font-normal">用户ID：</label><input id="createBy.id" name="createBy.id" type="text" maxlength="50" class="input-mini" value="${log.createBy.id}"/>
			<label class="font-normal">URI：</label><input id="requestUri" name="requestUri" type="text" maxlength="50" class="input-mini" value="${log.requestUri}"/>
		</div><div style="margin-top:8px;">
			<label class="font-normal">日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate"
				value="<fmt:formatDate value="${log.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate"
				value="<fmt:formatDate value="${log.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;&nbsp;
			&nbsp;<label for="exception"><input id="exception" name="exception" type="checkbox"${log.exception eq '1'?' checked':''} value="1"/>只查询异常信息</label>
			&nbsp;&nbsp;&nbsp;<button id="btnSubmit" class="btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button>
		</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th width="5%">序号</th><th width="9%">操作菜单</th><th width="10%">操作用户</th><th width="8%">所在公司</th><th width="10%">所在部门</th><th width="10%">URI</th><th width="8%">提交方式</th><th width="10%">操作者IP</th><th width="10%">操作时间</th></thead>
		<tbody><%request.setAttribute("strEnter", "\n");request.setAttribute("strTab", "\t");%>
		<c:forEach items="${page.list}" var="log"step="1" varStatus="logStatus">
			<tr>
				<td><c:out value="${logStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/></td>
				<td title="${log.title}">${log.title}</td>
				<td>${log.createBy.name}</td>
				<td>${log.createBy.company.name}</td>
				<td>${log.createBy.office.name}</td>
				<td><strong>${log.requestUri}</strong></td>
				<td>${log.method}</td>
				<td title="${log.remoteAddr}">${log.remoteAddr}</td>
				<td title="<fmt:formatDate value="${log.createDate}" type="both"/>"><fmt:formatDate value="${log.createDate}" type="both"/></td>
			</tr>
			<c:if test="${not empty log.exception}"><tr>
				<td colspan="8" style="word-wrap:break-word;word-break:break-all;">
<%-- 					用户代理: ${log.userAgent}<br/> --%>
<%-- 					提交参数: ${fns:escapeHtml(log.params)} <br/> --%>
					异常信息: <br/>
					${fn:replace(fn:replace(fns:escapeHtml(log.exception), strEnter, '<br/>'), strTab, '&nbsp; &nbsp; ')}</td>
			</tr></c:if>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>