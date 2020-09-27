<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险查看</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/riskManage.css" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>
<body>
	<br/><br/><br/>
	<div class="form-horizontal">
	<c:set value="${dcaRiskManage}" var="dcaRiskManage"/>
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
			<label class="control-label">界定结果：</label>
			<div class="controls">
				<span><c:out value="${fns:getDictLabel(dcaRiskManage.defineStatus, 'define_status', '')}"/></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">界定人：</label>
			<div class="controls">
				<span><c:out value="${dcaRiskManage.definePerson }"/></span>
			</div>
		</div>		
		<div class="control-group">
			<label class="control-label">界定时间：</label>
			<div class="controls">
				<span><fmt:formatDate value="${dcaRiskManage.defineDate }" pattern="yyyy-MM-dd HH:mm:ss" /></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">界定材料：</label>
			<div class="controls">
				<input id="evidence" name="evidence" type="hidden" value="${dcaRiskManage.evidence}">
				<sys:ckfinder input="evidence" type="files" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">说明：</label>
			<div class="controls">
				<textarea class="input-xxlarge" rows="4" disabled="disabled"><c:out value="${dcaRiskManage.explains }"/></textarea>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">界定履历：</label>
			<div class="controls">
				<c:forEach items="${logList}" var="dcaRiskManageLog">
					<span>${dcaRiskManageLog.createPerson} &nbsp;&nbsp; ${dcaRiskManageLog.action } &nbsp;&nbsp; <fmt:formatDate value="${dcaRiskManageLog.createDate }" pattern="yyyy-MM-dd HH:mm:ss" /></span><br/>
				</c:forEach>
			</div>
		</div>		
		<div class="form-actions">
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</div>
</body>
</html>