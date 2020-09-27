<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>告警统计表</title>
<meta name="decorator" content="default" />
<link rel="stylesheet" type="text/css" href="/assets/dca/css/reportCount.css"> 
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<script src="/assets/dca/js/jquery.report.alarm.js" type="text/javascript"></script>
</head>
<body>
<div id="reportAlarm">
	<h2 class="text-center">告警统计表</h2>
	<ul class="statTit-ul">
		<li class="inline-li mt-10">
			<div class="pull-left">
				<label>操作人：</label>
				<select id="operSelect" class="input-medium">
				</select>
			</div>
			<div class="titleYear">
				<select id="yearSelect" class="selectYear">
				</select><span>年度</span>
			</div>
		</li>
		<li class="pull-left mt-10 text-center"><label>所属部门：</label>
			<select id="officeSelect" class="input-medium">
			</select>
		</li>
		<li class="pull-right">报表生成日期：<span id="createDate" class="date-width"></span></li>
		
	</ul>
	<div class="clearfix"></div>
	<div>
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th width="5%">序号</th>
					<th width="15%">业务事项</th>
					<th width="15%">办理事项</th>
					<th width="10%">告警(黄色)</th>
					<th width="10%">告警(橙色)</th>
					<th width="10%">告警(红色)</th>
					<th width="15%">合计</th>
					<th width="20%">补充</th>
				</tr>
			</thead>
			<tbody id="totalTable">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>