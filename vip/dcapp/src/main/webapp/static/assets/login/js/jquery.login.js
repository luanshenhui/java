/**
 * 登陆
 */
+(function ($) {

    function Login(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;

        this.$element

            .on('click', 'button[data-id="loginBtn"]', function () {
            	
        		var name = $('#username').val(),
        			pwd = $('#password').val();
        		
        		var width = '1400',
        			heigth = '1080';
        		if(window.screen.width == '1366'){
        			width = '1354';
        			heigth = '701';
        		}
        		
        		var locationHref = window.location.href;
        		var locationUrl = locationHref.split("/");
        		
        		// 向融合分析平台发起登陆
        		$.post("http://" + locationUrl[2] + "/a/login", {username: name, password: pwd}, function(){
        			// 向OA发起登陆
        			var div = $('<div>').load("http://" + locationUrl[2] + "/OAapp/WebObjects/OAapp.woa/wa/loginOA #hrefId", 
        					{language: 'CN', userId: name, password: pwd, Width: width, Height: heigth},function(){
    					
        				// 从cookie中获取链接
        				var href = getCookie('href');
        				
    					if(href){
    	    				if(href == 'oa'){
    	    					href = $('a',div).attr('href');
    	    				}
    	    				
    	    				window.location = href;
    					}else{
    						window.location = 'main.html';
    					}
    				})
    				
        		});
    			
            })
    }
    
    /* 
		功能：获取cookies函数  
		参数：name，cookie名字 
	*/  
	function getCookie(name){  
	    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));  
	    if(arr != null){  
	     return unescape(arr[2]);   
	    }else{  
	     return null;  
	    }  
	}
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.login');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.login', (data = new Login(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.login;

    $.fn.login = Plugin;
    $.fn.login.Constructor = Login;
    
    $.fn.login.noConflict = function () {
        $.fn.login = old;
        return this;
    }

})(jQuery);


$(function () {
	
    $('.login').login();
})

