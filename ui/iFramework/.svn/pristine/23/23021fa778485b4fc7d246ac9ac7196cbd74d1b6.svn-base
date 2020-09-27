var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
function encode64(input)
{
	input = escape(input);
	var output = "";
	var chr1, chr2, chr3 = "";
	var enc1, enc2, enc3, enc4 = "";
	var i = 0;
	do
	{
		chr1 = input.charCodeAt(i++);
		chr2 = input.charCodeAt(i++);
		chr3 = input.charCodeAt(i++);
		enc1 = chr1 >> 2;
		enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
		enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
		enc4 = chr3 & 63;
		if (isNaN(chr2))
		{
			enc3 = enc4 = 64;
		}
		else if (isNaN(chr3))
		{
			enc4 = 64;
		}
		output = output +
		keyStr.charAt(enc1) +
		keyStr.charAt(enc2) +
		keyStr.charAt(enc3) +
		keyStr.charAt(enc4);
		chr1 = chr2 = chr3 = "";
		enc1 = enc2 = enc3 = enc4 = "";
	}
	while(i < input.length);
	return output;
}
function decode64(input)
{
	var output = "";
	var chr1, chr2, chr3 = "";
	var enc1, enc2, enc3, enc4 = "";
	var i = 0;
	// remove all characters that are not A-Z, a-z, 0-9, +, /, or =
	var base64test = /[^A-Za-z0-9\+\/\=]/g ;
	if (base64test.exec(input))
	{
		alert("There were invalid base64 characters in the input text.\n" +
		"Valid base64 characters are A-Z, a-z, 0-9, '+', '/', and '='\n" +
		"Expect errors in decoding.");
	}
	input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
	do
	{
		enc1 = keyStr.indexOf(input.charAt(i++));
		enc2 = keyStr.indexOf(input.charAt(i++));
		enc3 = keyStr.indexOf(input.charAt(i++));
		enc4 = keyStr.indexOf(input.charAt(i++));
		chr1 = (enc1 << 2) | (enc2 >> 4);
		chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
		chr3 = ((enc3 & 3) << 6) | enc4;
		output = output + String.fromCharCode(chr1);
		if (enc3 != 64)
		{
			output = output + String.fromCharCode(chr2);
		}
		if (enc4 != 64)
		{
			output = output + String.fromCharCode(chr3);
		}
		chr1 = chr2 = chr3 = "";
		enc1 = enc2 = enc3 = enc4 = "";
	}
	while (i < input.length);
	return unescape(output);
}
/**
 * 把form中的元素变为只读
 * @param fm form对象
 */
function readonlyForm(fm)
{
	var tp = fm.elements;
	for(var i=0;i<tp.length;i++)
	{
	    var classname=tp[i].className.replaceAll("ReadOnly","");
		if(tp[i].type.equalsIgnoreCase("text"))
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
		else if(tp[i].type.equalsIgnoreCase("button")&&tp[i].name!='close')
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
		else if(tp[i].type.equalsIgnoreCase("textarea"))
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
		else if(tp[i].type.equalsIgnoreCase("checkbox"))
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
		else if(tp[i].type.equalsIgnoreCase("radio"))
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
		else if(tp[i].type.equalsIgnoreCase("password"))
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
		else if(tp[i].type.equalsIgnoreCase("select-one"))
		{
			tp[i].disabled = 'disabled';
			tp[i].setAttribute("className", classname+"ReadOnly");
		}
	}
}

/**
 * 从form中取得请求的字符串（会枚举form中的所有可传入后台的对象）
 * @param fm form对象
 * @return 请求的字符串
 */
function getQueryStrFomForm(fm)
{
	var tp = fm.elements;
	var str = "";
	//var names = "";

	for(var i=0;i<tp.length;i++)
	{
		if(tp[i].type.equalsIgnoreCase("text") || tp[i].type.equalsIgnoreCase("hidden") || tp[i].type.equalsIgnoreCase("textarea") || tp[i].type.equalsIgnoreCase("select-one") || tp[i].type.equalsIgnoreCase("password"))
		{

			if (tp[i].name != "")
			{
				//names = names + "," + tp[i].name;
				str = str + "&" + tp[i].name + "=" + tp[i].value.toUrlString();
			}
		}
		else if ((tp[i].type.equalsIgnoreCase("checkbox") || tp[i].type.equalsIgnoreCase("radio")) && tp[i].checked)
		{

			if (tp[i].name != "")
			{
				str = str + "&" + tp[i].name + "=" + tp[i].value.toUrlString();
			}
		}
	}

	/**if(names != "")
		names = names.substring(1,names.length);
		alert(names);
	var arrays = names.split(",");

	for(i=0;i<arrays.length;i++)
	{
		//alert(fm(arrays[i]).value);
		if(fm.all(arrays[i]).length == undefined)
		{
			str = str + "&" + arrays[i] + "=" + fm.all(arrays[i]).value.toUrlString();
		}
		else if(tp[i].type == "text")
		{
			str = str + "&" + arrays[i] + "=" + tp[i].value.toUrlString();
		}
		else
		{
			var tmp = fm.all(arrays[i]);
			var tpvalue = "";
			for(var j=0;j<tmp.length;j++)
			{
				if(tmp[j].checked)
				{
					tpvalue = tpvalue + "," + tmp[j].value;
				}
				else if (tmp.type.equalsIgnoreCase("select-one"))
				{
					tpvalue = tpvalue + "," + tmp.value;
					break;
				}
			}
			if(tpvalue != "")
			{
				tpvalue = tpvalue.substring(1,tpvalue.length);
			}
			str = str + "&" + arrays[i] + "=" + tpvalue.toUrlString();
		}
	}*/
	if(str != "")
	{
		str = str.substring(1,str.length);
	}
	return str;
}

