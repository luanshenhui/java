/**
 * 风险管理
 */
+(function ($) {

    function RiskManageList(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }

    function _buildEvent() {
        var $this = this;
        this.$element.on('change', '#bizOperPostId', function () {
        	
        	var dom = $('#bizOperPerson', this.$element).prev();
        	$('.select2-choice .select2-chosen', dom).text(" ");
        	
        	var bizOperPost = $('#bizOperPostId').val();
        	$this.bindSelect("bizOperPerson", ctx+"/dca/dcaRiskManage/findUserByOfficeId?officeId="+ bizOperPost);    			
        })     
    }
    
    // 给操作人下拉列表赋值
    RiskManageList.prototype.bindSelect = function(ctrlName, url) {
	    var control = $('#' + ctrlName);
	    $.getJSON(url, function (data) {
	        control.empty();//清空下拉框
	        control.append("<option value=''> </option>");
	        $.each(data, function (i, item) {
	            control.append("<option value='" + item.id + "'>" + item.name + "</option>");
	        });
	        
	        var value = $('#personSelected', this.$element).val();        
			$("#bizOperPerson option[value="+value+"]").attr("selected", "selected");
			
			var dom = $('#bizOperPerson', this.$element).prev();
	    	$('.select2-choice .select2-chosen', dom).text($('#bizOperPerson').find("option:selected").text());
	    });
    
	}
    
    function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1)
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.RiskManageList')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.RiskManageList', (data = new RiskManageList(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.riskManageList;

    $.fn.riskManageList = Plugin;
    $.fn.riskManageList.Constructor = RiskManageList;
    
    $.fn.riskManageList.noConflict = function () {
        $.fn.riskManageList = old;
        return this
    }

})(jQuery);


$(function () {	
    $('#searchForm').riskManageList("bindSelect", "bizOperPerson", ctx+"/dca/dcaRiskManage/findUserByOfficeId?officeId="+$('#bizOperPostId').val())
})

