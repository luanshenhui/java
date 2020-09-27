+(function ($) {

	$.get(ctx+'/dca/dcaAlarmRiskStatistics/findAlarmRiskStatData', {}, function (result) {
		if (!result) {
                alertx('获取数据失败');
		}else {
			var data = JSON.parse(result);
			console.log(data)
			if(data){
				drawChart(data);
			}
		}
	});
	
	//根据数据画图
	function drawChart(data){
		var labels = [];
		var riskList = [];
		var riskLabels = [];
		var alarmList = [];
		var alarmLabels = [];
		var workList = [];
		var totalRiskCount = 0;
		var totalAlarmCount = 0;
		var totalWorkCount = 0;
		
		var tableHtml = '';
		for(var i = 0,len = data.length;i < len;i++){
			var item = data[i];
			var label = item.label;//权力名称
			var riskCount = item.riskCount;//风险数量
			totalRiskCount += riskCount;
			
			var alarmCount = item.alarmCount;//告警数量
			totalAlarmCount += alarmCount;
			
			var workCount = item.workCount;//业务事项数量
			totalWorkCount += workCount;
			
			labels[i] = label;
			
			if(riskCount != 0){
				//风险数据
				var riskItem = {};
				riskItem.value = riskCount;
				riskItem.name = label;
				riskList.push(riskItem);
				
				riskLabels.push(label);
			}
			
			if(alarmCount != 0){
				//告警数据
				var alarmItem = {};
				alarmItem.value = alarmCount;
				alarmItem.name = label;
				alarmList.push(alarmItem);
				
				alarmLabels.push(label);
			}
			
			//业务数据
			var workItem = {};
			workItem.value = workCount;
			workList[i] = workItem;
			tableHtml = tableHtml + '<tr><td>' + label + '</td><td>' + workCount + '</td><td>' + alarmCount + '</td><td>' + riskCount + '</td></tr>';
		}
		
		if(totalRiskCount == 0){
			$("#riskNoData").css("display","block");
		} else {
			$("#riskNoData").css("display","none");
			//绘制平台风险统计饼图
			drawRiskPie(riskLabels,riskList);
		}
		
		if(totalAlarmCount == 0){
			$("#alarmNoData").css("display","block");
		} else {
			$("#alarmNoData").css("display","none");
			//绘制平台告警统计饼图
			drawAlarmPie(alarmLabels,alarmList);
		}
		
		//绘制业务事项柱状图
		drawWorkBar(labels,workList);
		
		//绘制汇总统计表格
		tableHtml = tableHtml + '<tr><td>汇总</td><td>' + totalWorkCount + '</td><td>' + totalAlarmCount + '</td><td>' + totalWorkCount + '</td></tr>';
		$("#totalTable").html(tableHtml);
	}
	
	//绘制平台风险统计饼图
	function drawRiskPie(labels,data){
		// 基于准备好的dom，初始化echarts实例
	   	var riskPie = echarts.init(document.getElementById('riskStat'));
		
	    // 指定图表的配置项和数据
		var option = {
		    title : {
		        text: '平台风险统计',
		        x:'left'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'right',
		        data: labels
		    },
		    series : [
		        {
		            name: '风险数量',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:data,
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
		};
	    // 使用刚指定的配置项和数据显示图表。
	    riskPie.setOption(option);
	}

	//绘制平台告警统计饼图
	function drawAlarmPie(labels,data){
		// 基于准备好的dom，初始化echarts实例
	   	var alarmPie = echarts.init(document.getElementById('alarmStat'));
		
	    // 指定图表的配置项和数据
		var option = {
		    title : {
		        text: '平台告警统计',
		        x:'left'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'right',
		        data: labels
		    },
		    series : [
		        {
		            name: '告警数量',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:data,
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
		};
	    // 使用刚指定的配置项和数据显示图表。
	    alarmPie.setOption(option);
	}

	//业务事项统计柱状图
	function drawWorkBar(labels,data){
		// 基于准备好的dom，初始化echarts实例
	   	var workBar = echarts.init(document.getElementById('workStat'));
		
		var option = {
			title : {
		        text: '业务事项统计',
		        x:'left'
		    },
		    color: ['#3398DB'],
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    xAxis : [
		        {
		            type : 'category',
		            data : labels,
		            axisTick: {
		                alignWithLabel: true
		            }
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		    series : [
		        {
		            name:'业务事项数量',
		            type:'bar',
		            barWidth: '60%',
		            data: data
		        }
		    ]
		};
		
		// 使用刚指定的配置项和数据显示图表。
	    workBar.setOption(option);
	}
})(jQuery);