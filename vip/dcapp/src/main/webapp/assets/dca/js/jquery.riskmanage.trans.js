/**
 * 风险管理转发页面
 */
+(function ($) {

    function RiskManageTrans(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }

    function _buildEvent() {
        var $this = this;
        $this.$element.validate({
        	submitHandler: function(form){
				confirmx("是否确定进行“风险转发”？，转发后，被转发人具有查看/界定权限。",function(){
					loading('正在提交，请稍等...');
					form.submit();
				})
			},
			errorContainer: "#messageBox",
			errorPlacement: function(error, element) {
				$("#messageBox").text("输入有误，请先更正。");
				if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
					error.appendTo(element.parent().parent());
				} else {
					error.insertAfter(element);
				}
			}
		}); 
    }
    
    function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1)
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.RiskManageTrans')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.RiskManageTrans', (data = new RiskManageTrans(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.RiskManageTrans;

    $.fn.riskManageTrans = Plugin;
    $.fn.riskManageTrans.Constructor = RiskManageTrans;
    
    $.fn.riskManageTrans.noConflict = function () {
        $.fn.riskManageTrans = old;
        return this
    }

})(jQuery);


$(function () {	
	$("#inputForm").riskManageTrans({
		
	});
	
})

