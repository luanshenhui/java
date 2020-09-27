/**
 * 告警上报设置列表
 */
+(function ($) {

    function AlarmUpGradeList(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;

        this.$element

            .on('change', '#powerId', function () {
            	
            	var dom = $('#bizRoleId', this.$element).prev();
            	$('.select2-choice .select2-chosen', dom).text(" ");
            	
            	var powerId = $('#powerId', this.$element).val();
            	$this.bindSelect("bizRoleId", ctx+"/dca/dcaAlarmUpGrade/getBizRoleByPowerId?powerId="+ powerId);
    			
            })
    }
    
    /**
     * 绑定下拉框
     */
    AlarmUpGradeList.prototype.bindSelect = function (ctrlName, url) {
	    var control = $('#' + ctrlName);
	    $.getJSON(url, function (data) {
	        control.empty();//清空下拉框
	        control.append("<option value=''> </option>");
	        $.each(data, function (i, item) {
	            control.append("<option value='" + item.uuid + "'>" + item.bizRoleName + "</option>");
	        });
	      
			var value = $('#bizRoleIdSelected', this.$element).val();
			$("#bizRoleId option[value="+value+"]").attr("selected", "selected");
			
			var dom = $('#bizRoleId', this.$element).prev();
	    	$('.select2-choice .select2-chosen', dom).text($('#bizRoleId').find("option:selected").text());
	        
	    });
	    
	}
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.alarmUpGradeList');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.alarmUpGradeList', (data = new AlarmUpGradeList(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.alarmUpGradeList;

    $.fn.alarmUpGradeList = Plugin;
    $.fn.alarmUpGradeList.Constructor = AlarmUpGradeList;
    
    $.fn.alarmUpGradeList.noConflict = function () {
        $.fn.alarmUpGradeList = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('#searchForm').alarmUpGradeList("bindSelect", "bizRoleId", ctx+"/dca/dcaAlarmUpGrade/getBizRoleByPowerId?powerId="+$('#powerId').val());
})