/**
&ltinput id=up size=60 onkeypress="regInput(/^\d{0,12}(\.\d{0,2})?$/)"&gt&ltbutton onclick="lw.value = chineseNumber(up.value)"&gt转为大写&lt/button><br>
&ltinput id=lw size=60 value="壹仟壹佰壹拾壹圆整"&gt&ltbutton onclick="up.value = aNumber(lw.value)"&gt转为小写&lt/button&gt
*/
function regInput(reg)
{
	var srcElem = event.srcElement;
	var oSel = document.selection.createRange();
	oSel = oSel.duplicate();
	oSel.text = "";
	var srcRange = srcElem.createTextRange();
	oSel.setEndPoint("StartToStart", srcRange);
	var num = oSel.text + String.fromCharCode(event.keyCode) + srcRange.text.substr(oSel.text.length);
	event.returnValue = reg.test(num);
}
/**
 * 把小写金额转换为大写金额
 * @param num 输入的金额
 * @return 转换之后的大写金额
 */
function nomalToChineseMoney(num)
{
	if (isNaN(num) || num > Math.pow(10, 12)) return "";
	var cn = "零壹贰叁肆伍陆柒捌玖";
	var unit = new Array("拾佰仟", "分角");
	var unit1= new Array("万亿", "");
	var numArray = num.toString().split(".");
	var start = new Array(numArray[0].length-1, 2);
	function toChinese(num, index)
	{
		var num = num.replace(/\d/g, function ($1)
		{
		return cn.charAt($1)+unit[index].charAt(start--%4 ? start%4 : -1);
		});
		return num;
	}
	for (var i=0; i<numArray.length; i++)
	{
		var tmp = "";
		for (var j=0; j*4<numArray[i].length; j++)
		{
			var strIndex = numArray[i].length-(j+1)*4;
			var str = numArray[i].substring(strIndex, strIndex+4);
			var start = i ? 2 : str.length-1;
			var tmp1 = toChinese(str, i);
			tmp1 = tmp1.replace(/(零.)+/g, "零").replace(/零+$/, "");
			tmp1 = tmp1.replace(/^壹拾/, "拾");
			tmp = (tmp1+unit1[i].charAt(j-1)) + tmp;
		}
		numArray[i] = tmp;
	}
	numArray[1] = numArray[1] ? numArray[1] : "" ;
	numArray[0] = numArray[0] ? numArray[0]+"圆" : numArray[0], numArray[1] = numArray[1].replace(/^零+/, "");
	numArray[1] = numArray[1].match(/分/) ? numArray[1] : numArray[1]+"整";
	return numArray[0]+numArray[1];
}
/**
 * 把大写金额转换为小写金额
 * @param num 输入的大写金额
 * @return 转换之后的小写金额
 */
function chineseToSmallMoney(num)
{
	var numArray = new Array();
	var unit = "亿万圆$";
	for (var i=0; i<unit.length; i++)
	{
		var re = eval("/"+ (numArray[i-1] ? unit.charAt(i-1) : "") +"(.*)"+unit.charAt(i)+"/");
		if (num.match(re))
		{
			numArray[i] = num.match(re)[1].replace(/^拾/, "壹拾");
			numArray[i] = numArray[i].replace(/[零壹贰叁肆伍陆柒捌玖]/g, function ($1){
					return "零壹贰叁肆伍陆柒捌玖".indexOf($1);
				}
			);
			numArray[i] = numArray[i].replace(/[分角拾佰仟]/g, function ($1){
					return "*"+Math.pow(10, "分角 拾佰仟 ".indexOf($1)-2)+"+";
				}
			).replace(/^\*|\+$/g, "").replace(/整/, "0");
			numArray[i] = "(" + numArray[i] + ")*"+Math.ceil(Math.pow(10, (2-i)*4));
		}
		else
			numArray[i] = 0;
	}
	return eval(numArray.join("+"));
}

/**
 * 数字格式化函数
 * alert(formatNumber(0,''));
 * <BR>alert(formatNumber(12432.21,'#,###'));
 * <BR>alert(formatNumber(12432.21,'#,###.000#'));
 * <BR>alert(formatNumber(12432,'#,###.00'));
 * <BR>alert(formatNumber('12432.415','#,###.0#'));
 * @param number 要格式化的数字
 * @param pattern  要格式化的格式
 *
 */
