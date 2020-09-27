<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9;IE=8;IE=7;IE=EDGE;" />
<!--css-->
<link type="text/css" rel="stylesheet" href="${ctx}/static/dec/styles/dpn.css" />
<link type="text/css" rel="stylesheet" href="${ctx}/static/dec/styles/port.css" />
<link rel="stylesheet" type="text/css" media="all" href="${ctx}/static/autocomplete/autocomplete.css" />
<!--js-->
<script type="text/javascript" src="${ctx}/static/dec/styles/dpn.js"></script>

<script type="text/javascript">
     //文字连接页面跳转方法
     function jumpPage(targetUrl){
    	this.location.href = targetUrl;
    }
	
     //日期控件初始化方法
    jQuery(function(){
    	jQuery("div.dpn-content input.datepick").attr("readonly", "readonly");
        jQuery("div.dpn-content input.datepick").datePicker({
            clickInput : true,
            createButton : false,
            startDate : "2000-01-01"
        });
    });
	
     //select控件默认选中项方法
	function isSelected(selectId,selectValue){
		var count = $("#"+selectId+" option").length;
		for(var i=0;i<count;i++){
			if($("#"+selectId+" option")[i].value==selectValue){
				$("#"+selectId+" option")[i].selected = true;
				break;
			}
		}
	}
	//复选框选中
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
	
	//替换
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
	//删除
	function delAdd(add){
		$(add).parent().parent().remove();  
		sumNum();   
	}
	$.validator.addMethod("lettersonly", function(value,element){
		return this.optional(element)||/^[a-z ]+$/i.test(value);
	},"英文字母");
	$.validator.addMethod("lettersonly1", function(value,element){
		return this.optional(element)||/^[a-z0-9' ]+$/i.test(value);
	},"英文字母与数字或空格");
	$.validator.addMethod("integer", function(value,element){
		return this.optional(element)||/^[0-9]\d*$/i.test(value);
	},"请输入正整数");
	
	$.validator.addMethod("member8", function(value,element,params){
		var opts = {noZero:true,integer:6,fraction:'2'};//不允许为0/整数位数/小数位数
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
	},"请输入最多8位数字，包含两位小数");
	$.validator.addMethod("member9", function(value,element,params){
		var opts = {noZero:true,integer:7,fraction:'2'};//不允许为0/整数位数/小数位数
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
	},"请输入最多9位数字，包含两位小数");
	$.validator.addMethod("member5", function(value,element,params){
		var opts = {noZero:true,integer:3,fraction:'2'};//不允许为0/整数位数/小数位数
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
	},"请输入最多5位数字，包含两位小数");
	$.validator.addMethod("member10", function(value,element,params){
		var opts = {noZero:true,integer:8,fraction:'2'};//不允许为0/整数位数/小数位数
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
	},"请输入最多10位数字，包含两位小数");
	$.validator.addMethod("member51", function(value,element,params){
		var opts = {noZero:true,integer:8,fraction:'1'};//不允许为0/整数位数/小数位数
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
	},"请输入最多5位数字，包含一位小数");
</script>
	