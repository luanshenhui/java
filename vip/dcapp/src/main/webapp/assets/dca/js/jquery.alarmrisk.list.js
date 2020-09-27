/**
 * 风险管理
 */
+(function ($) {

    function AlarmRiskList(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }

    function _buildEvent() {
        var $this = this;        
        // 点击批量导入触发事件
		$("#btnImport").click(function(){
			$.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true}, 
				bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});
		});
    }
       
    function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1)
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.AlarmRiskList')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.AlarmRiskList', (data = new AlarmRiskList(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.alarmRiskList;

    $.fn.alarmRiskList = Plugin;
    $.fn.alarmRiskList.Constructor = AlarmRiskList;
    
    $.fn.alarmRiskList.noConflict = function () {
        $.fn.alarmRiskList = old;
        return this
    }

})(jQuery);


$(function () {	
	
	$("#importBox").alarmRiskList({
		
	});
	
	
})

