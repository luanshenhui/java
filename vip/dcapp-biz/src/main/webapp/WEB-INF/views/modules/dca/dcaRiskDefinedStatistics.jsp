<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>风险界定统计</title>
<meta name="decorator" content="default" />
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<style>
.table td{
	padding:0;
	font-size:14px;
}
.table thead tr{
	height:30px;
}

.table thead tr th{
	font-size:14px;
}
</style>
<script type="text/javascript">
$(document).ready(function() {	
	        //获取当前年份
	        var currentYear = new Date().getFullYear();
	        //获取select
	        var select = $("#year_select");
	        for(var i = currentYear; i >= currentYear-4; i--){
	           select.append("<option value='"+i+"'>"+i+"</option>");
	        }
	        $(".select2-chosen").html(currentYear);
	        $("#year_select option[value=currentYear]").attr("selected","selected");
	        $.get(ctx+'/dca/dcaRiskDefinedStatistics/getStatistics', {selectYear:currentYear}, function (result) {
	    		if (!result) {
	                    alertx('获取数据失败');
	    		}else {
	    			var data = JSON.parse(result);
	    			$('#qqq').text(data.dt);
	    			var isRiskHtml = '';
	    			var isNotRiskHtml = '';
	    			var unattunedHtml = '';
	    			var totalHtml = '';
	    			if(data){
	    				var isRisk_show=data.isRisk;
	    				var isNotRisk_show=data.isNotRisk;
	    				var unattuned_show=data.unattuned;
	    				var total_show=data.total;
	    				for(var i = 0;i < 12;i++){
	    					isRiskHtml = isRiskHtml + '<td>' + isRisk_show[i] + '</td>';
	    					isNotRiskHtml = isNotRiskHtml + '<td>' + isNotRisk_show[i] + '</td>';
	    					unattunedHtml = unattunedHtml + '<td>' + unattuned_show[i] + '</td>';
	    					totalHtml = totalHtml + '<td>' + total_show[i] + '</td>';
	    				}
	    			var isRiskTr='<tr><td>' + '风险' + '</td>' + isRiskHtml +'</tr>'
	    			var isNotRiskTr='<tr><td>' + '非风险' + '</td>' + isNotRiskHtml +'</tr>'
	    			var unattunedTr='<tr><td>' + '未界定' + '</td>' + unattunedHtml +'</tr>'
	    			var totalTr='<tr><td>' + '合计' + '</td>' + totalHtml +'</tr>'
	    			var tableHtml = isRiskTr + isNotRiskTr + unattunedTr + totalTr;
	    			 
	    				var labels = [];
	    				  
	    				//绘制柱状图
	    				drawWorkBar(labels,data);
	    				
	    				//绘制汇总统计表格
	    				$("#totalTable").html(tableHtml);
	    			}
	    		}
	    	});
});

function selectYear(){
	var para=$('#year_select').val();
	$.get(ctx+'/dca/dcaRiskDefinedStatistics/getStatistics', {selectYear:para}, function (result) {
		if (!result) {
                alertx('获取数据失败');
		}else {
			var data = JSON.parse(result);
			$('#qqq').text(data.dt);
			var isRiskHtml = '';
			var isNotRiskHtml = '';
			var unattunedHtml = '';
			var totalHtml = '';
			if(data){
				var isRisk_show=data.isRisk;
				var isNotRisk_show=data.isNotRisk;
				var unattuned_show=data.unattuned;
				var total_show=data.total;
				for(var i = 0;i < 12;i++){
					isRiskHtml = isRiskHtml + '<td>' + isRisk_show[i] + '</td>';
					isNotRiskHtml = isNotRiskHtml + '<td>' + isNotRisk_show[i] + '</td>';
					unattunedHtml = unattunedHtml + '<td>' + unattuned_show[i] + '</td>';
					totalHtml = totalHtml + '<td>' + total_show[i] + '</td>';
				}
			var isRiskTr='<tr><td>' + '风险' + '</td>' + isRiskHtml +'</tr>'
			var isNotRiskTr='<tr><td>' + '非风险' + '</td>' + isNotRiskHtml +'</tr>'
			var unattunedTr='<tr><td>' + '未界定' + '</td>' + unattunedHtml +'</tr>'
			var totalTr='<tr><td>' + '合计' + '</td>' + totalHtml +'</tr>'
			var tableHtml = isRiskTr + isNotRiskTr + unattunedTr + totalTr;
			 
				var labels = [];
				  
				//绘制业务事项柱状图
				drawWorkBar(labels,data);
				
				//绘制汇总统计表格
				$("#totalTable").html(tableHtml);
			}
		}
	});
}

//统计柱状图
function drawWorkBar(labels,data){
	// 基于准备好的dom，初始化echarts实例
   	var workBar = echarts.init(document.getElementById('workStat'));
	
   	option = {
   		    tooltip : {
   		        trigger: 'axis',
   		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
   		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
   		        }
   		    },
   		    legend: {
   		        data:['风险','非风险','未界定']
   		    },
   		    toolbox: {
   		        show : false,
   		        orient: 'vertical',
   		        x: 'right',
   		        y: 'center',
   		        feature : {
   		            mark : {show: true},
   		            dataView : {show: true, readOnly: false},
   		            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
   		            restore : {show: true},
   		            saveAsImage : {show: true}
   		        }
   		    },
   		    calculable : true,
   		    xAxis : [
   		        {
   		            type : 'category',
   		            data : ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
   		        }
   		    ],
   		    yAxis : [
   		        {
   		            type : 'value'
   		        }
   		    ],
   		    series : [
   		        {
   		            name:'风险',
   		            type:'bar',
   		            stack: '汇总',
   		            data:data.isRisk
   		        },
   		        {
   		            name:'非风险',
   		            type:'bar',
   		            stack: '汇总',
   		            data:data.isNotRisk
   		        },
   		        {
   		            name:'未界定',
   		            type:'bar',
   		            stack: '汇总',
   		            data:data.unattuned
   		        }
   		    ]
   		};
   		                    
	
	// 使用刚指定的配置项和数据显示图表。
    workBar.setOption(option);
}
</script>

</head>
<body>
<h2 class="text-center font14">风险界定统计</h2>
<div>
	<!-- <label style="margin-top:10px;float:left;">请选择年份时间：</label>   -->
	<div style="margin-left: 48px;">  
		<select id="year_select" onChange="selectYear(this)" style="width:160px;margin-top:10px;float:left;">
		    <option value=""> </option>
		</select>
	</div>
	<div class="pull-right mt-10" style="margin-top:10px;margin-right:130px">
	 	<label>报表生成日期：</label><span id="qqq"></span>
	</div>
</div>
<div id="totalStat" style="height:260px;width:90%;margin-top:10px;border:1px solid #eee;display:inline-block; margin-left: 50px;">
	<div style="padding:15px;">
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<caption align="left"></caption>
			<thead>
				<tr>
				    <th width="7%">界定状态</th>
					<th width="5%">一月</th>
					<th width="5%">二月</th>
					<th width="5%">三月</th>
					<th width="5%">四月</th>
					<th width="5%">五月</th>
					<th width="5%">六月</th>
					<th width="5%">七月</th>
					<th width="5%">八月</th>
					<th width="5%">九月</th>
					<th width="5%">十月</th>
					<th width="5%">十一月</th>
					<th width="5%">十二月</th>
				</tr>
			</thead>
			<tbody id="totalTable">
			</tbody>
		</table>
	</div>
</div>



<div id="workStat" style="border:1px solid #;width:90%;display:inline-block;height:300px;margin-left: 50px;">
</div>

</body>
</html>