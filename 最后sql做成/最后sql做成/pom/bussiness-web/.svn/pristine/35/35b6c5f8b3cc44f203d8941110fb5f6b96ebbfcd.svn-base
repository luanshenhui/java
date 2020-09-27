var Cookie = {
    /**
     * 设置Cookie值
     * @method  setValue
     * @param  {[type]} name       [description]
     * @param  {[type]} value      [description]
     * @param  {[type]} options    [description]
     * @return {[type]}            [description]
     */
    setValue : function (name, value, options) {
        if (typeof value != 'undefined') {
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
                expires = '; expires=' + date.toUTCString();
            }
            var path = options.path ? '; path=' + (options.path) : '';
            var domain = options.domain ? '; domain=' + (options.domain) : '';
            var secure = options.secure ? '; secure' : '';
            document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
        }
    },
    getValue : function(name){
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

//================================================Date====================================================

Date.prototype.format = function(formatStr){
    var str = formatStr;
    var Week = ['日','一','二','三','四','五','六'];

    str=str.replace(/yyyy|YYYY/,this.getFullYear());
    str=str.replace(/yy|YY/,(this.getYear() % 100)>9?(this.getYear() % 100).toString():'0' + (this.getYear() % 100));

    str=str.replace(/MM/,(this.getMonth()+1)>9?(this.getMonth()+1).toString():'0' + (this.getMonth()+1));
    str=str.replace(/M/g,(this.getMonth()+1));

    str=str.replace(/w|W/g,Week[this.getDay()]);

    str=str.replace(/dd|DD/,this.getDate()>9?this.getDate().toString():'0' + this.getDate());
    str=str.replace(/d|D/g,this.getDate());

    str=str.replace(/hh|HH/,this.getHours()>9?this.getHours().toString():'0' + this.getHours());
    str=str.replace(/h|H/g,this.getHours());
    str=str.replace(/mm/,this.getMinutes()>9?this.getMinutes().toString():'0' + this.getMinutes());
    str=str.replace(/m/g,this.getMinutes());

    str=str.replace(/ss|SS/,this.getSeconds()>9?this.getSeconds().toString():'0' + this.getSeconds());
    str=str.replace(/s|S/g,this.getSeconds());

    return str;
};

Date.prototype.diff = function(interval, objDate) {
  //若参数不足或 objDate 不是日期类型則回传 undefined
  if (arguments.length < 2 || objDate.constructor != Date) { return undefined; }
  switch (interval) {
   //计算秒差
   case 's': return parseInt((objDate - this) / 1000);
   //计算分差
   case 'n': return parseInt((objDate - this) / 60000);
   //计算時差
   case 'h': return parseInt((objDate - this) / 3600000);
   //计算日差
   case 'd': return parseInt((objDate - this) / 86400000);
   //计算周差
   case 'w': return parseInt((objDate - this) / (86400000 * 7));
   //计算月差
   case 'm': return (objDate.getMonth() + 1) + ((objDate.getFullYear() - this.getFullYear()) * 12) - (this.getMonth() + 1);
   //计算年差
   case 'y': return objDate.getFullYear() - this.getFullYear();
   //输入有误
   default: return undefined;
  }
};

//================================================String====================================================

String.prototype.ltrim = function(){
    var s = this;
    s = s.replace(/^\s*/g, '');
    return s;
};

String.prototype.rtrim = function(){
    var s = this;
    s = s.replace(/\s*$/g, '');
    return s;
};

String.prototype.trim = function(){
    return this.ltrim().rtrim();
};

// 合并多个空白为一个空白
String.prototype.mergeBlank = function () {
    var regEx = /\s+/g;
    return this.replace(regEx, ' ');
};

/**
 * 扩展基础类
 * 得到字符串的长度，包括中文和英文
 **/
String.prototype.charlen = function() {
    var arr = this.match(/[^\x00-\xff]/ig);
    return this.length + (arr == null ? 0 : arr.length);
};

/**
 * 扩展基础类
 * 格式化字符串${0} -> 参考printf %s
 **/
String.prototype.format = function() {
    var args = arguments;
    return this.replace(/\$\{(\d+)\}/g,
        function(m, i){
            return args[i];
        });
};

/**
 * 扩展基础类
 * 字符串包含字符串判断
 **/
String.prototype.contains = function(sub) {
    return this.indexOf(sub) != -1;
};

/**
 * 扩展基础类
 * 字符串比较大小
 **/
String.prototype.compare = function(b) {
    if(!b)
        return -1;

    if(this.length != b.length)
        return this.length - b.length;

    var i = 0;
    for (; i < this.length; i++){
        var val = this.charCodeAt(i) - b.charCodeAt(i);
        if(val != 0)
            return val;
    }

    return 0;
};

/**
 * 扩展基础类
 * 替换字符
 **/
String.prototype.replaceLen = function(start, len, replaced) {
    if(!len)
        return this;

    if(start >= this.length)
        return this;

    var returnSeg = '';
    var returnSeg2 = '';
    var i = 0;
    for (; i < this.length; i++){
        var c = this.charAt(i);
        if(i < start)
            returnSeg += c;

        if(i >= start + len)
            returnSeg2 += c;
    }

    return returnSeg + replaced + returnSeg2;
};

/**
 * 扩展基础类
 * 替换字符，这个在替换填入比较有用，比如***天***小时 替换为 <input />天<input />小时
 **/
String.prototype.replaceChar = function(target, replaced, start) {
    if(!target)
        return this;

    if(!start)
        start = 0;

    var returnVal = this.substring(0, start);
    var index = 0;
    for (var i = start; i < this.length; i++) {
        var c = this.charAt(i);
        target = typeof target == 'function' ? target.call(this, index) : target;
        if (c == target) {
            returnVal += typeof replaced == 'function' ? replaced.call(this, index) : replaced;
            while (i < this.length - 1 && this.charAt(i + 1) == c) {
                i++;
            }
            index++;
        }else{
            returnVal += c;
        }
    }

    return returnVal;
};

//================================================Array====================================================

/**
 * 扩展基础类
 * 克隆复制（简单copy而已）
 **/
Array.prototype.clone = function(){
    var arr = [];
    var i = 0;
    for(; i < this.length; i++){
        switch(typeof this[i]){
            case 'object':
                var obj = {};
                for(key in this[i])
                    obj[key] = this[i][key];
                arr.push(obj);
                break;
            default:
                arr.push(this[i]);
                break;
        }
    }
    return arr;
};

/**
 * 扩展基础类
 * 清空
 **/
Array.prototype.clear = function() {
    this.splice(0, this.length);
};

/**
 * 扩展基础类
 * 数组包含元素
 **/
Array.prototype.contains = function(el) {
    var i;
    for(i = 0; i < this.length; i++) {
        if(this[i] == el)
            return true;
    }
    return false;
};

/**
 * 扩展基础类
 * 数组添加数组
 **/
Array.prototype.merge = function(arr) {
    if(arr){
        var i;
        for(i = 0; i < arr.length; i++) {
            this.push(arr[i]);
        }
    }
};

/**
 * 扩展基础类
 * 根据值和属性获取到数组的对象下标
 **/
Array.prototype.indexOf = function(val, field){
    var i = 0;
    for(; i < this.length; i++){
        if(this[i] && (field ? this[i][field] == val : this[i] == val)){
            return i;
        }
    }
    return -1;
};

/**
 * 扩展基础类
 * 最后一个下标
 **/
Array.prototype.lastIndexOf = function(val, field){
    var i = 0;
    var max = -1;
    for(; i < this.length; i++){
        if(this[i] && (field ? this[i][field] == val : this[i] == val)){
            max = i;
        }
    }
    return max;
};

/**
 * 扩展基础类
 * 数组唯一
 **/
Array.prototype.unique = function(field){
    var arr = [];

    var i = 0;
    for(; i < this.length; i++){
        var val = field ? this[i][field] : this[i];
        var index = this.lastIndexOf(val, field);
        if(index == i)
            arr.push(this[i]);
    }

    return arr;
};

/**
 * 扩展基础类
 * 数组最大值
 **/
Array.prototype.max = function(field){
    var result = -1;

    var i = 0;
    for(; i < this.length; i++){
        var val = field ? this[i][field] : this[i];
        if(val > result)
            result = val;
    }

    return result;
};

/**
 * 扩展基础类
 * 数组最小值
 **/
Array.prototype.min = function(field){
    var result = -1;

    var i = 0;
    for(; i < this.length; i++){
        var val = field ? this[i][field] : this[i];
        if(val < result)
            result = val;
    }

    return result;
};