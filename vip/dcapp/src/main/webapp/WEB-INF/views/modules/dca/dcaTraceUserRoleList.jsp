<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>岗位管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "ROOT";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.roleParentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.roleId);
				}
			}
		}
	</script>
</head>
<body>
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="20%">岗位名称</th>
				<th width="20%">岗位级别</th>
				<th width="20%">上级岗位名称</th>
				<th>包含人员</th>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<c:if test="${empty list}">
		<div class="text-center"><span class="font-normal">没有符合条件的信息。</span></div>
	</c:if>
	
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.roleId}}" pId="{{pid}}">	
			<td>{{row.roleName}}</td>
			<td>{{row.roleRank}}</td>
			<td>{{row.roleParentName}}</td>
			<td>{{row.userNameList}}</td>
		</tr>
	</script>
	
</body>
</html>