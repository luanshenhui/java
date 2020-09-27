/**
 * 风险告警统计(部门)
 */


+(function ($) {

    /**
     *
     * @param element dom节点
     * @param options  options 参数
     * @constructor
     */
    function RiskAlarmReport(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

      
    }

     
 /**
  * 风险界定统计饼图
  * @private
  */
    function _buildEvent() {

        var $this = this;
        //部门修改监听
        this.$element.on('change', '#bizOperPostId', function () {
        	
        	_selectData(); 
        });
        
        _getData();

        
    }
    function _getData(officeID){
    	var params={};
    	if(officeID){
    		params.officeId = officeID;
    	}
    	$.get(ctx+'/dca/dcaAlarmRiskDefineStatistics/findRiskDefineData', params, function (result) {
        	
    		if (!result) {
                    alertx('获取数据失败');
    		}else {
    			var data = JSON.parse(result);
    			
    			if(data){
    				var labels = [];
    				var riskList = [];
    				var totalRiskCount = 0;
    				for(var i = 0,len = data.length;i < len;i++){
    					var item = data[i];
    					var label = item.label;//风险界定名称
    					var riskCount = item.totalCount;//风险数量
    					totalRiskCount += riskCount;
    					
    					
    					labels[i] = label;
    					
    					//风险数据
    					var riskItem = {};
    					riskItem.value = riskCount;
    					riskItem.name = label;
    					riskList[i] = riskItem;
    				
    				}
    				if(totalRiskCount == 0){
    					_drawRiskPie(labels,riskList);
    					$("#riskDefine").html("<p>平台风险统计</p><span>暂无数据</span>");
    					
    				}else {
    					$("#riskNoData").css("display","none");
    					//绘制风险界定统计饼图
    					_drawRiskPie(labels,riskList);
    				}
    			}
    			//绘制风险界定统计饼图
				//_drawRiskPie(labels,riskList);
    		}
    	});
        $.get(ctx+'/dca/dcaAlarmRiskDefineStatistics/findRiskCount', params, function (result) {
    		if (!result) {
                alertx('获取数据失败');
    	}else {
    		
    		var data = JSON.parse(result);
    		var labels=[];
    		var riskList =[];
    		var alarmList=[];
    		var emptyTabel='';
    		var emptyTabelbody ='';
    		var tableHtml = '';
    		var tablebody='';
    		var len=data.length >= 5? 5:data.length
    		for(var i=0; i<len; i++){
    			var items= data[i];
    			var label = items.year;//x轴的年份
    			var riskCount = items.riskCount;//风险个数
    			var alarmCount = items.alarmCount;//报警个数
    			
    			labels[i] = label;
    			
    			//风险个数
    			
    			var riskItem = {};
    			riskItem.value = riskCount;
    			riskItem.name = label;
    			riskList[i] = riskItem;
    			
    			//告警个数
    			var alarmItem = {};
    			alarmItem.value = alarmCount;
    			alarmItem.name = label;
    			alarmList[i] = alarmItem;
    			
    			
    			
    			//统计数据
    			if(i==0){
    				tableHtml = tableHtml +'<th width="10%">&nbsp;</th>';
    			}
    			tableHtml = tableHtml +'<th width="10%">'+label+'年度'+'</th>';
    			
    			
    		}
    		
    		if(riskList.length ==0 && alarmList.length == 0){
    			var body = "<tr><td>暂无数据</td></tr>";
    			var header ="<tr><th>&nbsp;</th></tr>";
    			$('#tableheader').html(header);
    			$('#totalTable').html(body);
    		}else{
	    		for(var i=0; i<2; i++){
	    			for(var j = 0; j <len; j++){
	    				if(i==0){
	    					if(j==0){
	    						tablebody =  tablebody +'<td>风险</td>';
	    					}
	    					tablebody =  tablebody +'<td>'+riskList[j].value+'</td>';
	    				}else{
	    					if(j==0){
	    						tablebody =  tablebody +'<td>告警</td>';
	    					}
	    					tablebody =  tablebody +'<td>'+alarmList[j].value+'</td>';
	    				}
	    			}
	    			tablebody = '<tr>'+tablebody+'</tr>';
	    		}
	    		$('#tableheader').html(tableHtml);
	    		$('#totalTable').html(tablebody);
    		}
    		
    		//绘制告警风险年度情况柱状图
    		_drawWorkBar(labels,alarmList,riskList);
    	}
    		
    		
    	});
        $.get(ctx+'/dca/dcaAlarmRiskDefineStatistics/findRiskMonthCount', params, function (result) {
    		if (!result) {
                alertx('获取数据失败');
    	}else {
    		
    		var data = JSON.parse(result);
    		var riskList = data.riskArray;
    		var alarmList= data.alarmArray;
    		
    		//绘制告警风险年份折线图
    		
    		_drawRiskLine(riskList,alarmList);

    	}
    		
    		
    	});
    	
    }
  //绘制风险界定统计饼图
    function _drawRiskPie(labels,data){
    	
    	// 基于准备好的dom，初始化echarts实例
       	var riskPie = echarts.init(document.getElementById('riskDefine'));
    	
        // 指定图表的配置项和数据
    	var option = {
    	    title : {
    	        text: '风险界定统计',
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
  //绘制告警风险年份折线图
    function _drawRiskLine(riskList,alarmList){
    	
    	   	// 基于准备好的dom，初始化echarts实例
        var drawLine = echarts.init(document.getElementById('YearState'));
    	   	
        // 指定图表的配置项和数据
      
        var	option = {
        		    title : {
        		        text: '年份情况',
        		        x: 'center',
        		        align: 'right'
        		    },
        		    grid: {
        		        bottom: 80
        		    },
        		    tooltip : {
        		        trigger: 'axis'
        		    },
        		    legend: {
        		        data:['风险','告警'],
        		        x: 'left'
        		    },
        		    xAxis : [
        		        {
        		            type : 'category',
        		            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
        		        }
        		    ],
        		    yAxis: [
        		        {
        		        	name :'风险',
            	            type : 'value'
        		        },
        		        {
        		           
        		            name :'告警',
        		            type: 'value'
        		        }
        		    ],
        		    series: [
        		        {
        		            name:'风险',
        		            type:'line',
        		            animation: false,
        		            data:riskList
        		        },
        		        {
        		            name:'告警',
        		            type:'line',
        		            animation: false,
        		            data: alarmList
        		        }
        		    ]
        		};
        // 使用刚指定的配置项和数据显示图表。
        drawLine.setOption(option); 
    }

   
    //告警风险年度情况柱状图
    function _drawWorkBar(labels,alarmList,riskList){
    	// 基于准备好的dom，初始化echarts实例
       	var workBar = echarts.init(document.getElementById('alarmRiskState'));
    	
     // 指定图表的配置项和数据
    	var option = {
    		title : {
    	        text: '告警风险年度情况',
    	        x:'left'
    	    },
    	    color: ['#3398DB','#3369BD'],
    	    tooltip : {
    	        trigger: 'axis',
    	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
    	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
    	        }
    	    },
    	    legend: {
    	        data:['风险','告警']
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
    	            data : labels
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
    	            data:riskList
    	        },
    	        {
    	            name:'告警',
    	            type:'bar',
    	            barGap:'0',
    	            data:alarmList
    	        }
    	    ]
    	};
    	
    	// 使用刚指定的配置项和数据显示图表。
        workBar.setOption(option);
    }

    //监听事件
    function _selectData(){
    	_getData($("#bizOperPostId").val());
    }

    // ========================

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.RiskAlarmReport')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.RiskAlarmReport', (data = new RiskAlarmReport(this, options)))
            }

            if (typeof option == 'string') {

                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.riskAlarmReport;

    $.fn.riskAlarmReport = Plugin;
    $.fn.riskAlarmReport.Constructor = RiskAlarmReport;

    // ==================

    $.fn.riskAlarmReport.noConflict = function () {
        $.fn.riskAlarmReport = old;
        return this;
    }


})(jQuery);


$(function () {
	
  $('#riskalarmReport').riskAlarmReport({});


})

