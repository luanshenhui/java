<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险转发</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<script src="/assets/dca/js/jquery.riskmanage.trans.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>
<body>
	<br/><br/><br/>
	<form:form id="inputForm" modelAttribute="dcaRiskManage" action="${ctx}/dca/dcaRiskManage/trans" method="post" class="form-horizontal">
		<form:hidden path="riskManageId" value="${dcaRiskManage.riskManageId}"/>
		<sys:message content="${message}"/>	
		<div class="control-group">
			<label class="control-label">风险转发给：</label>
			<div class="controls">
				<sys:treeselect id="bizOperPerson" name="bizOperPerson" value="${dcaRiskManage.bizOperPerson}" labelName="bizOperPersonName" labelValue="${dcaRiskManage.bizOperPersonName}"
						title="转发人员" url="/sys/office/treeData?type=3" cssClass="required" dataMsgRequired="请指定一个以上的转发人。" allowClear="true" notAllowSelectParent="true" checked="true" isAll="true"/>
			</div>
		</div>
		<div class="control-group">			
			<c:if test="${dcaRiskManage.defineStatus == '3'}">
				<div class="controls">
					<form:checkbox path="isDefinePower" label="是否有界定权限" checked="checked" value="1"/>
				</div>
			</c:if>			
		</div>				
		<div class="form-actions">
		<shiro:hasPermission name="dca:dcaRiskManage:edit"><input id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>