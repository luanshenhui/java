<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险走势分析</title>
	<meta name="decorator" content="default"/>	
	<dca:resources/>
	<script type="text/javascript" src="/static/echarts/echarts.min.js"></script>
	<script type="text/javascript" src="/assets/dca/js/jquery.risktrend.report.js"></script>
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/risktrend.report.css" />  
</head>
<body> 
	<div id="idDiv" class="text-center">
		<h2 class="text-center font14">风险走势</h2>
		<div>  
			<select id="year_select" style="width:160px;margin-top:10px;"></select>
		</div>
		<div id="totalStat" style="height:250px;width:1000px;margin-top:10px;border:1px solid #eee;display:inline-block;">
			<div style="padding:15px;">
				<table id="contentTable" class="table table-striped table-bordered table-condensed">					
					<thead>
						<tr>
					     	<th width="7%">权力</th>
							<th width="5%">1月</th>
							<th width="5%">2月</th>
							<th width="5%">3月</th>
							<th width="5%">4月</th>
							<th width="5%">5月</th>
							<th width="5%">6月</th>
							<th width="5%">7月</th>
							<th width="5%">8月</th>
							<th width="5%">9月</th>
							<th width="5%">10月</th>
							<th width="5%">11月</th>
							<th width="5%">12月</th>						
						</tr>
					</thead>
					<tbody id="totalTable">
					</tbody>
				</table>
			</div>
		</div>
		<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
	    <div id="main" style="width: 1000px;height:400px;border:1px solid #eee;display:inline-block;"></div>
	</div>
	    
</body>
</html>