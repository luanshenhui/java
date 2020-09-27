<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效指标管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<script src="/assets/kpi/js/jquery.kpi.idx.list.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/assets/kpi/css/kpi.css"> 
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>
<body>
<div id="kpiIdxList">
	<ul class="ul-form">
		<shiro:hasPermission name="kpi:dcaKpiIdx:edit">
			<li class="btns pull-right">
				<a href="${ctx}/kpi/dcaKpiIdx/form"class="btn-s btn-add "><i>+</i>新建</a>
			</li>
		</shiro:hasPermission>
		<li class="clearfix"></li>
	</ul>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr class="kpi-head-tr">
				<th>项目</th>
				<c:forEach items="${dictList}" var="dictItem">
					<th>${dictItem.label}</th>
				</c:forEach>
				<shiro:hasPermission name="kpi:dcaKpiIdx:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody class="kpi-tbody">
		<c:forEach items="${result}" var="dcaKpi">
			<tr>
			<c:if test="${not empty dcaKpi.dcaKpiIdxResult}">
				<td class="td-font">
					${dcaKpi.dcaKpiIdxResult[0].idxTypeName}
				</td>
			</tr>
			<c:forEach items="${dcaKpi.dcaKpiIdxResult}" var="item">
				<tr>
					<td>${item.idxName}</td>
					<c:forEach items="${item.dataList}" var="itemTD">
						<td>${itemTD.criticalityValue}</td>
					</c:forEach>
					<shiro:hasPermission name="kpi:dcaKpiIdx:edit">
						<td>
	    					<a href="${ctx}/kpi/dcaKpiIdx/form?idxId=${item.idxId}">修改</a>
							<a href="${ctx}/kpi/dcaKpiIdx/delete?idxId=${item.idxId}" onclick="return confirmx('确认要删除该企业绩效吗？', this.href)">删除</a>
						</td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
</div>
</body>
</html>