/**
 * 绩效指标管理列表
 */
var msglist=[];

+(function ($) {

    function KpiList(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        this.$element
        .on('click','#btnSubmit',function(){
        	
        	if(_checkData()){
        		$this.save();
        	}else{
        		
        		// 弹出提示框
        		if(msglist != null && msglist.length != 0){
        			var text = "";
        			for(var i=0;i< msglist.length;i++){
        				text += "<p>" + msglist[i] + "</p>";
        			}
        			alertx(text);
        			msglist = [];
        		}
        		
        	}
        	
        	var value = $('input[data-id=inputText]').val();
        	var name = $(this).attr
        	
        	
        	
        	
        })
    }
    
    KpiList.prototype.save = function () {
    	var arrayList = [];
    	$(".KPIList").each(function(){
    		var items={
    				idxId:$(this).attr('id'),
    				idxName:$(this).attr('data-idxName'),
    				idxType:$(this).attr('data-idType'),
    				kpiResult:$(this).val()
    		}
    	
    	   arrayList.push(items);
    	});
    	var param={
    			result:JSON.stringify(arrayList)
    		}
		
		$.post(ctx+'/kpi/dcaKpi/savaKPIResult',param,function(result){
			if(result == "success"){
				alertx("保存成功！",function(){
					window.location.reload();
				});
			}else{
				alertx("保存失败！");
			}			
		});		
	}
    
    function _checkData(){
    	
    	$(".KPIList").each(function(){
    		var kpiResult =$(this).val();
    		var name = $(this).attr('data-idxName');
    		
    		if(!_isBlank(kpiResult)){
        		if(!_isNumAlph(kpiResult)){
        			msglist.push(name + '输入不合规，请录入后重新保存！');
        		}
        	}else{
        		msglist.push(name + '为必填项目，请录入后重新保存！');
        	}
    	})
    	
    	if(msglist != null && msglist.length != 0){
    		return false;
    	}
    	
    	return true;
    }
    
   //只能输入正、负 数字，最多输入4位整数和2位小数
    function _isNumAlph(a){
    	var reg=/^(\-|\+)?(\d[0-9]{0,3}|0)(\.\d{1,2})?$/;
    	return reg.test(a);
    }
  
    /**
     * 判断是否为空
     * @private
     */
    function _isBlank(value){
		if(value == ""){
			return true;
		}else{
			return false;
		}
	}
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.kpiList');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.kpiList', (data = new KpiList(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.kpiList;

    $.fn.kpiList = Plugin;
    $.fn.kpiList.Constructor = KpiList;
    
    $.fn.kpiList.noConflict = function () {
        $.fn.kpiList = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('#kpiList').kpiList({});
})

