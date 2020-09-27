<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险界定</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/riskManage.css" />
	<script src="/assets/dca/js/jquery.riskmanage.define.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>
<body>
	<br/><br/><br/>
	<form:form id="inputForm" modelAttribute="dcaRiskManage" action="${ctx}/dca/dcaRiskManage/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<div class="control-group">
			<label class="control-label">风险级别：</label>
			<div class="controls">
				<c:choose>
						<c:when test="${dcaRiskManage.alarmLevel == '1'}">
							<div class="circle green-background"></div>
						</c:when>
						<c:when test="${dcaRiskManage.alarmLevel == '2'}">
							<div class="circle yellow-background"></div>
						</c:when>
						<c:when test="${dcaRiskManage.alarmLevel == '3'}">
							<div class="circle orange-background"></div>
						</c:when>						
						<c:when test="${dcaRiskManage.alarmLevel == '4'}">
							<div class="circle red-background"></div>
						</c:when>
					</c:choose>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">风险维度：</label>
			<div class="controls">
				<span><c:out value="${fns:getDictLabel(dcaRiskManage.alarmType, 'alarm_type', '')}"/></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">风险内容：</label>
			<div class="controls">
				<span><c:out value="${dcaRiskManage.riskMsg }"/></span>
			</div>
		</div>
		
		<div class="control-group">
			<label class="control-label">界定人：</label>
			<div class="controls">
				<span><c:out value="${dcaRiskManage.definePerson }"/></span>
			</div>
		</div>	
		<div class="control-group">
			<label class="control-label"><font color="red">*</font>界定结果：</label>
			<div class="controls">
				<form:radiobutton path="defineStatus" htmlEscape="false" value="1" checked="true"/>风险
				<form:radiobutton path="defineStatus" htmlEscape="false" value="2"/>非风险 
			</div>
		</div>			
		<div class="control-group">
			<label class="control-label"><font color="red">*</font>界定材料：</label>
			<div class="controls">				
				<form:hidden id="evidence" path="evidence" htmlEscape="false" maxlength="255" class="input-xlarge" cssClass="required"/>
				<sys:ckfinder input="evidence" type="files" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">说明：</label>
			<div class="controls">
				<form:textarea path="explains" htmlEscape="true" rows="4" maxlength="160" class="input-xxlarge"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="dca:dcaRiskManage:edit"><input id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
		
		<div class="control-group">
			<label class="control-label">界定履历：</label>
			<div class="controls">
				<c:forEach items="${logList}" var="dcaRiskManageLog">
					<span>${dcaRiskManageLog.createPerson} &nbsp;&nbsp; ${dcaRiskManageLog.action } &nbsp;&nbsp; <fmt:formatDate value="${dcaRiskManageLog.createDate }" pattern="yyyy-MM-dd HH:mm:ss" /></span><br/>
				</c:forEach>
			</div>
		</div>				
	</form:form>
</body>
</html>