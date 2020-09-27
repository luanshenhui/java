/**
 * Created by 11150221050069 on 2016/12/28.
 */

var url='/a/index/api?';

+(function ($) {

    function DepartRiskDetail(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        
        this.$element

        	// 点击按钮的hover
	        .on('click', '.box-left>ul li', function () {
	        	  $(this).addClass('on').siblings().removeClass('on');
	        	  var id = $(this).attr('data-id');
	        	  
	        	// 清空div
	        		$('div[data-id="main-fusionAnalysis"]').empty();
	        		
		    		// 风险等级
		    		if(id == "riskLevel"){
		    			
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
	        
    }
    
    // 风险等级数据
    DepartRiskDetail.prototype.findRiskLevelData = function () {
    	
    	var html = '<span class="risk-level-red"></span>高'
			+'<span class="risk-level-orange"></span>中'
			+'<span class="risk-level-yellow"></span>低';
	
	$('div[data-id="fusionAnalysisColor"]').append(html);
		
		$.getJSON(url+'_id=nytz-depart-riskLevel',function(result){
			if(result){
				// 红橙黄
				var colorList = ["#FF0000", "#EA7500", "#FFD306"];
				var nameList = ["高", "中", "低"];
				var mapList ={};
				$.each(result,function(index,content){
					var key = content.COID;
					if (null == mapList[key]) {
						// map中不存在
						var list = [];
						list.push(content);
						mapList[key] = list;
						 }else {
						// map中存在
						mapList[key].push(content);
					}
				});
				
				$.each(mapList,function(key, value){
					var coId = value[0].COID;
	    			var companyName = value[0].NAME;
					
					if (value != null && value.length != 3) {
					// 不是空 并且数据不全时，补全风险等级数据
					for (var i = 0; i < 3; i++) {
						var riskLevel = "";
						if (value.length > i) {
							// 没有越界
							riskLevel = value[i].RISK_LEVEL;
						}
						switch (i) {
						case 0:
							if (riskLevel != '10') {
								// 第1个不是10，把"10"补上
								var item = {};
								item.RISK_LEVEL = '10';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('0',0,item);
							}
							break;
						case 1:
							if (riskLevel != '20') {
								// 第2个不是"20"，把"20"补上
								var item = {};
								item.RISK_LEVEL = '20';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('1',0,item);
							}
							break;
						case 2:
							if (riskLevel != '30') {
								// 第3个不是"30"，把"30"补上
								var item = {};
								item.RISK_LEVEL = '30';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('2',0,item);
							}
							break;
						}
					}
				}
					var barData=[];
	    	    	if(value){
	    	    		
		    			var divId = 'riskLevelBar_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < value.length; j++){
	    	    			var item = value[j].RISKNUM;
	    	    			barData.push(item);
		    	    	}
	    	    		
		    			// 绘制柱状图
	    	    		_drawBar(companyName, barData, colorList, nameList, divId);
	    	    		
	    	    	}else{
	    	    		
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    		
	    	    	}
				})
			}
		});
   }
    // 风险界定数据
    DepartRiskDetail.prototype.findRiskDefineData = function () {
			
		$.getJSON(url+'_id=nytz-depart-riskDefine',function(result){
			
			if(result){
				// 红绿蓝
				var colorList = ["#D20000", "#30ADA0", "#2593D6"];
				var nameList = ["界定为风险", "界定为非风险", "未界定"];
				var mapList ={};
				$.each(result,function(index,content){
					var key = content.COID;
					if (null == mapList[key]) {
						// map中不存在
						var list = [];
						list.push(content);
						mapList[key] = list;
						 }else {
						// map中存在
						mapList[key].push(content);
					}
				})
				$.each(mapList,function(key, value){
					var coId = value[0].COID;
	    			var companyName = value[0].CONAME;
					
					if (value != null && value.length != 3) {
					// 不是空 并且数据不全时，补全风险等级数据
					for (var i = 0; i < 3; i++) {
						var status = "";
						if (value.length > i) {
							// 没有越界
							riskLevel = value[i].DEFINE_STATUS;
						}
						switch (i) {
						case 0:
							if (status != '1') {
								// 第1个不是10，把"10"补上
								var item = {};
								item.RISK_LEVEL = '1';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('0',0,item);
							}
							break;
						case 1:
							if (status != '2') {
								// 第2个不是"20"，把"20"补上
								var item = {};
								item.RISK_LEVEL = '2';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('1',0,item);
							}
							break;
						case 2:
							if (status != '3') {
								// 第3个不是"30"，把"30"补上
								var item = {};
								item.RISK_LEVEL = '3';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('2',0,item);
							}
							break;
						}
					}
				}
				
	    	    	var barData = [];
	    	    
	    	    	if(value){
		    			
		    			var divId = 'riskDefineBar_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < value.length; j++){
	    	    			var item = value[j].RISKNUM;
	    	    			barData.push(item);
		    	    	}
	    	    		
		    			// 绘制柱状图
	    	    		_drawBar(companyName, barData, colorList, nameList, divId);
	    	    	}else{
	    	    		
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    		
	    	    	}
		    	
			})
		}
	});
  }
	
	// 告警等级数据
    DepartRiskDetail.prototype.findAlarmLevelData = function () {
    	
		$.getJSON(url+'_id=nytz-depart-alarmLevel',function(result){
			
			if(result){
				// 红橙黄
				var colorList = ["#FF0000", "#EA7500", "#FFD306"];
				var nameList = ["红色", "橙色", "黄色"];
				var mapList ={};
				$.each(result,function(index,content){
					var key = content.COID;
					if (null == mapList[key]) {
						// map中不存在
						var list = [];
						list.push(content);
						mapList[key] = list;
						 }else {
						// map中存在
						mapList[key].push(content);
					}
				});
				
				$.each(mapList,function(key, value){
					var coId = value[0].COID;
	    			var companyName = value[0].NAME;
					
					if (value != null && value.length != 3) {
					// 不是空 并且数据不全时，补全风险等级数据
					for (var i = 0; i < 3; i++) {
						var riskLevel = "";
						if (value.length > i) {
							// 没有越界
							alarmLevel = value[i].ALARM_LEVEL;
						}
						switch (i) {
						case 0:
							if (riskLevel != '2') {
								// 第1个不是10，把"10"补上
								var item = {};
								item.ALARM_LEVEL = '2';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('0',0,item);
							}
							break;
						case 1:
							if (riskLevel != '3') {
								// 第2个不是"20"，把"20"补上
								var item = {};
								item.ALARM_LEVEL = '3';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('1',0,item);
							}
							break;
						case 2:
							if (riskLevel != '4') {
								// 第3个不是"30"，把"30"补上
								var item = {};
								item.ALARM_LEVEL = '4';
								item.RISKNUM = 0;
								item.COID = value[i].COID;
								item.NAME = value[i].NAME;
								value.splice('2',0,item);
							}
							break;
						}
					}
				}
					var barData = [];
	    	    	
	    	    	if(value){
		    			
		    			var divId = 'alarmLevelBar_'+coId;
		    			var html = '<a href="javascript:void(0);" class="company-module" '
		    					+'id="' + divId + '" data-id="' + coId + '" data-name="'+ companyName +'"></a>';
		    			$('div[data-id="main-fusionAnalysis"]').append(html);
		    			
	    	    		for(var j = 0; j < value.length; j++){
	    	    			var item = value[j].RISKNUM;
	    	    			barData.push(item);
		    	    	}

		    			// 绘制柱状图
	    	    		_drawBar(companyName, barData, colorList, nameList, divId);
	    	    	}else{
	    	    		var noDataHtml = '<div class="no-data-company"><p>' + companyName + '</p><p class="noDataP">无数据</p></div>'; 
	    	    		$('div[data-id="main-fusionAnalysis"]').append(noDataHtml);
	    	    	}
				})
			}
		});
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
            var data = $this.data('dcapp.departRiskDetail');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.departRiskDetail', (data = new DepartRiskDetail(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.departRiskDetail;

    $.fn.departRiskDetail = Plugin;
    $.fn.departRiskDetail.Constructor = DepartRiskDetail;
    
    $.fn.departRiskDetail.noConflict = function () {
        $.fn.departRiskDetail = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	 $('div[data-id=departRiskDetail]').departRiskDetail('findRiskLevelData');
})

