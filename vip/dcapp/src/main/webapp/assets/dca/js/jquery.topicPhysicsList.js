/**
 * dcaTopicPhysicsList 的 联想查询
 */




+(function ($) {

    /**
     *
     * @param element dom节点
     * @param options  options 参数
     * @constructor
     */
    function TopicPhysicsList(element, options) {

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
            var data = $this.data('dcapp.TopicPhysicsList')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.TopicPhysicsList', (data = new TopicPhysicsList(this, options)))
            }

            if (typeof option == 'string') {

                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.topicPhysicsList;

    $.fn.topicPhysicsList = Plugin;
    $.fn.topicPhysicsList.Constructor = TopicPhysicsList;

    // ==================

    $.fn.topicPhysicsList.noConflict = function () {
        $.fn.topicPhysicsList = old;
        return this
    }


})(jQuery);


$(function () {

    $('#auto').topicPhysicsList({
       
    })

})

