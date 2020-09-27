<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效指标管理</title>
	<meta name="decorator" content="default"/>
	<script src="/assets/kpi/js/jquery.kpi.list.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="/assets/kpi/css/kpi.css"> 
	<script type="text/javascript">
		$(document).ready(function() {
			// 点击批量导入触发事件
			$("#btnImport").click(function(){
				$.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true}, 
					bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});
			});
			
		});
	</script>
</head>
<body>
<div id="importBox" class="hide">
	<form id="importForm" action="${ctx}/kpi/dcaKpi/import" method="post" enctype="multipart/form-data"
		class="form-search" style="padding-left:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>
		<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
		<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
		<a href="${ctx}/kpi/dcaKpi/import/template">下载模板</a><br/><br/>
	</form>
</div>

<div id="kpiList">
	<ul class="ul-form">
		<shiro:hasPermission name="dca:dcaAlarmUpGrade:edit">
			<li class="btns pull-right">
				<a href="javascript:void(0);" id="btnImport" class="btn-s btn-add "><i>+</i>绩效考核表导入</a>
			</li>
		</shiro:hasPermission>
		<li class="clearfix"></li>
	</ul>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr class="kpi-head-tr">
				<th>项目</th>
				<th>绩效值</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${allresult}" var="kpiName">
			<tr>
				<td class="td-font">${kpiName.idTypeName}</td>
				<td></td>
			</tr>
			<c:forEach items="${kpiName.resultList}" var="item">
				<tr>
					<td>${item.idxName}</td>
					<td>
					<input type="text" id="${item.idxId}" value="${item.kpiResult}"data-idxName="${item.idxName}" data-idType="${kpiName.idType}" maxlength="50" class="KPIList input-medium" style="text-align: center;"/>
					<font color="red">*</font>
					</td>
				</tr>
			</c:forEach>
		</c:forEach>
			
		</tbody>
	</table>
	<div class="form-actions">
			<shiro:hasPermission name="kpi:dcaKpiIdx:edit"><a id="btnSubmit" class="btn-s btn-opear">保存</a></shiro:hasPermission>
			<a href="${ctx}/kpi/dcaKpi/list" class="btn-s btn-opear" id="btnCancel">取消</a>
			<a href="${ctx}/kpi/dcaKpi/form" class="btn-s btn-opear">查看考核结果</a>
	</div>
</div>
</body>
</html>