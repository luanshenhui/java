<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险清单管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<script src="/assets/dca/js/jquery.alarmrisk.list.js" type="text/javascript"></script>
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
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/dca/dcaAlarmRiskList/import" method="post" enctype="multipart/form-data"
			class="form-search" style="padding-left:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
			<a href="${ctx}/dca/dcaAlarmRiskList/import/template">下载模板</a>
		</form>
	</div>
	<form:form id="searchForm" modelAttribute="dcaAlarmRiskList" action="${ctx}/dca/dcaAlarmRiskList/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>权力：</label>
				<form:select path="powerId" class="input-medium">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>风险类型：</label>
				<form:select path="riskType" class="input-medium">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('risk_type_detail')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>风险等级：</label>
				<form:select path="riskLevel" class="input-medium">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('risk_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button></li>			
			<shiro:hasPermission name="dca:dcaAlarmRiskList:edit">
			<li class="btns pull-right"><a id="btnImport" class="btn-s btn-add" type="button" value="批量导入"><i>+</i>批量导入</a></li>			
			<li class="btns pull-right"><a href="${ctx}/dca/dcaAlarmRiskList/form" class="btn-s btn-add"><i>+</i>新建</a></li>			
			</shiro:hasPermission>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="10%">权力</th>
				<th width="10%">风险名称</th>
				<th width="10%">风险类型</th>
				<th width="15%">风险环节</th>
				<th width="15%">风险内容</th>
				<th width="5%">风险等级</th>
				<th width="10%">防范措施</th>
				<shiro:hasPermission name="dca:dcaAlarmRiskList:edit"><th width="20%">操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaAlarmRiskList" step="1" varStatus="alarmRiskListStatus">
			<tr>
				<td>
					<c:out value="${alarmRiskListStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/>
				</td>
				<td><a href="${ctx}/dca/dcaAlarmRiskList/form?id=${dcaAlarmRiskList.riskId}">
					<c:out value="${fns:getDictLabel(dcaAlarmRiskList.powerId, 'power_id', '')}"/>
				</a></td>
				<td>
					<c:out value="${dcaAlarmRiskList.riskName}"/>
				</td>
				<td>
					<c:out value="${fns:getDictLabel(dcaAlarmRiskList.riskType, 'risk_type_detail', '')}"/>
				</td>
				<td title="<c:out value="${dcaAlarmRiskList.riskTask}"/>">
					<c:out value="${dcaAlarmRiskList.riskTask}"/>
				</td>
				<td title="<c:out value="${dcaAlarmRiskList.riskContent}"/>">
					<c:out value="${dcaAlarmRiskList.riskContent}"/>					
				</td>
				<td>
					<c:out value="${fns:getDictLabel(dcaAlarmRiskList.riskLevel, 'risk_level', '')}"/>					
				</td>
				<td title="<c:out value="${dcaAlarmRiskList.measure}"/>">
					<c:out value="${dcaAlarmRiskList.measure}"/>
				</td>
				<shiro:hasPermission name="dca:dcaAlarmRiskList:edit"><td>
    				<a href="${ctx}/dca/dcaAlarmRiskList/form?id=${dcaAlarmRiskList.riskId}" class="btn-s btn-opear">修改</a>
					<a href="${ctx}/dca/dcaAlarmRiskList/delete?id=${dcaAlarmRiskList.riskId}" onclick="return confirmx('确认要删除该风险清单吗？', this.href)" class="btn-s btn-opear">删除</a>
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