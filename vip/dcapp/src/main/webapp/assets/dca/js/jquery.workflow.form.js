/**
 * 告警上报设置添加/修改
 */


(function ($) {

    function WorkFlowForm(element, options) {
    	
        this.$element = $(element)

        this.options = $.extend({}, {}, options);
        
        _buildEvent.call(this);
        
        _ajax.call(this);
        
        $("#inputForm").validate({
			rules: {
				wfName: {
					nameCheck : true,
					remote: ctx+"/dca/dcaWorkflow/checkWfName?oldwfName=" + encodeURIComponent($('#oldwfName').val()),
					
					},
				traceDictId:{
	        		// 自定义校验方法-模板ID格式
					traceDictIdCheck : true
	    		}
			},
			messages: {
				wfName: {
					nameCheck : "允许输入汉字、英文、数字、下划线的长度为1~80个字符的名称",
					remote: "工作流名称已存在"
					}
			},
			submitHandler: function(form){
				loading('正在提交，请稍等...');
				//dataType();
				form.submit();
			},
			errorContainer: "#messageBox",
			errorPlacement: function(error, element) {
				$("#messageBox").text("输入有误，请先更正。");
				if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
					error.appendTo(element.parent().parent());
				} else {
					error.insertAfter(element);
				}
			}
		}); 
    }
  
    
    function dataType(){
		var dd = "";
		var ee="";
		if($("input[type='checkbox'][name='mokedoc']:checked").attr("checked")){//选中了
			   $("#dds").text("");
			   $('input:checkbox[name="mokedoc"]:checked').each(function(){
				    dd += $(this).attr("data-label")+"\n";
				    ee += $(this).val()+"||";
				    $("#dds").val(dd);
			   });
			   if(ee.length>=4){
				   var newstr=ee.substring(0,ee.length-2);
			       $("#save-idxDataType").val(newstr);
			   }
			   
		}else{$("#dds").val("");} 
	} 
    
	function _ajax(){
		$.ajax({
		    url:ctx+'/dca/dcaWorkflow/getDict',
		    type:'get', //GET
		    dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
		    success:function(data){
		    	//取得数据库值，分割
		    	array=$("#idx-data-type").val().split("||");
		    	var str="";
		    	$.each(data,function(index,value){
		    		var checkBoxValue=value.value;
		    		var checkBoxLabel=value.label;
		    		str+='<li><input type="checkbox" class="way" name="mokedoc" value="'+checkBoxValue+'" data-label="'+checkBoxLabel+'" >'+checkBoxLabel+'</li>'
		    	})
		    	$('#yaw').html(str);
		    	//huixia
		    	$.each(array,function(index,value){
		    	   $("input[class='way'][value='"+value+"']").attr("checked","checked");
	    		});
		    	dataType.call(this);
		    }
		})
		
		
	}

	 
    function _buildEvent() {

        var $this = this;
        
        this.$element

            .on('click', '.clickPop', function () {
            	$('.pop').show();
            })
            .on('click', '.shut', function () {
            	$('.pop').hide();
            })
            .on('click','.way', dataType)
            .on('click','#startTime',function(){
                
            	WdatePicker({
            		dateFmt:'yyyy-MM-dd HH:mm:ss',
            		maxDate:'#F{$dp.$D(\'endTime\')||\'2020-10-01 00:00:00\'}',
            		isShowClear:true
            	});
            })
            
            .on('click','#endTime',function(){
            	WdatePicker({
            		dateFmt:'yyyy-MM-dd HH:mm:ss',
            		minDate:'#F{$dp.$D(\'startTime\')}',
            		maxDate:'2020-10-01 00:00:00',
            		isShowClear:true
            	});
            });
    }
    
  
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.WorkFlowForm')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.WorkFlowForm', (data = new WorkFlowForm(this, options)))
            }

            if (typeof option == 'string') {

                data[option].apply(data, args)
            }
        })
    }
    
    var old = $.fn.workFlowForm;

    $.fn.workFlowForm = Plugin;
    $.fn.workFlowForm.Constructor = WorkFlowForm;
    
    $.fn.workFlowForm.noConflict = function () {
        $.fn.workFlowForm = old;
        return this
    }

})(jQuery);


$(function () {
	
	$("#WorkFlowForm").workFlowForm({
		
    })

    // 模板ID（只允许输入字母（a～z,A～Z）,数字（0～9））
	jQuery.validator.addMethod("traceDictIdCheck", function(value, element) {
		
	    return this.optional(element) || /^[a-zA-Z0-9]*$/.test(value);
	    
	}, "模板ID必须必须为字母或数字");
	
  	
	// 工作流名称-自定义校验（只允许输入汉字、英文、数字、下划线）
	jQuery.validator.addMethod("nameCheck",function(value, element) {

		if (!/^[\u4e00-\u9fa5a-zA-Z0-9_()（）]{0,80}$/.test(value)) {
			return this.optional(element) || false;
			
		} else {
			
			// 合法格式
			return this.optional(element) || true;
		}
		
	},"允许输入汉字、英文、数字、下划线的长度为1~80的名称");

})

