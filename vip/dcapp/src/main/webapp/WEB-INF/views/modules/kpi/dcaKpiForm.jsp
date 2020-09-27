<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效考核结果</title>
	<meta name="decorator" content="default"/>
	<script src="/assets/kpi/js/jquery.kpi.form.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/assets/kpi/css/kpi.css"> 
</head>
<body>
<div id="kpiForm">
	<sys:message content="${message}"/>		
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr class="kpi-head-tr">
				<th>项目</th>
				<th>绩效值</th>
				<th>考核结果</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${result}" var="dcaKpi">
			<tr>
				<td class="td-font">
					${dcaKpi.idxTypeName}
				</td>
			</tr>
			<c:forEach items="${dcaKpi.dataList}" var="item">
				<tr>
					<td>${item.idxName}</td>
					<td>${item.kpiResult}</td>
					<td>${item.checkResultText}</td>
				</tr>
			</c:forEach>
		</c:forEach>
		</tbody>
	</table>
	
	<div class="form-actions">
		<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
	</div>
</div>
</body>
</html>