<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/riskManage.css" />
	<script src="/assets/dca/js/jquery.riskmanage.list.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
						
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
	<form:form id="searchForm" modelAttribute="dcaRiskManage" action="${ctx}/dca/dcaRiskManage/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="personSelected" name="personSelected" type="hidden" value="${dcaRiskManage.bizOperPerson}"/>		
		<ul class="ul-form">
			<li><label>部门：</label>
				<c:choose>
					<c:when test="${not empty dca.bizOperPost }">
						<sys:treeselect id="bizOperPost" name="bizOperPost" value="${dca.bizOperPost}" labelName="bizOperPostName" labelValue="${dca.bizOperPostName}"
							title="所属部门" url="/sys/office/treeData?type=2" allowClear="true" notAllowSelectParent="false" disabled="disabled"/>
					</c:when>
					<c:otherwise>
						<sys:treeselect id="bizOperPost" name="bizOperPost" value="${dcaRiskManage.bizOperPost}" labelName="bizOperPostName" labelValue="${dcaRiskManage.bizOperPostName}"
								title="所属部门" url="/sys/office/treeData?type=2" allowClear="true" notAllowSelectParent="false" isAll="true"/>
					</c:otherwise>
				</c:choose>
			</li>
			<li><label>操作人：</label>
			    <c:choose>
			    	<c:when test="${not empty dca.bizOperPersonName}">
			    		<form:input path="bizOperPersonName" value="${dca.bizOperPersonName}" disabled="true"/>			    	
			    	</c:when>
			    	<c:otherwise>
						<form:select path="bizOperPerson" class="input-medium" >
							<form:option value="" label="请选择"/>		
						</form:select>		    	
			    	</c:otherwise>
			    </c:choose>	
			</li>
			<li><label>界定状态：</label>
				<form:select path="defineStatus" class="input-medium">
					<form:option value="-999" label=" "/>
					<form:options items="${fns:getDictList('define_status')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn-s btn-opear" type="submit" value="查询"><i class="icon-search-1"></i>查询</button></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="4%">序号</th>
				<th width="10%">业务事项</th>
				<th width="5%">操作人</th>
				<th width="13%">所属部门</th>
				<th width="10%">办理事项</th>
				<th width="12%">风险内容</th>
				<th width="4%">风险级别</th>
				<th width="9%">界定人</th>
				<th width="5%">界定状态</th>
				<shiro:hasPermission name="dca:dcaRiskManage:edit"><th width="22%">操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaRiskManage" varStatus="flowStatus">
			<tr>
				<td><c:out value="${flowStatus.index + (1 + (page.pageNo - 1) * page.pageSize)}"/></td>
				<td>
					<c:out value="${dcaRiskManage.bizFlowName}"/>
				</td>
				<td>
					<c:out value="${dcaRiskManage.bizOperPerson}"/>
				</td>
				<td title="<c:out value="${dcaRiskManage.bizOperPostName}"/>">
					<c:out value="${dcaRiskManage.bizOperPostName}"/>
				</td>
				<td title="<c:out value="${dcaRiskManage.bizDataName}"/>">
					<c:out value="${dcaRiskManage.bizDataName}"/>
				</td>
				<td title="<c:out value="${dcaRiskManage.riskMsg}"/>">
					<c:out value="${dcaRiskManage.riskMsg}"/>
				</td>
				<td>
					<c:choose>
						<c:when test="${dcaRiskManage.alarmLevel eq '1'}">
							<div class="circle green-background"></div>
						</c:when>						
						<c:when test="${dcaRiskManage.alarmLevel eq '2'}">
							<div class="circle yellow-background"></div>
						</c:when>
						<c:when test="${dcaRiskManage.alarmLevel eq '3'}">
							<div class="circle orange-background"></div>
						</c:when>
						<c:when test="${dcaRiskManage.alarmLevel eq '4'}">
							<div class="circle red-background"></div>
						</c:when>
					</c:choose>
				</td>
				<td>
					<c:out value="${dcaRiskManage.definePerson}"/>  
				</td>
				<td>
					<c:out value="${fns:getDictLabel(dcaRiskManage.defineStatus, 'define_status', '')}"/>   
				</td>
				<shiro:hasPermission name="dca:dcaRiskManage:edit"><td>
    				<a href="${ctx}/dca/dcaRiskManage/detail?id=${dcaRiskManage.riskManageId}" class="btn-s btn-opear">查看</a>
    				<%-- 判断是否可以人工界定 --%>
    				<c:if test="${dcaRiskManage.defineByManual == '1'}">
	    				<c:choose>
	    					<%-- [纪检监察室] --%>
	    					<c:when test="${isDISR}">
	    						<c:if test="${dcaRiskManage.defineStatus == '3'}">
		    						<a href="${ctx}/dca/dcaRiskManage/define?id=${dcaRiskManage.riskManageId}" class="btn-s btn-opear">界定</a>
		    					</c:if>	    					
								<%-- [纪检监察室]最高领导 --%>
		    					<c:if test="${isLEADER}"> 
		    						<c:if test="${dcaRiskManage.defineStatus != '3'}">
										<a href="${ctx}/dca/dcaRiskManage/recall?id=${dcaRiskManage.riskManageId}" onclick="return confirmx('撤销界定？撤销界定后，需再次界定。', this.href)" class="btn-s btn-opear">撤销界定</a>
			    					</c:if>    					
									<a href="${ctx}/dca/dcaRiskManage/form?id=${dcaRiskManage.riskManageId}" class="btn-s btn-opear">风险转发</a>
		    					</c:if>	    					
	    					</c:when>
	    					<%-- 其他部门 --%>
	    					<c:otherwise>
	    						<c:if test="${dcaRiskManage.defineStatus == '3' && dcaRiskManage.isDefinePower == '1'}">
		    						<a href="${ctx}/dca/dcaRiskManage/define?id=${dcaRiskManage.riskManageId}" class="btn-s btn-opear">界定</a>
		    					</c:if>
	    					</c:otherwise>
	    				</c:choose>   					
    				</c:if>				
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<c:if test="${empty page.list}">
		<div class="text-center"><span class="font-normal">没有符合条件的信息，请尝试其他搜索条件。</span></div>
	</c:if>
	<div class="pagination">${page}</div>
</body>
</html>