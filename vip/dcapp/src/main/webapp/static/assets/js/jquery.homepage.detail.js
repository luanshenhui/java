/**
 * 首页
 */

+(function ($) {

    function HomePageDetail(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        
        this.$element

	        .on('click', '.center-box2', function () {
	        	
	        	$(".pop-up").css("display","block");
				
	        })
	        
	        .on('click', '.close', function () {
	        	
	        	$(".pop-up").css("display","none");
				
	        })
	}
    
    HomePageDetail.prototype.getData = function () {
    	
		var url = ctx+"/index/getSecondData";
		var sysDate = $('span[data-id="closingTime"]', parent.document).text();
		var param = {
				powerId : $('#powerId').val(),
				sysDate : sysDate
		}
		
		$.getJSON(url,param, function(result){
	    	
			// 左二--风险等级/告警等级
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
	    	
	    	// 关键流程
	    	var keyProcess = result.keyWorkFlowCount;
	    	var gaugeName = result.totalNumber;
	    	
	    	// 覆盖业务
	    	var overlayService = keyProcess/gaugeName*100+'%';
	    	$('span[data-id="overlayService"]').text(overlayService);
	    	
	    	var alarmAndRiskList = result.alarmAndRiskList;
	    	if(alarmAndRiskList){
	    		var html = '';
	    		for(var i = 0; i < alarmAndRiskList.length; i++){
	    			// 级别
	    			var alarmLevel = alarmAndRiskList[i].alarmLevel;
	    			// 业务操作人
	    			var operPersonName = alarmAndRiskList[i].operPersonName;
	    			// 用于区分告警和风险（告警-1、风险-2）
	    			var type = alarmAndRiskList[i].type;
	    			// 更新时间
	    			var updateDate = alarmAndRiskList[i].updateDate;
	    			
	    			var iconClass = "";
	    			if(alarmLevel == 1){
	    				iconClass = "icon-green";
	    			}else if(alarmLevel == 2){
	    				iconClass = "icon-yellow";
	    			}else if(alarmLevel == 3){
	    				iconClass = "icon-orange";
	    			}else if(alarmLevel == 4){
	    				iconClass = "icon-red";
	    			}
	    			var typeName = "";
	    			var fontColorClass = "";
	    			if(type == 1){
	    				typeName = "告警";
	    				fontColorClass = "yellow-font";
	    			}else if (type == 2){
	    				typeName = "风险";
	    				fontColorClass = "red-font";
	    			}
	    			
	    			html = '<li><i class="'+ iconClass +'"></i><span class="'+ fontColorClass +'">'+ typeName +'</span>：'+ operPersonName + updateDate +'出现'+ typeName +'</li>';
	    			$('#sp').append(html);
	    		}
	    		
	    	}else{
	    		$('#systemScroll').hide();
	    		$('#systemScrollHidden').show();
	    	}
		})
	    
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
            var data = $this.data('dcapp.homePageDetail');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.homePageDetail', (data = new HomePageDetail(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.homePageDetail;

    $.fn.homePageDetail = Plugin;
    $.fn.homePageDetail.Constructor = HomePageDetail;
    
    $.fn.homePageDetail.noConflict = function () {
        $.fn.homePageDetail = old;
        return this;
    }
    	  
})(jQuery);
$(function () {
    $('#homePageDetail').homePageDetail("getData");
    
    var powerTitle = '';
    var middleImgClass = "";
    
    if($('#powerId').val() == '0101'){
    	powerTitle = '重大决策';
    	middleImgClass = "project-box";
    }else if($('#powerId').val() == '0201'){
    	powerTitle = '重大事项';
    	middleImgClass = "detail";
    }else if($('#powerId').val() == '0301'){
    	powerTitle = '重要人事';
    	middleImgClass = "hr-box";
    }else if($('#powerId').val() == '0401'){
    	powerTitle = '大额资金';
    	middleImgClass = "largeAmount-box";
    }else if($('#powerId').val() == '0501'){
    	powerTitle = '投资';
    	middleImgClass = "investment-box";
    }else{
    	powerTitle = '担保';
    }
    
    $('[data-id="middleImg"]').addClass(middleImgClass);
    $('[data-id="powerTitle"]').html(powerTitle);
})

