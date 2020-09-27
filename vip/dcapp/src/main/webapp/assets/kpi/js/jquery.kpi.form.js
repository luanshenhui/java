/**
 * 绩效指标新增
 */
+(function ($) {

    function KpiForm(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;        
        
        $("#btnSubmit").click(function(){
        	
        	$this.saveSubmit();
        	
        })       
    }
    
    KpiForm.prototype.getData = function(){
		
    	/*$.getJSON(ctx+'/kpi/dcaKpi/getKPICheckResult', function (data){
			console.log(data);
		});	*/					
	} 
    
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.kpiForm');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.kpiForm', (data = new KpiForm(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.kpiForm;

    $.fn.kpiForm = Plugin;
    $.fn.kpiForm.Constructor = KpiForm;
    
    $.fn.kpiForm.noConflict = function () {
        $.fn.kpiForm = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('#kpiForm').kpiForm("getData");
})

