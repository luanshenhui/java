jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        // CAUTION: Needed to parenthesize options.path and options.domain
        // in the following expressions, otherwise they evaluate to undefined
        // in the packed version for some reason...
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};
	
	/* * 
 *  jQuery Hotkeys Plugin 
 *  Copyright 2010
 * */
 (function(jQuery){
 	jQuery.hotkeys = {		
 	   version: "0.8",
 	   specialKeys: {
          8: "backspace", 9: "tab", 13: "return", 16: "shift", 17: "ctrl", 18: "alt", 19: "pause",
          20: "capslock", 27: "esc", 32: "space", 33: "pageup", 34: "pagedown", 35: "end", 36: "home",
          37: "left", 38: "up", 39: "right", 40: "down", 45: "insert", 46: "del", 
          96: "0", 97: "1", 98: "2", 99: "3", 100: "4", 101: "5", 102: "6", 103: "7",
          104: "8", 105: "9", 106: "*", 107: "+", 109: "-", 110: ".", 111 : "/", 
          112: "f1", 113: "f2", 114: "f3", 115: "f4", 116: "f5", 117: "f6", 118: "f7", 119: "f8", 
          120: "f9", 121: "f10", 122: "f11", 123: "f12", 144: "numlock", 145: "scroll", 191: "/", 224: "meta"
       },
       
       shiftNums: {
       	  "`": "~", "1": "!", "2": "@", "3": "#", "4": "$", "5": "%", "6": "^", "7": "&", 
       	  "8": "*", "9": "(", "0": ")", "-": "_", "=": "+", ";": ": ", "'": "\"", ",": "<", 
       	  ".": ">",  "/": "?",  "\\": "|"
       }
    };
    
    
    function keyHandler( handleObj ) {
	    if ( typeof handleObj.data !== "string" ) {		
	    	return;		
	    }

	    var origHandler = handleObj.handler,			
	    keys = handleObj.data.toLowerCase().split(" ");
	    handleObj.handler = function( event ) {
	        if ( this !== event.target && (/textarea|select/i.test( event.target.nodeName ) ||	event.target.type === "text") ) {		
	        	return;			
	        }
	        var special = event.type !== "keypress" && jQuery.hotkeys.specialKeys[ event.which ],			
	        character = String.fromCharCode( event.which ).toLowerCase(),			
	        key, modif = "", possible = {};
	        if ( event.altKey && special !== "alt" ) {			
	        	modif += "alt+";		
	        }
	        
	        if ( event.ctrlKey && special !== "ctrl" ) {			
	        	modif += "ctrl+";	
	        }
	        
	        if ( event.metaKey && !event.ctrlKey && special !== "meta" ) {			
	        	modif += "meta+";		
	        }
	        
	        if ( event.shiftKey && special !== "shift" ) {		
	        	modif += "shift+";		
	        }
	        
	        if ( special ) {		
	        	possible[ modif + special ] = true;		
	        }else {
	        	possible[ modif + character ] = true;			
	        	possible[ modif + jQuery.hotkeys.shiftNums[ character ] ] = true;
	        	if ( modif === "shift+" ) {				
	        		possible[ jQuery.hotkeys.shiftNums[ character ] ] = true;	

	        	}
	        }
	        for ( var i = 0, l = keys.length; i < l; i++ ) {
	        	if ( possible[ keys[i] ] ) {
	                 return origHandler.apply( this, arguments );
	            }		
	        }		
        };
    }
    jQuery.each([ "keydown", "keyup", "keypress" ], function() {
    	jQuery.event.special[ this ] = { add: keyHandler };
    });
  })( jQuery );
	        
	
	
	function textMouseover(txt,clazz){
		txt.className = clazz;
	}
	function textFocus(txt,clazz){
		txt.className = clazz;
	}
    function textBlur(txt,clazz){
		txt.className = clazz;
	}
	function textMouseOut(txt,clazz){
	    var t = document.activeElement.id;
        var p = txt.id;
		if(t!=p){
		txt.className = clazz;
		}
	}

	function actionSubmit(method,action){
		document.forms[0].method.value = method;
		document.forms[0].action= action;
		document.forms[0].submit();
	}

	
