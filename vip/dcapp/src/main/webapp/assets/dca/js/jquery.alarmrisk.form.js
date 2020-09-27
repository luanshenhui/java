/**
 * 风险清单新增修改页
 */
+(function ($) {

    function AlarmRiskForm(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }

    function _buildEvent() {
        var $this = this;
        $this.$element.validate({			
			submitHandler: function(form){
				// 判断风险名称是否重复
				$.get(ctx+'/dca/dcaAlarmRiskList/checkName', {riskName : $("#riskName").val().trim(), oldName : $('#oldName').val().trim(),powerId:$('[data-power="power"]').val().trim() }, function (res) {					
					// 名称已存在
					if (res=="false"){
						alertx("风险名称在此权力中已存在，请重新输入！");
						return false;
					}else{
						loading('正在提交，请稍等...');
						form.submit();
					}
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
            var data = $this.data('dcapp.AlarmRiskForm')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.AlarmRiskForm', (data = new AlarmRiskForm(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.alarmRiskForm;

    $.fn.alarmRiskForm = Plugin;
    $.fn.alarmRiskForm.Constructor = AlarmRiskForm;
    
    $.fn.alarmRiskForm.noConflict = function () {
        $.fn.alarmRiskForm = old;
        return this
    }

})(jQuery);


$(function () {
	$("#inputForm").alarmRiskForm({
		
	});
	
})

