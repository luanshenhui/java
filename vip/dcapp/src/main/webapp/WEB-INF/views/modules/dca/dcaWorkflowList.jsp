<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>工作流管理管理</title>
<meta name="decorator" content="default" />
<link rel="stylesheet" type="text/css" href="/assets/dca/css/workFlowList.css"> 
<script src="/assets/dca/js/jquery.workflow.list.js" type="text/javascript"></script>
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
<div id="workFlowList"> 
	<form:form id="searchForm" modelAttribute="dcaWorkflow"
		action="${ctx}/dca/dcaWorkflow/" method="post"
		class="breadcrumb form-search">
		<form:input  path="editEnable" type="hidden" value="${editEnable}" data-id="editEnable"/> 
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li>
				<label class="font-normal label-width-75">工作流名称：</label> 
				<form:input path="wfName" htmlEscape="true" maxlength="30" class="input-medium" />
			</li>
			<li>
				<label class="font-normal label-width-50">权力：</label>
				<form:select path="powerId" class="input-medium">
					<form:option value="" label=" " />
					<form:options items="${fns:getDictList('power_id')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</li>
			<li>
				<label class="font-normal label-width-65">业务类型：</label>
				<form:select path="idxDataType" class="input-medium">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('idx_data_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</li>
			<li>
				<label class="font-normal label-width-50">状态：</label>
				<form:select path="isShow" class="input-medium">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('wf_status')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value="查询" ><i class="icon-search-1"></i>查询</button>
			</li>
			<shiro:hasPermission name="dca:dcaTopicLib:edit">
				<li  class="btns pull-right">
					<a href="${ctx}/dca/dcaWorkflow/form" class="btn-s btn-add btn-margin-top"><i>+</i>新 建</a>
				</li>
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
				<th width="10%">业务类型</th>
				<th width="25%">工作流名称</th>
				<th width="20%">权力</th>
				<th width="5%">优先级</th>
				<th width="5%">状态</th>
				
				<shiro:hasPermission name="workflow:dcaWorkflow:edit">
					<th width="30%">操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="dcaWorkflow" step="1" varStatus="flowStatus">
				<tr>
					<td><c:out value="${flowStatus.index + (1 + (page.pageNo - 1) * pageSize)}"/></td>
					<td>
						<c:set var="idt" value="${fn:split(dcaWorkflow.idxDataType, '||')}" />
						 <c:forEach items="${idt}" var="idt" varStatus="status">
							  <c:out value="${status.index+1}.${fns:getDictLabel(idt, 'idx_data_type', '')}"/>
							  <br/>
						</c:forEach>
					</td>
					<td class="nowrap"><c:out value="${dcaWorkflow.wfName}"/></td>
					<td class="nowrap"><c:out value="${fns:getDictLabel(dcaWorkflow.powerId, 'power_id', '')}"/></td>
					<td><c:out value="${fns:getDictLabel(dcaWorkflow.wfLevel, 'level', '')}"/></td>
					<td><c:out value="${fns:getDictLabel(dcaWorkflow.isShow, 'wf_status', '')}"/></td>

					<shiro:hasPermission name="workflow:dcaWorkflow:edit">
						<td>	
						  <input value="${dcaWorkflow.wfId}" type="hidden" data-id="dcaWorkflow-wfId"/>					
							<c:if test="${dcaWorkflow.isShow=='0'}">
							  <a class="startGreen btn-s btn-opear"
							    onclick="return confirmx('是否确定“启动”此工作流？', this.href)"
								href="${ctx}/dca/dcaWorkflow/startWorkFlow?id=${dcaWorkflow.wfId}" data-value="${dcaWorkflow.num}">启动</a>
							</c:if >						
							<c:if test="${dcaWorkflow.isShow=='1'}">
								<a class="stopRed btn-s btn-opear"
								    onclick="return confirmx('是否确定“停用”此工作流？', this.href)"
									href="${ctx}/dca/dcaWorkflow/stopWorkFlow?id=${dcaWorkflow.wfId}">停用</a>
							</c:if>
							<a id="edit" class="btn-s btn-opear editCheck" data-value="${dcaWorkflow.wfId}">编辑</a>
							<a id="processSetting" class="btn-s btn-opear processSettingCheck">流程设置</a>
							<a id="delete"  class="btn-s btn-opear deleteCheck">删除</a>
						</td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<div class="noteNull " ><span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span></div>
	</c:if>
	<div class="pagination">${page}</div>
</div>
</body>
</html>