<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>物理表关联</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/topicLibListRef.css" />
    <script src="/assets/dca/js/jquery.topicRefPhysicsListRef.js" type="text/javascript"></script>



	<script type="text/javascript">
		$(document).ready(function(){
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
		
	</script>
</head>
<body>
<div id="topicRefPhysicsListRef">
	<%-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/dca/dcaTopicRefPhysics/">物理表关联</a></li>

	</ul> --%>
	<form:form id="searchForm" modelAttribute="dcaTopicLib" action="${ctx}/dca/dcaTopicLib/getSearchResult" method="post" class="breadcrumb form-search">
		<input id ="pageFlg" name="pageFlg"  type="hidden" value="${pageFlg}">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<form:input type="hidden" path="saveList" value="${saveList }" data-id="slist" htmlEscape="true" />
			<form:input type="hidden" path="delList" value="${delList }" data-id="dlist" htmlEscape="true" />
			<form:input type="hidden" path="changeFlag" value="" data-id="changeFlag" htmlEscape="true"/>
		<ul class="ul-form">
			<li><label class="label-width font-normal ">物理表中文名：</label>
				<form:input path="tableComment" htmlEscape="true" maxlength="25" class="input-medium" />
				<input name="id" type="hidden" value="${dcaTopicLib.id}" htmlEscape="true"/>
			</li>
			
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value=""><i class="icon-search-1"></i>查询</button></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<form:form id="setPhy" modelAttribute="dcaTopicLib" action="${ctx}/dca/dcaTopicLib/setPhyRef" method="post" class="breadcrumb form-search m-0" >
		<form:hidden path="id"/>
		
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th class="check-column"></th>
					<th>物理表英文名</th>
					<th>物理表中文名</th>

				</tr>
			</thead>
			<tbody>
			<c:forEach items="${page.list}" var="dcaTopicLib" varStatus="vs">
				<tr>
					<td>
					<input data-name="chkbox" type="checkbox" data-id = "${dcaTopicLib.tableName}" name="tableNameList[${vs.index}].phyCheck" data-relation="tableNameList[${vs.index}].phyCheck" ${dcaTopicLib.phyCheck eq 'on' ? 'checked' : ''} />
					 
					 </td>
					<td name="">
					
						<input data-name="topicId" name="tableNameList[${vs.index}].topicId"  type="hidden"  value="${dcaTopicLib.id}" class="topicId"/>
						<input data-name="tableName" name="tableNameList[${vs.index}].tableName" type="hidden" value="${dcaTopicLib.tableName}" class="tableName"/>
						
						<c:out value="${dcaTopicLib.tableName}"/>
					</td>
					<td name="">
						<input data-name="tableComment" name="tableNameList[${vs.index}].tableComment" type="hidden" value="${dcaTopicLib.tableComment}" class="tableComment">
						
						<c:out value="${dcaTopicLib.tableComment}"/>
					</td>


				</tr>
			</c:forEach>
			</tbody>
		</table>
			<form:input type="hidden" path="saveList" value="${saveList}" data-id="slist" htmlEscape="true" />
			<form:input type="hidden" path="delList" value="${delList}" data-id="dlist" htmlEscape="true"/>
			<form:input type="hidden" path="changeFlag" value="" data-id="changeFlag" htmlEscape="true"/>
		<c:if test="${empty page.list}">
			<div class="text-center"><span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span></div>
		</c:if>
		<div class="form-actions">
			<shiro:hasPermission  name="dca:dcaTopicLib:edit">
			<button id="btnSubmit1" class="saveRef btn-s btn-opear" data-target="btn_save" type="submit" value="保 存">保 存</button>&nbsp;</shiro:hasPermission>
			<a href="${ctx}/dca/dcaTopicLib/list"><button id="btnCancel" class="btn-s btn-opear" data-target="btn_back" type="button" value="返 回">返 回</button></a>
		</div>

		<div class="pagination">${page}</div>
	</form:form>
</div>
</body>
</html>