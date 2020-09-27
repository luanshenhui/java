
/* JavaScript autocomplete widget, version 1.5.4. For details, see http://createwebapp.com  */
(function () {

	var ua = navigator.userAgent.toLowerCase();
	var webkit = /webkit/.test(ua), webkit4 = /webkit\/4/.test(ua), gecko = !webkit && /gecko/.test(ua), ff2 = !webkit && /firefox\/2/.test(ua), msie = /msie/.test(ua), msie6 = /msie 6/.test(ua), msie7 = /msie 7/.test(ua), loaded = 0, sw = 0, sn, g_busy = "autocomplete_busy", g_close = "autocomplete_close", PX = "px", ON = "on", OFF = "off", Event = new Object(), g_bw = 1;
	var emptyFunction = function () {
	}, getStyle = function (e) {
		if (!webkit && document.defaultView && document.defaultView.getComputedStyle) {
			return document.defaultView.getComputedStyle(e, null);
		} else {
			return e.currentStyle || e.style;
		}
	};
	if (!Element) {
		var Element = {};
	}
	Estyle = function (e, s) {
		e = $(e);
		var v = e.style[s];
		if (!v) {
			if (document.defaultView) {
				var css = document.defaultView.getComputedStyle(e, null);
			}
			v = css ? css[s] : null;
		}
		return v == "auto" ? null : v;
	};
	var $ = function (e) {
		if (typeof e == "string") {
			e = document.getElementById(e);
		}
		return e;
	}, $A = function (iterable) {
		if (!iterable) {
			return [];
		}
		var rs = [];
		for (var i = 0, length = iterable.length; i < length; i++) {
			rs.push(iterable[i]);
		}
		return rs;
	}, toInt = function (s) {
		return isNaN(parseInt(s)) ? 0 : parseInt(s);
	}, hasClass = function (e, n) {
		return new RegExp("(^|\\s)" + n + "(\\s|$)").test(e.className);
	}, removeClass = function (e, n) {
		if (!e) {
			return;
		}
		e.className = e.className.replace(new RegExp(n, "g"), "");
	}, cumulativeOffset = function (e) {
		var T = 0, L = 0;
		do {
			T += e.offsetTop || 0;
			L += e.offsetLeft || 0;
			e = e.offsetParent;
		} while (e);
		return [L, T];
	}, page = function (t) {
		var T = 0, L = 0, e = t;
		do {
			T += e.offsetTop || 0;
			L += e.offsetLeft || 0;
		} while (e = e.offsetParent);
		e = t;
		do {
			if (!window.opera || e.tagName == "BODY") {
				T -= e.scrollTop || 0;
				L -= e.scrollLeft || 0;
			}
		} while (e = e.parentNode);
		return [L, T];
	};
	Object.extend = function (d, s) {
		for (var p in s) {
			d[p] = s[p];
		}
		return d;
	};
	var Class = {create:function () {
		var parent = null, ps = $A(arguments);
		function klass() {
			this.initialize.apply(this, arguments);
		}
		Object.extend(klass, Class.Methods);
		klass.superclass = parent;
		klass.subclasses = [];
		for (var i = 0; i < ps.length; i++) {
			klass.addMethods(ps[i]);
		}
		if (!klass.prototype.initialize) {
			klass.prototype.initialize = function () {
			};
		}
		klass.prototype.constructor = klass;
		return klass;
	}};
	Class.Methods = {addMethods:function (s) {
		var ps = Object.keys(s);
		if (!Object.keys({toString:true}).length) {
			ps.push("toString", "valueOf");
		}
		for (var i = 0, length = ps.length; i < length; i++) {
			var property = ps[i], value = s[property];
			this.prototype[property] = value;
		}
		return this;
	}};
	Object.extend(Object, {keys:function (o) {
		var keys = [];
		for (var p in o) {
			keys.push(p);
		}
		return keys;
	}, clone:function (o) {
		return Object.extend({}, o);
	}, isUndefined:function (o) {
		return typeof o == "undefined";
	}});
	var interpret = function (v) {
		return v == null ? "" : String(v);
	};
	Object.extend(Function.prototype, {bind:function () {
		if (arguments.length < 2 && Object.isUndefined(arguments[0])) {
			return this;
		}
		var __method = this, args = $A(arguments), object = args.shift();
		return function () {
			return __method.apply(object, args.concat($A(arguments)));
		};
	}, bindAsEventListener:function () {
		var __method = this, args = $A(arguments), object = args.shift();
		return function (event) {
			return __method.apply(object, [event || window.event].concat(args));
		};
	}, curry:function () {
		if (!arguments.length) {
			return this;
		}
		var __method = this, args = $A(arguments);
		return function () {
			return __method.apply(this, args.concat($A(arguments)));
		};
	}, delay:function () {
	
		var __method = this, args = $A(arguments), timeout = args.shift() * 1000;
		return window.setTimeout(function () {
			return __method.apply(__method, args);
		}, timeout);
	}});
	Function.prototype.defer = Function.prototype.delay.curry(0.01);
	Object.extend(Event, {element:function (e) {
		return $(e.target || e.srcElement);
	}, stop:function (e) {
		if (e.preventDefault) {
			e.preventDefault();
			e.stopPropagation();
		} else {
			e.returnValue = false;
			e.cancelBubble = true;
		}
	}, observers:false, _observeAndCache:function (e, n, observer, useCapture) {
		if (!this.observers) {
			this.observers = [];
		}
		if (e.addEventListener) {
			this.observers.push([e, n, observer, useCapture]);
			e.addEventListener(n, observer, useCapture);
		} else {
			if (e.attachEvent) {
				this.observers.push([e, n, observer, useCapture]);
				e.attachEvent("on" + n, observer);
			}
		}
	}, unloadCache:function () {
		if (!Event.observers) {
			return;
		}
		for (var i = 0, length = Event.observers.length; i < length; i++) {
			Event.stopObserving.apply(this, Event.observers[i]);
			Event.observers[i][0] = null;
		}
		Event.observers = false;
	}, observe:function (e, n, observer, useCapture) {
		e = $(e);
		useCapture = useCapture || false;
		if (n == "keypress" && (webkit || e.attachEvent)) {
			n = "keydown";
		}
		Event._observeAndCache(e, n, observer, useCapture);
	}, stopObserving:function (e, n, observer, useCapture) {
		e = $(e);
		useCapture = useCapture || false;
		if (n == "keypress" && (webkit || e.attachEvent)) {
			n = "keydown";
		}
		if (e.removeEventListener) {
			e.removeEventListener(n, observer, useCapture);
		} else {
			if (e.detachEvent) {
				try {
					e.detachEvent("on" + n, observer);
				}
				catch (ex) {
				}
			}
		}
	}});
	if (msie) {
		Event.observe(window, "unload", Event.unloadCache, false);
	}
	var Try = {these:function () {
		var returnValue;
		for (var i = 0, length = arguments.length; i < length; i++) {
			var lambda = arguments[i];
			try {
				returnValue = lambda();
				break;
			}
			catch (e) {
			}
		}
		return returnValue;
	}};
	var Ajax = {getTransport:function () {
		return Try.these(function () {
			return new XMLHttpRequest();
		}, function () {
			return new ActiveXObject("Msxml2.XMLHTTP");
		}, function () {
			return new ActiveXObject("Microsoft.XMLHTTP");
		}) || false;
	}};
	Ajax.Updater = Class.create({_complete:false, initialize:function (url, options) {
	
		this.options = {method:"post", asynchronous:true, contentType:"application/x-www-form-urlencoded", encoding:"UTF-8", parameters:"", evalJS:true};
		Object.extend(this.options, options || {});
		this.transport = Ajax.getTransport();
		this.request(url);
	}, request:function (url) {
		this.url = url;
		this.method = this.options.method;
		var params = Object.clone(this.options.parameters);
		this.parameters = params;
		try {
			var response = new Ajax.Response(this);
			if (this.options.onfreate) {
				this.options.onCreate(response);
			}
			this.transport.open(this.method.toUpperCase(), this.url, this.options.asynchronous);
			if (this.options.asynchronous) {
				this.respondToReadyState.bind(this).defer(1);
			}
			this.transport.onreadystatechange = this.onStateChange.bind(this);
			this.setRequestHeaders();
			this.body = this.method == "post" ? (this.options.postBody || params) : null;
			this.transport.send(this.body);
			if (!this.options.asynchronous && this.transport.overrideMimeType) {
				this.onStateChange();
			}
		}
		catch (e) {
			this.dispatchException(e);
		}
	}, onStateChange:function () {
		var readyState = this.transport.readyState;
		if (readyState > 1 && !((readyState == 4) && this._complete)) {
			this.respondToReadyState(this.transport.readyState);
		}
	}, setRequestHeaders:function () {
		var headers = {"X-Requested-With":"XMLHttpRequest", Accept:"text/javascript, text/html, application/xml, text/xml, */*"};
		if (this.method == "post") {
			headers["Content-type"] = this.options.contentType + (this.options.encoding ? "; charset=" + this.options.encoding : "");
			if (this.transport.overrideMimeType && (navigator.userAgent.match(/Gecko\/(\d{4})/) || [0, 2005])[1] < 2005) {
				headers.Connection = "close";
			}
		}
		for (var n in headers) {
			this.transport.setRequestHeader(n, headers[n]);
		}
	}, success:function () {
		var status = this.getStatus();
		return !status || (status >= 200 && status < 300);
	}, getStatus:function () {
		try {
			return this.transport.status || 0;
		}
		catch (e) {
			return 0;
		}
	}, respondToReadyState:function (readyState) {
		var state = Ajax.Updater.Events[readyState], response = new Ajax.Response(this);
		if (state == "Complete") {
			try {
				this._complete = true;
				(this.options["on" + response.status] || this.options["on" + (this.success() ? "Success" : "Failure")] || emptyFunction)(response);
			}
			catch (e) {
				this.dispatchException(e);
			}
		}
		try {
			(this.options["on" + state] || emptyFunction)(response);
		}
		catch (e) {
			this.dispatchException(e);
		}
		if (state == "Complete") {
			this.transport.onreadystatechange = emptyFunction;
		}
	}, dispatchException:function (ex) {
	}});
	Ajax.Updater.Events = ["Uninitialized", "Loading", "Loaded", "Interactive", "Complete"];
	Ajax.Response = Class.create({initialize:function (request) {
		this.request = request;
		var transport = this.transport = request.transport, readyState = this.readyState = transport.readyState;
		if ((readyState > 2 && !msie) || readyState == 4) {
			this.status = this.getStatus();
			this.responseText = interpret(transport.responseText);
		}
	}, status:0, getStatus:Ajax.Updater.prototype.getStatus});
	var cwa = {h:function (o) {
		var s = 0;
		for (i = 0; i < o.length; i++) {
			s += o.charCodeAt(i);
		}
		var base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		var h = base.substr(s & 63, 1);
		while (s > 63) {
			s >>= 6;
			h = base.substr(s & 63, 1) + h;
		}
		return h;
	}, y:function (o) {
		return o.owner && o.key && !o.key.indexOf(cwa.h(o.owner));
	}, b:function (t) {
		return t.substring(t.indexOf("{") + 1, t.lastIndexOf("}"));
	}, focus:function (t) {
		t.focus();
		var l = t.value.length;
		if (msie) {
			var r = t.createTextRange();
			r.moveStart("character", l);
			r.moveEnd("character", l);
			r.select();
		} else {
			t.setSelectionRange(l, l);
		}
	}};
	var ac = function () {
		this.initialize.apply(this, arguments);
	};
	(function () {
		var t;
		function _domloaded() {
			if (loaded) {
				return;
			}
			if (t) {
				window.clearInterval(t);
			}
			loaded = 1;
		}
		if (document.addEventListener) {
			if (webkit) {
				t = window.setInterval(function () {
					if (/loaded|complete/.test(document.readyState)) {
						_domloaded();
					}
				}, 0);
				Event.observe(window, "load", _domloaded);
			} else {
				document.addEventListener("DOMContentLoaded", _domloaded, false);
			}
		} else {
			document.write("<script id=_onDOMContentLoaded defer src=//:></script>");
			$("_onDOMContentLoaded").onreadystatechange = function () {
				if (this.readyState == "complete") {
					this.onreadystatechange = null;
					_domloaded();
				}
			};
		}
	})();
	Object.extend = function (d, s) {
		for (var p in s) {
			d[p] = s[p];
		}
		return d;
	};
	Function.prototype.bind = function () {
		var __method = this, args = $A(arguments), object = args.shift();
		return function () {
			return __method.apply(object, args.concat($A(arguments)));
		};
	};
	Function.prototype.bindAsEventListener = function (object) {
		var __method = this, args = $A(arguments), object = args.shift();
		return function (event) {
			return __method.apply(object, [event || window.event].concat(args));
		};
	};
	Object.extend(ac, {u:function (e) {
		while (e = e.parentNode) {
			if (e.style) {
				if (e.style.overflow == "hidden") {
					e.style.overflow = "visible";
				}
				if (e.style.tableLayout == "fixed") {
					e.style.tableLayout = "auto";
				}
			}
		}
	}, removeWatermark:function (n, k) {
		ac.owner = n + " Autocomplete";
		ac.key = k;
	}, findPopup:function (v) {
		var e = Event.element(v);
		e = e ? e : v;
		while (e && e.parentNode && !hasClass(e, "autocomplete_list")) {
			e = e.parentNode;
		}
		if (e == null) {
			return null;
		}
		return e.parentNode && e.id ? e : null;
	}, I:function (e) {
		var v;
		if (e.nodeType == 1) {
			v = e.getAttribute("onselect");
		}
		return (v != null) && (v != undefined);
	}, F:function (v, p) {
		var e = Event.element(v);
		while (e.parentNode && (e != p) && (!ac.I(e))) {
			e = e.parentNode;
		}
		return (e.parentNode && (e != p)) ? e : null;
	}, C:function (v) {
		var e = Event.element(v);
		for (var i = 0; i < ac.inst.length; i++) {
			var a = ac.inst[i];
			if (a.text != e && a.L.L2 != e) {
				setTimeout(a.hide.bind(a), 0);
			}
		}
	}, L:function () {
		if (msie) {
			sn = self.name;
		}
		var x = "autocomplete_x1";
		if (loaded) {
			var e = document.createElement("div");
			e.id = x;
			alert(x);
			document.body.appendChild(e);
		} else {
			document.write("<div id='" + x + "'></div>");
		}
		var e = $(x);
		var es = e.style;
		es.position = "fixed";
		es.left = es.top = "-800px";
		es.overflow = "scroll";
		es.width = "40px";
		e.className = g_busy;
		e.innerHTML = "<div style='width:80px' class='" + g_close + "'></div>";
		sw = e.offsetWidth - e.clientWidth;
		for (var i = 0; i < ac.inst.length; i++) {
			var o = ac.inst[i];
			o.pi.bind(o);
		}
	}, inst:new Array(), name:"", key:""});
	ac.prototype = {$c:0, init:0, T:0, i:-1, d:1, last_value:"", custom_uri:"", initialize:function (t, f, options) {
		this.text = $(t) ? $(t) : document.getElementsByName(t)[0];
		if ((this.text == null) || (f == null) || (typeof f != "function")) {
			return;
		}
		this.text.setAttribute("autocomplete", OFF);
		this.setOptions(options);
		this.f = f;
		this.makeURI = function () {
			if (this.bR()) {
				return this.f();
			}
		}.bind(this);
		var x = this.text.getAttribute("autocomplete_id");
		if (x != null) {
			return;
		}
		var sid = "no_" + ac.inst.length;
		this.text.setAttribute("autocomplete_id", sid);
		this.onchange = this.text.onchange;
		this.text.onchange = function () {
		};
		var ml = function (n) {
			var x = "autocomplete_list";
			if (loaded) {
				var e = document.createElement("ol");
				e.id = n + "_" + x;
				var es = e.style;
				es.position = "fixed";
				es.left = es.top = "-9999px";
				e.className = x;
				document.body.appendChild(e);
			} else {
				document.write("<ol id='" + n + "_" + x + "' style='position:fixed;left:-9999;top:-9999px' class='" + x + "'></ol>");
			}
			var e = $(n + "_" + x);
			return e;
		};
		this.L = ml(sid + "a");
		this.L2 = ml(sid + "b");
		if (msie6) {
			if (loaded) {
				var e = document.createElement("iframe");
				e.id = sid + "_iframe";
				var es = e.style;
				es.position = "fixed";
				es.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity = 0)";
				e.src = "javascript:false;";
				document.body.appendChild(e);
			} else {
				document.write("<iframe id='" + sid + "_iframe' style='position:fixed;filter:progid:DXImageTransform.Microsoft.Alpha(opacity = 0)' src='javascript:false;'></iframe>");
			}
			this.F = $(sid + "_iframe");
			this.F.style.display = "none";
		}
		ac.inst.push(this);
		if (ac.L) {
			ac.L();
			ac.L = null;
		}
		var id = "autocomplete_" + new Date().getTime();
		document.write("<div id='" + id + "' class='autocomplete_icon' style='position:fixed;width:11px;height:11px;left:-99px;top:-99px" + top + "'></div>");
		var icon = $(id);
		icon.onclick = function () {
			if (this.icon.className == g_close) {
			//alert("11111111");
				//this.text.value = "";
				//this.notBusy();
			//	this.makeURI();
			}
			//this.text.focus();
		}.bind(this);
		this.icon = icon;
		this.fpi();
		Event.observe(window, "resize", this.pi.bind(this));
		this.r();
	}, fpi:function () {
		for (var i = 1; i <= 4 * 20; i++) {
			setTimeout(this.pi.bind(this), i * 50);
		}
	}, pi:function () {
		var p = page(this.text);
		this.icon.style.left = (p[0] + this.text.offsetWidth - 18) + "px";
		this.icon.style.top = (p[1] + (this.text.offsetHeight - 11) / 2 - (msie6 ? 2 : 0) + (msie7 ? 1 : 0)) + "px";
	}, V:function () {
		var s = this.L.style;
		return (s.display != "none") && (toInt(s.left) >= 0) && (toInt(s.top) >= 0);
	}, setOptions:function (options) {
		this.options = {width:"auto", delay:0.4, minChars:1, delimChars:",", size:10, select_first:1, align:"auto"};
		Object.extend(this.options, options || {});
	}, r:function () {
		this._k = this.k.bindAsEventListener(this);
		this.$r = this.request.bind(this);
		var t = this.text;
		t.className += " autocomplete_text";
		if (/mac/.test(ua)) {
			t._ac = this;
			t.onkeypress = function (e) {
				return !this._ac.$s;
			};
		}
		var O = Event.observe;
		if (msie) {
			O(t, "keydown", this._k);
		} else {
			O(t, "keypress", this._k);
		}
		O(t, "keyup", function () {
			clearTimeout(this.$u);
		}.bind(this));
		O(t, "blur", this.blur.bind(this));
		if (ac.inst.length == 1) {
			O(document, "click", ac.C);
		}
		var e = t;
		while (e = e.parentNode) {
			if (e.style && (e.style.overflow == "scroll" || e.style.overflow == "auto")) {
				this.scrollable = this.scrollable ? this.scrollable : e;
				O(e, "scroll", this.onScroll.bind(this));
			}
		}
	}, onScroll:function () {
		var s = this.scrollable;
		if (s) {
			var p = this.t();
			var o = cumulativeOffset(s);
			if (p[1] >= o[1] && p[1] < o[1] + s.offsetHeight && p[0] >= o[0] && p[0] < o[0] + s.offsetWidth && this.V()) {
				this.s();
			} else {
				this.hide();
			}
		}
	}, t:function () {
		var p = page(this.text);
		return [p[0] + (msie ? this.text.scrollLeft : 0) + (document.documentElement.scrollLeft || document.body.scrollLeft), p[1] + (document.documentElement.scrollTop || document.body.scrollTop)];
	}, iolv:function () {
		var d = this.options.delimChars, v = encodeURIComponent(this.text.value), i, j, k = 0;
		for (i = v.length - 1; i >= 0; i--) {
			for (j = 0; j < d.length; j++) {
				if (v.charAt(i) == d.charAt(j)) {
					k = i + 1;
					break;
				}
			}
			if (k) {
				break;
			}
		}
		return k;
	}, page:function (n) {
		var s = this.options.size, i = this.i, l = this.items.length;
		if (n == "page_up") {
			if (i >= s) {
				this.focus(i - s);
			} else {
				this.focus(0);
			}
		}
		if (n == "page_down") {
			if (i + s < l) {
				this.focus(i + s);
			} else {
				this.focus(l - 1);
			}
		}
	}, blur:function () {
		if (!this.V() && this.icon.className != g_busy) {
			this.status = OFF;
			setTimeout(function () {
				if (this.status == OFF) {
					this.stop();
				}
			}.bind(this), 4);
		}
	}, stop:function () {
	
		this.c();
		this.notBusy();
		this.hide();
	}, c:function () {
		if ((this.latest) && (this.latest.transport.readyState != 4)) {
			this.latest.transport.abort();
		}
	}, k:function (e) {
		this.status = ON;
		this.$s = false;
		var c = e.keyCode;
		var delay = this.options.delay;
		this.isModified = true;
		if (c == 13 || c == 9) {
			if (c == 13) {
				Event.stop(e);
			}
			if (this.V() || c == 9) {
				if ((this.$c) && (this.i > -1)) {
					this.$s = true;
				}
				this.z();
				return;
			}
			delay = 0.05;
			this.isModified = false;
		}
		if (c == 38 || c == 40 || c == 63232 || c == 63233) {
			if (this.$c) {
				(c == 38) || (c == 63232) ? this.U() : this.D();
				Event.stop(e);
			}
		}
		if (c == 33 || c == 34 || c == 63276 || c == 63277) {
			if (this.$c) {
				(c == 33) || (c == 63276) ? this.page("page_up") : this.page("page_down");
			}
		}
		if (c == 27) {
			this.stop();
			if (webkit) {
				this.text.blur();
				this.text.focus();
			}
		}
		if (c == 38 || c == 40 || c == 33 || c == 34 || c == 27 || c == 63232 || c == 63233 || c == 63276 || c == 63277) {
			Event.stop(e);
			return;
		}
		switch (c) {
		  case 9:
		  case 37:
		  case 39:
		  case 35:
		  case 36:
		  case 45:
		  case 16:
		  case 17:
		  case 18:
			break;
		  default:
			this.custom_uri = "";
			clearTimeout(this.T);
			this.c();
			setTimeout(function () {
			
				this.T = setTimeout(this.$r, delay * 1000);
			}.bind(this, delay), 4);
		}
	}, z:function () {
		var m = this.G();
		this.stop();
		if ((m == undefined) || (m == null)) {
			return;
		}
		if (m) {
			try {
				eval(m.getAttribute("onselect").replace("this.request(", "this.request(1"));
			}
			catch (e) {
			}
			if (!cwa.y(ac)) {
				setTimeout(this.icon.onclick, 256 * 4);
			}
			cwa.focus(this.text);
			if (this.onchange) {
				setTimeout(function () {
					this.onchange.bind(this.text)();
				}.bind(this), 4);
			}
		}
	}, G:function () {
		return this.items ? this.items[this.i] : null;
	}, focus:function (i, pass) {
		if ((this.i == i) || (!this.$c)) {
			return;
		}
		this.L.style.display = "";
		removeClass(this.G(), "current_item");
		this.i = i;
		var m = this.G();
		if (!m) {
			return;
		}
		m.className += " current_item";
		if (i == 0) {
			m.className += " first_item_no_border";
		}
		var u = this.L, h = this.options.size * m.offsetHeight, mt = m.offsetTop;
		if (ff2) {
			mt += g_bw;
		}
		if (msie && (document.documentMode != 8)) {
			mt -= toInt(getStyle(m).paddingTop);
		}
		var moveUp = (mt < u.scrollTop) || (i == 0);
		var moveDown = mt + m.offsetHeight - u.scrollTop > h;
		if (moveUp || moveDown) {
			removeClass(this.first, "first_item");
			removeClass(this.first, "first_item_no_border");
		}
		if (moveUp) {
			u.scrollTop = mt;
			m.className += " first_item_no_border";
			this.first = m;
		}
		if (moveDown) {
			u.scrollTop = mt + m.offsetHeight - h;
			this.first = this.items[i + 1 - this.options.size];
			if (this.first) {
				this.first.className += " first_item";
			}
		}
		try {
			var z = m.getAttribute("onfocus");
			if (msie) {
				z = cwa.b(z.toString());
			}
			eval(z);
		}
		catch (e) {
		}
	}, U:function () {
		if (this.i > -1) {
			this.focus(this.i - 1);
		}
	}, D:function () {
		if (this.i < this.items.length - 1) {
			this.focus(this.i + 1);
		}
	}, bR:function () {
		if (!this.init) {
			this.init = true;
			this.L.onscroll = function () {
				cwa.focus(this.text);
			}.bind(this);
		}
		this.last_value = this.value.substr(this.iolv());
		var l = this.last_value ? this.last_value.length : this.text.value.length;
		return l >= this.options.minChars;
	}, request:function (u) {
		var z = typeof u != "string";
		this.value = encodeURIComponent(this.text.value);
		if (u == 1) {
			u = this.url;
			this.status = ON;
		} else {
			if (z) {
				u = this.makeURI();
			}
		}
		if (this.status == ON) {
			this.onLoad();
			this.url = u;
			if (u == undefined) {
				this.stop();
				return;
			}
			this.latest = new Ajax.Updater(u + this.custom_uri, {method:"get", onComplete:this.d.bind(this)});
		} else {
			this.stop();
		}
	}, onLoad:function () {
		this.$c = 0;
		this.i = -1;
		this.busy();
	}, d:function (response) {
		var l = this.latest;
		var tx = l.transport;
		if ((this.status == ON) && (tx == response.transport) && (this.latest.url == this.url + this.custom_uri)) {
			this.L2.innerHTML = response.responseText;
			this.$c = true;
			if (!l.success) {
				l.success = l.responseIsSuccess;
			}
			try {
				if ((typeof tx.status != "unknown") && l.success()) {
				} else {
				
					this.L2.innerHTML = "<li onselect=';'>Please try again.<br/>HTTP error code:" + tx.status + "</li>";
				}
				this.L2.style.width = this.L2.style.height = "auto";
				var ls = this.L2.childNodes;
				var i = 0;
				for (var j = 0; j < ls.length; j++) {
					var x = ls[j];
					if (ac.I(x)) {
						x.className = "item";
						if (msie && (++i <= this.options.size) && !x.getElementsByTagName("span").length) {
							x.innerHTML = "<span style='padding:0'></span>" + x.innerHTML;
						}
					}
				}
				this.$c = true;
				if (ls.length > 0) {
					this.s(this.options.select_first);
				} else {
					this.stop();
				}
			}
			catch (e) {
			}
		}
	}, offset:function (e) {
		var o = 0;
		if (gecko || webkit || (msie && (document.compatMode != "BackCompat"))) {
			var pl = "padding-left", pr = "padding-right";
			var f = function (e, p) {
				return toInt(Estyle(e, p));
			};
			o = g_bw * 2 + f(e, pl) + f(e, pr);
		}
		return o;
	}, H:function (L) {
		var s = this.options.size;
		var A = $A(L.getElementsByTagName("li"));
		var l = A.length;
		var m = A[(l > s ? s : l) - 1];
		var h = m.offsetTop + m.offsetHeight;
		if (msie) {
			if (document.compatMode == "BackCompat") {
				h += g_bw * 2;
			}
			h += g_bw;
			if (document.documentMode != 8) {
				h -= toInt(getStyle(m).paddingTop);
			}
			h -= g_bw * 2;
		}
		if (webkit4) {
			h -= g_bw;
		}
		return h - g_bw;
	}, s:function (ft) {
		this.status = ON;
		var p = this.t();
		var th = this.text.offsetHeight;
		if (this.status == ON) {
			var pt = p[1] + th;
			if (this.status != ON) {
				return;
			}
			var w = "auto";
			var i = 600;
			if (!!window.opera) {
				this.L2.style.width = i + PX;
			}
			var oh = this.L2.offsetHeight;
			if (webkit || gecko) {
				w = this.L2.offsetWidth;
			} else {
				var l = this.text.offsetWidth, h = i, ow;
				do {
					i = Math.ceil((l + h) / 2);
					this.L2.style.width = i + PX;
					ow = this.L2.offsetWidth;
					if ((gecko) || (document.compatMode == "CSS1Compat")) {
						ow -= g_bw * 2;
					}
					if ((this.L2.offsetHeight > oh) || (ow > i)) {
						l = i + 1;
					} else {
						h = i;
					}
				} while (h - l >= 20);
				w = h;
				this.L2.style.width = w + PX;
			}
			if (this.L2.offsetWidth < this.text.offsetWidth) {
				w = this.text.offsetWidth - this.offset(this.L2);
			}
			var h = "auto";
			this.items = new Array();
			if (this.L.innerHTML != this.L2.innerHTML) {
				this.L.innerHTML = this.L2.innerHTML;
				this.i = -1;
				var ls = this.L.childNodes;
				for (var j = 0; j < ls.length; j++) {
					var x = ls[j];
					if (x.className == "item") {
						var i = this.items.length;
						x.onmouseover = function (i) {
							this.focus(i);
						}.bind(this, i);
						x.onclick = function (i) {
							this.i = i;
							this.z();
						}.bind(this, i);
						this.items.push(x);
					}
				}
			}
			if (this.items.length > this.options.size) {
				this.L.style.overflow = "auto";
				w = parseInt(w) + sw;
				h = this.H(this.L2) + PX;
			}
			if (this.items.length) {
				var l = p[0], d = this.text.offsetWidth - w, a = this.options.align, ls = this.L.style;
				if ((a == "auto") && (document.body.offsetWidth - l - w > 14)) {
					d = 0;
				}
				if (a == "left") {
					d = 0;
				}
				if (a == "center") {
					d /= 2;
				}
				ls.top = pt + PX;
				ls.left = l + d + PX;
				ls.width = w + PX;
				ls.height = h;
				ls.display = "";
				if (ft) {
					setTimeout(this.D.bind(this), 0);
				}
				if (this.F) {
					self.name = sn;
					var es = this.F.style;
					es.top = pt + PX;
					es.left = p[0] + PX;
					es.width = w;
					es.height = this.L.clientHeight;
					es.display = "";
				}
			}
			this.notBusy();
			if (msie) {
				setTimeout(function () {
					for (var j = 0; j < this.items.length; j++) {
						var x = this.items[j];
						if (!x.getElementsByTagName("span").length) {
							x.innerHTML = "<span style='padding:0'></span>" + x.innerHTML;
						}
					}
				}.bind(this), 0);
			}
		}
	}, hide:function () {
		if (this.V()) {
			this.L.style.display = "none";
			if (this.F) {
				this.F.style.display = "none";
			}
		}
	}, busy:function () {
		this.icon.className = g_busy;
	}, notBusy:function () {
		this.icon.className = "autocomplete_" + (this.text.value.length == 0 ? "icon" : "close");
	}};
	window.AutoComplete = window.Autocomplete = ac;
	try {
	
		var a = "autocomplete.js", b = "", c = document.getElementsByTagName("script"), i;
		for (i = 0; i < c.length; i++) {
			if (c[i].src.indexOf(a) > -1) {
				document.write(unescape("%3Cscript src='" + c[i].src.replace(a, b) + "' type='text/javascript'%3E%3C/script%3E"));
			}
		}
	}
	catch (e) {
	}
})();

