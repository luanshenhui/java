/**
 * 绩效指标管理列表
 */
+(function ($) {

    function KpiIdxList(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
    }
    
    KpiIdxList.prototype.getData = function () {
    	
    	$.getJSON(ctx+'/kpi/dcaKpiIdx/getData', function (data) {
    		
	        //console.log(data);
	        var html = '';
	        
	        /*$.each(data, function (i, item) {
	        	
	        	var idxType = item.idxType;
	        	html += '<tr>';
	        	var dcaKpiIdxResult = item.dcaKpiIdxResult;
	        	


	        	html += '</tr>';
	        })
	        
	        $('.kpi-tbody').append(html);*/
	        
	        
	        
	    });
	    
	}
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.kpiIdxList');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.kpiIdxList', (data = new KpiIdxList(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.kpiIdxList;

    $.fn.kpiIdxList = Plugin;
    $.fn.kpiIdxList.Constructor = KpiIdxList;
    
    $.fn.kpiIdxList.noConflict = function () {
        $.fn.kpiIdxList = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('#kpiIdxList').kpiIdxList("getData");
})

