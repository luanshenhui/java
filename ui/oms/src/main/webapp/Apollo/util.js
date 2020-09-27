//var localPath = window.location;
var bossPath = "";
//var contextPath = localPath.pathname.split("/")[1];
//var basePath = localPath.protocol+"//"+localPath.host+"/"+contextPath+"/";
var basePath = "http://local.rkylin.cn/";
var defaultOptions = {"text":"请选择","value":"","description":"1","group":"1"};
function serializeObject(form) {
	var o = {};
	$.each(form.serializeArray(), function(index) {
		if (o[this['name']]) {
			o[this['name']] = o[this['name']] + "," + this['value'];
		} else {
			o[this['name']] = this['value'];
		}
	});
	return o;
}
function StartWaiting() {
	return true;
}
function CloseWaiting() {
	return true;
}

function formatComboboxItem(row) {
	var s = '<span style="font-weight:bold">' + row.text + '</span><br/>' + '<span style="color:#888">' + row.desc + '</span>';
	return s;
}

function getArgs(){
	var args = {};
	var match = null;
	var search = decodeURIComponent(location.search.substring(1));
	var reg = /(?:([^&]+)=([^&]+))/g;
	while((match = reg.exec(search))!==null){
		args[match[1]] = match[2];
	}
	return args;
}

//带默认值的下拉框
function jsonToArrayForSelected(JSONobj){
	var arr = new Array();
	//添加默认值
	if(defaultOptions!=null)
		arr.push(defaultOptions);
	for(var i in JSONobj){
		var m = {};
		for(var key in JSONobj[i]){
			m[key.toLowerCase()] = JSONobj[i][key];
		}
		arr.push(m);
	}	
	return arr;
}

function jsonToArray(JSONobj) {
	var arr = new Array();
	for(var i in JSONobj){
		var m = {};
		for(var key in JSONobj[i]){
			m[key] = JSONobj[i][key];
		}
		arr.push(m);
	}	
	return arr;
}

function JsonToString(o) {    
    var arr = []; 
    var fmt = function(s) { 
        if (typeof s == 'object' && s != null) return JsonToString(s); 
        return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s; 
    } 
    for (var i in o) 
         arr.push("'" + i + "':" + fmt(o[i])); 
    return '{' + arr.join(',') + '}'; 
} 
function OpenDownload(group, view, action, param) {
	var url_path = basePath + "MainServlet?group=" + group + "&view=" + view + "&action=" + action;
	for(var key in param){ 
		url_path += ("&" + key + "=" + param[key]);
	}
	window.open(url_path);
}
function GetData(group, view, action, param, async) {
			getDataAfterCheck(group, view, action, param, async);
}

function getDataAfterCheck(group, view, action, param, async){
	var url_path = basePath + "MainServlet?group=" + group + "&view=" + view + "&action=" + action;
	$.ajax({
		url : url_path,
		dataType: "json",
		contentType:"text/html; charset=utf-8",
		data : param,
		async : async,
		success: function(r) {
			var fun = "window." + action + "Success";
			if(typeof(eval(fun))=="function") {
				var input = JsonToString(r);
				eval(fun + "(" + input + ");\n");
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			var fun = "window." + action + "Error";
			if(typeof(fun)=="function") {
				eval(action + "Error" + "(" + XMLHttpRequest, + "," + textStatus + "," + errorThrown + ")");
			}
		}
	});
}

function PostData(action,param, async) {	
	var url_path = basePath + "MainServlet"
	$.ajax({
		url : url_path,						
		data : param,
		type: 'POST',
		dataType: "json",
		async : async,
		success: function(r) {
			var fun = "window." + action + "Success";
			if(typeof(eval(fun))=="function") {
				var input = JsonToString(r);
				eval(fun + "(" + input + ");\n");
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			var fun = "window." + action + "Error";
			if(typeof(fun)=="function") {
				eval(action + "Error" + "(" + XMLHttpRequest, + "," + textStatus + "," + errorThrown + ")");
			}
		}
	});
}

function isLoginRequest(group, view, action) {
	
	return true ;//暂时不判断
	if(group == 'user' && view == 'prsuser' && action == 'Login'){
		return true ;
	}else{
		return false ;
	}
}

function getCookie(name) {
	var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
	if (arr = document.cookie.match(reg))
		return unescape(arr[2]);
	else
		return null;
}

$.extend($.fn.validatebox.defaults.rules, {
	eqPwd : {
		validator : function(value, param) {
			return value == $(param[0]).val();
		},
		message : '密码不一致！'
	},
	numbers : {
		validator : function(value) {
			return /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/
					.test(value);
		},
		message : '只能输入数字.'
	},
	passwd : {
		validator : function(value) {
			return /[0-9]+/.test(value) && (/[a-z]+/.test(value) || /[A-Z]+/
					.test(value));
		},
		message : '密码中必须包含一个字母和一个数字'
	}
});
