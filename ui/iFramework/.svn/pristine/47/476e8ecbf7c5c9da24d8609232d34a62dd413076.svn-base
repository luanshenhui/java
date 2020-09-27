Array.prototype.in_array = function(value) {	
	var i;
	for (i=0; i < this.length; i++) { 
		if (this[i] === value) { 
			return true; 
			}
		} 
	return false; 
};
// 特殊字符验证
$jQuery.validator.addMethod("specialCharCheck",
		function(value, element) {
			if (value == "")
				return true;
			if (element.type == "textarea") {
				var ESCAPED_CODE_POINTS = [ '\'', '\^', '\#', '$', '%', '\&',
						'\|', '\:', '\[', '\]', '\{', '\}', '\=', '\"', '\>',
						'\<', '?' ,'\\'];
				var chars = value.split("");
				var i = 0;
				for (i = 0; i < chars.length; i++) {
					if (ESCAPED_CODE_POINTS.in_array(chars[i])) {
						return false;
					}
				}
				return true;
			} else if (element.type == "text") {
				var tt = /^(?!.*?[\'\^\#\$%\&\|\:\[\]\{\}\=\"\>\<?\\]).*$/;
				if(this.optional(element) || tt.test(value)){
					return true;
				}else{
					return false;
				}
			}
		});

// 中文字两个字节
$jQuery.validator.addMethod("byteRangeLength",
		function(value, element, param) {
			if ($jQuery.trim(value) == "") {
				return this.optional(element) || true;
			}
			var length = value.length;
			for ( var i = 0; i < value.length; i++) {
				if (value.charCodeAt(i) > 127) {
					length = length + 1;
				}
			}
			return this.optional(element)
					|| (length >= param[0] && length <= param[1]);
		});

// 邮政编码验证
$jQuery.validator.addMethod("isZipCode", function(value, element) {
	var tel = /^[0-9]{6}$/;
	return this.optional(element) || (tel.test(value));
});
//用户名密码只允许输入数字和字符及下划线
$jQuery.validator.addMethod("accountValidate",
		function(value, element) {
	 var regx = /^[a-zA-Z0-9_]{1,}$/; 
	 return regx.test(value);
});
/**
 * 定位图标
 */
function getImgPosition(objectId) {
	var _left, _top, _leftIE, leftTemp;
	leftTemp = getAbsoluteLeft(objectId);
	var windowWidth = getWindowWidth();
	var oWidth = getElementWidth(objectId);
	var oHeight = getElementHeight(objectId);
	_top = getAbsoluteTop(objectId);
	_left = leftTemp + oWidth + 2;
	_top = _top - oHeight - 2;

	arrayPosition = new Array(_left, _top);
	return arrayPosition;
}
/**
 * 定位提示
 */
function getTipPosition(objectId,withIMG) {
	var imgWidth=0;
	if(withIMG){imgWidth=10;}
	var _left, _top, leftTemp;
	leftTemp = getAbsoluteLeft(objectId);
	var windowWidth = getWindowWidth();
	var oWidth = getElementWidth(objectId);
	var oHeight = getElementHeight(objectId);
	_top = getAbsoluteTop(objectId);
	if (windowWidth - leftTemp - oWidth < 160) {	
		if (oHeight > 24) {
			_left = leftTemp + oWidth - 110 - 10;
			_top = _top - oHeight + 2;
		} else {
			_left = leftTemp + 20;
			_top = _top + 2;
		}
	} else {
		_left = leftTemp + oWidth + imgWidth;						
		_top = _top - oHeight - 2;
	}
	//alert("windowWidth"+windowWidth+'_'+"leftTemp"+ leftTemp+'_'+"oWidth"+ oWidth+'_'+"_left"+_left+"_"+"_top"+_top+'_oHeight'+oHeight);
	arrayPosition = new Array(_left, _top);
	return arrayPosition;
}
function getAbsoluteLeft(objectId) {
	// var objectId = element.id;
	// Get an object left position from the upper left viewport corner
	var o = document.getElementById(objectId);
	var oLeft = o.offsetLeft; // Get left position from the parent object
	while (o.offsetParent != null) { // Parse the parent hierarchy up to the
										// document element
		oParent = o.offsetParent; // Get parent object reference
		oLeft += oParent.offsetLeft; // Add parent left position
		o = oParent;
		// alert(oParent.offsetLeft);
	}
	return oLeft;

};

function getAbsoluteTop(objectId) {
	// var objectId = element.id;
	// Get an object top position from the upper left viewport corner
	var o = document.getElementById(objectId);
	var oTop = o.offsetTop; // Get top position from the parent object
	while (o.offsetParent != null) { // Parse the parent hierarchy up to the
										// document element
		oParent = o.offsetParent; // Get parent object reference
		oTop += oParent.offsetTop; // Add parent top position
		o = oParent;
	}
	var oHeight = getElementHeight(objectId);
	oTop = oTop + oHeight + 2;
	return oTop;
};
function getElementWidth(objectId) {
	x = document.getElementById(objectId);
	return x.offsetWidth;
};
function getElementHeight(objectId) {
	x = document.getElementById(objectId);
	return x.offsetHeight;
};
function getWindowWidth() {
	var windowWidth = 0;
	if (self.innerHeight) { // all except Explorer
		windowWidth = self.innerWidth;
	} else if (document.documentElement
			&& document.documentElement.clientHeight) { // Explorer 6 Strict
														// Mode
		windowWidth = document.documentElement.clientWidth;
	} else if (document.body) { // other Explorers
		windowWidth = document.body.clientWidth;
	}
	return windowWidth;
}
function getWindowHeight() {
	if (self.innerHeight) { // all except Explorer
		windowHeight = self.innerHeight;
	} else if (document.documentElement
			&& document.documentElement.clientHeight) { // Explorer 6 Strict
														// Mode
		windowHeight = document.documentElement.clientHeight;
	} else if (document.body) { // other Explorers
		windowHeight = document.body.clientHeight;
	}
	return windowHeight;
}

// //校验提示框定位end
/**
 * 定位显示校验提示及图标
 *  */
function showErrorsWithPosition(error, element, _this,webpath) {
	var left, top, objectId, imgId;
	var afterObjs,lastObj;	
	for ( var i = 0; _this.errorList[i]; i++) {
		var error = _this.errorList[i];
		objectId = error.element.id;		
		_this.settings.highlight
				&& _this.settings.highlight.call(_this, error.element,
						_this.settings.errorClass, _this.settings.validClass);
		var error_show = error.message+' <iframe class="ifhideselect" border:#932621 solid 1px; frameborder="0" scrolling="false" style="z-index:-1;position:absolute;filter:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0);border:0;left:0;top:0;"></iframe> ';
		_this.showLabel(error.element, error_show);
		
		imgId = 'img_' + error.element.id;
		if (!$jQuery("#" + imgId).is('div')) {
			var imgsrc = webpath+"/view/common/image/stop.gif";
			var mouseover = "onMouseover=\"showTip('error_" + error.element.id
					+ "');\"";
			var mouseout = "onMouseout=\"hideTip('error_" + error.element.id
					+ "');\"";
			var imgHtml = "<div id=\""+imgId+"\"><img class=\"errorImg\"  height=\"16\" width=\"16\" src=" + imgsrc + " "
					+ mouseover + " " + mouseout + "></div>";			
			$jQuery("#" + objectId).after(imgHtml);

		}
	}
	if (_this.errorList.length) {
		_this.toShow = _this.toShow.add(_this.containers);
	}
	if (_this.settings.success) {
		for ( var i = 0; _this.successList[i]; i++) {
			_this.showLabel(_this.successList[i]);
		}
	}
	if (_this.settings.unhighlight) {
		for ( var i = 0, elements = _this.validElements(); elements[i]; i++) {
			_this.settings.unhighlight.call(_this, elements[i],
					_this.settings.errorClass, _this.settings.validClass);
		}
	}
	_this.toHide = _this.toHide.not(_this.toShow);
	_this.hideErrors();
	for ( var j = 0; _this.errorList[j]; j++) {
		var error = _this.errorList[j];
		var postion_img = getImgPosition(error.element.id);
		var left_img = postion_img[0];
		var top_img = postion_img[1];
		imgId = 'img_' + error.element.id;
		$jQuery("#" + imgId).css('position', 'absolute');
		$jQuery("#" + imgId).css("left", left_img);
		$jQuery("#" + imgId).css("top", top_img);
		var postion_tip = getTipPosition(error.element.id,true);
		var left = postion_tip[0];
		var top = postion_tip[1];
		var errorDivId = 'error_' + error.element.id;
		_this.toShow[j].id = errorDivId;
		$jQuery("#" + errorDivId).css('position', 'absolute');
		$jQuery("#" + errorDivId).css("left", left);
		$jQuery("#" + errorDivId).css("top", top);
		$jQuery("#" + errorDivId).css('display', 'none');
		$jQuery("#" + errorDivId).children().css("width",$jQuery("#" + errorDivId).css("width"));
		$jQuery("#" + errorDivId).children().css("height",$jQuery("#" + errorDivId).height()+10);		
	}
}
function showTip(objId) {
	$jQuery("#" + objId).show();
}
function hideTip(objId) {
	$jQuery("#" + objId).hide();
}
/**
 * 提示信息重新定位
 * */
function errorPlacementWithPositon(error, element){
	var objectId = element[0].id;	
	var postion_tip = getTipPosition(objectId,false);
	var _left = postion_tip[0];			
	var _top = postion_tip[1];
	error.insertBefore(element);
	error.addClass('message');
	error.css('position', 'absolute');
	error.css('left', _left);
	error.css('top', _top);	
}
// 日期，大于目标域
$jQuery.validator.addMethod("dateGreaterThen", function(value, element, param) {
	var startDate = $jQuery(param).val();
	if (startDate == "" || value == "")
		return true;
	return new Date(Date.parse(startDate.replace(/-/g,"\/"))) <= new Date(Date
			.parse(value.replace(/-/g,"\/")));
});

// 不等于
$jQuery.validator.addMethod("notEqualTo", function(value, element, param) {
	var target = $(param).unbind(".validate-equalTo").bind(
			"blur.validate-equalTo", function() {
				$(element).valid();
			});
	return value != target.val();
});