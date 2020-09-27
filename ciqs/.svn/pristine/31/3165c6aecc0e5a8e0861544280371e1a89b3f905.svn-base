/**
 * validate agent properties
 * 
 * @author shixin
 * @since 2011-11-23
 * @return valid
 */
function doForm(){
	//alert("doForm begin!");
	var idsHostValid = validateIdsHost();
	
	var idsPortValid = validateIdsPort();
	
	var agentNameValid = validateAgentName();
	
	var coAppTypeValid = validateCoAppType();
	
	var coAppVersionValid = validateCoAppVersion();
	
	var coAppRootUrlValid = validateCoAppRootUrl();
	
	var coAppNotifyUrlValid = validateCoAppNotifyUrl();
	
	//alert("validate result=" + (idsHostValid && idsPortValid && agentNameValid && coAppTypeValid && coAppVersionValid && coAppRootUrlValid && coAppNotifyUrlValid));
	
	return idsHostValid && idsPortValid && agentNameValid && coAppTypeValid && coAppVersionValid && coAppRootUrlValid && coAppNotifyUrlValid;
}

function validateIdsHost(){
	var idsHostEle = document.getElementById("idsHost");
	if(idsHostEle == null){
		alert("idsHostEle is " + idsHostEle);
		return false;
	}
	var idsHostSpanEle = document.getElementById("idsHost-Span");
	if(idsHostSpanEle == null){
		alert("idsHostSpanEle is " + idsHostSpanEle);
		return false;
	}
	var idsHostValue = idsHostEle.value;
	idsHostValue = trim(idsHostValue);
	
	//为空
	if(false == isNotNull(idsHostValue)){
		idsHostSpanEle.innerHTML = "<font color='red'>IP地址不允许为空!" + "</font>";
		return false;
	}
	
	//单个IP
	if(false == hasWhiteSpace(idsHostValue) && false == isValidIpSegment(idsHostValue)){
		idsHostSpanEle.innerHTML = "<font color='red'>IP地址格式不合法!" + "</font>";
		return false;
	}
	
	//空格分隔的多个IP
	if(hasWhiteSpace(idsHostValue)){
		var ipArray = idsHostValue.split(/\s+/);
		for (var i=0;i<=ipArray.length;i++){
			var ip = ipArray[i];
			if(false == isValidIpSegment(ip)){
				idsHostSpanEle.innerHTML = "<font color='red'>IP地址格式不合法!" + "</font>";
				return false;
			}
		} 
	}
	
	idsHostSpanEle.innerHTML = "";
	return true;
}

function validateIdsPort(){
	// alert("validateIdsPort begin!");
	var idsPortEle = document.getElementById("idsPort");
	if(idsPortEle == null){
		alert("idsPortEle is " + idsPortEle);
		return false;
	}
	var idsPortSpanEle = document.getElementById("idsPort-Span");
	if(idsPortSpanEle == null){
		alert("idsPortSpanEle is " + idsPortSpanEle);
		return false;
	}
	
	// 必须是数字
	var idsPortValue = idsPortEle.value;
	if(false == isNumber(idsPortValue)){
		idsPortSpanEle.innerHTML = "<font color='red'>" + idsPortValue + "不是数字!" + "</font>";
		return false;
	}
	idsPortSpanEle.innerHTML = "";
	return true;
}

