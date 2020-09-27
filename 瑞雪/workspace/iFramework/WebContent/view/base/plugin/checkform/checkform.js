////////////////////////////////////////////////////////////////////////////////
/*
 *--------------- 客户端表单通用验证checkForm(oForm) -----------------
 *	1.对非ie的支持
 *	2.增加了内置表达式和内置提示
 *  3.增加了显示方式（弹出式和页面显示式）
 *	4.增加了显示一条和显示全部
 *	5.进行了封装（CLASS_CHECK）
 *	6.支持外接函数或表达式（应用在密码一致）
 *	7.简化了调用方式，所有操作只需要<script language='javascript' src='checkform.js'>,
	  然后在HTML里定义各标签验证格式
 *	8.对IE增加了对键盘输入的限制（如：定义usage='int'时，输入框只能输入数字（非IE无效）
 *	9.增加了对disabled的不验证
 * 10.自定义报警方式（重写showMessageEx方法）
 * 11.能对多FORM验证,还有针对普通按钮(非submit)下的验证

 *-----------------------------申明信息-----------------------------
	本程序只需要对需要验证的标签设置三个属性：usage,exp,tip

	usage	 :	内置格式或表达式或函数
	exp		 :	正则表达式（注意如果指定了usage则忽略exp)
	tip		 :	出错提示（如果是内置格式可以不要此属性，有缺省提示）
	mandatory:  必填项
	maxlen   :  最大长度
	xss      :  是否需要防跨站脚本编制，true为检测
	sqlinject:  是否需要防sql注入，true为检测

	调用时只需要引用<script language='javascript' src='checkform.js'>，然后为每个标记
	增加以上3个属性（不一定需要全部）
 *
 *--------------- 客户端表单通用验证checkForm(oForm) -----------------
 */
////////////////////////////////////////////////////////////////////////////////
//必填项
var V_MSG_MANDATORY = "必填项";
var V_MSG_VALUE_NOT_SAVE = "不安全的内容";

//检测必填项的正则
var V_EXP_MANDATORY = "^[^ ]+$";
//匹配汉字的正则表达式
var V_EXP_CHINESE = "[\u4e00-\u9fa5]";//"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$";
//最大长度
var V_EXP_MAXLEN = "^(.|\n){#1,#2}$";
//检测跨站脚本编制的正则表达式，匹配：< b>、<u>、</或<script>等类似
var V_EXP_XSS_1 = "^((\%3C)|<)((\%2F)|\/)*[a-z0-9\%]+((\%3E)|>)$";
//检测跨站脚本编制的正则表达式，匹配：<img 随后的字符 >
var V_EXP_XSS_2 = "^((\%3C)|<)((\%69)|i|(\%49))((\%6D)|m|(\%4D))((\%67)|g|(\%47))[^\n]+((\%3E)|>)$";
//检测sql注入的正则表达式，匹配：' or这样的串，以及相对应的urlencode编码
var V_EXP_SQL_INJECT_1 = "^\w*((\%27)|(\’))((\%6F)|o|(\%4F))((\%72)|r|(\%52))$";

