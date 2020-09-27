
+(function ($) {

    /**
     *
     * @param element dom节点
     * @param options  options 参数
     * @constructor
     */
    function BasicDataManageList(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);
        
        _load.call(this);

    }
    
    function _load(){
    	var agrPn= $('.intelSearch').length;
     	var myArray = new Array(agrPn);

     	for(var i = 0;i<agrPn;i++){
     		var autoP = $('.intelSearch').eq(i).html();
     		myArray[i]= {'keyVal':autoP};
     		
     	}

    	$('#auto').autocompleter({
    		 data: myArray
    	})
    }


    // ========================

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.BasicDataManageList')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.BasicDataManageList', (data = new BasicDataManageList(this, options)))
            }

            if (typeof option == 'string') {

                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.basicDataManageList;

    $.fn.basicDataManageList = Plugin;
    $.fn.basicDataManageList.Constructor = BasicDataManageList;

    // ==================

    $.fn.basicDataManageList.noConflict = function () {
        $.fn.basicDataManageList = old;
        return this
    }


})(jQuery);


$(function () {

    $('#auto').basicDataManageList({
       
    })

})