function validateAgentName(){
	//alert("validateAgentName begin!");
	var agentNameEle = document.getElementById("agentName");
	if(agentNameEle == null){
		alert("agentNameEle is " + agentNameEle);
		return false;
	}
	var agentNameValue = agentNameEle.value;
	//alert("agentNameValue=" + agentNameValue);
	
	var agentNameSpanEle = document.getElementById("agentName-Span");
	if(agentNameSpanEle == null){
		alert("agentNameSpanEle is " + agentNameSpanEle);
		return false;
	}
	
	// 1. 不允许为空
	if(false == isNotNull(agentNameValue)){
		agentNameSpanEle.innerHTML = "<font color='red'>不允许为空!" + "</font>";
		return false;
	}
	
	// 2. 检测长度
	if(getStringLength(agentNameValue) < 2 || getStringLength(agentNameValue) > 80){
		agentNameSpanEle.innerHTML = "<font color='red'>长度必须为2~80个字符!" + "</font>";
		return false;
	}
	
	// 3. 检测非法字符
	if(hasIllegalCharacters(agentNameValue)){
		agentNameSpanEle.innerHTML = "<font color='red'>不允许使用空格等特殊字符!" + "</font>";
		return false;
	}
	
	// 4. 不允许为中文
	if(hasChineseCharacters(agentNameValue)){
		agentNameSpanEle.innerHTML = "<font color='red'>不允许使用中文!" + "</font>";
		return false;
	}
	agentNameSpanEle.innerHTML = "";
	return true;
}

function validateCoAppType(){
	//alert("validateCoAppType begin");
	var coAppTypeEle = document.getElementById("coAppType");
	if(coAppTypeEle == null){
		alert("coAppTypeEle is " + coAppTypeEle);
		return false;
	}
	var coAppTypeValue = coAppTypeEle.value;
	//alert("agentNameValue=" + agentNameValue);
	
	var coAppTypeSpanEle = document.getElementById("coAppType-Span");
	if(coAppTypeSpanEle == null){
		alert("coAppTypeSpanEle is " + coAppTypeSpanEle);
		return false;
	}
	
	// 1. 允许为空
	//alert("coAppTypeValue=" +coAppTypeValue);
	if(false == isNotNull(coAppTypeValue)){
		return true;
	}
	// 2. 检查非法字符
	if(hasIllegalCharacters(coAppTypeValue)){
		coAppTypeSpanEle.innerHTML = "<font color='red'>不允许使用空格等特殊字符!" + "</font>";
		return false;
	}
	coAppTypeSpanEle.innerHTML = "";
	return true;
}

function validateCoAppVersion(){
	var coAppVersionEle = document.getElementById("coAppVersion");
	if(coAppVersionEle == null){
		alert("coAppVersionEle is " + coAppVersionEle);
		return false;
	}
	var coAppVersionValue = coAppVersionEle.value;
	//alert("agentNameValue=" + agentNameValue);
	
	var coAppVersionSpanEle = document.getElementById("coAppVersion-Span");
	if(coAppVersionSpanEle == null){
		alert("coAppVersionSpanEle is " + coAppVersionSpanEle);
		return false;
	}
	
	// 1. 允许为空
	if(false == isNotNull(coAppVersionValue)){
		return true;
	}
	// 2. 检查非法字符
	if(hasIllegalCharacters(coAppVersionValue)){
		coAppVersionSpanEle.innerHTML = "<font color='red'>不允许使用空格等特殊字符!" + "</font>";
		return false;
	}
	coAppVersionSpanEle.innerHTML = "";
	return true;
}

function validateCoAppRootUrl(){
	var coAppRootUrlEle = document.getElementById("coAppRootUrl");
	if(coAppRootUrlEle == null){
		alert("coAppRootUrlEle is " + coAppRootUrlEle);
		return false;
	}
	var coAppRootUrlValue = coAppRootUrlEle.value;
	//alert("agentNameValue=" + agentNameValue);
	
	var coAppRootUrlSpanEle = document.getElementById("coAppRootUrl-Span");
	if(coAppRootUrlSpanEle == null){
		alert("coAppRootUrlSpanEle is " + coAppRootUrlSpanEle);
		return false;
	}
	// 1. 允许为空
	//alert("coAppRootUrlValue=" +coAppRootUrlValue);
	if(false == isNotNull(coAppRootUrlValue)){
		return true;
	}
	// 2、检查URL是否合法
	if(false == isValidUrl(coAppRootUrlValue)){
		coAppRootUrlSpanEle.innerHTML = "<font color='red'>URL格式不合法!" + "</font>";
		return false;
	}
	coAppRootUrlSpanEle.innerHTML = "";
	return true;
}

