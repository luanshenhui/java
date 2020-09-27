/**
 * 首页框架
 */
var t;
var index = 0;
var powerIdList = ['0701','0601','0501', '0101','0201', '0301', '0401'];

+(function ($) {

    function HomePage(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        
        this.$element

        	// 点击按钮的hover
	        .on('click', 'li[data-role=item]', function () {
	        	
	        	$("li[data-role=item]").removeClass('active');
	            $(this).addClass('active');
	            
	    		var powerId = $(this).attr('data-powerId');
	    		
	    		// 监管职责
	    		if(powerId == "duty"){
	    			$('#iframe-main').attr('src',  ctx+'/index/duty');
	    		// 流程说明
	    		}else if(powerId == "workflowinstruction"){
	    			$('#iframe-main').attr('src',  ctx+'/index/workflowinstruction');
	    		// 风险点
	    		}else if(powerId == "riskpoint"){
	    			$('#iframe-main').attr('src',  ctx+'/index/riskpoint');
	    		// 其他权力
	    		}else if(powerId == "0601") {
				$('#iframe-main').attr('src',  'http://222.85.142.100:38090/tieTouBoxContent/model.html');
			//	window.location.href = 'http://222.85.142.100:38090/index.jsp'
                        }else if(powerId == "0701") {
                                $('#iframe-main').attr('src',  '../../../../static/tljs/index1.html');
		        }
                        else{
				$('#iframe-main').attr('src',  ctx+'/index/homepageDetail?powerId='+powerId);
	    		}
				
	        })
	        
	        .on('click', '.header-btn', function(){
	        	
	        	var frequency = $('#frequency').val()*1000;
	            clearInterval(t);
	            t = setInterval(function(){
			if(index==0) {
				$('#iframe-main').attr('src',  'http://222.85.142.100:38090/tieTouBoxContent/shangTong.html');
			}
			else if(index==1){
				$('#iframe-main').attr('src',  'http://222.85.142.100:38090/tieTouBoxContent/model.html');
			}
			else{ 
	                	$('#iframe-main').attr('src',  ctx+'/index/homepageDetail?powerId='+powerIdList[index]);
	                }
	                $("li[data-role=item]").removeClass('active');
	                $('li[data-powerId="'+ powerIdList[index] +'"]').addClass('active');
	                
	                index = (index == 7 )?0:index+1;
	                if(index == 0){
	                	$('#iframe-main').attr('src',  ctx+'/index/homepageInfo');
	                }

	            }, frequency);
	            
	            $('div[data-id="header-btn-stop"]').removeClass("display-none").addClass("display-block");
	            $('div[data-id="header-btn-start"]').removeClass("display-block").addClass("display-none");
	        })
	        
	        .on('click', 'div[data-id="header-btn-stop"]', function(){
	            clearInterval(t);
	            $('div[data-id="header-btn-start"]').removeClass('display-none').addClass("display-block");
	            $('div[data-id="header-btn-stop"]').removeClass('display-block').addClass("display-none");

	        })
	        
    }
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.homePage');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.homePage', (data = new HomePage(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.homePage;

    $.fn.homePage = Plugin;
    $.fn.homePage.Constructor = HomePage;
    
    $.fn.homePage.noConflict = function () {
        $.fn.homePage = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
    $('#homePage').homePage();

	var refreshTime = $('#refreshTime').val()*60000;
	// 定时刷新首页
	setInterval(function(){
		window.location.reload(); 
	}, refreshTime);
    
})

