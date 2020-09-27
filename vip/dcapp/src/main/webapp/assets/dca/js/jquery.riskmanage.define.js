/**
 * 风险管理
 */
+(function ($) {

    function RiskManageDefine(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }

    function _buildEvent() {
        var $this = this;
        $this.$element.validate({
			submitHandler: function(form){
				 var evidence = $('#evidence').val();
				if(evidence == null || evidence == ""){
					alertx("请上传界定材料。");
					return false;
				} 
				confirmx("是否确定进行“界定”？",function(){
					loading('正在提交，请稍等...');
					form.submit();
				});
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
            var data = $this.data('dcapp.RiskManageDefine')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.RiskManageDefine', (data = new RiskManageDefine(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.RiskManageDefine;

    $.fn.riskManageDefine = Plugin;
    $.fn.riskManageDefine.Constructor = RiskManageDefine;
    
    $.fn.riskManageDefine.noConflict = function () {
        $.fn.riskManageDefine = old;
        return this
    }

})(jQuery);


$(function () {	
	$("#inputForm").riskManageDefine({
		
	});
	
})

