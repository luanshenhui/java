/**
 * 首页第一屏相关数据
 */

+(function ($) {

    function HomePageInfo(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        this.$element
	        .on('click','div[data-id=businessGauge]',function(){
	        	
	        	location.href='/static/nytz/kpiresult.html'; 
	        	
	        })
	        .on('click','div[data-id=risk]',function(){
	        	location.href='/static/nytz/riskDetail.html'; 
	        	
	        })
	        .on('click','div[data-id=alarm]',function(){
	        	location.href='/static/nytz/alarmDetail.html';
	        	
	        })
	         .on('click','div[data-id=riskDeptInfo]',function(){
	        	 location.href='/static/nytz/departData.html';
	        	
	        })
        
    }
    
    HomePageInfo.prototype.getData = function () {
		var sysDate = $('span[data-id="closingTime"]', parent.document).text();
		var param = {
				powerId : $('#powerId').val(),
				sysDate : sysDate
		}
		var param1 = {
				sysDate : sysDate
		}
		
		// 左一--企业效能（仪表盘）
		$.getJSON(ctx+'/index/getDataForGauge',function(result){
			
			// 左一--企业效能（仪表盘）
	    	var gaugeValue = result.efficiency;
	    	var gaugeName = result.totalNumber;
	    	_drawGauge(gaugeValue, gaugeName);
			
		})
		
		// 左二--风险等级/告警等级
		$.getJSON(ctx+'/index/getDataForRiskAlarm', param, function(result){
			
			// 红色风险
	    	$('span[data-id="riskGR"]').text(result.riskAlarmLevelProcessedRCount);
	    	$('span[data-id="riskRCount"]').text(result.riskAlarmLevelRCount);
	    	
	    	if(result.riskAlarmLevelRCount == 0){
	    		$('span[data-id="riskGR"]').css('width', '100%').removeClass('green').addClass('gray');
	    	}else{
	    		var riskGR = result.riskAlarmLevelProcessedRCount/result.riskAlarmLevelRCount*100;
		    	$('span[data-id="riskGR"]').css('width', riskGR+'%');
		    	$('span[data-id="riskRR"]').css('width', (100-riskGR)+'%');
	    	}
	    	// 橙色风险
	    	$('span[data-id="riskGO"]').text(result.riskAlarmLevelProcessedOCount);
	    	$('span[data-id="riskOCount"]').text(result.riskAlarmLevelOCount);
	    	
	    	if(result.riskAlarmLevelOCount == 0){
	    		$('span[data-id="riskGO"]').css('width', '100%').removeClass('green').addClass('gray');
	    	}else{
		    	var riskGO = result.riskAlarmLevelProcessedOCount/result.riskAlarmLevelOCount*100;
		    	$('span[data-id="riskGO"]').css('width', riskGO+'%');
		    	$('span[data-id="riskOO"]').css('width', (100-riskGO)+'%');
	    	}
	    	
	    	// 黄色风险
	    	$('span[data-id="riskGY"]').text(result.riskAlarmLevelProcessedYCount);
	    	$('span[data-id="riskYCount"]').text(result.riskAlarmLevelYCount);
	    	
	    	if(result.riskAlarmLevelYCount == 0){
	    		$('span[data-id="riskGY"]').css('width', '100%').removeClass('green').addClass('gray');
	    	}else{
	    		var riskGY = result.riskAlarmLevelProcessedYCount/result.riskAlarmLevelYCount*100;
		    	$('span[data-id="riskGY"]').css('width', riskGY+'%');
		    	$('span[data-id="riskYY"]').css('width', (100-riskGY)+'%');
	    	}
	    	
	    	// 红色告警
	    	$('span[data-id="alarmGR"]').text(result.alarmLevelProcessedRCount);
	    	$('span[data-id="alarmRCount"]').text(result.alarmLevelRCount);
	    	
	    	if(result.alarmLevelRCount == 0){
	    		$('span[data-id="alarmGR"]').css('width', '100%').removeClass('green').addClass('gray');
	    	}else{
	    		var alarmGR = result.alarmLevelProcessedRCount/result.alarmLevelRCount*100;
		    	$('span[data-id="alarmGR"]').css('width', alarmGR+'%');
		    	$('span[data-id="alarmRR"]').css('width', (100-alarmGR)+'%');
	    	}
	    	
	    	// 橙色告警
	    	$('span[data-id="alarmGO"]').text(result.alarmLevelProcessedOCount);
	    	$('span[data-id="alarmOCount"]').text(result.alarmLevelOCount);
	    	
	    	if(result.alarmLevelOCount == 0){
	    		$('span[data-id="alarmGO"]').css('width', '100%').removeClass('green').addClass('gray');
	    	}else{
	    		var alarmGO = result.alarmLevelProcessedOCount/result.alarmLevelOCount*100;
		    	$('span[data-id="alarmGO"]').css('width', alarmGO+'%');
		    	$('span[data-id="alarmOO"]').css('width', (100-alarmGO)+'%');
	    	}
	    	
	    	// 黄色告警
	    	$('span[data-id="alarmGY"]').text(result.alarmLevelProcessedYCount);
	    	$('span[data-id="alarmYCount"]').text(result.alarmLevelYCount);
	    	
	    	if(result.alarmLevelYCount == 0){
	    		$('span[data-id="alarmGY"]').css('width', '100%').removeClass('green').addClass('gray');
	    	}else{
		    	var alarmGY = result.alarmLevelProcessedYCount/result.alarmLevelYCount*100;
		    	$('span[data-id="alarmGY"]').css('width', alarmGY+'%');
		    	$('span[data-id="alarmYY"]').css('width', (100-alarmGY)+'%');
	    	}
			
		})
		
		//左三--数据引擎监控情况 
		$.getJSON(ctx+'/index/getBizDataLastList',function(result){
			
			var data = [];
			var xData = [];
			if(result){
				for(var i = 0; i < result.length; i++){
					data.push(result[i]);
					xData.push(i+1);
				}
			    _drawLineDataEngine(data, xData);
			}
		})
		
		// 右一--时间维度（柱状图使用）
		$.getJSON(ctx+'/index/getDataForWorkBar',function(result){
			var barLabels = ['第一季度', '第二季度', '第三季度', '第四季度'];
	    	var barAlarmList = [];
	    	var barRiskList = [];
	    	
	    	// 时间维度（柱状图使用）
	    	var timeDimensionList = result.timeDimensionList;
	    	if(timeDimensionList){
	    		for(var i = 0; i < timeDimensionList.length; i++){
//	    			barLabels.push(timeDimensionList[i].time);
	    			barAlarmList.push(timeDimensionList[i].alarmNumber);
	    			barRiskList.push(timeDimensionList[i].riskNumber);
		    	}
	    		// 绘制柱状图
		    	_drawWorkBar(barLabels, barAlarmList, barRiskList);
	    	}else{
	    		$('#alarmRiskState').hide();
	    		$('#alarmriskstateHidden').show();
	    	}
			
		})
		
		// 右二--各部门风险情况（饼图）
		$.getJSON(ctx+'/index/getDataForPie',function(result){
			
	    	var pieLabels = [];
	    	var pieData = [];
	    	
	    	// 各部门风险状况（饼图使用）
	    	var involvedDepartmentList = result.involvedDepartmentList;
	    	if(involvedDepartmentList){
	    		for(var i = 0; i < involvedDepartmentList.length; i++){
	    			pieLabels.push(involvedDepartmentList[i].deptName);
	    			
	    			var item = {
	    					value : involvedDepartmentList[i].proportion,
	    					name : involvedDepartmentList[i].deptName
	    			}
	    			pieData.push(item);
		    	}
	    		
	    		// 绘制饼图
	    		_drawRiskPie(pieLabels, pieData);
	    		$('#riskSpan').show();
	    		
	    	}else{
	    		$('#riskDeptInfo').hide();
	    		$('#riskDeptInfoHidden').show();
	    	}
			
		})
		
		// 右三--数据展示
		$.getJSON(ctx+'/index/getDataForShowData', param1, function(result){
			
			var gaugeName = result.totalNumber;
	    	// 关键流程
	    	var keyProcess = result.keyWorkFlowCount;
	    	$('span[data-id="keyProcess"]').text(keyProcess);
	    	
	    	var overlayService = 0;
	    	// 覆盖业务
	    	if(gaugeName == 0){
	    		overlayService = 0;
	    	}else{
		    	overlayService = keyProcess/gaugeName*100+'%';
	    	}
	    	$('span[data-id="overlayService"]').text(overlayService);
	    	
	    	// 职责清单
	    	var dutyList = result.dutyListCount;
	    	$('span[data-id="dutyList"]').text(dutyList);
	    	
	    	// 涉及部门
	    	var involvedDept = result.involvedDeptCount;
	    	$('span[data-id="involvedDept"]').text(involvedDept);
	    	
	    	// 风险点
	    	var riskPoint = result.riskListCount;
	    	$('span[data-id="riskPoint"]').text(riskPoint);
			
		})
		
		// 业务综合效能分析（雷达图）
		$.getJSON(ctx+'/index/getDataForRadar',function(result){
			
			var indicator = [];
	    	var radarValue = [];
	    	var efficiencyAnalysisList = result.efficiencyAnalysisList;
	    	if(efficiencyAnalysisList){
	    		for(var i = 0; i < efficiencyAnalysisList.length; i++){
	    			
	    			var item = {
	    					name : efficiencyAnalysisList[i].performanceName,
	    					max : 100
	    			};
	    			indicator.push(item);
	    			
	    			radarValue.push(efficiencyAnalysisList[i].efficiencyValue);
		    	}
	    		// 绘制雷达图
		    	_drawRadar(indicator, radarValue);
		    	$('#radarMarks').show();
	    	}else{
	    		$('#businessAnalysis').hide();
	    		$('#businessAnalysisHidden').show();
	    	}
			
		})
	    
	}
    
    // 企业效能（仪表盘）
    function _drawGauge(value, name){
    	var businessGauge = echarts.init(document.getElementById('businessGauge'));
    	 
    	var option = {
    		    backgroundColor: '#1b1b1b',
    		    tooltip : {
    		        formatter: "{a} <br/>{c} {b}"
    		    },
    		    clickable:true,
    		    series : [
    		        {
    		            name:'企业效能',
    		            type:'gauge',
    		            startAngle :180,
    		            endAngle :0,
    		            center: ['50%', '70%'], 
    		            min:0,
    		            max:100,
    		            splitNumber:10,
    		            radius: 170,
    		            axisLine: {            // 坐标轴线
    		                lineStyle: {       // 属性lineStyle控制线条样式
    		                    color: [[0.09, '#1e90ff'],[0.82, '#1e90ff'],[1, '#1e90ff']],
    		                    width: 3,
    		                    shadowColor : '#fff', //默认透明
    		                    shadowBlur: 10
    		                }
    		            },
    		            axisTick: {            // 坐标轴小标记
    		                length :15,        // 属性length控制线长
    		                lineStyle: {       // 属性lineStyle控制线条样式
    		                    color: 'auto',
    		                    shadowColor : '#fff', //默认透明
    		                    shadowBlur: 10
    		                }
    		            },
    		            splitLine: {           // 分隔线
    		                length :25,         // 属性length控制线长
    		                lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
    		                    width:3,
    		                    color: '#fff',
    		                    shadowColor : '#fff', //默认透明
    		                    shadowBlur: 10
    		                }
    		            },
    		            pointer: {           // 指针
    		                shadowColor : '#fff', //默认透明
    		                shadowBlur: 5
    		            },
    		            title : {
    		            	offsetCenter:[0, '30%'],
    		                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
    		                    fontWeight: 'bolder',
    		                    fontSize: 32,
    		                    color: '#fff'
    		                }
    		            },
    		            detail : {
    		                shadowColor : '#fff', //默认透明
    		                shadowBlur: 5,
    		                offsetCenter: [0, '-35%'],       // x, y，单位px
    		                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
    		                    fontWeight: 'bolder',
    		                    color: '#ff8400',
    		                    fontSize: 50,
    		                }
    		            },
    		            data:[{value:value, name: name}]
    		        }
    		    ]
    		};
    	
    	// 使用刚指定的配置项和数据显示图表。
    	businessGauge.setOption(option);
    	
    	// 添加点击事件  
    	/*businessGauge.on('click', function(params){
        	window.open('../nytz/kpiresult.html' + encodeURIComponent(params.name));
        	//$('#iframe-main').attr('src','../nytz/kpiresult.html'+ encodeURIComponent(params.name));
        	//$('#iframe-main').innerHTML="0001"
        }); */
    }
    
    // 业务综合效能分析雷达图
    function _drawRadar(indicator, value){
    	// 基于准备好的dom，初始化echarts实例
       	var businessRadar = echarts.init(document.getElementById('businessAnalysis'));
       	
       	var option = {
       		    radar: {
       		    	center :['50%', '45%'],
       		        indicator: indicator,
       		        name: {
       		            textStyle: {
       		                color: '#FFFFFF',
       		                fontSize:22
       		            }
       		        },
       		        splitNumber : 4,
       		        splitArea:{
       		        	areaStyle :{
       		        		color : ['rgba(97, 172, 36, 1)', 'rgba(255, 193, 59, 1)', 'rgba(253, 113, 0, 1)', 'rgba(210, 0, 0, 1)']
       		        	}
       		        },
       		        splitLine:{
       		        	lineStyle :{
       		        		color : 'rgba(0, 0, 0, 0)'
       		        	}
       		        },
       		        axisLine :{
       		        	lineStyle :{
       		        		color : 'rgba(45, 48, 53, 0.8)'
       		        	}
       		        }
       		    },
       		    series: [{
       		        type: 'radar',
       		        symbolSize:10,
       		        itemStyle: {
       	                normal: {
       	                    color: '#d20000',
       	                    borderWidth : 4,
       	                    shadowColor: 'rgba(255, 255, 255, 0.5)',
       	                    shadowBlur: 15
       	                }
       		        },
       		        lineStyle : {
    	                normal: {
    	                    color: '#FFFFFF'
    	                }
    		        },
	       		    areaStyle: {
	                     normal: {
	                    	 color: '#038cec',
	                         opacity: 0
	                     }
	                },
       		        data : [{
       		        	itemStyle: {
	    	                normal: {
	    	                	color:'#FFFFFF',
	    	                    borderWidth : 4,
	    	                    shadowColor: 'rgba(255, 255, 255, 0.5)',
	    	                    shadowBlur: 15
	    	                }
	    		        },
       		        	value : value
       		        }]
       		    }]
       		};
       		                    
       	businessRadar.setOption(option);
    }
    
    // 绘各部门风险情况饼图
    function _drawRiskPie(labels,data){
    	
    	// 基于准备好的dom，初始化echarts实例
       	var riskPie = echarts.init(document.getElementById('riskDeptInfo'));
    	
        // 指定图表的配置项和数据
    	var option = {
    	    title : {
    	        text: '各部门风险状况',
    	        left:'left',
    	        textStyle:{
    	        	color:'#FFFFFF',
    	        	fontWeight:'normal',
    	        },
    	        textBaseLine:'top',
    	        padding:[5,5,5,20]
    	        
    	    },
    	    color: ['#10ebff','#108aff','#104eff','#6a10ff','#28df9c','#94df28','#dfc328','#e68216','#ec491d'],
    	    tooltip : {
    	        trigger: 'item',
    	        formatter: "{a} <br/>{b} : {c} ({d}%)"
    	    },
    	    legend: {
    	        orient: 'vertical',
    	        left: 'right',
    	        top: 'middle',
    	        align:'left',
    	        itemWidth:20,
    	        itemHeight:7,
    	        itemGap:10,
    	        padding:[40,50,0,50],
    	        textStyle:{
    	        	color:'#FFFFFF',
    	        	fontWeight:'normal',
    	        },
    	        data: labels
    	    },
    	    series : [
    	        {
    	            name: '风险数量',
    	            type: 'pie',
    	            radius: ['30%', '70%'],
    	            center:['30%','55%'],
    	            data:data,
    	            itemStyle: {
    	                emphasis: {
    	                    shadowBlur: 10,
    	                    shadowOffsetX: 0,
    	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
    	                }
    	            },
    	            label:{
    	            	normal: { 
    	                    show: false     //不需要设置标签
    	                } 
    	            },
    	            labelLine: { 
    	                normal: { 
    	                    show: false     //不需要设置引导线 
    	                } 
    	            }
    	        }
    	    ]
    	};
        // 使用刚指定的配置项和数据显示图表。
        riskPie.setOption(option);
    }
    
    // 告警风险对比季度情况柱状图
    function _drawWorkBar(labels,alarmList,riskList){
    	// 基于准备好的dom，初始化echarts实例
       	var workBar = echarts.init(document.getElementById('alarmRiskState'));
    	
       	// 指定图表的配置项和数据
    	var option = {
    		title : {
    	        text: '告警风险对比',
    	        textStyle:{
    	        	color:'#FFFFFF',
    	        	fontWeight:'normal',
    	        },
    	        x:'left',
    	        padding:[5,5,5,20]
    	    },
    	    color: ['#108aff','#02dbf4'],
    	    tooltip : {
    	        trigger: 'axis',
    	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
    	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
    	        }
    	    },
    	    legend: {
    	        left: 'right',
    	        top: 'top',
    	        align:'left',
    	        itemWidth:20,
    	        itemHeight:7,
    	        itemGap:20,
    	        padding:[5,20],
    	        textStyle:{
    	        	color:'#FFFFFF',
    	        	fontWeight:'normal',
    	        },
    	        data:['告警','风险']
    	    },
    	    grid: {
    	        left: '2%',
    	        right: '8%',
    	        bottom: '3%',
    	        containLabel: true
    	    },
    	    xAxis : [
    	        {
    	        	name : '季度',
    	        	nameLocation:'end',
    	        	nameGap : 5,
    	            type : 'category',
    	            axisLine:{
		            	lineStyle: {
		            		color:'#747474'
		            	}
		            },
		            splitLine:{
		            	show : true,
		            	lineStyle: {
		            		color:'#232325'
		            	}
    	            },
    	            data : labels
    	        }
    	    ],
    	    yAxis : [
    	        {	
    	        	name : '数量',
    	        	nameLocation:'end',
    	            type : 'value',
    	            axisLine:{
		            	lineStyle: {
		            		color:'#747474'
		            	}
		            },
		            splitLine:{
		            	lineStyle: {
		            		color:'#232325'
		            	}
    	            }
    	        }
    	    ],
    	    series : [
				{
				    name:'告警',
				    type:'bar',
				    barWidth : 25,
				    barGap:'20%',
				    data:alarmList
				},
    	        {
    	            name:'风险',
    	            type:'bar',
				    barWidth : 25,
    	            data:riskList
    	        }
    	    ]
    	};
    	
    	// 使用刚指定的配置项和数据显示图表。
        workBar.setOption(option);
    }
    
    function _drawLineDataEngine(data, xAxisData){
    	
    	// 基于准备好的dom，初始化echarts实例
       	var dataEngineLine = echarts.init(document.getElementById('dataEngine'));
    	
    	var option = {
    		    title: {
    		        text: '数据引擎监控情况',
    		        textStyle:{
        	        	color:'#FFFFFF',
        	        	fontWeight:'normal',
        	        	fontSize:18
        	        },
        	        padding:[5,5,5,20]
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
    		            boundaryGap : false,
    		            axisLine:{
    		            	lineStyle: {
    		            		color:'#747474'
    		            	}
    		            },
    		            splitLine:{
    		            	show : true,
    		            	lineStyle: {
    		            		color:'#232325'
    		            	}
        	            },
    		            data : xAxisData
    		        }
    		    ],
    		    yAxis : [
    		        {
    		            type : 'value',
    		            axisLine:{
    		            	lineStyle: {
    		            		color:'#747474'
    		            	}
    		            },
    		            splitLine:{
    		            	lineStyle: {
    		            		color:'#232325'
    		            	}
        	            }
    		        }
    		    ],
    		    series : [
    		        {
    		            type:'line',
    		            label: {
    		                normal: {
    		                    show: true,
    		                    position: 'top'
    		                }
    		            },
    		            lineStyle:{
    		            	normal : {
    		            		color:'#449ce6',
    		            		width:1
    		            	}
    		            },
    		            areaStyle: {
    		            	normal: {
    		            		color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
    		            			  offset: 0, color: 'rgba(73, 172, 255, 0.1)' // 0% 处的颜色
    		            			}, {
    		            			  offset: 1, color: 'rgba(73, 172, 255, 1)' // 100% 处的颜色
    		            			}], false)
    		            	}
    		            },
    		            smooth:true,
    		            smoothMonotone:'x',
    		            symbol: 'none',
    		            sampling: 'average',
    		            data: data
    		        }
    		    ]
    		};
    	
    	// 使用刚指定的配置项和数据显示图表。
    	dataEngineLine.setOption(option);
    }
    
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.homePageInfo');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.homePageInfo', (data = new HomePageInfo(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.homePageInfo;

    $.fn.homePageInfo = Plugin;
    $.fn.homePageInfo.Constructor = HomePageInfo;
    
    $.fn.homePageInfo.noConflict = function () {
        $.fn.homePageInfo = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
	$("li[data-role=item]", parent.document).removeClass('active');
    $('#homePageInfo').homePageInfo("getData");
    
})

