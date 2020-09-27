<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>权责清单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="/assets/dca/js/jquery.Power.List.js"></script>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
			
        	return false;
        }
	</script>
</head>
<body>
<div id="dcaPowerList">
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/dca/dcaPowerList/import" method="post" enctype="multipart/form-data"
			class="form-search" style="padding-left:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn-s btn-opear" type="submit" value="   导    入   "/>
			<a href="${ctx}/dca/dcaPowerList/import/template">下载模板</a>
		</form>
	</div>
	<%-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/dca/dcaPowerList/">权责清单列表</a></li>
		<shiro:hasPermission name="dca:dcaPowerList:edit"><li><a href="${ctx}/dca/dcaPowerList/form">权责清单添加</a></li></shiro:hasPermission>
	</ul> --%>
	<form:form id="searchForm" modelAttribute="dcaPowerList" action="${ctx}/dca/dcaPowerList/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>权力：</label>
				<form:select path="powerId" class="input-medium">
					<form:option value="" label=" "/>
					<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>关联岗位：</label>
				<sys:treeselect id="remarks" name="remarks" value="${dcaPowerList.remarks}" labelName="name" labelValue=""
					title="岗位" url="/sys/dcaTraceUserRole/treeData"  allowClear="true" notAllowSelectParent="false" />
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value=""><i class="icon-search-1"></i>查询</button></li>
			<li class="btns pull-right"><button data-id="btnImport" class="btn-s btn-add" type="button" value="批量导入" ><i>+</i>批量导入</button></li>
			<shiro:hasPermission name="dca:dcaPowerList:edit"><li class="btns pull-right"><a href="${ctx}/dca/dcaPowerList/form" class="btn-s btn-add "><i>+</i>新建</a></li></shiro:hasPermission>
			
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/> 
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="15%">权力</th>
				<th width="15%">设定依据</th>
				<th width="15%">责任事项</th>
				<th width="15%">业务角色</th>
				<th width="15%">关联岗位</th>
				<shiro:hasPermission name="dca:dcaPowerList:edit"><th width="20%">操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaPowerList" step="1" varStatus="powerListStatus">
			<tr>
				<td>
					<c:out value="${powerListStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/>
				</td>
<!--  				<td><a href="${ctx}/dca/dcaPowerList/form?id=${dcaPowerList.bizRoleId}">
					${dcaPowerList.bizRoleName}
				</a></td>
-->				
				<td>
					${fns:getDictLabel(dcaPowerList.powerId, 'power_id', '')}
				</td>
				<td title="<c:out value="${dcaPowerList.accord}" />">
					<c:out value="${dcaPowerList.accord}" />
				</td>
				<td title="<c:out value="${dcaPowerList.duty}" />">
					<c:out value="${dcaPowerList.duty}" />
				</td>
				<td title="<c:out value="${dcaPowerList.bizRoleName}" />">
					<c:out value="${dcaPowerList.bizRoleName}" />
				</td>
				<td title="<c:out value="${dcaPowerList.name}" />">
					<c:out value="${dcaPowerList.name}" />
				</td>

				<shiro:hasPermission name="dca:dcaPowerList:edit"><td>
    				<a href="${ctx}/dca/dcaPowerList/form?id=${dcaPowerList.uuid}"  class="btn-s btn-opear">修改</a>
					<a href="${ctx}/dca/dcaPowerList/delete?id=${dcaPowerList.uuid}"  onclick="return confirmx('确认要删除该权责清单吗？', this.href)"  class="btn-s btn-opear">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<div class="text-center"><span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span></div>
	</c:if>
	<div class="pagination">${page}</div>
	</div>
</body>
</html>