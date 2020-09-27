<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险统计表</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/reportCountRisk.css">
	<script src="/assets/dca/js/jquery.report.risk.js" type="text/javascript"></script>
	
</head>
<body>
	
	<form:form method="post" class="form-horizontal">
		<sys:message content="${message}"/>
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	</form:form>
	<br>
<div id="reportRisk">
		<h2 class="text-center font14">风险统计表</h2>
		<ul class="statTit-ul">
			<li class="inline-li mt-10" >
				<div class="pull-left operatorBox">
					<label>操作人：</label>
					<input type="text" value="" id="operator" disabled="disabled" />
					<input type="hidden" value="" id="operatorHidden" />
				</div>
				</li>
				<li class="inline-li mt-10" >
				<div class="titleYear">
					<select class="selectYear" id="selectYear">
					</select><span>年度</span>
				</div>
			</li> 
			<li class="inline-li mt-10 ">
			<div class="pull-left">
				<label>所属部门：</label>
					
					<sys:treeselect id="bizOperPost" name="bizOperPost" value="${data.userOfficeId}" labelName="bizOperPostName" labelValue="${data.userOfficeName}"
								title="所属部门" url="/sys/office/treeData?type=2" allowClear="true" notAllowSelectParent="true" />
			</div>
			</li>
			<li class="pull-right m-r-20">报表生成日期：<span id="createDate" class="date-width"></span></li>
			
		</ul>
		<div class="clearfix"></div>
	
		<table id="contentTable2" class="table table-striped table-bordered table-condensed" >
			<thead> 
				<tr>
					<th width="5%">序号</th>
					<th width="15%">业务事项</th>
					<th width="15%">办理事项</th>
					<th width="10%">风险(黄色)</th>
					<th width="10%">风险(橙色)</th>
					<th width="10%">风险(红色)</th>
					<th width="15%">合计</th>
					<th width="20%">补充</th>
		        </tr>
	         </thead>
			<tbody id="riskTable">
			</tbody>
		</table>
</div>
	<div class="pagination">${page}</div>
</body>
</html>