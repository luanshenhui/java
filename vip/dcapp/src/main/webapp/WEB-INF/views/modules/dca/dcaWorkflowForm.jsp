<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工作流管理</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/workFlowForm.css">
	<dca:resources />
    <script src="/assets/dca/js/jquery.workflow.form.js" type="text/javascript"></script>  
	<script type="text/javascript">
	
	$(document).ready(function() {

		});

	</script>
</head>
<body>
<div id="WorkFlowForm">
	<input type="hidden" value="${dcaWorkflow.idxDataType}" id="idx-data-type">
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/dca/dcaWorkflow/">工作流管理列表</a></li>
		<li class="active"><a href="${ctx}/dca/dcaWorkflow/form?id=${dcaWorkflow.id}">工作流管理<shiro:hasPermission name="workflow:dcaWorkflow:edit">${not empty dcaWorkflow.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="workflow:dcaWorkflow:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%><br/>
	<form:form id="inputForm" modelAttribute="dcaWorkflow" action="${ctx}/dca/dcaWorkflow/save" method="post" class="form-horizontal">
		<form:input type="hidden" path="idxDataType" id="save-idxDataType"/>
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label font-normal">工作流名称：</label>
			<div class="controls">
			    <input id="oldwfName" name="oldwfName" type="hidden" value="${dcaWorkflow.wfName}">
			    <!-- 新建 -->
			    <c:if test="${empty dcaWorkflow.id}">
			    <form:input path="wfName" placeholder="输入80位以内工作流名称" htmlEscape="true" maxlength="80" id="workFlowName" class="input-xlarge required" disabled="false"/>
			    </c:if>
			   <!--  编辑 -->
			    <c:if test="${not empty dcaWorkflow.id}">
			     <form:input path="wfName" placeholder="输入80位以内工作流名称" htmlEscape="true" maxlength="80" id="workFlowName" class="input-xlarge required" disabled="true"/>
			     <form:hidden path="wfName" />
			    </c:if>
				
				<span class="help-inline"><font class="font-red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">权力：</label>
			<div class="controls powerId" >
				<form:select path="powerId" class="input-xlarge required">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<input class="${not empty dcaWorkflow.id?'':'hide'} powerIdDisable" />
				<span class="help-inline"><font class="font-red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">开始时间：</label>
			<div class="controls">
				<input id="startTime" name="startTime" type="text" readonly="readonly" maxlength="20" class="input-date Wdate "
					value="<fmt:formatDate value="${dcaWorkflow.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">结束时间：</label>
			<div class="controls">
				<input id="endTime" name="endTime" type="text" readonly="readonly" maxlength="20" class="input-date Wdate "
					value="<fmt:formatDate value="${dcaWorkflow.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
			</div>
		</div>
		<%-- 
		<div class="control-group">
			<label class="control-label">状态：</label>
			<div class="controls">
				<form:select path="isShow" class="input-xlarge ">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('wf_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		 --%>
		<div class="control-group">
			<label class="control-label font-normal">优先级：</label>
			<div class="controls">
				<form:select path="wfLevel" class="input-xlarge required">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font class="font-red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">模板ID：</label>
			<div class="controls">
				<form:input path="traceDictId" htmlEscape="true" maxlength="30" class="input-xlarge required" />
				<span class="help-inline"><font class="font-red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">业务类型：</label>
			<div class="controls">
			    <input type="button" value="选择" class="clickPop btn-s btn-opear">
			        <div class="controls m-l-0 pull-left">
						<form:textarea path="idxDataTypeName"  id="dds" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge required data-area"  readonly="true"/>
						<span class="help-inline"><font class="font-red">*</font> </span>
				    </div> 
				    <div class="pop">
					<label>选择业务类型：(可多选)</label>
						<ul id="yaw" class="dataTypeCheckBox" >
						    
						</ul>
						<div class="editBtn" >
							<button type="button" class="shut btn-s btn-opear" >确定</button>
							<!-- <button type="button" class="shut" style="padding:3px 5px;">取消</button> -->
						</div>
					</div>
			</div>
			<!--
				<c:forEach items="${fns:getDictList('idx_data_type')}" var="data_type" step="1">
				<li><input type="checkbox" name="idx_data_type" value="${dcaWorkflow.idxDataType}">${data_type}</li>
				</c:forEach>
			   
				<form:select path="idxDataType" class="input-xlarge required">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('idx_data_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			-->
		</div>
		<div class="control-group">
			<label class="control-label font-normal">说明：</label>
			<div class="controls">
				<form:textarea path="remarks" placeholder="输入60位以内说明" htmlEscape="true" maxlength="60" rows="4"  class="input-xxlarge"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="workflow:dcaWorkflow:edit"><button id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存" >保 存</button>&nbsp;</shiro:hasPermission>
			<button id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)">返 回</button>
		</div>
	</form:form>
</div>
</body>
</html>