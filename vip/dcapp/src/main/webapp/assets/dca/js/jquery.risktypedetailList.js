/**
 * 绩效指标管理列表
 */
+(function ($) {

    function RisktypedetailList(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        var pass=true;
        $("#btnSubmit").click(function() {
        	confirmx("确定保存...",function(){
				$("font").html("*");
				var dom=$("#tvalue").find("td input");
				var list=new Array();
//        	var digit= /^\d+(?:\.\d{1,2})?$/;
				for(var a=0 ;a<dom.length;a++){
					var obj = new Object();    
					obj.riskType=dom[a].id.split("_")[0];    
					obj.riskLevel=dom[a].id.split("_")[1];    
					obj.points=$(dom[a]).val();
					if($(dom[a]).val()==""){
						$(dom[a]).next().html("必填")
						return false;
					}
					pass=_checkData($(dom[a]).val());
					if(!pass){
						$(dom[a]).next().html("错误")
						return;
					}
					
					list.push(obj);
				}
				var json_str = JSON.stringify(list);
				
				$.post(ctx + '/dca/risktypedetail/save', {
					list : json_str
				}, function(res) {
					if (res == "success") {
						alertx("保存成功！");
						return false;
					} else {
						alertx("保存失败！");
						return false;
					}
				});
			})
        	
        })
        
        
    }
    
    RisktypedetailList.prototype.getData = function () {
    	
    	$.getJSON(ctx+'/dca/risktypedetail/getData', function (data) {
    		
	        $.each(data, function (i, item) {
	        	var idName = item.riskType+"_"+item.riskLevel;
	        	$("#"+idName).val(item.points)
	        })
	    });
	    
	}
    
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
    
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.RisktypedetailList');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.RisktypedetailList', (data = new RisktypedetailList(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.RisktypedetailList;

    $.fn.RisktypedetailList = Plugin;
    $.fn.RisktypedetailList.Constructor = RisktypedetailList;
    
    $.fn.RisktypedetailList.noConflict = function () {
        $.fn.RisktypedetailList = old;
        return this;
    }

})(jQuery);


$(function () {
    $('#RisktypedetailList').RisktypedetailList("getData");
    
})

