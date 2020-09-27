+(function($) {

	/**
	 * 
	 * @param element
	 *            dom节点
	 * @param options
	 *            options 参数
	 * @constructor
	 */
	function topicLibList(element, options) {
		
		this.$element = $(element);

		this.options = $.extend({}, {msg1:'该主题库未启用，不可关联物理表。',msg2:'该主题库已删除,请重新刷新页面！'}, options);

		this.flag = true;

		_buildEvent.call(this);

	}

	


			function _buildEvent() {
				var $this = this;
				
				this.$element
				.on('click', '.showRef', function() {
					
					if($this.flag){
						var _tr = $(this).parents('tr:first');
						 var _topicId = $("[data-id='topic-id']",_tr).val();
							
							$.get(ctx+'/dca/dcaTopicLib/checkTopicLibStatus', {id : _topicId}, function (res) {
								
								// 判断主题库的状态
								if (res=="停用") {
									//停用的场合
									
									alertx($this.options.msg1);
									
								} else if(res=="删除"){
									alertx($this.options.msg2);
									
								}else {
									var href= ctx+"/dca/dcaTopicLib/showRef?id="+ _topicId ;
									$this.flag=false;
									$('.showRef',_tr).attr('href',href).get(0).click();	
									
								}
							});
					
						}
				});
			}
	

	// ========================

	function Plugin(option) {

		var args = Array.prototype.slice.call(arguments, 1)

		return this.each(function() {
			var $this = $(this);
			var data = $this.data('dcapp.topicLibList')
			var options = typeof option == 'object' && option

			if (!data) {
				$this.data('dcapp.topicLibList',
						(data = new topicLibList(this, options)))
			}

			if (typeof option == 'string') {

				data[option].apply(data, args)
			}
		})
	}

	var old = $.fn.topicLibList;

	$.fn.topicLibList = Plugin;
	$.fn.topicLibList.Constructor = topicLibList;

	// ==================

	$.fn.topicLibList.noConflict = function() {
		$.fn.topicLibList = old;
		return this
	}

})(jQuery);

$(function() {

	$('#topicLibList').topicLibList({

	})
	

})
