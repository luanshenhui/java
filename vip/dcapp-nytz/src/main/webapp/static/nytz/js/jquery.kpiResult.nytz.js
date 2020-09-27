/**
 * Created by 11150221050069 on 2016/12/28.
 */


+(function ($) {

    function KpiResult(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        
        this.$element

    }
    
    KpiResult.prototype.getKPIResult = function(){
    	var url ='/a/index/api?_id=nytz_kpiResult';
		var mapResult={};
	
    	$.getJSON(url,function(data){
    		if(data){
    			$.each(data,function(index,content){
        			
        			var key = content.IDXTYPE;
        			if(null == mapResult[key]){
        		    	var list = [];
        		    	list.push(content);
        		    	mapResult[key] = list;
        			}else{
        				mapResult[key].push(content);
        			}
        			
        		});
    		}
    		$.each(mapResult,function(key,value){
    			if(value.length > 0){
					var html = '';
					html += '<tr>';
					html += '<td class="txt-left border-right">' + value[0].IDXTYPENAME + '</td>';
					html += '<td class="border-right"></td>';
					html += '<td></td>';
					html += '</tr>';
					
					for(var i = 0 ; i < value.length; i++){
						html += '<tr>';
						html += '<td  class="border-right">' + value[i].IDXNAME + '</td>';
						html += '<td  class="border-right">' + value[i].KPIRESULT + '</td>';
						html += '<td>' + value[i].CHECKRESULTTEXT + '</td>';
						html += '</tr>';
					}
					
					$('[data-id="kpi-tbody"]').append(html);
    			}
			})
		
    	})
    	 
         
    }
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.kpiResult');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.kpiResult', (data = new KpiResult(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.riskDetail;

    $.fn.kpiResult = Plugin;
    $.fn.kpiResult.Constructor = KpiResult;
    
    $.fn.kpiResult.noConflict = function () {
        $.fn.kpiResult = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
	 $('div[data-id=kpiResult]').kpiResult('getKPIResult');
})

