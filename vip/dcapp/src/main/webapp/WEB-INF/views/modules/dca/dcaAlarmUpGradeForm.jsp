<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>告警上报管理管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<script src="/assets/dca/js/jquery.alarm.up.grade.form.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/dca/dcaAlarmUpGrade/">告警上报管理列表</a></li>
		<li class="active"><a href="${ctx}/dca/dcaAlarmUpGrade/form?uuid=${dcaAlarmUpGrade.uuid}">告警上报管理<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit">${not empty dcaAlarmUpGrade.uuid?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="dca:dcaAlarmUpGrade:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/> --%>
	<form:form id="inputForm" modelAttribute="dcaAlarmUpGrade" action="${ctx}/dca/dcaAlarmUpGrade/save" method="post" class="form-horizontal span12">
		<form:hidden path="uuid"/>
		<form:hidden path="gradeOrgPostOld" value="${dcaAlarmUpGrade.gradeOrgPost}"/>
		<sys:message content="${message}"/>
		<div class="control-group">
			<label class="control-label font-normal">权力：</label>
			<div class="controls">
				<!-- 修改 -->
				<c:if test="${not empty dcaAlarmUpGrade.uuid}">
					<form:input path="powerName" htmlEscape="true" maxlength="5" class="input-xlarge required" disabled="true"/>
					<form:hidden path="powerId"/>
				</c:if>
				<!-- 新建 -->
				<c:if test="${empty dcaAlarmUpGrade.uuid}">
					<form:select path="powerId" class="input-xlarge required">
						<form:option value="" label="请选择"/>
						<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="true"/>
					</form:select>
				</c:if>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">业务角色：</label>
			<div class="controls">
				<!-- 修改 -->
				<c:if test="${not empty dcaAlarmUpGrade.uuid}">
					<form:input path="bizRoleName" htmlEscape="true" maxlength="100" class="input-xlarge required" disabled="true"/>
					<form:hidden path="bizRoleId"/>
				</c:if>
				<!-- 新建 -->
				<c:if test="${empty dcaAlarmUpGrade.uuid}">
					<form:select path="bizRoleId" class="input-xlarge required">
						<form:option value="" label="请选择"/>
					</form:select>
				</c:if>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">告警等级：</label>
			<div class="controls">
				<!-- 修改 -->
				<c:if test="${not empty dcaAlarmUpGrade.uuid}">
					<form:input path="alarmLevelName" htmlEscape="true" maxlength="5" class="input-xlarge required" disabled="true"/>
					<form:hidden path="alarmLevel"/>
				</c:if>
				<!-- 新建 -->
				<c:if test="${empty dcaAlarmUpGrade.uuid}">
					<form:select path="alarmLevel" class="input-xlarge required">
						<form:option value="" label="请选择"/>
						<form:options items="${fns:getDictList('alarm_level')}" itemLabel="label" itemValue="value" htmlEscape="true"/>
					</form:select>
				</c:if>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">累计超期时间（小时）：</label>
			<div class="controls">
				<!-- 修改 -->
				<c:if test="${not empty dcaAlarmUpGrade.uuid}">
					<form:input path="sumOutTimeName" htmlEscape="true" class="input-xlarge required digits" disabled="true" maxlength="8"/>
					<form:hidden path="sumOutTime"/>
				</c:if>
				<!-- 新建 -->
				<c:if test="${empty dcaAlarmUpGrade.uuid}">
					<form:input path="sumOutTime" htmlEscape="true" class="input-xlarge required digits" maxlength="8"/>
				</c:if>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">上报岗位：</label>
			<div class="controls">
				<sys:treeselect id="gradeOrgPost" name="gradeOrgPost" value="${dcaAlarmUpGrade.gradeOrgPost}" labelName="gradeOrgPostName" labelValue="${dcaAlarmUpGrade.gradeOrgPostName}"
						title="岗位" url="/sys/dcaTraceUserRole/treeData" cssClass="required" allowClear="true"  dataMsgRequired="必填信息"
						notAllowSelectParent="false" checked="true"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">备注：</label>
			<div class="controls">
				<form:textarea path="remarksNew" htmlEscape="true" rows="4" maxlength="60" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit"><input id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>