function validateCoAppNotifyUrl(){
	var coAppNotifyUrlEle = document.getElementById("coAppNotifyUrl");
	if(coAppNotifyUrlEle == null){
		alert("coAppNotifyUrlEle is " + coAppNotifyUrlEle);
		return false;
	}
	var coAppNotifyUrlValue = coAppNotifyUrlEle.value;
	//alert("agentNameValue=" + agentNameValue);
	
	var coAppNotifyUrlSpanEle = document.getElementById("coAppNotifyUrl-Span");
	if(coAppNotifyUrlSpanEle == null){
		alert("coAppNotifyUrlSpanEle is " + coAppNotifyUrlSpanEle);
		return false;
	}
	// 1. 允许为空
	if(false == isNotNull(coAppNotifyUrlValue)){
		return true;
	}
	// 2、检查URL是否合法
	if(false == isValidUrl(coAppNotifyUrlValue)){
		coAppNotifyUrlSpanEle.innerHTML = "<font color='red'>URL格式不合法!" + "</font>";
		return false;
	}
	coAppNotifyUrlSpanEle.innerHTML = "";
	return true;
}

function isValidUrl(_url){
	//允许为空
	if(false == isNotNull(_url)){
		return true;
	}
	var urlPattern = new RegExp("^(http(s?)://)((((\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5]))|localhost|(([a-zA-Z-]{1,62}(\\d*))(\\.[a-zA-Z0-9-]{1,62})+))(:\\d{1,5})?(/\\w+)*(/?|(/\\w+\\.?\\w+))?)$");
	if (_url.match(urlPattern) != null) {
		return true;
	}
	return false;
}

function hasWhiteSpace(_str){
//	alert("1=" + /\s+/g.test("127.0.0.1"));
//	alert("2=" + /\s+/g.test("127 .0.0.1"));
//	alert("3=" + /\s+/g.test(" 127.0.0.1"));
//	alert("4=" + /\s+/g.test("127.0.0.1 "));
//	alert("5=" + /\s+/g.test("127.0.0.1  "));
	if(false == isNotNull(_str)){
		return false;
	}
	if (/\s+/g.test(_str)) {
		return true;
	}
	return false;
}

function isValidIpSegment(_str){
	if(_str == "localhost"){
		return true;
	}
	var ipPattern=/^(\d{1,3})[.](\d{1,3})[.](\d{1,3})[.](\d{1,3})$/;
	var IPArray = _str.match(ipPattern);
	if (IPArray != null) {
	   for (var i = 1; i <= 4; i++) {
		  if (IPArray[i] > 255) {
			 return false;
		  }
	   }
	   return true;
	}
	return false;
}

function hasChineseCharacters(_str){
	if(false == isNotNull(_str)){
		return false;
	}
	_str = _str.toString();
	if (_str.match(/^\s*\S*[\u0391-\uFFE5]+\s*\S*$/) != null) {
		return true;
	}
	return false;
}

function hasIllegalCharacters(_str){
	_str = _str.toString();
	var specialChars = new RegExp("[ `~!@#$^&*=|{}':;',_\\[\\]<>/?~！@#￥……&*（）—|{}【】‘；：”“'。，、？]") 
	if (_str.match(specialChars) != null) {
		return true;
	}
	return false;
}

function isNumber(_sCode) {
	_sCode = _sCode.toString();
	if(/^[0-9]{1,20}$/g.test(_sCode)) {
		return true;
	}else {
		return false;
	}
}

function isNotNull(_sCode){
	_sCode = trim(_sCode);
	var nLen = getStringLength(_sCode);
	if(nLen==0){
		// this.sErrorInfo += "错误：输入了空白字符！";
		return false;
	}
	return true;
}

function trim(s){
	return s.replace( /^\s*/, "" ).replace( /\s*$/, "" );
}

function getStringLength(str){
	var totallength=0;
	for (var i=0; i < str.length;i++){
		var intCode=str.charCodeAt(i);
		if (intCode>=0&&intCode<=128) {
			totallength=totallength+1;	// 非中文单个字符长度加 1
		}else {
			totallength=totallength+2;	// 中文字符长度则加 2
		}
	} // end for
	return totallength;	
}