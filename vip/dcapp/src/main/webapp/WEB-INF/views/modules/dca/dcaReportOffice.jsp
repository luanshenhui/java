<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>告警风险统计（部门）</title>
<meta name="decorator" content="default" />
<dca:resources/>
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<script src="/assets/dca/js/jquery.riskalarmoffice.report.js" type="text/javascript"></script>
<link type="text/css" href="/assets/dca/css/riskalarmreport.css" rel="stylesheet"></link>

<script type="text/javascript">
$(document).ready(function() {
	
});

</script>
</head>
<body>
<div id="riskalarmReport">
<div class="span12">
<label class="font-normal">部门：</label>
	<c:choose> 
		<c:when test="${flag == true}">
			<sys:treeselect id="bizOperPost" name="bizOperPost" value="${id}" labelName="bizOperPostName" labelValue="${name}"
							title="所属部门" url="/sys/office/treeData?type=2" allowClear="true" notAllowSelectParent="false" disabled="disabled"/>
		</c:when>
		<c:otherwise>
			<sys:treeselect id="bizOperPost" name="bizOperPost" value="" labelName="bizOperPostName" labelValue=""
							title="所属部门" url="/sys/office/treeData?type=2" allowClear="true" notAllowSelectParent="false" isAll="true"/>
		</c:otherwise>
	</c:choose> 
</div>
	<div class="riskdefineContainer">
	<div id="riskDefine" class="riskdefine">
		<div id="riskNoData" style="margin:5px;display:none;">
			<p class="p-no-data">平台风险统计</p>
			<p class="m-t-20 m-l-5">暂无数据</p>
		</div>
	</div>
	
	</div>
	
	<div class="alarmRiskcontainer">
	<div id="alarmRiskState" class="alarmriskstate"></div>
	<div  class="tablestate">
		<table id="contentTable" class="table table-striped table-bordered table-condensed ">
						<thead>
						<tr id="tableheader">
							
						</tr>
						</thead>
						<tbody id="totalTable">
						</tbody>
		</table>
		</div>
	</div>
	<div id="YearState" class="yearstate"></div>
</div>
</body>
</html>