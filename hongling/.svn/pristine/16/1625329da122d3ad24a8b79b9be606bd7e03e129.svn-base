(function($) {
  $.updateWithJSON = function(data) {
  	  if($.csValidator.isNull(data)){
  	  	return ;
  	  }
	$.each(data,function(fieldName,fieldValue) {
	  if(!$.csValidator.isNull(fieldValue)){
		  fieldValue = unescape(fieldValue);
	  }else{
		  fieldValue = "";
	  }

	  var $field = $('#'+fieldName);
	  if ($field.length < 1) {
		$field = $('input,select,textarea').filter('[name="'+fieldName+'"]');
	  }
	  if ($field.eq(0).is('input')) {
		var type = $field.attr('type');
		switch (type) {
		  case 'checkbox':
			if ($field.length > 1) {
			  $field.each(function() {
				var value = $(this).val();
				try{
					if ($.inArray(value,fieldValue) != -1) {
					  $(this).attr('checked','true');
					} else {
					  $(this).attr('checked','');
					}
				}
				catch(e){}
				
			  });
			} else {
			  if ($field.val() == fieldValue) {
				$field.attr('checked','true');
			  } else {
				$field.attr('checked','');
			  }
			}
			break;
		  case 'radio':
			$field.each(function() {
			  var value = $(this).val();
			  if (value == fieldValue) {
				$(this).attr('checked','true');
			  } else {
				//$(this).attr('checked','');
			  }
			});
			break;
		  default:
			$field.val(fieldValue);
			break;
		}
	  } else if ($field.is('select')) {
		var $options = $('option',$field);
		var multiple = $field.attr('multiple');
		$options.each(function() {
		  var value = $(this).val() || $(this).html();
		  switch (multiple) {
			case true:
			  if ($.inArray(value,fieldValue) != -1) {
			  	  
				$(this).attr('selected','true');
			  } else {
				$(this).attr('selected','');
			  }
			  break;
			default:
			  if (value == fieldValue) {
				$(this).attr('selected','true');
			  } else {
				//$(this).attr('selected','');
			  }
			  break;
		  }
		});
	  } else  {
		$field.text(fieldValue);
	  } 
	});
  }
})(jQuery);