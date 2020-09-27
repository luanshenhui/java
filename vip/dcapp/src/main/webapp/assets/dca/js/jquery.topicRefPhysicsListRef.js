+(function($) {

	/**
	 * 
	 * @param element
	 *            dom节点
	 * @param options
	 *            options 参数
	 * @constructor
	 */
	function TopicRefPhysicsListRef(element, options) {
		
		this.$element = $(element);

		this.options = $.extend({}, {}, options);

		this.changeFlag = false;

		/* 20161125jsp上的js */
		this.slist = [];
		this.dlist = [];

		if ($('#pageFlg').val() == 1) {
			top._TopicRefPhysicsListRef = {
				sList : {},
				dList : {}
			};
		}

		this.topicId, this.tableName, this.tableComment;
		/* 结束 */

		_buildEvent.call(this);

		_render.call(this)

	}

	/**
	 * 
	 * @private
	 */
	function _render() {

		$('form input[type="checkbox"]:checked', this.$element).addClass(
				'checked');
		$('form input[type="checkbox"]:unChecked', this.$element).addClass(
				'unChecked');

		/*$.each(top._TopicRefPhysicsListRef.sList,function(k,v){
			
			$('input:checkbox[data-id='+k+']').prop('checked',true)
			
			
		})
		
		$.each(top._TopicRefPhysicsListRef.dList,function(k,v){
			
			$('input:checkbox[data-id='+k+']').prop('checked',false)
			
		})*/
		
		
		//return false;
		
		var saveListVal = $("[data-id='slist']", this.$element).val();
		var delListVal = $("[data-id='dlist']", this.$element).val();
		/* 20161125jsp上的js */
		if (saveListVal) {
			this.slist = JSON.parse(saveListVal);
		}
		if (delListVal) {
			this.dlist = JSON.parse(delListVal);
		}
		var container = $('.tableName', this.$element);
		for (var j = 0; j < this.slist.length; j++) {

			for (var k = 0; k < container.length; k++) {

				if (this.slist[j].tableName === $(container[k]).val()) {

					$('input[type="checkbox"]', this.$element).eq(k).attr('checked', 'true');
				}

			}
		}
		for (var v = 0; v < this.dlist.length; v++) {

			for (var y = 0; y < container.length; y++) {

				if (this.dlist[v].tableName === $(container[y]).val()) {

					$('input[type="checkbox"]', this.$element).eq(y).removeAttr('checked');
				}

			}
		}
		/* 结束 */

	}

	function _buildEvent() {

		var $this = this;

		this.$element

				.on(
						'click',
						'input:checkbox[data-name=chkbox]',
						function(e) {
							var _tr = $(this).parents('tr:first');
							$this.topicId = $('input[data-name=topicId]', _tr).val();
							
							
							$this.tableName = $('input[data-name=tableName]', _tr).val();
							$this.tableComment = $('input[data-name=tableComment]', _tr).val();
							// 选中状态
							if ($(e.target).is(':checked')) {

								if ($(e.target).hasClass('unChecked')) {

									var toSave = {
										topicId : $this.topicId,
										tableName : $this.tableName,
										tableComment : $this.tableComment
									}

									$this.slist.push(toSave);

								} else {
									
									var toDelete = {
										topicId : $this.topicId,
										tableName : $this.tableName,
										tableComment : $this.tableComment
									};
									for (var i = 0; i < $this.dlist.length; i++) {
										if (toDelete.tableName === $this.dlist[i].tableName) {
											$this.dlist.splice(i, 1);
										}
									}
								}

							} else {
								// 未选中状态

								if ($(e.target).hasClass('unChecked')) {
									
									
									var toDeleteSave = {
										topicId : $this.topicId,
										tableName : $this.tableName,
										tableComment : $this.tableComment
									};
									
									for (var i = 0; i < $this.slist.length; i++) {
										if (toDeleteSave.tableName === $this.slist[i].tableName) {
										
											$this.slist.splice(i, 1);
										}
									}

								} else {
									var toDelete = {
										topicId : $this.topicId,
										tableName : $this.tableName,
										tableComment : $this.tableComment
									}
									$this.dlist.push(toDelete);

								}
							}
							
							$("[data-id='slist']").val(JSON.stringify($this.slist), this.$element);
							$("[data-id='dlist']").val(JSON.stringify($this.dlist), this.$element);

						})

				.on('submit', '#setPhy', function() {
					if ($this.slist.length!=0 || $this.dlist.length!=0 ) {
						 $this.changeFlag = true;
						 $("[data-id='changeFlag']", this.$element).val("0");
						 loading('正在提交，请稍等...');
					} else {
						 $this.changeFlag = false;
						 if($('#messageBox', this.$element).length==0){
						var messageDiv='<div id="messageBox" class="alert alert-warning " style="position: relative; z-index: 10000;"><button data-dismiss="alert" class="close">×</button>请选择物理表后，进行保存。</div>';
						$('#searchForm', this.$element).after(messageDiv); }
						top.$.jBox.tip.mess=1;top.$.jBox.tip("请选择物理表后，进行保存。","warning",{persistent:true,opacity:0});$("#messageBox").show();
						$("[data-id='changeFlag']", this.$element).val("1");
					}

					return $this.changeFlag;

				});

	}

	// ========================

	function Plugin(option) {

		var args = Array.prototype.slice.call(arguments, 1)

		return this.each(function() {
			var $this = $(this);
			var data = $this.data('dcapp.TopicRefPhysicsListRef')
			var options = typeof option == 'object' && option

			if (!data) {
				$this.data('dcapp.TopicRefPhysicsListRef',
						(data = new TopicRefPhysicsListRef(this, options)))
			}

			if (typeof option == 'string') {

				data[option].apply(data, args)
			}
		})
	}

	var old = $.fn.topicRefPhysicsListRef;

	$.fn.topicRefPhysicsListRef = Plugin;
	$.fn.topicRefPhysicsListRef.Constructor = TopicRefPhysicsListRef;

	// ==================

	$.fn.topicRefPhysicsListRef.noConflict = function() {
		$.fn.topicRefPhysicsListRef = old;
		return this
	}

})(jQuery);

$(function() {

	$('#topicRefPhysicsListRef').topicRefPhysicsListRef({

	})
	

})
