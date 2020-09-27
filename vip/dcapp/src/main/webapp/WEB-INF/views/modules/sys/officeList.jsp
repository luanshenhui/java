<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "${not empty office.id ? office.id : '0'}";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/sys/office/list?id=${office.id}&parentIds=${office.parentIds}">机构列表</a></li>
		<shiro:hasPermission name="sys:office:edit"><li><a href="${ctx}/sys/office/form?parent.id=${office.id}">机构添加</a></li></shiro:hasPermission>
	</ul> --%>
	<ul class="ul-form span12">
		<shiro:hasPermission name="sys:office:edit"><li class="btns pull-right"><a href="${ctx}/sys/office/form?parent.id=${office.id}" class="btn-s btn-add"><i>+</i>机构添加</a></li></shiro:hasPermission>
	</ul>
	<div class="clearfix"></div>
	<sys:message content="${message}"/>
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
		<tr>
			<th width="10%">部门名称</th>
			<%-- <th width="10%">归属区域</th>--%>
			<th width="10%">部门编码</th>
			<th width="10%">职能类型</th>
			
			
			<th width="10%">上级部门</th>
			<th width="10%">部门正职</th>
			<th width="10%">部门副职</th>
			<%-- <th width="20%">备注</th>--%>
			<%-- <shiro:hasPermission name="sys:office:edit"><th>操作</th></shiro:hasPermission>--%>
		</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td title="{{row.name}}"><a href="${ctx}/sys/office/form?id={{row.id}}">{{row.name}}</a></td>
			<%--<td>{{row.area.name}}</td>--%>
			<td title="{{row.code}}">{{row.code}}</td>
			<td>{{dict.type}}</td>
			<td title="{{row.parentName}}">{{row.parentName}}</td>
			<td title="{{row.primaryPersonName}}">{{row.primaryPersonName}}</td>
			<td title="{{row.deputyPersonName}}">{{row.deputyPersonName}}</td>
			<%--<td title="{{row.remarks}}">{{row.remarks}}</td>--%>
			<%--<shiro:hasPermission name="sys:office:edit"><td>
				<a href="${ctx}/sys/office/form?id={{row.id}}" class="btn-s btn-opear">修改</a>
				<a href="${ctx}/sys/office/delete?id={{row.id}}" class="btn-s btn-opear" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)">删除</a>
				<a href="${ctx}/sys/office/form?parent.id={{row.id}}" class="btn-s btn-opear">添加下级机构</a> 
			</td></shiro:hasPermission>--%>
		</tr>
	</script>
</body>
</html>