function formatNumber(number,pattern)
{
	var negFlag = "false"; // 负数标记
	
	
	var str = Number(number).toString();
	if (str.indexOf("-")==0)
    {
    	negFlag = "true";
    	str = str.replace("-","");
    	number = -number;
    }
	
	var strInt;
	var strFloat;
	var formatInt;
	var formatFloat;
	if(cTrim(str,0)=="")
	      return "";
	//判断模式串是否有小数格式
	if(/\./g.test(pattern))
	{
		formatInt = pattern.split('.')[0];
		formatFloat = pattern.split('.')[1];
	}
	else
	{
		formatInt = pattern;
		formatFloat = null;
	}
	if(/\./g.test(str))
	{
		// 如果字符串有小数
		if(formatFloat!=null)
		{
			var tempFloat = Math.round(parseFloat('0.'+str.split('.')[1])*Math.pow(10,formatFloat.length))/Math.pow(10,formatFloat.length);
			//strInt = (Math.floor(number)+Math.floor(tempFloat)).toString();
			// 如果数字串是负数，则执行Math.floor()函数时先将数字串改为正数，然后取正，然后再加“-”号。
				//if (number<0)
				//{
				      //strInt = "-"+(Math.floor(number*(-1))+Math.floor(tempFloat)).toString();
				//}
				//else
				//{
				      strInt = (Math.floor(number)+Math.floor(tempFloat)).toString();
				//}
			strFloat = /\./g.test(tempFloat.toString())?tempFloat.toString().split('.')[1]:'0';
		}
		else
		{
			strInt = Math.round(number).toString();
			strFloat = '0';
		}
	}
	else
	{
		strInt = str;
		strFloat = '0';
	}
	// 处理整数数位的格式化
	if(formatInt!=null)
	{
		var outputInt = '';
		var zero = formatInt.match(/0*$/)[0].length;
		var comma = null;
		if(/,/g.test(formatInt)){
			comma = formatInt.match(/,[^,]*/)[0].length-1;
		}
		var newReg = new RegExp('(\\d{'+comma+'})','g');
		if(strInt.length<zero){
			outputInt = new Array(zero+1).join('0')+strInt;
			outputInt = outputInt.substr(outputInt.length-zero,zero);
		}else{
			outputInt = strInt;
		}
		outputInt = outputInt.substr(0,outputInt.length%comma)+outputInt.substring(outputInt.length%comma).replace(newReg,(comma!=null?',':'')+'$1');
		outputInt = outputInt.replace(/^,/,'');
		strInt = outputInt;
	}
	// 处理小数位的格式化
	if(formatFloat!=null){
		var outputFloat = '';
		var zero = formatFloat.match(/^0*/)[0].length;
		if(strFloat.length<zero){
			outputFloat = strFloat+new Array(zero+1).join('0');
			//outputFloat = outputFloat.substring(0,formatFloat.length);
			var outputFloat1 = outputFloat.substring(0,zero);
			var outputFloat2 = outputFloat.substring(zero,formatFloat.length);
			outputFloat = outputFloat1+outputFloat2.replace(/0*$/,'');
		}else{
		// 如果小数是0，而且模式串的小数格式中也不包含0，则只保留整数部分。
	      if (strFloat==0&&zero==0)
	            outputFloat = '';
	      else
				outputFloat = strFloat.substring(0,formatFloat.length);
		}
		strFloat = outputFloat;
	}else{
		if(pattern!='' || (pattern=='' && strFloat=='0')){
			strFloat = '';
		}
	}
	if(negFlag == "true")
	{
		return "-" + strInt+(strFloat==''?'':'.'+strFloat);
	}
	else
	{
		return strInt+(strFloat==''?'':'.'+strFloat);
	}
}

/**
 * 取除空格
 */
function cTrim(sInputString,iType)
{
	var sTmpStr = ' ';
	var i = -1;

	if(iType == 0 || iType == 1)
	{
		while(sTmpStr == ' ')
		{
			++i;
			sTmpStr = sInputString.substr(i,1);
		}
		sInputString = sInputString.substring(i);
	}

	if(iType == 0 || iType == 2)
	{
		sTmpStr = ' ';
		i = sInputString.length;
		while(sTmpStr == ' ')
		{
			--i;
			sTmpStr = sInputString.substr(i,1);
		}
		sInputString = sInputString.substring(0,i+1);
	}
	return sInputString;
}

/**
 * 日期对象格式化方法,格式：yyyy-MM-dd或者yyyy/MM/dd或yyyy年MM月dd日
 * @param format 要格式化的格式 格式：yyyy-MM-dd或者yyyy/MM/dd或yyyy年MM月dd日
 * @return string 格式化之后日期
 */
Date.prototype.format = function(format)
{
   var o = {
     "M+" : this.getMonth()+1, //month
     "d+" : this.getDate(),    //day
     "h+" : this.getHours(),   //hour
     "m+" : this.getMinutes(), //minute
     "s+" : this.getSeconds(), //second
     "q+" : Math.floor((this.getMonth()+3)/3), //quarter
     "S" : this.getMilliseconds() //millisecond
   };
   if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
     (this.getFullYear()+"").substr(4 - RegExp.$1.length));
   for(var k in o)if(new RegExp("("+ k +")").test(format))
     format = format.replace(RegExp.$1,
       RegExp.$1.length==1 ? o[k] :
         ("00"+ o[k]).substr((""+ o[k]).length));
   return format;
};
/**
 * 取得两个日期相差的天数
 * @param date1 要比较的第一个日期
 * @param date2 要比较的第二个日期
 * @return 相差的天数
 */
