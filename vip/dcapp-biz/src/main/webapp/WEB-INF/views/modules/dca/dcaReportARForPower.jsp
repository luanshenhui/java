<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>告警风险统计（权力）</title>
<meta name="decorator" content="default" />
<!-- 
<link rel="stylesheet" type="text/css" href="/assets/dca/css/workFlowList.css"> 
<script src="/assets/dca/js/jquery.workflow.list.js" type="text/javascript"></script>
 -->
 <link rel="stylesheet" type="text/css" href="/assets/dca/css/arForPower.report.css"> 
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<script src="/assets/dca/js/jquery.report.arForPower.js" type="text/javascript"></script>
</head>
<body>

<div id="totalStat" class="chart-div m-r-10">
	<div style="padding:15px;">
	<div class="title">平台统计数据<span class="pull-right">(单位：件)</span> </div>
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			
			<thead>
				<tr>
					<th width="25%">权力</th>
					<th width="25%">业务事项</th>
					<th width="25%">告警</th>
					<th width="25%">风险</th>
				</tr>
			</thead>
			<tbody id="totalTable">
			</tbody>
		</table>
	</div>
</div>

<div id="riskStat" class="chart-div">
	<div id="riskNoData" style="margin:5px;display:none;">
		<p class="p-no-data">平台风险统计</p>
		<p class="m-t-20 m-l-5">暂无数据</p>
	</div>
</div>

<div id="alarmStat" class="chart-div m-r-10">
	<div id="alarmNoData" style="margin:5px;display:none;">
		<p class="p-no-data">平台告警统计</p>
		<p class="m-t-20 m-l-5">暂无数据</p>
	</div>
</div>

<div id="workStat" class="chart-div m-b-20">
</div>

</body>
</html>