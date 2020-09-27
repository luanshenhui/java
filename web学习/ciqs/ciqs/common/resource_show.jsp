<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9;IE=8;IE=7;IE=EDGE;" />
<!--css-->
<link type="text/css" rel="stylesheet" href="${ctx}/static/dec/styles/dpn.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/static/show/css/style.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/static/showS/css/style3.css" />
<!--js-->
<script type="text/javascript" src="${ctx}/static/dec/styles/dpn.js"></script>
<!-- <script type="text/javascript" src="${ctx}/static/autocomplete/autocomplete.js"></script> -->

<script type="text/javascript">
	console.log('12312312312')
     //Ã¦ÂÂÃ¥Â­ÂÃ¨Â¿ÂÃ¦ÂÂ¥Ã©Â¡ÂµÃ©ÂÂ¢Ã¨Â·Â³Ã¨Â½Â¬Ã¦ÂÂ¹Ã¦Â³Â
     function jumpPage(targetUrl){
    	this.location.href = targetUrl;
    }
    
    function openNewPage(targetUrl){
    	window.open(targetUrl);
    }
	
     //Ã¦ÂÂ¥Ã¦ÂÂÃ¦ÂÂ§Ã¤Â»Â¶Ã¥ÂÂÃ¥Â§ÂÃ¥ÂÂÃ¦ÂÂ¹Ã¦Â³Â
    jQuery(function(){
    	jQuery("input.datepick").attr("readonly", "readonly");
    	if(jQuery("input.datepick").length > 0){
	        jQuery("input.datepick").datePicker({
	            clickInput : true,
	            createButton : false,
	            startDate : "2000-01-01"
	        });
        }
        
        //Ã¦ÂÂ©Ã¥Â±ÂÃ¦ÂÂ¥Ã¦ÂÂÃ¦Â Â¼Ã¥Â¼ÂÃ¥ÂÂÃ¦ÂÂ¹Ã¦Â³Â
        Date.prototype.format = function(fmt){
			var o = {
				"M+" : this.getMonth()+1,
				"d+" : this.getDate(),
				"h+" : this.getHours(),
				"m+" : this.getMinutes(),
				"s+" : this.getSeconds()
			};
			if(/(y+)/.test(fmt)){
				fmt = fmt.replace(RegExp.$1, this.getFullYear() + "").substr(4 - RegExp.$1.length);
			}
			for(var k in o){
				if(new RegExp("(" + k + ")").test(fmt)){
					fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
				}
			}
			return fmt;
		};
    });
	
     //selectÃ¦ÂÂ§Ã¤Â»Â¶Ã©Â»ÂÃ¨Â®Â¤Ã©ÂÂÃ¤Â¸Â­Ã©Â¡Â¹Ã¦ÂÂ¹Ã¦Â³Â
	function isSelected(selectId,selectValue){
		var count = $("#"+selectId+" option").length;
		for(var i=0;i<count;i++){
			if($("#"+selectId+" option")[i].value==selectValue){
				$("#"+selectId+" option")[i].selected = true;
				break;
			}
		}
	}
	//Ã¥Â¤ÂÃ©ÂÂÃ¦Â¡ÂÃ©ÂÂÃ¤Â¸Â­
	function handleCheckAll(checkAll,checkBoxName){
		var checkAllBoxs=$("input[name="+checkAll+"]:checkbox");
		for (var i=0;i<checkAllBoxs.length ;i++){
			checkAllBoxs[i].checked=checkAll.checked;
		}
		var allCheckBoxs=$("input[name="+checkBoxName+"]:checkbox");
		for (var i=0;i<allCheckBoxs.length ;i++){
			if(allCheckBoxs[i].type=="checkbox"){ 
				allCheckBoxs[i].checked=checkAll.checked;
			}
		}
	}
	
	//Ã¦ÂÂ¿Ã¦ÂÂ¢
	function replaceAll(str, rgExp, replaceText){
		for(var i = 0; true; i++){
			if(str.indexOf(rgExp) != -1){
				str = str.replace(rgExp, replaceText);
			}else{
				break;
			}
		}
		return str;
	}
	//Ã¥ÂÂ Ã©ÂÂ¤
	function delAdd(add){
		$(add).parent().parent().remove();  
		sumNum();   
	}
	$.validator.addMethod("lettersonly", function(value,element){
		return this.optional(element)||/^[a-z ]+$/i.test(value);
	},"Ã¨ÂÂ±Ã¦ÂÂÃ¥Â­ÂÃ¦Â¯Â");
	$.validator.addMethod("lettersonly1", function(value,element){
		return this.optional(element)||/^[a-z0-9' ]+$/i.test(value);
	},"Ã¨ÂÂ±Ã¦ÂÂÃ¥Â­ÂÃ¦Â¯ÂÃ¤Â¸ÂÃ¦ÂÂ°Ã¥Â­ÂÃ¦ÂÂÃ§Â©ÂºÃ¦Â Â¼");
	$.validator.addMethod("integer", function(value,element){
		return this.optional(element)||/^[0-9]\d*$/i.test(value);
	},"Ã¨Â¯Â·Ã¨Â¾ÂÃ¥ÂÂ¥Ã¦Â­Â£Ã¦ÂÂ´Ã¦ÂÂ°");
	
	$.validator.addMethod("member8", function(value,element,params){
		var opts = {noZero:true,integer:6,fraction:'2'};//Ã¤Â¸ÂÃ¥ÂÂÃ¨Â®Â¸Ã¤Â¸Âº0/Ã¦ÂÂ´Ã¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°/Ã¥Â°ÂÃ¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°
		if(params && $.type(params) === 'object'){
			$.extend(opts,params);
		}
		var pattern = '^\\d{1,'+opts.integer+'}(?:\\.\\d{1,'+opts.fraction+'})?$';
		var money = new RegExp(pattern);
		var result = this.optional(element)||money.test(value);
		if(result&&opts.noZeero){
			var zeroReg = new RegExp('^0+(\\.0+)?$');
			var result2 = zeroReg.test(value);
			if(result2){
				result = false;
			}
		}
		return result;
	},"Ã¨Â¯Â·Ã¨Â¾ÂÃ¥ÂÂ¥Ã¦ÂÂÃ¥Â¤Â8Ã¤Â½ÂÃ¦ÂÂ°Ã¥Â­ÂÃ¯Â¼ÂÃ¥ÂÂÃ¥ÂÂ«Ã¤Â¸Â¤Ã¤Â½ÂÃ¥Â°ÂÃ¦ÂÂ°");
	$.validator.addMethod("member9", function(value,element,params){
		var opts = {noZero:true,integer:7,fraction:'2'};//Ã¤Â¸ÂÃ¥ÂÂÃ¨Â®Â¸Ã¤Â¸Âº0/Ã¦ÂÂ´Ã¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°/Ã¥Â°ÂÃ¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°
		if(params && $.type(params) === 'object'){
			$.extend(opts,params);
		}
		var pattern = '^\\d{1,'+opts.integer+'}(?:\\.\\d{1,'+opts.fraction+'})?$';
		var money = new RegExp(pattern);
		var result = this.optional(element)||money.test(value);
		if(result&&opts.noZeero){
			var zeroReg = new RegExp('^0+(\\.0+)?$');
			var result2 = zeroReg.test(value);
			if(result2){
				result = false;
			}
		}
		return result;
	},"Ã¨Â¯Â·Ã¨Â¾ÂÃ¥ÂÂ¥Ã¦ÂÂÃ¥Â¤Â9Ã¤Â½ÂÃ¦ÂÂ°Ã¥Â­ÂÃ¯Â¼ÂÃ¥ÂÂÃ¥ÂÂ«Ã¤Â¸Â¤Ã¤Â½ÂÃ¥Â°ÂÃ¦ÂÂ°");
	$.validator.addMethod("member5", function(value,element,params){
		var opts = {noZero:true,integer:3,fraction:'2'};//Ã¤Â¸ÂÃ¥ÂÂÃ¨Â®Â¸Ã¤Â¸Âº0/Ã¦ÂÂ´Ã¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°/Ã¥Â°ÂÃ¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°
		if(params && $.type(params) === 'object'){
			$.extend(opts,params);
		}
		var pattern = '^\\d{1,'+opts.integer+'}(?:\\.\\d{1,'+opts.fraction+'})?$';
		var money = new RegExp(pattern);
		var result = this.optional(element)||money.test(value);
		if(result&&opts.noZeero){
			var zeroReg = new RegExp('^0+(\\.0+)?$');
			var result2 = zeroReg.test(value);
			if(result2){
				result = false;
			}
		}
		return result;
	},"Ã¨Â¯Â·Ã¨Â¾ÂÃ¥ÂÂ¥Ã¦ÂÂÃ¥Â¤Â5Ã¤Â½ÂÃ¦ÂÂ°Ã¥Â­ÂÃ¯Â¼ÂÃ¥ÂÂÃ¥ÂÂ«Ã¤Â¸Â¤Ã¤Â½ÂÃ¥Â°ÂÃ¦ÂÂ°");
	$.validator.addMethod("member10", function(value,element,params){
		var opts = {noZero:true,integer:8,fraction:'2'};//Ã¤Â¸ÂÃ¥ÂÂÃ¨Â®Â¸Ã¤Â¸Âº0/Ã¦ÂÂ´Ã¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°/Ã¥Â°ÂÃ¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°
		if(params && $.type(params) === 'object'){
			$.extend(opts,params);
		}
		var pattern = '^\\d{1,'+opts.integer+'}(?:\\.\\d{1,'+opts.fraction+'})?$';
		var money = new RegExp(pattern);
		var result = this.optional(element)||money.test(value);
		if(result&&opts.noZeero){
			var zeroReg = new RegExp('^0+(\\.0+)?$');
			var result2 = zeroReg.test(value);
			if(result2){
				result = false;
			}
		}
		return result;
	},"Ã¨Â¯Â·Ã¨Â¾ÂÃ¥ÂÂ¥Ã¦ÂÂÃ¥Â¤Â10Ã¤Â½ÂÃ¦ÂÂ°Ã¥Â­ÂÃ¯Â¼ÂÃ¥ÂÂÃ¥ÂÂ«Ã¤Â¸Â¤Ã¤Â½ÂÃ¥Â°ÂÃ¦ÂÂ°");
	$.validator.addMethod("member51", function(value,element,params){
		var opts = {noZero:true,integer:8,fraction:'1'};//Ã¤Â¸ÂÃ¥ÂÂÃ¨Â®Â¸Ã¤Â¸Âº0/Ã¦ÂÂ´Ã¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°/Ã¥Â°ÂÃ¦ÂÂ°Ã¤Â½ÂÃ¦ÂÂ°
		if(params && $.type(params) === 'object'){
			$.extend(opts,params);
		}
		var pattern = '^\\d{1,'+opts.integer+'}(?:\\.\\d{1,'+opts.fraction+'})?$';
		var money = new RegExp(pattern);
		var result = this.optional(element)||money.test(value);
		if(result&&opts.noZeero){
			var zeroReg = new RegExp('^0+(\\.0+)?$');
			var result2 = zeroReg.test(value);
			if(result2){
				result = false;
			}
		}
		return result;
	},"Ã¨Â¯Â·Ã¨Â¾ÂÃ¥ÂÂ¥Ã¦ÂÂÃ¥Â¤Â5Ã¤Â½ÂÃ¦ÂÂ°Ã¥Â­ÂÃ¯Â¼ÂÃ¥ÂÂÃ¥ÂÂ«Ã¤Â¸ÂÃ¤Â½ÂÃ¥Â°ÂÃ¦ÂÂ°");
	
	
	function viweConta(path){
		paths = "http://localhost:8080/ciqs/showVideo?imgPath="+path;
		
		var objectView;
		if(getSysKind){
			objectView = "<OBJECT ID=\"video2\" CLASSID=\"clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA\" HEIGHT=\"480\" WIDTH=\"640\">"
						  +"<param name=\"_ExtentX\" value=\"9313\">"
						  +"<param name=\"_ExtentY\" value=\"7620\">"
						  +"<param name=\"AUTOSTART\" value=\"0\">"
						  +"<param name=\"SHUFFLE\" value=\"0\">"
						  +"<param name=\"PREFETCH\" value=\"0\">"
						  +"<param name=\"NOLABELS\" value=\"0\">"
						  +"<param name=\"CONTROLS\" value=\"ImageWindow\">"
						  +"<param name=\"CONSOLE\" value=\"Clip1\">"
						  +"<param name=\"LOOP\" value=\"0\">"
						  +"<param name=\"NUMLOOP\" value=\"0\">"
						  +"<param name=\"CENTER\" value=\"0\">"
						  +"<param name=\"MAINTAINASPECT\" value=\"0\">"
						  +"<param name=\"defaultFrame\" value=\"0\">"
						  +"<param name=\"BACKGROUNDCOLOR\" value=\"#000000\">"
						  +"	<embed SRC=\""+paths+"\" type=\"application/x-mplayer2\" HEIGHT=\"480\" WIDTH=\"640\" AUTOSTART=\"true\">"
						  +"	</embed>"
						  +"</OBJECT>";
			$("#CuPlayer").empty();
			$("#CuPlayer").append(objectView);
			$("#CuPlayerMiniV").show();
		}else{
			objectView = "<object classid=\"clsid:22d6f312-b0f6-11d0-94ab-0080c74c7e95\" width=\"600\" height=\"450\" id=\"video2\">"
							+"<embed width=\"600\" height=\"450\">" 
							+"</embed>"
							+"</object>"
							+"<br/><span>è¥è§é¢æ æ³æ­£å¸¸æ­æ¾ï¼å¯è½æ¯ç±äºæ¨çè®¡ç®æºæ²¡æç¸å³çè§£ç åºæè´ï¼è¯·<a href=\"downloadServlet?fileName=\/message\/ciq\/WMZPureCodec20101029_Dio.exe\" style=\"color:#0000FF\">ä¸è½½å®ç¾è§£ç </a>è½¯ä»¶å¹¶å®è£</span>";
			$("#videoFrame").empty();
			$("#videoFrame").append(objectView);
			if(fileType=='2' && !getSysKind()){
				var v = document.getElementById("video2");
				v.Filename = paths;
			}
			$("#CuPlayer").empty();
			$("#CuPlayer").append(objectView);
			$("#CuPlayerMiniV").show();
		}
		
	}
	
	function getSysKind(){
		var sUserAgent = navigator.userAgent;
		var isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows"); // ç¡®ä¿ä¸ºwindowsç³»ç»
		if(isWin) {
			var isWin7=sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1; //win7
			if(isWin7){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	/**历时计算方法 
	 * startIndex：开始环节索引
	 * endIndex:结束环节索引
	 * idName: 获取命名规则
	 * return: x天x小时x分钟
	 */	
	function ciqFormatTime(startIndex,endIndex,idName){
		if(!endIndex){
			endIndex = startIndex
			startIndex = 1;
		}
		if(!idName){
			idName = "time_";
		}
		var startText = '';
		for(var i=startIndex;i<endIndex;i++){
			var start = $("#" + idName + i).text();
			if(start != '' && start != null){
				startText = start;
				break;
			}
		}
		var endText = '';
		for(var i=endIndex;i>startIndex;i--){
			var end = $("#" + idName  + i).text();
			if(end != '' && start != null){
				endText = end;
				break;
			}
		}
		if(startText != '' && endText != ''){
			var startDate = new Date(startText); 
			var endDate = new Date(endText);
			var times = 0;
			times = endDate.getTime() - startDate.getTime();
			var point = '+';
			if(times < 0){
				point = '-'				
			}
			times = Math.abs(times);
			var day = Math.floor(times / 86400000);
			times = times - 86400000 * day;
			var hour = Math.floor(times / 3600000);
			times = times - 3600000 * hour;
			var min = Math.floor(times / 60000);
			if(day > 0 && day < 10){
				day = '0'+day;
			}
			if(hour > 0 && hour < 10){
				hour = '0'+hour;
			}
			if(min > 0 && min < 10){
				min = '0'+min;
			}
			var result = day + '天' + hour + '小时' + min + '分钟';
			if(point == '-'){
				result = point + result;
			}
			return result;
		}else{
			return '';
		}
	}
</script>

	