function getDateDiff(date1,date2)
{
   var re   =  /^(\d{4})\S(\d{1,2})\S(\d{1,2})$/;
   var dt1,dt2;
   if(re.test(date1))
   {
    dt1 = new Date(RegExp.$1,RegExp.$2 - 1,RegExp.$3);
   }
   if(re.test(date2))
   {
    dt2 = new Date(RegExp.$1,RegExp.$2 - 1,RegExp.$3);
   }
   return Math.floor((dt2-dt1)/(1000 * 60 * 60 * 24));
}
/**
 * @class StringBuffer类
 * @return 返回stringbuffer实例
 */
function StringBuffer()
{
    this._strings = [];
    if(arguments.length==1)
    {
        this._strings.push(arguments[0]);
    }
}
/**
 * 向stringbuffer中追加字符串
 * @param str 要追加的字符串
 */
StringBuffer.prototype.append = function(str)
{
    this._strings.push(str);
    return this;
};
/**
 * 返回stringbuffer中的内容
 * @return str 返回stringbuffer中的内容
 */
StringBuffer.prototype.toString = function()
{
    return this._strings.join("");
};
/**
 *  返回长度
 * @return str  返回长度
 */
StringBuffer.prototype.length = function()
{
    var str = this._strings.join("");
    return str.length;
};
/**
 * 取得arg在stringbuffer中第一次出现的位置
 * @param arg 要取得位置的字符串
 * @return 位置信息
 */
StringBuffer.prototype.indexOf = function(arg)
{
    var str = this._strings.join("");
    return str.indexOf(arg);
};
/**
 * 取得arg在stringbuffer中最后一次出现的位置
 * @param arg 要取得位置的字符串
 * @return 位置信息
 */
StringBuffer.prototype.lastIndexOf = function(arg)
{
    var str = this._strings.join("");
    return str.lastIndexOf(arg);
};
/**
 * 在stringbuffer中截取字符串
 * @param start 开始位置
 * @param end 结束位置
 * @return 截取之后的字符串
 */
StringBuffer.prototype.substring = function(start,end)
{
    var str = this._strings.join("");
    return str.substring(start,end);
};
/**
 * 取得stringbuffer中index位置的字符
 * @param index 位置
 * @return 返回index位置的字符
 */
StringBuffer.prototype.charAt = function(index)
{
    var str = this._strings.join("");
    return str.charAt(index);
};
/**
 * 字符串在数组中的开始位置
 * @param substr 要查找的字符串
 * @param start 开始查找的位置
 * @return 位置信息，如果不存在就返回-1
 */
Array.prototype.indexOf=function(substr,start){
	var ta,rt,d='\0';
	if(start!=null){ta=this.slice(start);rt=start;}else{ta=this;rt=0;}
	var str=d+ta.join(d)+d,t=str.indexOf(d+substr+d);
	if(t==-1)return -1;rt+=str.slice(0,t).replace(/[^\0]/g,'').length;
	return rt;
};
/**
 * 字符串在数组中的结束位置
 * @param substr 要查找的字符串
 * @param start 开始查找的位置
 * @return 位置信息，如果不存在就返回-1
 */
Array.prototype.lastIndexOf=function(substr,start){
	var ta,rt,d='\0';
	if(start!=null){ta=this.slice(start);rt=start;}else{ta=this;rt=0;}
	ta=ta.reverse();var str=d+ta.join(d)+d,t=str.indexOf(d+substr+d);
	if(t==-1)return -1;rt+=str.slice(t).replace(/[^\0]/g,'').length-2;
	return rt;
};
/**
 * 替换数组内部的值
 * @param reg 要替换的正则表达式
 * @param rpby 给替换为的内容
 * @return 替换之后的字符串
 */
Array.prototype.replace=function(reg,rpby){
	var ta=this.slice(0),d='\0';
	var str=ta.join(d);str=str.replace(reg,rpby);
	return str.split(d);
};

/**
 * 检查输入字符串是否是包含HTML特殊字符&、<、>、"
 * @return 如果包含返回true，否则返回false
 */
String.prototype.isIncludeHtmlChar = function()
{
  /*字符串中仅有下列字符，则字符串为数字*/
	var allHTMLChar="&<>\"";
  for (var i = 0; i < this.length; i++) {
    if (allHTMLChar.indexOf(this.charAt(i)) >= 0) {
      return true;
    }
  }
  return false;
};
/**
 * 替换字符中的url特殊字符为标准字符：
 * @return 返回替换之后的字符串
 */
