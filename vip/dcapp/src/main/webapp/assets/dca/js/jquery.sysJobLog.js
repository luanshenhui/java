/**
 * 比较日期大小
 */


+(function ($) {

    /**
     *
     * @param element dom节点
     * @param options  options 参数
     * @constructor
     */
    function SysJobLog(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

      
    }

     
 /**
  * 绑定点击事件，获取页面的开始事件和结束时间，限制开始时间不能大于结束时间
  * @private
  */
    function _buildEvent() {

        var $this = this;

        this.$element
        
            .on('click','#startdate',function(){
         
            	WdatePicker({
            		dateFmt:'yyyy-MM-dd',
            		maxDate:'#F{$dp.$D(\'enddate\')||\'2020-10-01\'}',
            		isShowClear:true
            	});
            })
            
            .on('click','#enddate',function(){
            	WdatePicker({
            		dateFmt:'yyyy-MM-dd',
            		minDate:'#F{$dp.$D(\'startdate\')}',
            		maxDate:'2020-10-01',
            		isShowClear:true
            	});
            });
    }


    // ========================

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.SysJobLog')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.SysJobLog', (data = new SysJobLog(this, options)))
            }

            if (typeof option == 'string') {

                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.sysJobLog;

    $.fn.sysJobLog = Plugin;
    $.fn.sysJobLog.Constructor = SysJobLog;

    // ==================

    $.fn.sysJobLog.noConflict = function () {
        $.fn.sysJobLog = old;
        return this;
    }


})(jQuery);


$(function () {
	
  $('#data-select').sysJobLog({});


})

