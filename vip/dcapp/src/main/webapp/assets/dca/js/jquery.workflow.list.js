+(function($) {

	/**
	 * 
	 * @param element
	 *            dom节点
	 * @param options
	 *            options 参数
	 * @constructor
	 */
	function workFlowList(element, options) {
		
		this.$element = $(element);

		this.options = $.extend({}, {msg1:'该工作流正加载到数据引擎中，不可进行编辑。',msg2:'该工作流正加载到数据引擎中，不可设置流程。',msg3:'该工作流正加载到数据引擎中，不可删除。',msg4:'确定删除？'}, options);
 
		this.flag = true;
		
		_render.call(this)

	}

	/**
	 * 
	 * @private
	 */
	function _render() {
		var $this = this;
		
		this.$element		
		.on('click', '.editCheck', function() {
			if($this.flag){
				var _tr = $(this).parents('tr:first');
				var _wfId = $("[data-id='dcaWorkflow-wfId']",_tr).val();
					$.get(ctx+'/dca/dcaWorkflow/universalCheck', {wfId : _wfId}, function (res) {
						if (!res) {
                             alertx($this.options.msg1);
						}else {
							var href= ctx+"/dca/dcaWorkflow/form?id="+ _wfId ;
							$this.flag=false;
							$('.editCheck',_tr).attr('href',href).get(0).click();	
						}
					});
					}
			})
		
		
		
		.on('click', '.processSettingCheck', function() {			
			if($this.flag){
				var _tr = $(this).parents('tr:first');
				 var _wfId = $("[data-id='dcaWorkflow-wfId']",_tr).val();
					$.get(ctx+'/dca/dcaWorkflow/universalCheck', {wfId : _wfId}, function (res) {
						if (!res) {
                             alertx($this.options.msg2);
						}else {							
							var href= ctx+"/dca/dcaWorkflow/flow?id="+ _wfId ;
							$this.flag=false;
							$('.processSettingCheck',_tr).attr('href',href).get(0).click();								
						}
					});
				}
			})
		
		
		.on('click', '.deleteCheck', function() {			
			if($this.flag){
				var _tr = $(this).parents('tr:first');
				 var _wfId = $("[data-id='dcaWorkflow-wfId']",_tr).val();
					$.get(ctx+'/dca/dcaWorkflow/universalCheck', {wfId : _wfId}, function (res) {
						if (!res) {
                                alertx($this.options.msg3);
						}else {
							confirmx($this.options.msg4, function(){
								var href= ctx+"/dca/dcaWorkflow/delete?id="+ _wfId ;
								$this.flag=false;
								$('.deleteCheck',_tr).attr('href',href).get(0).click();	
							});
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
			var data = $this.data('dcapp.workFlowList')
			var options = typeof option == 'object' && option

			if (!data) {
				$this.data('dcapp.workFlowList',
						(data = new workFlowList(this, options)))
			}

			if (typeof option == 'string') {

				data[option].apply(data, args)
			}
		})
	}

	var old = $.fn.workFlowList;

	$.fn.workFlowList = Plugin;
	$.fn.workFlowList.Constructor = workFlowList;

	// ==================

	$.fn.workFlowList.noConflict = function() {
		$.fn.workFlowList = old;
		return this
	}

})(jQuery);

$(function() {

	$('#workFlowList').workFlowList({

	})
	

})
