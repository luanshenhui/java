/**
 * 风险走势分析统计
 */
+(function ($) {

    function RiskTrendReport(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }

    function _buildEvent() {
        var $this = this;
        this.$element.on('change', '#year_select', function () {
        	_selectYearChange(); 
        });          
        //获取当前年份
        var currentYear = new Date().getFullYear();
        //获取select
        var select = $("#year_select");
        for(var i = currentYear; i >= currentYear-4; i--){
           select.append("<option value='"+i+"'>"+i+"</option>");
        }
        $(".select2-chosen").html(currentYear);
        $("#year_select option[value=currentYear]").attr("selected","selected");
        
        _selectYearChange();                  
    }
    
    // 选择年份后重新查询
    function _selectYearChange(){
    	var year=$('#year_select').val();
    	// 获取统计数据
        $.post(ctx+'/dca/dcaRiskTrendReport/getData', {selectYear:year}, function (result) {
    		if (!result) {
                    alertx('获取数据失败');
    		}else {
    			var data = JSON.parse(result);
    			var tableHtml = '';
    			if(data){
    				var labels = [];
    				var riskList = [];	    				
    				for(var i = 0,len = data.length;i < len;i++){
    					var item = data[i];
    					var label = item.name;//权力名称	    						    					
    					labels[i] = label;    					
    					//风险数据
    					var riskItem = {};	    					
    					riskItem.name = label;
    					riskItem.type = 'line';
    					riskItem.stock = '总量';
    					riskItem.data = item.data;
    					riskList[i] = riskItem;
    					tableHtml = tableHtml + '<tr><td>' + label;   				
    					$.each(item.data,function(index,value){
    						tableHtml = tableHtml + '</td><td>' + value;
    					});
    					tableHtml = tableHtml + '</td></tr>';	    				
    				}
    				//绘制风险统计
    				_drawRiskLine(labels,riskList);
    				$("#totalTable").html(tableHtml);
    			}
    		}
    	});
    }
      
    function _drawRiskLine(labels,riskList){
 	   	// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
        // 指定图表的配置项和数据
        option = {
        	    tooltip : {
        	        trigger: 'axis'
        	    },
        	    legend: {
        	        data:labels
        	    },          	    
        	    calculable : true,
        	    xAxis : [
        	        {
        	            type : 'category',
        	            boundaryGap : false,
        	            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
        	        }
        	    ],
        	    yAxis : [
        	        {
        	            type : 'value'
        	        }
        	    ],
        	    series : riskList
        	};          
        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option); 
    }
    
    function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1)
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.RiskTrendReport')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.RiskTrendReport', (data = new RiskTrendReport(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.RiskTrendReport;

    $.fn.riskTrendReport = Plugin;
    $.fn.riskTrendReport.Constructor = RiskTrendReport;
    
    $.fn.riskTrendReport.noConflict = function () {
        $.fn.riskTrendReport = old;
        return this;
    }

})(jQuery);


$(function () {	
	$("#idDiv").riskTrendReport({
		
	});
	
})

