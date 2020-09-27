/**
 * 国资委首页融合分析详细页相关数据
 */

+(function ($) {

    function FusionAnalysisDetail(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        
        this.$element
        
        	.on('click', '.box-left>ul li', function (){
        		
        		$(this).addClass('on').siblings().removeClass('on');
        		
        		var id = $(this).attr('data-id');
        		
        		// 清空div
        		$('div[data-id="company-alarmRisk"]').hide();
        		$('div[data-id="company-riskDefine"]').hide();
        		$('div[data-id="company-riskTrend"]').hide();
        		
        		// 告警风险分析
	    		if(id == "alarmRisk"){
	    			
	    			$('p[data-id="fusionAnalysisDetailTitle"]').html('<i></i>告警风险分析');
	        		$('div[data-id="company-alarmRisk"]').show();
	    			$this.findAlarmRiskByCoId();
	    			
	    		// 风险界定分析
	    		}else if(id == "riskDefine"){
	    			
	    			$('p[data-id="fusionAnalysisDetailTitle"]').html('<i></i>风险界定分析<span data-id="riskDefineYear" style="font-size:24px;font-weight:border;"></span>');
	        		$('div[data-id="company-riskDefine"]').show();
	        		
	        		$this.findCoRiskDefinedReportData();
	    			
	    		// 风险走势分析
	    		}else{
	    			$('p[data-id="fusionAnalysisDetailTitle"]').html('<i></i>风险走势分析');
	        		$('div[data-id="company-riskTrend"]').show();
	        		
	        		$this.findRiskTrendReportData();
	    		}
        		
        	})
    }
    
    FusionAnalysisDetail.prototype.findAlarmRiskByCoId = function () {
    	var param = {
    			coId : $('#companyId').val()
    	}
		
    	$.getJSON(ctx+'/gzw/findAlarmRiskByCoId', param, function(result){
    		
	    	if(result){
	    		var riskList = result.riskList;
	    		
	    		// 风险分析
	    		if(riskList){
		    		var legendData = [];
		    		var pieData = [];
	    			
	    			for(var i = 0; i < riskList.length; i++){
	    				legendData.push(riskList[i].powerName);
	    				
	    				var item = {
		    					value : riskList[i].totalCount,
		    					name : riskList[i].powerName
		    			}
	    				pieData.push(item);
	    			} 

		    		_drawPie("风险分析", legendData, pieData, "main");
	    		}
	    		
	    		var alarmList = result.alarmList;
	    		
	    		// 告警分析
	    		if(alarmList){
		    		var legendData = [];
		    		var pieData = [];
	    			
	    			for(var i = 0; i < alarmList.length; i++){
	    				legendData.push(alarmList[i].powerName);
	    				
	    				var item = {
		    					value : alarmList[i].totalCount,
		    					name : alarmList[i].powerName
		    			}
	    				pieData.push(item);
	    			} 

		    		_drawPie("告警分析", legendData, pieData, "main1");
	    		}
	    		
	    		var instanceList = result.instanceList;
	    		if(instanceList){
	    			
	    			var xAxisData = [];
	    			var data = [];
	    			
	    			for(var i = 0; i < instanceList.length; i++){
	    				
	    				var item = {
	    						value: instanceList[i].powerName,
	                            textStyle: {
	                                fontSize: 20,
	                                color: '#fff'
	                            }
		    			}
	    				xAxisData.push(item);
	    				
	    				data.push(instanceList[i].totalCount);
	    			}
	    			
	    			_drawBar("业务事项分析", xAxisData, data, "main2");
	    		}
	    	}
			
		})
		
    }
    
    // 根据企业id查询当前年风险界定统计
    FusionAnalysisDetail.prototype.findCoRiskDefinedReportData = function () {
    	
    	var param = {
    			coId : $('#companyId').val()
    	}
    	
    	$.getJSON(ctx+'/gzw/findCoRiskDefinedReportData', param, function(result){

    		if(result){

				$('span[data-id="riskDefineYear"]').text('（' + result.curYear + '年）');
    			
    			var nameList = ['界定为风险', '界定为非风险', '未界定'];
    			
    			var monthList = [];
    			var riskList = [];
    			var nonRiskList = [];
    			var notDefinedList = [];
    			var totalList = [];
    			var data = result.data;
    			
    			if(data){
    				for(var i = 0; i < data.length; i++){
        				monthList.push(data[i].month + '月');
        				riskList.push(data[i].riskNum);
        				nonRiskList.push(data[i].nonRiskNum);
        				notDefinedList.push(data[i].notDefined);
        				totalList.push(data[i].totalNum);
        			}	
        			
        			_drawRiskDefineAnalysis(nameList, monthList, riskList, nonRiskList, notDefinedList, totalList);
    			}
    			
    		}
    		
    	})
    	
    }
    
    // 根据企业id查询当前年风险走势统计
    FusionAnalysisDetail.prototype.findRiskTrendReportData = function () {
    	
    	var param = {
    			coId : $('#companyId').val()
    	}
    	
    	$.getJSON(ctx+'/gzw/findRiskTrendReportData', param, function(result){

    		var legendData = [];
    		var data = [];
    		for(var i = 0; i < result.length; i++){
    			var item = {
    					name: result[i].name,
    					icon: 'circle'
    			}
    			legendData.push(item);
    			data.push(result[i].data);
    		}
    		
    		_drawLine(legendData, data);
    		
    	})
    	
    }
    
    function _drawLine(legendData, data){
    	
    	var myChart = echarts.init(document.getElementById('risk-trend-analysis'));
    	
        var option = {
            color: ['#ec023c','#01a0f2','#02fc08','#ff9000'],
	        xAxis: {
	        	type : 'category',
	        	axisLabel: {
	        		interval: 0,
	        	  	textStyle: {
	        	  		color: '#7a7a7a',
	                    fontSize: 20
	        	  	}
	        	},
	            data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
		    },
	        legend: {
	            align: 'left',
	            data: legendData,
	            textStyle: {
	                align: 'right',
	                baseline: 'middle',
	                color: '#FFFFFF',
	                fontSize: '25'
	            }
	        },
            yAxis: {
            	axisLabel: {
            		textStyle: {
            			color: '#7a7a7a',
            			fontSize: 20
        	  		}
        	  	}
        	},
	        series: [{
	            name: legendData[0].name,
	            type: 'line',
	            lineStyle: {
	            	normal: {
	            		color: '#ec023c'
	            		}
	            	},
	            data: data[0]
	        	},
		        {
		            name: legendData[1].name,
		            type: 'line',
		            lineStyle: {
		            	normal: {
		            		color: '#01a0f2'
		            		}
		            	},
		            data: data[1]
		        },
		        {
		            name: legendData[2].name,
		            type: 'line',
		            lineStyle: {
		            	normal: {
		            		color: '#02fc08'
		            		}
		            	},
		            data: data[2]
		        },
		        {
		            name: legendData[3].name,
		            type: 'line',
		            lineStyle: {
		            	normal: {
		            		color: '#ff9000'
		            		}
		            	},
		            data: data[3]
		        }
		    ]
	    };
	    myChart.setOption(option);
    }
    
	// 绘制饼图
    function _drawPie(title, legendData, data, element){
    	
    	var myChart = echarts.init(document.getElementById(element));
        option = {
            title: {
            	text: title,
            	textStyle: {
            		fontSize: '24',
            		color: '#fff'
            	}
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: 'right',
                itemHeight: '10',
                padding: [90,0,20,20],
                data: legendData,
                textStyle: {
                	fontSize: '16',
                	color: '#fff'
                }
            },
            series: [
                {
                    name: title,
                    type: 'pie',
                    radius: ['30%', '70%'],
                    avoidLabelOverlap: false,
                    label: {
                        normal: {
                            show: true,
                            position: 'outside',
                            formatter: "{d}%",
                            textStyle:{
                                fontSize: '20',
                                fontWeight: 'bold'
                            }
                        },
                        emphasis: {
                            show: true,
                            textStyle: {
                                fontSize: '20',
                                fontWeight: 'bold'
                            }
                        }
                    },
                    labelLine: {
                        normal: {
                            show: true,
                            length:20
                        }
                    },
                    data: data
                }
            ]
        };
        myChart.setOption(option);
    }
    
    // 绘制柱状图
    function _drawBar(title, xAxisData, data, element){
    	
    	var myChart = echarts.init(document.getElementById(element));
    	
        var option = {
            title: {
            	text: title,
            	textStyle: {
            		fontSize: '24',
            		color: '#fff'
            	}
            },
            color: ['#3398DB'],
            tooltip : {
                trigger: 'axis',
                axisPointer : {
                    type : 'shadow'
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
                    data: xAxisData,
                    axisTick: {
                        alignWithLabel: true
                    }
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    axisLabel:{
                        textStyle:{
                            color:'#7a7a7a',
                            fontSize:20
                        }
                    }
                }
            ],
            series : [
                {
                    name: title,
                    type:'bar',
                    barWidth: '60%',
                    data: data,
                    label:{
                        normal:{
                            show:true,
                            position:'top',
                            textStyle:{
                                color:'#ffc700'
                            }
                        }
                    }
                }
            ]
        };
        
        myChart.setOption(option);
    }
    
    function _drawRiskDefineAnalysis(name, month, risk, nonRisk, notDefined, total){
    	
    	var myChart = echarts.init(document.getElementById('risk-define-analysis'));

        // 指定图表的配置项和数据
		var option = {
		    title:{
		        text: '风险界定分析表',
		        textStyle: {
		        	color: '#fff',
		        	fontSize: '24'
		        },
		        left:'45%'
		    },
		    legend: {
		        data: name,
		        right:'20',
		        textStyle:{
		            color:'#ffffff',
		            fontSize:18
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
		            axisLabel:{
		                show: true,
		                textStyle:{
		                    fontSize:20,
		                    color:'#7a7a7a'
		                }
		            },
		            data : month
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value',
		            axisTick:{
		                show: false
		            },
		            axisLabel:{
		                show: true,
		                textStyle:{
		                    fontSize:20,
		                    color:'#7a7a7a'
		                }
		            }
		        }
		    ],
		    series : [
		        {
		            name: name[2],
		            type: 'bar',
		            stack: '统计',
		            itemStyle: {
		                normal:{
		                    color:'#02a0f4'
		                }
		            },
		            label: {
		                normal: {
		                    show: true,
		                    position: 'insideRight'
		                }
		            },
		            data: notDefined
		        },
		        {
		            name: name[1],
		            type:'bar',
		            stack: '统计',
		            itemStyle: {
		                normal:{
		                    color:'#02c7f4'
		                }
		            },
		            label: {
		                normal: {
		                    show: true,
		                    position: 'insideRight'
		                }
		            },
		            data: nonRisk
		        },
		        {
		            name: name[0],
		            type:'bar',
		            barWidth : 20,
		            itemStyle: {
		                normal:{
		                    color:'#ee073d'
		                }
		            },
		            stack: '统计',
		            label: {
		                normal: {
		                    show: true,
		                    position: 'insideRight'
		                }
		            },
		            data: risk
		        },
		        {
		            name:'总共',
		            type:'line',
		            lineStyle:{
		                normal:{
		                    color:'#ffc700'
		                }
		            },
		            data: total,
		            itemStyle: {
		                normal: {
		                    barBorderWidth: 6,
		                    barBorderRadius:0,
		                    label : {
		                        show: true,
		                        position: 'top',
		                        textStyle: {
		                            color: '#ffc700',
		                            fontSize:20
		                        }
		                    }
		                }
		            },
		
		        }
		    ]
		};
        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    }
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.fusionAnalysisDetail');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.fusionAnalysisDetail', (data = new FusionAnalysisDetail(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.fusionAnalysisDetail;

    $.fn.fusionAnalysisDetail = Plugin;
    $.fn.fusionAnalysisDetail.Constructor = FusionAnalysisDetail;
    
    $.fn.fusionAnalysisDetail.noConflict = function () {
        $.fn.fusionAnalysisDetail = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
    $('#fusionAnalysisDetailGZW').fusionAnalysisDetail("findAlarmRiskByCoId");
    
})