String.prototype.toUrlString=function()
{
   return this.replace(/\%/g,"%25").replace(/\//g,"%2F").replace(/\?/g,"%3F").replace(/\+/g,"%2B").replace(/\#/g,"%23").replace(/\&/g,"%26");
};
/**
 * 字符串不区分大小写的比较
 * @param arg 要比较的字符串
 * @return 如果相同返回true，否则返回false
 */
String.prototype.equalsIgnoreCase=function(arg)
{
        return (new String(this.toLowerCase())==(new String(arg)).toLowerCase());
};
/**
 * 取得字符串的长度，双字节按照两个长度计算
 * @return 取得字符串的长度，双字节按照两个长度计算
 */
String.prototype.lengthb=function()
{
        return this.replace(/[^\x00-\xff]/g,"**").length;
};
/**
 * 字符串比较
 * @param arg 要比较的字符串
 * @return 如果相同返回true，否则返回false
 */
String.prototype.equals=function(arg)
{
        return (this.toString()==arg.toString());
};
/**
 * 去掉字符串两边的空格
 * @return 去掉空格之后的字符串
 */
String.prototype.trim = function()
{
	return this.replace(/^\s+|\s+$/g,"");
};
/**
 * 去掉字符串左边的空格
 * @return 去掉空格之后的字符串
 */
String.prototype.ltrim = function()
{
	return this.replace(/^\s+/,"");
};
/**
 * 去掉字符串右边的空格
 * @return 去掉空格之后的字符串
 */
String.prototype.rtrim = function()
{
	return this.replace(/\s+$/,"");
};
/**
 * 判断字符串是否从toffset位起始，以prefix开头
 * @param prefix 开始的字符串
 * @param toffset 开始位置
 * @return 如果从toffset位起始，以prefix开头，返回true，否则返回false
 */
String.prototype.startsWith=function(prefix,toffset)
{
	if(toffset==undefined)
		{toffset=0;}
	if(prefix==undefined)
		{return false;}
	if(this.indexOf(prefix)==toffset)
		{return true;}
	return false;
};
/**
 * 把字符串转换为Date对象，字符串的格式：yyyy-MM-dd或者yyyy/MM/dd
 * @return 把字符串转换为Date对象，如果不是日期，返回NaN
 */
String.prototype.toDate=function()
{
	return new Date(Date.parse(this.replace(/-/g,   "/")));
};
/**
 * 判断字符串是以prefix结束
 * @param prefix 结束的字符串
 * @return 如果以prefix结束，返回true，否则返回false
 */
String.prototype.endsWith=function(suffix)
{
	if(suffix==undefined)
		{return false;}
	if(this.lastIndexOf(suffix)==this.length-suffix.length)
		{return true;}
	return false;
};
/**
 * 把字符串中的s1替换位s2
 * @param s1 要被替换的字符串
 * @param s2 要替换成的字符串
 * @return 替换之后的字符串
 */
String.prototype.replaceAll = function(s1,s2)
{
	return this.replace(new RegExp(s1,"gm"),s2);
};
/**
 * 判断字符串是否是整型字符
 * @return 如果是整型，返回true，否则返回false
 */
String.prototype.isInt = function()
{
	return /^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$/.test(this);
};
/**
 * 判断字符串是否是整型字符
 * @return 如果是整型，返回true，否则返回false
 */
String.prototype.isDouble = function()
{
	return /^[-\+]?\d+(\.\d+)?$/.test(this);
};
/**
 * 判断字符串是否是数字（不包含-和.）
 * @return 如果是数字，返回true，否则返回false
 */
String.prototype.isNumber = function()
{
	return /^\d+$/.test(this);
};
/**
 * 判断字符串是否是纯英文(A-Z/a-z)
 * @return 如果是纯英文，返回true，否则返回false
 */
String.prototype.isOnlyEnglish = function()
{
	return /^[A-Za-z]+$/.test(this);
};
/**
 * 判断字符串是否是纯中文(不包含英文的任何字符，包括数字)
 * @return 如果是纯中文，返回true，否则返回false
 */
String.prototype.isOnlyChinese = function()
{
	return /^[\u0391-\uFFE5]+$/.test(this);
};
/**
 * 判断字符串是否是空字符串
 * @return 如果是空字符串，返回true，否则返回false
 */
String.prototype.isEmpty = function()
{
	var tp = this.trim();
	if(tp == "")
		return true;
	else
		return false;
};
/**
 * 把半角字符转换为全角字符
 * @return 返回转换之后的全角字符
 */
String.prototype.toCase = function()
{
        var tmp = "";
        for(var i=0;i<this.length;i++)
        {
                if(this.charCodeAt(i)>0&&this.charCodeAt(i)<255)
                {
                        tmp += String.fromCharCode(this.charCodeAt(i)+65248);
                }
                else
                {
                        tmp += String.fromCharCode(this.charCodeAt(i));
                }
        }
        return tmp;
};
/**
 * 判断字符串是否是日期格式：格式：yyyy-MM-dd或者yyyy/MM/dd
 * @return 返回true或false
 */
String.prototype.isDate = function()
{
        return this.isLongDate()||this.isShortDate();
};
/**
 * 判断字符串是否是短日期格式：格式：yyyy-MM-dd或者yyyy/MM/dd
 * @return 返回true或false
 */
String.prototype.isShortDate = function()
{
        var r = this.replace(/(^\s*)|(\s*$)/g, "").match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
        if(r==null)
        {
        	return false;
        }
        var d = new Date(r[1], r[3]-1, r[4]);
        return (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]);
};
/**
 * 判断字符串是否是长日期格式：格式：yyyy-MM-dd或者yyyy/MM/dd
 * @return 返回true或false
 */
