/*jquery.cookies*/
jQuery.cookie=function(name,value,options){if(typeof value!='undefined'){options=options||{};if(value===null){value='';options.expires=-1;}var expires='';if(options.expires&&(typeof options.expires=='number'||options.expires.toUTCString)){var date;if(typeof options.expires=='number'){date=new Date();date.setTime(date.getTime()+(options.expires*24*60*60*1000));}else{date=options.expires;}expires='; expires='+date.toUTCString();}var path=options.path?'; path='+(options.path):'';var domain=options.domain?'; domain='+(options.domain):'';var secure=options.secure?'; secure':'';document.cookie=[name,'=',encodeURIComponent(value),expires,path,domain,secure].join('');}else{var cookieValue=null;if(document.cookie&&document.cookie!=''){var cookies=document.cookie.split(';');for(var i=0;i<cookies.length;i++){var cookie=jQuery.trim(cookies[i]);if(cookie.substring(0,name.length+1)==(name+'=')){cookieValue=decodeURIComponent(cookie.substring(name.length+1));break;}}}return cookieValue;}};

/*jquery.hotkey
(function(jQuery){jQuery.hotkeys={version:"0.8",specialKeys:{8:"backspace",9:"tab",13:"return",16:"shift",17:"ctrl",18:"alt",19:"pause",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"insert",46:"del",96:"0",97:"1",98:"2",99:"3",100:"4",101:"5",102:"6",103:"7",104:"8",105:"9",106:"*",107:"+",109:"-",110:".",111:"/",112:"f1",113:"f2",114:"f3",115:"f4",116:"f5",117:"f6",118:"f7",119:"f8",120:"f9",121:"f10",122:"f11",123:"f12",144:"numlock",145:"scroll",191:"/",224:"meta"},shiftNums:{"`":"~","1":"!","2":"@","3":"#","4":"$","5":"%","6":"^","7":"&","8":"*","9":"(","0":")","-":"_","=":"+",";":": ","'":"\"",",":"<",".":">","/":"?","\\":"|"}};function keyHandler(handleObj){if(typeof handleObj.data!=="string"){return;}var origHandler=handleObj.handler,keys=handleObj.data.toLowerCase().split(" ");handleObj.handler=function(event){if(this!==event.target&&(/textarea|select/i.test(event.target.nodeName)||event.target.type==="text")){return;}var special=event.type!=="keypress"&&jQuery.hotkeys.specialKeys[event.which],character=String.fromCharCode(event.which).toLowerCase(),key,modif="",possible={};if(event.altKey&&special!=="alt"){modif+="alt+";}if(event.ctrlKey&&special!=="ctrl"){modif+="ctrl+";}if(event.metaKey&&!event.ctrlKey&&special!=="meta"){modif+="meta+";}if(event.shiftKey&&special!=="shift"){modif+="shift+";}if(special){possible[modif+special]=true;}else{possible[modif+character]=true;possible[modif+jQuery.hotkeys.shiftNums[character]]=true;if(modif==="shift+"){possible[jQuery.hotkeys.shiftNums[character]]=true;}}for(var i=0,l=keys.length;i<l;i++){if(possible[keys[i]]){return origHandler.apply(this,arguments);}}};}jQuery.each(["keydown","keyup","keypress"],function(){jQuery.event.special[this]={add:keyHandler};});})(jQuery);
*/
(function (jQuery){
    if ( typeof(jQuery.browser)=='undefined' ) {
        jQuery.browser = {};
    }
    $.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());
    $.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
    $.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
    $.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());

    this.version = '(beta)(0.0.3)';
	this.all = {};
    this.special_keys = {
        27: 'esc', 9: 'tab', 32:'space', 13: 'return', 8:'backspace', 145: 'scroll', 20: 'capslock',
        144: 'numlock', 19:'pause', 45:'insert', 36:'home', 46:'del',35:'end', 33: 'pageup',
        34:'pagedown', 37:'left', 38:'up', 39:'right',40:'down', 112:'f1',113:'f2', 114:'f3',
        115:'f4', 116:'f5', 117:'f6', 118:'f7', 119:'f8', 120:'f9', 121:'f10', 122:'f11', 123:'f12'};

    this.shift_nums = { "`":"~", "1":"!", "2":"@", "3":"#", "4":"$", "5":"%", "6":"^", "7":"&",
        "8":"*", "9":"(", "0":")", "-":"_", "=":"+", ";":":", "'":"\"", ",":"<",
        ".":">",  "/":"?",  "\\":"|" };

    this.add = function(combi, options, callback) {
        if (jQuery.isFunction(options)){
            callback = options;
            options = {};
        }
        var opt = {},
            defaults = {type: 'keydown', propagate: false, disableInInput: false, target: jQuery('html')[0], checkParent: true},
            that = this;
        opt = jQuery.extend( opt , defaults, options || {} );
        combi = combi.toLowerCase();

        // inspect if keystroke matches
        var inspector = function(event) {
            event = jQuery.event.fix(event); // jQuery event normalization.
            var element = event.target;
            // @ TextNode -> nodeType == 3
            element = (element.nodeType==3) ? element.parentNode : element;

            if(opt['disableInInput']) { // Disable shortcut keys in Input, Textarea fields
                var target = jQuery(element);
                if( target.is("input") || target.is("textarea")){
                    return;
                }
            }
            var code = event.which,
                type = event.type,
                character = String.fromCharCode(code).toLowerCase(),
                special = that.special_keys[code],
                shift = event.shiftKey,
                ctrl = event.ctrlKey,
                alt= event.altKey,
                propagate = true, // default behaivour
                mapPoint = null;

            // in opera + safari, the event.target is unpredictable.
            // for example: 'keydown' might be associated with HtmlBodyElement
            // or the element where you last clicked with your mouse.
            if (jQuery.browser.opera || jQuery.browser.safari || opt.checkParent){
                while (!that.all[element] && element.parentNode){
                    element = element.parentNode;
                }
            }

            var cbMap = that.all[element].events[type].callbackMap;
            if(!shift && !ctrl && !alt) { // No Modifiers
                mapPoint = cbMap[special] ||  cbMap[character]
			}
            // deals with combinaitons (alt|ctrl|shift+anything)
            else{
                var modif = '';
                if(alt) modif +='alt+';
                if(ctrl) modif+= 'ctrl+';
                if(shift) modif += 'shift+';
                // modifiers + special keys or modifiers + characters or modifiers + shift characters
                mapPoint = cbMap[modif+special] || cbMap[modif+character] || cbMap[modif+that.shift_nums[character]]
            }
            if (mapPoint){
                mapPoint.cb(event);
                if(!mapPoint.propagate) {
                    event.stopPropagation();
                    event.preventDefault();
                    return false;
                }
            }
		};
        // first hook for this element
        if (!this.all[opt.target]){
            this.all[opt.target] = {events:{}};
        }
        if (!this.all[opt.target].events[opt.type]){
            this.all[opt.target].events[opt.type] = {callbackMap: {}}
            jQuery.event.add(opt.target, opt.type, inspector);
        }
        this.all[opt.target].events[opt.type].callbackMap[combi] =  {cb: callback, propagate:opt.propagate};
        return jQuery;
	};
    this.remove = function(exp, opt) {
        opt = opt || {};
        target = opt.target || jQuery('html')[0];
        type = opt.type || 'keydown';
		exp = exp.toLowerCase();
        delete this.all[target].events[type].callbackMap[exp]
        return jQuery;
	};
    jQuery.hotkeys = this;
    return jQuery;
})(jQuery);