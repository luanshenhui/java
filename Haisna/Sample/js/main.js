/***  Dropdown Navi  ***/
	var dropdownNav = function() { /* �h���b�v�_�E�����j���[*/

		$('.trigger').click(function() { 
			if ($(this).hasClass('selected')) {
	      // ���j���[��\��
	      $(this).removeClass('selected');
				$(this).next('.submenu').hide();
	    } else {
	      // �\�����Ă��郁�j���[�����
	      $('.trigger').removeClass('selected');
	      $('.submenu').hide();

	      // ���j���[�\��
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
	var matchHeight = function() { /* �w�肵���G�������g�̍����𑵂��� */
		$('.mh-box > div').matchHeight();
		$('.mh-list > li').matchHeight();
	};

$(function(){
	dropdownNav();
	matchHeight();
});


