(function($) {

	$.fn.spasticNav = function(options) {
	
		options = $.extend({
			overlap : 20,
			speed : 500,
			reset : 1500,
			//color : '#0b2b61',
			color : '#aaaaaa',
			easing : 'easeOutExpo'
		}, options);
	
		return this.each(function() {
		
		 	var nav = $(this),
		 		currentPageItem = $('#selected', nav),
		 		blob,
		 		reset;
		 		
		 	$('<li id="blob"></li>').css({ /*新修改*/
		 		width : 186,//currentPageItem.outerWidth(),
		 		height : 90,//currentPageItem.outerHeight() + options.overlap,
		 		left : currentPageItem.position().left,
		 		top : currentPageItem.position().top - options.overlap / 2,
		 		backgroundColor : options.color
		 	}).appendTo(this);

		 	blob = $('#blob', nav);
		 	
			$('li:not(#blob)', nav).hover(function() {
				
				// mouse over
				clearTimeout(reset);
				blob.animate(
					{
						left : $(this).position().left,
						width : $(this).width(),
						height : 90  
					},
					{
						duration : options.speed,
						easing : options.easing,
						queue : false
					}
				);
				
				//选中标题的字体颜色为黑色，其余为白色
				var id = $.cookie("btid");
				var arr = new Array();
				arr =['jdsw','sssw','jdlf','sslf'];
				for(var i=0;i<arr.length;i++){
					if(id == arr[i]){
						$("#"+id).css("color","#292929");
					}else{
						$("#"+arr[i]).css("color","#FFFFFF");
					}
				}
				
			});
		
		}); // end each
	
	};

})(jQuery);