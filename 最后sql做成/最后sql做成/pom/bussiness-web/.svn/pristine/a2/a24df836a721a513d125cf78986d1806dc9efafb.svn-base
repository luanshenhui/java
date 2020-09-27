Date.prototype.format = function(format){
  var o = {
    "M+" : this.getMonth()+1, //month
    "d+" : this.getDate(),    //day
    "h+" : this.getHours(),   //hour
    "m+" : this.getMinutes(), //minute
    "s+" : this.getSeconds(), //second
    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
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

Array.prototype.contains = function(value){
	if(typeof value == 'object'){
		for(var i=0;i<this.length;i++){
			for(var j=0;j<value.length;j++){
				if(this[i] == value[j])return true;
			}
		}
	}else{
		for(var i=0;i<this.length;i++){
			if(this[i] == value)return true;
		}
	}
	return false;
};
Array.prototype.indexOf = function(value){
	for(var i=0;i<this.length;i++){
		if(this[i] == value)return i;
	}
	return -1;
};


Array.prototype.insertAt = function(index, value ) {
	//var part1 = this.slice(0,index);
	//var part2 = this.slice(index);
	if(typeof value=='object' && typeof value[0]!='undefined'){
		for(var i=0;i<value.length;i++){
			this.splice((index+i),0,value[i]);
		}
	}else
		this.splice(index,0,value);
	return this;
};

Array.prototype.removeAt = function( index ){
	return this.splice(index,1);
};
/*
//["Array", "Boolean", "Date", "Number", "Object", "RegExp", "String", "Window", "HTMLDocument"]
Object.prototype.isType = function(typeName){
	return Object.prototype.toString.call(this) == "[object " + typeName + "]";
}*/

function toString(o){
	var r = [];
	if(typeof o =="string") return "\""+o.replace(/([\'\"\\])/g,"\\$1").replace(/(\n)/g,"\\n").replace(/(\r)/g,"\\r").replace(/(\t)/g,"\\t")+"\"";
	if(typeof o =="undefined") return "undefined";
	if(typeof o == "object"){
		if(o===null) return "null";
		else if(!o.sort){
			for(var i in o)
				r.push(i+":"+toString(o[i]));
			r="{"+r.join()+"}";
		}else{
			for(var i =0;i<o.length;i++)
				r.push(toString(o[i]));
			r="["+r.join()+"]";
		};
		return r;
	};
	return o.toString();
};

function getEvent(){
	if (document.all)
		return window.event;// 如果是ie
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent) || (typeof(arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}
//===
function getRelateDate(/*left or right*/edge,/*week or month*/period,date){
	if(!date)return '';
	var y = date.substring(0,4);
	var M = parseFloat(date.substring(4,6))-1;//月份0-11
	var d = date.substring(6,8);
	var _date = new Date(y,M,d);
	var dates = new Dates(_date);
	if(period=='mm'){
		if(edge=='r'){
			return dates.getMonthEndDate();
		}else{
			return dates.getMonthStartDate();
		}
	}else if(period=='ww'){
		if(edge=='r'){
			return dates.getWeekEndDate();
		}else{
			return dates.getWeekStartDate();
		}
	}
	return date;
};
 
//=======================================================
/*
 * 日期函数输入一个日期,返回该日期所在的月,周,季的开始结束日期.
 */
function Dates(now){
	if(typeof now =='undefined')now = new Date();
	this.nowDayOfWeek = now.getDay();         //周的第几天   
	this.nowDay = now.getDate();              //日
	this.nowMonth = now.getMonth();           //月   
	this.nowYear = now.getYear();             //年   
	this.nowYear += (this.nowYear < 2000) ? 1900 : 0;  //   

	if(this.nowDayOfWeek==0){//按国人的使用习惯周1才是第一天，周日是上周的最后一天。
		this.nowDayOfWeek=6;
		this.nowDay = this.nowDay-1; 
	}
}
//格式化日期：yyyy-MM-dd
Dates.prototype.formatDate=function(date){
	var myyear=date.getFullYear();   
    var mymonth=date.getMonth()+1;   
    var myweekday=date.getDate();    
    if(mymonth<10){   
        mymonth="0"+mymonth;   
    }    
    if(myweekday<10){   
        myweekday="0"+myweekday;   
    }   
    return (myyear+"-"+mymonth+"-"+myweekday);    
};
//获得某月的天数   
Dates.prototype.getMonthDays=function(myMonth){
	var nowYear = this.nowYear;
    var monthStartDate=new Date(nowYear,myMonth,1);    
    var monthEndDate=new Date(nowYear,myMonth+1,1);    
    var days=(monthEndDate-monthStartDate)/(1000*60*60*24);    
    return days;    
};
//获得本季度的开始月份   
Dates.prototype.getQuarterStartMonth = function(){   
    var quarterStartMonth = 0;
    var nowMonth = this.nowMonth;   
    if(nowMonth<3){   
       quarterStartMonth = 0;   
    }   
    if(2<nowMonth && nowMonth<6){   
       quarterStartMonth = 3;   
    }   
    if(5<nowMonth && nowMonth<9){   
       quarterStartMonth = 6;   
    }   
    if(nowMonth>8){   
       quarterStartMonth = 9;   
    }   
    return quarterStartMonth;   
}   ;
//获得本周的开始日期   
Dates.prototype.getWeekStartDate=function(){
    var weekStartDate=new Date(this.nowYear,this.nowMonth,this.nowDay-this.nowDayOfWeek+1);    
    return this.formatDate(weekStartDate);   
};
//获得本周的结束日期   
Dates.prototype.getWeekEndDate=function(){
    var weekEndDate=new Date(this.nowYear,this.nowMonth,this.nowDay+(6-this.nowDayOfWeek)+1);    
    return this.formatDate(weekEndDate);   
};    
//获得本月的开始日期   
Dates.prototype.getMonthStartDate=function(){
    var monthStartDate = new Date(this.nowYear,this.nowMonth, 1);    
    return this.formatDate(monthStartDate);   
};   
//获得本月的结束日期   
Dates.prototype.getMonthEndDate=function (){
    var monthEndDate = new Date(this.nowYear,this.nowMonth,this.getMonthDays(this.nowMonth));    
    return this.formatDate(monthEndDate);   
};   
//获得本季度的开始日期   
Dates.prototype.getQuarterStartDate=function(){
    var quarterStartDate = new Date(this.nowYear,this.getQuarterStartMonth(),1);    
    return this.formatDate(quarterStartDate);   
};   
//或的本季度的结束日期   
Dates.prototype.getQuarterEndDate=function(){
    var quarterEndMonth = this.getQuarterStartMonth() + 2;   
    var quarterStartDate = new Date(this.nowYear,this.quarterEndMonth,this.getMonthDays(quarterEndMonth));    
    return this.formatDate(quarterStartDate);
};  

function loadCss(file){
    var cssTag = document.getElementById('loadCss');
    var head = document.getElementsByTagName('head').item(0);
    if(cssTag) head.removeChild(cssTag);
    css = document.createElement('link');
    css.href = file;
    css.rel = 'stylesheet';
    css.type = 'text/css';
    css.id = 'loadCss';
    head.appendChild(css);
};