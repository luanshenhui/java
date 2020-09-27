<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>告警指标管理管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules: {
					idxName: {remote: "${ctx}/dca/dcaWorkflowBasicIdx/checkName?oldIdxName=" + encodeURIComponent('${dcaWorkflowBasicIdx.idxName}')},
					idxSql: {remote: "${ctx}/dca/dcaWorkflowBasicIdx/sqlValidate?oldIdxSql=" + encodeURIComponent('${dcaWorkflowBasicIdx.idxSql}')}
				},
				messages: {
					idxName: {remote: "指标名称不能重复，该名称已存在！"},
					idxSql: {remote: "SQL不合法，请重新录入！"}
				},
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/dca/dcaWorkflowBasicIdx/">告警指标管理列表</a></li>
		<li class="active"><a href="${ctx}/dca/dcaWorkflowBasicIdx/form?id=${dcaWorkflowBasicIdx.id}">告警指标管理<shiro:hasPermission name="dca:dcaWorkflowBasicIdx:edit">${not empty dcaWorkflowBasicIdx.idxId?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="dca:dcaWorkflowBasicIdx:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/> --%>
	<form:form id="inputForm" modelAttribute="dcaWorkflowBasicIdx" action="${ctx}/dca/dcaWorkflowBasicIdx/save" method="post" class="form-horizontal span12">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group" style="position:relative">
			<label class="control-label font-normal">指标名称：</label>
			<div class="controls">
				<input id="oldIdxName" name="oldIdxName" type="hidden" value="${dcaWorkflowBasicIdx.idxName}">
				<!-- 新建 -->
				<c:if test="${empty dcaWorkflowBasicIdx.id}">
				<form:input path="idxName" htmlEscape="true" maxlength="30" class="input-xlarge required" disabled="false"/>
				</c:if>
				<!-- 编辑 -->
				<c:if test="${not empty dcaWorkflowBasicIdx.id}">
				<form:input path="idxName" htmlEscape="true" maxlength="30" class="input-xlarge required" disabled="true"/>
				<form:hidden path="idxName"/>
				</c:if>
				<%-- <form:input path="idxName" htmlEscape="true" maxlength="30" class="input-xlarge required" readonly="${not empty dcaWorkflowBasicIdx.id?'true':'false'}" disabled="${not empty dcaWorkflowBasicIdx.id?'true':'false'}"/> --%>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">业务类型：</label>
			<div class="controls">
				<form:select path="idxDataType" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('idx_data_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		
		<div class="control-group">
			<label class="control-label font-normal">SQL语句：</label>
			<div class="controls">
				<input id="oldIdxSql" name="oldIdxSql" type="hidden" value="${dcaWorkflowBasicIdx.idxSql}">
				<form:textarea path="idxSql" htmlEscape="true" maxlength="600" class="input-xlarge required" placeholder="只允许输入selec语句，例如：select * from 表名"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">备注：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="true" maxlength="60" class="input-xxlarge" rows="4"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="dca:dcaWorkflowBasicIdx:edit"><input id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>