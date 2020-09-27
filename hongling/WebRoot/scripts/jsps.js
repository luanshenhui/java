var IS_NET = false;
var SERVICE_ROOT = "/hongling";
var PAGE_SIZE = 15;
var DICT_CATEGORY_MEMBER_GROUP = 5;
var DICT_CATEGORY_MEMBER_STATUS = 6;
var DICT_CATEGORY_INFORMATION_CATEGORY = 7;
var DICT_CATEGORY_FABRIC_CATEGORY = 8;
var DICT_CATEGORY_GENDER = 10;
var DICT_CATEGORY_BOOL = 12;
var DICT_CATEGORY_WEIGHTUNIT = 29;
var DICT_CATEGORY_HEIGHTUNIT = 30;
var DICT_CATEGORY_PAYTYPE = 31;
var DICT_CATEGORY_BACKEND_MENU =33;
var DICT_CATEGORY_ORDEN_AUTO = 36;
var DICT_CATEGORY_FABRIC_SUPPLY_CATEGORY = 34;
var DICT_CATEGORY_CLIENT_PIECE_VALID = 37;
var DICT_CATEGORY_APPLY_DELIVERY_TYPE = 38;
var DICT_CATEGORY_APPLY_DELIVERY_DAYS = 39;
var DICT_CATEGORY_MONEYSIGN = 40;
var DICT_CATEGORY_STYLE = 41;
var DICT_CATEGORY_HOMEPAGE = 44;
var DICT_CATEGORY_IOFLAG = 45;
var DICT_CATEGORY_BODYTYPE = 32;
var DICT_BODY_TYPE=10284;//着装风格默认值
var DICT_CLONTHING_SIZE=10368;//成衣尺寸默认值
var DICT_CATEGORY_SHIPPING_PAY_TYPE=48; // 快递付款方式
var DICT_CATEGORY_BUSINESS_UNIT=49; //经营单位
var DICT_CUSTOMER_SPECIFIED= 10008; // 客户指定

var DICT_CATEGORY_ORDEN_STATUS = 9;

var VERSION_CN = 1;
var VERSION_EN = 2;
var VERSION_DE = 3;
var VERSION_FR = 4;
var VERSION_JA = 5;
var DICT_YES = 10050;
var DICT_NO = 10051;
var DICT_VIEW_FRONT = 10004;
var DICT_VIEW_BACK = 10005;
var DICT_DESIGN_STYLE='24,2021,3016,4016,6007';//设计款式

var DICT_SIZE_CATEGORY_NAKED= 10052;//净体
var DICT_SIZE_CATEGORY_CLOTH= 10053;//成衣
var DICT_SIZE_CATEGORY_STANDARD= 10054;//标准号加减

var DICT_GROUP_STATUS_COMMON_USER = 10250;
var DICT_GROUP_STATUS_MANAGER_USER = 10251;
var DICT_BACKEND_MENU_ORDEN_MANAGER = 10300;
var DICT_BACKEND_MENU_FABRIC_MANAGER = 10301;
var DICT_BACKEND_MENU_INFORMATION_MANAGER = 10302;
var DICT_BACKEND_MENU_MEMBER_MANAGER = 10303;
var DICT_BACKEND_MENU_AUTHORITY_MANAGER = 10304;
var DICT_BACKEND_MENU_CASH_MANAGER = 10305;
var DICT_BACKEND_MENU_DELIVERY_MANAGER = 10309;
var DICT_BACKEND_MENU_MY_MESSAGE = 10308;
// 快递公司
var DICT_BACKEND_MENU_EXPRESSCOM_MANAGE = 10310;
// 查看订单
var DICT_BACKEND_MENU_VIEWORDEN_MANAGE = 10312;
var DICT_BACKEND_MENU_REALMNAME_MANAGE = 10313;
var DICT_BACKEND_MENU_RECEIVING_MANAGE = 10314;

var DICT_MEMBER_PAYTYPE_ONLINE = 10270;

var DICT_FABRIC_SUPPLY_CATEGORY_REDCOLLAR = 10320;
var DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_LARGE = 10321;
var DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_PIECE = 10322;
var DICT_APPLY_DELIVERY_TYPE_AUTO = 10336;

var DICT_CLOTHING_SUIT2PCS =1;
var DICT_CLOTHING_SUIT3PCS =2;
var DICT_CLOTHING_ShangYi =3;
var DICT_CLOTHING_PANT=2000;
var DICT_CLOTHING_ChenYi=3000;
var DICT_CLOTHING_MaJia=4000;
var DICT_CLOTHING_PeiJian=5000;
var DICT_CLOTHING_DaYi=6000;
var DICT_CLOTHING_SUIT2PCS_AC=6;

var DICT_FABRIC_SUPPLY_CATEGORY_CLIENT ='MTDsuit,MTDshirt';
var XKBODY = "10284,10282,10286,10287,10285";//西裤着装风格
var PRICE ="1375,2619,3714,4640,6603";//上衣、西裤、衬衣、马夹、大衣的价格

var DICT_CM=10266;//身高--厘米
var DICT_FABRIC ="8001,8030,8050";//面料选择id
var DICT_QT ="313,331,340,371,345,363,386,1225,2170,2192,2180,2186,2199,3215,3235,3233,4088,4093,4112,4102,4107,4123,6291,6309,6318,6322,6349,6438,6364";//线、扣、袖里、领地呢、里料id

var LAPEL = 1119;//驳头型
var FRONTBUTTON = 35;//前门扣
var GROUPID_CAIWU = 10257;//财务账户id

var DELIVERY_STATE_APPLY = 20130; // 发货状态：已申请
var DELIVERY_STATE_LADE = 20131; // 发货状态：已提货
var DELIVERY_STATE_CANCLE = 20132; // 发货状态：已撤销
var DICT_ZDGY ="0714,0853,0724,0672,0638,064B,064D,350D,3454,57N7,5612,5622,421A,42A3,4240,6714,6724,6672,6638,664D";//上衣、西裤、衬衣、马夹、大衣   扣、里料、线

//JSON.JS
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('3(!m.l){l={}}(5(){5 f(n){7 n<10?\'0\'+n:n}3(6 1m.x.p!==\'5\'){1m.x.p=5(a){7 m.1w()+\'-\'+f(m.1v()+1)+\'-\'+f(m.1q())+\'T\'+f(m.1G())+\':\'+f(m.1F())+\':\'+f(m.1R())+\'Z\'};L.x.p=1B.x.p=1A.x.p=5(a){7 m.1z()}}w e=/[\\1y\\1a\\12-\\11\\Y\\1n\\1l\\1e-\\1b\\19-\\17\\13-\\1i\\1c\\15-\\X]/g,J=/[\\\\\\"\\1C-\\1E\\1o-\\1s\\1a\\12-\\11\\Y\\1n\\1l\\1e-\\1b\\19-\\17\\13-\\1i\\1c\\15-\\X]/g,8,D,1d={\'\\b\':\'\\\\b\',\'\\t\':\'\\\\t\',\'\\n\':\'\\\\n\',\'\\f\':\'\\\\f\',\'\\r\':\'\\\\r\',\'"\':\'\\\\"\',\'\\\\\':\'\\\\\\\\\'},o;5 K(b){J.W=0;7 J.N(b)?\'"\'+b.z(J,5(a){w c=1d[a];7 6 c===\'I\'?c:\'\\\\u\'+(\'14\'+a.V(0).O(16)).18(-4)})+\'"\':\'"\'+b+\'"\'}5 E(a,b){w i,k,v,h,B=8,9,2=b[a];3(2&&6 2===\'q\'&&6 2.p===\'5\'){2=2.p(a)}3(6 o===\'5\'){2=o.H(b,a,2)}1J(6 2){y\'I\':7 K(2);y\'P\':7 1p(2)?L(2):\'A\';y\'1r\':y\'A\':7 L(2);y\'q\':3(!2){7\'A\'}8+=D;9=[];3(Q.x.O.1t(2)===\'[q 1u]\'){h=2.h;C(i=0;i<h;i+=1){9[i]=E(i,2)||\'A\'}v=9.h===0?\'[]\':8?\'[\\n\'+8+9.G(\',\\n\'+8)+\'\\n\'+B+\']\':\'[\'+9.G(\',\')+\']\';8=B;7 v}3(o&&6 o===\'q\'){h=o.h;C(i=0;i<h;i+=1){k=o[i];3(6 k===\'I\'){v=E(k,2);3(v){9.1f(K(k)+(8?\': \':\':\')+v)}}}}R{C(k 1g 2){3(Q.1h.H(2,k)){v=E(k,2);3(v){9.1f(K(k)+(8?\': \':\':\')+v)}}}}v=9.h===0?\'{}\':8?\'{\\n\'+8+9.G(\',\\n\'+8)+\'\\n\'+B+\'}\':\'{\'+9.G(\',\')+\'}\';8=B;7 v}}3(6 l.S!==\'5\'){l.S=5(a,b,c){w i;8=\'\';D=\'\';3(6 c===\'P\'){C(i=0;i<c;i+=1){D+=\' \'}}R 3(6 c===\'I\'){D=c}o=b;3(b&&6 b!==\'5\'&&(6 b!==\'q\'||6 b.h!==\'P\')){1j 1k 1D(\'l.S\');}7 E(\'\',{\'\':a})}}3(6 l.U!==\'5\'){l.U=5(c,d){w j;5 M(a,b){w k,v,2=a[b];3(2&&6 2===\'q\'){C(k 1g 2){3(Q.1h.H(2,k)){v=M(2,k);3(v!==1H){2[k]=v}R{1I 2[k]}}}}7 d.H(a,b,2)}e.W=0;3(e.N(c)){c=c.z(e,5(a){7\'\\\\u\'+(\'14\'+a.V(0).O(16)).18(-4)})}3(/^[\\],:{}\\s]*$/.N(c.z(/\\\\(?:["\\\\\\/1K]|u[0-1L-1M-F]{4})/g,\'@\').z(/"[^"\\\\\\n\\r]*"|1N|1O|A|-?\\d+(?:\\.\\d*)?(?:[1P][+\\-]?\\d+)?/g,\']\').z(/(?:^|:|,)(?:\\s*\\[)+/g,\'\'))){j=1Q(\'(\'+c+\')\');7 6 d===\'5\'?M({\'\':j},\'\'):j}1j 1k 1x(\'l.U\');}}})();',62,116,'||value|if||function|typeof|return|gap|partial||||||||length||||JSON|this||rep|toJSON|object||||||var|prototype|case|replace|null|mind|for|indent|str||join|call|string|escapable|quote|String|walk|test|toString|number|Object|else|stringify||parse|charCodeAt|lastIndex|uffff|u070f|||u0604|u0600|u2060|0000|ufff0||u202f|slice|u2028|u00ad|u200f|ufeff|meta|u200c|push|in|hasOwnProperty|u206f|throw|new|u17b5|Date|u17b4|x7f|isFinite|getUTCDate|boolean|x9f|apply|Array|getUTCMonth|getUTCFullYear|SyntaxError|u0000|valueOf|Boolean|Number|x00|Error|x1f|getUTCMinutes|getUTCHours|undefined|delete|switch|bfnrt|9a|fA|true|false|eE|eval|getUTCSeconds'.split('|'),0,{}));

//bgiframe.js
/*! Copyright (c) 2010 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Version 2.1.2
 */

;(function($){

$.fn.bgiframe = ($.browser.msie && /msie 6\.0/i.test(navigator.userAgent) ? function(s) {
    s = $.extend({
        top     : 'auto', // auto == .currentStyle.borderTopWidth
        left    : 'auto', // auto == .currentStyle.borderLeftWidth
        width   : 'auto', // auto == offsetWidth
        height  : 'auto', // auto == offsetHeight
        opacity : true,
        src     : 'javascript:false;'
    }, s);
    var html = '<iframe class="bgiframe"frameborder="0"tabindex="-1"src="'+s.src+'"'+
                   'style="display:block;position:absolute;z-index:-1;'+
                       (s.opacity !== false?'filter:Alpha(Opacity=\'0\');':'')+
                       'top:'+(s.top=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderTopWidth)||0)*-1)+\'px\')':prop(s.top))+';'+
                       'left:'+(s.left=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderLeftWidth)||0)*-1)+\'px\')':prop(s.left))+';'+
                       'width:'+(s.width=='auto'?'expression(this.parentNode.offsetWidth+\'px\')':prop(s.width))+';'+
                       'height:'+(s.height=='auto'?'expression(this.parentNode.offsetHeight+\'px\')':prop(s.height))+';'+
                '"/>';
    return this.each(function() {
        if ( $(this).children('iframe.bgiframe').length === 0 )
            this.insertBefore( document.createElement(html), this.firstChild );
    });
} : function() { return this; });

// old alias
$.fn.bgIframe = $.fn.bgiframe;

function prop(n) {
    return n && n.constructor === Number ? n + 'px' : n;
}

})(jQuery);

//maccordion.js
/*
 * jQuery UI Multilevel Accordion v.1
 * 
 * Copyright (c) 2011 Pieter Pareit
 *
 * http://www.scriptbreaker.com
 *
 */

//plugin definition
(function($){
    $.fn.extend({

    //pass the options variable to the function
    accordion: function(options) {
        
		var defaults = {
			accordion: 'true',
			speed: 300,
			closedSign: '+',
			openedSign: '-'
		};

		// Extend our default options with those provided.
		var opts = $.extend(defaults, options);
		//Assign current element to variable, in this case is UL element
 		var $this = $(this);
 		
 		//add a mark [+] to a multilevel menu
 		$this.find("li").each(function() {
 			if($(this).find("ul").size() != 0){
 				//add the multilevel sign next to the link
 				$(this).find("a:first").append("<span>"+ opts.closedSign +"</span>");
 				
 				//avoid jumping to the top of the page when the href is an #
 				if($(this).find("a:first").attr('href') == "#"){
 		  			$(this).find("a:first").click(function(){return false;});
 		  		}
 			}
 		});

 		//open active level
 		$this.find("li.active").each(function() {
 			$(this).parents("ul").slideDown(opts.speed);
 			$(this).parents("ul").parent("li").find("span:first").html(opts.openedSign);
 		});

  		$this.find("li a").click(function() {
  			if($(this).parent().find("ul").size() != 0){
  				if(opts.accordion){
  					//Do nothing when the list is open
  					if(!$(this).parent().find("ul").is(':visible')){
  						parents = $(this).parent().parents("ul");
  						visible = $this.find("ul:visible");
  						visible.each(function(visibleIndex){
  							var close = true;
  							parents.each(function(parentIndex){
  								if(parents[parentIndex] == visible[visibleIndex]){
  									close = false;
  									return false;
  								}
  							});
  							if(close){
  								if($(this).parent().find("ul") != visible[visibleIndex]){
  									$(visible[visibleIndex]).slideUp(opts.speed, function(){
  										$(this).parent("li").find("span:first").html(opts.closedSign);
  									});
  									
  								}
  							}
  						});
  					}
  				}
  				if($(this).parent().find("ul:first").is(":visible")){
  					$(this).parent().find("ul:first").slideUp(opts.speed, function(){
  						$(this).parent("li").find("span:first").delay(opts.speed).html(opts.closedSign);
  					});
  				}else{
  					$(this).parent().find("ul:first").slideDown(opts.speed, function(){
  						$(this).parent("li").find("span:first").delay(opts.speed).html(opts.openedSign);
  					});
  				}
  			}
  		});
    }
});
})(jQuery);

//cookie.js
/**
 * jQuery Cookie plugin
 *
 * Copyright (c) 2010 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */
jQuery.cookie = function (key, value, options) {

    // key and at least value given, set cookie...
    if (arguments.length > 1 && String(value) !== "[object Object]") {
        options = jQuery.extend({}, options);

        if (value === null || value === undefined) {
            options.expires = -1;
        }

        if (typeof options.expires === 'number') {
            var days = options.expires, t = options.expires = new Date();
            t.setDate(t.getDate() + days);
        }

        value = String(value);

        return (document.cookie = [
            encodeURIComponent(key), '=',
            options.raw ? value : encodeURIComponent(value),
            options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
            options.path ? '; path=' + options.path : '',
            options.domain ? '; domain=' + options.domain : '',
            options.secure ? '; secure' : ''
        ].join(''));
    }

    // key and possibly options given, get cookie...
    options = value || {};
    var result, decode = options.raw ? function (s) { return s; } : decodeURIComponent;
    return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
};

//autocomplete.js
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}(';(4($){$.1f.1I({1g:4(1J,3){6 1K=Y 1J=="1L";3=$.1I({},$.N.2d,{Z:1K?1J:Q,7:1K?Q:1J,1M:1K?$.N.2d.1M:10,I:3&&!3.1N?10:3Q},3);3.1O=3.1O||4(e){a e};3.1P=3.1P||3.2e;a m.J(4(){2f $.N(m,3)})},u:4(1Q){a m.11("u",1Q)},1n:4(1Q){a m.12("1n",[1Q])},2g:4(){a m.12("2g")},2h:4(3){a m.12("2h",[3])},2i:4(){a m.12("2i")}});$.N=4(g,3){6 C={2O:38,2P:40,2Q:46,2R:9,2S:13,2T:27,2U:3R,2V:33,2W:34,2X:8};6 $g=$(g).3S("1g","3T").R(3.2Y);6 1h;6 14="";6 1o=$.N.2Z(3);6 1i=0;6 1R;6 1j={1S:r};6 h=$.N.30(3,g,2j,1j);6 1T;$.2k.31&&$(g.32).11("3U.1g",4(){5(1T){1T=r;a r}});$g.11(($.2k.31?"3V":"3W")+".1g",4(w){1i=1;1R=w.35;3X(w.35){S C.2O:w.1p();5(h.O()){h.36()}j{15(0,B)}T;S C.2P:w.1p();5(h.O()){h.37()}j{15(0,B)}T;S C.2V:w.1p();5(h.O()){h.39()}j{15(0,B)}T;S C.2W:w.1p();5(h.O()){h.3a()}j{15(0,B)}T;S 3.1k&&$.1q(3.U)==","&&C.2U:S C.2R:S C.2S:5(2j()){w.1p();1T=B;a r}T;S C.2T:h.16();T;3Y:2l(1h);1h=2m(15,3.1M);T}}).3b(4(){1i++}).3Z(4(){1i=0;5(!1j.1S){3c()}}).3d(4(){5(1i++>1&&!h.O()){15(0,B)}}).11("1n",4(){6 1f=(1U.f>1)?1U[1]:Q;4 2n(q,7){6 u;5(7&&7.f){1l(6 i=0;i<7.f;i++){5(7[i].u.K()==q.K()){u=7[i];T}}}5(Y 1f=="4")1f(u);j $g.12("u",u&&[u.7,u.e])}$.J(17($g.L()),4(i,e){2o(e,2n,2n)})}).11("2g",4(){1o.1r()}).11("2h",4(){$.1I(3,1U[1]);5("7"3e 1U[1])1o.1s()}).11("2i",4(){h.1V();$g.1V();$(g.32).1V(".1g")});4 2j(){6 D=h.D();5(!D)a r;6 v=D.u;14=v;5(3.1k){6 y=17($g.L());5(y.f>1){6 3f=3.U.f;6 1t=$(g).1m().E;6 2p,1W=0;$.J(y,4(i,1u){1W+=1u.f;5(1t<=1W){2p=i;a r}1W+=3f});y[2p]=v;v=y.3g(3.U)}v+=3.U}$g.L(v);1v();$g.12("u",[D.7,D.e]);a B}4 15(41,3h){5(1R==C.2Q){h.16();a}6 P=$g.L();5(!3h&&P==14)a;14=P;P=1w(P);5(P.f>=3.2q){$g.R(3.2r);5(!3.1X)P=P.K();2o(P,3i,1v)}j{1Y();h.16()}};4 17(e){5(!e)a[""];5(!3.1k)a[$.1q(e)];a $.42(e.2s(3.U),4(1u){a $.1q(e).f?$.1q(1u):Q})}4 1w(e){5(!3.1k)a e;6 y=17(e);5(y.f==1)a y[0];6 1t=$(g).1m().E;5(1t==e.f){y=17(e)}j{y=17(e.2t(e.3j(1t),""))}a y[y.f-1]}4 1Z(q,2u){5(3.1Z&&(1w($g.L()).K()==q.K())&&1R!=C.2X){$g.L($g.L()+2u.3j(1w(14).f));$(g).1m(14.f,14.f+2u.f)}};4 3c(){2l(1h);1h=2m(1v,43)};4 1v(){6 44=h.O();h.16();2l(1h);1Y();5(3.3k){$g.1n(4(u){5(!u){5(3.1k){6 y=17($g.L()).1x(0,-1);$g.L(y.3g(3.U)+(y.f?3.U:""))}j{$g.L("");$g.12("u",Q)}}})}};4 3i(q,7){5(7&&7.f&&1i){1Y();h.3l(7,q);1Z(q,7[0].e);h.2v()}j{1v()}};4 2o(z,20,3m){5(!3.1X)z=z.K();6 7=1o.3n(z);5(7&&7.f){20(z,7)}j 5((Y 3.Z=="1L")&&(3.Z.f>0)){6 1y={45:+2f 47()};$.J(3.1y,4(3o,21){1y[3o]=Y 21=="4"?21():21});$.48({49:"4a",4b:"1g"+g.4c,3p:3.3p,Z:3.Z,7:$.1I({q:1w(z),4d:3.I},1y),20:4(7){6 18=3.22&&3.22(7)||22(7);1o.1z(z,18);20(z,18)}})}j{h.3q();3m(z)}};4 22(7){6 18=[];6 2w=7.2s("\\n");1l(6 i=0;i<2w.f;i++){6 A=$.1q(2w[i]);5(A){A=A.2s("|");18[18.f]={7:A,e:A[0],u:3.23&&3.23(A,A[0])||A[0]}}}a 18};4 1Y(){$g.1A(3.2r)}};$.N.2d={2Y:"4e",3r:"4f",2r:"4g",2q:1,1M:4h,1X:r,1B:B,24:r,1C:10,I:4i,3k:r,1y:{},2x:B,2e:4(A){a A[0]},1P:Q,1Z:r,F:0,1k:r,U:", ",1O:4(e,z){a e.2t(2f 4j("(?![^&;]+;)(?!<[^<>]*)("+z.2t(/([\\^\\$\\(\\)\\[\\]\\{\\}\\*\\.\\+\\?\\|\\\\])/3s,"\\\\$1")+")(?![^<>]*>)(?![^&;]+;)","3s"),"<3t>$1</3t>")},1N:B,26:4k};$.N.2Z=4(3){6 7={};6 f=0;4 1B(s,2y){5(!3.1X)s=s+"".K();6 i=s.3u(2y);5(3.24=="1u"){i=s.K().1n("\\\\b"+2y.K())}5(i==-1)a r;a i==0||3.24};4 1z(q,e){5(f>3.1C){1r()}5(!7[q]){f++}7[q]=e}4 1s(){5(!3.7)a r;6 19={},3v=0;5(!3.Z)3.1C=1;19[""]=[];1l(6 i=0,3w=3.7.f;i<3w;i++){6 V=3.7[i];V=(Y V=="1L")?[V]:V;6 e=3.1P(V,i+1,3.7.f);5(e===r)2z;6 28=e.4l(0).K();5(!19[28])19[28]=[];6 A={e:e,7:V,u:3.23&&3.23(V)||e};19[28].2A(A);5(3v++<3.I){19[""].2A(A)}};$.J(19,4(i,e){3.1C++;1z(i,e)})}2m(1s,25);4 1r(){7={};f=0}a{1r:1r,1z:1z,1s:1s,3n:4(q){5(!3.1C||!f)a Q;5(!3.Z&&3.24){6 1a=[];1l(6 k 3e 7){5(k.f>0){6 c=7[k];$.J(c,4(i,x){5(1B(x.e,q)){1a.2A(x)}})}}a 1a}j 5(7[q]){a 7[q]}j 5(3.1B){1l(6 i=q.f-1;i>=3.2q;i--){6 c=7[q.4m(0,i)];5(c){6 1a=[];$.J(c,4(i,x){5(1B(x.e,q)){1a[1a.f]=x}});a 1a}}}a Q}}};$.N.30=4(3,g,h,1j){6 G={H:"4n"};6 l,o=-1,7,z="",2B=B,t,p;4 3x(){5(!2B)a;t=$("<4o/>").16().R(3.3r).1b("4p","4q").2C(2D.3y);p=$("<4r/>").2C(t).4s(4(w){5(1c(w).3z&&1c(w).3z.4t()==\'3A\'){o=$("1D",p).1A(G.H).4u(1c(w));$(1c(w)).R(G.H)}}).3d(4(w){$(1c(w)).R(G.H);h();g.3b();a r}).4v(4(){1j.1S=B}).4w(4(){1j.1S=r});5(3.F>0)t.1b("F",3.F);2B=r}4 1c(w){6 t=w.1c;4x(t&&t.4y!="3A")t=t.4z;5(!t)a[];a t}4 1d(29){l.1x(o,o+1).1A(G.H);3B(29);6 2E=l.1x(o,o+1).R(G.H);5(3.1N){6 M=0;l.1x(0,o).J(4(){M+=m.1E});5((M+2E[0].1E-p.1F())>p[0].4A){p.1F(M+2E[0].1E-p.4B())}j 5(M<p.1F()){p.1F(M)}}};4 3B(29){o+=29;5(o<0){o=l.1G()-1}j 5(o>=l.1G()){o=0}}4 3C(2F){a 3.I&&3.I<2F?3.I:2F}4 3D(){p.3E();6 I=3C(7.f);1l(6 i=0;i<I;i++){5(!7[i])2z;6 2G=3.2e(7[i].7,i+1,I,7[i].e,z);5(2G===r)2z;6 1D=$("<1D/>").4C(3.1O(2G,z)).R(i%2==0?"4D":"4E").2C(p)[0];$.7(1D,"3F",7[i])}l=p.4F("1D");5(3.2x){l.1x(0,1).R(G.H);o=0}5($.1f.3G)p.3G()}a{3l:4(d,q){3x();7=d;z=q;3D()},37:4(){1d(1)},36:4(){1d(-1)},39:4(){5(o!=0&&o-8<0){1d(-o)}j{1d(-8)}},3a:4(){5(o!=l.1G()-1&&o+8>l.1G()){1d(l.1G()-1-o)}j{1d(8)}},16:4(){t&&t.16();l&&l.1A(G.H);o=-1},O:4(){a t&&t.4G(":O")},4H:4(){a m.O()&&(l.3H("."+G.H)[0]||3.2x&&l[0])},2v:4(){6 M=$(g).M();t.1b({F:Y 3.F=="1L"||3.F>0?3.F:$(g).F(),3I:M.3I+g.1E,2H:M.2H}).2v();5(3.1N){p.1F(0);p.1b({3J:3.26,4I:\'4J\'});5($.2k.4K&&Y 2D.3y.4L.3J==="2a"){6 2b=0;l.J(4(){2b+=m.1E});6 2I=2b>3.26;p.1b(\'4M\',2I?3.26:2b);5(!2I){l.F(p.F()-3K(l.1b("3L-2H"))-3K(l.1b("3L-4N")))}}}},D:4(){6 D=l&&l.3H("."+G.H).1A(G.H);a D&&D.f&&$.7(D[0],"3F")},3q:4(){p&&p.3E()},1V:4(){t&&t.4O()}}};$.1f.1m=4(E,W){5(E!==2a){a m.J(4(){5(m.2J){6 1e=m.2J();5(W===2a||E==W){1e.4P("2K",E);1e.h()}j{1e.4Q(B);1e.4R("2K",E);1e.4S("2K",W);1e.h()}}j 5(m.3M){m.3M(E,W)}j 5(m.2c){m.2c=E;m.3N=W}})}6 X=m[0];5(X.2J){6 2L=2D.1m.4T(),3O=X.e,2M="<->",2N=2L.3P.f;2L.3P=2M;6 1H=X.e.3u(2M);X.e=3O;m.1m(1H,1H+2N);a{E:1H,W:1H+2N}}j 5(X.2c!==2a){a{E:X.2c,W:X.3N}}}})(4U);',62,305,'|||options|function|if|var|data|||return||||value|length|input|select||else||listItems|this||active|list||false||element|result||event||words|term|row|true|KEY|selected|start|width|CLASSES|ACTIVE|max|each|toLowerCase|val|offset|Autocompleter|visible|currentValue|null|addClass|case|break|multipleSeparator|rawValue|end|field|typeof|url||bind|trigger||previousValue|onChange|hide|trimWords|parsed|stMatchSets|csub|css|target|moveSelect|selRange|fn|autocomplete|timeout|hasFocus|config|multiple|for|selection|search|cache|preventDefault|trim|flush|populate|cursorAt|word|hideResultsNow|lastWord|slice|extraParams|add|removeClass|matchSubset|cacheLength|li|offsetHeight|scrollTop|size|caretAt|extend|urlOrData|isUrl|string|delay|scroll|highlight|formatMatch|handler|lastKeyPressCode|mouseDownOnSelect|blockSubmit|arguments|unbind|progress|matchCase|stopLoading|autoFill|success|param|parse|formatResult|matchContains||scrollHeight||firstChar|step|undefined|listHeight|selectionStart|defaults|formatItem|new|flushCache|setOptions|unautocomplete|selectCurrent|browser|clearTimeout|setTimeout|findValueCallback|request|wordAt|minChars|loadingClass|split|replace|sValue|show|rows|selectFirst|sub|continue|push|needsInit|appendTo|document|activeItem|available|formatted|left|scrollbarsVisible|createTextRange|character|range|teststring|textLength|UP|DOWN|DEL|TAB|RETURN|ESC|COMMA|PAGEUP|PAGEDOWN|BACKSPACE|inputClass|Cache|Select|opera|form|||keyCode|prev|next||pageUp|pageDown|focus|hideResults|click|in|seperator|join|skipPrevCheck|receiveData|substring|mustMatch|display|failure|load|key|dataType|emptyList|resultsClass|gi|strong|indexOf|nullData|ol|init|body|nodeName|LI|movePosition|limitNumberOfItems|fillList|empty|ac_data|bgiframe|filter|top|maxHeight|parseInt|padding|setSelectionRange|selectionEnd|orig|text|150|188|attr|off|submit|keypress|keydown|switch|default|blur||crap|map|200|wasVisible|timestamp||Date|ajax|mode|abort|port|name|limit|ac_input|ac_results|ac_loading|400|100|RegExp|180|charAt|substr|ac_over|div|position|absolute|ul|mouseover|toUpperCase|index|mousedown|mouseup|while|tagName|parentNode|clientHeight|innerHeight|html|ac_even|ac_odd|find|is|current|overflow|auto|msie|style|height|right|remove|move|collapse|moveStart|moveEnd|createRange|jQuery'.split('|'),0,{}))
//slides.js
/*
* Slides, A Slideshow Plugin for jQuery
* Intructions: http://slidesjs.com
* By: Nathan Searles, http://nathansearles.com
* Version: 1.1.9
* Updated: September 5th, 2011
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
;(function($){
	$.fn.slides = function( option ) {
		// override defaults with specified option
		option = $.extend( {}, $.fn.slides.option, option );

		return this.each(function(){
			// wrap slides in control container, make sure slides are block level
			$('.' + option.container, $(this)).children().wrapAll('<div class="slides_control"/>');
			
			var elem = $(this),
				control = $('.slides_control',elem),
				total = control.children().size(),
				width = control.children().outerWidth(),
				height = control.children().outerHeight(),
				start = option.start - 1,
				effect = option.effect.indexOf(',') < 0 ? option.effect : option.effect.replace(' ', '').split(',')[0],
				paginationEffect = option.effect.indexOf(',') < 0 ? effect : option.effect.replace(' ', '').split(',')[1],
				next = 0, prev = 0, number = 0, current = 0, loaded, active, clicked, position, direction, imageParent, pauseTimeout, playInterval;
			
			// is there only one slide?
			if (total < 2) {
				// Fade in .slides_container
				$('.' + option.container, $(this)).fadeIn(option.fadeSpeed, option.fadeEasing, function(){
					// let the script know everything is loaded
					loaded = true;
					// call the loaded funciton
					option.slidesLoaded();
				});
				// Hide the next/previous buttons
				//$('.' + option.next + ', .' + option.prev).fadeOut(0);
				return false;
			}

			// animate slides
			function animate(direction, effect, clicked) {
				if (!active && loaded) {
					active = true;
					// start of animation
					option.animationStart(current + 1);
					switch(direction) {
						case 'next_slide':
							// change current slide to previous
							prev = current;
							// get next from current + 1
							next = current + 1;
							// if last slide, set next to first slide
							next = total === next ? 0 : next;
							// set position of next slide to right of previous
							position = width*2;
							// distance to slide based on width of slides
							direction = -width*2;
							// store new current slide
							current = next;
						break;
						case 'prev_slide':
							// change current slide to previous
							prev = current;
							// get next from current - 1
							next = current - 1;
							// if first slide, set next to last slide
							next = next === -1 ? total-1 : next;								
							// set position of next slide to left of previous
							position = 0;								
							// distance to slide based on width of slides
							direction = 0;		
							// store new current slide
							current = next;
						break;
						case 'pagination':
							// get next from pagination item clicked, convert to number
							next = parseInt(clicked,10);
							// get previous from pagination item with class of current
							prev = $('.' + option.paginationClass + ' li.'+ option.currentClass +' a', elem).attr('href').match('[^#/]+$');
							// if next is greater then previous set position of next slide to right of previous
							if (next > prev) {
								position = width*2;
								direction = -width*2;
							} else {
							// if next is less then previous set position of next slide to left of previous
								position = 0;
								direction = 0;
							}
							// store new current slide
							current = next;
						break;
					}

					// fade animation
					if (effect === 'fade') {
						// fade animation with crossfade
						if (option.crossfade) {
							// put hidden next above current
							control.children(':eq('+ next +')', elem).css({
								zIndex: 10
							// fade in next
							}).fadeIn(option.fadeSpeed, option.fadeEasing, function(){
								if (option.autoHeight) {
									// animate container to height of next
									control.animate({
										height: control.children(':eq('+ next +')', elem).outerHeight()
									}, option.autoHeightSpeed, function(){
										// hide previous
										control.children(':eq('+ prev +')', elem).css({
											display: 'none',
											zIndex: 0
										});								
										// reset z index
										control.children(':eq('+ next +')', elem).css({
											zIndex: 0
										});									
										// end of animation
										option.animationComplete(next + 1);
										active = false;
									});
								} else {
									// hide previous
									control.children(':eq('+ prev +')', elem).css({
										display: 'none',
										zIndex: 0
									});									
									// reset zindex
									control.children(':eq('+ next +')', elem).css({
										zIndex: 0
									});									
									// end of animation
									option.animationComplete(next + 1);
									active = false;
								}
							});
						} else {
							// fade animation with no crossfade
							control.children(':eq('+ prev +')', elem).fadeOut(option.fadeSpeed,  option.fadeEasing, function(){
								// animate to new height
								if (option.autoHeight) {
									control.animate({
										// animate container to height of next
										height: control.children(':eq('+ next +')', elem).outerHeight()
									}, option.autoHeightSpeed,
									// fade in next slide
									function(){
										control.children(':eq('+ next +')', elem).fadeIn(option.fadeSpeed, option.fadeEasing);
									});
								} else {
								// if fixed height
									control.children(':eq('+ next +')', elem).fadeIn(option.fadeSpeed, option.fadeEasing, function(){
										// fix font rendering in ie, lame
										if($.browser.msie) {
											$(this).get(0).style.removeAttribute('filter');
										}
									});
								}									
								// end of animation
								option.animationComplete(next + 1);
								active = false;
							});
						}
					// slide animation
					} else {
						// move next slide to right of previous
						control.children(':eq('+ next +')').css({
							left: position,
							display: 'block'
						});
						// animate to new height
						if (option.autoHeight) {
							control.animate({
								left: direction,
								height: control.children(':eq('+ next +')').outerHeight()
							},option.slideSpeed, option.slideEasing, function(){
								control.css({
									left: -width
								});
								control.children(':eq('+ next +')').css({
									left: width,
									zIndex: 5
								});
								// reset previous slide
								control.children(':eq('+ prev +')').css({
									left: width,
									display: 'none',
									zIndex: 0
								});
								// end of animation
								option.animationComplete(next + 1);
								active = false;
							});
							// if fixed height
							} else {
								// animate control
								control.animate({
									left: direction
								},option.slideSpeed, option.slideEasing, function(){
									// after animation reset control position
									control.css({
										left: -width
									});
									// reset and show next
									control.children(':eq('+ next +')').css({
										left: width,
										zIndex: 5
									});
									// reset previous slide
									control.children(':eq('+ prev +')').css({
										left: width,
										display: 'none',
										zIndex: 0
									});
									// end of animation
									option.animationComplete(next + 1);
									active = false;
								});
							}
						}
					// set current state for pagination
					if (option.pagination) {
						// remove current class from all
						$('.'+ option.paginationClass +' li.' + option.currentClass, elem).removeClass(option.currentClass);
						// add current class to next
						$('.' + option.paginationClass + ' li:eq('+ next +')', elem).addClass(option.currentClass);
					}
				}
			} // end animate function
			
			function stop() {
				// clear interval from stored id
				clearInterval(elem.data('interval'));
			}

			function pause() {
				if (option.pause) {
					// clear timeout and interval
					clearTimeout(elem.data('pause'));
					clearInterval(elem.data('interval'));
					// pause slide show for option.pause amount
					pauseTimeout = setTimeout(function() {
						// clear pause timeout
						clearTimeout(elem.data('pause'));
						// start play interval after pause
						playInterval = setInterval(	function(){
							animate("next", effect);
						},option.play);
						// store play interval
						elem.data('interval',playInterval);
					},option.pause);
					// store pause interval
					elem.data('pause',pauseTimeout);
				} else {
					// if no pause, just stop
					stop();
				}
			}
				
			// 2 or more slides required
			if (total < 2) {
				return;
			}
			
			// error corection for start slide
			if (start < 0) {
				start = 0;
			}
			
			if (start > total) {
				start = total - 1;
			}
					
			// change current based on start option number
			if (option.start) {
				current = start;
			}
			
			// randomizes slide order
			if (option.randomize) {
				control.randomize();
			}
			
			// make sure overflow is hidden, width is set
			$('.' + option.container, elem).css({
				overflow: 'hidden',
				// fix for ie
				position: 'relative'
			});
			
			// set css for slides
			control.children().css({
				position: 'absolute',
				top: 0, 
				left: control.children().outerWidth(),
				zIndex: 0,
				display: 'none'
			 });
			
			// set css for control div
			control.css({
				position: 'relative',
				// size of control 3 x slide width
				width: (width * 3),
				// set height to slide height
				height: height,
				// center control to slide
				left: -width
			});
			
			// show slides
			$('.' + option.container, elem).css({
				display: 'block'
			});

			// if autoHeight true, get and set height of first slide
			if (option.autoHeight) {
				control.children().css({
					height: 'auto'
				});
				control.animate({
					height: control.children(':eq('+ start +')').outerHeight()
				},option.autoHeightSpeed);
			}
			
			// checks if image is loaded
			if (option.preload && control.find('img:eq(' + start + ')').length) {
				// adds preload image
				$('.' + option.container, elem).css({
					background: 'url(' + option.preloadImage + ') no-repeat 50% 50%'
				});
				
				// gets image src, with cache buster
				var img = control.find('img:eq(' + start + ')').attr('src') + '?' + (new Date()).getTime();
				
				// check if the image has a parent
				if ($('img', elem).parent().attr('class') != 'slides_control') {
					// If image has parent, get tag name
					imageParent = control.children(':eq(0)')[0].tagName.toLowerCase();
				} else {
					// Image doesn't have parent, use image tag name
					imageParent = control.find('img:eq(' + start + ')');
				}

				// checks if image is loaded
				control.find('img:eq(' + start + ')').attr('src', img).load(function() {
					// once image is fully loaded, fade in
					control.find(imageParent + ':eq(' + start + ')').fadeIn(option.fadeSpeed, option.fadeEasing, function(){
						$(this).css({
							zIndex: 5
						});
						// removes preload image
						$('.' + option.container, elem).css({
							background: ''
						});
						// let the script know everything is loaded
						loaded = true;
						// call the loaded funciton
						option.slidesLoaded();
					});
				});
			} else {
				// if no preloader fade in start slide
				control.children(':eq(' + start + ')').fadeIn(option.fadeSpeed, option.fadeEasing, function(){
					// let the script know everything is loaded
					loaded = true;
					// call the loaded funciton
					option.slidesLoaded();
				});
			}
			
			// click slide for next
			if (option.bigTarget) {
				// set cursor to pointer
				control.children().css({
					cursor: 'pointer'
				});
				// click handler
				control.children().click(function(){
					// animate to next on slide click
					animate('next', effect);
					return false;
				});									
			}
			
			// pause on mouseover
			if (option.hoverPause && option.play) {
				control.bind('mouseover',function(){
					// on mouse over stop
					stop();
				});
				control.bind('mouseleave',function(){
					// on mouse leave start pause timeout
					pause();
				});
			}
			
			// generate next/prev buttons
			if (option.generateNextPrev) {
				$('.' + option.container, elem).after('<a href="#" class="'+ option.prev +'">Prev</a>');
				$('.' + option.prev, elem).after('<a href="#" class="'+ option.next +'">Next</a>');
			}
			
			// next button
			$('.' + option.next ,elem).click(function(e){
				e.preventDefault();
				if (option.play) {
					pause();
				}
				animate('next_slide', effect);
			});
			
			// previous button
			$('.' + option.prev, elem).click(function(e){
				e.preventDefault();
				if (option.play) {
					 pause();
				}
				animate('prev_slide', effect);
			});
			
			// generate pagination
			if (option.generatePagination) {
				// create unordered list
				if (option.prependPagination) {
					elem.prepend('<ul class='+ option.paginationClass +'></ul>');
				} else {
					elem.append('<ul class='+ option.paginationClass +'></ul>');
				}
				// for each slide create a list item and link
				control.children().each(function(){
					$('.' + option.paginationClass, elem).append('<li><a href="#'+ number +'">'+ (number+1) +'</a></li>');
					number++;
				});
			} else {
				// if pagination exists, add href w/ value of item number to links
				$('.' + option.paginationClass + ' li a', elem).each(function(){
					$(this).attr('href', '#' + number);
					number++;
				});
			}
			
			// add current class to start slide pagination
			$('.' + option.paginationClass + ' li:eq('+ start +')', elem).addClass(option.currentClass);
			
			// click handling 
			$('.' + option.paginationClass + ' li a', elem ).click(function(){
				// pause slideshow
				if (option.play) {
					 pause();
				}
				// get clicked, pass to animate function					
				clicked = $(this).attr('href').match('[^#/]+$');
				// if current slide equals clicked, don't do anything
				if (current != clicked) {
					animate('pagination', paginationEffect, clicked);
				}
				return false;
			});
			
			// click handling 
			$('a.link', elem).click(function(){
				// pause slideshow
				if (option.play) {
					 pause();
				}
				// get clicked, pass to animate function					
				clicked = $(this).attr('href').match('[^#/]+$') - 1;
				// if current slide equals clicked, don't do anything
				if (current != clicked) {
					animate('pagination', paginationEffect, clicked);
				}
				return false;
			});
		
			if (option.play) {
				// set interval
				playInterval = setInterval(function() {
					animate('next', effect);
				}, option.play);
				// store interval id
				elem.data('interval',playInterval);
			}
		});
	};
	
	// default options
	$.fn.slides.option = {
		preload: false, // boolean, Set true to preload images in an image based slideshow
		preloadImage: '/img/loading.gif', // string, Name and location of loading image for preloader. Default is "/img/loading.gif"
		container: 'slides_container', // string, Class name for slides container. Default is "slides_container"
		generateNextPrev: false, // boolean, Auto generate next/prev buttons
		next: 'next_slide', // string, Class name for next button
		prev: 'prev_slide', // string, Class name for previous button
		pagination: true, // boolean, If you're not using pagination you can set to false, but don't have to
		generatePagination: true, // boolean, Auto generate pagination
		prependPagination: false, // boolean, prepend pagination
		paginationClass: 'pagination', // string, Class name for pagination
		currentClass: 'current', // string, Class name for current class
		fadeSpeed: 350, // number, Set the speed of the fading animation in milliseconds
		fadeEasing: '', // string, must load jQuery's easing plugin before http://gsgd.co.uk/sandbox/jquery/easing/
		slideSpeed: 350, // number, Set the speed of the sliding animation in milliseconds
		slideEasing: '', // string, must load jQuery's easing plugin before http://gsgd.co.uk/sandbox/jquery/easing/
		start: 1, // number, Set the speed of the sliding animation in milliseconds
		effect: 'slide', // string, '[next/prev], [pagination]', e.g. 'slide, fade' or simply 'fade' for both
		crossfade: false, // boolean, Crossfade images in a image based slideshow
		randomize: false, // boolean, Set to true to randomize slides
		play: 0, // number, Autoplay slideshow, a positive number will set to true and be the time between slide animation in milliseconds
		pause: 0, // number, Pause slideshow on click of next/prev or pagination. A positive number will set to true and be the time of pause in milliseconds
		hoverPause: false, // boolean, Set to true and hovering over slideshow will pause it
		autoHeight: false, // boolean, Set to true to auto adjust height
		autoHeightSpeed: 350, // number, Set auto height animation time in milliseconds
		bigTarget: false, // boolean, Set to true and the whole slide will link to next slide on click
		animationStart: function(){}, // Function called at the start of animation
		animationComplete: function(){}, // Function called at the completion of animation
		slidesLoaded: function() {} // Function is called when slides is fully loaded
	};
	
	// Randomize slide order on load
	$.fn.randomize = function(callback) {
		function randomizeOrder() { return(Math.round(Math.random())-0.5); }
			return($(this).each(function() {
			var $this = $(this);
			var $children = $this.children();
			var childCount = $children.length;
			if (childCount > 1) {
				$children.hide();
				var indices = [];
				for (i=0;i<childCount;i++) { indices[indices.length] = i; }
				indices = indices.sort(randomizeOrder);
				$.each(indices,function(j,k) { 
					var $child = $children.eq(k);
					var $clone = $child.clone(true);
					$clone.show().appendTo($this);
					if (callback !== undefined) {
						callback($child, $clone);
					}
				$child.remove();
			});
			}
		}));
	};
})(jQuery);

//hotkeys.js
/*
 * jQuery Hotkeys Plugin
 * Copyright 2010, John Resig
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Based upon the plugin by Tzury Bar Yochay:
 * http://github.com/tzuryby/hotkeys
 *
 * Original idea by:
 * Binny V A, http://www.openjs.com/scripts/events/keyboard_shortcuts/
*/

;(function(jQuery){
	
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
		// Only care when a possible input has been specified
		if ( typeof handleObj.data !== "string" ) {
			return;
		}
		
		var origHandler = handleObj.handler,
			keys = handleObj.data.toLowerCase().split(" ");
	
		handleObj.handler = function( event ) {
			// Don't fire in text-accepting inputs that we didn't directly bind to
			if ( this !== event.target && (/textarea|select/i.test( event.target.nodeName ) ||
				 event.target.type === "text") ) {
				return;
			}
			
			// Keypress represents characters, not special keys
			var special = event.type !== "keypress" && jQuery.hotkeys.specialKeys[ event.which ],
				character = String.fromCharCode( event.which ).toLowerCase(),
				key, modif = "", possible = {};

			// check combinations (alt|ctrl|shift+anything)
			if ( event.altKey && special !== "alt" ) {
				modif += "alt+";
			}

			if ( event.ctrlKey && special !== "ctrl" ) {
				modif += "ctrl+";
			}
			
			// TODO: Need to make sure this works consistently across platforms
			if ( event.metaKey && !event.ctrlKey && special !== "meta" ) {
				modif += "meta+";
			}

			if ( event.shiftKey && special !== "shift" ) {
				modif += "shift+";
			}

			if ( special ) {
				possible[ modif + special ] = true;

			} else {
				possible[ modif + character ] = true;
				possible[ modif + jQuery.hotkeys.shiftNums[ character ] ] = true;

				// "$" can be triggered as "Shift+4" or "Shift+$" or just "$"
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

//jtemplate.js
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('a(37.b&&!37.b.38){(9(b){6 m=9(s,A,f){5.1M=[];5.1u={};5.2p=E;5.1N={};5.1c={};5.f=b.1m({1Z:1f,3a:1O,2q:1f,2r:1f,3b:1O,3c:1O},f);5.1v=(5.f.1v!==F)?(5.f.1v):(13.20);5.Y=(5.f.Y!==F)?(5.f.Y):(13.3d);5.3e(s,A);a(s){5.1w(5.1c[\'21\'],A,5.f)}5.1c=E};m.y.2s=\'0.7.8\';m.R=1O;m.y.3e=9(s,A){6 2t=/\\{#14 *(\\w*?)( .*)*\\}/g;6 22,1x,M;6 1y=E;6 2u=[];2v((22=2t.3N(s))!=E){1y=2t.1y;1x=22[1];M=s.2w(\'{#/14 \'+1x+\'}\',1y);a(M==-1){C j Z(\'15: m "\'+1x+\'" 2x 23 3O.\');}5.1c[1x]=s.2y(1y,M);2u[1x]=13.2z(22[2])}a(1y===E){5.1c[\'21\']=s;c}N(6 i 24 5.1c){a(i!=\'21\'){5.1N[i]=j m()}}N(6 i 24 5.1c){a(i!=\'21\'){5.1N[i].1w(5.1c[i],b.1m({},A||{},5.1N||{}),b.1m({},5.f,2u[i]));5.1c[i]=E}}};m.y.1w=9(s,A,f){a(s==F){5.1M.B(j 1g(\'\',1,5));c}s=s.U(/[\\n\\r]/g,\'\');s=s.U(/\\{\\*.*?\\*\\}/g,\'\');5.2p=b.1m({},5.1N||{},A||{});5.f=j 2A(f);6 p=5.1M;6 1P=s.1h(/\\{#.*?\\}/g);6 16=0,M=0;6 e;6 1i=0;6 25=0;N(6 i=0,l=(1P)?(1P.V):(0);i<l;++i){6 17=1P[i];a(1i){M=s.2w(\'{#/1z}\');a(M==-1){C j Z("15: 3P 1Q 3f 1z.");}a(M>16){p.B(j 1g(s.2y(16,M),1,5))}16=M+11;1i=0;i=b.3Q(\'{#/1z}\',1P);1R}M=s.2w(17,16);a(M>16){p.B(j 1g(s.2y(16,M),1i,5))}6 3R=17.1h(/\\{#([\\w\\/]+).*?\\}/);6 26=I.$1;2B(26){q\'3S\':++25;p.27();q\'a\':e=j 1A(17,p);p.B(e);p=e;D;q\'J\':p.27();D;q\'/a\':2v(25){p=p.28();--25}q\'/N\':q\'/29\':p=p.28();D;q\'29\':e=j 1n(17,p,5);p.B(e);p=e;D;q\'N\':e=2a(17,p,5);p.B(e);p=e;D;q\'1R\':q\'D\':p.B(j 18(26));D;q\'2C\':p.B(j 2D(17,5.2p));D;q\'h\':p.B(j 2E(17));D;q\'2F\':p.B(j 2G(17));D;q\'3T\':p.B(j 1g(\'{\',1,5));D;q\'3U\':p.B(j 1g(\'}\',1,5));D;q\'1z\':1i=1;D;q\'/1z\':a(m.R){C j Z("15: 3V 2H 3f 1z.");}D;2I:a(m.R){C j Z(\'15: 3W 3X: \'+26+\'.\');}}16=M+17.V}a(s.V>16){p.B(j 1g(s.3Y(16),1i,5))}};m.y.K=9(d,h,z,H){++H;6 $T=d,2b,2c;a(5.f.3b){$T=5.1v(d,{2d:(5.f.3a&&H==1),1S:5.f.1Z},5.Y)}a(!5.f.3c){2b=5.1u;2c=h}J{2b=5.1v(5.1u,{2d:(5.f.2q),1S:1f},5.Y);2c=5.1v(h,{2d:(5.f.2q&&H==1),1S:1f},5.Y)}6 $P=b.1m({},2b,2c);6 $Q=(z!=F)?(z):({});$Q.2s=5.2s;6 19=\'\';N(6 i=0,l=5.1M.V;i<l;++i){19+=5.1M[i].K($T,$P,$Q,H)}--H;c 19};m.y.2J=9(1T,1o){5.1u[1T]=1o};13=9(){};13.3d=9(3g){c 3g.U(/&/g,\'&3Z;\').U(/>/g,\'&3h;\').U(/</g,\'&3i;\').U(/"/g,\'&40;\').U(/\'/g,\'&#39;\')};13.20=9(d,1B,Y){a(d==E){c d}2B(d.2K){q 2A:6 o={};N(6 i 24 d){o[i]=13.20(d[i],1B,Y)}a(!1B.1S){a(d.41("2L"))o.2L=d.2L}c o;q 42:6 o=[];N(6 i=0,l=d.V;i<l;++i){o[i]=13.20(d[i],1B,Y)}c o;q 2M:c(1B.2d)?(Y(d)):(d);q 43:a(1B.1S){a(m.R)C j Z("15: 44 45 23 46.");J c F}2I:c d}};13.2z=9(2e){a(2e===E||2e===F){c{}}6 o=2e.47(/[= ]/);a(o[0]===\'\'){o.48()}6 2N={};N(6 i=0,l=o.V;i<l;i+=2){2N[o[i]]=o[i+1]}c 2N};6 1g=9(2O,1i,14){5.2f=2O;5.3j=1i;5.1d=14};1g.y.K=9(d,h,z,H){6 2g=5.2f;a(!5.3j){6 2P=5.1d;6 $T=d;6 $P=h;6 $Q=z;2g=2g.U(/\\{(.*?)\\}/g,9(49,3k){1C{6 1D=10(3k);a(1E 1D==\'9\'){a(2P.f.1Z||!2P.f.2r){c\'\'}J{1D=1D($T,$P,$Q)}}c(1D===F)?(""):(2M(1D))}1F(e){a(m.R){a(e 1G 18)e.1j="4a";C e;}c""}})}c 2g};6 1A=9(L,1H){5.2h=1H;L.1h(/\\{#(?:J)*a (.*?)\\}/);5.3l=I.$1;5.1p=[];5.1q=[];5.1I=5.1p};1A.y.B=9(e){5.1I.B(e)};1A.y.28=9(){c 5.2h};1A.y.27=9(){5.1I=5.1q};1A.y.K=9(d,h,z,H){6 $T=d;6 $P=h;6 $Q=z;6 19=\'\';1C{6 2Q=(10(5.3l))?(5.1p):(5.1q);N(6 i=0,l=2Q.V;i<l;++i){19+=2Q[i].K(d,h,z,H)}}1F(e){a(m.R||(e 1G 18))C e;}c 19};2a=9(L,1H,14){a(L.1h(/\\{#N (\\w+?) *= *(\\S+?) +4b +(\\S+?) *(?:12=(\\S+?))*\\}/)){L=\'{#29 2a.3m 3n \'+I.$1+\' 2H=\'+(I.$2||0)+\' 1Q=\'+(I.$3||-1)+\' 12=\'+(I.$4||1)+\' u=$T}\';c j 1n(L,1H,14)}J{C j Z(\'15: 4c 4d "3o": \'+L);}};2a.3m=9(i){c i};6 1n=9(L,1H,14){5.2h=1H;5.1d=14;L.1h(/\\{#29 (.+?) 3n (\\w+?)( .+)*\\}/);5.3p=I.$1;5.x=I.$2;5.W=I.$3||E;5.W=13.2z(5.W);5.1p=[];5.1q=[];5.1I=5.1p};1n.y.B=9(e){5.1I.B(e)};1n.y.28=9(){c 5.2h};1n.y.27=9(){5.1I=5.1q};1n.y.K=9(d,h,z,H){1C{6 $T=d;6 $P=h;6 $Q=z;6 1r=10(5.3p);6 1U=[];6 1J=1E 1r;a(1J==\'3q\'){6 2R=[];b.1e(1r,9(k,v){1U.B(k);2R.B(v)});1r=2R}6 u=(5.W.u!==F)?(10(5.W.u)):(($T!=E)?($T):({}));6 s=1V(10(5.W.2H)||0),e;6 12=1V(10(5.W.12)||1);a(1J!=\'9\'){e=1r.V}J{a(5.W.1Q===F||5.W.1Q===E){e=1V.4e}J{e=1V(10(5.W.1Q))+((12>0)?(1):(-1))}}6 19=\'\';6 i,l;a(5.W.1W){6 2S=s+1V(10(5.W.1W));e=(2S>e)?(e):(2S)}a((e>s&&12>0)||(e<s&&12<0)){6 1K=0;6 3r=(1J!=\'9\')?(4f.4g((e-s)/12)):F;6 1s,1k;N(;((12>0)?(s<e):(s>e));s+=12,++1K){1s=1U[s];a(1J!=\'9\'){1k=1r[s]}J{1k=1r(s);a(1k===F||1k===E){D}}a((1E 1k==\'9\')&&(5.1d.f.1Z||!5.1d.f.2r)){1R}a((1J==\'3q\')&&(1s 24 2A)){1R}6 3s=u[5.x];u[5.x]=1k;u[5.x+\'$3t\']=s;u[5.x+\'$1K\']=1K;u[5.x+\'$3u\']=(1K==0);u[5.x+\'$3v\']=(s+12>=e);u[5.x+\'$3w\']=3r;u[5.x+\'$1U\']=(1s!==F&&1s.2K==2M)?(5.1d.Y(1s)):(1s);u[5.x+\'$1E\']=1E 1k;N(i=0,l=5.1p.V;i<l;++i){1C{19+=5.1p[i].K(u,h,z,H)}1F(2T){a(2T 1G 18){2B(2T.1j){q\'1R\':i=l;D;q\'D\':i=l;s=e;D;2I:C e;}}J{C e;}}}1l u[5.x+\'$3t\'];1l u[5.x+\'$1K\'];1l u[5.x+\'$3u\'];1l u[5.x+\'$3v\'];1l u[5.x+\'$3w\'];1l u[5.x+\'$1U\'];1l u[5.x+\'$1E\'];1l u[5.x];u[5.x]=3s}}J{N(i=0,l=5.1q.V;i<l;++i){19+=5.1q[i].K($T,h,z,H)}}c 19}1F(e){a(m.R||(e 1G 18))C e;c""}};6 18=9(1j){5.1j=1j};18.y=Z;18.y.K=9(d){C 5;};6 2D=9(L,A){L.1h(/\\{#2C (.*?)(?: 4h=(.*?))?\\}/);5.1d=A[I.$1];a(5.1d==F){a(m.R)C j Z(\'15: 4i 3o 2C: \'+I.$1);}5.3x=I.$2};2D.y.K=9(d,h,z,H){6 $T=d;6 $P=h;1C{c 5.1d.K(10(5.3x),h,z,H)}1F(e){a(m.R||(e 1G 18))C e;}c\'\'};6 2E=9(L){L.1h(/\\{#h 1T=(\\w*?) 1o=(.*?)\\}/);5.x=I.$1;5.2f=I.$2};2E.y.K=9(d,h,z,H){6 $T=d;6 $P=h;6 $Q=z;1C{h[5.x]=10(5.2f)}1F(e){a(m.R||(e 1G 18))C e;h[5.x]=F}c\'\'};6 2G=9(L){L.1h(/\\{#2F 4j=(.*?)\\}/);5.2U=10(I.$1);5.2V=5.2U.V;a(5.2V<=0){C j Z(\'15: 2F 4k 4l 4m\');}5.2W=0;5.2X=-1};2G.y.K=9(d,h,z,H){6 2Y=b.O(z,\'1X\');a(2Y!=5.2X){5.2X=2Y;5.2W=0}6 i=5.2W++%5.2V;c 5.2U[i]};b.1a.1w=9(s,A,f){a(s.2K===m){c b(5).1e(9(){b.O(5,\'2i\',s);b.O(5,\'1X\',0)})}J{c b(5).1e(9(){b.O(5,\'2i\',j m(s,A,f));b.O(5,\'1X\',0)})}};b.1a.4n=9(1L,A,f){6 s=b.2Z({1t:1L,1Y:1f}).3y;c b(5).1w(s,A,f)};b.1a.4o=9(30,A,f){6 s=b(\'#\'+30).2O();a(s==E){s=b(\'#\'+30).3z();s=s.U(/&3i;/g,"<").U(/&3h;/g,">")}s=b.4p(s);s=s.U(/^<\\!\\[4q\\[([\\s\\S]*)\\]\\]>$/3A,\'$1\');s=s.U(/^<\\!--([\\s\\S]*)-->$/3A,\'$1\');c b(5).1w(s,A,f)};b.1a.4r=9(){6 1W=0;b(5).1e(9(){a(b.2j(5)){++1W}});c 1W};b.1a.4s=9(){b(5).3B();c b(5).1e(9(){b.3C(5,\'2i\')})};b.1a.2J=9(1T,1o){c b(5).1e(9(){6 t=b.2j(5);a(t===F){a(m.R)C j Z(\'15: m 2x 23 3D.\');J c}t.2J(1T,1o)})};b.1a.31=9(d,h){c b(5).1e(9(){6 t=b.2j(5);a(t===F){a(m.R)C j Z(\'15: m 2x 23 3D.\');J c}b.O(5,\'1X\',b.O(5,\'1X\')+1);b(5).3z(t.K(d,h,5,0))})};b.1a.4t=9(1L,h,G){6 X=5;G=b.1m({1j:\'4u\',1Y:1O,32:1f},G);b.2Z({1t:1L,1j:G.1j,O:G.O,3E:G.3E,1Y:G.1Y,32:G.32,3F:G.3F,4v:\'4w\',4x:9(d){6 r=b(X).31(d,h);a(G.2k){G.2k(r)}},4y:G.4z,4A:G.4B});c 5};6 2l=9(1t,h,2m,2n,1b,G){5.3G=1t;5.1u=h;5.3H=2m;5.3I=2n;5.1b=1b;5.3J=E;5.33=G||{};6 X=5;b(1b).1e(9(){b.O(5,\'34\',X)});5.35()};2l.y.35=9(){5.3K();a(5.1b.V==0){c}6 X=5;b.4C(5.3G,5.3I,9(d){6 r=b(X.1b).31(d,X.1u);a(X.33.2k){X.33.2k(r)}});5.3J=4D(9(){X.35()},5.3H)};2l.y.3K=9(){5.1b=b.3L(5.1b,9(o){a(b.4E.4F){6 n=o.36;2v(n&&n!=4G){n=n.36}c n!=E}J{c o.36!=E}})};b.1a.4H=9(1t,h,2m,2n,G){c j 2l(1t,h,2m,2n,5,G)};b.1a.3B=9(){c b(5).1e(9(){6 2o=b.O(5,\'34\');a(2o==E){c}6 X=5;2o.1b=b.3L(2o.1b,9(o){c o!=X});b.3C(5,\'34\')})};b.1m({38:9(s,A,f){c j m(s,A,f)},4I:9(1L,A,f){6 s=b.2Z({1t:1L,1Y:1f}).3y;c j m(s,A,f)},2j:9(z){c b.O(z,\'2i\')},4J:9(14,O,3M){c 14.K(O,3M,F,0)},4K:9(1o){m.R=1o}})})(b)}',62,295,'|||||this|var|||function|if|jQuery|return|||settings||param||new|||Template|||node|case||||extData|||_name|prototype|element|includes|push|throw|break|null|undefined|options|deep|RegExp|else|get|oper|se|for|data|||DEBUG_MODE|||replace|length|_option|that|f_escapeString|Error|eval||step|TemplateUtils|template|jTemplates|ss|this_op|JTException|ret|fn|objs|_templates_code|_template|each|false|TextNode|match|literalMode|type|cval|delete|extend|opFOREACH|value|_onTrue|_onFalse|fcount|ckey|url|_param|f_cloneData|setTemplate|tname|lastIndex|literal|opIF|filter|try|__tmp|typeof|catch|instanceof|par|_currentState|mode|iteration|url_|_tree|_templates|true|op|end|continue|noFunc|name|key|Number|count|jTemplateSID|async|disallow_functions|cloneData|MAIN|iter|not|in|elseif_level|op_|switchToElse|getParent|foreach|opFORFactory|_param1|_param2|escapeData|optionText|_value|__t|_parent|jTemplate|getTemplate|on_success|Updater|interval|args|updater|_includes|filter_params|runnable_functions|version|reg|_template_settings|while|indexOf|is|substring|optionToObject|Object|switch|include|Include|UserParam|cycle|Cycle|begin|default|setParam|constructor|toString|String|obj|val|__template|tab|arr|tmp|ex|_values|_length|_index|_lastSessionID|sid|ajax|elementName|processTemplate|cache|_options|jTemplateUpdater|run|parentNode|window|createTemplate||filter_data|clone_data|clone_params|escapeHTML|splitTemplates|of|txt|gt|lt|_literalMode|__1|_cond|funcIterator|as|find|_arg|object|_total|prevValue|index|first|last|total|_root|responseText|html|im|processTemplateStop|removeData|defined|dataFilter|timeout|_url|_interval|_args|timer|detectDeletedNodes|grep|parameter|exec|closed|No|inArray|ppp|elseif|ldelim|rdelim|Missing|unknown|tag|substr|amp|quot|hasOwnProperty|Array|Function|Functions|are|allowed|split|shift|__0|subtemplate|to|Operator|failed|MAX_VALUE|Math|ceil|root|Cannot|values|has|no|elements|setTemplateURL|setTemplateElement|trim|CDATA|hasTemplate|removeTemplate|processTemplateURL|GET|dataType|json|success|error|on_error|complete|on_complete|getJSON|setTimeout|browser|msie|document|processTemplateStart|createTemplateURL|processTemplateToText|jTemplatesDebugMode'.split('|'),0,{}))

//pagination.js
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(5($){$.E=5(a,b){3.N=a;3.4=b};$.J($.E.U,{k:5(){9 o.1g(3.N/3.4.u)},1a:5(a){6 b=o.1p(3.4.C/2);6 c=3.k();6 d=c-3.4.C;6 e=a>b?o.19(o.H(a-b,d),0):0;6 f=a>b?o.H(a+b+(3.4.C%2),c):o.H(3.4.C,c);9{w:e,p:f}}});$.t={};$.t.L=5(a,b){3.N=a;3.4=b;3.K=I $.E(a,b)};$.J($.t.L.U,{F:5(a,b,c){6 d,j=3.K.k();a=a<0?0:(a<j?a:j-1);c=$.J({x:a+1,q:""},c||{});7(a==b){d=$("<s 17=\'1i\'>"+c.x+"</s>")}1j{d=$("<a>"+c.x+"</a>").1l(\'1n\',3.4.16.1s(/1B/,a))}7(c.q){d.1d(c.q)};d.n(\'14\',a);9 d},G:5(a,b,c,d,e){6 i;1F(i=c;i<d;i++){3.F(i,b,e).D(a)}},S:5(a,b){6 c,p,m=3.K.1a(a),j=3.K.k(),h=$("<12 17=\'Y\'></12>");7(3.4.T&&(a>0||3.4.W)){h.13(3.F(a-1,a,{x:3.4.T,q:"1k"}))};7(m.w>0&&3.4.r>0){p=o.H(3.4.r,m.w);3.G(h,a,0,p,{q:\'1m\'});7(3.4.r<m.w&&3.4.v){y("<s>"+3.4.v+"</s>").D(h)}}3.G(h,a,m.w,m.p);7(m.p<j&&3.4.r>0){7(j-3.4.r>m.p&&3.4.v){y("<s>"+3.4.v+"</s>").D(h)}c=o.19(j-3.4.r,m.p);3.G(h,a,c,j,{q:\'1q\'})}7(3.4.Q&&(a<j-1||3.4.V)){h.13(3.F(a+1,a,{x:3.4.Q,q:"1C"}))}$(\'a\',h).1b(b);9 h}});$.1c.Y=5(c,d){d=y.J({u:10,C:11,8:0,r:0,16:"#",T:"1e",Q:"1f",v:"...",W:X,V:X,l:"L",Z:z,M:5(){9 z}},d||{});6 e=3,l,B,8;5 R(a){6 b,15=$(a.1o).n(\'14\'),P=A(15);7(!P){a.1r()}9 P};5 A(a){e.n(\'8\',a);B=l.S(a,R);e.18();B.D(e);6 b=d.M(a,e);9 b};8=d.8;e.n(\'8\',8);c=(!c||c<0)?1:c;d.u=(!d.u||d.u<0)?1:d.u;7(!$.t[d.l]){1t I 1u("1v l \'"+d.l+"\' 1w 1x 1y 1z y.t 1A.");}l=I $.t[d.l](c,d);6 f=I $.E(c,d);6 g=f.k();e.O(\'1D\',{k:g},5(a,b){7(b>=0&&b<a.n.k){A(b);9 z}});e.O(\'1E\',5(a){6 b=$(3).n(\'8\');7(b>0){A(b-1)}9 z});e.O(\'1h\',{k:g},5(a){6 b=$(3).n(\'8\');7(b<a.n.k-1){A(b+1)}9 z});B=l.S(8,R);e.18();B.D(e);7(d.Z){d.M(8,e)}}})(y);',62,104,'|||this|opts|function|var|if|current_page|return||||||||fragment||np|numPages|renderer|interval|data|Math|end|classes|num_edge_entries|span|PaginationRenderers|items_per_page|ellipse_text|start|text|jQuery|false|selectPage|links|num_display_entries|appendTo|PaginationCalculator|createLink|appendRange|min|new|extend|pc|defaultRenderer|callback|maxentries|bind|continuePropagation|next_text|paginationClickHandler|getLinks|prev_text|prototype|next_show_always|prev_show_always|true|pagination|load_first_page|||div|append|page_id|new_current_page|link_to|class|empty|max|getInterval|click|fn|addClass|Prev|Next|ceil|nextPage|current|else|prev|attr|sp|href|target|floor|ep|stopPropagation|replace|throw|ReferenceError|Pagination|was|not|found|in|object|__id__|next|setPage|prevPage|for'.split('|'),0,{}))

//menu.js
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

//form.js
;(function($) {
	$.fn.ajaxSubmit = function(options) {
		if (!this.length) {
			log('ajaxSubmit: skipping submit process - no element selected');
			return this;
		}
		
		var method, action, url, $form = this;

		if (typeof options == 'function') {
			options = { success: options };
		}

		method = this.attr('method');
		action = this.attr('action');
		url = (typeof action === 'string') ? $.trim(action) : '';
		url = url || window.location.href || '';
		if (url) {
			url = (url.match(/^([^#]+)/)||[])[1];
		}

		options = $.extend(true, {
			url:  url,
			success: $.ajaxSettings.success,
			type: method || 'GET',
			iframeSrc: /^https/i.test(window.location.href || '') ? 'javascript:false' : 'about:blank'
		}, options);

		var veto = {};
		this.trigger('form-pre-serialize', [this, options, veto]);
		if (veto.veto) {
			log('ajaxSubmit: submit vetoed via form-pre-serialize trigger');
			return this;
		}

		if (options.beforeSerialize && options.beforeSerialize(this, options) === false) {
			log('ajaxSubmit: submit aborted via beforeSerialize callback');
			return this;
		}

	   var traditional = options.traditional;
	   if ( traditional === undefined ) {
	      traditional = $.ajaxSettings.traditional;
	   }
	   
		var qx,n,v,a = this.formToArray(options.semantic);
		if (options.data) {
			options.extraData = options.data;
	      qx = $.param(options.data, traditional);
		}

		// give pre-submit callback an opportunity to abort the submit
		if (options.beforeSubmit && options.beforeSubmit(a, this, options) === false) {
			log('ajaxSubmit: submit aborted via beforeSubmit callback');
			return this;
		}

		// fire vetoable 'validate' event
		this.trigger('form-submit-validate', [a, this, options, veto]);
		if (veto.veto) {
			log('ajaxSubmit: submit vetoed via form-submit-validate trigger');
			return this;
		}

		var q = $.param(a, traditional);
	   if (qx)
	      q = ( q ? (q + '&' + qx) : qx );

		if (options.type.toUpperCase() == 'GET') {
			options.url += (options.url.indexOf('?') >= 0 ? '&' : '?') + q;
			options.data = null;  // data is null for 'get'
		}
		else {
			options.data = q; // data is the query string for 'post'
		}

		var callbacks = [];
		if (options.resetForm) {
			callbacks.push(function() { $form.resetForm(); });
		}
		if (options.clearForm) {
			callbacks.push(function() { $form.clearForm(options.includeHidden); });
		}

		// perform a load on the target only if dataType is not provided
		if (!options.dataType && options.target) {
			var oldSuccess = options.success || function(){};
			callbacks.push(function(data) {
				var fn = options.replaceTarget ? 'replaceWith' : 'html';
				$(options.target)[fn](data).each(oldSuccess, arguments);
			});
		}
		else if (options.success) {
			callbacks.push(options.success);
		}

		options.success = function(data, status, xhr) { // jQuery 1.4+ passes xhr as 3rd arg
			var context = options.context || options;   // jQuery 1.4+ supports scope context 
			for (var i=0, max=callbacks.length; i < max; i++) {
				callbacks[i].apply(context, [data, status, xhr || $form, $form]);
			}
		};

		// are there files to upload?
		var fileInputs = $('input:file', this).length > 0;
		var mp = 'multipart/form-data';
		var multipart = ($form.attr('enctype') == mp || $form.attr('encoding') == mp);

		// options.iframe allows user to force iframe mode
		// 06-NOV-09: now defaulting to iframe mode if file input is detected
	   if (options.iframe !== false && (fileInputs || options.iframe || multipart)) {
		   // hack to fix Safari hang (thanks to Tim Molendijk for this)
		   // see:  http://groups.google.com/group/jquery-dev/browse_thread/thread/36395b7ab510dd5d
		   if (options.closeKeepAlive) {
			   $.get(options.closeKeepAlive, function() { fileUpload(a); });
			}
		   else {
			   fileUpload(a);
			}
	   }
	   else {
			// IE7 massage (see issue 57)
			if ($.browser.msie && method == 'get' && typeof options.type === "undefined") {
				var ieMeth = $form[0].getAttribute('method');
				if (typeof ieMeth === 'string')
					options.type = ieMeth;
			}
			$.ajax(options);
	   }

		// fire 'notify' event
		this.trigger('form-submit-notify', [this, options]);
		return this;


		// private function for handling file uploads (hat tip to YAHOO!)
		function fileUpload(a) {
			var form = $form[0], el, i, s, g, id, $io, io, xhr, sub, n, timedOut, timeoutHandle;
	        var useProp = !!$.fn.prop;

	        if (a) {
	            if ( useProp ) {
	            	// ensure that every serialized input is still enabled
	              	for (i=0; i < a.length; i++) {
	                    el = $(form[a[i].name]);
	                    el.prop('disabled', false);
	              	}
	            } else {
	              	for (i=0; i < a.length; i++) {
	                    el = $(form[a[i].name]);
	                    el.removeAttr('disabled');
	              	}
	            };
	        }

			if ($(':input[name=submit],:input[id=submit]', form).length) {
				// if there is an input with a name or id of 'submit' then we won't be
				// able to invoke the submit fn on the form (at least not x-browser)
				alert('Error: Form elements must not have name or id of "submit".');
				return;
			}
			
			s = $.extend(true, {}, $.ajaxSettings, options);
			s.context = s.context || s;
			id = 'jqFormIO' + (new Date().getTime());
			if (s.iframeTarget) {
				$io = $(s.iframeTarget);
				n = $io.attr('name');
				if (n == null)
				 	$io.attr('name', id);
				else
					id = n;
			}
			else {
				$io = $('<iframe name="' + id + '" src="'+ s.iframeSrc +'" />');
				$io.css({ position: 'absolute', top: '-1000px', left: '-1000px' });
			}
			io = $io[0];


			xhr = { // mock object
				aborted: 0,
				responseText: null,
				responseXML: null,
				status: 0,
				statusText: 'n/a',
				getAllResponseHeaders: function() {},
				getResponseHeader: function() {},
				setRequestHeader: function() {},
				abort: function(status) {
					var e = (status === 'timeout' ? 'timeout' : 'aborted');
					log('aborting upload... ' + e);
					this.aborted = 1;
					$io.attr('src', s.iframeSrc); // abort op in progress
					xhr.error = e;
					s.error && s.error.call(s.context, xhr, e, status);
					g && $.event.trigger("ajaxError", [xhr, s, e]);
					s.complete && s.complete.call(s.context, xhr, e);
				}
			};

			g = s.global;
			// trigger ajax global events so that activity/block indicators work like normal
			if (g && ! $.active++) {
				$.event.trigger("ajaxStart");
			}
			if (g) {
				$.event.trigger("ajaxSend", [xhr, s]);
			}

			if (s.beforeSend && s.beforeSend.call(s.context, xhr, s) === false) {
				if (s.global) {
					$.active--;
				}
				return;
			}
			if (xhr.aborted) {
				return;
			}

			// add submitting element to data if we know it
			sub = form.clk;
			if (sub) {
				n = sub.name;
				if (n && !sub.disabled) {
					s.extraData = s.extraData || {};
					s.extraData[n] = sub.value;
					if (sub.type == "image") {
						s.extraData[n+'.x'] = form.clk_x;
						s.extraData[n+'.y'] = form.clk_y;
					}
				}
			}
			
			var CLIENT_TIMEOUT_ABORT = 1;
			var SERVER_ABORT = 2;

			function getDoc(frame) {
				var doc = frame.contentWindow ? frame.contentWindow.document : frame.contentDocument ? frame.contentDocument : frame.document;
				return doc;
			}
			
			// take a breath so that pending repaints get some cpu time before the upload starts
			function doSubmit() {
				// make sure form attrs are set
				var t = $form.attr('target'), a = $form.attr('action');

				// update form attrs in IE friendly way
				form.setAttribute('target',id);
				if (!method) {
					form.setAttribute('method', 'POST');
				}
				if (a != s.url) {
					form.setAttribute('action', s.url);
				}

				// ie borks in some cases when setting encoding
				if (! s.skipEncodingOverride && (!method || /post/i.test(method))) {
					$form.attr({
						encoding: 'multipart/form-data',
						enctype:  'multipart/form-data'
					});
				}

				// support timout
				if (s.timeout) {
					timeoutHandle = setTimeout(function() { timedOut = true; cb(CLIENT_TIMEOUT_ABORT); }, s.timeout);
				}
				
				// look for server aborts
				function checkState() {
					try {
						var state = getDoc(io).readyState;
						log('state = ' + state);
						if (state.toLowerCase() == 'uninitialized')
							setTimeout(checkState,50);
					}
					catch(e) {
						log('Server abort: ' , e, ' (', e.name, ')');
						cb(SERVER_ABORT);
						timeoutHandle && clearTimeout(timeoutHandle);
						timeoutHandle = undefined;
					}
				}

				// add "extra" data to form if provided in options
				var extraInputs = [];
				try {
					if (s.extraData) {
						for (var n in s.extraData) {
							extraInputs.push(
								$('<input type="hidden" name="'+n+'" />').attr('value',s.extraData[n])
									.appendTo(form)[0]);
						}
					}

					if (!s.iframeTarget) {
						// add iframe to doc and submit the form
						$io.appendTo('body');
		                io.attachEvent ? io.attachEvent('onload', cb) : io.addEventListener('load', cb, false);
					}
					setTimeout(checkState,15);
					form.submit();
				}
				finally {
					// reset attrs and remove "extra" input elements
					form.setAttribute('action',a);
					if(t) {
						form.setAttribute('target', t);
					} else {
						$form.removeAttr('target');
					}
					$(extraInputs).remove();
				}
			}

			if (s.forceSync) {
				doSubmit();
			}
			else {
				setTimeout(doSubmit, 10); // this lets dom updates render
			}

			var data, doc, domCheckCount = 50, callbackProcessed;

			function cb(e) {
				if (xhr.aborted || callbackProcessed) {
					return;
				}
				try {
					doc = getDoc(io);
				}
				catch(ex) {
					log('cannot access response document: ', ex);
					e = SERVER_ABORT;
				}
				if (e === CLIENT_TIMEOUT_ABORT && xhr) {
					xhr.abort('timeout');
					return;
				}
				else if (e == SERVER_ABORT && xhr) {
					xhr.abort('server abort');
					return;
				}

				if (!doc || doc.location.href == s.iframeSrc) {
					// response not received yet
					if (!timedOut)
						return;
				}
	            io.detachEvent ? io.detachEvent('onload', cb) : io.removeEventListener('load', cb, false);

				var status = 'success', errMsg;
				try {
					if (timedOut) {
						throw 'timeout';
					}

					var isXml = s.dataType == 'xml' || doc.XMLDocument || $.isXMLDoc(doc);
					log('isXml='+isXml);
					if (!isXml && window.opera && (doc.body == null || doc.body.innerHTML == '')) {
						if (--domCheckCount) {
							// in some browsers (Opera) the iframe DOM is not always traversable when
							// the onload callback fires, so we loop a bit to accommodate
							log('requeing onLoad callback, DOM not available');
							setTimeout(cb, 250);
							return;
						}
						// let this fall through because server response could be an empty document
						//log('Could not access iframe DOM after mutiple tries.');
						//throw 'DOMException: not available';
					}

					//log('response detected');
	                var docRoot = doc.body ? doc.body : doc.documentElement;
	                xhr.responseText = docRoot ? docRoot.innerHTML : null;
					xhr.responseXML = doc.XMLDocument ? doc.XMLDocument : doc;
					if (isXml)
						s.dataType = 'xml';
					xhr.getResponseHeader = function(header){
						var headers = {'content-type': s.dataType};
						return headers[header];
					};
	                // support for XHR 'status' & 'statusText' emulation :
	                if (docRoot) {
	                    xhr.status = Number( docRoot.getAttribute('status') ) || xhr.status;
	                    xhr.statusText = docRoot.getAttribute('statusText') || xhr.statusText;
	                }

					var dt = (s.dataType || '').toLowerCase();
					var scr = /(json|script|text)/.test(dt);
					if (scr || s.textarea) {
						// see if user embedded response in textarea
						var ta = doc.getElementsByTagName('textarea')[0];
						if (ta) {
							xhr.responseText = ta.value;
	                        // support for XHR 'status' & 'statusText' emulation :
	                        xhr.status = Number( ta.getAttribute('status') ) || xhr.status;
	                        xhr.statusText = ta.getAttribute('statusText') || xhr.statusText;
						}
						else if (scr) {
							// account for browsers injecting pre around json response
							var pre = doc.getElementsByTagName('pre')[0];
							var b = doc.getElementsByTagName('body')[0];
							if (pre) {
								xhr.responseText = pre.textContent ? pre.textContent : pre.innerText;
							}
							else if (b) {
								xhr.responseText = b.textContent ? b.textContent : b.innerText;
							}
						}
					}
					else if (dt == 'xml' && !xhr.responseXML && xhr.responseText != null) {
						xhr.responseXML = toXml(xhr.responseText);
					}

	                try {
	                    data = httpData(xhr, dt, s);
	                }
	                catch (e) {
	                    status = 'parsererror';
	                    xhr.error = errMsg = (e || status);
	                }
				}
				catch (e) {
					log('error caught: ',e);
					status = 'error';
	                xhr.error = errMsg = (e || status);
				}

				if (xhr.aborted) {
					log('upload aborted');
					status = null;
				}

	            if (xhr.status) { // we've set xhr.status
	                status = (xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) ? 'success' : 'error';
	            }

				// ordering of these callbacks/triggers is odd, but that's how $.ajax does it
				if (status === 'success') {
					s.success && s.success.call(s.context, data, 'success', xhr);
					g && $.event.trigger("ajaxSuccess", [xhr, s]);
				}
	            else if (status) {
					if (errMsg == undefined)
						errMsg = xhr.statusText;
					s.error && s.error.call(s.context, xhr, status, errMsg);
					g && $.event.trigger("ajaxError", [xhr, s, errMsg]);
	            }

				g && $.event.trigger("ajaxComplete", [xhr, s]);

				if (g && ! --$.active) {
					$.event.trigger("ajaxStop");
				}

				s.complete && s.complete.call(s.context, xhr, status);

				callbackProcessed = true;
				if (s.timeout)
					clearTimeout(timeoutHandle);

				// clean up
				setTimeout(function() {
					if (!s.iframeTarget)
						$io.remove();
					xhr.responseXML = null;
				}, 100);
			}

			var toXml = $.parseXML || function(s, doc) { // use parseXML if available (jQuery 1.5+)
				if (window.ActiveXObject) {
					doc = new ActiveXObject('Microsoft.XMLDOM');
					doc.async = 'false';
					doc.loadXML(s);
				}
				else {
					doc = (new DOMParser()).parseFromString(s, 'text/xml');
				}
				return (doc && doc.documentElement && doc.documentElement.nodeName != 'parsererror') ? doc : null;
			};
			var parseJSON = $.parseJSON || function(s) {
				return window['eval']('(' + s + ')');
			};

			var httpData = function( xhr, type, s ) { // mostly lifted from jq1.4.4

				var ct = xhr.getResponseHeader('content-type') || '',
					xml = type === 'xml' || !type && ct.indexOf('xml') >= 0,
					data = xml ? xhr.responseXML : xhr.responseText;

				if (xml && data.documentElement.nodeName === 'parsererror') {
					$.error && $.error('parsererror');
				}
				if (s && s.dataFilter) {
					data = s.dataFilter(data, type);
				}
				if (typeof data === 'string') {
					if (type === 'json' || !type && ct.indexOf('json') >= 0) {
						data = parseJSON(data);
					} else if (type === "script" || !type && ct.indexOf("javascript") >= 0) {
						$.globalEval(data);
					}
				}
				return data;
			};
		}
	};

	/**
	 * ajaxForm() provides a mechanism for fully automating form submission.
	 *
	 * The advantages of using this method instead of ajaxSubmit() are:
	 *
	 * 1: This method will include coordinates for <input type="image" /> elements (if the element
	 *	is used to submit the form).
	 * 2. This method will include the submit element's name/value data (for the element that was
	 *	used to submit the form).
	 * 3. This method binds the submit() method to the form for you.
	 *
	 * The options argument for ajaxForm works exactly as it does for ajaxSubmit.  ajaxForm merely
	 * passes the options argument along after properly binding events for submit elements and
	 * the form itself.
	 */
	$.fn.ajaxForm = function(options) {
		// in jQuery 1.3+ we can fix mistakes with the ready state
		if (this.length === 0) {
			var o = { s: this.selector, c: this.context };
			if (!$.isReady && o.s) {
				log('DOM not ready, queuing ajaxForm');
				$(function() {
					$(o.s,o.c).ajaxForm(options);
				});
				return this;
			}
			// is your DOM ready?  http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
			log('terminating; zero elements found by selector' + ($.isReady ? '' : ' (DOM not ready)'));
			return this;
		}

		return this.ajaxFormUnbind().bind('submit.form-plugin', function(e) {
			if (!e.isDefaultPrevented()) { // if event has been canceled, don't proceed
				e.preventDefault();
				$(this).ajaxSubmit(options);
			}
		}).bind('click.form-plugin', function(e) {
			var target = e.target;
			var $el = $(target);
			if (!($el.is(":submit,input:image"))) {
				// is this a child element of the submit el?  (ex: a span within a button)
				var t = $el.closest(':submit');
				if (t.length == 0) {
					return;
				}
				target = t[0];
			}
			var form = this;
			form.clk = target;
			if (target.type == 'image') {
				if (e.offsetX != undefined) {
					form.clk_x = e.offsetX;
					form.clk_y = e.offsetY;
				} else if (typeof $.fn.offset == 'function') { // try to use dimensions plugin
					var offset = $el.offset();
					form.clk_x = e.pageX - offset.left;
					form.clk_y = e.pageY - offset.top;
				} else {
					form.clk_x = e.pageX - target.offsetLeft;
					form.clk_y = e.pageY - target.offsetTop;
				}
			}
			// clear form vars
			setTimeout(function() { form.clk = form.clk_x = form.clk_y = null; }, 100);
		});
	};

	// ajaxFormUnbind unbinds the event handlers that were bound by ajaxForm
	$.fn.ajaxFormUnbind = function() {
		return this.unbind('submit.form-plugin click.form-plugin');
	};

	/**
	 * formToArray() gathers form element data into an array of objects that can
	 * be passed to any of the following ajax functions: $.get, $.post, or load.
	 * Each object in the array has both a 'name' and 'value' property.  An example of
	 * an array for a simple login form might be:
	 *
	 * [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
	 *
	 * It is this array that is passed to pre-submit callback functions provided to the
	 * ajaxSubmit() and ajaxForm() methods.
	 */
	$.fn.formToArray = function(semantic) {
		var a = [];
		if (this.length === 0) {
			return a;
		}

		var form = this[0];
		var els = semantic ? form.getElementsByTagName('*') : form.elements;
		if (!els) {
			return a;
		}

		var i,j,n,v,el,max,jmax;
		for(i=0, max=els.length; i < max; i++) {
			el = els[i];
			n = el.name;
			if (!n) {
				continue;
			}

			if (semantic && form.clk && el.type == "image") {
				// handle image inputs on the fly when semantic == true
				if(!el.disabled && form.clk == el) {
					a.push({name: n, value: $(el).val()});
					a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
				}
				continue;
			}

			v = $.fieldValue(el, true);
			if (v && v.constructor == Array) {
				for(j=0, jmax=v.length; j < jmax; j++) {
					a.push({name: n, value: v[j]});
				}
			}
			else if (v !== null && typeof v != 'undefined') {
				a.push({name: n, value: v});
			}
		}

		if (!semantic && form.clk) {
			// input type=='image' are not found in elements array! handle it here
			var $input = $(form.clk), input = $input[0];
			n = input.name;
			if (n && !input.disabled && input.type == 'image') {
				a.push({name: n, value: $input.val()});
				a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
			}
		}
		return a;
	};

	$.fn.formToJsonStr = function(semantic) {
		var a = '{';
		if (this.length === 0) {
			return a;
		}

		var form = this[0];
		var els = semantic ? form.getElementsByTagName('*') : form.elements;
		if (!els) {
			return a;
		}

		var i,j,n,v,el,max,jmax;
		for(i=0, max=els.length; i < max; i++) {
			el = els[i];
			n = el.name;
			if (!n) {
				continue;
			}
			if (semantic && form.clk && el.type == "image") {
				// handle image inputs on the fly when semantic == true
				if(!el.disabled && form.clk == el) {
					a =a + '"' + n + '":"' + '"' + $(el).val().toValidJson() + '"' + ',';
					a =a + '"' + n+'.x' + '":"' + form.clk_x.toValidJson() + '"' + ',';
					a =a + '"' + n+'.y' + '":"' + form.clk_y.toValidJson() + '"' + ',';
				}
				continue;
			}

			v = $.fieldValue(el, true);
			if (v && v.constructor == Array) {
				for(j=0, jmax=v.length; j < jmax; j++) {
					a =a + '"' + n + '":"' + v[j].toValidJson() + '"' + ',';
				}
			}
			else if (v !== null && typeof v != 'undefined') {
				a =a + '"' + n + '":"'+ v.toValidJson() + '"' + ',';
			}
		}

		if (!semantic && form.clk) {
			// input type=='image' are not found in elements array! handle it here
			var $input = $(form.clk), input = $input[0];
			n = input.name;
			if (n && !input.disabled && input.type == 'image') {
				a =a + '"' + n + '":"' + $input.val().toValidJson() + '"' + ',';
				a =a + '"' + n+'.x' + '":"' + form.clk_x.toValidJson() + '"' + ',';
				a =a + '"' + n+'.y' + '":"' + form.clk_y.toValidJson() + '"' + ',';
			}
		}
		if(a.endWith(","))
		{
			a = a.substring(0,a.length-1);
		}
		a = a+'}';
		
		return a;
	};

	/**
	 * Serializes form data into a 'submittable' string. This method will return a string
	 * in the format: name1=value1&amp;name2=value2
	 */
	$.fn.formSerialize = function(semantic) {
		//hand off to jQuery.param for proper encoding
		return $.param(this.formToArray(semantic));
	};

	/**
	 * Serializes all field elements in the jQuery object into a query string.
	 * This method will return a string in the format: name1=value1&amp;name2=value2
	 */
	$.fn.fieldSerialize = function(successful) {
		var a = [];
		this.each(function() {
			var n = this.name;
			if (!n) {
				return;
			}
			var v = $.fieldValue(this, successful);
			if (v && v.constructor == Array) {
				for (var i=0,max=v.length; i < max; i++) {
					a.push({name: n, value: v[i]});
				}
			}
			else if (v !== null && typeof v != 'undefined') {
				a.push({name: this.name, value: v});
			}
		});
		//hand off to jQuery.param for proper encoding
		return $.param(a);
	};

	/**
	 * Returns the value(s) of the element in the matched set.  For example, consider the following form:
	 *
	 *  <form><fieldset>
	 *	  <input name="A" type="text" />
	 *	  <input name="A" type="text" />
	 *	  <input name="B" type="checkbox" value="B1" />
	 *	  <input name="B" type="checkbox" value="B2"/>
	 *	  <input name="C" type="radio" value="C1" />
	 *	  <input name="C" type="radio" value="C2" />
	 *  </fieldset></form>
	 *
	 *  var v = $(':text').fieldValue();
	 *  // if no values are entered into the text inputs
	 *  v == ['','']
	 *  // if values entered into the text inputs are 'foo' and 'bar'
	 *  v == ['foo','bar']
	 *
	 *  var v = $(':checkbox').fieldValue();
	 *  // if neither checkbox is checked
	 *  v === undefined
	 *  // if both checkboxes are checked
	 *  v == ['B1', 'B2']
	 *
	 *  var v = $(':radio').fieldValue();
	 *  // if neither radio is checked
	 *  v === undefined
	 *  // if first radio is checked
	 *  v == ['C1']
	 *
	 * The successful argument controls whether or not the field element must be 'successful'
	 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
	 * The default value of the successful argument is true.  If this value is false the value(s)
	 * for each element is returned.
	 *
	 * Note: This method *always* returns an array.  If no valid value can be determined the
	 *	   array will be empty, otherwise it will contain one or more values.
	 */
	$.fn.fieldValue = function(successful) {
		for (var val=[], i=0, max=this.length; i < max; i++) {
			var el = this[i];
			var v = $.fieldValue(el, successful);
			if (v === null || typeof v == 'undefined' || (v.constructor == Array && !v.length)) {
				continue;
			}
			v.constructor == Array ? $.merge(val, v) : val.push(v);
		}
		return val;
	};

	/**
	 * Returns the value of the field element.
	 */
	$.fieldValue = function(el, successful) {
		var n = el.name, t = el.type, tag = el.tagName.toLowerCase();
		if (successful === undefined) {
			successful = true;
		}

		if (successful && (!n || el.disabled || t == 'reset' || t == 'button' ||
			(t == 'checkbox' || t == 'radio') && !el.checked ||
			(t == 'submit' || t == 'image') && el.form && el.form.clk != el ||
			tag == 'select' && el.selectedIndex == -1)) {
				return null;
		}

		if (tag == 'select') {
			var index = el.selectedIndex;
			if (index < 0) {
				return null;
			}
			var a = [], ops = el.options;
			var one = (t == 'select-one');
			var max = (one ? index+1 : ops.length);
			for(var i=(one ? index : 0); i < max; i++) {
				var op = ops[i];
				if (op.selected) {
					var v = op.value;
					if (!v) { // extra pain for IE...
						v = (op.attributes && op.attributes['value'] && !(op.attributes['value'].specified)) ? op.text : op.value;
					}
					if (one) {
						return v;
					}
					a.push(v);
				}
			}
			return a;
		}
		return $(el).val();
	};

	/**
	 * Clears the form data.  Takes the following actions on the form's input fields:
	 *  - input text fields will have their 'value' property set to the empty string
	 *  - select elements will have their 'selectedIndex' property set to -1
	 *  - checkbox and radio inputs will have their 'checked' property set to false
	 *  - inputs of type submit, button, reset, and hidden will *not* be effected
	 *  - button elements will *not* be effected
	 */
	$.fn.clearForm = function(includeHidden) {
		return this.each(function() {
			$('input,select,textarea', this).clearFields(includeHidden);
		});
	};

	/**
	 * Clears the selected form elements.
	 */
	$.fn.clearFields = $.fn.clearInputs = function(includeHidden) {
		var re = /^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i; // 'hidden' is not in this list
		return this.each(function() {
			var t = this.type, tag = this.tagName.toLowerCase();
			if (re.test(t) || tag == 'textarea' || (includeHidden && /hidden/.test(t)) ) {
				this.value = '';
			}
			else if (t == 'checkbox' || t == 'radio') {
				this.checked = false;
			}
			else if (tag == 'select') {
				this.selectedIndex = -1;
			}
		});
	};

	/**
	 * Resets the form data.  Causes all form elements to be reset to their original value.
	 */
	$.fn.resetForm = function() {
		return this.each(function() {
			// guard against an input with the name of 'reset'
			// note that IE reports the reset function as an 'object'
			if (typeof this.reset == 'function' || (typeof this.reset == 'object' && !this.reset.nodeType)) {
				this.reset();
			}
		});
	};

	/**
	 * Enables or disables any matching elements.
	 */
	$.fn.enable = function(b) {
		if (b === undefined) {
			b = true;
		}
		return this.each(function() {
			this.disabled = !b;
		});
	};

	/**
	 * Checks/unchecks any matching checkboxes or radio buttons and
	 * selects/deselects and matching option elements.
	 */
	$.fn.selected = function(select) {
		if (select === undefined) {
			select = true;
		}
		return this.each(function() {
			var t = this.type;
			if (t == 'checkbox' || t == 'radio') {
				this.checked = select;
			}
			else if (this.tagName.toLowerCase() == 'option') {
				var $sel = $(this).parent('select');
				if (select && $sel[0] && $sel[0].type == 'select-one') {
					// deselect all other options
					$sel.find('option').selected(false);
				}
				this.selected = select;
			}
		});
	};

	// expose debug var
	$.fn.ajaxSubmit.debug = false;

	// helper fn for console logging
	function log() {
		if (!$.fn.ajaxSubmit.debug) 
			return;
		var msg = '[jquery.form] ' + Array.prototype.join.call(arguments,'');
		if (window.console && window.console.log) {
			window.console.log(msg);
		}
		else if (window.opera && window.opera.postError) {
			window.opera.postError(msg);
		}
	};

	})(jQuery);


//update.js
;(function($) {
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

//window.js
/**
 * weebox.js
 * @category   javascript
 * @package    jquery
 * @author     Jack <xiejinci@gmail.com>
 * @version    
 */ 
(function($) {
	var cachedata = {};
	var arrweebox = new Array();
	var weebox = function(content,options) {
		var self 		= this;
		this.dh 		= null;
		this.mh 		= null;
		this.dc			= null;
		this.dt			= null;
		this.db			= null;
		this.selector 	= null;	
		this.ajaxurl 	= null;
		this.options 	= null;
		this._dragging 	= false;
		this._content 	= content || '';
		this._options 	= options || {};
		this._defaults 	= {
			boxid: null,
			boxclass: null,
			cache: false,
			type: 'dialog',
			title: '',
			width: 0,
			height: 0,
			timeout: 0, 
			draggable: true,
			modal: true,
			focus: null,
			blur: null,
			position: 'center',
			overlay: 30,
			showTitle: true,
			showButton: true,
			showCancel: true, 
			showOk: true,
			okBtnName: '确定',
			cancelBtnName: '取消',
			contentType: 'text',
			contentChange: false,
			clickClose: false,
			zIndex: 999,
			animate: '',
			showAnimate:'',
			hideAnimate:'',
			onclose: null,
			onopen: null,
			oncancel: null,
			onok: null,
			suggest:{url:'',tele:'',vele:'',fn:null},
			select:{url:'',type:'radio', tele:'',vele:'',width:120,search:false,fn:null}
		};
		//初始化选项
		this.initOptions = function() {
			self._options = self._options || {};
			self._options.animate = self._options.animate || '';
			self._options.showAnimate = self._options.showAnimate || self._options.animate;
			self._options.hideAnimate = self._options.hideAnimate || self._options.animate;
			self._options.type = self._options.type || 'dialog';
			self._options.title = self._options.title || '';
			self._options.boxclass = self._options.boxclass || 'wee'+self._options.type;
			self._options.contentType = self._options.contentType || "";
			if (self._options.contentType == "") {
				self._options.contentType = (self._content.substr(0,1) == '#') ? 'selector' : 'text';
			}
			self.options  = $.extend({}, self._defaults, self._options);
			self._options = null;
			self._defaults = null;
		};
		//初始化弹窗Box
		this.initBox = function() {
			var html = '';
			switch(self.options.type) {
				case 'alert':
				case 'select':
				case 'dialog':
				html =  '<div class="weedialog">' +
						'	<div class="dialog-header">' +
						'		<div class="dialog-tl"></div>' +
						'		<div class="dialog-tc">' +
						'			<div class="dialog-tc1"></div>' +
						'			<div class="dialog-tc2"><a href="javascript:;" onclick="return false" title="关闭" class="dialog-close"></a><span class="dialog-title"></span></div>' +
						'		</div>' +
						'		<div class="dialog-tr"></div>' +
						'	</div>' +
						'	<table width="100%" border="0" cellspacing="0" cellpadding="0" >' +
						'		<tr>' +
						'			<td class="dialog-cl"></td>' +
						'			<td>' +
						'				<div class="dialog-content"></div>' +
						'				<div class="dialog-button">' +
						'					<input type="button" class="dialog-ok" value="确定">' +
						'					<input type="button" class="dialog-cancel" value="取消">' +
						'				</div>' +
						'			</td>' +
						'			<td class="dialog-cr"></td>' +
						'		</tr>' +
						'	</table>' +
						'	<div class="dialog-bot">' +
						'		<div class="dialog-bl"></div>' +
						'		<div class="dialog-bc"></div>' +
						'		<div class="dialog-br"></div>' +
						'	</div>' +
						'</div>';
						break;
				case 'custom':
				case 'suggest':
				html = '<div><div class="dialog-content"></div></div>';
						break;
			}
			self.dh = $(html).appendTo('body').hide().css({
				position: 'absolute',	
				overflow: 'hidden',
				zIndex: self.options.zIndex
			});
			self.dc = self.find('.dialog-content');
			self.dt = self.find('.dialog-title');
			self.db = self.find('.dialog-button');
			if (self.options.boxid) {
				self.dh.attr('id', self.options.boxid);
			}	
			if (self.options.boxclass) {
				self.dh.addClass(self.options.boxclass);
			}
			if (self.options.height>0) {
				self.dc.css('height', self.options.height);
			}
			if (self.options.width>0) {
				self.dh.css('width', self.options.width);
			}
			self.dh.bgiframe();
		}
		//初始化遮照
		this.initMask = function() {
			if (self.options.modal) {
				if ($.browser.msie) {
                    h= document.compatMode == "CSS1Compat" ? document.documentElement.clientHeight : document.body.clientHeight;
                    w= document.compatMode == "CSS1Compat" ? document.documentElement.clientWidth : document.body.clientWidth;
                } else {
                    h= self.bheight();
                    w= self.bwidth();
                }
				self.mh = $("<div class='dialog-mask'></div>")
				.appendTo('body').hide().css({
					width: w,
					height: h,
					zIndex: self.options.zIndex-1
				}).bgiframe();
			}
		}
		//初始化弹窗内容
		this.initContent = function(content) {
			self.dh.find(".dialog-ok").val(self.options.okBtnName);
			self.dh.find(".dialog-cancel").val(self.options.cancelBtnName);	
			if (self.options.title == '') {
				//self.dt.hide();	
				//self.dt.html(self._titles[self._options.type] || '');
			} else {
				self.dt.html(self.options.title);
			}
			if (!self.options.showTitle) {
				self.dt.hide();
			}	
			if (!self.options.showButton) {
				self.dh.find('.dialog-button').hide();
			}
			if (!self.options.showCancel) {
				self.dh.find('.dialog-cancel').hide();
			}							
			if (!self.options.showOk) {
				self.dh.find(".dialog-ok").hide();
			}
			if (self.options.type == 'suggest') {//例外处理
				self.hide();
				//self.options.clickClose = true;
				$(self.options.suggest.tele).unbind('keyup').keyup(function(){
					var val = $.trim(this.value);
					var data = null;
					for(key in cachedata) {
						if (key == val) {
							data = cachedata[key];
						}
					}
					if (data === null) {
						$.ajax({
							type: "GET",
							data:{q:val},
						  	url: self.options.suggest.url || self._content,
						  	success: function(res){data = res;},
						  	dataType:'json',
						  	async: false				  	
						});
					}
					cachedata[val] = data;
					var html = '';
					for(key in data) {
						html += '<li>'+data[key].name+'</li>';
					}
					self.setContent(html);
					self.show();
					self.find('li').click(function(){
						var i = self.find('li').index(this);
						$(self.options.suggest.tele).val(data[i].name);
						$(self.options.suggest.vele).val(data[i].id);
						if (typeof self.options.suggest.fn == 'function') {
							fn(data[i]);
						}
						self.hide();
					});
				});
			} else if(self.options.type == 'select') {
				var type = self.options.select.type || 'radio';
				var url = self.options.select.url || self._content || '';
				var search = self.options.select.search || false;
				$.ajax({
					type: "GET",
				  	url: url,
				  	success: function(data){
						var html = '';
						if (data === null) {
							html = '没有数据';
						} else {
							if (search) {
								html += '<div class="wsearch"><input type="text"><input type="button" value="查询"></div>';
							}
							var ovals = $.trim($(self.options.select.vele).val()).split(',');//原值
							html += '<div class="wselect">';
							for(key in data) {
								var checked = ($.inArray(data[key].id, ovals)==-1)?'':'checked="checked"'; 
								html += '<li><label><input name="wchoose" '+checked+' type="'+type+'" value="'+data[key].id+'">'+data[key].name+'</label></li>';
							}
							html += '</div>';
						}
						self.setContent(html);
						self.find('li').width(self.options.select.width);
						self.find('.wsearch input').keyup(function(){
							var v = $.trim(this.value);
							self.find('li').hide();
							for(i in data) {
								if (data[i].id==v || data[i].name.indexOf(v)!=-1) {
									self.find('li:eq('+i+')').show();
								}
							}
						});
						self.setOnok(function(){
							if (type=='radio') {
								if (self.find(':checked').length == 0) {
									$(self.options.select.tele).val('');
									$(self.options.select.vele).val('');
								} else {
									var i = self.find(':radio[name=wchoose]').index(self.find(':checked')[0]);
									$(self.options.select.tele).val(data[i].name);
									$(self.options.select.vele).val(data[i].id);
									if (typeof self.options.select.fn == 'function') fn(data[i]);
								}
							} else {
								if (self.find(':checked').length == 0) {
									$(self.options.select.tele).val('');
									$(self.options.select.vele).val('');
								} else {
									var temps=[],ids=[],names=[];
									self.find(':checked').each(function(){
										var i = self.find(':checkbox[name=wchoose]').index(this);
										temps.push(data[i]);
										ids.push(data[i].id);
										names.push(data[i].name);
									});
									$(self.options.select.tele).val(names.join(","));
									$(self.options.select.vele).val(ids.join(","));
									if (typeof self.options.select.fn == 'function') fn(temps);
								}
							}
							self.close();
						});
						self.show();
					},
				  	dataType:'json'
				});
			} else {				
				if (self.options.contentType == "selector") {
					self.selector = self._content;
					self._content = $(self.selector).html();
					self.setContent(self._content);
					//if have checkbox do
					var cs = $(self.selector).find(':checkbox');
					self.dc.find(':checkbox').each(function(i){
						this.checked = cs[i].checked;
					});
					$(self.selector).empty();
					self.show();
					self.focus();
					self.onopen();
				} else if (self.options.contentType == "ajax") {	
					self.ajaxurl = self._content;	
					self.setLoading();				
					self.show();
					self.dh.find(".dialog-button").hide();
					if (self.options.cache == false) {
						if (self.ajaxurl.indexOf('?') == -1) {
							self.ajaxurl += "?_t="+Math.random();
						} else {
							self.ajaxurl += "&_t="+Math.random();
						}
					}
					$.get(self.ajaxurl, function(data) {
						self._content = data;
				    	self.setContent(self._content);
				    	self.show();
						self.focus();
				    	self.onopen();
					});
				} else if (self.options.contentType == "iframe") { /*加入iframe使程序可以直接引用其它页面 by ePim*/
					var html = '<style type="text/css">';
					html += ('\n.dialog-box .dialog-content{padding:0px;}');
					html += ('\n</style>');
					html += ('<iframe class="dialogIframe" src="'+self._content+'" width="100%" height="100%" frameborder="0"></iframe>');
					self.setContent(html);
					self.onopen();
					self.show();
				} else {
					self.setContent(self._content);	
					self.show();
					self.focus();
					self.onopen();
				}
			}
		}
		//初始化弹窗事件
		this.initEvent = function() {
			self.dh.find(".dialog-close, .dialog-cancel, .dialog-ok").unbind('click').click(function(){self.close()});			
			if (typeof(self.options.onok) == "function") {
				self.dh.find(".dialog-ok").unbind('click').click(function(){self.options.onok(self)});
			} 
			if (typeof(self.options.oncancel) == "function") {
				self.dh.find(".dialog-cancel").unbind('click').click(function(){self.options.oncancel(self)});
			}	
			if (self.options.timeout>0) {
				window.setTimeout(self.close, (self.options.timeout * 1000));
			}			
			this.drag();			
		}
		//设置onok事件
		this.setOnok = function(fn) {
			self.dh.find(".dialog-ok").unbind('click');
			if (typeof(fn)=="function")	self.dh.find(".dialog-ok").click(function(){fn(self)});
		}
		//设置onOncancel事件
		this.setOncancel = function(fn) {
			self.dh.find(".dialog-cancel").unbind('click');
			if (typeof(fn)=="function")	self.dh.find(".dialog-cancel").click(function(){fn(self)});
		}
		//设置onOnclose事件
		this.setOnclose = function(fn) {
			self.options.onclose = fn;
		}
		//弹窗拖拽
		this.drag = function() {		
			if (self.options.draggable && self.options.showTitle) {
				self.dh.find('.dialog-header').mousedown(function(event){
					var h  = this; 
					var o  = document;
					var ox = self.dh.position().left;
					var oy = self.dh.position().top;
					var mx = event.clientX;
					var my = event.clientY;
					var width = self.dh.width();
					var height = self.dh.height();
					var bwidth = self.bwidth();
					var bheight = self.bheight(); 
			        if(h.setCapture) {
			            h.setCapture();
			        }
					$(document).mousemove(function(event){						
						if (window.getSelection) {
							window.getSelection().removeAllRanges();
						} else { 
				        	document.selection.empty();
				        }
						//TODO
						var left = Math.max(ox+event.clientX-mx, 0);
						var top = Math.max(oy+event.clientY-my, 0);
						var left = Math.min(left, bwidth-width);
						var top = Math.min(top, bheight-height);
						self.dh.css({left: left, top: top});
					}).mouseup(function(){
						if(h.releaseCapture) { 
			                h.releaseCapture();
			            }
				        $(document).unbind('mousemove');
				        $(document).unbind('mouseup');
					});
				});			
			}	
		}
		//打开前的回弹函数
		this.onopen = function() {							
			if (typeof(self.options.onopen) == "function") {
				self.options.onopen(self);
			}	
		}
		//增加一个按钮
		this.addButton = function(opt) {
			opt = opt || {};
			opt.title = opt.title || 'OK';
			opt.bclass = opt.bclass || 'dialog-btn1';
			opt.fn = opt.fn || null;
			opt.index = opt.index || 0;
			var btn = $('<input type="button" class="'+opt.bclass+'" value="'+opt.title+'">').click(function(){
				if (typeof opt.fn == "function") opt.fn(self);
			});
			if (opt.index < self.db.find('input').length) {
				self.db.find('input:eq('+opt.index+')').before(btn);
			} else {
				self.db.append(opt);
			}			
		}
		//显示弹窗
		this.show = function() {
			if (self.options.showButton) {
				self.dh.find('.dialog-button').show();
			}
			if (self.options.position == 'center') {
				self.setCenterPosition();
			} else {
				self.setElementPosition();
			}
			if (typeof self.options.showAnimate == "string") {
				self.dh.show(self.options.animate);
			} else {
				self.dh.animate(self.options.showAnimate.animate, self.options.showAnimate.speed);
			}
			if (self.mh) {
				self.mh.show();
			}
		}
		this.hide = function(fn) {
			if (typeof self.options.hideAnimate == "string") {
				self.dh.hide(self.options.animate, fn);
			} else {
				self.dh.animate(self.options.hideAnimate.animate, self.options.hideAnimate.speed, "", fn);
			}
		}
		//设置弹窗焦点
		this.focus = function() {
			if (self.options.focus) {
				self.dh.find(self.options.focus).focus();//TODO IE中要两次
				self.dh.find(self.options.focus).focus();
			} else {
				self.dh.find('.dialog-cancel').focus();
			}
		}
		//在弹窗内查找元素
		this.find = function(selector) {
			return self.dh.find(selector);
		}
		//设置加载加状态
		this.setLoading = function() {			
			self.setContent('<div class="dialog-loading"></div>');
			self.dh.find(".dialog-button").hide();
			if (self.dc.height()<90) {				
				self.dc.height(Math.max(90, self.options.height));
			}
			if (self.dh.width()<200) {
				self.dh.width(Math.max(200, self.options.width));
			}
		}
		this.setWidth = function(width) {
			self.dh.width(width);
		}
		//设置标题
		this.setTitle = function(title) {
			self.dt.html(title);
		}
		//取得标题
		this.getTitle = function() {
			return self.dt.html();
		}
		//设置内容
		this.setContent = function(content) {
			self.dc.html(content);
			if (self.options.height>0) {
				self.dc.css('height', self.options.height);
			} else {
				self.dc.css('height','');
			}
			if (self.options.width>0) {
				self.dh.css('width', self.options.width);
			} else {
				self.dh.css('width','');
			}
			if (self.options.showButton) {
				self.dh.find(".dialog-button").show();
			}
		}
		//取得内容
		this.getContent = function() {
			return self.dc.html();
		}	
		//使能按钮
		this.disabledButton = function(btname, state) {
			self.dh.find('.dialog-'+btname).attr("disabled", state);
		}
		//隐藏按钮
		this.hideButton = function(btname) {
			self.dh.find('.dialog-'+btname).hide();			
		}
		//显示按钮
		this.showButton = function(btname) {
			self.dh.find('.dialog-'+btname).show();	
		}
		//设置按钮标题
		this.setButtonTitle = function(btname, title) {
			self.dh.find('.dialog-'+btname).val(title);	
		}
		//操作完成
		this.next = function(opt) {
			opt = opt || {};
			opt.title = opt.title || self.getTitle();
			opt.content = opt.content || "";
			opt.okname = opt.okname || "确定";
			opt.width = opt.width || 260;
			opt.onok = opt.onok || self.close;
			opt.onclose = opt.onclose || null;
			opt.oncancel = opt.oncancel || null;
			opt.hideCancel = opt.hideCancel || true;
			self.setTitle(opt.title);
			self.setButtonTitle("ok", okname);
			self.setWidth(width);
			self.setOnok(opt.onok);
			if (opt.content != "") self.setContent(opt.content);
			if (opt.hideCancel)	self.hideButton("cancel");
			if (typeof(opt.onclose) == "function") self.setOnclose(opt.onclose);
			if (typeof(opt.oncancel) == "function") self.setOncancel(opt.oncancel);
			self.show();
		}
		//关闭弹窗
		this.close = function(n) {
			if (typeof(self.options.onclose) == "function") {
				self.options.onclose(self);
			}
			if (self.options.contentType == 'selector') {
				if (self.options.contentChange) {
					//if have checkbox do
					var cs = self.find(':checkbox');
					$(self.selector).html(self.getContent());						
					if (cs.length > 0) {
						$(self.selector).find(':checkbox').each(function(i){
							this.checked = cs[i].checked;
						});
					}
				} else {
					$(self.selector).html(self._content);
				}
			} else if(self.options.contentType == "iframe") {
				var iframe = self.dh.find(".dialogIframe");
				iframe.removeAttr("src");
			}
			//设置关闭后的焦点
			if (self.options.blur) {
				$(self.options.blur).focus();
			}
			//从数组中删除
			for(i=0;i<arrweebox.length;i++) {
				if (arrweebox[i].dh.get(0) == self.dh.get(0)) {
					arrweebox.splice(i, 1);
					break;
				}
			}
			self.hide();
			self.dh.remove();
			if (self.mh) {
				self.mh.remove();
			}
		}
		//取得遮照高度
		this.bheight = function() {
			if ($.browser.msie && $.browser.version < 7) {
				var scrollHeight = Math.max(
					document.documentElement.scrollHeight,
					document.body.scrollHeight
				);
				var offsetHeight = Math.max(
					document.documentElement.offsetHeight,
					document.body.offsetHeight
				);
				
				if (scrollHeight < offsetHeight) {
					return $(window).height();
				} else {
					return scrollHeight;
				}
			} else {
				return $(document).height();
			}
		}
		//取得遮照宽度
		this.bwidth = function() {
			if ($.browser.msie && $.browser.version < 7) {
				var scrollWidth = Math.max(
					document.documentElement.scrollWidth,
					document.body.scrollWidth
				);
				var offsetWidth = Math.max(
					document.documentElement.offsetWidth,
					document.body.offsetWidth
				);
				
				if (scrollWidth < offsetWidth) {
					return $(window).width();
				} else {
					return scrollWidth;
				}
			} else {
				return $(document).width();
			}
		}
		//将弹窗显示在中间位置
		this.setCenterPosition = function() {
			var wnd = $(window), doc = $(document),
				pTop = doc.scrollTop(),	pLeft = doc.scrollLeft();
			pTop += (wnd.height() - self.dh.height()) / 2;
			pLeft += (wnd.width() - self.dh.width()) / 2;
			self.dh.css({top: pTop, left: pLeft});
		}
		//根据元素设置弹窗显示位置
		this.setElementPosition = function() {
			var trigger = $(self.options.position.refele);
			var reftop = self.options.position.reftop || 0;
			var refleft = self.options.position.refleft || 0;
			var adjust = (typeof self.options.position.adjust=="undefined")?true:self.options.position.adjust;
			var top = trigger.offset().top + trigger.height();
			var left = trigger.offset().left;
			var docWidth = document.documentElement.clientWidth || document.body.clientWidth;
			var docHeight = document.documentElement.clientHeight|| document.body.clientHeight;
			var docTop = document.documentElement.scrollTop|| document.body.scrollTop;
			var docLeft = document.documentElement.scrollLeft|| document.body.scrollLeft;
			var docBottom = docTop + docHeight;
			var docRight = docLeft + docWidth;
			if (adjust && left + self.dh.width() > docRight) {
				left = docRight - self.dh.width() - 1;
			}
			if (adjust && top + self.dh.height() > docBottom) {
				top = docBottom - self.dh.height() - 1;
			}
			left = Math.max(left+refleft, 0);
			top = Math.max(top+reftop, 0);
			self.dh.css({top: top, left: left});
		}
		this.initOptions();
		this.initMask();
		this.initBox();		
		this.initContent();
		this.initEvent();
	}	
	
	var weeboxs = function() {		
		var self = this;
		this._onbox = false;
		this._opening = false;
		this.zIndex = 999;
		this.length = function() {
			return arrweebox.length;
		}
		this.open = function(content, options) {
			self._opening = true;
			if (typeof(options) == "undefined") {
				options = {};
			}
			if (options.boxid) {
				for(var i=0; i<arrweebox.length; i++) {
					if (arrweebox[i].dh.attr('id') == options.boxid) {
						arrweebox[i].close();
						break;
					}
				}
			}
			options.zIndex = self.zIndex;
			self.zIndex += 10;
			var box = new weebox(content, options);
			box.dh.click(function(){self._onbox = true;});
			arrweebox.push(box);
			/*-----解决在ie下页面过大时出现部分阴影没有覆盖的问题-----by ePim*/
			if (box.options.position != "center"){
				box.setElementPosition();
			}
			if (box.mh) {
				box.mh.css({
					width: box.bwidth(),
					height: box.bheight()
				});
			}
			/*-----解决在ie下页面过大时出现部分没有遮罩的问题-----by ePim(WanJiDong@gmail.com)*/
			return box;
		}
		//关闭最上层窗体,程序调用方法：jQuery.weeboxs.close();
		this.close = function(){
			var closingBox = this.getTopBox();
			if(false!=closingBox) {
				closingBox.close();
			}
		}
		this.getTopBox = function() {
			if (arrweebox.length>0) {
				return arrweebox[arrweebox.length-1];
			} else {
				return false;
			}
		}
		$(window).scroll(function() {
			if (arrweebox.length > 0) {
				for(i=0;i<arrweebox.length;i++) {
					var box = arrweebox[i];//self.getTopBox();
					/*if (box.options.position == "center") {
						box.setCenterPosition();
					}*/
					if (box.options.position != "center"){
						box.setElementPosition();
					}
					if (box.mh) {
						box.mh.css({
							width: box.bwidth(),
							height: box.bheight()
						});
					}
				}
			}		
		}).resize(function() {
			if (arrweebox.length > 0) {
				var box = self.getTopBox();
				if (box.options.position == "center") {
					box.setCenterPosition();
				}
				if (box.mh) {
					box.mh.css({
						width: box.bwidth(),
						height: box.bheight()
					});
				}
			}
		});
		$(document).click(function(event) {
			if (event.button==2) return true;
			if (arrweebox.length>0) {
				var box = self.getTopBox();
				if(!self._opening && !self._onbox && box.options.clickClose) {
					box.close();
				}
			}
			self._opening = false;
			self._onbox = false;
		});
	};
	$.extend({weeboxs: new weeboxs()});		
})(jQuery);

//date.format.js
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(B($){8 s=["2j","2i","2h","2g","2f","22","21"];8 t=["1p","1r","1t","19","14","1b","1c","1d","1e","1g","1h","1i"];8 u=["20","1Z","1Y","1X","14","1U","1u","1R","1Q","1N","1M","1K"];8 v=[];v["1p"]="1J";v["1r"]="1I";v["1t"]="1G";v["19"]="1F";v["14"]="1E";v["1b"]="1D";v["1c"]="1C";v["1d"]="1B";v["1e"]="1A";v["1g"]="10";v["1h"]="11";v["1i"]="12";$.K=(B(){B 1m(a){C s[18(a,10)]||a};B 1o(a){8 b=18(a,10)-1;C t[b]||a};B 1q(a){8 b=18(a,10)-1;C u[b]||a};8 q=B(a){C v[a]||a};8 r=B(a){8 b=a;8 c="";z(b.17(".")!==-1){8 d=b.F(\'.\');b=d[0];c=d[1]};8 e=b.F(":");z(e.D===3){A=e[0];Q=e[1];O=e[2];C{1n:b,A:A,Q:Q,O:O,16:c}}G{C{1n:"",A:"",Q:"",O:"",16:""}}};C{N:B(a,b){1z{8 c=H;8 d=H;8 f=H;8 g=H;8 h=H;8 j=H;z(1y a.1s==="B"){d=a.1s();f=a.1x()+1;g=a.1w();h=a.J();j=r(a.1v())}G z(a.1S(/\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.?\\d{0,3}[-+]?\\d{2}:?\\d{2}/)!=-1){8 k=a.F(/[T\\+-]/);d=k[0];f=k[1];g=k[2];j=r(k[3].F(".")[0]);c=R U(d,f-1,g);h=c.J()}G{8 k=a.F(" ");1j(k.D){x 6:d=k[5];f=q(k[1]);g=k[2];j=r(k[3]);c=R U(d,f-1,g);h=c.J();w;x 2:8 l=k[0].F("-");d=l[0];f=l[1];g=l[2];j=r(k[1]);c=R U(d,f-1,g);h=c.J();w;x 7:x 9:x 10:d=k[3];f=q(k[1]);g=k[2];j=r(k[4]);c=R U(d,f-1,g);h=c.J();w;1f:C a}};8 m="";8 n="";1H(8 i=0;i<b.D;i++){8 o=b.E(i);m+=o;1j(m){x"1L":n+=1m(h);m="";w;x"L":z(b.E(i+1)=="d"){w}z(V(g).D===1){g=\'0\'+g}n+=g;m="";w;x"1O":n+=1q(f);m="";w;x"1P":z(b.E(i+1)==="M"){w}n+=1o(f);m="";w;x"I":z(b.E(i+1)=="M"){w}z(V(f).D===1){f=\'0\'+f}n+=f;m="";w;x"P":n+=d;m="";w;x"1T":z(b.E(i+1)=="y"&&b.E(i+2)=="y"){w}n+=V(d).1V(-2);m="";w;x"1W":n+=j.A;m="";w;x"Y":8 p=(j.A==0?12:j.A<13?j.A:j.A-12);p=V(p).D==1?\'0\'+p:p;n+=p;m="";w;x"h":z(b.E(i+1)=="h"){w};8 p=(j.A==0?12:j.A<13?j.A:j.A-12);n+=p;m="";w;x"Z":n+=j.Q;m="";w;x"15":n+=j.O.W(0,2);m="";w;x"23":n+=j.16.W(0,3);m="";w;x"a":n+=j.A>=12?"24":"25";m="";w;x" ":n+=o;m="";w;x"/":n+=o;m="";w;x":":n+=o;m="";w;1f:z(m.D===2&&m.17("y")!==0&&m!="26"){n+=m.W(0,1);m=m.W(1,2)}G z((m.D===3&&m.17("27")===-1)){m=""}}};C n}28(e){29.2a(e);C a}}}}())}(2b));$(2c).2d(B(){$(".2e").1l(B(a,b){z($(b).1k(":1a")){$(b).X($.K.N($(b).X(),"L/I/P"))}G{$(b).S($.K.N($(b).S(),"L/I/P"))}});$(".2k").1l(B(a,b){z($(b).1k(":1a")){$(b).X($.K.N($(b).X(),"L/I/P Y:Z:15"))}G{$(b).S($.K.N($(b).S(),"L/I/P Y:Z:15"))}})});',62,145,'||||||||var||||||||||||||||||||||||break|case||if|hour|function|return|length|charAt|split|else|null|MM|getDay|format|dd||date|second|yyyy|minute|new|text||Date|String|substring|val|hh|mm|||||May|ss|millis|indexOf|parseInt|Apr|input|Jun|Jul|Aug|Sep|default|Oct|Nov|Dec|switch|is|each|strDay|time|strMonth|Jan|strLongMonth|Feb|getFullYear|Mar|July|toTimeString|getDate|getMonth|typeof|try|09|08|07|06|05|04|03|for|02|01|December|ddd|November|October|MMMM|MMM|September|August|search|yy|June|slice|HH|April|March|February|January|Saturday|Friday|SSS|PM|AM|SS|yyy|catch|console|log|jQuery|document|ready|shortDateFormat|Thursday|Wednesday|Tuesday|Monday|Sunday|longDateFormat'.split('|'),0,{}))

//ztree.js

/*
 * JQuery zTree core 3.1
 * http://code.google.com/p/jquerytree/
 *
 * Copyright (c) 2010 Hunter.z (baby666.cn)
 *
 * Licensed same as jquery - MIT License
 * http://www.opensource.org/licenses/mit-license.php
 *
 * email: hunter.z@263.net
 * Date: 2012-02-14
 */
;(function(l){var D,E,F,G,H,I,p={},J={},s={},M=0,K={treeId:"",treeObj:null,view:{addDiyDom:null,autoCancelSelected:!0,dblClickExpand:!0,expandSpeed:"fast",fontCss:{},nameIsHTML:!1,selectedMulti:!0,showIcon:!0,showLine:!0,showTitle:!0},data:{key:{children:"children",name:"name",title:""},simpleData:{enable:!1,idKey:"id",pIdKey:"pId",rootPId:null},keep:{parent:!1,leaf:!1}},async:{enable:!1,contentType:"application/x-www-form-urlencoded",type:"post",dataType:"text",url:"",autoParam:[],otherParam:[],dataFilter:null},
callback:{beforeAsync:null,beforeClick:null,beforeRightClick:null,beforeMouseDown:null,beforeMouseUp:null,beforeExpand:null,beforeCollapse:null,onAsyncError:null,onAsyncSuccess:null,onNodeCreated:null,onClick:null,onRightClick:null,onMouseDown:null,onMouseUp:null,onExpand:null,onCollapse:null}},t=[function(b){var a=b.treeObj,c=f.event;a.unbind(c.NODECREATED);a.bind(c.NODECREATED,function(a,c,h){k.apply(b.callback.onNodeCreated,[a,c,h])});a.unbind(c.CLICK);a.bind(c.CLICK,function(a,c,h,j){k.apply(b.callback.onClick,
[a,c,h,j])});a.unbind(c.EXPAND);a.bind(c.EXPAND,function(a,c,h){k.apply(b.callback.onExpand,[a,c,h])});a.unbind(c.COLLAPSE);a.bind(c.COLLAPSE,function(a,c,h){k.apply(b.callback.onCollapse,[a,c,h])});a.unbind(c.ASYNC_SUCCESS);a.bind(c.ASYNC_SUCCESS,function(a,c,h,j){k.apply(b.callback.onAsyncSuccess,[a,c,h,j])});a.unbind(c.ASYNC_ERROR);a.bind(c.ASYNC_ERROR,function(a,c,h,j,g,f){k.apply(b.callback.onAsyncError,[a,c,h,j,g,f])})}],q=[function(b){var a=g.getCache(b);a||(a={},g.setCache(b,a));a.nodes=[];
a.doms=[]}],v=[function(b,a,c,d,e,h){if(c){var j=b.data.key.children;c.level=a;c.tId=b.treeId+"_"+ ++M;c.parentTId=d?d.tId:null;if(c[j]&&c[j].length>0){if(typeof c.open=="string")c.open=k.eqs(c.open,"true");c.open=!!c.open;c.isParent=!0;c.zAsync=!0}else{c.open=!1;if(typeof c.isParent=="string")c.isParent=k.eqs(c.isParent,"true");c.isParent=!!c.isParent;c.zAsync=!c.isParent}c.isFirstNode=e;c.isLastNode=h;c.getParentNode=function(){return g.getNodeCache(b,c.parentTId)};c.getPreNode=function(){return g.getPreNode(b,
c)};c.getNextNode=function(){return g.getNextNode(b,c)};c.isAjaxing=!1;g.fixPIdKeyValue(b,c)}}],w=[function(b){var a=b.target,c=p[b.data.treeId],d="",e=null,h="",j="",i=null,o=null,l=null;if(k.eqs(b.type,"mousedown"))j="mousedown";else if(k.eqs(b.type,"mouseup"))j="mouseup";else if(k.eqs(b.type,"contextmenu"))j="contextmenu";else if(k.eqs(b.type,"click"))if(k.eqs(a.tagName,"button")&&a.blur(),k.eqs(a.tagName,"button")&&a.getAttribute("treeNode"+f.id.SWITCH)!==null)d=a.parentNode.id,h="switchNode";
else{if(l=k.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+f.id.A}]))d=l.parentNode.id,h="clickNode"}else if(k.eqs(b.type,"dblclick")&&(j="dblclick",l=k.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+f.id.A}])))d=l.parentNode.id,h="switchNode";if(j.length>0&&d.length==0&&(l=k.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+f.id.A}])))d=l.parentNode.id;if(d.length>0)switch(e=g.getNodeCache(c,d),h){case "switchNode":e.isParent?k.eqs(b.type,"click")||k.eqs(b.type,"dblclick")&&k.apply(c.view.dblClickExpand,
[c.treeId,e],c.view.dblClickExpand)?i=D:h="":h="";break;case "clickNode":i=E}switch(j){case "mousedown":o=F;break;case "mouseup":o=G;break;case "dblclick":o=H;break;case "contextmenu":o=I}return{stop:!1,node:e,nodeEventType:h,nodeEventCallback:i,treeEventType:j,treeEventCallback:o}}],x=[function(b){var a=g.getRoot(b);a||(a={},g.setRoot(b,a));a.children=[];a.expandTriggerFlag=!1;a.curSelectedList=[];a.noSelection=!0;a.createdNodes=[]}],y=[],z=[],A=[],B=[],C=[],g={addNodeCache:function(b,a){g.getCache(b).nodes[a.tId]=
a},addAfterA:function(b){z.push(b)},addBeforeA:function(b){y.push(b)},addInnerAfterA:function(b){B.push(b)},addInnerBeforeA:function(b){A.push(b)},addInitBind:function(b){t.push(b)},addInitCache:function(b){q.push(b)},addInitNode:function(b){v.push(b)},addInitProxy:function(b){w.push(b)},addInitRoot:function(b){x.push(b)},addNodesData:function(b,a,c){var d=b.data.key.children;a[d]||(a[d]=[]);if(a[d].length>0)a[d][a[d].length-1].isLastNode=!1,i.setNodeLineIcos(b,a[d][a[d].length-1]);a.isParent=!0;
a[d]=a[d].concat(c)},addSelectedNode:function(b,a){var c=g.getRoot(b);g.isSelectedNode(b,a)||c.curSelectedList.push(a)},addCreatedNode:function(b,a){(b.callback.onNodeCreated||b.view.addDiyDom)&&g.getRoot(b).createdNodes.push(a)},addZTreeTools:function(b){C.push(b)},exSetting:function(b){l.extend(!0,K,b)},fixPIdKeyValue:function(b,a){b.data.simpleData.enable&&(a[b.data.simpleData.pIdKey]=a.parentTId?a.getParentNode()[b.data.simpleData.idKey]:b.data.simpleData.rootPId)},getAfterA:function(b,a,c){for(var d=
0,e=z.length;d<e;d++)z[d].apply(this,arguments)},getBeforeA:function(b,a,c){for(var d=0,e=y.length;d<e;d++)y[d].apply(this,arguments)},getInnerAfterA:function(b,a,c){for(var d=0,e=B.length;d<e;d++)B[d].apply(this,arguments)},getInnerBeforeA:function(b,a,c){for(var d=0,e=A.length;d<e;d++)A[d].apply(this,arguments)},getCache:function(b){return s[b.treeId]},getNextNode:function(b,a){if(!a)return null;var c=b.data.key.children,d=a.parentTId?a.getParentNode():g.getRoot(b);if(!a.isLastNode)if(a.isFirstNode)return d[c][1];
else for(var e=1,h=d[c].length-1;e<h;e++)if(d[c][e]===a)return d[c][e+1];return null},getNodeByParam:function(b,a,c,d){if(!a||!c)return null;for(var e=b.data.key.children,h=0,j=a.length;h<j;h++){if(a[h][c]==d)return a[h];var f=g.getNodeByParam(b,a[h][e],c,d);if(f)return f}return null},getNodeCache:function(b,a){if(!a)return null;var c=s[b.treeId].nodes[a];return c?c:null},getNodes:function(b){return g.getRoot(b)[b.data.key.children]},getNodesByParam:function(b,a,c,d){if(!a||!c)return[];for(var e=
b.data.key.children,h=[],j=0,f=a.length;j<f;j++)a[j][c]==d&&h.push(a[j]),h=h.concat(g.getNodesByParam(b,a[j][e],c,d));return h},getNodesByParamFuzzy:function(b,a,c,d){if(!a||!c)return[];for(var e=b.data.key.children,h=[],j=0,f=a.length;j<f;j++)typeof a[j][c]=="string"&&a[j][c].indexOf(d)>-1&&h.push(a[j]),h=h.concat(g.getNodesByParamFuzzy(b,a[j][e],c,d));return h},getPreNode:function(b,a){if(!a)return null;var c=b.data.key.children,d=a.parentTId?a.getParentNode():g.getRoot(b);if(!a.isFirstNode)if(a.isLastNode)return d[c][d[c].length-
2];else for(var e=1,h=d[c].length-1;e<h;e++)if(d[c][e]===a)return d[c][e-1];return null},getRoot:function(b){return b?J[b.treeId]:null},getSetting:function(b){return p[b]},getSettings:function(){return p},getTitleKey:function(b){return b.data.key.title===""?b.data.key.name:b.data.key.title},getZTreeTools:function(b){return(b=this.getRoot(this.getSetting(b)))?b.treeTools:null},initCache:function(b){for(var a=0,c=q.length;a<c;a++)q[a].apply(this,arguments)},initNode:function(b,a,c,d,e,h){for(var j=
0,f=v.length;j<f;j++)v[j].apply(this,arguments)},initRoot:function(b){for(var a=0,c=x.length;a<c;a++)x[a].apply(this,arguments)},isSelectedNode:function(b,a){for(var c=g.getRoot(b),d=0,e=c.curSelectedList.length;d<e;d++)if(a===c.curSelectedList[d])return!0;return!1},removeNodeCache:function(b,a){var c=b.data.key.children;if(a[c])for(var d=0,e=a[c].length;d<e;d++)arguments.callee(b,a[c][d]);delete g.getCache(b).nodes[a.tId]},removeSelectedNode:function(b,a){for(var c=g.getRoot(b),d=0,e=c.curSelectedList.length;d<
e;d++)if(a===c.curSelectedList[d]||!g.getNodeCache(b,c.curSelectedList[d].tId))c.curSelectedList.splice(d,1),d--,e--},setCache:function(b,a){s[b.treeId]=a},setRoot:function(b,a){J[b.treeId]=a},setZTreeTools:function(b,a){for(var c=0,d=C.length;c<d;c++)C[c].apply(this,arguments)},transformToArrayFormat:function(b,a){if(!a)return[];var c=b.data.key.children,d=[];if(k.isArray(a))for(var e=0,h=a.length;e<h;e++)d.push(a[e]),a[e][c]&&(d=d.concat(g.transformToArrayFormat(b,a[e][c])));else d.push(a),a[c]&&
(d=d.concat(g.transformToArrayFormat(b,a[c])));return d},transformTozTreeFormat:function(b,a){var c,d,e=b.data.simpleData.idKey,h=b.data.simpleData.pIdKey,j=b.data.key.children;if(!e||e==""||!a)return[];if(k.isArray(a)){var f=[],g=[];for(c=0,d=a.length;c<d;c++)g[a[c][e]]=a[c];for(c=0,d=a.length;c<d;c++)g[a[c][h]]&&a[c][e]!=a[c][h]?(g[a[c][h]][j]||(g[a[c][h]][j]=[]),g[a[c][h]][j].push(a[c])):f.push(a[c]);return f}else return[a]}},m={bindEvent:function(b){for(var a=0,c=t.length;a<c;a++)t[a].apply(this,
arguments)},bindTree:function(b){var a={treeId:b.treeId},b=b.treeObj;b.unbind("click",m.proxy);b.bind("click",a,m.proxy);b.unbind("dblclick",m.proxy);b.bind("dblclick",a,m.proxy);b.unbind("mouseover",m.proxy);b.bind("mouseover",a,m.proxy);b.unbind("mouseout",m.proxy);b.bind("mouseout",a,m.proxy);b.unbind("mousedown",m.proxy);b.bind("mousedown",a,m.proxy);b.unbind("mouseup",m.proxy);b.bind("mouseup",a,m.proxy);b.unbind("contextmenu",m.proxy);b.bind("contextmenu",a,m.proxy)},doProxy:function(b){for(var a=
[],c=0,d=w.length;c<d;c++){var e=w[c].apply(this,arguments);a.push(e);if(e.stop)break}return a},proxy:function(b){var a=g.getSetting(b.data.treeId);if(!k.uCanDo(a,b))return!0;for(var c=m.doProxy(b),d=!0,e=!1,h=0,j=c.length;h<j;h++){var f=c[h];f.nodeEventCallback&&(e=!0,d=f.nodeEventCallback.apply(f,[b,f.node])&&d);f.treeEventCallback&&(e=!0,d=f.treeEventCallback.apply(f,[b,f.node])&&d)}try{e&&l("input:focus").length==0&&k.noSel(a)}catch(i){}return d}};D=function(b,a){var c=p[b.data.treeId];if(a.open){if(k.apply(c.callback.beforeCollapse,
[c.treeId,a],!0)==!1)return!0}else if(k.apply(c.callback.beforeExpand,[c.treeId,a],!0)==!1)return!0;g.getRoot(c).expandTriggerFlag=!0;i.switchNode(c,a);return!0};E=function(b,a){var c=p[b.data.treeId],d=c.view.autoCancelSelected&&b.ctrlKey&&g.isSelectedNode(c,a)?0:c.view.autoCancelSelected&&b.ctrlKey&&c.view.selectedMulti?2:1;if(k.apply(c.callback.beforeClick,[c.treeId,a,d],!0)==!1)return!0;d===0?i.cancelPreSelectedNode(c,a):i.selectNode(c,a,d===2);c.treeObj.trigger(f.event.CLICK,[c.treeId,a,d]);
return!0};F=function(b,a){var c=p[b.data.treeId];k.apply(c.callback.beforeMouseDown,[c.treeId,a],!0)&&k.apply(c.callback.onMouseDown,[b,c.treeId,a]);return!0};G=function(b,a){var c=p[b.data.treeId];k.apply(c.callback.beforeMouseUp,[c.treeId,a],!0)&&k.apply(c.callback.onMouseUp,[b,c.treeId,a]);return!0};H=function(b,a){var c=p[b.data.treeId];k.apply(c.callback.beforeDblClick,[c.treeId,a],!0)&&k.apply(c.callback.onDblClick,[b,c.treeId,a]);return!0};I=function(b,a){var c=p[b.data.treeId];k.apply(c.callback.beforeRightClick,
[c.treeId,a],!0)&&k.apply(c.callback.onRightClick,[b,c.treeId,a]);return typeof c.callback.onRightClick!="function"};var k={apply:function(b,a,c){return typeof b=="function"?b.apply(L,a?a:[]):c},canAsync:function(b,a){var c=b.data.key.children;return a&&a.isParent&&!(a.zAsync||a[c]&&a[c].length>0)},clone:function(b){var a;if(b instanceof Array){a=[];for(var c=b.length;c--;)a[c]=arguments.callee(b[c]);return a}else if(typeof b=="function")return b;else if(b instanceof Object){a={};for(c in b)a[c]=
arguments.callee(b[c]);return a}else return b},eqs:function(b,a){return b.toLowerCase()===a.toLowerCase()},isArray:function(b){return Object.prototype.toString.apply(b)==="[object Array]"},getMDom:function(b,a,c){if(!a)return null;for(;a&&a.id!==b.treeId;){for(var d=0,e=c.length;a.tagName&&d<e;d++)if(k.eqs(a.tagName,c[d].tagName)&&a.getAttribute(c[d].attrName)!==null)return a;a=a.parentNode}return null},noSel:function(b){if(g.getRoot(b).noSelection)try{window.getSelection?window.getSelection().removeAllRanges():
document.selection.empty()}catch(a){}},uCanDo:function(){return!0}},i={addNodes:function(b,a,c,d){if(!b.data.keep.leaf||!a||a.isParent)if(k.isArray(c)||(c=[c]),b.data.simpleData.enable&&(c=g.transformTozTreeFormat(b,c)),a){var e=l("#"+a.tId+f.id.SWITCH),h=l("#"+a.tId+f.id.ICON),j=l("#"+a.tId+f.id.UL);if(!a.open)i.replaceSwitchClass(a,e,f.folder.CLOSE),i.replaceIcoClass(a,h,f.folder.CLOSE),a.open=!1,j.css({display:"none"});g.addNodesData(b,a,c);i.createNodes(b,a.level+1,c,a);d||i.expandCollapseParentNode(b,
a,!0)}else g.addNodesData(b,g.getRoot(b),c),i.createNodes(b,0,c,null)},appendNodes:function(b,a,c,d,e,h){if(!c)return[];for(var j=[],l=b.data.key.children,o=b.data.key.name,m=g.getTitleKey(b),p=0,N=c.length;p<N;p++){var n=c[p],u=(d?d:g.getRoot(b))[l].length==c.length&&p==0,r=p==c.length-1;e&&(g.initNode(b,a,n,d,u,r,h),g.addNodeCache(b,n));u=[];n[l]&&n[l].length>0&&(u=i.appendNodes(b,a+1,n[l],n,e,h&&n.open));if(h){var r=i.makeNodeUrl(b,n),s=i.makeNodeFontCss(b,n),t=[],q;for(q in s)t.push(q,":",s[q],
";");j.push("<li id='",n.tId,"' class='level",n.level,"' treenode>","<button type='button' hidefocus='true'",n.isParent?"":"disabled"," id='",n.tId,f.id.SWITCH,"' title='' class='",i.makeNodeLineClass(b,n),"' treeNode",f.id.SWITCH,"></button>");g.getBeforeA(b,n,j);j.push("<a id='",n.tId,f.id.A,"' class='level",n.level,"' treeNode",f.id.A,' onclick="',n.click||"",'" ',r!=null&&r.length>0?"href='"+r+"'":""," target='",i.makeNodeTarget(n),"' style='",t.join(""),"'");k.apply(b.view.showTitle,[b.treeId,
n],b.view.showTitle)&&n[m]&&j.push("title='",n[m].replace(/'/g,"&#39;").replace(/</g,"&lt;").replace(/>/g,"&gt;"),"'");j.push(">");g.getInnerBeforeA(b,n,j);r=b.view.nameIsHTML?n[o]:n[o].replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;");j.push("<button type='button' hidefocus='true' id='",n.tId,f.id.ICON,"' title='' treeNode",f.id.ICON," class='",i.makeNodeIcoClass(b,n),"' style='",i.makeNodeIcoStyle(b,n),"'></button><span id='",n.tId,f.id.SPAN,"'>",r,"</span>");g.getInnerAfterA(b,n,
j);j.push("</a>");g.getAfterA(b,n,j);n.isParent&&n.open&&i.makeUlHtml(b,n,j,u.join(""));j.push("</li>");g.addCreatedNode(b,n)}}return j},appendParentULDom:function(b,a){var c=[],d=l("#"+a.tId),e=l("#"+a.tId+f.id.UL),h=i.appendNodes(b,a.level+1,a[b.data.key.children],a,!1,!0);i.makeUlHtml(b,a,c,h.join(""));!d.get(0)&&a.parentTId&&(i.appendParentULDom(b,a.getParentNode()),d=l("#"+a.tId));e.get(0)&&e.remove();d.append(c.join(""));i.createNodeCallback(b)},asyncNode:function(b,a,c,d){var e,h;if(a&&!a.isParent)return k.apply(d),
!1;else if(a&&a.isAjaxing)return!1;else if(k.apply(b.callback.beforeAsync,[b.treeId,a],!0)==!1)return k.apply(d),!1;if(a)a.isAjaxing=!0,l("#"+a.tId+f.id.ICON).attr({style:"","class":"ico_loading"});var j=b.async.contentType=="application/json",g=j?"{":"",o="";for(e=0,h=b.async.autoParam.length;a&&e<h;e++){var m=b.async.autoParam[e].split("="),p=m;m.length>1&&(p=m[1],m=m[0]);j?(o=typeof a[m]=="string"?'"':"",g+='"'+p+('":'+o+a[m]).replace(/'/g,"\\'")+o+","):g+=p+("="+a[m]).replace(/&/g,"%26")+"&"}if(k.isArray(b.async.otherParam))for(e=
0,h=b.async.otherParam.length;e<h;e+=2)j?(o=typeof b.async.otherParam[e+1]=="string"?'"':"",g+='"'+b.async.otherParam[e]+('":'+o+b.async.otherParam[e+1]).replace(/'/g,"\\'")+o+","):g+=b.async.otherParam[e]+("="+b.async.otherParam[e+1]).replace(/&/g,"%26")+"&";else for(var q in b.async.otherParam)j?(o=typeof b.async.otherParam[q]=="string"?'"':"",g+='"'+q+('":'+o+b.async.otherParam[q]).replace(/'/g,"\\'")+o+","):g+=q+("="+b.async.otherParam[q]).replace(/&/g,"%26")+"&";g.length>1&&(g=g.substring(0,
g.length-1));j&&(g+="}");l.ajax({contentType:b.async.contentType,type:b.async.type,url:k.apply(b.async.url,[b.treeId,a],b.async.url),data:g,dataType:b.async.dataType,success:function(e){var h=[];try{h=!e||e.length==0?[]:typeof e=="string"?eval("("+e+")"):e}catch(g){}if(a)a.isAjaxing=null,a.zAsync=!0;i.setNodeLineIcos(b,a);h&&h!=""?(h=k.apply(b.async.dataFilter,[b.treeId,a,h],h),i.addNodes(b,a,k.clone(h),!!c)):i.addNodes(b,a,[],!!c);b.treeObj.trigger(f.event.ASYNC_SUCCESS,[b.treeId,a,e]);k.apply(d)},
error:function(c,d,e){i.setNodeLineIcos(b,a);if(a)a.isAjaxing=null;b.treeObj.trigger(f.event.ASYNC_ERROR,[b.treeId,a,c,d,e])}});return!0},cancelPreSelectedNode:function(b,a){for(var c=g.getRoot(b).curSelectedList,d=c.length-1;d>=0;d--)if(!a||a===c[d])if(l("#"+c[d].tId+f.id.A).removeClass(f.node.CURSELECTED),i.setNodeName(b,c[d]),a){g.removeSelectedNode(b,a);break}if(!a)g.getRoot(b).curSelectedList=[]},createNodeCallback:function(b){if(b.callback.onNodeCreated||b.view.addDiyDom)for(var a=g.getRoot(b);a.createdNodes.length>
0;){var c=a.createdNodes.shift();k.apply(b.view.addDiyDom,[b.treeId,c]);b.callback.onNodeCreated&&b.treeObj.trigger(f.event.NODECREATED,[b.treeId,c])}},createNodes:function(b,a,c,d){if(c&&c.length!=0){var e=g.getRoot(b),h=b.data.key.children,h=!d||d.open||!!l("#"+d[h][0].tId).get(0);e.createdNodes=[];a=i.appendNodes(b,a,c,d,!0,h);d?(d=l("#"+d.tId+f.id.UL),d.get(0)&&d.append(a.join(""))):b.treeObj.append(a.join(""));i.createNodeCallback(b)}},expandCollapseNode:function(b,a,c,d,e){var h=g.getRoot(b),
j=b.data.key.children;if(a){if(h.expandTriggerFlag){var m=e,e=function(){m&&m();a.open?b.treeObj.trigger(f.event.EXPAND,[b.treeId,a]):b.treeObj.trigger(f.event.COLLAPSE,[b.treeId,a])};h.expandTriggerFlag=!1}if(a.open==c)k.apply(e,[]);else{!a.open&&a.isParent&&(!l("#"+a.tId+f.id.UL).get(0)||a[j]&&a[j].length>0&&!l("#"+a[j][0].tId).get(0))&&i.appendParentULDom(b,a);var c=l("#"+a.tId+f.id.UL),h=l("#"+a.tId+f.id.SWITCH),o=l("#"+a.tId+f.id.ICON);a.isParent?(a.open=!a.open,a.iconOpen&&a.iconClose&&o.attr("style",
i.makeNodeIcoStyle(b,a)),a.open?(i.replaceSwitchClass(a,h,f.folder.OPEN),i.replaceIcoClass(a,o,f.folder.OPEN),d==!1||b.view.expandSpeed==""?(c.show(),k.apply(e,[])):a[j]&&a[j].length>0?c.slideDown(b.view.expandSpeed,e):(c.show(),k.apply(e,[]))):(i.replaceSwitchClass(a,h,f.folder.CLOSE),i.replaceIcoClass(a,o,f.folder.CLOSE),d==!1||b.view.expandSpeed==""?(c.hide(),k.apply(e,[])):c.slideUp(b.view.expandSpeed,e))):k.apply(e,[])}}else k.apply(e,[])},expandCollapseParentNode:function(b,a,c,d,e){a&&(a.parentTId?
(i.expandCollapseNode(b,a,c,d),a.parentTId&&i.expandCollapseParentNode(b,a.getParentNode(),c,d,e)):i.expandCollapseNode(b,a,c,d,e))},expandCollapseSonNode:function(b,a,c,d,e){var h=g.getRoot(b),f=b.data.key.children,h=a?a[f]:h[f],f=a?!1:d,k=g.getRoot(b).expandTriggerFlag;g.getRoot(b).expandTriggerFlag=!1;if(h)for(var l=0,m=h.length;l<m;l++)h[l]&&i.expandCollapseSonNode(b,h[l],c,f);g.getRoot(b).expandTriggerFlag=k;i.expandCollapseNode(b,a,c,d,e)},makeNodeFontCss:function(b,a){var c=k.apply(b.view.fontCss,
[b.treeId,a],b.view.fontCss);return c&&typeof c!="function"?c:{}},makeNodeIcoClass:function(b,a){var c=["ico"];a.isAjaxing||(c[0]=(a.iconSkin?a.iconSkin+"_":"")+c[0],a.isParent?c.push(a.open?f.folder.OPEN:f.folder.CLOSE):c.push(f.folder.DOCU));return c.join("_")},makeNodeIcoStyle:function(b,a){var c=[];if(!a.isAjaxing){var d=a.isParent&&a.iconOpen&&a.iconClose?a.open?a.iconOpen:a.iconClose:a.icon;d&&c.push("background:url(",d,") 0 0 no-repeat;");(b.view.showIcon==!1||!k.apply(b.view.showIcon,[b.treeId,
a],!0))&&c.push("width:0px;height:0px;")}return c.join("")},makeNodeLineClass:function(b,a){var c=[];b.view.showLine?a.level==0&&a.isFirstNode&&a.isLastNode?c.push(f.line.ROOT):a.level==0&&a.isFirstNode?c.push(f.line.ROOTS):a.isLastNode?c.push(f.line.BOTTOM):c.push(f.line.CENTER):c.push(f.line.NOLINE);a.isParent?c.push(a.open?f.folder.OPEN:f.folder.CLOSE):c.push(f.folder.DOCU);return i.makeNodeLineClassEx(a)+c.join("_")},makeNodeLineClassEx:function(b){return"level"+b.level+" switch "},makeNodeTarget:function(b){return b.target||
"_blank"},makeNodeUrl:function(b,a){return a.url?a.url:null},makeUlHtml:function(b,a,c,d){c.push("<ul id='",a.tId,f.id.UL,"' class='level",a.level," ",i.makeUlLineClass(b,a),"' style='display:",a.open?"block":"none","'>");c.push(d);c.push("</ul>")},makeUlLineClass:function(b,a){return b.view.showLine&&!a.isLastNode?f.line.LINE:""},replaceIcoClass:function(b,a,c){if(a&&!b.isAjaxing&&(b=a.attr("class"),b!=void 0)){b=b.split("_");switch(c){case f.folder.OPEN:case f.folder.CLOSE:case f.folder.DOCU:b[b.length-
1]=c}a.attr("class",b.join("_"))}},replaceSwitchClass:function(b,a,c){if(a){var d=a.attr("class");if(d!=void 0){d=d.split("_");switch(c){case f.line.ROOT:case f.line.ROOTS:case f.line.CENTER:case f.line.BOTTOM:case f.line.NOLINE:d[0]=i.makeNodeLineClassEx(b)+c;break;case f.folder.OPEN:case f.folder.CLOSE:case f.folder.DOCU:d[1]=c}a.attr("class",d.join("_"));c!==f.folder.DOCU?a.removeAttr("disabled"):a.attr("disabled","disabled")}}},selectNode:function(b,a,c){c||i.cancelPreSelectedNode(b);l("#"+a.tId+
f.id.A).addClass(f.node.CURSELECTED);g.addSelectedNode(b,a)},setNodeFontCss:function(b,a){var c=l("#"+a.tId+f.id.A),d=i.makeNodeFontCss(b,a);d&&c.css(d)},setNodeLineIcos:function(b,a){if(a){var c=l("#"+a.tId+f.id.SWITCH),d=l("#"+a.tId+f.id.UL),e=l("#"+a.tId+f.id.ICON),h=i.makeUlLineClass(b,a);h.length==0?d.removeClass(f.line.LINE):d.addClass(h);c.attr("class",i.makeNodeLineClass(b,a));a.isParent?c.removeAttr("disabled"):c.attr("disabled","disabled");e.removeAttr("style");e.attr("style",i.makeNodeIcoStyle(b,
a));e.attr("class",i.makeNodeIcoClass(b,a))}},setNodeName:function(b,a){var c=b.data.key.name,d=g.getTitleKey(b),e=l("#"+a.tId+f.id.SPAN);e.empty();b.view.nameIsHTML?e.html(a[c]):e.text(a[c]);k.apply(b.view.showTitle,[b.treeId,a],b.view.showTitle)&&a[d]&&l("#"+a.tId+f.id.A).attr("title",a[d])},setNodeTarget:function(b){l("#"+b.tId+f.id.A).attr("target",i.makeNodeTarget(b))},setNodeUrl:function(b,a){var c=l("#"+a.tId+f.id.A),d=i.makeNodeUrl(b,a);d==null||d.length==0?c.removeAttr("href"):c.attr("href",
d)},switchNode:function(b,a){a.open||!k.canAsync(b,a)?i.expandCollapseNode(b,a,!a.open):b.async.enable?i.asyncNode(b,a)||i.expandCollapseNode(b,a,!a.open):a&&i.expandCollapseNode(b,a,!a.open)}};l.fn.zTree={consts:{event:{NODECREATED:"ztree_nodeCreated",CLICK:"ztree_click",EXPAND:"ztree_expand",COLLAPSE:"ztree_collapse",ASYNC_SUCCESS:"ztree_async_success",ASYNC_ERROR:"ztree_async_error"},id:{A:"_a",ICON:"_ico",SPAN:"_span",SWITCH:"_switch",UL:"_ul"},line:{ROOT:"root",ROOTS:"roots",CENTER:"center",
BOTTOM:"bottom",NOLINE:"noline",LINE:"line"},folder:{OPEN:"open",CLOSE:"close",DOCU:"docu"},node:{CURSELECTED:"curSelectedNode"}},_z:{tools:k,view:i,event:m,data:g},getZTreeObj:function(b){return(b=g.getZTreeTools(b))?b:null},init:function(b,a,c){var d=k.clone(K);l.extend(!0,d,a);d.treeId=b.attr("id");d.treeObj=b;d.treeObj.empty();p[d.treeId]=d;if(l.browser.msie&&parseInt(l.browser.version)<7)d.view.expandSpeed="";g.initRoot(d);b=g.getRoot(d);a=d.data.key.children;c=c?k.clone(k.isArray(c)?c:[c]):
[];b[a]=d.data.simpleData.enable?g.transformTozTreeFormat(d,c):c;g.initCache(d);m.bindTree(d);m.bindEvent(d);c={setting:d,cancelSelectedNode:function(a){i.cancelPreSelectedNode(this.setting,a)},expandAll:function(a){a=!!a;i.expandCollapseSonNode(this.setting,null,a,!0);return a},expandNode:function(a,b,c,m,o){if(!a||!a.isParent)return null;b!==!0&&b!==!1&&(b=!a.open);if((o=!!o)&&b&&k.apply(d.callback.beforeExpand,[d.treeId,a],!0)==!1)return null;else if(o&&!b&&k.apply(d.callback.beforeCollapse,[d.treeId,
a],!0)==!1)return null;b&&a.parentTId&&i.expandCollapseParentNode(this.setting,a.getParentNode(),b,!1);if(b===a.open&&!c)return null;g.getRoot(d).expandTriggerFlag=o;c?i.expandCollapseSonNode(this.setting,a,b,!0,function(){m!==!1&&l("#"+a.tId+f.id.ICON).focus().blur()}):(a.open=!b,i.switchNode(this.setting,a),m!==!1&&l("#"+a.tId+f.id.ICON).focus().blur());return b},getNodes:function(){return g.getNodes(this.setting)},getNodeByParam:function(a,b,c){return!a?null:g.getNodeByParam(this.setting,c?c[this.setting.data.key.children]:
g.getNodes(this.setting),a,b)},getNodeByTId:function(a){return g.getNodeCache(this.setting,a)},getNodesByParam:function(a,b,c){return!a?null:g.getNodesByParam(this.setting,c?c[this.setting.data.key.children]:g.getNodes(this.setting),a,b)},getNodesByParamFuzzy:function(a,b,c){return!a?null:g.getNodesByParamFuzzy(this.setting,c?c[this.setting.data.key.children]:g.getNodes(this.setting),a,b)},getNodeIndex:function(a){if(!a)return null;for(var b=d.data.key.children,c=a.parentTId?a.getParentNode():g.getRoot(this.setting),
f=0,i=c[b].length;f<i;f++)if(c[b][f]==a)return f;return-1},getSelectedNodes:function(){for(var a=[],b=g.getRoot(this.setting).curSelectedList,c=0,d=b.length;c<d;c++)a.push(b[c]);return a},isSelectedNode:function(a){return g.isSelectedNode(this.setting,a)},reAsyncChildNodes:function(a,b,c){if(this.setting.async.enable){var d=!a;d&&(a=g.getRoot(this.setting));b=="refresh"&&(a[this.setting.data.key.children]=[],d?this.setting.treeObj.empty():l("#"+a.tId+f.id.UL).empty());i.asyncNode(this.setting,d?null:
a,!!c)}},refresh:function(){this.setting.treeObj.empty();var a=g.getRoot(this.setting),b=a[this.setting.data.key.children];g.initRoot(this.setting);a[this.setting.data.key.children]=b;g.initCache(this.setting);i.createNodes(this.setting,0,a[this.setting.data.key.children])},selectNode:function(a,b){a&&k.uCanDo(this.setting)&&(b=d.view.selectedMulti&&b,a.parentTId?i.expandCollapseParentNode(this.setting,a.getParentNode(),!0,!1,function(){l("#"+a.tId+f.id.ICON).focus().blur()}):l("#"+a.tId+f.id.ICON).focus().blur(),
i.selectNode(this.setting,a,b))},transformTozTreeNodes:function(a){return g.transformTozTreeFormat(this.setting,a)},transformToArray:function(a){return g.transformToArrayFormat(this.setting,a)},updateNode:function(a){a&&l("#"+a.tId).get(0)&&k.uCanDo(this.setting)&&(i.setNodeName(this.setting,a),i.setNodeTarget(a),i.setNodeUrl(this.setting,a),i.setNodeLineIcos(this.setting,a),i.setNodeFontCss(this.setting,a))}};b.treeTools=c;g.setZTreeTools(d,c);b[a]&&b[a].length>0?i.createNodes(d,0,b[a]):d.async.enable&&
d.async.url&&d.async.url!==""&&i.asyncNode(d);return c}};var L=l.fn.zTree,f=L.consts})(jQuery);

/*
 * JQuery zTree excheck 3.1
 * http://code.google.com/p/jquerytree/
 *
 * Copyright (c) 2010 Hunter.z (baby666.cn)
 *
 * Licensed same as jquery - MIT License
 * http://www.opensource.org/licenses/mit-license.php
 *
 * email: hunter.z@263.net
 * Date: 2012-02-14
 */
(function(h){var p,q,r,o={event:{CHECK:"ztree_check"},id:{CHECK:"_check"},checkbox:{STYLE:"checkbox",DEFAULT:"chk",DISABLED:"disable",FALSE:"false",TRUE:"true",FULL:"full",PART:"part",FOCUS:"focus"},radio:{STYLE:"radio",TYPE_ALL:"all",TYPE_LEVEL:"level"}},t={check:{enable:!1,autoCheckTrigger:!1,chkStyle:o.checkbox.STYLE,nocheckInherit:!1,radioType:o.radio.TYPE_LEVEL,chkboxType:{Y:"ps",N:"ps"}},data:{key:{checked:"checked"}},callback:{beforeCheck:null,onCheck:null}};p=function(c,a){if(a.chkDisabled===
!0)return!1;var b=g.getSetting(c.data.treeId),d=b.data.key.checked;if(n.apply(b.callback.beforeCheck,[b.treeId,a],!0)==!1)return!0;a[d]=!a[d];e.checkNodeRelation(b,a);d=h("#"+a.tId+j.id.CHECK);e.setChkClass(b,d,a);e.repairParentChkClassWithSelf(b,a);b.treeObj.trigger(j.event.CHECK,[b.treeId,a]);return!0};q=function(c,a){if(a.chkDisabled===!0)return!1;var b=g.getSetting(c.data.treeId),d=h("#"+a.tId+j.id.CHECK);a.check_Focus=!0;e.setChkClass(b,d,a);return!0};r=function(c,a){if(a.chkDisabled===!0)return!1;
var b=g.getSetting(c.data.treeId),d=h("#"+a.tId+j.id.CHECK);a.check_Focus=!1;e.setChkClass(b,d,a);return!0};h.extend(!0,h.fn.zTree.consts,o);h.extend(!0,h.fn.zTree._z,{tools:{},view:{checkNodeRelation:function(c,a){var b,d,f,k=c.data.key.children,l=c.data.key.checked;b=j.radio;if(c.check.chkStyle==b.STYLE){var i=g.getRadioCheckedList(c);if(a[l])if(c.check.radioType==b.TYPE_ALL){for(d=i.length-1;d>=0;d--)b=i[d],b[l]=!1,i.splice(d,1),e.setChkClass(c,h("#"+b.tId+j.id.CHECK),b),b.parentTId!=a.parentTId&&
e.repairParentChkClassWithSelf(c,b);i.push(a)}else{i=a.parentTId?a.getParentNode():g.getRoot(c);for(d=0,f=i[k].length;d<f;d++)b=i[k][d],b[l]&&b!=a&&(b[l]=!1,e.setChkClass(c,h("#"+b.tId+j.id.CHECK),b))}else if(c.check.radioType==b.TYPE_ALL)for(d=0,f=i.length;d<f;d++)if(a==i[d]){i.splice(d,1);break}}else a[l]&&(!a[k]||a[k].length==0||c.check.chkboxType.Y.indexOf("s")>-1)&&e.setSonNodeCheckBox(c,a,!0),!a[l]&&(!a[k]||a[k].length==0||c.check.chkboxType.N.indexOf("s")>-1)&&e.setSonNodeCheckBox(c,a,!1),
a[l]&&c.check.chkboxType.Y.indexOf("p")>-1&&e.setParentNodeCheckBox(c,a,!0),!a[l]&&c.check.chkboxType.N.indexOf("p")>-1&&e.setParentNodeCheckBox(c,a,!1)},makeChkClass:function(c,a){var b=c.data.key.checked,d=j.checkbox,f=j.radio,k="",k=a.chkDisabled===!0?d.DISABLED:a.halfCheck?d.PART:c.check.chkStyle==f.STYLE?a.check_Child_State<1?d.FULL:d.PART:a[b]?a.check_Child_State===2||a.check_Child_State===-1?d.FULL:d.PART:a.check_Child_State<1?d.FULL:d.PART,b=c.check.chkStyle+"_"+(a[b]?d.TRUE:d.FALSE)+"_"+
k,b=a.check_Focus&&a.chkDisabled!==!0?b+"_"+d.FOCUS:b;return d.DEFAULT+" "+b},repairAllChk:function(c,a){if(c.check.enable&&c.check.chkStyle===j.checkbox.STYLE)for(var b=c.data.key.checked,d=c.data.key.children,f=g.getRoot(c),k=0,l=f[d].length;k<l;k++){var i=f[d][k];i.nocheck!==!0&&(i[b]=a);e.setSonNodeCheckBox(c,i,a)}},repairChkClass:function(c,a){if(a){g.makeChkFlag(c,a);var b=h("#"+a.tId+j.id.CHECK);e.setChkClass(c,b,a)}},repairParentChkClass:function(c,a){if(a&&a.parentTId){var b=a.getParentNode();
e.repairChkClass(c,b);e.repairParentChkClass(c,b)}},repairParentChkClassWithSelf:function(c,a){if(a){var b=c.data.key.children;a[b]&&a[b].length>0?e.repairParentChkClass(c,a[b][0]):e.repairParentChkClass(c,a)}},repairSonChkDisabled:function(c,a,b){if(a){var d=c.data.key.children;if(a.chkDisabled!=b)a.chkDisabled=b,a.nocheck!==!0&&e.repairChkClass(c,a);if(a[d])for(var f=0,k=a[d].length;f<k;f++)e.repairSonChkDisabled(c,a[d][f],b)}},repairParentChkDisabled:function(c,a,b){if(a){if(a.chkDisabled!=b)a.chkDisabled=
b,a.nocheck!==!0&&e.repairChkClass(c,a);e.repairParentChkDisabled(c,a.getParentNode(),b)}},setChkClass:function(c,a,b){a&&(b.nocheck===!0?a.hide():a.show(),a.removeClass(),a.addClass(e.makeChkClass(c,b)))},setParentNodeCheckBox:function(c,a,b,d){var f=c.data.key.children,k=c.data.key.checked,l=h("#"+a.tId+j.id.CHECK);d||(d=a);g.makeChkFlag(c,a);a.nocheck!==!0&&a.chkDisabled!==!0&&(a[k]=b,e.setChkClass(c,l,a),c.check.autoCheckTrigger&&a!=d&&a.nocheck!==!0&&c.treeObj.trigger(j.event.CHECK,[c.treeId,
a]));if(a.parentTId){l=!0;if(!b)for(var f=a.getParentNode()[f],i=0,m=f.length;i<m;i++)if(f[i].nocheck!==!0&&f[i][k]||f[i].nocheck===!0&&f[i].check_Child_State>0){l=!1;break}l&&e.setParentNodeCheckBox(c,a.getParentNode(),b,d)}},setSonNodeCheckBox:function(c,a,b,d){if(a){var f=c.data.key.children,k=c.data.key.checked,l=h("#"+a.tId+j.id.CHECK);d||(d=a);var i=!1;if(a[f])for(var m=0,n=a[f].length;m<n&&a.chkDisabled!==!0;m++){var o=a[f][m];e.setSonNodeCheckBox(c,o,b,d);o.chkDisabled===!0&&(i=!0)}if(a!=
g.getRoot(c)&&a.chkDisabled!==!0){i&&a.nocheck!==!0&&g.makeChkFlag(c,a);if(a.nocheck!==!0){if(a[k]=b,!i)a.check_Child_State=a[f]&&a[f].length>0?b?2:0:-1}else a.check_Child_State=-1;e.setChkClass(c,l,a);c.check.autoCheckTrigger&&a!=d&&a.nocheck!==!0&&c.treeObj.trigger(j.event.CHECK,[c.treeId,a])}}}},event:{},data:{getRadioCheckedList:function(c){for(var a=g.getRoot(c).radioCheckedList,b=0,d=a.length;b<d;b++)g.getNodeCache(c,a[b].tId)||(a.splice(b,1),b--,d--);return a},getCheckStatus:function(c,a){if(!c.check.enable||
a.nocheck)return null;var b=c.data.key.checked;return{checked:a[b],half:a.halfCheck?a.halfCheck:c.check.chkStyle==j.radio.STYLE?a.check_Child_State===2:a[b]?a.check_Child_State>-1&&a.check_Child_State<2:a.check_Child_State>0}},getTreeCheckedNodes:function(c,a,b,d){if(!a)return[];for(var f=c.data.key.children,k=c.data.key.checked,d=!d?[]:d,e=0,i=a.length;e<i;e++)a[e].nocheck!==!0&&a[e][k]==b&&d.push(a[e]),g.getTreeCheckedNodes(c,a[e][f],b,d);return d},getTreeChangeCheckedNodes:function(c,a,b){if(!a)return[];
for(var d=c.data.key.children,f=c.data.key.checked,b=!b?[]:b,k=0,e=a.length;k<e;k++)a[k].nocheck!==!0&&a[k][f]!=a[k].checkedOld&&b.push(a[k]),g.getTreeChangeCheckedNodes(c,a[k][d],b);return b},makeChkFlag:function(c,a){if(a){var b=c.data.key.children,d=c.data.key.checked,f=-1;if(a[b])for(var e=!1,g=0,i=a[b].length;g<i;g++){var m=a[b][g],h=-1;if(c.check.chkStyle==j.radio.STYLE)if(h=m.nocheck===!0?m.check_Child_State:m.halfCheck===!0?2:m.nocheck!==!0&&m[d]?2:m.check_Child_State>0?2:0,h==2){f=2;break}else h==
0&&(f=0);else if(c.check.chkStyle==j.checkbox.STYLE){h=m.nocheck===!0?m.check_Child_State:m.halfCheck===!0?1:m.nocheck!==!0&&m[d]?m.check_Child_State===-1||m.check_Child_State===2?2:1:m.check_Child_State>0?1:0;if(h===1){f=1;break}else if(h===2&&e&&h!==f){f=1;break}else if(f===2&&h>-1&&h<2){f=1;break}else h>-1&&(f=h);e||(e=m.nocheck!==!0)}}a.check_Child_State=f}}}});var o=h.fn.zTree,n=o._z.tools,j=o.consts,e=o._z.view,g=o._z.data;g.exSetting(t);g.addInitBind(function(c){var a=c.treeObj,b=j.event;a.unbind(b.CHECK);
a.bind(b.CHECK,function(a,b,e){n.apply(c.callback.onCheck,[a,b,e])})});g.addInitCache(function(){});g.addInitNode(function(c,a,b,d,f,e){if(b){a=c.data.key.checked;typeof b[a]=="string"&&(b[a]=n.eqs(b[a],"true"));b[a]=!!b[a];b.checkedOld=b[a];b.nocheck=!!b.nocheck||c.check.nocheckInherit&&d&&!!d.nocheck;b.chkDisabled=!!b.chkDisabled||d&&!!d.chkDisabled;if(typeof b.halfCheck=="string")b.halfCheck=n.eqs(b.halfCheck,"true");b.halfCheck=!!b.halfCheck;b.check_Child_State=-1;b.check_Focus=!1;b.getCheckStatus=
function(){return g.getCheckStatus(c,b)};e&&g.makeChkFlag(c,d)}});g.addInitProxy(function(c){var a=c.target,b=g.getSetting(c.data.treeId),d="",f=null,e="",h=null;if(n.eqs(c.type,"mouseover")){if(b.check.enable&&n.eqs(a.tagName,"button")&&a.getAttribute("treeNode"+j.id.CHECK)!==null)d=a.parentNode.id,e="mouseoverCheck"}else if(n.eqs(c.type,"mouseout")){if(b.check.enable&&n.eqs(a.tagName,"button")&&a.getAttribute("treeNode"+j.id.CHECK)!==null)d=a.parentNode.id,e="mouseoutCheck"}else if(n.eqs(c.type,
"click")&&b.check.enable&&n.eqs(a.tagName,"button")&&a.getAttribute("treeNode"+j.id.CHECK)!==null)d=a.parentNode.id,e="checkNode";if(d.length>0)switch(f=g.getNodeCache(b,d),e){case "checkNode":h=p;break;case "mouseoverCheck":h=q;break;case "mouseoutCheck":h=r}return{stop:!1,node:f,nodeEventType:e,nodeEventCallback:h,treeEventType:"",treeEventCallback:null}});g.addInitRoot(function(c){g.getRoot(c).radioCheckedList=[]});g.addBeforeA(function(c,a,b){var d=c.data.key.checked;c.check.enable&&(g.makeChkFlag(c,
a),c.check.chkStyle==j.radio.STYLE&&c.check.radioType==j.radio.TYPE_ALL&&a[d]&&g.getRoot(c).radioCheckedList.push(a),b.push("<button type='button' ID='",a.tId,j.id.CHECK,"' class='",e.makeChkClass(c,a),"' treeNode",j.id.CHECK," onfocus='this.blur();' ",a.nocheck===!0?"style='display:none;'":"","></button>"))});g.addZTreeTools(function(c,a){a.checkNode=function(a,b,g,l){var i=this.setting.data.key.checked;if(a.chkDisabled!==!0&&(b!==!0&&b!==!1&&(b=!a[i]),l=!!l,(a[i]!==b||g)&&!(l&&n.apply(this.setting.callback.beforeCheck,
[this.setting.treeId,a],!0)==!1)&&n.uCanDo(this.setting)&&this.setting.check.enable&&a.nocheck!==!0))a[i]=b,b=h("#"+a.tId+j.id.CHECK),(g||this.setting.check.chkStyle===j.radio.STYLE)&&e.checkNodeRelation(this.setting,a),e.setChkClass(this.setting,b,a),e.repairParentChkClassWithSelf(this.setting,a),l&&c.treeObj.trigger(j.event.CHECK,[c.treeId,a])};a.checkAllNodes=function(a){e.repairAllChk(this.setting,!!a)};a.getCheckedNodes=function(a){var b=this.setting.data.key.children;return g.getTreeCheckedNodes(this.setting,
g.getRoot(c)[b],a!==!1)};a.getChangeCheckedNodes=function(){var a=this.setting.data.key.children;return g.getTreeChangeCheckedNodes(this.setting,g.getRoot(c)[a])};a.setChkDisabled=function(a,b){b=!!b;e.repairSonChkDisabled(this.setting,a,b);b||e.repairParentChkDisabled(this.setting,a,b)};var b=a.updateNode;a.updateNode=function(c,f){b&&b.apply(a,arguments);if(c&&this.setting.check.enable&&h("#"+c.tId).get(0)&&n.uCanDo(this.setting)){var g=h("#"+c.tId+j.id.CHECK);(f==!0||this.setting.check.chkStyle===
j.radio.STYLE)&&e.checkNodeRelation(this.setting,c);e.setChkClass(this.setting,g,c);e.repairParentChkClassWithSelf(this.setting,c)}}});var s=e.createNodes;e.createNodes=function(c,a,b,d){s&&s.apply(e,arguments);b&&e.repairParentChkClassWithSelf(c,d)}})(jQuery);

/*
 * JQuery zTree exedit 3.1
 * http://code.google.com/p/jquerytree/
 *
 * Copyright (c) 2010 Hunter.z (baby666.cn)
 *
 * Licensed same as jquery - MIT License
 * http://www.opensource.org/licenses/mit-license.php
 *
 * email: hunter.z@263.net
 * Date: 2012-02-14
 */
(function(m){var C={onHoverOverNode:function(b,a){var c=o.getSetting(b.data.treeId),j=o.getRoot(c);if(j.curHoverNode!=a)C.onHoverOutNode(b);j.curHoverNode=a;f.addHoverDom(c,a)},onHoverOutNode:function(b){var b=o.getSetting(b.data.treeId),a=o.getRoot(b);if(a.curHoverNode&&!o.isSelectedNode(b,a.curHoverNode))f.removeTreeDom(b,a.curHoverNode),a.curHoverNode=null},onMousedownNode:function(b,a){function c(b){if(z.dragFlag==0&&Math.abs(H-b.clientX)<g.edit.drag.minMoveSize&&Math.abs(I-b.clientY)<g.edit.drag.minMoveSize)return!0;
var a,c,e,l,i;i=g.data.key.children;h.noSel(g);m("body").css("cursor","pointer");if(z.dragFlag==0){if(h.apply(g.callback.beforeDrag,[g.treeId,n],!0)==!1)return j(b),!0;for(a=0,c=n.length;a<c;a++){if(a==0)z.dragNodeShowBefore=[];e=n[a];e.isParent&&e.open?(f.expandCollapseNode(g,e,!e.open),z.dragNodeShowBefore[e.tId]=!0):z.dragNodeShowBefore[e.tId]=!1}z.dragFlag=1;z.showHoverDom=!1;h.showIfameMask(g,!0);e=!0;l=-1;if(n.length>1){var s=n[0].parentTId?n[0].getParentNode()[i]:o.getNodes(g);i=[];for(a=0,
c=s.length;a<c;a++)if(z.dragNodeShowBefore[s[a].tId]!==void 0&&(e&&l>-1&&l+1!==a&&(e=!1),i.push(s[a]),l=a),n.length===i.length){n=i;break}}e&&(C=n[0].getPreNode(),J=n[n.length-1].getNextNode());w=m("<ul class='zTreeDragUL'></ul>");for(a=0,c=n.length;a<c;a++)if(e=n[a],e.editNameFlag=!1,f.selectNode(g,e,a>0),f.removeTreeDom(g,e),l=m("<li id='"+e.tId+"_tmp'></li>"),l.append(m("#"+e.tId+d.id.A).clone()),l.css("padding","0"),l.children("#"+e.tId+d.id.A).removeClass(d.node.CURSELECTED),w.append(l),a==g.edit.drag.maxShowNodeNum-
1){l=m("<li id='"+e.tId+"_moretmp'><a>  ...  </a></li>");w.append(l);break}w.attr("id",n[0].tId+d.id.UL+"_tmp");w.addClass(g.treeObj.attr("class"));w.appendTo("body");u=m("<button class='tmpzTreeMove_arrow'></button>");u.attr("id","zTreeMove_arrow_tmp");u.appendTo("body");g.treeObj.trigger(d.event.DRAG,[g.treeId,n])}if(z.dragFlag==1&&u.attr("id")!=b.target.id){r&&(r.removeClass(d.node.TMPTARGET_TREE),v&&m("#"+v+d.id.A,r).removeClass(d.node.TMPTARGET_NODE));v=r=null;D=!1;k=g;e=o.getSettings();for(var B in e)if(e[B].treeId&&
e[B].edit.enable&&e[B].treeId!=g.treeId&&(b.target.id==e[B].treeId||m(b.target).parents("#"+e[B].treeId).length>0))D=!0,k=e[B];B=x.scrollTop();l=x.scrollLeft();i=k.treeObj.offset();a=k.treeObj.get(0).scrollHeight;e=k.treeObj.get(0).scrollWidth;c=b.clientY+B-i.top;var E=k.treeObj.height()+i.top-b.clientY-B,q=b.clientX+l-i.left,p=k.treeObj.width()+i.left-b.clientX-l;i=c<g.edit.drag.borderMax&&c>g.edit.drag.borderMin;var s=E<g.edit.drag.borderMax&&E>g.edit.drag.borderMin,N=q<g.edit.drag.borderMax&&q>
g.edit.drag.borderMin,G=p<g.edit.drag.borderMax&&p>g.edit.drag.borderMin,E=c>g.edit.drag.borderMin&&E>g.edit.drag.borderMin&&q>g.edit.drag.borderMin&&p>g.edit.drag.borderMin,q=i&&k.treeObj.scrollTop()<=0,p=s&&k.treeObj.scrollTop()+k.treeObj.height()+10>=a,O=N&&k.treeObj.scrollLeft()<=0,P=G&&k.treeObj.scrollLeft()+k.treeObj.width()+10>=e;if(b.target.id&&k.treeObj.find("#"+b.target.id).length>0){for(var A=b.target;A&&A.tagName&&!h.eqs(A.tagName,"li")&&A.id!=k.treeId;)A=A.parentNode;var K=!0;for(a=0,
c=n.length;a<c;a++)if(e=n[a],A.id===e.tId){K=!1;break}else if(m("#"+e.tId).find("#"+A.id).length>0){K=!1;break}if(K&&b.target.id&&(b.target.id==A.id+d.id.A||m(b.target).parents("#"+A.id+d.id.A).length>0))r=m(A),v=A.id}e=n[0];if(E&&(b.target.id==k.treeId||m(b.target).parents("#"+k.treeId).length>0)){if(!r&&(b.target.id==k.treeId||q||p||O||P)&&(D||!D&&e.parentTId))r=k.treeObj;i?k.treeObj.scrollTop(k.treeObj.scrollTop()-10):s&&k.treeObj.scrollTop(k.treeObj.scrollTop()+10);N?k.treeObj.scrollLeft(k.treeObj.scrollLeft()-
10):G&&k.treeObj.scrollLeft(k.treeObj.scrollLeft()+10);r&&r!=k.treeObj&&r.offset().left<k.treeObj.offset().left&&k.treeObj.scrollLeft(k.treeObj.scrollLeft()+r.offset().left-k.treeObj.offset().left)}w.css({top:b.clientY+B+3+"px",left:b.clientX+l+3+"px"});l=a=0;if(r&&r.attr("id")!=k.treeId){var y=v==null?null:o.getNodeCache(k,v);c=b.ctrlKey&&g.edit.drag.isMove&&g.edit.drag.isCopy||!g.edit.drag.isMove&&g.edit.drag.isCopy;a=!!(C&&v===C.tId);i=!!(J&&v===J.tId);l=e.parentTId&&e.parentTId==v;e=(c||!i)&&
h.apply(k.edit.drag.prev,[k.treeId,n,y],!!k.edit.drag.prev);a=(c||!a)&&h.apply(k.edit.drag.next,[k.treeId,n,y],!!k.edit.drag.next);i=(c||!l)&&!(k.data.keep.leaf&&!y.isParent)&&h.apply(k.edit.drag.inner,[k.treeId,n,y],!!k.edit.drag.inner);if(!e&&!a&&!i){if(r=null,v="",t=d.move.TYPE_INNER,u.css({display:"none"}),window.zTreeMoveTimer)clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null}else{c=m("#"+v+d.id.A,r);c.addClass(d.node.TMPTARGET_NODE);l=e?i?0.25:a?0.5:1:-1;i=a?i?0.75:e?0.5:
0:-1;b=(b.clientY+B-c.offset().top)/c.height();(l==1||b<=l&&b>=-0.2)&&e?(a=1-u.width(),l=0-u.height()/2,t=d.move.TYPE_PREV):(i==0||b>=i&&b<=1.2)&&a?(a=1-u.width(),l=c.height()-u.height()/2,t=d.move.TYPE_NEXT):(a=5-u.width(),l=0,t=d.move.TYPE_INNER);u.css({display:"block",top:c.offset().top+l+"px",left:c.offset().left+a+"px"});if(L!=v||M!=t)F=(new Date).getTime();if(y&&y.isParent&&t==d.move.TYPE_INNER&&(b=!0,window.zTreeMoveTimer&&window.zTreeMoveTargetNodeTId!==y.tId?(clearTimeout(window.zTreeMoveTimer),
window.zTreeMoveTargetNodeTId=null):window.zTreeMoveTimer&&window.zTreeMoveTargetNodeTId===y.tId&&(b=!1),b))window.zTreeMoveTimer=setTimeout(function(){t==d.move.TYPE_INNER&&y&&y.isParent&&!y.open&&(new Date).getTime()-F>k.edit.drag.autoOpenTime&&h.apply(k.callback.beforeDragOpen,[k.treeId,y],!0)&&(f.switchNode(k,y),k.edit.drag.autoExpandTrigger&&k.treeObj.trigger(d.event.EXPAND,[k.treeId,y]))},k.edit.drag.autoOpenTime+50),window.zTreeMoveTargetNodeTId=y.tId}}else if(t=d.move.TYPE_INNER,r&&h.apply(k.edit.drag.inner,
[k.treeId,n,null],!!k.edit.drag.inner)?r.addClass(d.node.TMPTARGET_TREE):r=null,u.css({display:"none"}),window.zTreeMoveTimer)clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null;L=v;M=t}return!1}function j(b){if(window.zTreeMoveTimer)clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null;M=L=null;x.unbind("mousemove",c);x.unbind("mouseup",j);x.unbind("selectstart",e);m("body").css("cursor","auto");r&&(r.removeClass(d.node.TMPTARGET_TREE),v&&m("#"+v+d.id.A,r).removeClass(d.node.TMPTARGET_NODE));
h.showIfameMask(g,!1);z.showHoverDom=!0;if(z.dragFlag!=0){z.dragFlag=0;var a,l,i;for(a=0,l=n.length;a<l;a++)i=n[a],i.isParent&&z.dragNodeShowBefore[i.tId]&&!i.open&&(f.expandCollapseNode(g,i,!i.open),delete z.dragNodeShowBefore[i.tId]);w&&w.remove();u&&u.remove();var q=b.ctrlKey&&g.edit.drag.isMove&&g.edit.drag.isCopy||!g.edit.drag.isMove&&g.edit.drag.isCopy;!q&&r&&v&&n[0].parentTId&&v==n[0].parentTId&&t==d.move.TYPE_INNER&&(r=null);if(r){var p=v==null?null:o.getNodeCache(k,v);if(h.apply(g.callback.beforeDrop,
[k.treeId,n,p,t],!0)!=!1){var s=q?h.clone(n):n,b=function(){if(D){if(!q)for(var b=0,a=n.length;b<a;b++)f.removeNode(g,n[b]);if(t==d.move.TYPE_INNER)f.addNodes(k,p,s);else if(f.addNodes(k,p.getParentNode(),s),t==d.move.TYPE_PREV)for(b=0,a=s.length;b<a;b++)f.moveNode(k,p,s[b],t,!1);else for(b=-1,a=s.length-1;b<a;a--)f.moveNode(k,p,s[a],t,!1)}else if(q&&t==d.move.TYPE_INNER)f.addNodes(k,p,s);else if(q&&f.addNodes(k,p.getParentNode(),s),t==d.move.TYPE_PREV)for(b=0,a=s.length;b<a;b++)f.moveNode(k,p,s[b],
t,!1);else for(b=-1,a=s.length-1;b<a;a--)f.moveNode(k,p,s[a],t,!1);for(b=0,a=s.length;b<a;b++)f.selectNode(k,s[b],b>0);m("#"+s[0].tId+d.id.ICON).focus().blur()};t==d.move.TYPE_INNER&&h.canAsync(k,p)?f.asyncNode(k,p,!1,b):b();g.treeObj.trigger(d.event.DROP,[k.treeId,s,p,t])}}else{for(a=0,l=n.length;a<l;a++)f.selectNode(k,n[a],a>0);g.treeObj.trigger(d.event.DROP,[g.treeId,null,null,null])}}}function e(){return!1}var l,i,g=o.getSetting(b.data.treeId),z=o.getRoot(g);if(b.button==2||!g.edit.enable||!g.edit.drag.isCopy&&
!g.edit.drag.isMove)return!0;var p=b.target,q=o.getRoot(g).curSelectedList,n=[];if(o.isSelectedNode(g,a))for(l=0,i=q.length;l<i;l++){if(q[l].editNameFlag&&h.eqs(p.tagName,"input")&&p.getAttribute("treeNode"+d.id.INPUT)!==null)return!0;n.push(q[l]);if(n[0].parentTId!==q[l].parentTId){n=[a];break}}else n=[a];f.editNodeBlur=!0;f.cancelCurEditNode(g,null,!0);var x=m(document),w,u,r,D=!1,k=g,C,J,L=null,M=null,v=null,t=d.move.TYPE_INNER,H=b.clientX,I=b.clientY,F=(new Date).getTime();h.uCanDo(g)&&x.bind("mousemove",
c);x.bind("mouseup",j);x.bind("selectstart",e);b.preventDefault&&b.preventDefault();return!0}},p={tools:{getAbs:function(b){b=b.getBoundingClientRect();return[b.left,b.top]},inputFocus:function(b){b.get(0)&&(b.focus(),h.setCursorPosition(b.get(0),b.val().length))},inputSelect:function(b){b.get(0)&&(b.focus(),b.select())},setCursorPosition:function(b,a){if(b.setSelectionRange)b.focus(),b.setSelectionRange(a,a);else if(b.createTextRange){var c=b.createTextRange();c.collapse(!0);c.moveEnd("character",
a);c.moveStart("character",a);c.select()}},showIfameMask:function(b,a){for(var c=o.getRoot(b);c.dragMaskList.length>0;)c.dragMaskList[0].remove(),c.dragMaskList.shift();if(a)for(var j=m("iframe"),e=0,d=j.length;e<d;e++){var f=j.get(e),g=h.getAbs(f),f=m("<div id='zTreeMask_"+e+"' class='zTreeMask' style='background-color:yellow;opacity: 0.3;filter: alpha(opacity=30);    top:"+g[1]+"px; left:"+g[0]+"px; width:"+f.offsetWidth+"px; height:"+f.offsetHeight+"px;'></div>");f.appendTo("body");c.dragMaskList.push(f)}}},
view:{addEditBtn:function(b,a){if(!(a.editNameFlag||m("#"+a.tId+d.id.EDIT).length>0)&&h.apply(b.edit.showRenameBtn,[b.treeId,a],b.edit.showRenameBtn)){var c=m("#"+a.tId+d.id.A),j="<button type='button' class='edit' id='"+a.tId+d.id.EDIT+"' title='"+h.apply(b.edit.renameTitle,[b.treeId,a],b.edit.renameTitle)+"' treeNode"+d.id.EDIT+" onfocus='this.blur();' style='display:none;'></button>";c.append(j);m("#"+a.tId+d.id.EDIT).bind("click",function(){if(!h.uCanDo(b)||h.apply(b.callback.beforeEditName,[b.treeId,
a],!0)==!1)return!0;f.editNode(b,a);return!1}).show()}},addRemoveBtn:function(b,a){if(!(a.editNameFlag||m("#"+a.tId+d.id.REMOVE).length>0)&&h.apply(b.edit.showRemoveBtn,[b.treeId,a],b.edit.showRemoveBtn)){var c=m("#"+a.tId+d.id.A),j="<button type='button' class='remove' id='"+a.tId+d.id.REMOVE+"' title='"+h.apply(b.edit.removeTitle,[b.treeId,a],b.edit.removeTitle)+"' treeNode"+d.id.REMOVE+" onfocus='this.blur();' style='display:none;'></button>";c.append(j);m("#"+a.tId+d.id.REMOVE).bind("click",function(){if(!h.uCanDo(b)||
h.apply(b.callback.beforeRemove,[b.treeId,a],!0)==!1)return!0;f.removeNode(b,a);b.treeObj.trigger(d.event.REMOVE,[b.treeId,a]);return!1}).bind("mousedown",function(){return!0}).show()}},addHoverDom:function(b,a){if(o.getRoot(b).showHoverDom)a.isHover=!0,b.edit.enable&&(f.addEditBtn(b,a),f.addRemoveBtn(b,a)),h.apply(b.view.addHoverDom,[b.treeId,a])},cancelCurEditNode:function(b,a){var c=o.getRoot(b),j=b.data.key.name,e=c.curEditNode;if(e){var l=c.curEditInput,i=a?a:l.val();if(!a&&h.apply(b.callback.beforeRename,
[b.treeId,e,i],!0)===!1)return e.editNameFlag=!0,!1;else e[j]=i?i:l.val(),a||b.treeObj.trigger(d.event.RENAME,[b.treeId,e]);m("#"+e.tId+d.id.A).removeClass(d.node.CURSELECTED_EDIT);l.unbind();f.setNodeName(b,e);e.editNameFlag=!1;c.curEditNode=null;c.curEditInput=null;f.selectNode(b,e,!1)}return c.noSelection=!0},editNode:function(b,a){var c=o.getRoot(b);f.editNodeBlur=!1;if(o.isSelectedNode(b,a)&&c.curEditNode==a&&a.editNameFlag)setTimeout(function(){h.inputFocus(c.curEditInput)},0);else{var j=b.data.key.name;
a.editNameFlag=!0;f.removeTreeDom(b,a);f.cancelCurEditNode(b);f.selectNode(b,a,!1);m("#"+a.tId+d.id.SPAN).html("<input type=text class='rename' id='"+a.tId+d.id.INPUT+"' treeNode"+d.id.INPUT+" >");var e=m("#"+a.tId+d.id.INPUT);e.attr("value",a[j]);b.edit.editNameSelectAll?h.inputSelect(e):h.inputFocus(e);e.bind("blur",function(){f.editNodeBlur||f.cancelCurEditNode(b)}).bind("keydown",function(c){c.keyCode=="13"?(f.editNodeBlur=!0,f.cancelCurEditNode(b,null,!0)):c.keyCode=="27"&&f.cancelCurEditNode(b,
a[j])}).bind("click",function(){return!1}).bind("dblclick",function(){return!1});m("#"+a.tId+d.id.A).addClass(d.node.CURSELECTED_EDIT);c.curEditInput=e;c.noSelection=!1;c.curEditNode=a}},moveNode:function(b,a,c,j,e,l){var i=o.getRoot(b),g=b.data.key.children;if(a!=c&&(!b.data.keep.leaf||!a||a.isParent||j!=d.move.TYPE_INNER)){var h=c.parentTId?c.getParentNode():i,p=a===null||a==i;p&&a===null&&(a=i);if(p)j=d.move.TYPE_INNER;i=a.parentTId?a.getParentNode():i;if(j!=d.move.TYPE_PREV&&j!=d.move.TYPE_NEXT)j=
d.move.TYPE_INNER;var q,n;p?n=q=b.treeObj:l||(j==d.move.TYPE_INNER?f.expandCollapseNode(b,a,!0,!1):f.expandCollapseNode(b,a.getParentNode(),!0,!1),q=m("#"+a.tId),n=m("#"+a.tId+d.id.UL));var x=m("#"+c.tId).remove();n&&j==d.move.TYPE_INNER?n.append(x):q&&j==d.move.TYPE_PREV?q.before(x):q&&j==d.move.TYPE_NEXT&&q.after(x);var w=-1,u=0,r=null;q=null;var C=c.level;if(c.isFirstNode){if(w=0,h[g].length>1)r=h[g][1],r.isFirstNode=!0}else if(c.isLastNode)w=h[g].length-1,r=h[g][w-1],r.isLastNode=!0;else for(n=
0,x=h[g].length;n<x;n++)if(h[g][n].tId==c.tId){w=n;break}w>=0&&h[g].splice(w,1);if(j!=d.move.TYPE_INNER)for(n=0,x=i[g].length;n<x;n++)i[g][n].tId==a.tId&&(u=n);if(j==d.move.TYPE_INNER){p?c.parentTId=null:(a.isParent=!0,a.open=!1,c.parentTId=a.tId);a[g]||(a[g]=[]);if(a[g].length>0)q=a[g][a[g].length-1],q.isLastNode=!1;a[g].splice(a[g].length,0,c);c.isLastNode=!0;c.isFirstNode=a[g].length==1}else a.isFirstNode&&j==d.move.TYPE_PREV?(i[g].splice(u,0,c),q=a,q.isFirstNode=!1,c.parentTId=a.parentTId,c.isFirstNode=
!0,c.isLastNode=!1):a.isLastNode&&j==d.move.TYPE_NEXT?(i[g].splice(u+1,0,c),q=a,q.isLastNode=!1,c.parentTId=a.parentTId,c.isFirstNode=!1,c.isLastNode=!0):(j==d.move.TYPE_PREV?i[g].splice(u,0,c):i[g].splice(u+1,0,c),c.parentTId=a.parentTId,c.isFirstNode=!1,c.isLastNode=!1);o.fixPIdKeyValue(b,c);o.setSonNodeLevel(b,c.getParentNode(),c);f.setNodeLineIcos(b,c);f.repairNodeLevelClass(b,c,C);!b.data.keep.parent&&h[g].length<1?(h.isParent=!1,h.open=!1,a=m("#"+h.tId+d.id.UL),j=m("#"+h.tId+d.id.SWITCH),g=
m("#"+h.tId+d.id.ICON),f.replaceSwitchClass(h,j,d.folder.DOCU),f.replaceIcoClass(h,g,d.folder.DOCU),a.css("display","none")):r&&f.setNodeLineIcos(b,r);q&&f.setNodeLineIcos(b,q);b.check.enable&&f.repairChkClass&&(f.repairChkClass(b,h),f.repairParentChkClassWithSelf(b,h),h!=c.parent&&f.repairParentChkClassWithSelf(b,c));l||f.expandCollapseParentNode(b,c.getParentNode(),!0,e)}},removeChildNodes:function(b,a){if(a){var c=b.data.key.children,j=a[c];if(j){m("#"+a.tId+d.id.UL).remove();for(var e=0,l=j.length;e<
l;e++)o.removeNodeCache(b,j[e]);o.removeSelectedNode(b);delete a[c];if(!b.data.keep.parent)a.isParent=!1,a.open=!1,c=m("#"+a.tId+d.id.SWITCH),j=m("#"+a.tId+d.id.ICON),f.replaceSwitchClass(a,c,d.folder.DOCU),f.replaceIcoClass(a,j,d.folder.DOCU)}}},removeEditBtn:function(b){m("#"+b.tId+d.id.EDIT).unbind().remove()},removeNode:function(b,a){var c=o.getRoot(b),j=b.data.key.children,e=a.parentTId?a.getParentNode():c;if(c.curEditNode===a)c.curEditNode=null;a.isFirstNode=!1;a.isLastNode=!1;a.getPreNode=
function(){return null};a.getNextNode=function(){return null};m("#"+a.tId).remove();o.removeNodeCache(b,a);o.removeSelectedNode(b,a);for(var l=0,i=e[j].length;l<i;l++)if(e[j][l].tId==a.tId){e[j].splice(l,1);break}var g;if(!b.data.keep.parent&&e[j].length<1)e.isParent=!1,e.open=!1,l=m("#"+e.tId+d.id.UL),i=m("#"+e.tId+d.id.SWITCH),g=m("#"+e.tId+d.id.ICON),f.replaceSwitchClass(e,i,d.folder.DOCU),f.replaceIcoClass(e,g,d.folder.DOCU),l.css("display","none");else if(b.view.showLine&&e[j].length>0){var h=
e[j][e[j].length-1];h.isLastNode=!0;h.isFirstNode=e[j].length==1;l=m("#"+h.tId+d.id.UL);i=m("#"+h.tId+d.id.SWITCH);g=m("#"+h.tId+d.id.ICON);e==c?e[j].length==1?f.replaceSwitchClass(h,i,d.line.ROOT):(c=m("#"+e[j][0].tId+d.id.SWITCH),f.replaceSwitchClass(e[j][0],c,d.line.ROOTS),f.replaceSwitchClass(h,i,d.line.BOTTOM)):f.replaceSwitchClass(h,i,d.line.BOTTOM);l.removeClass(d.line.LINE)}},removeRemoveBtn:function(b){m("#"+b.tId+d.id.REMOVE).unbind().remove()},removeTreeDom:function(b,a){a.isHover=!1;f.removeEditBtn(a);
f.removeRemoveBtn(a);h.apply(b.view.removeHoverDom,[b.treeId,a])},repairNodeLevelClass:function(b,a,c){if(c!==a.level){var b=m("#"+a.tId),j=m("#"+a.tId+d.id.A),e=m("#"+a.tId+d.id.UL),c="level"+c,a="level"+a.level;b.removeClass(c);b.addClass(a);j.removeClass(c);j.addClass(a);e.removeClass(c);e.addClass(a)}}},event:p,data:{setSonNodeLevel:function(b,a,c){if(c){var d=b.data.key.children;c.level=a?a.level+1:0;if(c[d])for(var a=0,e=c[d].length;a<e;a++)c[d][a]&&o.setSonNodeLevel(b,c,c[d][a])}}}};m.extend(!0,
m.fn.zTree.consts,{event:{DRAG:"ztree_drag",DROP:"ztree_drop",REMOVE:"ztree_remove",RENAME:"ztree_rename"},id:{EDIT:"_edit",INPUT:"_input",REMOVE:"_remove"},move:{TYPE_INNER:"inner",TYPE_PREV:"prev",TYPE_NEXT:"next"},node:{CURSELECTED_EDIT:"curSelectedNode_Edit",TMPTARGET_TREE:"tmpTargetzTree",TMPTARGET_NODE:"tmpTargetNode"}});m.extend(!0,m.fn.zTree._z,p);var p=m.fn.zTree,h=p._z.tools,d=p.consts,f=p._z.view,o=p._z.data,p=p._z.event;o.exSetting({edit:{enable:!1,editNameSelectAll:!1,showRemoveBtn:!0,
showRenameBtn:!0,removeTitle:"remove",renameTitle:"rename",drag:{autoExpandTrigger:!1,isCopy:!0,isMove:!0,prev:!0,next:!0,inner:!0,minMoveSize:5,borderMax:10,borderMin:-5,maxShowNodeNum:5,autoOpenTime:500}},view:{addHoverDom:null,removeHoverDom:null},callback:{beforeDrag:null,beforeDragOpen:null,beforeDrop:null,beforeEditName:null,beforeRemove:null,beforeRename:null,onDrag:null,onDrop:null,onRemove:null,onRename:null}});o.addInitBind(function(b){var a=b.treeObj,c=d.event;a.unbind(c.RENAME);a.bind(c.RENAME,
function(a,c,d){h.apply(b.callback.onRename,[a,c,d])});a.unbind(c.REMOVE);a.bind(c.REMOVE,function(a,c,d){h.apply(b.callback.onRemove,[a,c,d])});a.unbind(c.DRAG);a.bind(c.DRAG,function(a,c,d){h.apply(b.callback.onDrag,[a,c,d])});a.unbind(c.DROP);a.bind(c.DROP,function(a,c,d,f,g){h.apply(b.callback.onDrop,[a,c,d,f,g])})});o.addInitCache(function(){});o.addInitNode(function(b,a,c){if(c)c.isHover=!1,c.editNameFlag=!1});o.addInitProxy(function(b){var a=b.target,c=o.getSetting(b.data.treeId),f=b.relatedTarget,
e="",l=null,i="",g=null,m=null;if(h.eqs(b.type,"mouseover")){if(m=h.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+d.id.A}]))e=m.parentNode.id,i="hoverOverNode"}else if(h.eqs(b.type,"mouseout"))m=h.getMDom(c,f,[{tagName:"a",attrName:"treeNode"+d.id.A}]),m||(e="remove",i="hoverOutNode");else if(h.eqs(b.type,"mousedown")&&(m=h.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+d.id.A}])))e=m.parentNode.id,i="mousedownNode";if(e.length>0)switch(l=o.getNodeCache(c,e),i){case "mousedownNode":g=C.onMousedownNode;
break;case "hoverOverNode":g=C.onHoverOverNode;break;case "hoverOutNode":g=C.onHoverOutNode}return{stop:!1,node:l,nodeEventType:i,nodeEventCallback:g,treeEventType:"",treeEventCallback:null}});o.addInitRoot(function(b){b=o.getRoot(b);b.curEditNode=null;b.curEditInput=null;b.curHoverNode=null;b.dragFlag=0;b.dragNodeShowBefore=[];b.dragMaskList=[];b.showHoverDom=!0});o.addZTreeTools(function(b,a){a.addNodes=function(a,d,e){function l(){f.addNodes(b,a,i,e==!0)}if(!d)return null;a||(a=null);if(a&&!a.isParent&&
b.data.keep.leaf)return null;var i=h.clone(h.isArray(d)?d:[d]);b.async.enable&&h.canAsync(b,a)?f.asyncNode(b,a,e,l):l();return i};a.cancelEditName=function(a){var d=o.getRoot(b),e=b.data.key.name,h=d.curEditNode;d.curEditNode&&f.cancelCurEditNode(b,a?a:h[e])};a.copyNode=function(a,j,e,l){if(!j)return null;if(a&&!a.isParent&&b.data.keep.leaf&&e===d.move.TYPE_INNER)return null;var i=h.clone(j);if(!a)a=null,e=d.move.TYPE_INNER;e==d.move.TYPE_INNER?(j=function(){f.addNodes(b,a,[i],l)},b.async.enable&&
h.canAsync(b,a)?f.asyncNode(b,a,l,j):j()):(f.addNodes(b,a.parentNode,[i],l),f.moveNode(b,a,i,e,!1,l));return i};a.editName=function(a){a&&a.tId&&a===o.getNodeCache(b,a.tId)&&(a.parentTId&&f.expandCollapseParentNode(b,a.getParentNode(),!0),f.editNode(b,a))};a.moveNode=function(a,j,e,l){function i(){f.moveNode(b,a,j,e,!1,l)}if(!j)return j;if(a&&!a.isParent&&b.data.keep.leaf&&e===d.move.TYPE_INNER)return null;else if(a&&(j.parentTId==a.tId&&e==d.move.TYPE_INNER||m("#"+j.tId).find("#"+a.tId).length>0))return null;
else a||(a=null);b.async.enable&&h.canAsync(b,a)?f.asyncNode(b,a,l,i):i();return j};a.removeNode=function(a,j){a&&(j=!!j,j&&h.apply(b.callback.beforeRemove,[b.treeId,a],!0)==!1||(f.removeNode(b,a),j&&this.setting.treeObj.trigger(d.event.REMOVE,[b.treeId,a])))};a.removeChildNodes=function(a){if(!a)return null;var d=a[b.data.key.children];f.removeChildNodes(b,a);return d?d:null};a.setEditable=function(a){b.edit.enable=a;return this.refresh()}});var H=f.cancelPreSelectedNode;f.cancelPreSelectedNode=
function(b,a){for(var c=o.getRoot(b).curSelectedList,d=0,e=c.length;d<e;d++)if(!a||a===c[d])if(f.removeTreeDom(b,c[d]),a)break;H&&H.apply(f,arguments)};var I=f.createNodes;f.createNodes=function(b,a,c,d){I&&I.apply(f,arguments);c&&f.repairParentChkClassWithSelf&&f.repairParentChkClassWithSelf(b,d)};f.makeNodeUrl=function(b,a){return a.url&&!b.edit.enable?a.url:null};var F=f.selectNode;f.selectNode=function(b,a,c){var d=o.getRoot(b);if(o.isSelectedNode(b,a)&&d.curEditNode==a&&a.editNameFlag)return!1;
F&&F.apply(f,arguments);f.addHoverDom(b,a);return!0};var G=h.uCanDo;h.uCanDo=function(b,a){var c=o.getRoot(b);return a&&(h.eqs(a.type,"mouseover")||h.eqs(a.type,"mouseout")||h.eqs(a.type,"mousedown")||h.eqs(a.type,"mouseup"))?!0:!c.curEditNode&&(G?G.apply(f,arguments):!0)}})(jQuery);

//multiselect.js
(function(a){a.fn.multiSelect=function(h,k){k=a.extend({keepSelected:false,autoSubmit:true,button_select:null,button_select_all:null,button_deselect:null,button_deselect_all:null,autoSort:true,sortType:"value",sortDesc:false,beforeMove:null,afterMove:null},k);var f=this;var g=a(h);if(k.autoSubmit){this.parents("form").submit(function(){b(g)})}var d=function(o,q,p){var l=p?-1:1;if(typeof q=="function"){var n=q}else{if(q=="key"){var n=function(s,r){return l*((r.value<s.value)-(s.value<r.value))}}else{var n=function(s,r){return l*((a(r).text()<a(s).text())-(a(s).text()<a(r).text()))}}}var m=a.makeArray(a("option",o).detach()).sort(n);a(o).append(m)};var j=function(l){if(!k.autoSort){return}d(l,k.sortType,k.sortDesc)};j(f);j(g);var i=function(n,m,l){e(n,m,l,k.beforeMove,k.afterMove,j)};var c=function(m,l){if(k.beforeMove&&!k.beforeMove(m,h,"all")){return}a("option",m).attr("selected","selected");i(m,l);j(h);k.afterMove&&k.afterMove(m,h,"all")};f.dblclick(function(){i(f,g,"select")});if(k.button_select){a(k.button_select).click(function(){i(f,g,"select")})}if(k.button_select_all){a(k.button_select_all).click(function(){c(f,g)})}g.dblclick(function(){i(g,f,"deselect")});if(k.button_deselect){a(k.button_deselect).click(function(){i(g,f,"deselect")})}if(k.button_deselect_all){a(k.button_deselect_all).click(function(){c(g,f)})}return this;function e(q,p,n,o,m,l){if(o&&!o(q,p,n)){return}a("option:selected",q).each(function(){a(this).appendTo(p)});l(p);m&&m(q,p,n)}function b(l){l.children("option").each(function(){this.selected=true})}}})(jQuery);

//core.js
String.prototype.endWith = function (s) {
    if (s == null || s == "" || this.length == 0 || s.length > this.length) {
        return false;
    }
    if (this.substring(this.length - s.length) == s) {
        return true;
    }
    else {
        return false;
    }
    return true;
};

String.prototype.startWith = function (s) {
    if (s == null || s == "" || this.length == 0 || s.length > this.length) {
        return false;
    }
    if (this.substr(0, s.length) == s) {
        return true;
    }
    else {
        return false;
    }
    return true;
};

String.prototype.toValidJson = function () {
    var v = this;
    if (v != undefined && v != null && v != "") {
        //v = v.toString().replace(new RegExp('(["\"])', 'g'), "\\\"");
        //v = v.replace(/[\r\n]/g, "");
        //v = v.replace("\n", "");
        //v = v.replaceAll("'", "&#39;");
        //v = v.replaceAll('\\\\', '\\\\');
        v = escape(v);
    }
    return v;
};

String.prototype.replaceAll = function (reallyDo, replaceWith, ignoreCase) {
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi" : "g")), replaceWith);
    } else {
        return this.replace(reallyDo, replaceWith);
    }
};

/*
* 检测数组中是否包含与指定值相同的单元
* 成功则返回值相同的第一个位置，没有相同的则返回false
*/
Array.prototype.contain = function (_val) {
    if (this.length <= 0) return false;
    for (var i = 0; i < this.length; i++) {
        if (this[i] == _val) return i;
    }
    return false;
};

// 清空数组
Array.prototype.clear = function () {
    this.splice(0, this.length);
};
jQuery.csCore = {
    PAGE_INDEX_KEY: "pageindex",
    PAGE_SIZE_KEY: "pagesize",
    loadPath: function (id) {
        var dict = $.csCore.getDictByID(id);
        if ($.csValidator.isNull($("#path").html())) {
            $("#path").html(dict.name);
        } else {
            $("#path").html(dict.name + ">>" + $("#path").html());
        }

        if (dict.parentID != "0") {
            $.csCore.loadPath(dict.parentID);
        }
    },
    getMemberByID: function (id) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/member/getmemberbyid'), $.csControl.appendKeyValue("", "id", id));
    },
    getCashByMemberByID: function (pubmemberid) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/member/getcashbymemberid'), $.csControl.appendKeyValue("", "pubmemberid", pubmemberid));
    },
    getDiscountByID: function (id) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/bldiscount/GetDiscountByID'), $.csControl.appendKeyValue("", "ID", id));
    },
    isInRole: function (id) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/groupmenu/isinrole'), $.csControl.appendKeyValue("", "id", id));
    },
    isJSON: function (obj) {
        var isjson = typeof (obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]";
        return isjson;
    },
    addValueLine: function (viewID) {
        this.getViewElements(viewID).addClass('value');
    },
    buildServicePath: function (servicePath) {
        return SERVICE_ROOT + servicePath;
    },
    isAdmin: function () {
        return this.invoke(this.buildServicePath('/service/core/isadmin'));
    },
    signOut: function () {
        $.csCore.confirm($.csCore.getValue('Common_ExitConfirm'), "$.csCore.signOutRemote()");
    },
    signOutRemote: function () {
    	$.cookie("fashiontype", "");
        var data = this.invoke(this.buildServicePath('/service/member/signout'));
        if (!$.csValidator.isNull(data)) {
            if (data.toUpperCase() == "OK") {
                document.location.href = "../common/login.jsp";
            }
        }
    },
    getVersions: function () {
        return this.invoke(this.buildServicePath('/service/dict/getversions'));
    },
    getCurrentVersion:function(){
    	return this.invoke(this.buildServicePath('/service/core/getcurrentversion'));
    },
    contain: function (a, b) {
        a = "," + a + ",";
        b = "," + b + ",";
        if (a.indexOf(b) > -1) {
            return true;
        }
        return false;
    },
    getImageHeight: function (url) {
        var theimage = new image();
        theimage.src = url;
        return theimage.height;
    },
    setPageTitle: function (page, title) {
        page.title = title;
    },
    getDictResourceName: function (dictID) {
        return "Dict_" + dictID;
    },
    pickUser: function (controlID, controlText, isMultiple, groupID) {
        $.csCore.loadModal('../member/pick.jsp', 600, 370, function () { $.csMemberPick.init(controlID, controlText, isMultiple, groupID); });
    },
    autoCompleteUsername: function (input, isMultiple) {
        if (isMultiple == "undefined" || isMultiple == null || isMultiple == "") {
            isMultiple = false;
        }
        var url = $.csCore.buildServicePath('/service/member/getmemberbykeyword');
        $("#" + input).autocomplete(url, {
            multiple: isMultiple,
            dataType: "json",
            parse: function (data) {
                return $.map(data, function (row) {
                    return {
                        data: row,
                        value: row.ID,
                        result: row.username
                    };
                });
            },
            formatItem: function (item) {
                return item.username + "(" + item.name + ")";
            }
        }).result(function (e, data) {

        });
    },
    postData: function (url, form) {
        flag = false;
        var formData = $.csControl.getFormData(form);
        //alert(JSON.stringify(formData));
        var data = this.invoke(url, formData);
        if (!$.csValidator.isNull(data)) {
            if (data.toUpperCase() == "OK") {
                flag = true;
                $('#' + form).resetForm();
            }
            else {
                $.csCore.alert(data);
            }
        }else{
        	$.csCore.alert(data);
        }
        return flag;
    },
    getData: function (url) {
        url = encodeURI(url);
        var d = "";
        $.ajax({
            url: url,
            async: false,
            cache: false,
            success: function (data, textStatus, jqXHR) {
                d = data;
            },
            error: function (jqXHR, textStatus, errorThrown) {
                d = "error:" + jqXHR.responseText;
            }
        });
        if (IS_NET == true) {
            d = JSON.stringify(d);
            d = escape(d);
            d = JSON.parse(d);
        } else {
            try {
                d = JSON.parse(d);
            }
            catch (e) { }
        }
        return d;
    },
    invoke: function (url, formData,nameid) {
        var d = "";
        if ($.csValidator.isNull(formData)) {
            formData = "{}";
        }
        if ($.csValidator.isNull(nameid)) {
        	 if (IS_NET == true) {
                 var param = '{"formData":"' + formData + '"}';
                 $.ajax({
                     url: url,
                     data: param,
                     type: 'post',
                     dataType: 'json',
                     async: false,
                     contentType: "application/json;charset=utf-8;",
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                     },
                     error: function (xhr) {
                         d = xhr;
                     }
                 });

             } else {
                 $.ajax({
                     url: url,
                     data: { formData: formData },
                     type: "post",
                     dataType: "json",
                     async: false,
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                     },
                     error: function (xhr) {
                         d = xhr.responseText;
                     }
                 });
             }
        	 if (IS_NET == true) {
                 d = JSON.stringify(d);
                 d = $.csCore.utf8ToGb2312(d);
                 var from = d.indexOf(":") + 1;
                 d = d.substring(from, d.length - 1);
                 if (d.substring(0, 1) == "\"") {
                     d = d.substring(1, d.length - 1);
                 } else {
                     try {
                         d = JSON.parse(d);
                     }
                     catch (e) { }
                     return d;
                 }
             } else {
                 try {

                     d = JSON.parse(d);
                 }
                 catch (e) { }
             }
             return d;
        }else{
        	 if (IS_NET == true) {
                 var param = '{"formData":"' + formData + '"}';
                 $.ajax({
                     url: url,
                     data: param,
                     type: 'post',
                     dataType: 'json',
                     contentType: "application/json;charset=utf-8;",
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                       $(nameid).html(d);
                     },
                     error: function (xhr) {
                         d = xhr;
                     }
                 });

             } else {
                 $.ajax({
                     url: url,
                     data: { formData: formData },
                     type: "post",
                     dataType: "json",
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                         $(nameid).html(d);
                     },
                     error: function (xhr) {
                         d = xhr.responseText;
                     }
                 });
             }
        }
    },
    getDicts: function (categoryID) {
        var datas = this.invoke(this.buildServicePath('/service/dict/getdicts'), $.csControl.appendKeyValue("", "categoryid", categoryID));
        return datas;
    },
    getDictsByParent: function (categoryID, parentID) {
        var param = $.csControl.appendKeyValue("", "categoryid", categoryID);
        param = $.csControl.appendKeyValue(param, "parentid", parentID);
        var datas = this.invoke(this.buildServicePath('/service/dict/getdictsbyparent'), param);
        return datas;
    },
    getAllDicts: function (parentID) {
        var datas = this.invoke(this.buildServicePath('/service/dict/getalldicts'), $.csControl.appendKeyValue("", "parentid", parentID));
        return datas;
    },
    getNextDicts: function (parentID) {
        var datas = this.invoke(this.buildServicePath('/service/dict/getnextdicts'), $.csControl.appendKeyValue("", "parentid", parentID));
        return datas;
    },
    getDictByID: function (dictID) {
        var dict = this.invoke(this.buildServicePath('/service/dict/getdictbyid'), $.csControl.appendKeyValue("", "id", dictID));
        return dict;
    },
    getValue: function (name1, name2,nameid) {
        if ($.csValidator.isNull(name1)) {
            alert("param is required");
            return false;
        }
        var param = "";
        param = $.csControl.appendKeyValue(param, "name1", name1);
        if (!$.csValidator.isNull(name2)) {
            param = $.csControl.appendKeyValue(param, "name2", name2);
        }
        return this.invoke(this.buildServicePath('/service/core/getvalue'), param,nameid);
    },
    getCurrentMember: function () {
        return this.invoke(this.buildServicePath('/service/member/getcurrentmember'));
    },
    getBlDealItems: function () {
    	param = $.csControl.appendKeyValue("", "from", "BlAddDeal.js");
        var datas = this.invoke(this.buildServicePath('/service/blcash/GetDealItems'), param);
        return datas;
    },
    getBlDealItemByID: function (ID) {
        var dealItem = this.invoke(this.buildServicePath('/service/blcash/GetDealItemByID'), $.csControl.appendKeyValue("", "ID", ID));
        return dealItem;
    },
    removeData: function (url, removedIDs) {
        if (removedIDs == null || removedIDs == "") {
            this.alert($.csCore.getValue('Common_PleaseSelect', 'Common_ForRemoved'));
            return false;
        }
        this.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csCore.removeRemote('" + url + "','" + removedIDs + "')");
    },
    removeRemote: function (url, removedIDs) {
        var param = $.csControl.appendKeyValue("", "removedIDs", removedIDs);
        var data = $.csCore.invoke(url, param);
        if (data != null) {
            if (data == "OK") {
                removedIDs = removedIDs.split(',');
                for (var i = 0; i <= removedIDs.length - 1; i++) {
                    $('#row' + removedIDs[i]).remove();
                }
            }
            else {
                $.csCore.alert(data);
            }
        }
    },
    initPagination: function (divPagination, nCount, nPageSize, getPagingData) {
        var prev_text = $.csCore.getValue('Common_Prev');
        var next_text = $.csCore.getValue('Common_Next');
        var total = $.csCore.getValue("Common_Total");
        var item_unit = $.csCore.getValue("Common_ItemUnit");
        var item_per_page = $.csCore.getValue("Common_ItemPerPage");

        $("#" + divPagination).pagination(nCount, {
            callback: getPagingData,
            items_per_page: nPageSize,
            prev_text: prev_text,
            next_text: next_text
        });
        $('#' + divPagination.replaceAll("Pagination", "") + 'Statistic').html(total + nCount + item_unit + "," + nPageSize + item_per_page);

    },
    processList: function (moduler, data) {
        $('#' + moduler + 'Result').setTemplateElement(moduler + 'Template', null, { filter_data: false });
        if (data.data != null) {
            $('#' + moduler + 'Result').processTemplate(data);
        }
        else {
            $('#' + moduler + 'Result').processTemplate({ data: data });
        }
        var result = $('#' + moduler + 'Result').html().replaceAll("null", "", true).replaceAll("00:00:00.0", "", true);
        $('#' + moduler + 'Result').html(result);
    },
    changeVersion: function (versionID) {
        var datas = this.invoke(this.buildServicePath('/service/core/changeversion'), $.csControl.appendKeyValue("", "versionid", versionID));
        window.location.reload();//页面刷新
    },
    pressEnterToNext: function () {
        $('input:text:first').focus();
        var $inp = $('input');
        $inp.bind('keydown', function (e) {
            var key = e.which;
            if (key == 13) {
                e.preventDefault();
                var nxtIdx = $inp.index(this) + 1;
                $(":input:eq(" + nxtIdx + ")").focus();
            }
        });
    },
    pressEnterToSubmit: function (pressedId, buttonId) {
        $("#" + pressedId).keydown(
			function (e) {
			    if (e.keyCode == 13) {
			        $('#' + buttonId).trigger('click');
			    }
			}
		);
    },
    getViewElements: function (viewID) {
        return $("#" + viewID).find("[id^='_view_']");
    },
    resetView: function (viewID) {
        var elements = this.getViewElements(viewID);
        for (var i = 0; i < elements.length; i++) {
            elements.eq(i).html("");
        }
    },
    viewWithJSON: function (viewID, jsonObject) {
        var elements = this.getViewElements(viewID);
        $.each(jsonObject, function (fieldName, fieldValue) {
            if ($.inArray($("#_view_" + fieldName)[0], elements) >= 0) {

                if (!$.csValidator.isNull(fieldValue)) {
                    try {
                        if (fieldValue.toLowerCase().substring(0, 6) == "/date(") {
                            fieldValue = $.csDate.formatMillisecondDate(fieldValue);
                        }
                    } catch (err) { }

                    $("#_view_" + fieldName).html(unescape(fieldValue));
                }
            }
        });
    },
    loadModal: function (src, width, height, initEvent) {
        if (width <= 0 || height <= 0 || width == undefined || height == undefined) {
            width = 750;
            height = 415;
        }
        if (src.endWith(".htm") || src.endWith(".html")||src.endWith(".jsp")) {
            if ($.csValidator.isNull(initEvent)) {
                $.weeboxs.open(src, { contentType: 'ajax', width: width, height: height, showButton: false });
            } else {
                $.weeboxs.open(src, { contentType: 'ajax', onopen: initEvent, width: width, height: height, showButton: false });
            }

        } else {
            $.weeboxs.open("#" + src, { width: width, height: height, showButton: false });
        }
    },
    loadPage: function (container, url, initEvent) {
        if ($.csValidator.isNull(url)) {
            return false;
        }
        $('#' + container).html('');
        if ($.csValidator.isNull(initEvent)) {
            $('#' + container).load(url);
        } else {
            $('#' + container).load(url, initEvent);
        }
    },
    changeCaptcha: function (imgId) {
        $("#" + imgId).attr("src", this.buildServicePath('/service/core/getcaptcha?' + (new Date()).getTime()));
    },
    login: function (divId) {
        if ($.csValidator.checkNull('username', $.csCore.getValue('Common_Required', 'Member_Username'))) {
            return false;
        }
        if ($.csValidator.checkNull('password', $.csCore.getValue('Common_Required', 'Member_Password'))) {
            return false;
        }
        if (!IS_NET) {
            if ($.csValidator.checkNull('captcha', $.csCore.getValue('Common_Required', 'Common_Captcha'))) {
                return false;
            }
        }
        if (this.postData(this.buildServicePath('/service/member/login'), divId)) {
            document.location.href = this.getMyPlatform();
        }
    },
    utf8ToGb2312: function (str1) {
        str1 = unescape(str1.replace(/\\u/g, '%u').replace(/;/g, ''));
        return str1;

    },
    getMyPlatform: function () {
        var datas = this.invoke(this.buildServicePath('/service/member/getmyplatform'), '');
        return datas;
    },
    alert: function (msg) {
        hint = $.csCore.getValue("Common_Prompt");
        $.weeboxs.open(msg, { title: hint, type: 'alert', okBtnName: $.csCore.getValue("Button_OK") });
    },
    confirm: function (msg, okEvent) {
        $.weeboxs.open(msg, {
            title: $.csCore.getValue("Common_Prompt"),
            okBtnName: $.csCore.getValue("Button_OK"),
            cancelBtnName: $.csCore.getValue("Button_Cancel"),
            type: 'dialog',
            onok: function () {
                eval(okEvent);
                $.csCore.close();
            },
            oncancel: function () {
                $.csCore.close();
            }
        });
    },
    close: function () {
        $.weeboxs.close();
    },
    loadEditor: function (textareaId) {
        //自定义插件
        var uploadUrl = $.csCore.buildServicePath('/service/file/uploadimages');
        if (IS_NET) {
            uploadUrl = "../../scripts/jquery/xheditor/upload.ashx";
        }
        var uploadPlugin = {
            uploadFile: { c: 'upload_image', t: 'Upload Image (Ctrl+2)', h: 1, e: function () {
                var _this = this;
                var jDom = $('<div><input type="text" id="xheImgUrl" class="xheText" /><input type="button" id="xheSave" /></div>');
                var jUrl = $('#xheImgUrl', jDom);
                var jSave = $('#xheSave', jDom);
                _this.uploadInit(jUrl, uploadUrl, 'jpg,gif,png,bmp');
                jSave.click(function () {
                    _this.loadBookmark();
                    _this.pasteHTML("<img src='" + jUrl.val() + "'/>");
                    _this.hidePanel();
                    return false;
                });
                _this.saveBookmark();
                _this.showDialog(jDom);

                //alert($("#xheCancel").parent().parent().parent().html());
                $("#xheCancel").hide();
                $("#xheSave").hide();
                $(".xheUpload").css("width", "200px");
                $("#xheImgUrl").hide();
            }
            }
        };
        //初始化xhEditor编辑器插
        $('#' + textareaId).xheditor({
            plugins: uploadPlugin,
            tools: 'uploadFile,|,Link,Unlink,|,SelectAll,Removeformat,Align,|,Fontface,FontSize,Bold,Italic,Underline,FontColor,BackColor,|,Source,Fullscreen',
            skin: 'default',
            upMultiple: false,
            html5Upload: false
        });
    },
    loadUpload: function (dataID,types) {
    	if($.csValidator.isNull(types)){
    		types = "*.*";
    	}
        var buttonID = "button" + dataID;
        var progressID = "progress" + dataID;

        var dom = "<span id='" + buttonID + "'></span><div class='fieldset flash' id='" + progressID + "'></div>";
        $("#" + dataID).parent().append(dom);

        var attachmentIDs = $("#" + dataID).val();
        if (!$.csValidator.isNull(attachmentIDs)) {
            var attachments = this.getAttachmentByIDs(attachmentIDs);
            $.each(attachments, function (i, attachment) {
                var file = new Object();
                file.index = i;
                file.name = attachment.fileName;
                file.size = attachment.fileLength;
                file.id = "upload_" + dataID + i;
                file.filestatus = -4;
                loadSuccessFile(file, progressID, attachment.ID, attachment.fileNameInDisk, dataID);
            });
        };
        url = "/service/file/uploadfile?dataid=" + dataID;
        if (IS_NET) {
            url = "../../scripts/jquery/swfupload/upload.ashx?dataid=" + dataID;
        }

        var upload = new SWFUpload({
            upload_url: this.buildServicePath(url),
            file_size_limit: "500 MB",
            file_types: types,
            file_types_description: "All Files",
            file_upload_limit: 10,
            file_queue_limit: 0,
            swfupload_preload_handler: preLoad,
            swfupload_load_failed_handler: loadFailed,
            file_dialog_start_handler: fileDialogStart,
            file_queued_handler: fileQueued,
            file_queue_error_handler: fileQueueError,
            file_dialog_complete_handler: fileDialogComplete,
            upload_start_handler: uploadStart,
            upload_progress_handler: uploadProgress,
            upload_error_handler: uploadError,
            upload_success_handler: uploadSuccess,
            upload_complete_handler: uploadComplete,
            button_image_url: "../../scripts/jquery/swfupload/images/button_upload_cn.png",
            button_placeholder_id: buttonID,
            button_width: 61,
            button_height: 22,
            flash_url: "../../scripts/jquery/swfupload/swfupload.swf",
            flash9_url: "../../scripts/jquery/swfupload/swfupload_fp9.swf",
            custom_settings: { progressTarget: progressID },
            debug: false
        });
    },
    getAttachmentByIDs: function (IDs) {
        var datas = this.invoke(this.buildServicePath('/service/file/getattachmentbyids'), $.csControl.appendKeyValue("", "IDs", IDs));
        return datas;
    },
    getRandom: function () {
        Math.round(Math.random() * 10000);
    },
    playVideo: function (width, height, file) {
        var aid = this.getRandom();
        var video = "";
        video += "<object width='" + width + "' height='" + height + "' id='p" + aid + "' classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'>";
        video += " <param name='movie' value='player.swf' />";
        video += " <param name='quality' value='high' />";
        video += " <param name='menu' value='false' />";
        video += " <param name='allowFullScreen' value='true' />";
        video += " <param name='scale' value='noscale' />";
        video += " <param name='allowScriptAccess' value='always' />";
        video += " <param name='swLiveConnect' value='true' />";
        video += " <param name='flashVars' value=' &video=" + file + "&autoplay=1'/>";
        video += " <!-- [if !IE] -->";
        video += " <object width='" + width + "' height='" + height + "' data='player.swf' type='application/x-shockwave-flash' id='p" + aid + "'>";
        video += " <param name='quality' value='high' />";
        video += " <param name='menu' value='false' />";
        video += " <param name='allowFullScreen' value='true' />";
        video += " <param name='scale' value='noscale' />";
        video += " <param name='allowScriptAccess' value='always' />";
        video += " <param name='swLiveConnect' value='true' />";
        video += " <param name='flashVars' value=' &video=" + file + "&autoplay=1'/>";
        video += " </object>";
        video += " <!-- [endif] -->";
        video += "</object>";
        return video;
    },
    playImg: function (width, height, file) {
        return "<img style='margin-top:4px;width:" + width + "px;height:" + height + "px;' src='" + file + "'/>";
    },
    zoomImg: function (maxWidth, maxHeight) {
        $('img').each(function () {
            var ratio = 0;  // 缩放比例  
            var width = $(this).width();    // 图片实际宽度   
            var height = $(this).height();  // 图片实际高度     // 检查图片是否超宽   
            if (width > maxWidth) {
                ratio = maxWidth / width;   // 计算缩放比例       
                $(this).css("width", maxWidth); // 设定实际显示宽度       
                height = height * ratio;    // 计算等比例缩放后的高度       
                $(this).css("height", height);  // 设定等比例缩放后的高度   
            }     // 检查图片是否超高  
            if (height > maxHeight) {
                ratio = maxHeight / height; // 计算缩放比例      
                $(this).css("height", maxHeight);   // 设定实际显示高度       
                width = width * ratio;    // 计算等比例缩放后的高度       
                $(this).css("width", width);    // 设定等比例缩放后的高度   
            }
        });
    }
};

jQuery.csDate = {
    formatUTCDateTime: function (date) {
        if (date == null || date == "" || date == "null") return "";

        var beginIndex = date.indexOf("(") + 1;
        var endIndex = date.indexOf(")");
        var dateNum = date.substring(beginIndex, endIndex);
        var newDate = new Date(parseInt(dateNum, 10));
        return $.format.date(newDate, "yyyy-MM-dd ");
    },
    formatMillisecondDate: function (date) {
        if (IS_NET) {
            return $.csDate.formatUTCDateTime(date);
        } else {
            if (!$.csValidator.isNull(date)) {
                var newDate = new Date(date);
                return $.format.date(newDate, "yyyy-MM-dd ");
            }
        }
        return date;
    },
    formatDateTime: function (date) {
        if (date == null || date == "" || date == "null") return "";
        var beginIndex = date.indexOf("(") + 1;
        var endIndex = date.indexOf(")");
        var dateNum = date.substring(beginIndex, endIndex);
        var newDate = new Date(parseInt(dateNum, 10));
        return $.format.date(newDate, "yyyy-MM-dd hh:mm:ss");
    },
    getLastYear: function () {
        //获取系统时间 
        var date = new Date();
        year = date.getFullYear() ;
        month = date.getMonth();
        if (month == '0') {
        	month = '12';
        	year--;
        }
        day = date.getDate();
        return $.format.date(year + "-" + month + "-" + day, "yyyy-MM-dd");
    },
    getNow: function () {
        return $.format.date(new Date(), "yyyy-MM-dd");
    },
    datePicker: function (id, defaultDate) {
        defaultDate = $.csValidator.isNull(defaultDate) ? $.csDate.getNow() : defaultDate;
        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd' }); }).val(defaultDate).css("width", "80").css("text-align", "center").css("cursor", "pointer");
    },
    datePickerNull: function (id) {
        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd' }); }).css("width", "80").css("text-align", "center").css("cursor", "pointer");
    },
    datePickerTo10: function (id, defaultDate) {
        defaultDate = $.csValidator.isNull(defaultDate) ? $.csDate.getNow() : defaultDate;
//        var min= $.csDate.dateAddDay(defaultDate,-8);
        var min= $.csDate.getNow();
        var max= $.csDate.dateAddDay(defaultDate,5);
        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd', minDate:min,maxDate:max}); }).val(defaultDate).css("width", "80").css("text-align", "center").css("cursor", "pointer");
    },
    dateAddDay : function (str,n) {
    	var   dd, mm, yy;   
    	var arr = str.split("-");
    	yy = Number(arr[0]);
	    mm = Number(arr[1])-1;
	    dd = Number(arr[2]);
	    
        var s, d, t, t2;
        t = Date.UTC(yy, mm, dd);
        t2 = n * 1000 * 3600 * 24;
        t+= t2;
        d = new Date(t);
        s = d.getUTCFullYear() + "-";
        s += ("00"+(d.getUTCMonth()+1)).slice(-2) + "-";
        s += ("00"+d.getUTCDate()).slice(-2);
        return s;
    }
};

jQuery.csValidator = {
    checkNull: function (controlId, message) {
        var bFlag = false;
        if ($('#' + controlId) != null && $('#' + controlId).get(0) != null && $('#' + controlId).get(0).tagName.toLowerCase() == "select") {
            if ($('#' + controlId).val() < 0) {
                bFlag = true;
            }
        }
        else {
            var value = $("#" + controlId).val();
            if (this.isNull(value)) {
                bFlag = true;
            }
        }
        if (bFlag == true) {
            $.csCore.alert(message);
            $("#" + controlId).focus();
        }
        return bFlag;
    },
    checkNotValidEmail: function (controlId, message) {
        if ($("[id$='" + controlId + "']").val() != "") {
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            if (!emailReg.test($("[id$='" + controlId + "']").val())) {
                $.csCore.alert(message);
                $("[id$='" + controlId + "']").focus();
                return true;
            }
        }
        return false;
    },
    isNull: function (val) {
        if (val == undefined || val == null || val == "" || val == '' || val == "undefined" || val == "null" || val == "NULL") {
            return true;
        }
        return false;
    },
    isExistImg: function (url) {      
        if ($.browser.msie) {
        	var x = new XMLHttpRequest();
            x.open("HEAD", url, false);
            x.send();
            return x.status == 200;
        }

        return true;
    },
    //判断是否为正整数
    checkNotPositiveInteger: function (val, message) { 
        if (val != undefined && val != null && val != "" && val != '' && val != "undefined" && val != "null" && val != "NULL") {
            var value = /^[1-9][0-9]*$/;
            if (!value.test(val)) {
                $.csCore.alert(message);
                return true;
            }
        }
        return false;
    },
    //判断是否为两位小数
    checkNotPositiveMoney: function (val, message) { 
        if (val != undefined && val != null && val != "" && val != '' && val != "undefined" && val != "null" && val != "NULL") {
            var value = /^-?\d+\.?\d{0,2}$/;
            if (!value.test(val)) {
                $.csCore.alert(message);
                return true;
            }
        }
        return false;
    }
};

jQuery.csControl = {
    fillBool: function (controlID) {
        $.csControl.fillOptions(controlID, $.csCore.getAllDicts(DICT_BOOL), "ID", "name");
    },
    initTable: function () {
        $(".list_result tr").mouseover(function () { $(this).addClass("over"); }).mouseout(function () { $(this).removeClass("over"); });
    },
    canListView: function () {
        if ($.cookie("area") == "ParamH" || $.cookie("area") == "ParamV") {
            return true;
        }
        return false;
    },
    view: function (url, event, width, height) {
        $('#paneView').empty();
        if ($.csValidator.isNull(url)) {
            return false;
        }
        if ($.cookie("area") == "ParamV" || $.cookie("area") == "ParamH") {
            $.csCore.loadPage('paneView', url, event);
        } else {
            if ($.csValidator.isNull(width)) {
                width = 750;
            }
            if ($.csValidator.isNull(height)) {
                height = 400;
            }

            $.csCore.loadModal(url, width, height, event);
        }
    },
    fillOptions: function (select, datas, fieldValue, fieldText, firstHint) {
        select = $('#' + select).empty();
        if (firstHint != null && firstHint != "") {
            var optionFirst = "<option title='" + firstHint + "' value='-1'>" + firstHint + "</option>";
            select.append(optionFirst);
        };
        $.each(datas, function (i, data) {
        	if(fieldValue == "CXID"){//编辑页面，刺绣信息 ecode为空，不显示
        		if(data.ecode != null){
	        		 var actionValue = "data.ID";
	                 var actionText = "data." + fieldText;
	                 var option = "<option title='" + eval(actionText) + "' value='" + eval(actionValue) + "'>" + eval(actionText) + "</option>";
	                 select.append(option);
        		}
        	}else{
        		var actionValue = "data." + fieldValue;
                var actionText = "data." + fieldText;
                var option = "<option value='" + eval(actionValue) + "'>" + eval(actionText) + "</option>";
                select.append(option);
        	}
        });
    },
    fillRadios: function (divContainer, datas, fieldName, fieldValue, fieldText) {
        var div = $('#' + divContainer);
        $.each(datas, function (i, data) {
            if (i == 0) {
                checked = " checked='true' ";
            } else {
                checked = "";
            };
            var inputRadio = "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='" + fieldName + "' value='" + eval("data." + fieldValue) + "'>" + eval("data." + fieldText) + "</label> ";
            div.append(inputRadio);
        });
    },
    fillRadio: function (divContainer, datas, fieldName, fieldValue, fieldText,value) {
        var div = $('#' + divContainer);
        $.each(datas, function (i, data) {
        	if(eval("data." + fieldValue)==value){
        		checked = " checked='true' "; 
        	}else{
        		checked = ""; 
        	}
            var inputRadio = "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='" + fieldName + "' value='" + eval("data." + fieldValue) + "'>" + eval("data." + fieldText) + "</label> ";
            div.append(inputRadio);
        });
    },
    getRadioValue: function (name) {
        return $("input[name=" + name + "]:checked").val();
    },
    fillChecks: function (divContainer, datas, fieldName, fieldValue, fieldText, initValue) {
        try {
            initValue = initValue == null ? "" : initValue.toLowerCase();
        }
        catch (err) { }
        initValue = "," + initValue + ",";
        var div = $('#' + divContainer);
        div.empty();
        $.each(datas, function (i, data) {
            var value = eval("data." + fieldValue);
            var tempValue = "," + value + ",";
            tempValue = tempValue.toLowerCase();
            var checked = "";
            if (initValue != null && initValue != "" && initValue.indexOf(tempValue) >= 0) {
                checked = "checked='true'";
            }
            var inputCheck = "<label class='checkbox'><input " + checked + " type='checkbox' name='" + fieldName + "' value='" + value + "'>";
            inputCheck = inputCheck + eval("data." + fieldText) + "</label>";
            div.append(inputCheck);
        });
    },
    checkAll: function (chkRow, chked) {
        $('[name=' + chkRow + ']').each(function () { $(this).attr("checked", chked); });
    },
    getCheckedValue: function (chkRow) {
        var index = 0;
        var values = new Array();
        $('[name=' + chkRow + ']').each(function () {
            if (this.checked == true) {
                values[index] = this.value;
                index++;
            }
        });
        return values;
    },
    initSingleCheck: function (value) {
        var radio = $("input[value='" + value + "']");
        if (radio.length > 0) {
            radio.attr("checked", "checked");
        }
        else {
            var option = $("option[value='" + value + "']");
            if (option.length > 0) {
                option.attr("selected", true);
            }
        }
    },
    initSingleCheckById: function (id) {
    	$('#'+id).attr("checked", "checked");
    },
    checkOnce: function (current) {
        var checked = current.checked;
        $("input[name='" + current.name + "']").attr("checked", false);
        current.checked = checked;
    },
    getFormData: function (containerID) {
        var result = "{";
        var elements = "";
        elements += '#' + containerID + ' input[type=text],';
        elements += '#' + containerID + ' input[type=password],';
        elements += '#' + containerID + ' input[type=hidden],';
        elements += '#' + containerID + ' textarea,';
        elements += '#' + containerID + ' select,';
        elements += '#' + containerID + ' input[type=checkbox],';
        elements += '#' + containerID + ' input[type=radio]';
        $(elements).each(
			function () {
			    if ($(this).attr('type') == 'radio' || $(this).attr('type') == "checkbox") {

			        if ($(this).attr('checked') == 'checked' || $(this).attr('checked') == 'true' || $(this).attr('checked') == true) {
			            result += $.csControl.appendElement(this);
			        }
			    }
			    else {
			        result += $.csControl.appendElement(this);
			    }
			}
		);
        if (result.endWith(",")) {
            result = result.substring(0, result.length - 1);
        }
        result += "}";
        return result;
    },
    appendElement: function (element) {
        var name = $(element).attr('name');
        if ($.csValidator.isNull(name)) {
            name = $(element).attr('id');
        }
        if (!$.csValidator.isNull(name)) {
            var val = $(element).val();
            if (!$.csValidator.isNull(val)) {
                val = val.toValidJson();
            }
            return "'" + name + "':'" + val + "',";
        }
        return "";
    },
    appendKeyValue: function (json, key, value) {
        if ($.csValidator.isNull(key)) {
            alert("key is reqiured");
            return false;
        }
        var base = json;
        if ($.csValidator.isNull(base)) {
            base = "{'" + key + "':'" + value + "'}";
        } else {
            if (base.startWith("{") && base.endWith("}")) {
                base = base.replaceAll("}", "", true);
                base = base + ",'" + key + "':'" + value + "'}";
            } else {
                alert("json param is error;");
            }
        }
        return base;
    }
};

jQuery.csMemberPick = {
    moduler: "MemberPick",
    controlID: "",
    controlText: "",
    isMultiple: true,
    bindEvent: function () {
        $("#btnMemberPickSearch").click($.csMemberPick.list);
        $("#btnPickMember").click($.csMemberPick.pick);
        $("#btnCancelPickMember").click($.csCore.close);
    },
    list: function () {
        var param = $.csControl.getFormData($.csMemberPick.moduler + 'Search');
        var url = $.csCore.buildServicePath("/service/member/getpickmembers");
        //alert(param);
        var data = $.csCore.invoke(url, param);
        $.csControl.fillOptions('select_left', data, "ID", "name");
        var selectValues = $("#" + $.csMemberPick.controlID).val();
        if (!$.csValidator.isNull(selectValues)) {
            var Values = selectValues.split(',');
            $.each(Values, function (i, value) {
                $("#select_left option[value='" + value + "']").remove();
            });
        }

        $.csMemberCommon.bindLabel();
    },
    pick: function () {
        var values = "";
        var texts = "";
        var options = $("#select_right").find("option");
        $.each(options, function (i, option) {
            values += option.value + ",";
            texts += option.text + ",";
        });
        if (values.endWith(",")) {
            values = values.substring(0, values.length - 1);
        }
        if (texts.endWith(",")) {
            texts = texts.substring(0, texts.length - 1);
        }
        $("#" + $.csMemberPick.controlID).val(values);
        $("#" + $.csMemberPick.controlText).val(texts);
        $.csCore.close();
    },
    beforeMove: function () {
        if ($.csMemberPick.isMultiple) {
            var selectLeft = $("#select_left").find("option:selected");
            $.each(selectLeft, function (i, item) {
                $("#select_right option[value='" + item.value + "']").remove();
            });
        } else {
            var selectLeft = $("#select_left").find("option:selected");
            var selectRight = $("#select_right").find("option");
            $.each(selectRight, function (i, item) {
                $("#select_left").append("<option value='" + item.value + "'>" + item.text + "</option>");
                $("#select_right option[value='" + item.value + "']").remove();
            });
        }
        return true;
    },
    init: function (controlID, controlText, isMultiple, groupID) {
        $.csMemberCommon.fillStatus("searchStatusID");
        $.csMemberCommon.fillGroup("searchGroupIDs");
        if (!$.csValidator.isNull(groupID)) {
            $("#searchGroupIDs").hide();
            $.csControl.initSingleCheck(groupID);
        }

        $.csMemberPick.controlID = controlID;
        $.csMemberPick.controlText = controlText;
        $.csMemberPick.isMultiple = isMultiple;

        var selectValues = $("#" + controlID).val();
        var selectTexts = $("#" + controlText).val();
        if (!$.csValidator.isNull(selectValues)) {
            Values = selectValues.split(',');
            Texts = selectTexts.split(',');
            var domOption = "";
            for (var i = 0; i < Values.length; i++) {
                domOption += "<option value='" + Values[i] + "'>" + Texts[i] + "</option>"
            }
            $("#select_right").append(domOption);
        }
        if (isMultiple) {
            $("#select_left").attr("multiple", "multiple");
            $("#select_right").attr("multiple", "multiple");
        } else {
            $("#options_right_all,#options_left_all").hide();
        }
        $.csMemberPick.list();
        $.csMemberPick.bindEvent();
        var options = {
            sortType: "key",
            button_select: "#options_right",
            button_deselect: "#options_left",
            button_select_all: "#options_right_all",
            button_deselect_all: "#options_left_all",
            beforeMove: $.csMemberPick.beforeMove
        };
        $("#select_left").multiSelect("#select_right", options);
        $.csCore.pressEnterToSubmit('searchKeyword','btnMemberPickSearch');
    }
};

//base.js
jQuery.csBase={
		loadChangePassword:function(){
			$.csCore.loadModal("../common/changepassword.htm",400,240,function(){$.csChangePassword.init();});
		},
		loadMyOrden:function(){
			$.csCore.loadModal("../orden/list.jsp",1010,525,function(){$.csOrdenList.init();});
		},
		loadBlDelivery:function(){
			$.csCore.loadModal("../bldelivery/BlDeliveryF.jsp",1010,525,function(){$.csBlDeliveryFList.init();});
		},
		loadBlCash:function(){
			$.csCore.loadModal("../blcash/BlDealList.jsp",1010,525,function(){$.csBlDealList.init("front",null,null);});
		},
		loadMyFabric:function(){
			$.csCore.loadModal("../fabric/list.jsp",970,525,function(){$.csFabricList.init();});
		},
		loadMyUser:function(){
			$.csCore.loadModal("../member/list.jsp",970,525,function(){$.csMemberList.init();});
		},
		loadMyInformation:function(){
			$.csCore.loadModal("../information/list.jsp",970,490,function(){$.csInformationList.init();});
		},
		loadVersions:function(){
			$.csControl.fillOptions('versions',$.csCore.getVersions(), "ID" , "name", "");
	        var currentVersion = $.csCore.getCurrentVersion();
	        $.csControl.initSingleCheck(currentVersion);
	        $("#versions").change(function(){$.csCore.changeVersion($("#versions").val());});
		},
		loadMyMessage:function(){
			$("#newmessage").html("").hide();
			if($.csCore.isAdmin() == true){
				$.csCore.loadPage("desktop_content","../message/list.jsp",function(){$.csMessageList.init();});
			}else{
				$.csCore.loadModal("../message/list.jsp",970,525,function(){$.csMessageList.init();});
			}
		},
		loadCoder:function(){
			$.csCore.loadModal("../coder/list.jsp",780,430,function(){$.csCoderList.init();});
		},
		checkNewMessage:function(){
			var hidden= $("#newmessage").is(":hidden");
			if(hidden){
				var total = JSON.parse($.csCore.invoke($.csCore.buildServicePath("/service/message/getnewmessagecount")));
				if(total > 0){
					$("#newmessage").show();
//					$.csCore.getValue("Message_HaveNewMessage",null,"#newmessage");
					$("#newmessage").unbind("click");
					$("#newmessage").click($.csBase.loadMyMessage);
				}
			}
		},
		loadCurrentMember:function() {
			if ($.csCore.isAdmin() == true) {
				var currentMember = $.csCore.getCurrentMember();
				$("#hello").html(currentMember.name + "," + $.csCore.getValue("Common_SystemWelcome")).attr("title",$.csCore.getValue("Common_WelcomeToPlatform"));
			}
		},
		getTotalCash:function(memberID) {
			return $.csCore.invoke($.csCore.buildServicePath("/service/cash/gettotal?memberid="+memberID),$.csControl.appendKeyValue('','memberid',memberID));
		},
		init:function(page){
			var systemName = $.csCore.getValue("Common_SystemName");
			$("#system_name").html(systemName);
			$.csCore.setPageTitle(page, systemName);
			$.csBase.loadCurrentMember();
			if($("#myorden").length>0){
				$("#myorden").bind("click",$.csBase.loadMyOrden);
			}
			if($("#myfabric").length>0){
				$("#myfabric").click($.csBase.loadMyFabric);
			}
			if($("#blDelivery").length>0){
				$("#blDelivery").bind("click",$.csBase.loadBlDelivery);
			}
			if($("#blCash").length>0){
				$("#blCash").bind("click",$.csBase.loadBlCash);
			}
			if($("#mymessage").length>0){
				var url = $.csCore.buildServicePath('/service/message/getnewmessagecount');
				var retValue = $.csCore.invoke(url);
				$("#mymessage").click($.csBase.loadMyMessage);
			}
			if($("#myuser").length>0){
				$("#myuser").click($.csBase.loadMyUser);
			}
			if($("#myinformation").length>0){
				$("#myinformation").bind("click",$.csBase.loadMyInformation);
			}
			if($("#coder").length>0){
				$("#coder").bind("click",$.csBase.loadCoder);
			}
			$("#signOut").bind("click", $.csCore.signOut);
			
			$.csBase.loadVersions();
		}
	};


//flowplayer-3.2.11.min.js
;(function(){function g(o){console.log("$f.fireEvent",[].slice.call(o))}function k(q){if(!q||typeof q!="object"){return q}var o=new q.constructor();for(var p in q){if(q.hasOwnProperty(p)){o[p]=k(q[p])}}return o}function m(t,q){if(!t){return}var o,p=0,r=t.length;if(r===undefined){for(o in t){if(q.call(t[o],o,t[o])===false){break}}}else{for(var s=t[0];p<r&&q.call(s,p,s)!==false;s=t[++p]){}}return t}function c(o){return document.getElementById(o)}function i(q,p,o){if(typeof p!="object"){return q}if(q&&p){m(p,function(r,s){if(!o||typeof s!="function"){q[r]=s}})}return q}function n(s){var q=s.indexOf(".");if(q!=-1){var p=s.slice(0,q)||"*";var o=s.slice(q+1,s.length);var r=[];m(document.getElementsByTagName(p),function(){if(this.className&&this.className.indexOf(o)!=-1){r.push(this)}});return r}}function f(o){o=o||window.event;if(o.preventDefault){o.stopPropagation();o.preventDefault()}else{o.returnValue=false;o.cancelBubble=true}return false}function j(q,o,p){q[o]=q[o]||[];q[o].push(p)}function e(){return"_"+(""+Math.random()).slice(2,10)}var h=function(t,r,s){var q=this,p={},u={};q.index=r;if(typeof t=="string"){t={url:t}}i(this,t,true);m(("Begin*,Start,Pause*,Resume*,Seek*,Stop*,Finish*,LastSecond,Update,BufferFull,BufferEmpty,BufferStop").split(","),function(){var v="on"+this;if(v.indexOf("*")!=-1){v=v.slice(0,v.length-1);var w="onBefore"+v.slice(2);q[w]=function(x){j(u,w,x);return q}}q[v]=function(x){j(u,v,x);return q};if(r==-1){if(q[w]){s[w]=q[w]}if(q[v]){s[v]=q[v]}}});i(this,{onCuepoint:function(x,w){if(arguments.length==1){p.embedded=[null,x];return q}if(typeof x=="number"){x=[x]}var v=e();p[v]=[x,w];if(s.isLoaded()){s._api().fp_addCuepoints(x,r,v)}return q},update:function(w){i(q,w);if(s.isLoaded()){s._api().fp_updateClip(w,r)}var v=s.getConfig();var x=(r==-1)?v.clip:v.playlist[r];i(x,w,true)},_fireEvent:function(v,y,w,A){if(v=="onLoad"){m(p,function(B,C){if(C[0]){s._api().fp_addCuepoints(C[0],r,B)}});return false}A=A||q;if(v=="onCuepoint"){var z=p[y];if(z){return z[1].call(s,A,w)}}if(y&&"onBeforeBegin,onMetaData,onStart,onUpdate,onResume".indexOf(v)!=-1){i(A,y);if(y.metaData){if(!A.duration){A.duration=y.metaData.duration}else{A.fullDuration=y.metaData.duration}}}var x=true;m(u[v],function(){x=this.call(s,A,y,w)});return x}});if(t.onCuepoint){var o=t.onCuepoint;q.onCuepoint.apply(q,typeof o=="function"?[o]:o);delete t.onCuepoint}m(t,function(v,w){if(typeof w=="function"){j(u,v,w);delete t[v]}});if(r==-1){s.onCuepoint=this.onCuepoint}};var l=function(p,r,q,t){var o=this,s={},u=false;if(t){i(s,t)}m(r,function(v,w){if(typeof w=="function"){s[v]=w;delete r[v]}});i(this,{animate:function(y,z,x){if(!y){return o}if(typeof z=="function"){x=z;z=500}if(typeof y=="string"){var w=y;y={};y[w]=z;z=500}if(x){var v=e();s[v]=x}if(z===undefined){z=500}r=q._api().fp_animate(p,y,z,v);return o},css:function(w,x){if(x!==undefined){var v={};v[w]=x;w=v}r=q._api().fp_css(p,w);i(o,r);return o},show:function(){this.display="block";q._api().fp_showPlugin(p);return o},hide:function(){this.display="none";q._api().fp_hidePlugin(p);return o},toggle:function(){this.display=q._api().fp_togglePlugin(p);return o},fadeTo:function(y,x,w){if(typeof x=="function"){w=x;x=500}if(w){var v=e();s[v]=w}this.display=q._api().fp_fadeTo(p,y,x,v);this.opacity=y;return o},fadeIn:function(w,v){return o.fadeTo(1,w,v)},fadeOut:function(w,v){return o.fadeTo(0,w,v)},getName:function(){return p},getPlayer:function(){return q},_fireEvent:function(w,v,x){if(w=="onUpdate"){var z=q._api().fp_getPlugin(p);if(!z){return}i(o,z);delete o.methods;if(!u){m(z.methods,function(){var B=""+this;o[B]=function(){var C=[].slice.call(arguments);var D=q._api().fp_invoke(p,B,C);return D==="undefined"||D===undefined?o:D}});u=true}}var A=s[w];if(A){var y=A.apply(o,v);if(w.slice(0,1)=="_"){delete s[w]}return y}return o}})};function b(q,G,t){var w=this,v=null,D=false,u,s,F=[],y={},x={},E,r,p,C,o,A;i(w,{id:function(){return E},isLoaded:function(){return(v!==null&&v.fp_play!==undefined&&!D)},getParent:function(){return q},hide:function(H){if(H){q.style.height="0px"}if(w.isLoaded()){v.style.height="0px"}return w},show:function(){q.style.height=A+"px";if(w.isLoaded()){v.style.height=o+"px"}return w},isHidden:function(){return w.isLoaded()&&parseInt(v.style.height,10)===0},load:function(J){if(!w.isLoaded()&&w._fireEvent("onBeforeLoad")!==false){var H=function(){if(u&&!flashembed.isSupported(G.version)){q.innerHTML=""}if(J){J.cached=true;j(x,"onLoad",J)}flashembed(q,G,{config:t})};var I=0;m(a,function(){this.unload(function(K){if(++I==a.length){H()}})})}return w},unload:function(J){if(u.replace(/\s/g,"")!==""){if(w._fireEvent("onBeforeUnload")===false){if(J){J(false)}return w}D=true;try{if(v){if(v.fp_isFullscreen()){v.fp_toggleFullscreen()}v.fp_close();w._fireEvent("onUnload")}}catch(H){}var I=function(){v=null;q.innerHTML=u;D=false;if(J){J(true)}};if(/WebKit/i.test(navigator.userAgent)&&!/Chrome/i.test(navigator.userAgent)){setTimeout(I,0)}else{I()}}else{if(J){J(false)}}return w},getClip:function(H){if(H===undefined){H=C}return F[H]},getCommonClip:function(){return s},getPlaylist:function(){return F},getPlugin:function(H){var J=y[H];if(!J&&w.isLoaded()){var I=w._api().fp_getPlugin(H);if(I){J=new l(H,I,w);y[H]=J}}return J},getScreen:function(){return w.getPlugin("screen")},getControls:function(){return w.getPlugin("controls")._fireEvent("onUpdate")},getLogo:function(){try{return w.getPlugin("logo")._fireEvent("onUpdate")}catch(H){}},getPlay:function(){return w.getPlugin("play")._fireEvent("onUpdate")},getConfig:function(H){return H?k(t):t},getFlashParams:function(){return G},loadPlugin:function(K,J,M,L){if(typeof M=="function"){L=M;M={}}var I=L?e():"_";w._api().fp_loadPlugin(K,J,M,I);var H={};H[I]=L;var N=new l(K,null,w,H);y[K]=N;return N},getState:function(){return w.isLoaded()?v.fp_getState():-1},play:function(I,H){var J=function(){if(I!==undefined){w._api().fp_play(I,H)}else{w._api().fp_play()}};if(w.isLoaded()){J()}else{if(D){setTimeout(function(){w.play(I,H)},50)}else{w.load(function(){J()})}}return w},getVersion:function(){var I="flowplayer.js 3.2.11";if(w.isLoaded()){var H=v.fp_getVersion();H.push(I);return H}return I},_api:function(){if(!w.isLoaded()){throw"Flowplayer "+w.id()+" not loaded when calling an API method"}return v},setClip:function(H){m(H,function(I,J){if(typeof J=="function"){j(x,I,J);delete H[I]}else{if(I=="onCuepoint"){$f(q).getCommonClip().onCuepoint(H[I][0],H[I][1])}}});w.setPlaylist([H]);return w},getIndex:function(){return p},bufferAnimate:function(H){v.fp_bufferAnimate(H===undefined||H);return w},_swfHeight:function(){return v.clientHeight}});m(("Click*,Load*,Unload*,Keypress*,Volume*,Mute*,Unmute*,PlaylistReplace,ClipAdd,Fullscreen*,FullscreenExit,Error,MouseOver,MouseOut").split(","),function(){var H="on"+this;if(H.indexOf("*")!=-1){H=H.slice(0,H.length-1);var I="onBefore"+H.slice(2);w[I]=function(J){j(x,I,J);return w}}w[H]=function(J){j(x,H,J);return w}});m(("pause,resume,mute,unmute,stop,toggle,seek,getStatus,getVolume,setVolume,getTime,isPaused,isPlaying,startBuffering,stopBuffering,isFullscreen,toggleFullscreen,reset,close,setPlaylist,addClip,playFeed,setKeyboardShortcutsEnabled,isKeyboardShortcutsEnabled").split(","),function(){var H=this;w[H]=function(J,I){if(!w.isLoaded()){return w}var K=null;if(J!==undefined&&I!==undefined){K=v["fp_"+H](J,I)}else{K=(J===undefined)?v["fp_"+H]():v["fp_"+H](J)}return K==="undefined"||K===undefined?w:K}});w._fireEvent=function(Q){if(typeof Q=="string"){Q=[Q]}var R=Q[0],O=Q[1],M=Q[2],L=Q[3],K=0;if(t.debug){g(Q)}if(!w.isLoaded()&&R=="onLoad"&&O=="player"){v=v||c(r);o=w._swfHeight();m(F,function(){this._fireEvent("onLoad")});m(y,function(S,T){T._fireEvent("onUpdate")});s._fireEvent("onLoad")}if(R=="onLoad"&&O!="player"){return}if(R=="onError"){if(typeof O=="string"||(typeof O=="number"&&typeof M=="number")){O=M;M=L}}if(R=="onContextMenu"){m(t.contextMenu[O],function(S,T){T.call(w)});return}if(R=="onPluginEvent"||R=="onBeforePluginEvent"){var H=O.name||O;var I=y[H];if(I){I._fireEvent("onUpdate",O);return I._fireEvent(M,Q.slice(3))}return}if(R=="onPlaylistReplace"){F=[];var N=0;m(O,function(){F.push(new h(this,N++,w))})}if(R=="onClipAdd"){if(O.isInStream){return}O=new h(O,M,w);F.splice(M,0,O);for(K=M+1;K<F.length;K++){F[K].index++}}var P=true;if(typeof O=="number"&&O<F.length){C=O;var J=F[O];if(J){P=J._fireEvent(R,M,L)}if(!J||P!==false){P=s._fireEvent(R,M,L,J)}}m(x[R],function(){P=this.call(w,O,M);if(this.cached){x[R].splice(K,1)}if(P===false){return false}K++});return P};function B(){if($f(q)){$f(q).getParent().innerHTML="";p=$f(q).getIndex();a[p]=w}else{a.push(w);p=a.length-1}A=parseInt(q.style.height,10)||q.clientHeight;E=q.id||"fp"+e();r=G.id||E+"_api";G.id=r;u=q.innerHTML;if(typeof t=="string"){t={clip:{url:t}}}t.playerId=E;t.clip=t.clip||{};if(q.getAttribute("href",2)&&!t.clip.url){t.clip.url=q.getAttribute("href",2)}s=new h(t.clip,-1,w);t.playlist=t.playlist||[t.clip];var I=0;m(t.playlist,function(){var L=this;if(typeof L=="object"&&L.length){L={url:""+L}}m(t.clip,function(M,N){if(N!==undefined&&L[M]===undefined&&typeof N!="function"){L[M]=N}});t.playlist[I]=L;L=new h(L,I,w);F.push(L);I++});m(t,function(L,M){if(typeof M=="function"){if(s[L]){s[L](M)}else{j(x,L,M)}delete t[L]}});m(t.plugins,function(L,M){if(M){y[L]=new l(L,M,w)}});if(!t.plugins||t.plugins.controls===undefined){y.controls=new l("controls",null,w)}y.canvas=new l("canvas",null,w);u=q.innerHTML;function K(L){if(/iPad|iPhone|iPod/i.test(navigator.userAgent)&&!/.flv$/i.test(F[0].url)&&!J()){return true}if(!w.isLoaded()&&w._fireEvent("onBeforeClick")!==false){w.load()}return f(L)}function J(){return w.hasiPadSupport&&w.hasiPadSupport()}function H(){if(u.replace(/\s/g,"")!==""){if(q.addEventListener){q.addEventListener("click",K,false)}else{if(q.attachEvent){q.attachEvent("onclick",K)}}}else{if(q.addEventListener&&!J()){q.addEventListener("click",f,false)}w.load()}}setTimeout(H,0)}if(typeof q=="string"){var z=c(q);if(!z){throw"Flowplayer cannot access element: "+q}q=z;B()}else{B()}}var a=[];function d(o){this.length=o.length;this.each=function(q){m(o,q)};this.size=function(){return o.length};var p=this;for(name in b.prototype){p[name]=function(){var q=arguments;p.each(function(){this[name].apply(this,q)})}}}window.flowplayer=window.$f=function(){var p=null;var o=arguments[0];if(!arguments.length){m(a,function(){if(this.isLoaded()){p=this;return false}});return p||a[0]}if(arguments.length==1){if(typeof o=="number"){return a[o]}else{if(o=="*"){return new d(a)}m(a,function(){if(this.id()==o.id||this.id()==o||this.getParent()==o){p=this;return false}});return p}}if(arguments.length>1){var t=arguments[1],q=(arguments.length==3)?arguments[2]:{};if(typeof t=="string"){t={src:t}}t=i({bgcolor:"#000000",version:[10,1],expressInstall:"http://releases.flowplayer.org/swf/expressinstall.swf",cachebusting:false},t);if(typeof o=="string"){if(o.indexOf(".")!=-1){var s=[];m(n(o),function(){s.push(new b(this,k(t),k(q)))});return new d(s)}else{var r=c(o);return new b(r!==null?r:k(o),k(t),k(q))}}else{if(o){return new b(o,k(t),k(q))}}}return null};i(window.$f,{fireEvent:function(){var o=[].slice.call(arguments);var q=$f(o[0]);return q?q._fireEvent(o.slice(1)):null},addPlugin:function(o,p){b.prototype[o]=p;return $f},each:m,extend:i});if(typeof jQuery=="function"){jQuery.fn.flowplayer=function(q,p){if(!arguments.length||typeof arguments[0]=="number"){var o=[];this.each(function(){var r=$f(this);if(r){o.push(r)}});return arguments.length?o[arguments[0]]:new d(o)}return this.each(function(){$f(this,k(q),p?k(p):{})})}}})();(function(){var h=document.all,j="http://get.adobe.com/flashplayer",c=typeof jQuery=="function",e=/(\d+)[^\d]+(\d+)[^\d]*(\d*)/,b={width:"100%",height:"100%",id:"_"+(""+Math.random()).slice(9),allowfullscreen:true,allowscriptaccess:"always",quality:"high",version:[3,0],onFail:null,expressInstall:null,w3c:false,cachebusting:false};if(window.attachEvent){window.attachEvent("onbeforeunload",function(){__flash_unloadHandler=function(){};__flash_savedUnloadHandler=function(){}})}function i(m,l){if(l){for(var f in l){if(l.hasOwnProperty(f)){m[f]=l[f]}}}return m}function a(f,n){var m=[];for(var l in f){if(f.hasOwnProperty(l)){m[l]=n(f[l])}}return m}window.flashembed=function(f,m,l){if(typeof f=="string"){f=document.getElementById(f.replace("#",""))}if(!f){return}if(typeof m=="string"){m={src:m}}return new d(f,i(i({},b),m),l)};var g=i(window.flashembed,{conf:b,getVersion:function(){var m,f;try{f=navigator.plugins["Shockwave Flash"].description.slice(16)}catch(o){try{m=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");f=m&&m.GetVariable("$version")}catch(n){try{m=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");f=m&&m.GetVariable("$version")}catch(l){}}}f=e.exec(f);return f?[1*f[1],1*f[(f[1]*1>9?2:3)]*1]:[0,0]},asString:function(l){if(l===null||l===undefined){return null}var f=typeof l;if(f=="object"&&l.push){f="array"}switch(f){case"string":l=l.replace(new RegExp('(["\\\\])',"g"),"\\$1");l=l.replace(/^\s?(\d+\.?\d*)%/,"$1pct");return'"'+l+'"';case"array":return"["+a(l,function(o){return g.asString(o)}).join(",")+"]";case"function":return'"function()"';case"object":var m=[];for(var n in l){if(l.hasOwnProperty(n)){m.push('"'+n+'":'+g.asString(l[n]))}}return"{"+m.join(",")+"}"}return String(l).replace(/\s/g," ").replace(/\'/g,'"')},getHTML:function(o,l){o=i({},o);var n='<object width="'+o.width+'" height="'+o.height+'" id="'+o.id+'" name="'+o.id+'"';if(o.cachebusting){o.src+=((o.src.indexOf("?")!=-1?"&":"?")+Math.random())}if(o.w3c||!h){n+=' data="'+o.src+'" type="application/x-shockwave-flash"'}else{n+=' classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'}n+=">";if(o.w3c||h){n+='<param name="movie" value="'+o.src+'" />'}o.width=o.height=o.id=o.w3c=o.src=null;o.onFail=o.version=o.expressInstall=null;for(var m in o){if(o[m]){n+='<param name="'+m+'" value="'+o[m]+'" />'}}var p="";if(l){for(var f in l){if(l[f]){var q=l[f];p+=f+"="+(/function|object/.test(typeof q)?g.asString(q):q)+"&"}}p=p.slice(0,-1);n+='<param name="flashvars" value=\''+p+"' />"}n+="</object>";return n},isSupported:function(f){return k[0]>f[0]||k[0]==f[0]&&k[1]>=f[1]}});var k=g.getVersion();function d(f,n,m){if(g.isSupported(n.version)){f.innerHTML=g.getHTML(n,m)}else{if(n.expressInstall&&g.isSupported([6,65])){f.innerHTML=g.getHTML(i(n,{src:n.expressInstall}),{MMredirectURL:encodeURIComponent(location.href),MMplayerType:"PlugIn",MMdoctitle:document.title})}else{if(!f.innerHTML.replace(/\s/g,"")){f.innerHTML="<h2>Flash version "+n.version+" or greater is required</h2><h3>"+(k[0]>0?"Your version is "+k:"You have no flash plugin installed")+"</h3>"+(f.tagName=="A"?"<p>Click here to download latest version</p>":"<p>Download latest version from <a href='"+j+"'>here</a></p>");if(f.tagName=="A"||f.tagName=="DIV"){f.onclick=function(){location.href=j}}}if(n.onFail){var l=n.onFail.call(this);if(typeof l=="string"){f.innerHTML=l}}}}if(h){window[n.id]=document.getElementById(n.id)}i(this,{getRoot:function(){return f},getOptions:function(){return n},getConf:function(){return m},getApi:function(){return f.firstChild}})}if(c){jQuery.tools=jQuery.tools||{version:"3.2.11"};jQuery.tools.flashembed={conf:b};jQuery.fn.flashembed=function(l,f){return this.each(function(){$(this).data("flashembed",flashembed(this,l,f))})}}})();

//flowplayer.ipad-3.2.12.min.js
$f.addPlugin("ipad",function(y){var S=-1;var z=0;var A=1;var P=2;var E=3;var L=4;var j=5;var i=this;var U=1;var T=false;var I=false;var v=false;var s=0;var R=[];var l;var t=null;var d=0;var f={accelerated:false,autoBuffering:false,autoPlay:true,baseUrl:null,bufferLength:3,connectionProvider:null,cuepointMultiplier:1000,cuepoints:[],controls:{},duration:0,extension:"",fadeInSpeed:1000,fadeOutSpeed:1000,image:false,linkUrl:null,linkWindow:"_self",live:false,metaData:{},originalUrl:null,position:0,playlist:[],provider:"http",scaling:"scale",seekableOnBegin:false,start:0,url:null,urlResolvers:[]};var x=S;var r=S;var u=/iPad|iPhone|iPod/i.test(navigator.userAgent);var c=null;function n(Y,X,V){if(X){for(key in X){if(key){if(X[key]&&typeof X[key]=="function"&&!V){continue}if(X[key]&&typeof X[key]=="object"&&X[key].length===undefined){var W={};n(W,X[key]);Y[key]=W}else{Y[key]=X[key]}}}}return Y}var B={simulateiDevice:false,controlsSizeRatio:1.5,controls:true,debug:false,validExtensions:"mov|m4v|mp4|avi|mp3|m4a|aac|m3u8|m3u|pls",posterExtensions:"png|jpg"};n(B,y);var b=B.validExtensions?new RegExp("^.("+B.validExtensions+")$","i"):null;var e=new RegExp("^.("+B.posterExtensions+")$","i");function h(){if(B.debug){if(u){var V=[].splice.call(arguments,0).join(", ");console.log.apply(console,[V])}else{console.log.apply(console,arguments)}}}function m(V){switch(V){case -1:return"UNLOADED";case 0:return"LOADED";case 1:return"UNSTARTED";case 2:return"BUFFERING";case 3:return"PLAYING";case 4:return"PAUSED";case 5:return"ENDED"}return"UNKOWN"}function J(V){var W=$f.fireEvent(i.id(),"onBefore"+V,s);return W!==false}function O(V){V.stopPropagation();V.preventDefault();return false}function M(W,V){if(x==S&&!V){return}r=x;x=W;D();if(W==E){p()}h(m(W))}function C(){c.fp_stop();T=false;I=false;v=false;M(A);M(A)}var g=null;function p(){if(g){return}console.log("starting tracker");g=setInterval(G,100);G()}function D(){clearInterval(g);g=null}function G(){var W=Math.floor(c.fp_getTime()*10)*100;var X=Math.floor(c.duration*10)*100;var Y=(new Date()).time;function V(ab,Z){ab=ab>=0?ab:X-Math.abs(ab);for(var aa=0;aa<Z.length;aa++){if(Z[aa].lastTimeFired>Y){Z[aa].lastTimeFired=-1}else{if(Z[aa].lastTimeFired+500>Y){continue}else{if(ab==W||(W-500<ab&&W>ab)){Z[aa].lastTimeFired=Y;$f.fireEvent(i.id(),"onCuepoint",s,Z[aa].fnId,Z[aa].parameters)}}}}}$f.each(i.getCommonClip().cuepoints,V);$f.each(R[s].cuepoints,V)}function H(){C();v=true;c.fp_seek(0)}function N(V){}function q(){console.log(c);function V(X){var W={};n(W,f);n(W,i.getCommonClip());n(W,X);if(W.ipadUrl){url=decodeURIComponent(W.ipadUrl)}else{if(W.url){url=W.url}}if(url&&url.indexOf("://")==-1&&W.ipadBaseUrl){url=W.ipadBaseUrl+"/"+url}else{if(url&&url.indexOf("://")==-1&&W.baseUrl){url=W.baseUrl+"/"+url}}W.originalUrl=W.url;W.completeUrl=url;W.extension=W.completeUrl.substr(W.completeUrl.lastIndexOf("."));var Y=W.extension.indexOf("?");if(Y>-1){W.extension=W.extension.substr(0,Y)}W.type="video";delete W.index;h("fixed clip",W);return W}c.fp_play=function(Z,X,ab,ac){var W=null;var aa=true;var Y=true;h("Calling play() "+Z,Z);if(X){h("ERROR: inStream clips not yet supported");return}if(Z!==undefined){if(typeof Z=="number"){if(s>=R.length){return}s=Z;Z=R[s]}else{if(typeof Z=="string"){Z={url:Z}}c.fp_setPlaylist(Z.length!==undefined?Z:[Z])}if(s==0&&R.length>1&&e.test(R[s].extension)){var ac=R[s].url;console.log("Poster image available with url "+ac);++s;console.log("Not last clip in the playlist, moving to next one");c.fp_play(s,false,true,ac);return}if(b&&!b.test(R[s].extension)){return}Z=R[s];W=Z.completeUrl;if(Z.autoBuffering!==undefined&&Z.autoBuffering===false){aa=false}if(Z.autoPlay===undefined||Z.autoPlay===true||ab===true){aa=true;Y=true}else{Y=false}}else{h("clip was not given, simply calling video.play, if not already buffering");if(x!=P){c.play()}return}h("about to play "+W,aa,Y);C();if(W){h("Changing SRC attribute"+W);c.setAttribute("src",W)}if(aa){if(!J("Begin")){return false}if(ac){Y=Z.autoPlay;c.setAttribute("poster",ac);c.setAttribute("preload","none")}$f.fireEvent(i.id(),"onBegin",s);h("calling video.load()");c.load()}if(Y){h("calling video.play()");c.play()}};c.fp_pause=function(){h("pause called");if(!J("Pause")){return false}c.pause()};c.fp_resume=function(){h("resume called");if(!J("Resume")){return false}c.play()};c.fp_stop=function(){h("stop called");if(!J("Stop")){return false}I=true;c.pause();try{c.currentTime=0}catch(W){}};c.fp_seek=function(W){h("seek called "+W);if(!J("Seek")){return false}var aa=0;var W=W+"";if(W.charAt(W.length-1)=="%"){var X=parseInt(W.substr(0,W.length-1))/100;var Z=c.duration;aa=Z*X}else{aa=W}try{c.currentTime=aa}catch(Y){h("Wrong seek time")}};c.fp_getTime=function(){return c.currentTime};c.fp_mute=function(){h("mute called");if(!J("Mute")){return false}U=c.volume;c.volume=0};c.fp_unmute=function(){if(!J("Unmute")){return false}c.volume=U};c.fp_getVolume=function(){return c.volume*100};c.fp_setVolume=function(W){if(!J("Volume")){return false}c.volume=W/100};c.fp_toggle=function(){h("toggle called");if(i.getState()==j){H();return}if(c.paused){c.fp_play()}else{c.fp_pause()}};c.fp_isPaused=function(){return c.paused};c.fp_isPlaying=function(){return !c.paused};c.fp_getPlugin=function(X){if(X=="canvas"||X=="controls"){var W=i.getConfig();return W.plugins&&W.plugins[X]?W.plugins[X]:null}h("ERROR: no support for "+X+" plugin on iDevices");return null};c.fp_close=function(){M(S);c.parentNode.removeChild(c);c=null};c.fp_getStatus=function(){var X=0;var Y=0;try{X=c.buffered.start();Y=c.buffered.end()}catch(W){}return{bufferStart:X,bufferEnd:Y,state:x,time:c.fp_getTime(),muted:c.muted,volume:c.fp_getVolume()}};c.fp_getState=function(){return x};c.fp_startBuffering=function(){if(x==A){c.load()}};c.fp_setPlaylist=function(X){h("Setting playlist");s=0;for(var W=0;W<X.length;W++){X[W]=V(X[W])}R=X;$f.fireEvent(i.id(),"onPlaylistReplace",X)};c.fp_addClip=function(X,W){X=V(X);R.splice(W,0,X);$f.fireEvent(i.id(),"onClipAdd",X,W)};c.fp_updateClip=function(X,W){n(R[W],X);return R[W]};c.fp_getVersion=function(){return"3.2.3"};c.fp_isFullscreen=function(){var W=c.webkitDisplayingFullscreen;if(W!==undefined){return W}return false};c.fp_toggleFullscreen=function(){if(c.fp_isFullscreen()){c.webkitExitFullscreen()}else{c.webkitEnterFullscreen()}};c.fp_addCuepoints=function(Z,X,W){var ab=X==-1?i.getCommonClip():R[X];ab.cuepoints=ab.cuepoints||{};Z=Z instanceof Array?Z:[Z];for(var Y=0;Y<Z.length;Y++){var ac=typeof Z[Y]=="object"?(Z[Y]["time"]||null):Z[Y];if(ac==null){continue}ac=Math.floor(ac/100)*100;var aa=ac;if(typeof Z[Y]=="object"){aa=n({},Z[Y],false);if(aa.time===undefined){delete aa.time}if(aa.parameters!==undefined){n(aa,aa.parameters,false);delete aa.parameters}}ab.cuepoints[ac]=ab.cuepoints[ac]||[];ab.cuepoints[ac].push({fnId:W,lastTimeFired:-1,parameters:aa})}};$f.each(("toggleFullscreen,stopBuffering,reset,playFeed,setKeyboardShortcutsEnabled,isKeyboardShortcutsEnabled,css,animate,showPlugin,hidePlugin,togglePlugin,fadeTo,invoke,loadPlugin").split(","),function(){var W=this;c["fp_"+W]=function(){h("ERROR: unsupported API on iDevices "+W);return false}})}function K(){var ai=["abort","canplay","canplaythrough","durationchange","emptied","ended","error","loadeddata","loadedmetadata","loadstart","pause","play","playing","progress","ratechange","seeked","seeking","stalled","suspend","volumechange","waiting"];var aa=function(ak){h("Got event "+ak.type,ak)};for(var ac=0;ac<ai.length;ac++){c.addEventListener(ai[ac],aa,false)}var X=function(ak){h("got onBufferEmpty event "+ak.type);M(P);$f.fireEvent(i.id(),"onBufferEmpty",s)};c.addEventListener("emptied",X,false);c.addEventListener("waiting",X,false);var Z=function(ak){if(r==A||r==P){}else{h("Restoring old state "+m(r));M(r)}$f.fireEvent(i.id(),"onBufferFull",s)};c.addEventListener("canplay",Z,false);c.addEventListener("canplaythrough",Z,false);var Y=function(al){var ak;d=R[s].start;if(R[s].duration>0){ak=R[s].duration;t=ak+d}else{ak=c.duration;t=null}c.fp_updateClip({duration:ak,metaData:{duration:c.duration}},s);R[s].duration=c.duration;R[s].metaData={duration:c.duration};$f.fireEvent(i.id(),"onMetaData",s,R[s])};c.addEventListener("loadedmetadata",Y,false);c.addEventListener("durationchange",Y,false);var W=function(ak){if(t&&c.currentTime>t){c.fp_seek(d);C();return O(ak)}};c.addEventListener("timeupdate",W,false);var ah=function(ak){if(x==L){if(!J("Resume")){h("Resume disallowed, pausing");c.fp_pause();return O(ak)}$f.fireEvent(i.id(),"onResume",s)}M(E);if(!T){T=true;$f.fireEvent(i.id(),"onStart",s)}};c.addEventListener("playing",ah,false);var V=function(ak){F()};c.addEventListener("play",V,false);var ae=function(ak){if(!J("Finish")){if(R.length==1){h("Active playlist only has one clip, onBeforeFinish returned false. Replaying");H()}else{if(s!=(R.length-1)){h("Not the last clip in the playlist, but onBeforeFinish returned false. Returning to the beginning of current clip");c.fp_seek(0)}else{h("Last clip in playlist, but onBeforeFinish returned false, start again from the beginning");c.fp_play(0)}}return O(ak)}M(j);$f.fireEvent(i.id(),"onFinish",s);if(R.length>1&&s<(R.length-1)){h("Not last clip in the playlist, moving to next one");c.fp_play(++s,false,true)}};c.addEventListener("ended",ae,false);var ad=function(ak){M(z,true);$f.fireEvent(i.id(),"onError",s,201);if(B.onFail&&B.onFail instanceof Function){B.onFail.apply(i,[])}};c.addEventListener("error",ad,false);var ag=function(ak){h("got pause event from player"+i.id());if(I){return}if(x==P&&r==A){h("forcing play");setTimeout(function(){c.play()},0);return}if(!J("Pause")){c.fp_resume();return O(ak)}Q();M(L);$f.fireEvent(i.id(),"onPause",s)};c.addEventListener("pause",ag,false);var aj=function(ak){$f.fireEvent(i.id(),"onBeforeSeek",s)};c.addEventListener("seeking",aj,false);var ab=function(ak){if(I){I=false;$f.fireEvent(i.id(),"onStop",s)}else{$f.fireEvent(i.id(),"onSeek",s)}h("seek done, currentState",m(x));if(v){v=false;c.fp_play()}else{if(x!=E){c.fp_pause()}}};c.addEventListener("seeked",ab,false);var af=function(ak){$f.fireEvent(i.id(),"onVolume",c.fp_getVolume())};c.addEventListener("volumechange",af,false)}function F(){l=setInterval(function(){if(c.fp_getTime()>=c.duration-1){$f.fireEvent(i.id(),"onLastSecond",s);Q()}},100)}function Q(){clearInterval(l)}function o(){c.fp_play(0)}function w(){}if(u||B.simulateiDevice){if(!window.flashembed.__replaced){var k=window.flashembed;window.flashembed=function(X,ac,Y){if(typeof X=="string"){X=document.getElementById(X.replace("#",""))}if(!X){return}var ab=window.getComputedStyle(X,null);var aa=parseInt(ab.width);var V=parseInt(ab.height);while(X.firstChild){X.removeChild(X.firstChild)}var W=document.createElement("div");var Z=document.createElement("video");W.appendChild(Z);X.appendChild(W);W.style.height=V+"px";W.style.width=aa+"px";W.style.display="block";W.style.position="relative";W.style.background="-webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, 0.5)), to(rgba(0, 0, 0, 0.7)))";W.style.cursor="default";W.style.webkitUserDrag="none";Z.style.height="100%";Z.style.width="100%";Z.style.display="block";Z.id=ac.id;Z.name=ac.id;Z.style.cursor="pointer";Z.style.webkitUserDrag="none";Z.type="video/mp4";Z.playerConfig=Y.config;$f.fireEvent(Y.config.playerId,"onLoad","player")};flashembed.getVersion=k.getVersion;flashembed.asString=k.asString;flashembed.isSupported=function(){return true};flashembed.__replaced=true}var a=i._fireEvent;i._fireEvent=function(V){if(V[0]=="onLoad"&&V[1]=="player"){c=i.getParent().querySelector("video");if(B.controls){c.controls="controls"}q();K();M(z,true);c.fp_setPlaylist(c.playerConfig.playlist);o();a.apply(i,[V])}var W=x!=S;if(x==S&&typeof V=="string"){W=true}if(W){return a.apply(i,[V])}};i._swfHeight=function(){return parseInt(c.style.height)};i.hasiPadSupport=function(){return true}}return i});

//jquery/xheditor/xheditor.zh-cn.js
(function(d,$){if(window.xheditor)return!1;var H=navigator.userAgent.toLowerCase(),Ba=-1!==H.indexOf("mobile"),I=d.browser,pa=parseFloat(I.version),i=I.msie,qa=I.mozilla,R=I.safari,Ca=I.opera,eb=-1<H.indexOf(" adobeair/"),Da=/OS 5(_\d)+ like Mac OS X/i.test(H);d.fn.xheditor=function(i){if(Ba&&!Da)return!1;var o=[];this.each(function(){if(d.nodeName(this,"TEXTAREA"))if(!1===i){if(this.xheditor)this.xheditor.remove(),this.xheditor=null}else if(this.xheditor)o.push(this.xheditor);else{var p=/({.*})/.exec(d(this).attr("class"));
if(p){try{p=eval("("+p[1]+")")}catch(t){}i=d.extend({},p,i)}p=new ra(this,i);if(p.init())this.xheditor=p,o.push(p)}});0===o.length&&(o=!1);1===o.length&&(o=o[0]);return o};var aa=0,S=!1,sa=!0,ta=!1,Sa=!1,t,ba,ca,da,J,Ea,ea,Fa,Ga,Ha,K;d("script[src*=xheditor]").each(function(){var d=this.src;if(d.match(/xheditor[^\/]*\.js/i))return K=d.replace(/[\?#].*$/,"").replace(/(^|[\/\\])[^\/]*$/,"$1"),!1});if(i){try{document.execCommand("BackgroundImageCache",!1,!0)}catch(qb){}(H=d.fn.jquery)&&H.match(/^1\.[67]/)&&
	(d.attrHooks.width=d.attrHooks.height=null)}var fb={27:"esc",9:"tab",32:"space",13:"enter",8:"backspace",145:"scroll",20:"capslock",144:"numlock",19:"pause",45:"insert",36:"home",46:"del",35:"end",33:"pageup",34:"pagedown",37:"left",38:"up",39:"right",40:"down",112:"f1",113:"f2",114:"f3",115:"f4",116:"f5",117:"f6",118:"f7",119:"f8",120:"f9",121:"f10",122:"f11",123:"f12"},Ta="#FFFFFF,#CCCCCC,#C0C0C0,#999999,#666666,#333333,#000000,#FFCCCC,#FF6666,#FF0000,#CC0000,#990000,#660000,#330000,#FFCC99,#FF9966,#FF9900,#FF6600,#CC6600,#993300,#663300,#FFFF99,#FFFF66,#FFCC66,#FFCC33,#CC9933,#996633,#663333,#FFFFCC,#FFFF33,#FFFF00,#FFCC00,#999900,#666600,#333300,#99FF99,#66FF99,#33FF33,#33CC00,#009900,#006600,#003300,#99FFFF,#33FFFF,#66CCCC,#00CCCC,#339999,#336666,#003333,#CCFFFF,#66FFFF,#33CCFF,#3366FF,#3333FF,#000099,#000066,#CCCCFF,#9999FF,#6666CC,#6633FF,#6600CC,#333399,#330099,#FFCCFF,#FF99FF,#CC66CC,#CC33CC,#993399,#663366,#330033".split(","),
	gb=[{n:"p",t:"\u666e\u901a\u6bb5\u843d"},{n:"h1",t:"\u6807\u98981"},{n:"h2",t:"\u6807\u98982"},{n:"h3",t:"\u6807\u98983"},{n:"h4",t:"\u6807\u98984"},{n:"h5",t:"\u6807\u98985"},{n:"h6",t:"\u6807\u98986"},{n:"pre",t:"\u5df2\u7f16\u6392\u683c\u5f0f"},{n:"address",t:"\u5730\u5740"}],hb=[{n:"\u5b8b\u4f53",c:"SimSun"},{n:"\u4eff\u5b8b\u4f53",c:"FangSong_GB2312"},{n:"\u9ed1\u4f53",c:"SimHei"},{n:"\u6977\u4f53",c:"KaiTi_GB2312"},{n:"\u5fae\u8f6f\u96c5\u9ed1",c:"Microsoft YaHei"},{n:"Arial"},{n:"Arial Black"},
	{n:"Comic Sans MS"},{n:"Courier New"},{n:"System"},{n:"Times New Roman"},{n:"Tahoma"},{n:"Verdana"}],T=[{n:"x-small",s:"10px",t:"\u6781\u5c0f"},{n:"small",s:"12px",t:"\u7279\u5c0f"},{n:"medium",s:"16px",t:"\u5c0f"},{n:"large",s:"18px",t:"\u4e2d"},{n:"x-large",s:"24px",t:"\u5927"},{n:"xx-large",s:"32px",t:"\u7279\u5927"},{n:"-webkit-xxx-large",s:"48px",t:"\u6781\u5927"}],ib=[{s:"\u5de6\u5bf9\u9f50",v:"justifyleft"},{s:"\u5c45\u4e2d",v:"justifycenter"},{s:"\u53f3\u5bf9\u9f50",v:"justifyright"},{s:"\u4e24\u7aef\u5bf9\u9f50",
	v:"justifyfull"}],jb=[{s:"\u6570\u5b57\u5217\u8868",v:"insertOrderedList"},{s:"\u7b26\u53f7\u5217\u8868",v:"insertUnorderedList"}],kb={"default":{name:"\u9ed8\u8ba4",width:24,height:24,line:7,list:{smile:"\u5fae\u7b11",tongue:"\u5410\u820c\u5934",titter:"\u5077\u7b11",laugh:"\u5927\u7b11",sad:"\u96be\u8fc7",wronged:"\u59d4\u5c48",fastcry:"\u5feb\u54ed\u4e86",cry:"\u54ed",wail:"\u5927\u54ed",mad:"\u751f\u6c14",knock:"\u6572\u6253",curse:"\u9a82\u4eba",crazy:"\u6293\u72c2",angry:"\u53d1\u706b",ohmy:"\u60ca\u8bb6",
	awkward:"\u5c34\u5c2c",panic:"\u60ca\u6050",shy:"\u5bb3\u7f9e",cute:"\u53ef\u601c",envy:"\u7fa1\u6155",proud:"\u5f97\u610f",struggle:"\u594b\u6597",quiet:"\u5b89\u9759",shutup:"\u95ed\u5634",doubt:"\u7591\u95ee",despise:"\u9119\u89c6",sleep:"\u7761\u89c9",bye:"\u518d\u89c1"}}},ka={Cut:{t:"\u526a\u5207 (Ctrl+X)"},Copy:{t:"\u590d\u5236 (Ctrl+C)"},Paste:{t:"\u7c98\u8d34 (Ctrl+V)"},Pastetext:{t:"\u7c98\u8d34\u6587\u672c",h:i?0:1},Blocktag:{t:"\u6bb5\u843d\u6807\u7b7e",h:1},Fontface:{t:"\u5b57\u4f53",
	h:1},FontSize:{t:"\u5b57\u4f53\u5927\u5c0f",h:1},Bold:{t:"\u52a0\u7c97 (Ctrl+B)",s:"Ctrl+B"},Italic:{t:"\u659c\u4f53 (Ctrl+I)",s:"Ctrl+I"},Underline:{t:"\u4e0b\u5212\u7ebf (Ctrl+U)",s:"Ctrl+U"},Strikethrough:{t:"\u5220\u9664\u7ebf"},FontColor:{t:"\u5b57\u4f53\u989c\u8272",h:1},BackColor:{t:"\u80cc\u666f\u989c\u8272",h:1},SelectAll:{t:"\u5168\u9009 (Ctrl+A)"},Removeformat:{t:"\u5220\u9664\u6587\u5b57\u683c\u5f0f"},Align:{t:"\u5bf9\u9f50",h:1},List:{t:"\u5217\u8868",h:1},Outdent:{t:"\u51cf\u5c11\u7f29\u8fdb"},
	Indent:{t:"\u589e\u52a0\u7f29\u8fdb"},Link:{t:"\u8d85\u94fe\u63a5 (Ctrl+L)",s:"Ctrl+L",h:1},Unlink:{t:"\u53d6\u6d88\u8d85\u94fe\u63a5"},Anchor:{t:"\u951a\u70b9",h:1},Img:{t:"\u56fe\u7247",h:1},Flash:{t:"Flash\u52a8\u753b",h:1},Media:{t:"\u591a\u5a92\u4f53\u6587\u4ef6",h:1},Hr:{t:"\u63d2\u5165\u6c34\u5e73\u7ebf"},Emot:{t:"\u8868\u60c5",s:"ctrl+e",h:1},Table:{t:"\u8868\u683c",h:1},Source:{t:"\u6e90\u4ee3\u7801"},Preview:{t:"\u9884\u89c8"},Print:{t:"\u6253\u5370 (Ctrl+P)",s:"Ctrl+P"},Fullscreen:{t:"\u5168\u5c4f\u7f16\u8f91 (Esc)",
	s:"Esc"},About:{t:"\u5173\u4e8e xhEditor"}},Ia={mini:"Bold,Italic,Underline,Strikethrough,|,Align,List,|,Link,Img",simple:"Blocktag,Fontface,FontSize,Bold,Italic,Underline,Strikethrough,FontColor,BackColor,|,Align,List,Outdent,Indent,|,Link,Img,Emot",full:"Cut,Copy,Paste,Pastetext,|,Blocktag,Fontface,FontSize,Bold,Italic,Underline,Strikethrough,FontColor,BackColor,SelectAll,Removeformat,|,Align,List,Outdent,Indent,|,Link,Unlink,Anchor,Img,Flash,Media,Hr,Emot,Table,|,Source,Preview,Print,Fullscreen"};
	Ia.mfull=Ia.full.replace(/\|(,Align)/i,"/$1");var lb={a:"Link",img:"Img",embed:"Embed"},mb={"<":"&lt;",">":"&gt;",'"':"&quot;","\u00ae":"&reg;","\u00a9":"&copy;"},nb=/[<>"\u00ae\u00a9]/g,ra=function(z,o){function p(a){var a=a.target,b=lb[a.tagName.toLowerCase()];b&&("Embed"===b&&(b={"application/x-shockwave-flash":"Flash","application/x-mplayer2":"Media"}[a.type.toLowerCase()]),c.exec(b))}function H(a){if(27===a.which)return ta?c.removeModal():S&&c.hidePanel(),!1}function I(){setTimeout(c.setSource,
	10)}function U(){c.getSource()}function Ua(a){var b,e,f;if(a&&(b=a.originalEvent.clipboardData)&&(e=b.items)&&(f=e[0])&&"file"==f.kind&&f.type.match(/^image\//i))return a=f.getAsFile(),b=new FileReader,b.onload=function(){var a='<img src="'+event.target.result+'">',a=Va(a);c.pasteHTML(a)},b.readAsDataURL(a),!1;var h=g.cleanPaste;if(0===h||y||Ja)return!0;Ja=!0;c.saveBookmark();var a=i?"pre":"div",n=d("<"+a+' class="xhe-paste">\ufeff\ufeff</'+a+">",k).appendTo(k.body),a=n[0];b=c.getSel();e=c.getRng(!0);
	n.css("top",fa.scrollTop());i?(e.moveToElementText(a),e.select()):(e.selectNodeContents(a),b.removeAllRanges(),b.addRange(e));setTimeout(function(){var a=3===h,b;if(a)b=n.text();else{var e=[];d(".xhe-paste",k.body).each(function(a,b){0==d(b).find(".xhe-paste").length&&e.push(b.innerHTML)});b=e.join("<br />")}n.remove();c.loadBookmark();if(b=b.replace(/^[\s\uFEFF]+|[\s\uFEFF]+$/g,""))if(a)c.pasteText(b);else if(b=c.cleanHTML(b),b=c.cleanWord(b),b=c.formatXHTML(b),!g.onPaste||g.onPaste&&!1!==(b=g.onPaste(b)))b=
	Va(b),c.pasteHTML(b);Ja=!1},0)}function Va(a){var b=g.localUrlTest,e=g.remoteImgSaveUrl;if(b&&e){var f=[],h=0,a=a.replace(/(<img)((?:\s+[^>]*?)?(?:\s+src="\s*([^"]+)\s*")(?: [^>]*)?)(\/?>)/ig,function(a,e,c,d,r){/^(https?|data:image)/i.test(d)&&!b.test(d)&&(f[h]=d,c=c.replace(/\s+(width|height)="[^"]*"/ig,"").replace(/\s+src="[^"]*"/ig,' src="'+ua+'img/waiting.gif" remoteimg="'+h++ +'"'));return e+c+r});0<f.length&&d.post(e,{urls:f.join("|")},function(a){a=a.split("|");d("img[remoteimg]",c.doc).each(function(){var b=
	d(this);L(b,"src",a[b.attr("remoteimg")]);b.removeAttr("remoteimg")})})}return a}function Ka(a){try{c._exec("styleWithCSS",a,!0)}catch(b){try{c._exec("useCSS",!a,!0)}catch(e){}}}function La(){if(Ma&&!y){Ka(!1);try{c._exec("enableObjectResizing",!0,!0)}catch(a){}if(i)try{c._exec("BackgroundImageCache",!0,!0)}catch(b){}}}function Ba(a){if(y||13!==a.which||a.shiftKey||a.ctrlKey||a.altKey)return!0;a=c.getParent("p,h1,h2,h3,h4,h5,h6,pre,address,div,li");if(a.is("li"))return!0;if(g.forcePtag)0===a.length&&
	c._exec("formatblock","<p>");else return c.pasteHTML("<br />"),i&&0<a.length&&2===c.getRng().parentElement().childNodes.length&&c.pasteHTML("<br />"),!1}function Na(){!qa&&!R&&(la&&A.height("100%").css("height",A.outerHeight()-q.outerHeight()),i&&q.hide().show())}function Da(a){a=a.target;if(a.tagName.match(/(img|embed)/i)){var b=c.getSel(),e=c.getRng(!0);e.selectNode(a);b.removeAllRanges();b.addRange(e)}}function L(a,b,e){if(!b)return!1;var c="_xhe_"+b;e&&(va&&(e=V(e,va,B)),a.attr(b,B?V(e,"abs",
	B):e).removeAttr(c).attr(c,e));return a.attr(c)||a.attr(b)}function Oa(){sa&&c.hidePanel()}function ob(a){if(y)return!0;var b=a.which,e=fb[b],b=e?e:String.fromCharCode(b).toLowerCase();sKey="";sKey+=a.ctrlKey?"ctrl+":"";sKey+=a.altKey?"alt+":"";sKey+=a.shiftKey?"shift+":"";sKey+=b;var a=ma[sKey],f;for(f in a)if(f=a[f],d.isFunction(f)){if(!1===f.call(c))return!1}else return c.exec(f),!1}function M(a,b){var e=typeof a;return!b?"undefined"!=e:"array"===b&&a.hasOwnProperty&&a instanceof Array?!0:e===
	b}function V(a,b,e){if(a.match(/^(\w+):\/\//i)&&!a.match(/^https?:/i)||/^#/i.test(a)||/^data:/i.test(a))return a;var c=e?d('<a href="'+e+'" />')[0]:location,e=c.protocol,h=c.host,n=c.hostname,j=c.port,c=c.pathname.replace(/\\/g,"/").replace(/[^\/]+$/i,"");""===j&&(j="80");""===c?c="/":"/"!==c.charAt(0)&&(c="/"+c);a=d.trim(a);"abs"!==b&&(a=a.replace(RegExp(e+"\\/\\/"+n.replace(/\./g,"\\.")+"(?::"+j+")"+("80"===j?"?":"")+"(/|$)","i"),"/"));"rel"===b&&(a=a.replace(RegExp("^"+c.replace(/([\/\.\+\[\]\(\)])/g,
	"\\$1"),"i"),""));if("rel"!==b&&(a.match(/^(https?:\/\/|\/)/i)||(a=c+a),"/"===a.charAt(0))){for(var n=[],a=a.split("/"),l=a.length,c=0;c<l;c++)j=a[c],".."===j?n.pop():""!==j&&"."!==j&&n.push(j);""===a[l-1]&&n.push("");a="/"+n.join("/")}"abs"===b&&!a.match(/^https?:\/\//i)&&(a=e+"//"+h+a);return a=a.replace(/(https?:\/\/[^:\/?#]+):80(\/|$)/i,"$1$2")}function Wa(a,b){if("*"===b||a.match(RegExp(".("+b.replace(/,/g,"|")+")$","i")))return!0;alert("\u4e0a\u4f20\u6587\u4ef6\u6269\u5c55\u540d\u5fc5\u9700\u4e3a: "+
	b);return!1}function Xa(a){var b=Math.floor(Math.log(a)/Math.log(1024));return(a/Math.pow(1024,Math.floor(b))).toFixed(2)+"Byte,KB,MB,GB,TB,PB".split(",")[b]}function N(){return!1}var c=this,F=d(z),Ya=F.closest("form"),q,A,W,fa,k,ga,ha,Ma=!1,y=!1,la=!1,Ja=!1,Pa,na=!1,Za="",w=null,wa,oa=!1,Qa=!1,ia=null,X=null,O=0,g=c.settings=d.extend({},ra.settings,o),xa=g.plugins,ya=[];xa&&(ka=d.extend({},ka,xa),d.each(xa,function(a){ya.push(a)}),ya=ya.join(","));if(g.tools.match(/^\s*(m?full|simple|mini)\s*$/i)){var $a=
	Ia[d.trim(g.tools)];g.tools=g.tools.match(/m?full/i)&&xa?$a.replace("Table","Table,"+ya):$a}g.tools.match(/(^|,)\s*About\s*(,|$)/i)||(g.tools+=",About");g.tools=g.tools.split(",");if(g.editorRoot)K=g.editorRoot;!1===eb&&(K=V(K,"abs"));if(g.urlBase)g.urlBase=V(g.urlBase,"abs");var ab="xheCSS_"+g.skin,ja="xhe"+aa+"_container",bb="xhe"+aa+"_Tool",cb="xhe"+aa+"_iframearea",db="xhe"+aa+"_iframe",za="xhe"+aa+"_fixffcursor",P="",Q="",ua=K+"xheditor_skin/"+g.skin+"/",Aa=kb,va=g.urlType,B=g.urlBase,Y=g.emotPath,
	Y=Y?Y:K+"xheditor_emot/",Ra="",Aa=d.extend({},Aa,g.emots),Y=V(Y,"rel",B?B:null);(na=g.showBlocktag)&&(Q+=" showBlocktag");var ma=[];this.init=function(){0===d("#"+ab).length&&d("head").append('<link id="'+ab+'" rel="stylesheet" type="text/css" href="'+ua+'ui.css" />');var a=F.outerWidth(),b=F.outerHeight(),a=g.width||z.style.width||(10<a?a:0);O=g.height||z.style.height||(10<b?b:150);M(a,"number")&&(a+="px");M(O,"string")&&(O=O.replace(/[^\d]+/g,""));var b=g.background||z.style.background,e=['<span class="xheGStart"/>'],
	f,h,n=/\||\//i;d.each(g.tools,function(a,b){b.match(n)&&e.push('<span class="xheGEnd"/>');if("|"===b)e.push('<span class="xheSeparator"/>');else if("/"===b)e.push("<br />");else{f=ka[b];if(!f)return;h=f.c?f.c:"xheIcon xheBtn"+b;e.push('<span><a href="#" title="'+f.t+'" cmd="'+b+'" class="xheButton xheEnabled" tabindex="-1" role="button"><span class="'+h+'" unselectable="on" style="font-size:0;color:transparent;text-indent:-999px;">'+f.t+"</span></a></span>");f.s&&c.addShortcuts(f.s,b)}b.match(n)&&
	e.push('<span class="xheGStart"/>')});e.push('<span class="xheGEnd"/><br />');F.after(d('<input type="text" id="'+za+'" style="position:absolute;display:none;" /><span id="'+ja+'" class="xhe_'+g.skin+'" style="display:none"><table cellspacing="0" cellpadding="0" class="xheLayout" style="'+("0px"!=a?"width:"+a+";":"")+"height:"+O+'px;" role="presentation"><tr><td id="'+bb+'" class="xheTool" unselectable="on" style="height:1px;" role="presentation"></td></tr><tr><td id="'+cb+'" class="xheIframeArea" role="presentation"><iframe frameborder="0" id="'+
	db+'" src="javascript:;" style="width:100%;"></iframe></td></tr></table></span>'));q=d("#"+bb);A=d("#"+cb);P='<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><link rel="stylesheet" href="'+ua+'iframe.css"/>';if(a=g.loadCSS)if(M(a,"array"))for(var j in a)P+='<link rel="stylesheet" href="'+a[j]+'"/>';else P=a.match(/\s*<style(\s+[^>]*?)?>[\s\S]+?<\/style>\s*/i)?P+a:P+('<link rel="stylesheet" href="'+a+'"/>');j="<html><head>"+P+"<title>\u53ef\u89c6\u5316\u7f16\u8f91\u5668,alt+1\u52309\u952e,\u5207\u6362\u5230\u5de5\u5177\u533a,tab\u952e,\u9009\u62e9\u6309\u94ae,esc\u952e,\u8fd4\u56de\u7f16\u8f91 "+
	(g.readTip?g.readTip:"")+"</title>";b&&(j+="<style>html{background:"+b+";}</style>");j+='</head><body spellcheck="0" class="editMode'+Q+'"></body></html>';c.win=W=d("#"+db)[0].contentWindow;fa=d(W);try{this.doc=k=W.document,ga=d(k),k.open(),k.write(j),k.close(),i?k.body.contentEditable="true":k.designMode="On"}catch(l){}setTimeout(La,300);c.setSource();W.setInterval=null;q.append(e.join("")).bind("mousedown contextmenu",N).click(function(a){var b=d(a.target).closest("a");b.is(".xheEnabled")&&(clearTimeout(wa),
	q.find("a").attr("tabindex","-1"),w=a,c.exec(b.attr("cmd")));return!1});q.find(".xheButton").hover(function(a){var b=d(this),e=g.hoverExecDelay,m=X;X=null;if(-1===e||oa||!b.is(".xheEnabled"))return!1;if(m&&10<m)return oa=!0,setTimeout(function(){oa=!1},100),!1;var f=b.attr("cmd");if(1!==ka[f].h)return c.hidePanel(),!1;Qa&&(e=0);0<=e&&(wa=setTimeout(function(){w=a;ia={x:w.clientX,y:w.clientY};c.exec(f)},e))},function(){ia=null;wa&&clearTimeout(wa)}).mousemove(function(a){if(ia){var b=a.clientX-ia.x,
	c=a.clientY-ia.y;if(1<Math.abs(b)||1<Math.abs(c))0<b&&0<c?(b=Math.round(Math.atan(c/b)/0.017453293),X=X?(X+b)/2:b):X=null,ia={x:a.clientX,y:a.clientY}}});t=d("#xhePanel");ba=d("#xheShadow");ca=d("#xheCntLine");0===t.length&&(t=d('<div id="xhePanel"></div>').mousedown(function(a){a.stopPropagation()}),ba=d('<div id="xheShadow"></div>'),ca=d('<div id="xheCntLine"></div>'),setTimeout(function(){d(document.body).append(t).append(ba).append(ca)},10));d("#"+ja).show();F.hide();A.css("height",O-q.outerHeight());
	i&8>pa&&setTimeout(function(){A.css("height",O-q.outerHeight())},1);F.focus(c.focus);Ya.submit(U).bind("reset",I);g.submitID&&d("#"+g.submitID).mousedown(U);d(window).bind("unload beforeunload",U).bind("resize",Na);d(document).mousedown(Oa);Sa||(d(document).keydown(H),Sa=!0);fa.focus(function(){g.focus&&g.focus()}).blur(function(){g.blur&&g.blur()});R&&fa.click(Da);ga.mousedown(Oa).keydown(ob).keypress(Ba).dblclick(p).bind("mousedown click",function(a){F.trigger(a.type)});if(i){ga.keydown(function(a){var b=
	c.getRng();if(8===a.which&&b.item)return d(b.item(0)).remove(),!1});var u=function(a){var a=d(a.target),b;(b=a.css("width"))&&a.css("width","").attr("width",b.replace(/[^0-9%]+/g,""));(b=a.css("height"))&&a.css("height","").attr("height",b.replace(/[^0-9%]+/g,""))};ga.bind("controlselect",function(a){a=a.target;d.nodeName(a,"IMG")&&d(a).unbind("resizeend",u).bind("resizeend",u)})}ga.keydown(function(a){var b=a.which;if(a.altKey&&49<=b&&57>=b)return q.find("a").attr("tabindex","0"),q.find(".xheGStart").eq(b-
	49).next().find("a").focus(),k.title="\ufeff\ufeff",!1}).click(function(){q.find("a").attr("tabindex","-1")});q.keydown(function(a){var b=a.which;if(27==b)q.find("a").attr("tabindex","-1"),c.focus();else if(a.altKey&&49<=b&&57>=b)return q.find(".xheGStart").eq(b-49).next().find("a").focus(),!1});j=d(k.documentElement);Ca?j.bind("keydown",function(a){a.ctrlKey&&86===a.which&&Ua()}):j.bind(i?"beforepaste":"paste",Ua);g.disableContextmenu&&j.bind("contextmenu",N);g.html5Upload&&j.bind("dragenter dragover",
	function(a){var b;if((b=a.originalEvent.dataTransfer.types)&&-1!==d.inArray("Files",b))return!1}).bind("drop",function(a){var a=a.originalEvent.dataTransfer,b;if(a&&(b=a.files)&&0<b.length){var e,f,a=["Link","Img","Flash","Media"],j=[],h;for(e in a)f=a[e],g["up"+f+"Url"]&&g["up"+f+"Url"].match(/^[^!].*/i)&&j.push(f+":,"+g["up"+f+"Ext"]);if(0===j.length)return!1;h=j.join(",");f=function(a){var b,c;for(e=0;e<a.length;e++)if(b=a[e].name.replace(/.+\./,""),b=h.match(RegExp("(\\w+):[^:]*,"+b+"(?:,|$)",
	"i")))if(c){if(c!==b[1])return 2}else c=b[1];else return 1;return c}(b);1===f?alert("\u4e0a\u4f20\u6587\u4ef6\u7684\u6269\u5c55\u540d\u5fc5\u9700\u4e3a\uff1a"+h.replace(/\w+:,/g,"")):2===f?alert("\u6bcf\u6b21\u53ea\u80fd\u62d6\u653e\u4e0a\u4f20\u540c\u4e00\u7c7b\u578b\u6587\u4ef6"):f&&c.startUpload(b,g["up"+f+"Url"],"*",function(a){var b=[],e;(e=g.onUpload)&&e(a);for(var r=0,j=a.length;r<j;r++)e=a[r],url=M(e,"string")?e:e.url,"!"===url.substr(0,1)&&(url=url.substr(1)),b.push(url);c.exec(f);d("#xhe"+
	f+"Url").val(b.join(" "));d("#xheSave").click()});return!1}});(j=g.shortcuts)&&d.each(j,function(a,b){c.addShortcuts(a,b)});aa++;Ma=!0;g.fullscreen?c.toggleFullscreen():g.sourceMode&&setTimeout(c.toggleSource,20);return!0};this.remove=function(){c.hidePanel();U();F.unbind("focus",c.focus);Ya.unbind("submit",U).unbind("reset",I);g.submitID&&d("#"+g.submitID).unbind("mousedown",U);d(window).unbind("unload beforeunload",U).unbind("resize",Na);d(document).unbind("mousedown",Oa);d("#"+ja).remove();d("#"+
	za).remove();F.show();Ma=!1};this.saveBookmark=function(){if(!y){c.focus();var a=c.getRng(),a=a.cloneRange?a.cloneRange():a;ha={top:fa.scrollTop(),rng:a}}};this.loadBookmark=function(){if(!y&&ha){c.focus();var a=ha.rng;if(i)a.select();else{var b=c.getSel();b.removeAllRanges();b.addRange(a)}fa.scrollTop(ha.top);ha=null}};this.focus=function(){y?d("#sourceCode",k).focus():W.focus();if(i){var a=c.getRng();a.parentElement&&a.parentElement().ownerDocument!==k&&c.setTextCursor()}return!1};this.setTextCursor=
	function(a){var b=c.getRng(!0),e=k.body;if(i)b.moveToElementText(e);else{for(var d=a?"lastChild":"firstChild";3!=e.nodeType&&e[d];)e=e[d];b.selectNode(e)}b.collapse(a?!1:!0);i?b.select():(a=c.getSel(),a.removeAllRanges(),a.addRange(b))};this.getSel=function(){return k.selection?k.selection:W.getSelection()};this.getRng=function(a){var b,e;try{a||(b=c.getSel(),e=b.createRange?b.createRange():0<b.rangeCount?b.getRangeAt(0):null),e||(e=k.body.createTextRange?k.body.createTextRange():k.createRange())}catch(d){}return e};
	this.getParent=function(a){var b=c.getRng(),e;i?e=b.item?b.item(0):b.parentElement():(e=b.commonAncestorContainer,b.collapsed||b.startContainer===b.endContainer&&2>b.startOffset-b.endOffset&&b.startContainer.hasChildNodes()&&(e=b.startContainer.childNodes[b.startOffset]));a=a?a:"*";e=d(e);e.is(a)||(e=d(e).closest(a));return e};this.getSelect=function(a){var b=c.getSel(),e=c.getRng(),f=!0,f=!e||e.item?!1:!b||0===e.boundingWidth||e.collapsed;if("text"===a)return f?"":e.text||(b.toString?b.toString():
	"");e.cloneContents?(a=d("<div></div>"),(e=e.cloneContents())&&a.append(e),e=a.html()):e=M(e.item)?e.item(0).outerHTML:M(e.htmlText)?e.htmlText:e.toString();f&&(e="");e=c.processHTML(e,"read");e=c.cleanHTML(e);return e=c.formatXHTML(e)};this.pasteHTML=function(a,b){if(y)return!1;c.focus();var a=c.processHTML(a,"write"),e=c.getSel(),f=c.getRng();if(b!==$){if(f.item){var h=f.item(0),f=c.getRng(!0);f.moveToElementText(h);f.select()}f.collapse(b)}a+="<"+(i?"img":"span")+' id="_xhe_temp" width="0" height="0" />';
	if(f.insertNode){if(0<d(f.startContainer).closest("style,script").length)return!1;f.deleteContents();f.insertNode(f.createContextualFragment(a))}else"control"===e.type.toLowerCase()&&(e.clear(),f=c.getRng()),f.pasteHTML(a);var h=d("#_xhe_temp",k),n=h[0];i?(f.moveToElementText(n),f.select()):(f.selectNode(n),e.removeAllRanges(),e.addRange(f));h.remove()};this.pasteText=function(a,b){a||(a="");a=c.domEncode(a);a=a.replace(/\r?\n/g,"<br />");c.pasteHTML(a,b)};this.appendHTML=function(a){if(y)return!1;
	c.focus();a=c.processHTML(a,"write");d(k.body).append(a);c.setTextCursor(!0)};this.domEncode=function(a){return a.replace(nb,function(a){return mb[a]})};this.setSource=function(a){ha=null;if("string"!==typeof a&&""!==a)a=z.value;y?d("#sourceCode",k).val(a):(g.beforeSetSource&&(a=g.beforeSetSource(a)),a=c.cleanHTML(a),a=c.formatXHTML(a),a=c.processHTML(a,"write"),i?(k.body.innerHTML='<img id="_xhe_temp" width="0" height="0" />'+a,d("#_xhe_temp",k).remove()):k.body.innerHTML=a)};this.processHTML=function(a,
	b){if("write"===b){a=a.replace(/(<(\/?)(\w+))((?:\s+[\w\-:]+\s*=\s*(?:"[^"]*"|'[^']*'|[^>\s]+))*)\s*((\/?)>)/g,function(a,b,c,e,d,f,h){e=e.toLowerCase();qa?"strong"===e?e="b":"em"===e&&(e="i"):R&&("strong"===e?(e="span",c||(d+=' class="Apple-style-span" style="font-weight: bold;"')):"em"===e?(e="span",c||(d+=' class="Apple-style-span" style="font-style: italic;"')):"u"===e?(e="span",c||(d+=' class="Apple-style-span" style="text-decoration: underline;"')):"strike"===e&&(e="span",c||(d+=' class="Apple-style-span" style="text-decoration: line-through;"')));
	var m,x="";if("del"===e)e="strike";else if("img"===e)d=d.replace(/\s+emot\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/i,function(a,b){m=b.match(/^(["']?)(.*)\1/)[2];m=m.split(",");m[1]||(m[1]=m[0],m[0]="");"default"===m[0]&&(m[0]="");return g.emotMark?a:""});else if("a"===e)!d.match(/ href=[^ ]/i)&&d.match(/ name=[^ ]/i)&&(x+=" xhe-anchor"),h&&(f="></a>");else if("table"===e&&!c&&(a=d.match(/\s+border\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/i),!a||a[1].match(/^(["']?)\s*0\s*\1$/)))x+=" xhe-border";var Z,d=d.replace(/\s+([\w\-:]+)\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/g,
	function(a,b,c){b=b.toLowerCase();c=c.match(/^(["']?)(.*)\1/)[2];aft="";if(i&&b.match(/^(disabled|checked|readonly|selected)$/)&&c.match(/^(false|0)$/i)||"img"===e&&m&&"src"===b)return"";b.match(/^(src|href)$/)&&(aft=" _xhe_"+b+'="'+c+'"',B&&(c=V(c,"abs",B)));x&&"class"===b&&(c+=" "+x,x="");R&&"style"===b&&"span"===e&&c.match(/(^|;)\s*(font-family|font-size|color|background-color)\s*:\s*[^;]+\s*(;|$)/i)&&(Z=!0);return" "+b+'="'+c+'"'+aft});m&&(a=Y+(m[0]?m[0]:"default")+"/"+m[1]+".gif",d+=' src="'+
	a+'" _xhe_src="'+a+'"');Z&&(d+=' class="Apple-style-span"');x&&(d+=' class="'+x+'"');return"<"+c+e+d+f});i&&(a=a.replace(/&apos;/ig,"&#39;"));if(!R)var e=function(a,b,e,c,d,f){var b="",h,m;(h=c.match(/font-family\s*:\s*([^;"]+)/i))&&(b+=' face="'+h[1]+'"');if(h=c.match(/font-size\s*:\s*([^;"]+)/i)){h=h[1].toLowerCase();for(var x=0;x<T.length;x++)if(h===T[x].n||h===T[x].s){m=x+1;break}m&&(b+=' size="'+m+'"',c=c.replace(/(^|;)(\s*font-size\s*:\s*[^;"]+;?)+/ig,"$1"))}if(m=c.match(/(?:^|[\s;])color\s*:\s*([^;"]+)/i)){if(h=
	m[1].match(/\s*rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/i)){m[1]="#";for(x=1;3>=x;x++)m[1]+=(h[x]-0).toString(16)}m[1]=m[1].replace(/^#([0-9a-f])([0-9a-f])([0-9a-f])$/i,"#$1$1$2$2$3$3");b+=' color="'+m[1]+'"'}c=c.replace(/(^|;)(\s*(font-family|color)\s*:\s*[^;"]+;?)+/ig,"$1");return""!==b?(c&&(b+=' style="'+c+'"'),"<font"+(e?e:"")+b+(d?d:"")+">"+f+"</font>"):a},a=a.replace(/<(span)(\s+[^>]*?)?\s+style\s*=\s*"((?:[^"]*?;)?\s*(?:font-family|font-size|color)\s*:[^"]*)"( [^>]*)?>(((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S])*?<\/\1>)*?<\/\1>)*?)<\/\1>/ig,
	e),a=a.replace(/<(span)(\s+[^>]*?)?\s+style\s*=\s*"((?:[^"]*?;)?\s*(?:font-family|font-size|color)\s*:[^"]*)"( [^>]*)?>(((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S])*?<\/\1>)*?)<\/\1>/ig,e),a=a.replace(/<(span)(\s+[^>]*?)?\s+style\s*=\s*"((?:[^"]*?;)?\s*(?:font-family|font-size|color)\s*:[^"]*)"( [^>]*)?>(((?!<\1(\s+[^>]*?)?>)[\s\S])*?)<\/\1>/ig,e);a=a.replace(/<(td|th)(\s+[^>]*?)?>(\s|&nbsp;)*<\/\1>/ig,"<$1$2>"+(i?"":"<br />")+"</$1>")}else{if(R)for(var c=[{r:/font-weight\s*:\s*bold;?/ig,
	t:"strong"},{r:/font-style\s*:\s*italic;?/ig,t:"em"},{r:/text-decoration\s*:\s*underline;?/ig,t:"u"},{r:/text-decoration\s*:\s*line-through;?/ig,t:"strike"}],e=function(a,b,e,d,h){for(var a=(e?e:"")+(d?d:""),g=[],D=[],m,e=0;e<c.length;e++)b=c[e].r,m=c[e].t,a=a.replace(b,function(){g.push("<"+m+">");D.push("</"+m+">");return""});a=a.replace(/\s+style\s*=\s*"\s*"/i,"");return(a?"<span"+a+">":"")+g.join("")+h+D.join("")+(a?"</span>":"")},d=0;2>d;d++)a=a.replace(/<(span)(\s+[^>]*?)?\s+class\s*=\s*"Apple-style-span"(\s+[^>]*?)?>(((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S])*?<\/\1>)*?<\/\1>)*?)<\/\1>/ig,
	e),a=a.replace(/<(span)(\s+[^>]*?)?\s+class\s*=\s*"Apple-style-span"(\s+[^>]*?)?>(((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S])*?<\/\1>)*?)<\/\1>/ig,e),a=a.replace(/<(span)(\s+[^>]*?)?\s+class\s*=\s*"Apple-style-span"(\s+[^>]*?)?>(((?!<\1(\s+[^>]*?)?>)[\s\S])*?)<\/\1>/ig,e);a=a.replace(/(<(\w+))((?:\s+[\w\-:]+\s*=\s*(?:"[^"]*"|'[^']*'|[^>\s]+))*)\s*(\/?>)/g,function(a,b,e,c,d){var e=e.toLowerCase(),f,c=c.replace(/\s+_xhe_(?:src|href)\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/i,function(a,
	b){f=b.match(/^(["']?)(.*)\1/)[2];return""});f&&va&&(f=V(f,va,B));c=c.replace(/\s+([\w\-:]+)\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/g,function(a,b,c){b=b.toLowerCase();c=c.match(/^(["']?)(.*)\1/)[2].replace(/"/g,"'");if("class"===b){if(c.match(/^["']?(apple|webkit)/i))return"";c=c.replace(/\s?xhe-[a-z]+/ig,"");if(""===c)return""}else{if(b.match(/^((_xhe_|_moz_|_webkit_)|jquery\d+)/i))return"";if(f&&b.match(/^(src|href)$/i))return" "+b+'="'+f+'"';"style"===b&&(c=c.replace(/(^|;)\s*(font-size)\s*:\s*([a-z-]+)\s*(;|$)/i,
	function(a,b,c,e,d){for(var f,h=0;h<T.length;h++)if(a=T[h],e===a.n){f=a.s;break}return b+c+":"+f+d}))}return" "+b+'="'+c+'"'});"img"===e&&!c.match(/\s+alt\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/i)&&(c+=' alt=""');return b+c+d});a=a.replace(/(<(td|th)(?:\s+[^>]*?)?>)\s*([\s\S]*?)(<br(\s*\/)?>)?\s*<\/\2>/ig,function(a,b,c,e){return b+(e?e:"&nbsp;")+"</"+c+">"});a=a.replace(/^\s*(?:<(p|div)(?:\s+[^>]*?)?>)?\s*(<span(?:\s+[^>]*?)?>\s*<\/span>|<br(?:\s+[^>]*?)?>|&nbsp;)*\s*(?:<\/\1>)?\s*$/i,"")}return a=a.replace(/(<pre(?:\s+[^>]*?)?>)([\s\S]+?)(<\/pre>)/gi,
	function(a,b,c,e){return b+c.replace(/<br\s*\/?>/ig,"\r\n")+e})};this.getSource=function(a){var b,e=g.beforeGetSource;y?(b=d("#sourceCode",k).val(),e||(b=c.formatXHTML(b,!1))):(b=c.processHTML(k.body.innerHTML,"read"),b=c.cleanHTML(b),b=c.formatXHTML(b,a),e&&(b=e(b)));return z.value=b};this.cleanWord=function(a){var b=g.cleanPaste;if(0<b&&3>b&&a.match(/mso(-|normal)|WordDocument|<table\s+[^>]*?x:str/i)){for(var a=a.replace(/<\!--[\s\S]*?--\>|<!(--)?\[[\s\S]+?\](--)?>|<style(\s+[^>]*?)?>[\s\S]*?<\/style>/ig,
	""),a=a.replace(/\r?\n/ig,""),a=a.replace(/(<(\/?)([\w\-:]+))((?:\s+[\w\-:]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^>\s]+))?)*)\s*(\/?>)/g,function(a,c,e,d,g,u){d=d.toLowerCase();if(d.match(/^(link|img)$/)&&g.match(/file:\/\//i)||d.match(/:/)||"span"===d&&2===b||!e&&(g=g.replace(/\s([\w\-:]+)(?:\s*=\s*("[^"]*"|'[^']*'|[^>\s]+))?/ig,function(a,c,e){c=c.toLowerCase();e=e.match(/^(["']?)(.*)\1/)[2];if(c.match(/:/)||c.match(/^(class|lang|language|span)$/)||"td"===d&&("height"===c||"width"===c&&!g.match(/\scolspan="\d+"/i)))return"";
	return"style"===c?2===b?"":(e=e.replace(/"|&quot;/ig,"'").replace(/\s*([^:]+)\s*:\s*(.*?)(;|$)/ig,function(a,b,c){return/^(color|background)$/i.test(b)?b+":"+c+";":""}).replace(/^\s+|\s+$/g,""))?" "+c+'="'+e+'"':"":a}),"span"===d&&/^\s*$/.test(g)))return"";return c+g+u}),c=0;3>c;c++)a=a.replace(/<([^\s>]+)(\s+[^>]*)?>\s*<\/\1>/g,function(a,b){return b.match(/^a$/i)?a:""});for(c=0;3>c;c++)a=a.replace(/<font(\s+[^>]+)><font(\s+[^>]+)>/ig,function(a,b,c){return"<font"+b+c+">"})}return a};this.cleanHTML=
	function(a){var a=a.replace(/<!?\/?(DOCTYPE|html|body|meta)(\s+[^>]*?)?>/ig,""),b,a=a.replace(/<head(?:\s+[^>]*?)?>([\s\S]*?)<\/head>/i,function(a,c){b=c.match(/<(script|style)(\s+[^>]*?)?>[\s\S]*?<\/\1>/ig);return""});b&&(a=b.join("")+a);a=a.replace(/<\??xml(:\w+)?(\s+[^>]*?)?>([\s\S]*?<\/xml>)?/ig,"");g.internalScript||(a=a.replace(/<script(\s+[^>]*?)?>[\s\S]*?<\/script>/ig,""));g.internalStyle||(a=a.replace(/<style(\s+[^>]*?)?>[\s\S]*?<\/style>/ig,""));if(!g.linkTag||!g.inlineScript||!g.inlineStyle)a=
	a.replace(/(<(\w+))((?:\s+[\w-]+\s*=\s*(?:"[^"]*"|'[^']*'|[^>\s]+))*)\s*(\/?>)/ig,function(a,b,c,d,j){if(!g.linkTag&&"link"===c.toLowerCase())return"";g.inlineScript||(d=d.replace(/\s+on(?:click|dblclick|mouse(down|up|move|over|out|enter|leave|wheel)|key(down|press|up)|change|select|submit|reset|blur|focus|load|unload)\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/ig,""));g.inlineStyle||(d=d.replace(/\s+(style|class)\s*=\s*("[^"]*"|'[^']*'|[^>\s]+)/ig,""));return b+d+j});return a=a.replace(/<\/(strong|b|u|strike|em|i)>((?:\s|<br\/?>|&nbsp;)*?)<\1(\s+[^>]*?)?>/ig,
	"$2")};this.formatXHTML=function(a,b){function e(a){for(var b={},a=a.split(","),c=0;c<a.length;c++)b[a[c]]=!0;return b}function d(a){var a=a.toLowerCase(),b=o[a];return b?b:a}function h(a,b,c){if(m[a])for(;E.last()&&x[E.last()];)g(E.last());Z[a]&&E.last()===a&&g(a);(c=D[a]||!!c)||E.push(a);var e=[];e.push("<"+a);b.replace(y,function(a,b,c,d,f){b=b.toLowerCase();e.push(" "+b+'="'+(c?c:d?d:f?f:k[b]?b:"").replace(/"/g,"'")+'"')});e.push((c?" /":"")+">");u(e.join(""),a,!0);"pre"===a&&(B=!0)}function g(a){if(a)for(b=
	E.length-1;0<=b&&!(E[b]===a);b--);else var b=0;if(0<=b){for(var c=E.length-1;c>=b;c--)u("</"+E[c]+">",E[c]);E.length=b}"pre"===a&&(B=!1,w--)}function j(a){u(c.domEncode(a))}function l(a){G.push(a.replace(/^[\s\r\n]+|[\s\r\n]+$/g,""))}function u(a,c,e){B||(a=a.replace(/(\t*\r?\n\t*)+/g,""));if(!B&&!0===b)if(a.match(/^\s*$/))G.push(a);else{var d=m[c];d?(e&&w++,""===A&&w--):A&&w++;((d?c:"")!==A||d)&&r();G.push(a);"br"===c&&r();d&&(D[c]||!e)&&w--;A=d?c:""}else G.push(a)}function r(){G.push("\r\n");if(0<
	w)for(var a=w;a--;)G.push("\t")}function s(a,b,c,e){if(!c)return e;var d="",c=c.replace(/ face\s*=\s*"\s*([^"]*)\s*"/i,function(a,b){b&&(d+="font-family:"+b+";");return""}),c=c.replace(/ size\s*=\s*"\s*(\d+)\s*"/i,function(a,b){d+="font-size:"+T[(7<b?7:1>b?1:b)-1].s+";";return""}),c=c.replace(/ color\s*=\s*"\s*([^"]*)\s*"/i,function(a,b){b&&(d+="color:"+b+";");return""}),c=c.replace(/ style\s*=\s*"\s*([^"]*)\s*"/i,function(a,b){b&&(d+=b);return""});return(c+=' style="'+d+'"')?"<span"+c+">"+e+"</span>":
	e}var D=e("area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed"),m=e("address,applet,blockquote,button,center,dd,dir,div,dl,dt,fieldset,form,frameset,h1,h2,h3,h4,h5,h6,hr,iframe,ins,isindex,li,map,menu,noframes,noscript,object,ol,p,pre,table,tbody,td,tfoot,th,thead,tr,ul,script"),x=e("a,abbr,acronym,applet,b,basefont,bdo,big,br,button,cite,code,del,dfn,em,font,i,iframe,img,input,ins,kbd,label,map,object,q,s,samp,script,select,small,span,strike,strong,sub,sup,textarea,tt,u,var"),
	Z=e("colgroup,dd,dt,li,options,p,td,tfoot,th,thead,tr"),k=e("checked,compact,declare,defer,disabled,ismap,multiple,nohref,noresize,noshade,nowrap,readonly,selected"),i=e("script,style"),o={b:"strong",i:"em",s:"del",strike:"del"},q=/<(?:\/([^\s>]+)|!([^>]*?)|([\w\-:]+)((?:"[^"]*"|'[^']*'|[^"'<>])*)\s*(\/?))>/g,y=/\s*([\w\-:]+)(?:\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s]+)))?/g,G=[],E=[];E.last=function(){return this[this.length-1]};for(var v,C,p=0,t,z,w=-1,A="body",B=!1;v=q.exec(a);){C=v.index;C>p&&(p=
	a.substring(p,C),t?z.push(p):j(p));p=q.lastIndex;if(C=v[1])if(C=d(C),t&&C===t&&(l(z.join("")),z=t=null),!t){g(C);continue}t?z.push(v[0]):(C=v[3])?(C=d(C),h(C,v[4],v[5]),i[C]&&(t=C,z=[])):v[2]&&G.push(v[0])}a.length>p&&j(a.substring(p,a.length));g();a=G.join("");G=null;a=a.replace(/<(font)(\s+[^>]*?)?>(((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S])*?<\/\1>)*?<\/\1>)*?)<\/\1>/ig,s);a=a.replace(/<(font)(\s+[^>]*?)?>(((?!<\1(\s+[^>]*?)?>)[\s\S]|<\1(\s+[^>]*?)?>((?!<\1(\s+[^>]*?)?>)[\s\S])*?<\/\1>)*?)<\/\1>/ig,
	s);a=a.replace(/<(font)(\s+[^>]*?)?>(((?!<\1(\s+[^>]*?)?>)[\s\S])*?)<\/\1>/ig,s);return a=a.replace(/^(\s*\r?\n)+|(\s*\r?\n)+$/g,"")};this.toggleShowBlocktag=function(a){na!==a&&(na=!na,a=d(k.body),na?(Q+=" showBlocktag",a.addClass("showBlocktag")):(Q=Q.replace(" showBlocktag",""),a.removeClass("showBlocktag")))};this.toggleSource=function(a){if(y!==a){q.find("[cmd=Source]").toggleClass("xheEnabled").toggleClass("xheActive");var b=k.body,e=d(b),f,h,a=0,g="";if(y)f=c.getSource(),e.html("").removeAttr("scroll").attr("class",
	"editMode"+Q),i?b.contentEditable="true":k.designMode="On",qa&&(c._exec("inserthtml","-"),d("#"+za).show().focus().hide()),g="\u6e90\u4ee3\u7801";else{c.pasteHTML('<span id="_xhe_cursor"></span>',!0);f=c.getSource(!0);a=f.indexOf('<span id="_xhe_cursor"></span>');if(!Ca)a=f.substring(0,a).replace(/\r/g,"").length;f=f.replace(/(\r?\n\s*|)<span id="_xhe_cursor"><\/span>(\s*\r?\n|)/,function(a,b,c){return b&&c?"\r\n":b+c});i?b.contentEditable="false":k.designMode="Off";e.attr("scroll","no").attr("class",
	"sourceMode").html('<textarea id="sourceCode" wrap="soft" spellcheck="false" style="width:100%;height:100%" />');h=d("#sourceCode",e).blur(c.getSource)[0];g="\u53ef\u89c6\u5316\u7f16\u8f91"}y=!y;c.setSource(f);c.focus();y?h.setSelectionRange?h.setSelectionRange(a,a):(h=h.createTextRange(),h.move("character",a),h.select()):c.setTextCursor();q.find("[cmd=Source]").attr("title",g).find("span").text(g);q.find("[cmd=Source],[cmd=Preview]").toggleClass("xheEnabled");q.find(".xheButton").not("[cmd=Source],[cmd=Fullscreen],[cmd=About]").toggleClass("xheEnabled").attr("aria-disabled",
	y?!0:!1);setTimeout(La,300)}};this.showPreview=function(){var a=g.beforeSetSource,b=c.getSource();a&&(b=a(b));var a="<html><head>"+P+"<title>\u9884\u89c8</title>"+(B?'<base href="'+B+'"/>':"")+"</head><body>"+b+"</body></html>",b=window.screen,b=window.open("","xhePreview","toolbar=yes,location=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width="+Math.round(0.9*b.width)+",height="+Math.round(0.8*b.height)+",left="+Math.round(0.05*b.width)),e=b.document;e.open();e.write(a);e.close();b.focus()};
	this.toggleFullscreen=function(a){if(la!==a){var a=d("#"+ja).find(".xheLayout"),b=d("#"+ja),e=jQuery.browser.version,e=i&&(6==e||7==e);la?(e&&F.after(b),a.attr("style",Za),A.height(O-q.outerHeight()),d(window).scrollTop(Pa),setTimeout(function(){d(window).scrollTop(Pa)},10)):(e&&d("body").append(b),Pa=d(window).scrollTop(),Za=a.attr("style"),a.removeAttr("style"),A.height("100%"),setTimeout(Na,100));qa?(d("#"+za).show().focus().hide(),setTimeout(c.focus,1)):e&&c.setTextCursor();la=!la;b.toggleClass("xhe_Fullscreen");
	d("html").toggleClass("xhe_Fullfix");q.find("[cmd=Fullscreen]").toggleClass("xheActive");setTimeout(La,300)}};this.showMenu=function(a,b){var e=d('<div class="xheMenu"></div>'),f=a.length,h=[];d.each(a,function(a,b){"-"===b.s?h.push('<div class="xheMenuSeparator"></div>'):h.push("<a href=\"javascript:void('"+b.v+'\')" title="'+(b.t?b.t:b.s)+'" v="'+b.v+'" role="option" aria-setsize="'+f+'" aria-posinset="'+(a+1)+'" tabindex="0">'+b.s+"</a>")});e.append(h.join(""));e.click(function(a){a=a.target;if(!d.nodeName(a,
	"DIV"))return c.loadBookmark(),b(d(a).closest("a").attr("v")),c.hidePanel(),!1}).mousedown(N);c.saveBookmark();c.showPanel(e)};this.showColor=function(a){var b=d('<div class="xheColor"></div>'),e=[],f=Ta.length,h=0;d.each(Ta,function(a,b){0===h%7&&e.push((0<h?"</div>":"")+"<div>");e.push("<a href=\"javascript:void('"+b+'\')" xhev="'+b+'" title="'+b+'" style="background:'+b+'" role="option" aria-setsize="'+f+'" aria-posinset="'+(h+1)+'"></a>');h++});e.push("</div>");b.append(e.join(""));b.click(function(b){b=
	b.target;if(d.nodeName(b,"A"))return c.loadBookmark(),a(d(b).attr("xhev")),c.hidePanel(),!1}).mousedown(N);c.saveBookmark();c.showPanel(b)};this.showPastetext=function(){var a=d('<div><label for="xhePastetextValue">\u4f7f\u7528\u952e\u76d8\u5feb\u6377\u952e(Ctrl+V)\u628a\u5185\u5bb9\u7c98\u8d34\u5230\u65b9\u6846\u91cc\uff0c\u6309 \u786e\u5b9a</label></div><div><textarea id="xhePastetextValue" wrap="soft" spellcheck="false" style="width:300px;height:100px;" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>'),
	b=d("#xhePastetextValue",a);d("#xheSave",a).click(function(){c.loadBookmark();var a=b.val();a&&c.pasteText(a);c.hidePanel();return!1});c.saveBookmark();c.showDialog(a)};this.showLink=function(){var a='<div><label for="xheLinkUrl">\u94fe\u63a5\u5730\u5740: </label><input type="text" id="xheLinkUrl" value="http://" class="xheText" /></div><div><label for="xheLinkTarget">\u6253\u5f00\u65b9\u5f0f: </label><select id="xheLinkTarget"><option selected="selected" value="">\u9ed8\u8ba4</option><option value="_blank">\u65b0\u7a97\u53e3</option><option value="_self">\u5f53\u524d\u7a97\u53e3</option><option value="_parent">\u7236\u7a97\u53e3</option></select></div><div style="display:none"><label for="xheLinkText">\u94fe\u63a5\u6587\u5b57: </label><input type="text" id="xheLinkText" value="" class="xheText" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>',
	b=ga.find("a[name]").not("[href]"),e=0<b.length;if(e){var f=[];b.each(function(){var a=d(this).attr("name");f.push('<option value="#'+a+'">'+a+"</option>")});a=a.replace(/(<div><label for="xheLinkTarget)/,'<div><label for="xheLinkAnchor">\u9875\u5185\u951a\u70b9: </label><select id="xheLinkAnchor"><option value="">\u672a\u9009\u62e9</option>'+f.join("")+"</select></div>$1")}var a=d(a),h=c.getParent("a"),n=d("#xheLinkText",a),j=d("#xheLinkUrl",a),l=d("#xheLinkTarget",a),b=d("#xheSave",a),u=c.getSelect();
	e&&a.find("#xheLinkAnchor").change(function(){var a=d(this).val();""!=a&&j.val(a)});if(1===h.length){if(!h.attr("href"))return w=null,c.exec("Anchor");j.val(L(h,"href"));l.attr("value",h.attr("target"))}else""===u&&n.val(g.defLinkText).closest("div").show();g.upLinkUrl&&c.uploadInit(j,g.upLinkUrl,g.upLinkExt);b.click(function(){c.loadBookmark();var a=j.val();(""===a||0===h.length)&&c._exec("unlink");if(""!==a&&"http://"!==a){var b=a.split(" "),e=l.val(),f=n.val();if(1<b.length){c._exec("unlink");
	u=c.getSelect();var g='<a href="xhe_tmpurl"',Z=[];""!==e&&(g+=' target="'+e+'"');for(var g=g+">xhe_tmptext</a>",f=""!==u?u:f?f:a,i=0,pb=b.length;i<pb;i++)a=b[i],""!==a&&(a=a.split("||"),e=g,e=e.replace("xhe_tmpurl",a[0]),e=e.replace("xhe_tmptext",a[1]?a[1]:f),Z.push(e));c.pasteHTML(Z.join("&nbsp;"))}else a=b[0].split("||"),f||(f=a[0]),f=a[1]?a[1]:""!==u?"":f?f:a[0],0===h.length?(f?c.pasteHTML('<a href="#xhe_tmpurl">'+f+"</a>"):c._exec("createlink","#xhe_tmpurl"),h=d('a[href$="#xhe_tmpurl"]',k)):f&&
	!R&&h.text(f),L(h,"href",a[0]),""!==e?h.attr("target",e):h.removeAttr("target")}c.hidePanel();return!1});c.saveBookmark();c.showDialog(a)};this.showAnchor=function(){var a=d('<div><label for="xheAnchorName">\u951a\u70b9\u540d\u79f0: </label><input type="text" id="xheAnchorName" value="" class="xheText" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>'),b=c.getParent("a"),e=d("#xheAnchorName",a),f=d("#xheSave",a);if(1===b.length){if(b.attr("href"))return w=
	null,c.exec("Link");e.val(b.attr("name"))}f.click(function(){c.loadBookmark();var a=e.val();a?0===b.length?c.pasteHTML('<a name="'+a+'"></a>'):b.attr("name",a):1===b.length&&b.remove();c.hidePanel();return!1});c.saveBookmark();c.showDialog(a)};this.showImg=function(){var a=d('<div><label for="xheImgUrl">\u56fe\u7247\u6587\u4ef6: </label><input type="text" id="xheImgUrl" value="http://" class="xheText" /></div><div><div><label for="xheImgAlt">\u66ff\u6362\u6587\u672c: </label><input type="text" id="xheImgAlt" /></div><div><label for="xheImgAlign">\u5bf9\u9f50\u65b9\u5f0f: </label><select id="xheImgAlign"><option selected="selected" value="">\u9ed8\u8ba4</option><option value="left">\u5de6\u5bf9\u9f50</option><option value="right">\u53f3\u5bf9\u9f50</option><option value="top">\u9876\u7aef</option><option value="middle">\u5c45\u4e2d</option><option value="baseline">\u57fa\u7ebf</option><option value="bottom">\u5e95\u8fb9</option></select></div><div><label for="xheImgWidth">\u5bbd\u3000\u3000\u5ea6: </label><input type="text" id="xheImgWidth" style="width:40px;" /> <label for="xheImgHeight">\u9ad8\u3000\u3000\u5ea6: </label><input type="text" id="xheImgHeight" style="width:40px;" /></div><div><label for="xheImgBorder">\u8fb9\u6846\u5927\u5c0f: </label><input type="text" id="xheImgBorder" style="width:40px;" /></div><div><label for="xheImgHspace">\u6c34\u5e73\u95f4\u8ddd: </label><input type="text" id="xheImgHspace" style="width:40px;" /> <label for="xheImgVspace">\u5782\u76f4\u95f4\u8ddd: </label><input type="text" id="xheImgVspace" style="width:40px;" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>'),
	b=c.getParent("img"),e=d("#xheImgUrl",a),f=d("#xheImgAlt",a),h=d("#xheImgAlign",a),n=d("#xheImgWidth",a),j=d("#xheImgHeight",a),l=d("#xheImgBorder",a),u=d("#xheImgVspace",a),r=d("#xheImgHspace",a),s=d("#xheSave",a);if(1===b.length){e.val(L(b,"src"));f.val(b.attr("alt"));h.val(b.attr("align"));n.val(b.attr("width"));j.val(b.attr("height"));l.val(b.attr("border"));var D=b.attr("vspace"),m=b.attr("hspace");u.val(0>=D?"":D);r.val(0>=m?"":m)}g.upImgUrl&&c.uploadInit(e,g.upImgUrl,g.upImgExt);s.click(function(){c.loadBookmark();
	var a=e.val();if(""!==a&&"http://"!==a){var g=a.split(" "),m=f.val(),D=h.val(),s=n.val(),i=j.val(),o=l.val(),p=u.val(),q=r.val();if(1<g.length){var v='<img src="xhe_tmpurl"',t=[];""!==m&&(v+=' alt="'+m+'"');""!==D&&(v+=' align="'+D+'"');""!==s&&(v+=' width="'+s+'"');""!==i&&(v+=' height="'+i+'"');""!==o&&(v+=' border="'+o+'"');""!==p&&(v+=' vspace="'+p+'"');""!==q&&(v+=' hspace="'+q+'"');var v=v+" />",w;for(w in g)a=g[w],""!==a&&(a=a.split("||"),m=v,m=m.replace("xhe_tmpurl",a[0]),a[1]&&(m='<a href="'+
	a[1]+'" target="_blank">'+m+"</a>"),t.push(m));c.pasteHTML(t.join("&nbsp;"))}else 1===g.length&&(a=g[0],""!==a&&(a=a.split("||"),0===b.length&&(c.pasteHTML('<img src="'+a[0]+'#xhe_tmpurl" />'),b=d('img[src$="#xhe_tmpurl"]',k)),L(b,"src",a[0]),""!==m&&b.attr("alt",m),""!==D?b.attr("align",D):b.removeAttr("align"),""!==s?b.attr("width",s):b.removeAttr("width"),""!==i?b.attr("height",i):b.removeAttr("height"),""!==o?b.attr("border",o):b.removeAttr("border"),""!==p?b.attr("vspace",p):b.removeAttr("vspace"),
	""!==q?b.attr("hspace",q):b.removeAttr("hspace"),a[1]&&(g=b.parent("a"),0===g.length&&(b.wrap("<a></a>"),g=b.parent("a")),L(g,"href",a[1]),g.attr("target","_blank"))))}else 1===b.length&&b.remove();c.hidePanel();return!1});c.saveBookmark();c.showDialog(a)};this.showEmbed=function(a,b,e,f,g,n,j){var b=d(b),l=c.getParent('embed[type="'+e+'"],embed[classid="'+f+'"]'),u=d("#xhe"+a+"Url",b),r=d("#xhe"+a+"Width",b),s=d("#xhe"+a+"Height",b),a=d("#xheSave",b);n&&c.uploadInit(u,n,j);1===l.length&&(u.val(L(l,
	"src")),r.val(l.attr("width")),s.val(l.attr("height")));a.click(function(){c.loadBookmark();var a=u.val();if(""!==a&&"http://"!==a){var b=r.val(),j=s.val(),n=/^\d+%?$/;n.test(b)||(b=412);n.test(j)||(j=300);var i='<embed type="'+e+'" classid="'+f+'" src="xhe_tmpurl"'+g,n=a.split(" ");if(1<n.length){var o,p=[],i=i+' width="xhe_width" height="xhe_height" />',q;for(q in n)a=n[q].split("||"),o=i,o=o.replace("xhe_tmpurl",a[0]),o=o.replace("xhe_width",a[1]?a[1]:b),o=o.replace("xhe_height",a[2]?a[2]:j),""!==
	a&&p.push(o);c.pasteHTML(p.join("&nbsp;"))}else 1===n.length&&(a=n[0].split("||"),0===l.length&&(c.pasteHTML(i.replace("xhe_tmpurl",a[0]+"#xhe_tmpurl")+" />"),l=d('embed[src$="#xhe_tmpurl"]',k)),L(l,"src",a[0]),l.attr("width",a[1]?a[1]:b),l.attr("height",a[2]?a[2]:j))}else 1===l.length&&l.remove();c.hidePanel();return!1});c.saveBookmark();c.showDialog(b)};this.showEmot=function(a){var b=d('<div class="xheEmot"></div>'),a=a?a:Ra?Ra:"default",e=Aa[a],f=Y+a+"/",g=0,n=[],j="",j=e.width,l=e.height,u=e.line,
	r=e.count,e=e.list;if(r)for(e=1;e<=r;e++)g++,n.push("<a href=\"javascript:void('"+e+'\')" style="background-image:url('+f+e+'.gif);" emot="'+a+","+e+'" xhev="" title="'+e+'" role="option">&nbsp;</a>'),0===g%u&&n.push("<br />");else d.each(e,function(b,c){g++;n.push("<a href=\"javascript:void('"+c+'\')" style="background-image:url('+f+b+'.gif);" emot="'+a+","+b+'" title="'+c+'" xhev="'+c+'" role="option">&nbsp;</a>');0===g%u&&n.push("<br />")});var r=u*(j+12),e=Math.ceil(g/u)*(l+12),s=0.75*r;e<=s&&
	(s="");j=d("<style>"+(s?".xheEmot div{width:"+(r+20)+"px;height:"+s+"px;}":"")+".xheEmot div a{width:"+j+"px;height:"+l+"px;}</style><div>"+n.join("")+"</div>").click(function(a){var a=a.target,b=d(a);if(d.nodeName(a,"A"))return c.loadBookmark(),c.pasteHTML('<img emot="'+b.attr("emot")+'" alt="'+b.attr("xhev")+'">'),c.hidePanel(),!1}).mousedown(N);b.append(j);var i=0,m=['<ul role="tablist">'];d.each(Aa,function(b,c){i++;m.push("<li"+(a===b?' class="cur"':"")+' role="presentation"><a href="javascript:void(\''+
	c.name+'\')" group="'+b+'" role="tab" tabindex="0">'+c.name+"</a></li>")});1<i&&(m.push('</ul><br style="clear:both;" />'),j=d(m.join("")).click(function(a){Ra=d(a.target).attr("group");c.exec("Emot");return!1}).mousedown(N),b.append(j));c.saveBookmark();c.showPanel(b)};this.showTable=function(){var a=d('<div><label for="xheTableRows">\u884c\u3000\u3000\u6570: </label><input type="text" id="xheTableRows" style="width:40px;" value="3" /> <label for="xheTableColumns">\u5217\u3000\u3000\u6570: </label><input type="text" id="xheTableColumns" style="width:40px;" value="2" /></div><div><label for="xheTableHeaders">\u6807\u9898\u5355\u5143: </label><select id="xheTableHeaders"><option selected="selected" value="">\u65e0</option><option value="row">\u7b2c\u4e00\u884c</option><option value="col">\u7b2c\u4e00\u5217</option><option value="both">\u7b2c\u4e00\u884c\u548c\u7b2c\u4e00\u5217</option></select></div><div><label for="xheTableWidth">\u5bbd\u3000\u3000\u5ea6: </label><input type="text" id="xheTableWidth" style="width:40px;" value="200" /> <label for="xheTableHeight">\u9ad8\u3000\u3000\u5ea6: </label><input type="text" id="xheTableHeight" style="width:40px;" value="" /></div><div><label for="xheTableBorder">\u8fb9\u6846\u5927\u5c0f: </label><input type="text" id="xheTableBorder" style="width:40px;" value="1" /></div><div><label for="xheTableCellSpacing">\u8868\u683c\u95f4\u8ddd: </label><input type="text" id="xheTableCellSpacing" style="width:40px;" value="1" /> <label for="xheTableCellPadding">\u8868\u683c\u586b\u5145: </label><input type="text" id="xheTableCellPadding" style="width:40px;" value="1" /></div><div><label for="xheTableAlign">\u5bf9\u9f50\u65b9\u5f0f: </label><select id="xheTableAlign"><option selected="selected" value="">\u9ed8\u8ba4</option><option value="left">\u5de6\u5bf9\u9f50</option><option value="center">\u5c45\u4e2d</option><option value="right">\u53f3\u5bf9\u9f50</option></select></div><div><label for="xheTableCaption">\u8868\u683c\u6807\u9898: </label><input type="text" id="xheTableCaption" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>'),
	b=d("#xheTableRows",a),e=d("#xheTableColumns",a),f=d("#xheTableHeaders",a),g=d("#xheTableWidth",a),n=d("#xheTableHeight",a),j=d("#xheTableBorder",a),l=d("#xheTableCellSpacing",a),u=d("#xheTableCellPadding",a),r=d("#xheTableAlign",a),s=d("#xheTableCaption",a);d("#xheSave",a).click(function(){c.loadBookmark();var a=s.val(),d=j.val(),i=b.val(),k=e.val(),o=f.val(),p=g.val(),q=n.val(),t=l.val(),w=u.val(),z=r.val(),d="<table"+(""!==d?' border="'+d+'"':"")+(""!==p?' width="'+p+'"':"")+(""!==q?' height="'+
	q+'"':"")+(""!==t?' cellspacing="'+t+'"':"")+(""!==w?' cellpadding="'+w+'"':"")+(""!==z?' align="'+z+'"':"")+">";""!==a&&(d+="<caption>"+a+"</caption>");if("row"===o||"both"===o){d+="<tr>";for(a=0;a<k;a++)d+='<th scope="col"></th>';d+="</tr>";i--}d+="<tbody>";for(a=0;a<i;a++){d+="<tr>";for(p=0;p<k;p++)d=0===p&&("col"===o||"both"===o)?d+'<th scope="row"></th>':d+"<td></td>";d+="</tr>"}c.pasteHTML(d+"</tbody></table>");c.hidePanel();return!1});c.saveBookmark();c.showDialog(a)};this.showAbout=function(){var a=
	d('<div style="font:12px Arial;width:245px;word-wrap:break-word;word-break:break-all;outline:none;" role="dialog" tabindex="-1"><p><span style="font-size:20px;color:#1997DF;">xhEditor</span><br />v1.1.13 (build 120304)</p><p>xhEditor\u662f\u57fa\u4e8ejQuery\u5f00\u53d1\u7684\u8de8\u5e73\u53f0\u8f7b\u91cf\u53ef\u89c6\u5316XHTML\u7f16\u8f91\u5668\uff0c\u57fa\u4e8e<a href="http://www.gnu.org/licenses/lgpl.html" target="_blank">LGPL</a>\u5f00\u6e90\u534f\u8bae\u53d1\u5e03\u3002</p><p>Copyright &copy; <a href="http://xheditor.com/" target="_blank">xhEditor.com</a>. All rights reserved.</p></div>');
	a.find("p").attr("role","presentation");c.showDialog(a,!0);setTimeout(function(){a.focus()},100)};this.addShortcuts=function(a,b){a=a.toLowerCase();ma[a]===$&&(ma[a]=[]);ma[a].push(b)};this.delShortcuts=function(a){delete ma[a]};this.uploadInit=function(a,b,e){function f(b){M(b,"string")&&(b=[b]);var c=!1,e,d=b.length,f,h=[];(e=g.onUpload)&&e(b);for(e=0;e<d;e++)f=b[e],f=M(f,"string")?f:f.url,"!"===f.substr(0,1)&&(c=!0,f=f.substr(1)),h.push(f);a.val(h.join(" "));c&&a.closest(".xheDialog").find("#xheSave").click()}
	var h=d('<span class="xheUpload"><input type="text" style="visibility:hidden;" tabindex="-1" /><input type="button" value="'+g.upBtnText+'" class="xheBtn" tabindex="-1" /></span>'),n=d(".xheBtn",h),j=g.html5Upload,l=j?g.upMultiple:1;a.after(h);n.before(a);b=b.replace(/{editorRoot}/ig,K);if("!"===b.substr(0,1))n.click(function(){c.showIframeModal("\u4e0a\u4f20\u6587\u4ef6",b.substr(1),f,null,null)});else{h.append('<input type="file"'+(1<l?' multiple=""':"")+' class="xheFile" size="13" name="filedata" tabindex="-1" />');
	var i=d(".xheFile",h);i.change(function(){c.startUpload(i[0],b,e,f)});setTimeout(function(){a.closest(".xheDialog").bind("dragenter dragover",N).bind("drop",function(a){var a=a.originalEvent.dataTransfer,d;j&&a&&(d=a.files)&&0<d.length&&c.startUpload(d,b,e,f);return!1})},10)}};this.startUpload=function(a,b,e,f){function h(a,e){var d=Object,g=!1;try{d=eval("("+a+")")}catch(h){}d.err===$||d.msg===$?alert(b+" \u4e0a\u4f20\u63a5\u53e3\u53d1\u751f\u9519\u8bef\uff01\r\n\r\n\u8fd4\u56de\u7684\u9519\u8bef\u5185\u5bb9\u4e3a: \r\n\r\n"+
	a):d.err?alert(d.err):(n.push(d.msg),g=!0);(!g||e)&&c.removeModal();e&&g&&f(n);return g}var n=[],j=g.html5Upload,l=j?g.upMultiple:1,i,r=d('<div style="padding:22px 0;text-align:center;line-height:30px;">\u6587\u4ef6\u4e0a\u4f20\u4e2d\uff0c\u8bf7\u7a0d\u5019\u2026\u2026<br /></div>'),s='<img src="'+ua+'img/loading.gif">';if(Ca||!j||a.nodeType&&(!(i=a.files)||!i[0].name)){if(!Wa(a.value,e))return;r.append(s);e=new c.html4Upload(a,b,h)}else{i||(i=a);a=i.length;if(a>l){alert("\u8bf7\u4e0d\u8981\u4e00\u6b21\u4e0a\u4f20\u8d85\u8fc7"+
	l+"\u4e2a\u6587\u4ef6");return}for(l=0;l<a;l++)if(!Wa(i[l].name,e))return;var k=d('<div class="xheProgress"><div><span>0%</span></div></div>');r.append(k);e=new c.html5Upload("filedata",i,b,h,function(a){if(0<=a.loaded){var b=Math.round(100*a.loaded/a.total)+"%";d("div",k).css("width",b);d("span",k).text(b+" ( "+Xa(a.loaded)+" / "+Xa(a.total)+" )")}else k.replaceWith(s)})}c.showModal("\u6587\u4ef6\u4e0a\u4f20\u4e2d(Esc\u53d6\u6d88\u4e0a\u4f20)",r,320,150);e.start()};this.html4Upload=function(a,b,
	c){var f="jUploadFrame"+(new Date).getTime(),g=this,i=d('<iframe name="'+f+'" class="xheHideArea" />').appendTo("body"),j=d('<form action="'+b+'" target="'+f+'" method="post" enctype="multipart/form-data" class="xheHideArea"></form>').appendTo("body"),l=d(a),k=l.clone().attr("disabled","true");l.before(k).appendTo(j);this.remove=function(){null!==g&&(k.before(l).remove(),i.remove(),j.remove(),g=null)};this.onLoad=function(){var a=i[0].contentWindow.document,b=d(a.body).text();a.write("");g.remove();
	c(b,!0)};this.start=function(){j.submit();i.load(g.onLoad)};return this};this.html5Upload=function(a,b,c,d,g){function i(b,c,e,d){l=new XMLHttpRequest;upload=l.upload;l.onreadystatechange=function(){4===l.readyState&&e(l.responseText)};upload?upload.onprogress=function(a){d(a.loaded)}:d(-1);l.open("POST",c);l.setRequestHeader("Content-Type","application/octet-stream");l.setRequestHeader("Content-Disposition",'attachment; name="'+encodeURIComponent(a)+'"; filename="'+encodeURIComponent(b.name)+'"');
	l.sendAsBinary&&b.getAsBinary?l.sendAsBinary(b.getAsBinary()):l.send(b)}function j(a){g&&g({loaded:s+a,total:o})}for(var l,k=0,r=b.length,s=0,o=0,m=this,p=0;p<r;p++)o+=b[p].size;this.remove=function(){l&&(l.abort(),l=null)};this.uploadNext=function(a){a&&(s+=b[k-1].size,j(0));(!a||a&&!0===d(a,k===r))&&k<r&&i(b[k++],c,m.uploadNext,function(a){j(a)})};this.start=function(){m.uploadNext()}};this.showIframeModal=function(a,b,e,f,g,i){function j(){try{s.callback=l,s.unloadme=c.removeModal,d(s.document).keydown(H),
	o=s.name}catch(a){}}function l(a){s.document.write("");c.removeModal();null!=a&&e(a)}var b=d('<iframe frameborder="0" src="'+b.replace(/{editorRoot}/ig,K)+(/\?/.test(b)?"&":"?")+"parenthost="+location.host+'" style="width:100%;height:100%;display:none;" /><div class="xheModalIfmWait"></div>'),k=b.eq(0),r=b.eq(1);c.showModal(a,b,f,g,i);var s=k[0].contentWindow,o;j();k.load(function(){j();if(o){var a=!0;try{o=eval("("+unescape(o)+")")}catch(b){a=!1}if(a)return l(o)}r.is(":visible")&&(k.show().focus(),
	r.remove())})};this.showModal=function(a,b,e,f,h){if(ta)return!1;c.panelState=S;S=!1;ea=g.layerShadow;e=e?e:g.modalWidth;f=f?f:g.modalHeight;J=d('<div class="xheModal" style="width:'+(e-1)+"px;height:"+f+"px;margin-left:-"+Math.ceil(e/2)+"px;"+(i&&7>pa?"":"margin-top:-"+Math.ceil(f/2)+"px")+'">'+(g.modalTitle?'<div class="xheModalTitle"><span class="xheModalClose" title="\u5173\u95ed (Esc)" tabindex="0" role="button"></span>'+a+"</div>":"")+'<div class="xheModalContent"></div></div>').appendTo("body");
	Fa=d('<div class="xheModalOverlay"></div>').appendTo("body");0<ea&&(Ea=d('<div class="xheModalShadow" style="width:'+J.outerWidth()+"px;height:"+J.outerHeight()+"px;margin-left:-"+(Math.ceil(e/2)-ea-2)+"px;"+(i&&7>pa?"":"margin-top:-"+(Math.ceil(f/2)-ea-2)+"px")+'"></div>').appendTo("body"));d(".xheModalContent",J).css("height",f-(g.modalTitle?d(".xheModalTitle").outerHeight():0)).html(b);i&&6===pa&&(Ga=d("select:visible").css("visibility","hidden"));d(".xheModalClose",J).click(c.removeModal);Fa.show();
	0<ea&&Ea.show();J.show();setTimeout(function(){J.find("a,input[type=text],textarea").filter(":visible").filter(function(){return"hidden"!==d(this).css("visibility")}).eq(0).focus()},10);ta=!0;Ha=h};this.removeModal=function(){Ga&&Ga.css("visibility","visible");J.html("").remove();0<ea&&Ea.remove();Fa.remove();Ha&&Ha();ta=!1;S=c.panelState};this.showDialog=function(a,b){var e=d('<div class="xheDialog"></div>'),f=d(a),h=d("#xheSave",f);if(1===h.length){f.find("input[type=text],select").keypress(function(a){if(13===
	a.which)return h.click(),!1});f.find("textarea").keydown(function(a){if(a.ctrlKey&&13===a.which)return h.click(),!1});h.after(' <input type="button" id="xheCancel" value="\u53d6\u6d88" />');d("#xheCancel",f).click(c.hidePanel);if(!g.clickCancelDialog){sa=!1;var i=d('<div class="xheFixCancel"></div>').appendTo("body").mousedown(N),j=A.offset();i.css({left:j.left,top:j.top,width:A.outerWidth(),height:A.outerHeight()})}e.mousedown(function(){oa=!0})}e.append(f);c.showPanel(e,b)};this.showPanel=function(a,
	b){if(!w.target)return!1;t.html("").append(a).css("left",-999).css("top",-999);da=d(w.target).closest("a").addClass("xheActive");var c=da.offset(),f=c.left,c=c.top,c=c+(da.outerHeight()-1);ca.css({left:f+1,top:c,width:da.width()}).show();var h=document.documentElement,i=document.body;if(f+t.outerWidth()>(window.pageXOffset||h.scrollLeft||i.scrollLeft)+(h.clientWidth||i.clientWidth))f-=t.outerWidth()-da.outerWidth();h=g.layerShadow;0<h&&ba.css({left:f+h,top:c+h,width:t.outerWidth(),height:t.outerHeight()}).show();
	if((h=d("#"+ja).offsetParent().css("zIndex"))&&!isNaN(h))ba.css("zIndex",parseInt(h,10)+1),t.css("zIndex",parseInt(h,10)+2),ca.css("zIndex",parseInt(h,10)+3);t.css({left:f,top:c}).show();b||setTimeout(function(){t.find("a,input[type=text],textarea").filter(":visible").filter(function(){return"hidden"!==d(this).css("visibility")}).eq(0).focus()},10);Qa=S=!0};this.hidePanel=function(){S&&(da.removeClass("xheActive"),ba.hide(),ca.hide(),t.hide(),S=!1,sa||(d(".xheFixCancel").remove(),sa=!0),Qa=oa=!1,
	X=null,c.focus(),c.loadBookmark())};this.exec=function(a){c.hidePanel();var b=ka[a];if(!b)return!1;if(null===w){w={};var e=q.find(".xheButton[cmd="+a+"]");if(1===e.length)w.target=e}if(b.e)b.e.call(c);else switch(a=a.toLowerCase(),a){case "cut":try{if(k.execCommand(a),!k.queryCommandSupported(a))throw"Error";}catch(f){alert("\u60a8\u7684\u6d4f\u89c8\u5668\u5b89\u5168\u8bbe\u7f6e\u4e0d\u5141\u8bb8\u4f7f\u7528\u526a\u5207\u64cd\u4f5c\uff0c\u8bf7\u4f7f\u7528\u952e\u76d8\u5feb\u6377\u952e(Ctrl + X)\u6765\u5b8c\u6210")}break;
	case "copy":try{if(k.execCommand(a),!k.queryCommandSupported(a))throw"Error";}catch(h){alert("\u60a8\u7684\u6d4f\u89c8\u5668\u5b89\u5168\u8bbe\u7f6e\u4e0d\u5141\u8bb8\u4f7f\u7528\u590d\u5236\u64cd\u4f5c\uff0c\u8bf7\u4f7f\u7528\u952e\u76d8\u5feb\u6377\u952e(Ctrl + C)\u6765\u5b8c\u6210")}break;case "paste":try{if(k.execCommand(a),!k.queryCommandSupported(a))throw"Error";}catch(o){alert("\u60a8\u7684\u6d4f\u89c8\u5668\u5b89\u5168\u8bbe\u7f6e\u4e0d\u5141\u8bb8\u4f7f\u7528\u7c98\u8d34\u64cd\u4f5c\uff0c\u8bf7\u4f7f\u7528\u952e\u76d8\u5feb\u6377\u952e(Ctrl + V)\u6765\u5b8c\u6210")}break;
	case "pastetext":window.clipboardData?c.pasteText(window.clipboardData.getData("Text",!0)):c.showPastetext();break;case "blocktag":var j=[];d.each(gb,function(a,b){j.push({s:"<"+b.n+">"+b.t+"</"+b.n+">",v:"<"+b.n+">",t:b.t})});c.showMenu(j,function(a){c._exec("formatblock",a)});break;case "fontface":var l=[];d.each(hb,function(a,b){b.c=b.c?b.c:b.n;l.push({s:'<span style="font-family:'+b.c+'">'+b.n+"</span>",v:b.c,t:b.n})});c.showMenu(l,function(a){c._exec("fontname",a)});break;case "fontsize":var p=
	[];d.each(T,function(a,b){p.push({s:'<span style="font-size:'+b.s+';">'+b.t+"("+b.s+")</span>",v:a+1,t:b.t})});c.showMenu(p,function(a){c._exec("fontsize",a)});break;case "fontcolor":c.showColor(function(a){c._exec("forecolor",a)});break;case "backcolor":c.showColor(function(a){i?c._exec("backcolor",a):(Ka(!0),c._exec("hilitecolor",a),Ka(!1))});break;case "align":c.showMenu(ib,function(a){c._exec(a)});break;case "list":c.showMenu(jb,function(a){c._exec(a)});break;case "link":c.showLink();break;case "anchor":c.showAnchor();
	break;case "img":c.showImg();break;case "flash":c.showEmbed("Flash",'<div><label for="xheFlashUrl">\u52a8\u753b\u6587\u4ef6: </label><input type="text" id="xheFlashUrl" value="http://" class="xheText" /></div><div><label for="xheFlashWidth">\u5bbd\u3000\u3000\u5ea6: </label><input type="text" id="xheFlashWidth" style="width:40px;" value="480" /> <label for="xheFlashHeight">\u9ad8\u3000\u3000\u5ea6: </label><input type="text" id="xheFlashHeight" style="width:40px;" value="400" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>',
	"application/x-shockwave-flash","clsid:d27cdb6e-ae6d-11cf-96b8-4445535400000",' wmode="opaque" quality="high" menu="false" play="true" loop="true" allowfullscreen="true"',g.upFlashUrl,g.upFlashExt);break;case "media":c.showEmbed("Media",'<div><label for="xheMediaUrl">\u5a92\u4f53\u6587\u4ef6: </label><input type="text" id="xheMediaUrl" value="http://" class="xheText" /></div><div><label for="xheMediaWidth">\u5bbd\u3000\u3000\u5ea6: </label><input type="text" id="xheMediaWidth" style="width:40px;" value="480" /> <label for="xheMediaHeight">\u9ad8\u3000\u3000\u5ea6: </label><input type="text" id="xheMediaHeight" style="width:40px;" value="400" /></div><div style="text-align:right;"><input type="button" id="xheSave" value="\u786e\u5b9a" /></div>',
	"application/x-mplayer2","clsid:6bf52a52-394a-11d3-b153-00c04f79faa6",' enablecontextmenu="false" autostart="false"',g.upMediaUrl,g.upMediaExt);break;case "hr":c.pasteHTML("<hr />");break;case "emot":c.showEmot();break;case "table":c.showTable();break;case "source":c.toggleSource();break;case "preview":c.showPreview();break;case "print":W.print();break;case "fullscreen":c.toggleFullscreen();break;case "about":c.showAbout();break;default:c._exec(a)}w=null};this._exec=function(a,b,e){e||c.focus();return b!==
	$?k.execCommand(a,!1,b):k.execCommand(a,!1,null)}};ra.settings={skin:"default",tools:"full",clickCancelDialog:!0,linkTag:!1,internalScript:!1,inlineScript:!1,internalStyle:!0,inlineStyle:!0,showBlocktag:!1,forcePtag:!0,upLinkExt:"zip,rar,txt",upImgExt:"jpg,jpeg,gif,png",upFlashExt:"swf",upMediaExt:"wmv,avi,wma,mp3,mid",modalWidth:350,modalHeight:220,modalTitle:!0,defLinkText:"\u70b9\u51fb\u6253\u5f00\u94fe\u63a5",layerShadow:3,emotMark:!1,upBtnText:"\u4e0a\u4f20",cleanPaste:1,hoverExecDelay:100,html5Upload:!0,
	upMultiple:99};window.xheditor=ra;d(function(){d.fn.oldVal=d.fn.val;d.fn.val=function(d){var i=this,p;return d===$?i[0]&&(p=i[0].xheditor)?p.getSource():i.oldVal():i.each(function(){(p=this.xheditor)?p.setSource(d):i.oldVal(d)})};d("textarea").each(function(){var i=d(this),o=i.attr("class");if(o&&(o=o.match(/(?:^|\s)xheditor(?:\-(m?full|simple|mini))?(?:\s|$)/i)))i.xheditor(o[1]?{tools:o[1]}:null)})})})(jQuery);

document.writeln("<script type='text/javascript' src='../../scripts/jquery/datepicker/WdatePicker.js'></script>");
document.writeln("<link href='../../themes/default/style.css' type='text/css' rel='stylesheet' />");
