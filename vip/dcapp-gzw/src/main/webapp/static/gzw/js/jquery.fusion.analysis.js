/**
 * 国资委首页融合分析相关数据
 */

+(function ($) {

    function FusionAnalysis(element, options) {

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
        		$('div[data-id="main-fusionAnalysis"]').empty();
        		
        		// 业务数据量
	    		if(id == "biz"){
	    			
	    			$('p[data-id="fusionAnalysisTitle"]').html("<i></i>业务数据量");
	    			$('div[data-id="fusionAnalysisColor"]').empty();
	    			
	    			$this.findBizData();
	    			
	    		// 风险等级
	    		}else if(id == "riskLevel"){
	    			
	    			$('p[data-id="fusionAnalysisTitle"]').html("<i></i>风险等级");
	    			
	    			var html = '<span class="risk-level-red"></span>高'
	    					+'<span class="risk-level-orange"></span>中'
	    					+'<span class="risk-level-yellow"></span>低';
	    			
	    			$('div[data-id="fusionAnalysisColor"]').empty().append(html);
	    			$this.findRiskLevelData();
	    			
	    		// 风险界定
	    		}else if(id == "riskDefine"){
	    		
	    			$('p[data-id="fusionAnalysisTitle"]').html("<i></i>风险界定");
	    			
	    			var html = '<span class="risk-define-red"></span>界定为风险'
	    					+'<span class="risk-define-green"></span>界定为非风险'
	    					+'<span class="risk-define-blue"></span>未界定';
	    			$('div[data-id="fusionAnalysisColor"]').empty().append(html);
	    			
	    			$this.findRiskDefineData();
	    			
	    		// 告警等级
	    		}else{
	    			$('p[data-id="fusionAnalysisTitle"]').html("<i></i>告警等级");
	    			
	    			var html = '<span class="risk-level-red"></span>红色'
	    					+'<span class="risk-level-orange"></span>橙色'
	    					+'<span class="risk-level-yellow"></span>黄色';
	    			$('div[data-id="fusionAnalysisColor"]').empty().append(html);
	    			
	    			$this.findAlarmLevelData();
	    		}
        		
        	})
        	
        	.on('click', '.company-module', function(){
        		
        		var companyId = $(this).attr('data-id');
        		var companyName = $(this).attr('data-name');
        		var pageIndex = $('input[data-id="pageIndex"]', parent.document).val();
        		
        		$('#iframe-main_'+pageIndex, parent.document)
        			.attr('src', ctx+'/gzw/companyFusionAnalysis?companyId='+companyId+'&companyName='+companyName);
        	})
    }
    
    FusionAnalysis.prototype.findBizData = function () {
		
		$.getJSON(ctx+'/gzw/findBizData',function(result){
			
	    	if(result){
	    		for(var i = 0; i < result.length; i++){

	    			var coId = result[i].coId;
	    			var companyName = result[i].coName;
	    			
	    	    	var pieData = [];
	    	    	var dataList = result[i].dataList;
	    	    	var legendData = [];
	    	    	if(dataList){

		    			var divId = 'bizDataPie_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < dataList.length; j++){
	    	    			var item = {
			    					value : dataList[j].instanceCount,
			    					name : dataList[j].powerName
			    			}
			    			pieData.push(item);
	    	    			
	    	    			legendData.push(dataList[j].powerName);
		    	    	}
		    			// 绘制饼图
			    		_drawPie(companyName, pieData, legendData, divId);
	    	    	}else{
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    	}

		    	}
	    	}
			
		})
    }
    
    // 风险等级数据
    FusionAnalysis.prototype.findRiskLevelData = function () {
		
		$.getJSON(ctx+'/gzw/findRiskLevelData',function(result){
			if(result){
				// 红橙黄
				var colorList = ["#FF0000", "#EA7500", "#FFD306"];
				var nameList = ["高", "中", "低"];
				
				for(var i = 0; i < result.length; i++){

					var coId = result[i].coId;
	    			var companyName = result[i].coName;
	    			
	    	    	var barData = [];
	    	    	var dataList = result[i].dataList;
	    	    	if(dataList){
	    	    		
		    			var divId = 'riskLevelBar_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < dataList.length; j++){
	    	    			var item = dataList[j].riskNum;
	    	    			barData.push(item);
		    	    	}
	    	    		
		    			// 绘制柱状图
	    	    		_drawBar(companyName, barData, colorList, nameList, divId);
	    	    		
	    	    	}else{
	    	    		
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    		
	    	    	}
		    	}
			}
		})
    }
    
    // 风险界定数据
	FusionAnalysis.prototype.findRiskDefineData = function () {
			
		$.getJSON(ctx+'/gzw/findDefineStatusData',function(result){
			
			if(result){
				// 红绿蓝
				var colorList = ["#D20000", "#30ADA0", "#2593D6"];
				var nameList = ["界定为风险", "界定为非风险", "未界定"];
				
				for(var i = 0; i < result.length; i++){

					var coId = result[i].coId;
	    			var companyName = result[i].coName;
	    			
	    	    	var barData = [];
	    	    	var dataList = result[i].dataList;
	    	    	if(dataList){
		    			
		    			var divId = 'riskDefineBar_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < dataList.length; j++){
	    	    			var item = dataList[j].riskNum;
	    	    			barData.push(item);
		    	    	}
	    	    		
		    			// 绘制柱状图
	    	    		_drawBar(companyName, barData, colorList, nameList, divId);
	    	    	}else{
	    	    		
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    		
	    	    	}
		    	}
			}
		})
    }
	
	// 告警等级数据
	FusionAnalysis.prototype.findAlarmLevelData = function () {
		
		$.getJSON(ctx+'/gzw/findAlarmLevelData',function(result){
			
			if(result){
				// 红橙黄
				var colorList = ["#FF0000", "#EA7500", "#FFD306"];
				var nameList = ["红色", "橙色", "黄色"];
				
				for(var i = 0; i < result.length; i++){

					var coId = result[i].coId;
	    			var companyName = result[i].coName;
	    			
	    	    	var barData = [];
	    	    	var dataList = result[i].dataList;
	    	    	if(dataList){
		    			
		    			var divId = 'alarmLevelBar_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < dataList.length; j++){
	    	    			var item = dataList[j].alarmCount;
	    	    			barData.push(item);
		    	    	}

		    			// 绘制柱状图
	    	    		_drawBar(companyName, barData, colorList, nameList, divId);
	    	    	}else{
	    	    		
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    		
	    	    	}
		    	}
			}
		})
	}
    
	// 绘制饼图
    function _drawPie(title, data, legendData, element){
    	
    	var targetElement = echarts.init(document.getElementById(element));
    	
    	// 指定图表的配置项和数据
        var dataStyle = {
            normal: {
                label: {
                    show: false
                },
                labelLine: {
                    show: false
                },
                shadowBlur: 40,
                shadowColor: 'rgba(40, 40, 40,0.5)',
            }
        };
        var option = {
            backgroundColor: '#f2f2f2',
            color: ['#ffdb6d', '#89c9e1', '#ce77b6', '#f29e29'],

            title: {
                text: title,
                x: 'center',
                top: '0%',
                textStyle: {
                    color: '#fff',
                    fontSize:20
                }
            },

            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: '2%',
                top: '40%',
                data: legendData,
                width: 10,
                textStyle: {
                	color:'#fff',
                	fontSize:'12'
                }
            },
            series: [{
                name: title,
                type: 'pie',
                center:[240,110],
                radius: ['40%', '60%'],
                avoidLabelOverlap: false,
                itemStyle: dataStyle,
                label: {
                    normal: {
                        show: false,
                        position: 'center'
                    },
                    emphasis: {
                        show: true,
                        formatter: function(param) {
                            return param.percent.toFixed(0) + '%';
                        },
                        textStyle: {
                            fontSize: '30',
                            fontWeight: 'bold'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        show: true
                    }
                },
                data: data
            }]
        };
        // 使用刚指定的配置项和数据显示图表。
        targetElement.setOption(option);
    }
    
    function _drawBar(title, data, color, name, element){
    	
    	var targetElement = echarts.init(document.getElementById(element));
        var option = {
            title : {
                text: title,
                textStyle: {
                	color: '#FFFFFF',
                    fontSize:20
                },
                x: 'center'
            },
            xAxis : [
                {
                    type : 'value',
                    splitLine: {
                    	show: false
                    },
                    show: false
                }
            ],
            yAxis : [
                {
                    type: 'category',
                    splitLine: {
                    	show: false
                    },
                    data: [''],
                    show: false
                }
            ],
            series : [
                {
                    name: name[0],
                    type: 'bar',
                    itemStyle: {
                    	normal: {
	                        barBorderWidth: '2',
	                        barBorderColor: '#090204',
	                        color: color[0],  // #FF0000红
	                        label: {
	                        	show: true, 
	                        	position: 'right'
	                        }
                    	}
                    },
                    data: [data[2]],
                    barWidth: '16'
                },
                {
                    name: name[1],
                    type: 'bar',
                    itemStyle: {
                    	normal: {
	                        barBorderWidth: '2',
	                        barBorderColor: '#090204',
	                        color: color[1],  // #EA7500橙
	                        label: {
	                        	show: true,
	                        	position: 'right'
	                        }
                    	}
                    },
                    data: [data[1]],
                    barWidth:'16'
                },
                {
                    name: name[2],
                    type: 'bar',
                    itemStyle :{
                    	normal: {
	                        barBorderWidth: '2',
	                        barBorderColor: '#090204',
	                        color: color[2],  // #FFD306黄
	                        label: {
	                        	show: true, 
	                        	position: 'right'
	                        }
                    	}
                    },
                    data: [data[0]],
                    barWidth:'16'
                }

            ]
        };
        targetElement.setOption(option);
    }
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.fusionAnalysis');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.fusionAnalysis', (data = new FusionAnalysis(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.fusionAnalysis;

    $.fn.fusionAnalysis = Plugin;
    $.fn.fusionAnalysis.Constructor = FusionAnalysis;
    
    $.fn.fusionAnalysis.noConflict = function () {
        $.fn.fusionAnalysis = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
	$('li[data-powerId="businessDataVolume"]', parent.document).addClass('active');
    $('#fusionAnalysisGZW').fusionAnalysis("findBizData");
    
})

