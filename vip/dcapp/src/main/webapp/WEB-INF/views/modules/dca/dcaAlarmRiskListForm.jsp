<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险清单管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<script src="/assets/dca/js/jquery.alarmrisk.form.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {

		});
	</script>
</head>
<body>
	<br/><br/><br/>
	<form:form id="inputForm" modelAttribute="dcaAlarmRiskList" action="${ctx}/dca/dcaAlarmRiskList/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>			
		<div class="control-group">
			<label class="control-label">风险名称：</label>
			<div class="controls">
				<input id="oldName" name="oldRiskName" type="hidden" value="${dcaAlarmRiskList.riskName}">
				<c:if test="${dcaAlarmRiskList.workFlowFlag == 'true'}">
					<form:input path="riskName" htmlEscape="true" maxlength="30" class="input-xlarge required" disabled="true"/>
				</c:if>
				<c:if test="${dcaAlarmRiskList.workFlowFlag != 'true'}">
					<form:input path="riskName" htmlEscape="true" maxlength="30" class="input-xlarge required" />
				</c:if>
				<span class="help-inline"><font color="red">*</font></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权力：</label>
			<div class="controls">
				<c:if test="${not empty dcaAlarmRiskList.riskId}">		
					<form:input path="powerId" htmlEscape="false" class="input-xlarge required" disabled="true" value="${fns:getDictLabel(dcaAlarmRiskList.powerId,'power_id','') }"/>
					<input type="hidden" data-power="power" value="${dcaAlarmRiskList.powerId}"> 
				</c:if>
				<c:if test="${empty dcaAlarmRiskList.riskId}">
					<form:select path="powerId" class="input-xlarge required" data-power="power">	
						<form:option value="" label="请选择"/>				
						<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</c:if>	
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">风险类型：</label>
			<div class="controls">				
				<form:select path="riskType" class="input-xlarge required">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('risk_type_detail')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>				
		<div class="control-group">
			<label class="control-label">风险环节：</label>
			<div class="controls">
				<form:input path="riskTask" htmlEscape="true" maxlength="16" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">风险内容：</label>
			<div class="controls">
				<form:textarea path="riskContent" htmlEscape="true" maxlength="300" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">风险等级：</label>
			<div class="controls">
				<form:select path="riskLevel" class="input-xlarge required">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('risk_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">防范措施：</label>
			<div class="controls">
				<form:textarea path="measure" htmlEscape="true" maxlength="300" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="dca:dcaAlarmRiskList:edit"><input id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>