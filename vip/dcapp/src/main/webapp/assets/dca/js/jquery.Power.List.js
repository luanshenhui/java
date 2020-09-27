/**
 * jquery书写demo
 */

+(function($) {

	/**
	 * 
	 * @param element
	 *            dom节点
	 * @param options
	 *            options 参数
	 * @constructor
	 */
	function DcaPowerList(element, options) {

		this.$element = $(element);

		this.options = $.extend({}, {}, options);

		this.changeFlag = false;

		_buildEvent.call(this);

		_render.call(this)

	}

	/**
	 * 
	 * @private
	 */
	function _render() {

	}

	function _buildEvent() {

		var $this = this;

		this.$element

		.on('click', '[data-id=btnImport]', function() {
			
			$.jBox($("#importBox").html(), {
				title : "导入数据",
				buttons : {
					"关闭" : true
				},
				bottomText : "说明：上传文件格式必须是excel，请按照导入模板格式上传，否则文件录入无效！"
			});
		});

	}

	// ========================

	function Plugin(option) {

		var args = Array.prototype.slice.call(arguments, 1)

		return this.each(function() {
			var $this = $(this);
			var data = $this.data('dcapp.DcaPowerList')
			var options = typeof option == 'object' && option

			if (!data) {
				$this.data('dcapp.DcaPowerList', (data = new DcaPowerList(this,
						options)))
			}

			if (typeof option == 'string') {

				data[option].apply(data, args)
			}
		})
	}

	var old = $.fn.dcaPowerList;

	$.fn.dcaPowerList = Plugin;
	$.fn.dcaPowerList.Constructor = DcaPowerList;

	// ==================

	$.fn.dcaPowerList.noConflict = function() {
		$.fn.topicRefPhysicsListRef = old;
		return this
	}

})(jQuery);

$(function() {

	$('#dcaPowerList').dcaPowerList({

	})

})