function CLASS_CHECK(){
	this.pass		= true;		//是否通过验证
	this.showAll	= true;		//是否显示所有的验证错误
	this.alert		= true;	//报警方式（默认alert报警）
	this.message	= "";		//错误内容
	this.first		= null;		//在显示全部验证错误时的第一个错误控件（用于回到焦点）
	this.cancel		= false;	

	//定义内置格式
	var aUsage = {
		"int":"^([+-]?)\\d+$",											//整数
		"int+":"^([+]?)\\d+$",											//正整数
		"int-":"^-\\d+$",												//负整数
		"num":"^([+-]?)\\d*\\.?\\d+$",									//数字
		"num+":"^([+]?)\\d*\\.?\\d+$",									//正数
		"num-":"^-\\d*\\.?\\d+$",										//负数
		"float":"^([+-]?)\\d*\\.\\d+$",									//浮点数
		"float+":"^([+]?)\\d*\\.\\d+$",									//正浮点数
		"float-":"^-\\d*\\.\\d+$",										//负浮点数
																		//邮件
		"email":"^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$",	
		"color":"^#[a-fA-F0-9]{6}",										//颜色
		"url":"^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([\\w-./?%&=]*)?$",	//联接
		"chinese":"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$",				//仅中文
		"ascii":"^[\\x00-\\xFF]+$",										//仅ACSII字符
		"zipcode":"^\\d{6}$",											//邮编
		"mobile":"^0{0,1}13[0-9]{9}$",									//手机
																		//ip4地址
		"ip4":"^\(([0-1]?\\d{0,2})|(2[0-5]{0,2}))\\.(([0-1]?\\d{0,2})|(2[0-5]{0,2}))\\.(([0-1]?\\d{0,2})|(2[0-5]{0,2}))\\.(([0-1]?\\d{0,2})|(2[0-5]{0,2}))$",
		"notempty":"^[^ ]+$",											//非空
		"picture":"(.*)\\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$",	//图片
		"rar":"(.*)\\.(rar|zip|7zip|tgz)$",								//压缩文件
		"date":"^\\d{4}(\\-|\\/|\.)\\d{1,2}\\1\\d{1,2}$"				//日期
	};

	//缺省消息
	var aMessage =	{
		"int"	:"请输入整数",											//整数
		"int+"	:"请输入正整数",											//正整数
		"int-"	:"请输入负整数",											//负整数
		"num"	:"请输入数字",											//数字
		"num+"	:"请输入正数",											//正数
		"num-"	:"请输入负整数",											//负数
		"float"	:"请输入浮点数",											//浮点数
		"float+":"请输入正浮点数",										//正浮点数
		"float-":"请输入负浮点数",										//负浮点数
		"email"	:"请输入正确的邮箱地址",									//邮件
		"color"	:"请输入正确的颜色",										//颜色
		"url"	:"请输入正确的连接地址",									//联接
		"chinese":"请输入中文",											//中文
		"ascii"	:"请输入ascii字符",										//仅ACSII字符
		"zipcode":"请输入正确的邮政编码",									//邮编
		"mobile":"请输入正确的手机号码",									//手机
		"ip4"	:"请输入正确的IP地址",									//ip地址
		"notempty":"不能为空",											//非空
		"picture":"请选择图片",											//图片
		"rar"	:"请输入压缩文件",										//压缩文件
		"date"	:"请输入正确的日期"										//日期
	}

	var me = this;

	me.checkForm = function(oForm){
		me.pass		= true;
		me.message	= "";
		me.first	= null;
		
		if(me.cancel==true){
			return true;
		}
		
		var els = oForm.elements;
		//遍历所有表元素
		for(var i=0;i<els.length;i++){
			//取得格式
			var sUsage	= els[i].getAttribute("Usage");	
			
			//========以下代码用于检测必填、xss、sql注入=============
			var m_mandatory = els[i].getAttribute("mandatory");
			var m_maxlen = els[i].getAttribute("maxlen");	
			var m_xss = els[i].getAttribute("xss");	
			var m_sqlInject = els[i].getAttribute("sqlinject");	
			
			//对于失效状态不验证
			if(isDisabled(els[i])==true){
				continue;
			}
			
			//取得表单的值,用通用取值函数
			var sVal = getValue(els[i]);
			
			//验证长度和必填的正则表达式
			var lengthRegEx = "";
			if(typeof(m_maxlen)!="undefined"&&m_maxlen!=null){
				if(m_maxlen <= 1 || m_maxlen > 999999){
					m_maxlen = 1;
				}
			}
			if(typeof(m_mandatory)!="undefined"&&m_mandatory!=null){
				if(m_mandatory.toLowerCase() != "true"){
					m_mandatory = "false";
				}
			}
			
			if(typeof(m_maxlen)!= "undefined" && m_maxlen !=null){
				if(m_mandatory == "true"){
					lengthRegEx = V_EXP_MAXLEN.replace("#1", 1);
					lengthRegEx = lengthRegEx.replace("#2", m_maxlen);
				}else{
					lengthRegEx = V_EXP_MAXLEN.replace("#1", 0);
					lengthRegEx = lengthRegEx.replace("#2", m_maxlen);
				}
			} else if(typeof(m_mandatory)!="undefined" && m_mandatory!=null){
				if (m_mandatory == "true"){
					lengthRegEx = V_EXP_MANDATORY;
				}
			}
		
			//跨站点脚本编制的验证结果，true为正确，false为不正确
			var xssResult = true;
			if(typeof(m_xss)!="undefined"&&m_xss!=null){
				if(m_xss.toLowerCase() == "true"){
					//字符串->正则表达式,不区分大小写
					var reg = new RegExp(V_EXP_XSS_1,"i");
					var reg2 = new RegExp(V_EXP_XSS_2,"i");
					if(reg.test(sVal) || reg2.test(sVal)){
						xssResult = false;
					}
				}
			}
			
			//SQL注入的验证结果，true为正确，false为不正确
			var sqlInjectResult = true;
			if(typeof(m_sqlInject)!="undefined"&&m_sqlInject!=null){
				if(m_sqlInject.toLowerCase() == "true"){
					//字符串->正则表达式,不区分大小写
					var reg = new RegExp(V_EXP_SQL_INJECT_1,"i");
					if(reg.test(sVal)){
						sqlInjectResult = false;
					}
				}
			}
			//=====================Over=============================
			
			var sReg	= "";
			
			//如果设置Usage，则使用内置正则表达式，忽略Exp
			if(typeof(sUsage) != "undefined" && sUsage!=null){
				//如果Usage在表达室里找到，则使用内置表达式，无则认为是表达式；表达式可以是函数；
				if(aUsage[sUsage]!=null){			
					sReg = aUsage[sUsage];
				} else {
					try {
						if(eval(sUsage)==false){	
							me.pass		= false;
							if(me.first==null){
								me.first	= els[i];
							}

							addMessage(getMessage(els[i]));							

							if(me.showAll==false){
								setFocus(els[i]);
								break;
							}
						}
					} catch(e){ 
						alert("表达式[" + sUsage +"]错误:" + e.description)
						return false;
					}
				}
			} else {			
				sReg = els[i].getAttribute("Exp");
			}

			if(typeof(sReg) != "undefined" && sReg!=null){
				//对于失效状态不验证
				if(isDisabled(els[i])==true){
					continue;
				}

				//取得表单的值,用通用取值函数
				var sVal = getValue(els[i]);
				//字符串->正则表达式,不区分大小写
				var reg = new RegExp(sReg,"i");
				var reglength = new RegExp(lengthRegEx,"i");
				var regChinese = new RegExp(V_EXP_CHINESE,"g");
				var temp = sVal.replace(regChinese,"aa");
				if(!reg.test(sVal) || !reglength.test(temp) || !xssResult || !sqlInjectResult){
					me.pass		= false;
					if(me.first==null){
						me.first	= els[i];
					}

					//alert(reg);
					//验证不通过,弹出提示warning
					var sTip = getMessage(els[i]);
					if(sTip.length==0&&typeof(sUsage)!="undefined"&&sUsage!=null&&aMessage[sUsage]!=null){
						sTip = aMessage[sUsage];
					}
					addMessage(sTip);

					if(me.showAll==false){
						//该表单元素取得焦点,用通用返回函数
						setFocus(els[i]);
						break;
					}
				}
			}        
		}

		if(me.pass==false){
			showMessage();

			if(me.first!=null&&me.showAll==true){
				setFocus(me.first);
			}
		}

		return me.pass;
	}

	/*
	 *	添加错误信息
	 */
	function addMessage(msg){
		if(me.alert==true){
			me.message += msg + "<br>";//"\n";
		} else {
			me.message += msg + "<br>";
		}
	}

	/*
	 *	显示错误
	 */
	function getMessage(els){
		var sTip = els.getAttribute("tip");
		if(typeof(sTip)!="undefined"&&sTip!=null){
			return sTip;
		} else {
			return "";
		}
	}

	function alertCallback(g_check){
		g_check.setFocus(g_check.first);
	}
	/*
	 *	显示错误
	 */
	function showMessage(){
		//外接显示错误函数
		if(typeof(me.showMessageEx)=="function"){
			return me.showMessageEx(me.message);
		}

		if(me.alert==true){
			alert(me.message,null,alertCallback,g_check);
		} else {
			var divTip;
				divTip = document.getElementById("divErrorMessage");
			try	{
				if(typeof(divTip)=="undefined"||divTip==null){
						divTip = document.createElement("div");
						divTip.id			= "divErrorMessage";
						divTip.name			= "divErrorMessage";
						divTip.style.color	= "red";
						document.body.appendChild(divTip);
				}

				divTip.innerHTML = me.message;
			}catch(e){}
		}
	}

	/*
	 *	获得元素是否失效（失效的元素不做判断）
	 */
	function isDisabled(el){
		//对于radio,checkbox元素，只要其中有一个非失效元素就验证
		if(el.type=="radio"||el.type=="checkbox"){
			//取得第一个元素的name,搜索这个元素组
			var tmpels = document.getElementsByName(el.name);
			for(var i=0;i<tmpels.length;i++){
				if(tmpels[i].disabled==false){
					return false;
				}
			}
			return true;
		}else{
			return el.disabled;
		}
	}


	/*
	 *	取得对象的值（对于单选多选框把其选择的个数作为需要验证的值）
	 */
	function getValue(el){
		//取得表单元素的类型
		var sType = el.type;
		switch(sType){
			//文本输入框,直接取值el.value
			case "text":
			case "hidden":
			case "password":
			case "file":
			case "textarea": return el.value;
			//单多下拉菜单,遍历所有选项取得被选中的个数返回结果"0"表示选中一个，"00"表示选中两个
			case "checkbox":
			case "radio": return getRadioValue(el);
			case "select-one":
			case "select-multiple": return getSelectValue(el);
		}
		//取得radio,checkbox的选中数,用"0"来表示选中的个数,我们写正则的时候就可以通过0{1,}来表示选中个数
		function getRadioValue(el){
			var sValue = "";
			//取得第一个元素的name,搜索这个元素组
			var tmpels = document.getElementsByName(el.name);
			for(var i=0;i<tmpels.length;i++){
				if(tmpels[i].checked){
					sValue += "0";
				}
			}
			return sValue;
		}
		//取得select的选中数,用"0"来表示选中的个数,我们写正则的时候就可以通过0{1,}来表示选中个数
		function getSelectValue(el){
			var sValue = "";
			for(var i=0;i<el.options.length;i++){
				//单选下拉框提示选项设置为value=""
				if(el.options[i].selected && el.options[i].value!=""){
					sValue += "0";
				}
			}
			return sValue;
		}
	}
	
	this.setFocus = function(el){
		//取得表单元素的类型
		var sType = el.type;
		switch(sType){
			//文本输入框,光标定位在文本输入框的末尾
			case "text":
			case "hidden":
			case "password":
			case "file":
			case "textarea": 
				try{el.focus();var rng = el.createTextRange(); rng.collapse(false); rng.select();}catch(e){};
				break;
			
			//单多选,第一选项非失效控件取得焦点
			case "checkbox":
			case "radio": 
				var els = document.getElementsByName(el.name);
				for(var i=0;i<els.length;i++){
					if(els[i].disabled == false){
						els[i].focus();
						break;
					}
				}
				break;
			case "select-one":
			case "select-multiple":
				el.focus();
				break;
		}
	}

	/*
	 *	对没有通过验证的元素设置焦点
	 */
	function setFocus(el){
		//取得表单元素的类型
		var sType = el.type;
		switch(sType){
			//文本输入框,光标定位在文本输入框的末尾
			case "text":
			case "hidden":
			case "password":
			case "file":
			case "textarea": 
				try{el.focus();var rng = el.createTextRange(); rng.collapse(false); rng.select();}catch(e){};
				break;
			
			//单多选,第一选项非失效控件取得焦点
			case "checkbox":
			case "radio": 
				var els = document.getElementsByName(el.name);
				for(var i=0;i<els.length;i++){
					if(els[i].disabled == false){
						els[i].focus();
						break;
					}
				}
				break;
			case "select-one":
			case "select-multiple":
				el.focus();
				break;
		}
	}

	//自动绑定到所有form的onsubmit事件
	if(window.attachEvent){
		window.attachEvent("onload",function()
			{
				for(var i=0;i<document.forms.length;i++){
					var theFrom = document.forms[i]; 
					function mapping(f){ 
						f.attachEvent("onsubmit",function(){return me.checkForm(f);}); 
					} 

					if(theFrom){
						mapping(theFrom); 
						theFrom.attachEvent("onclick",function(){
								var o = event.srcElement;
								if(typeof(o.type)!="undefined"){
									var check = o.getAttribute("check");
									if(typeof(check)!="undefined"&&check!=null&&check.toLowerCase()=="false"){
										me.cancel = true;
									}																									
								}
							}
						); 
					}
				}
			}
		);
		
	}
	else
	{
		window.onsubmit = function(e){var theFrom = e.target;if(theFrom){return me.checkForm(theFrom);}}
		window.addEventListener("click",function(e){var o = e.target;
			if(typeof(o.type)!="undefined"){
				var check = o.getAttribute("check");
				if(typeof(check)!="undefined"&&check!=null&&check.toLowerCase()=="false"){me.cancel = true;}																									
				}
			}
		,false);
		
	}

	this.keyCheck = function(){
		if(window.attachEvent){
			window.attachEvent("onload",function(){for(var i=0;i<document.forms.length;i++){var theFrom = document.forms[i]; if(theFrom){myKeyCheck(theFrom);}}});
		}else{			
			window.addEventListener("load",function(e){for(var i=0;i<document.forms.length;i++){var theFrom = document.forms[i]; if(theFrom){myKeyCheck(theFrom);}}},false);
		}

		function myKeyCheck(oForm){
			var els = oForm.elements;
			//遍历所有表元素
			for(var i=0;i<els.length;i++){
				//取得格式
				var sUsage	= els[i].getAttribute("Usage");	
				
				//如果设置Usage，则使用内置正则表达式，忽略Exp
				if(typeof(sUsage)!="undefined"&&sUsage!=null){
					switch(sUsage.toLowerCase ()){
						case "zipcode":
						case "int":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /\d/.test(String.fromCharCode(chr))||(this.value.indexOf('+')<0?String.fromCharCode(chr)=="+":false)||(this.value.indexOf('-')<0?String.fromCharCode(chr)=="-":false);}
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/\D/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;
						case "mobile":
						case "int+":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /\d/.test(String.fromCharCode(chr))||(this.value.indexOf('+')<0?String.fromCharCode(chr)=="+":false);}
							els[i].onpaste		= function(e){if(e==null)if(e==null)return !clipboardData.getData('text').match(/[^\d\+]/); else return false; else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;
						case "int-":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /\d/.test(String.fromCharCode(chr))||(this.value.indexOf('-')<0?String.fromCharCode(chr)=="-":false);}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\-]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;
						case "float":
						case "num":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /[\+\-\.]|\d/.test(String.fromCharCode(chr));}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\.\+\-]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;
						case "float+":
						case "num+":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /[\+\.]|\d/.test(String.fromCharCode(chr));}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\.\+]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;
						case "float-":
						case "num-":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /[\-\.]|\d/.test(String.fromCharCode(chr));}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\.\-]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;
						case "ascii":
							els[i].style.imeMode= "disabled";
							break;
						case "ip4":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /[\.]|\d/.test(String.fromCharCode(chr));}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\.]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							els[i].maxLength	= 15;
							break;
						case "color":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /[a-fA-Z]|\d/.test(String.fromCharCode(chr))||(this.value.indexOf('#')<0?String.fromCharCode(chr)=="#":false);}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\#]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].maxLength	= 7;
							els[i].style.imeMode= "disabled";
							break;
						case "date":
							els[i].onkeypress	= function(e){var chr;if(e)chr=e.charCode; else chr=window.event.keyCode;if(chr==0)return true; else return /[\/\-\.]|\d/.test(String.fromCharCode(chr));}					
							els[i].onpaste		= function(e){if(e==null)return !clipboardData.getData('text').match(/[^\d\.\-]/); else return false;}
							els[i].ondragenter	= function(e){return false;}
							els[i].style.imeMode= "disabled";
							break;							
					}
				}
			}
		}
	}

}

//初始化
var g_check = new CLASS_CHECK();

