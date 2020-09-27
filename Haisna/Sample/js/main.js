/***  Dropdown Navi  ***/
	var dropdownNav = function() { /* ドロップダウンメニュー*/

		$('.trigger').click(function() { 
			if ($(this).hasClass('selected')) {
	      // メニュー非表示
	      $(this).removeClass('selected');
				$(this).next('.submenu').hide();
	    } else {
	      // 表示しているメニューを閉じる
	      $('.trigger').removeClass('selected');
	      $('.submenu').hide();

	      // メニュー表示
	      $(this).addClass('selected').next('.submenu').show();

	    }    
	  });
		$(document).on('click', function(event) {
		  if (!$(event.target).closest('.trigger,.submenu').length) {
		      $('.trigger').removeClass('selected');
		      $('.submenu').hide();
		  }
		});

	};
/***  Match Height  ***/
	var matchHeight = function() { /* 指定したエレメントの高さを揃える */
		$('.mh-box > div').matchHeight();
		$('.mh-list > li').matchHeight();
	};

$(function(){
	dropdownNav();
	matchHeight();
});


