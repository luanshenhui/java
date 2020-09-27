<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效指标设置</title>
	<meta name="decorator" content="default"/>
	<dca:resources/> 
	<script src="/assets/kpi/js/jquery.kpi.idx.form.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/assets/kpi/css/kpi.css"> 
	<script type="text/javascript">
		
	</script>
</head>
<body>	
	<form:form id="inputForm" modelAttribute="dcaKpiIdx" action="" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table id="contentTable2" class="table table-striped table-bordered table-condensed" >
		<thead>
			<tr>
				<th width="25%">项目</th>
				<th width="25%">类型</th>
				<th width="25%">考核结果</th>
				<th width="25%">绩效临界值</th>
            	
            </tr>
        </thead>
		<tbody>
				<tr>
					<td rowspan="6">
						<form:input path="idxName" htmlEscape="false" maxlength="50" class="input-medium"/>
						<font color="red">*</font>
					</td>
					<td rowspan="6">					
						<form:select path="idxType" class="input-medium">
							<c:forEach items="${dictList}" var="dictList">
								<form:option value="${dictList.value}">${dictList.label}</form:option>
							</c:forEach>
						</form:select>
						
						<font color="red">*</font>
					</td>
					<form:hidden path="idxId"/>
					<form:hidden path="dataMap"/>													
					<c:forEach items="${dictListResult}" var="dictListResult">
						<tr>
							<td>
								<form:input path="idxResult" htmlEscape="false" maxlength="50" class="input-medium" disabled="true" value="${dictListResult.label}"/>
								<input type="hidden" id="idxValue${dictListResult.value}" value="${dictListResult.value}">
							</td>
							<td>
								<c:if test="${empty dcaKpiIdxList}">
									<input type="text" id="criticalityValue${dictListResult.value}"  maxlength="50" class="input-medium"/>
								</c:if>
								<c:if test="${not empty dcaKpiIdxList}">
									<c:forEach items="${dcaKpiIdxList}" var="dcaKpiIdx">
										<c:if test="${dcaKpiIdx.idxResult == dictListResult.value}">
											<input type="text" id="criticalityValue${dictListResult.value}"  maxlength="50" class="input-medium" value="${dcaKpiIdx.criticalityValue}"/>
										</c:if>
									</c:forEach>
								</c:if>							
								<font color="red">*</font>
							</td>
						</tr>
					</c:forEach>
				</tr>
			</tbody>
		</table>	
		<div class="form-actions form-padding">
			<shiro:hasPermission name="kpi:dcaKpiIdx:edit"><input id="btnSubmit" class="btn-s btn-opear" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>