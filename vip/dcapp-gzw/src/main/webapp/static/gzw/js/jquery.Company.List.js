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
	function DcaCompanyList(element, options) {

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
				bottomText : "说明：上传文件格式必须是excel，否则文件录入无效！"
			});
		});

	}

	// ========================

	function Plugin(option) {

		var args = Array.prototype.slice.call(arguments, 1)

		return this.each(function() {
			var $this = $(this);
			var data = $this.data('dcapp.DcaCompanyList')
			var options = typeof option == 'object' && option

			if (!data) {
				$this.data('dcapp.DcaCompanyList', (data = new DcaCompanyList(this,
						options)))
			}

			if (typeof option == 'string') {

				data[option].apply(data, args)
			}
		})
	}

	var old = $.fn.dcaCompanyList;

	$.fn.dcaCompanyList = Plugin;
	$.fn.dcaCompanyList.Constructor = DcaCompanyList;

	// ==================

	$.fn.dcaCompanyList.noConflict = function() {
		$.fn.topicRefPhysicsListRef = old;
		return this
	}

})(jQuery);

$(function() {

	$('#dcaCompanyList').dcaCompanyList({

	})

})
