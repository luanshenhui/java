<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>DacCompany管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="/static/gzw/js/jquery.Company.List.js"></script>
	<script type="text/javascript" src="/static/gzw/js/echarts.min.js"></script>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
			
        	return false;
        }

       function formSubmit(){
       $("#importForm").attr("action","${ctx}/dca/dcaCompanyYear/import?company="+$("#companyId").val()+ "&companyY=" +$("#companyY").val());
        }
        
       function reportY(){
       		$("#searchForm").attr("action","${ctx}/dca/dcaCompanyYear/reportY");
       }
	</script>
</head>

<body>
<div id="dcaCompanyList">
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/dca/dcaCompanyYear/import" method="post" enctype="multipart/form-data"
			class="form-search" style="paddingft:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn-s btn-opear" type="submit" value="导    入   " url/>
		</form>
	</div>
	<form:form id="searchForm" modelAttribute="dcaCompany" action="${ctx}/dca/dcaCompanyYear/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<li><label>企业名称：</label>
				<form:select path="companyId" class="input-medium">
				    <form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('company_name')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<label class="font-normal">年度：</label>
				<form:input path="companyY" htmlEscape="true" maxlength="4" class="input-small"/>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-s btn-opear" type="submit" value=""><i class="icon-search-1"></i>查询</button></li>
			<li class="btns"><button data-id="btnImport" class="btn-s btn-add" type="button" value="导入" onclick="formSubmit()"><i>+</i>导入</button></li>
			<shiro:hasPermission name="dca:dcaCompany:edit"></shiro:hasPermission>
		    <li class="btns pull-right">
	            <a href="${ctx}/dca/dcaCompanyYear/reportAll" class="btn btn-s btn-opear">审核结果图表</a>
	            <button id="btnReportY" class="btn btn-s btn-opear" type="submit" onclick="reportY()">审核汇总年别</button>
            </li>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>编号</th>
				<th>企业名称</th>
				<th>上传年份</th>
				<th>文件</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="dcaCompanyList" varStatus="status">
			<tr>
                <td>
                   ${status.index+1}
				</td> 
				<td>
				   ${fns:getDictLabel(dcaCompanyList.companyId, 'company_name', '')}
				</td>
				<td>
				   ${dcaCompanyList.companyY}年
				</td>	
				<td>
     				<a href="${ctx}/dca/dcaCompany/import/template?company=${dcaCompanyList.companyId}&companyYm=${dcaCompanyList.companyYm}" class="btn-s btn-opear">下载</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
		</div>
</body>
</html>