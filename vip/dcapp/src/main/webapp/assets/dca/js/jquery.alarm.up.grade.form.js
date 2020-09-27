/**
 * 告警上报设置添加/修改
 */
+(function ($) {

    function AlarmUpGradeForm(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;

        this.$element

            .on('change', '#powerId', function () {

            	var dom = $('#bizRoleId', this.$element).prev();
            	$('.select2-choice .select2-chosen', dom).text("请选择");
            	
            	var powerId = $('#powerId', this.$element).val();
            	$this.bindSelect("bizRoleId", ctx+"/dca/dcaAlarmUpGrade/getBizRoleByPowerId?powerId="+ powerId);
    			
            })

        	.validate({
        		submitHandler: function(form){
        			loading('正在提交，请稍等...');
        			form.submit();
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
    
    /**
     * 绑定下拉框
     * @private
     */
    AlarmUpGradeForm.prototype.bindSelect = function (ctrlName, url) {
	    var control = $('#' + ctrlName);
	    $.getJSON(url, function (data) {
	        control.empty();//清空下拉框
	        control.append("<option value=''>请选择</option>");
	        $.each(data, function (i, item) {
	            control.append("<option value='" + item.uuid + "'>" + item.bizRoleName + "</option>");
	        });
	    });
	}
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1);

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.alarmUpGradeForm');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.alarmUpGradeForm', (data = new AlarmUpGradeForm(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.alarmUpGradeForm;

    $.fn.alarmUpGradeForm = Plugin;
    $.fn.alarmUpGradeForm.Constructor = AlarmUpGradeForm;
    
    $.fn.alarmUpGradeForm.noConflict = function () {
        $.fn.alarmUpGradeForm = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('#inputForm').alarmUpGradeForm({})
    
})

