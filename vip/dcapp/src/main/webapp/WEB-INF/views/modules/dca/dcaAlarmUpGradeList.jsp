<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>告警上报管理管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<script src="/assets/dca/js/jquery.alarm.up.grade.list.js" type="text/javascript"></script>
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
	<%--  <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/dca/dcaAlarmUpGrade/">告警上报管理列表</a></li>
		<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit"><li><a href="${ctx}/dca/dcaAlarmUpGrade/form">告警上报管理添加</a></li></shiro:hasPermission>
	</ul> --%>
	<form:form id="searchForm" modelAttribute="dcaAlarmUpGrade" action="${ctx}/dca/dcaAlarmUpGrade/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="bizRoleIdSelected" type="hidden" value="${bizRoleIdSelected}"/>
		
		<ul class="ul-form">
			<li><label class="font-normal">权力：</label>
				<form:select path="powerId" class="input-medium">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="true"/>
				</form:select>
			</li>
			<li><label class="font-normal">业务角色：</label>
				<form:select path="bizRoleId" class="input-medium">
					<form:option value="" label=" "/>
				</form:select>
			</li>
			<li><label class="font-normal">告警等级：</label>
				<form:select path="alarmLevel" class="input-medium">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('alarm_level')}" itemLabel="label" itemValue="value" htmlEscape="true"/>
				</form:select>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button></li>
			<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit"><li class="btns pull-right"><a href="${ctx}/dca/dcaAlarmUpGrade/form"class="btn-s btn-add "><i>+</i>新建</a></li></shiro:hasPermission>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>序号</th>
				<th>权力</th>
				<th>业务角色</th>
				<th>告警等级</th>
				<th>累计超期时间（小时）</th>
				<th>上报岗位</th>
				<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaAlarmUpGrade" step="1" varStatus="alarmUpGradeStatus">
			<tr>
				<td>
					<c:out value="${alarmUpGradeStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/>
				</td>
				<td>
					${fns:getDictLabel(dcaAlarmUpGrade.powerId, 'power_id', '')}
				</td>
				<td title="<c:out value="${dcaAlarmUpGrade.bizRoleName}"/>">
					<c:out value="${dcaAlarmUpGrade.bizRoleName}"/>
				</td>
				<td>
					<c:out value="${fns:getDictLabel(dcaAlarmUpGrade.alarmLevel, 'alarm_level', '')}" />
				</td>
				<td>
					<c:out value="${dcaAlarmUpGrade.sumOutTime}"/>
				</td>
				<td title="<c:out value="${dcaAlarmUpGrade.orgName}"/>">
					<c:out value="${dcaAlarmUpGrade.orgName}" />
				</td>
				<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit"><td>
    				<a href="${ctx}/dca/dcaAlarmUpGrade/modify?uuid=${dcaAlarmUpGrade.uuid}" class="btn-s btn-opear">修改</a>
					<a href="${ctx}/dca/dcaAlarmUpGrade/delete?uuid=${dcaAlarmUpGrade.uuid}" class="btn-s btn-opear" onclick="return confirmx('是否确认删除？删除后不可恢复！', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<div class="text-center"><span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span></div>
	</c:if>
	<div class="pagination">${page}</div>
	
</body>
</html>