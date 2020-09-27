function childMenu() {
	//$('.menu').height($('.menu> ul').height());
	$('.menu').find("li").click(function(event){
		event.stopPropagation();
		//alert("xx");
		//event.stopPropagation();
//		$(event.target).siblings().removeClass('clicked').find(
//				'ul').animate({
//			width : 'hide'
//		});
//		$(event.target).children('ul').toggleClass('clicked')
//				.animate({
//					width : 'show'
//				});
	});
	$('.menu li:not(:has(ul)) ').mouseout(function(event) {}).removeClass('fly');
	$('.menu').mouseout(function() {});
//	$('#desktop').click(function(event){
//		
//		var t = false;
//		for ( var s = 0; s < $('.menu li').length; s++) {
//			
//			if ($('.menu li')[s] == event.target) {
//				t = true;
//			}
//		}
//		if (!t) {
//			$('.menu li ').siblings().removeClass('clicked')
//					.find('ul').fadeOut();
//
//			event.stopPropagation();
//		}
//		t = false;
//	});
}
