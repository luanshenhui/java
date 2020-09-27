/**
 * 绩效指标新增
 */
+(function ($) {

    function KpiIdxForm(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

	function _buildEvent() {

		var $this = this;

		$("#btnSubmit").click(function() {
			// 判断项目指标名称是否重复
			$.get(ctx + '/kpi/dcaKpiIdx/checkName', {
				idxName : $('#idxName').val().trim(),
				idxType : $('#idxType').val().trim()
			}, function(res) {
				// 名称已存在
				if (res == "false") {
					alertx("项目名称为空或在此类型中已存在，请重新输入！");
					return false;
				} else {
					$this.saveSubmit();
				}
			});

		})
	}
	/**
	 * 绩效临界值格式大小判断
	 */
	function _checkData(value) {
		var _numFlag = true;
		if (value) {
			var digit = /^-?\d+(\.\d+)?$/;
			if (!digit.test(value)) {
				_numFlag = false;
			} else {
				value = value.replace("-", "");
				arr = value.split(".");
				if (arr[0] < 0 || arr[0] > 9999) {
					_numFlag = false;
				} else {
					if (arr[1] < 0 || arr[1] > 99) {
						_numFlag = false;
					} else {
						_numFlag = true;
					}
				}
			}
		}
		return _numFlag;
	}

    KpiIdxForm.prototype.saveSubmit = function() {

		if ($("#inputForm").valid()) {
			// 绩效临界值非空标示
			var _checkFlag = false;
			// 绩效临界值降序标示
			var _orderFlag = false;
			// 绩效临界值格式大小正确标示
			var _numFlag = false;
			var data = {};
			var len = $("input[id^='idxValue']").length;
			for (var i = 1; i <= len; i++) {
				var idx = $("#idxValue0" + i).val();
				var value = $("#criticalityValue0" + i).val();
				// 绩效临界值不能为空
				if (value) {
					if (_checkData(value)) {
						data[idx] = value;
					} else {
						_numFlag = true;
					}
				} else {
					_checkFlag = true;
				}
			}
			// 绩效临界值必须降序排列
			if (!_checkFlag && data['05'] - data['04'] > 0
					&& data['04'] - data['03'] > 0
					&& data['03'] - data['02'] > 0
					&& data['02'] - data['01'] > 0) {
				_orderFlag = false;
			} else {
				_orderFlag = true;
			}
			if (_checkFlag) {
				alertx("绩效临界值不能为空！");
			} else if (_numFlag) {
				alertx("绩效临界值大小不在-xxxx.xx到xxxx.xx格式范围内！");
			} else if (_orderFlag) {
				alertx("绩效临界值由高到低且不能相等！");
			} else {
				var json_str = JSON.stringify(data);
				$("#dataMap").val(json_str);
				loading('正在提交，请稍等...');
				// 添加cation属性值
				$("#inputForm").attr('action', ctx + '/kpi/dcaKpiIdx/save')
						.get(0).submit();
			}
		}
	}         
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.KpiIdxForm');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.KpiIdxForm', (data = new KpiIdxForm(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.kpiIdxForm;

    $.fn.kpiIdxForm = Plugin;
    $.fn.kpiIdxForm.Constructor = KpiIdxForm;
    
    $.fn.kpiIdxForm.noConflict = function () {
        $.fn.kpiIdxForm = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('#inputForm').kpiIdxForm({});
	    
	// 输入项目指标名称非空校验
	$("#inputForm").validate({
		// 校验对象（项目名称）
		rules : {
			idxName : {

				required : true,
			}

		},
		// 校验对象非法对应的校验信息
		messages : {
			idxName : {

				required : "项目不能为空！"
			}
		},
	});
    
})

