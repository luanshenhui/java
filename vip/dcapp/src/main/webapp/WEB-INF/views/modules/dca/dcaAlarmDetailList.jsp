<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>告警查询管理</title>
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/alarmDetailList.css" />
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
		<li class="active"><a href="${ctx}/dca/dcaAlarmDetail/">告警查询列表</a></li>
	</ul> --%>
	<form:form id="searchForm" modelAttribute="dcaAlarmDetail" action="${ctx}/dca/dcaAlarmDetail/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li>
				<label class="font-normal">所属部门：</label>
				<sys:treeselect id="bizOperPost" name="bizOperPost" value="${dcaAlarmDetail.bizOperPost}" labelName="bizOperPostName" labelValue="${dcaAlarmDetail.bizOperPostName}"
						title="所属部门" url="/sys/office/treeData?type=2" allowClear="true" notAllowSelectParent="false" />
			</li>
			<li>
				<label class="font-normal">操作人：</label>
				<form:input path="bizOperPerson" htmlEscape="true" maxlength="50" class="input-small"/>
			</li>
			<li>
				<label class="font-normal">告警状态：</label>
				<form:select path="alarmStatus" class="input-small">
					<form:option value="0" label=" "/>
					<form:options items="${fns:getDictList('alarm_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li>
				<label class="font-normal">告警等级：</label>
				<form:select path="alarmLevel" class="input-small">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('alarm_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="4%">序号</th>
				<th width="15%">业务事项</th>
				<th width="11%">操作人</th>
				<th width="10%">所属部门</th>
				<th width="20%">办理事项</th>
				<th width="20%">告警内容</th>
				<th width="10%">告警等级</th>
				<th width="10%">告警状态</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaAlarmDetail" varStatus="flowStatus">
			<tr>
				<td><c:out value="${flowStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/></td>
				<td title="<c:out value="${dcaAlarmDetail.bizFlowName}" />"><c:out value="${dcaAlarmDetail.bizFlowName}" /></td>
				<td><c:out value="${dcaAlarmDetail.bizOperPerson}" /></td>
				<td><c:out value="${dcaAlarmDetail.bizOperPostName}" /></td>
				<td title="<c:out value="${dcaAlarmDetail.bizDataName}" />"><c:out value="${dcaAlarmDetail.bizDataName}" /></td>
				<td title="<c:out value="${dcaAlarmDetail.alarmMsg}" />"><c:out value="${dcaAlarmDetail.alarmMsg}" /></td>
				<c:if test="${dcaAlarmDetail.alarmLevel == '1'}">
					<td class="green"><c:out value="●" /></td>
				</c:if>
				<c:if test="${dcaAlarmDetail.alarmLevel == '2'}">
					<td class="yellow"><c:out value="●" /></td>
				</c:if>
				<c:if test="${dcaAlarmDetail.alarmLevel == '3'}">
					<td class="orange"><c:out value="●" /></td>
				</c:if>
				<c:if test="${dcaAlarmDetail.alarmLevel == '4'}">
					<td class="red"><c:out value="●" /></td>
				</c:if>
				<td><c:out value="${fns:getDictLabel(dcaAlarmDetail.alarmStatus, 'alarm_status', '')}" /></td>
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