function oneTypeGo(){
	var page = $("#gotoPage").val();
	var totalPage = $("#totalPage").val();
    if(!checkNum(page)){   
        alert("请输入正确的页数！"); 
        $("#gotoPage").select();
        $("#gotoPage").focus();
        return false;   
    }   
    if(page > totalPage){   
        alert("超出了最大页数，请重新输入！");  
        $("#gotoPage").select();
        $("#gotoPage").focus();
    }else if(page < 1){   
        alert("页数不能小于1！");   
        $("#gotoPage").select();
        $("#gotoPage").focus();
    }else{   
        window.location=$("#pageUrl").get(0).value.replace("p=","p="+page);   
        
    }   
}

function otherTypeGo(){
    var page = $("#gotoPage").val();
	var totalPage = $("#gotoPage").val();
    if(!checkNum(page)){   
        alert("请输入正确的页数！"); 
        $("#gotoPage").select();
        $("#gotoPage").focus();
        return false;   
    }   
    if(page > totalPage){   
        alert("超出了最大页数，请重新输入！"); 
        $("#gotoPage").select();
        $("#gotoPage").focus();
    }else if(page < 1){   
        alert("页数不能小于1！");  
        $("#gotoPage").select();
        $("#gotoPage").focus();
    }else{   
        window.location=$("#pageUrl").get(0).value.replace("p=1","p="+page);    
    }   
}

/**
 * 检验是否为正整数
 */
function checkNum(str)     
{     
	var reg =  /^[0-9]*[1-9][0-9]*$/;
	return reg.test(str);   
}



  function isChecked(){
	var c = document.getElementsByTagName("input");
	var count = 0;
	for (var i = 0; i < c.length; i++) {
		if (c[i].getAttribute("type") == "checkbox") {
			if (c[i].checked) {
				count = count + 1;
			}
		}
	}
	
	
	return count;
  }

  
  
  function isCheckedName(name){
  	var str=""; 
	var tname = "[name='" + name + "'][checked]";
	$(tname).each(function(){ 
	   str+=$(this).val()+","; 
	});
	var ids = new Array();
    str = str.substring(0,str.length -1);
    if(str == "" || str.length == 0){
    	return 0;
    }
	ids = str.split(",");
	return ids.length;
  }


$(document).ready(function(){
	$("body").keydown(function(){
	   var current = document.activeElement.id;
	   if(event.keyCode == 13)
	   {    
		    if(current != 'but_save' && current != 'but_query' && current != 'buttonSubmit'){
                event.keyCode = 9;
			}
	   }
    }); 
});

function back(){
	window.history.go(-1);
}

function openWindow(url,windowWidth,windowHeight)
{
		var property= 'menubar=no,toolbar=no,location=no,directories=no,status=no,scrollbars=yes,titlebar=no,resizable=no';

     	var windowTop    = (window.screen.height - windowHeight)/2;
     	
     	var windowLeft   = (window.screen.width - windowWidth)/2;
     	
     	var locationInfo = ",width=" + windowWidth + ",height=" + windowHeight + ",top=" + windowTop + ",left=" + windowLeft;
     	
     	property += locationInfo;
     	
		return window.open(url, "", property);
}

function showDialog(page){
	return openModalDialog(page,window,['600px','820px',,,'help:0;scroll:0;resizable:0;status:0; unadorned:1;']);
}

function showDialog1(page){
	return openModalDialog(page,window,['800px','1024px',,,'help:0;scroll:0;resizable:0;status:0; unadorned:1;']);
}

function openModalDialog(sURL,vArguments,paraArray){
	var sFeatures=""; //alert(paraArray);
	if(paraArray[0]) sFeatures+="dialogHeight:"+paraArray[0]+"px;";
	if(paraArray[1]) sFeatures+="dialogWidth:"+paraArray[1]+"px;";
	if(paraArray[2]) sFeatures+="dialogLeft:"+paraArray[2]+"px;";
	if(paraArray[3]) sFeatures+="dialogTop:"+paraArray[3]+"px;";
	if(paraArray[4]) sFeatures+=paraArray[4];
	 return window.showModalDialog(sURL,vArguments,sFeatures);
  //"dialogHeight:400px; dialogWidth:600px; help:0; resizable:1; status:0; unadorned:1;"
}



 
  //截取名字
  function splitname(name,key){
	  var ttname;
	  if(name!=null && name!=''){
			ttname=name.split(key);
			
		}
		return ttname;
  }