String.prototype.isLongDate = function()
{
        var r = this.replace(/(^\s*)|(\s*$)/g, "").match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/);
        if(r==null)
        {
        	return false;
        }
        var d = new Date(r[1], r[3]-1,r[4],r[5],r[6],r[7]);
        return (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]&&d.getHours()==r[5]&&d.getMinutes()==r[6]&&d.getSeconds()==r[7]);

};
/**
 * 判断字符串是否是ip地址
 * @return 返回true或false
 */
String.prototype.isIP = function()
{
    var reSpaceCheck = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/;
    if (reSpaceCheck.test(this))
    {
        this.match(reSpaceCheck);
        if (RegExp.$1 <= 255 && RegExp.$1 >= 0
         && RegExp.$2 <= 255 && RegExp.$2 >= 0
         && RegExp.$3 <= 255 && RegExp.$3 >= 0
         && RegExp.$4 <= 255 && RegExp.$4 >= 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        return false;
    }
};

/**
 * 得到左边的字符串
 * @param len 要取长度
 * @return 返回指定长度字符串
 */
String.prototype.Left = function(len)
{
    if(isNaN(len)||len==null)
    {
        len = this.length;
    }
    else
    {
        if(parseInt(len)<0||parseInt(len)>this.length)
        {
            len = this.length;
        }
    }
    return this.substr(0,len);
};
/**
 * 得到右边的字符串
 * @param len 要取长度
 * @return 返回指定长度字符串
 */
String.prototype.Right = function(len)
{
    if(isNaN(len)||len==null)
    {
        len = this.length;
    }
    else
    {
        if(parseInt(len)<0||parseInt(len)>this.length)
        {
            len = this.length;
        }
    }
    return this.substring(this.length-len,this.length);
};


/**
 * 打开一个非模式窗口
 * @param url 窗口打开地址
 * @param width 窗口宽度
 * @param height 窗口高度
 * @param scrollbars 滚动条
 * @return 返回窗口对象
 */
function OpenWin(url,width,height,scrollbars)
{
	//width=480??height=500
	var winLeft = (screen.availWidth - width) / 2;
	var winTop = (screen.availHeight - height) / 3;
	var winWidth = width;
	var winHeight = height;
	return window.open(url,"null","height="+winHeight+",width="+winWidth+",left="+winLeft+",top="+winTop+",scrollbars="+scrollbars+"");
}

/**
 * 折叠展开区域的方法
 * @param strDivId 要折叠展开的div
 * @param ctxPath 应用的路径
 * @return 无返回值
 */
function WrapBlock(strDivId,ctxPath)
{
    var objImg = event.srcElement;
	var objDiv = document.getElementById(strDivId);
	var objInnerDivs = objDiv.getElementsByTagName("div");
    if (objImg)
    {
        if (objImg.src.toString().indexOf("block_unwrap") != -1)
        {
            objImg.src = ctxPath + "/resource/image/block_wrap.gif";
			for (var i=0; i<objInnerDivs.length; i++)
			{
			    if(objInnerDivs[i].className == "DivTail")
				{
				    objInnerDivs[i].style.display = "none";
				}
			}
        }
        else
        {
            objImg.src = ctxPath + "/resource/image/block_unwrap.gif";
            for (var i=0; i<objInnerDivs.length; i++)
			{
			    if(objInnerDivs[i].className == "DivTail")
				{
				    objInnerDivs[i].style.display = "block";
				}
			}
        }
    }
}
/**
 * 鼠标放上时表格行高亮
 * @param tableId 表格id
 * @param rowIndex 行号
 * @return 无返回值
 */
function FocusTableRow(tableId,rowIndex)
{
	var preBgColor = null;
	var table = document.getElementById(tableId);
	if (table == null)
	{
    	return;
	}
	if (table.rules != null)
	{
	    table.rules = "none";
	}
	var tbody = table.getElementsByTagName("tbody")[0];
	var rows = tbody.getElementsByTagName("tr");
	for (var i=rowIndex; i < rows.length; i++)
	{
		rows[i].onmouseover = function() { preBgColor=this.style.backgroundColor; this.style.backgroundColor='#CFE4FE'; };
		rows[i].onmouseout = function() { this.style.backgroundColor=preBgColor; };
	}
}
/**
 * OpenModalWin - 打开模态窗,如果未设置模态窗口的显示位置则居中显示
 * @param url: 打开的url;
 * @param width: 模态窗口宽度；
 * @param height: 模态窗口高度；
 * @param height: 向模态窗口传递的参数；
 * @param wleft: 模态窗口的左坐标；
 * @param wtop: 模态窗口的上坐标；
 */
function OpenModalWin(url,width,height,argument,wleft,wtop)
{
	var tmp = new Date().getTime();

	if(url.indexOf("?") == -1)
	{
		url = url + "?_t_=" + tmp;
	}
	else
	{
		url = url + "&_t_=" + tmp;
	}
    var re;
	var winWidth = width;
	var winHeight = height;
	if ((wleft=="" || wleft=="undefined")||(wtop=="" || wtop=="undefined"))
	{
		re = window.showModalDialog(url,argument,"dialogHeight: "+winHeight+"px; dialogWidth: "+winWidth+"px; edge: Raised; center: Yes; help: No; scroll:Yes; resizable: Yes; status: No;");
	}
	else
	{
		re = window.showModalDialog(url,argument,"dialogHeight: "+winHeight+"px; dialogWidth: "+winWidth+"px;dialogTop: " + wtop + ";dialogLeft: " + wleft + "; edge: Raised; help: No; scroll:Yes; resizable: Yes; status: No;");
	}
	return re;
}
/**
 * GetParentArgOnModal - 模态窗口上获取主窗口传递的参数
 */
function GetParentArgOnModal()
{
	var val = window.dialogArguments;
	return val;
}
/**
 * ReturnObjOnModal - 模态窗口向主窗口返回参数并关闭
 * @param obj 要返回的参数
 */
function ReturnObjOnModal(obj)
{
	window.returnValue = obj;
	window.close();
}
/**
 * setIframeHeight - 去掉Iframe的滚动条，动态设置Iframe的高度
 * @param strContainerId: Iframe的src指向的页面的最外层容器元素的Id;
 * @param strIframeId: Iframe本身的Id，需要设置Iframe的SCROLLING="NO"；
 * @param strPaddindHeight: 用户自己填充的高度，只允许数字，用于边距校正；
 */
function setIframeHeight(strContainerId,strIframeId,strPaddindHeight)
{
    var objContainer = document.getElementById(strContainerId);
    if (objContainer.offsetHeight.toString() == "0")
    {
        var j = 0;
        var arrElmFlag = new Array();
        for(var i=0;i<parent.document.all.length;i++)
        {
            if (parent.document.all(i).style.display == "none")
            {
                parent.document.all(i).style.display = "block";
                arrElmFlag[j++] = i.toString();
            }
        }
        parent.document.all(strIframeId).height = Number(objContainer.offsetHeight) + Number(strPaddindHeight);
        for (var m=0; m<j; m++)
        {
            if (parent.document.all(Number(arrElmFlag[m])).style.display == "block")
            {
                parent.document.all(Number(arrElmFlag[m])).style.display = "none";
            }
        }
    }
    else
    {
        parent.document.all(strIframeId).height = Number(objContainer.offsetHeight) + Number(strPaddindHeight);
    }
}
/**
 * highlightTableRow - 高亮表格的焦点行
 * @param tableId 表格id
 */
function highlightTableRow(tableId)
{
    var previousClass = null;
    var table = document.getElementById(tableId);
    if (table == null)
    {
    	return;
    }

    var tbody = table.getElementsByTagName("tbody")[0];
    var rows = tbody.getElementsByTagName("tr");
    // add event handlers so rows light up
    for (var i=0; i < rows.length; i++)
    {
         rows[i].onmouseover = function() {previousClass=this.className;this.className+='over';};
         rows[i].onmouseout = function() { this.className=previousClass; };
     }
}
/**
 * getFormattedTime - 获得格式化的时间(单位为毫秒的时间转换为以时 分 秒为单位的时间)
 * @param timeMillis 毫秒时间
 */
function getFormattedTime(timeMillis)
{
   var formattedTime = "";
   //小于0
   if (timeMillis < 0)
   {
       formattedTime = "未知";
   }
   else
   {
       if (timeMillis < 1000)
       {
           formattedTime = timeMillis + " 毫秒";
       }
       else
       {
           //计算出天、小时、分钟、秒等
           var timeInSeconds = parseInt(timeMillis/1000);
           var timeInMill = timeMillis - timeInSeconds * 1000;
           timeInMill = timeInMill / 1000;
           if (timeInMill < 0.1)
           {
           		timeInMill = 0;
           }
           var days, hours, minutes;
           days = parseInt(timeInSeconds / 86400);
           timeInSeconds = timeInSeconds - days * 86400;
           hours = parseInt(timeInSeconds / 3600);
           timeInSeconds = timeInSeconds - hours * 3600;
           minutes = parseInt(timeInSeconds / 60);
           timeInSeconds = timeInSeconds - minutes * 60;

           timeInSeconds = timeInSeconds + timeInMill;
           if (timeInSeconds > 0)
           {
               formattedTime = timeInSeconds + " 秒";
           }
           if (minutes > 0)
           {
               formattedTime = minutes + " 分 " + formattedTime;
           }
           if (hours > 0)
           {
               formattedTime = hours + " 时 " + formattedTime;
           }
           if (days > 0)
           {
               formattedTime = days + " 天 " + formattedTime;
           }
       }
   }
   return formattedTime;
}
/**
 * 判断inputNumber是否在max和min之间
 * @param inputNumber 要校验的数字
 * @param max 最大值
 * @param min 最小值
 */
function isBetween(inputNumber, MIN, MAX) {
  if (inputNumber == null || inputNumber == "") {
    return false;
  }
  if (inputNumber < MIN || inputNumber > MAX) {
    return false;
  }
  return true;
}
/**
 * ajax树的afterOpenFunction方法调用的内容(树初始化时自动打开灰色的节点)
 * @param treeObj ajax树对象
 * @param ids  ajax树展开节点的id(逗号分隔)
 * @param treeOpenRoute 树展开路径
 * @param bOpenFirstLevel 是否强制展开第一级节点("true"-表示展开，其它-表示不展开)
 */
function openAjaxTreeFunc(treeObj,ids,treeOpenRoute,bOpenFirstLevel)
{
	var tmp = ids;
	if(tmp+"" == "null")
	{
		processNodes(treeObj,"0",treeOpenRoute,bOpenFirstLevel);
	}
	else
	{
		processNodes(treeObj,ids,treeOpenRoute,bOpenFirstLevel);
	}
}
/**
 * ajax数初始化时的节点处理
 * @param treeObj ajax树对象
 * @param ids  ajax树展开节点的id(逗号分隔)
 * @param treeOpenRoute 树展开路径
 * @param bOpenFirstLevel 是否强制展开第一级节点("true"-表示展开，其它-表示不展开)
 */
function processNodes(treeObj,ids,treeOpenRoute,bOpenFirstLevel)
{
//	alert("processNodes");
	golbIsClick = false;
	if(!golbIsClick)
	{
//		alert("step into");
		var tmpids = treeObj.getSubItems(ids);
//		alert("tmmpids:"+tmpids);
		var tparray = tmpids.split(",");
//		alert("tparray.length:"+tparray.length);
		for(var i=0;i<tparray.length;i++)
		{
			var routeId = "";
			var nodeState = "0";
			var pos = treeOpenRoute.indexOf("," + tparray[i] + "_");
			if(pos> -1)
			{
				routeId = treeOpenRoute.substring(treeOpenRoute.indexOf(tparray[i] + "_"));
				routeId = routeId.substring(0,routeId.indexOf(","));
				var isCheck = routeId.split("_")[1];
			 	if (isCheck+""=="0")
			 	{
			 		nodeState = "unsure";
				}
				else
				{
					nodeState = "1";
				}
				if (isCheck+""=="0")
				{
					treeObj.openItem(tparray[i]);
				}
				treeObj.setCheck_split(tparray[i],nodeState);
			}else{
				
				treeObj.setCheck_split(tparray[i],0);
			}
			if (bOpenFirstLevel=="true" && ids=="0")
			{
				treeObj.openItem(tparray[i]);
			}
		}
	}
}
/**
 * 将null转换成"",非null的字符串直接返回;
 * @param str
 * @return 返回非null的字符串
 */
function convertorQuote(str)
{
	if(null == str){
		return "";
	}else{
		return str;
	}
}

/**
 * 选中一组radioBox的某一个
 * @param radioObj radioBox对象
 * @param pos 待选中radio的序号，从1开始
 */
function radioChecked(radioObj,pos)
{
	try
	{
		var objRadio = radioObj;
		if (objRadio!=null)
		{
			if(objRadio.length==undefined)
			{
				objRadio.checked=true;
			}
			else
			{
				objRadio[pos-1].checked=true;
			}
		}
	}
	catch(e)
	{
	}
}
function hback()
{
    //Stop Ctrl+N
    if ((event.ctrlKey) && (event.keyCode==78))
    {
              event.returnValue=false;
    }
    //Stop Ctrl+R
    if ((event.ctrlKey) && (event.keyCode==82))
    {
         event.keyCode=0;
         event.returnValue=false;
    }
    //Stop Shift+F10
    if ((event.shiftKey) && (event.keyCode==121))
    {
         event.returnValue=false;
    }
    //Stop SHIFT+CLICK
    if ((event.srcElement.tagName=="A") && (event.shiftKey))
    {
         event.returnValue = false;
    }
    //Stop F5 And F11
    if (event.keyCode==116 || event.keyCode==122)
    {
         event.keyCode=0;
         event.returnValue = false;
    }
    //Stop BackSpace
    if (event.keyCode == 8) {
         if ((event.srcElement.type=="text" || event.srcElement.type=="password" || event.srcElement.type=="file" || event.srcElement.type == "textarea") && (!event.srcElement.readOnly) && (!event.srcElement.disabled)){
              event.returnValue=true;
         } else {
              event.returnValue=false;
         }
    }
    //Covert Enter To Tab
    if (event.keyCode == 13) {
         if (event.srcElement.type=="text" || event.srcElement.type == "password"){
              event.keyCode = 9;
         }
    }
    //Stop Alt+backSpace
    if (event.altKey && event.keyCode==37) {
         event.returnValue=false;
    }
	if((window.event.altKey)&&((window.event.keyCode==37)||(window.event.keyCode==39)))
	{
		//alert("Do not use Alt + -> or <- ");
		event.returnValue=false;
	}
	if (window.event.srcElement.tagName == "A" && window.event.shiftKey)
		window.event.returnValue = false;
	if ((window.event.altKey)&&(window.event.keyCode==115))
	{
	  window.showModelessDialog("about:blank","","dialogWidth:1px;dialogheight:1px");
	  return false;
	}
}
function returnValueFalse()
{
	   event.returnValue=false;
}
function returnFalse()
{
		return false;
}