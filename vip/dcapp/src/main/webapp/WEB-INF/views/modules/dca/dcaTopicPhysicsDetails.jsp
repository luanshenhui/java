<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>物理表字段详细</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#inputForm").submit();
	    	return false;
	    }
	</script>
</head>
<body>
	<h6 class="span12 font-normal">物理表结构详细</h6>
	<div class="pull-right navbar-search"><input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/></div>
	<div class="clearfix"></div>
	<form:form id="inputForm" modelAttribute="dcaTopicPhysics"  method="post" class="form-horizontal">
		<sys:message content="${message}"/>
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	</form:form>
	<table id="contentTable2" class="table table-striped table-bordered table-condensed span12" >
		<thead><tr><th title="字段序号">序号</th><th title="数据库字段名">字段名（英文）</th>
					<th title="数据库字段名">字段名（中文）</th><th title="数据库中设置的数据类型">数据类型</th>
					<th title="是否是数据库主键">是否主键</th><th title="字段是否唯一">是否唯一</th>
					<th title="字段是否可为空值">是否可空</th><th title="字段默认值">默认值</th>
				</tr></thead>
		<tbody>
			<c:forEach items="${page.list}" var="dcaTopicPhysics" varStatus="vs">
				<tr>
					<td>
						<c:out value="${dcaTopicPhysics.rowNumber}"/>
					</td>
					<td>
						<c:out value="${dcaTopicPhysics.columnName}"/>
					</td>
					<td>
						<c:out value="${dcaTopicPhysics.columnComment}"/>
					</td>
					<td>
						<c:out value="${dcaTopicPhysics.columnType}"/> (<c:out value="${dcaTopicPhysics.dataLength}"/>)
					</td>
					<td>
						${not empty dcaTopicPhysics.columnKey?'是':'否'}
					</td>
					<td>
						${dcaTopicPhysics.columnKey eq 'P'?'是':'否'}	
					</td>
					<td>
						${dcaTopicPhysics.isNull eq 'Y'?'是':'否'}
					</td>
					<td>
						${not empty dcaTopicPhysics.colDefault?dcaTopicPhysics.colDefault:'NULL'}	
					</td>
				</tr>
		 	</c:forEach>
		</tbody>
	</table>
	<div class="clearfix"></div>
	<div class="pagination">${page}</div>
</body>
</html>