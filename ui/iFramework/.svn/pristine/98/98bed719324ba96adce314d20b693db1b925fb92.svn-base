/* JS程序简要描述信息
 **************************************************************
 * 程序名	: ecside.validate.js
 * 建立日期: 2010-12-17
 * 模块		: 公共方法,ECside输入框校验
 * 描述		: 
 * 备注		: 
 * ------------------------------------------------------------
 * 修改历史
 * 序号	日期		         修改人		修改原因
 * 1  2013/08/29   WangXY		PDM2Code生成的代码，做表格edit功能需要
 * 2
 **************************************************************
 */

//是否是debug模式
ECSideUtil.setDebug=function(debug){
	ECSideUtil.validator.GLOBALS.isDebug=debug;
};

//是否是debug模式
ECSideUtil.isDebug=function(){
	return ECSideUtil.validator.GLOBALS.isDebug;
};

//判断是否需要验证
ECSideUtil.isValidate=function(){
	return ECSideUtil.validator.GLOBALS.isValidate;
};

//设置是否需要验证
ECSideUtil.setValidate=function(validate){
	ECSideUtil.validator.GLOBALS.isValidate=validate;
};

//日期输入框失去焦点方法
ECSideUtil.updateEditDateCellEx=function(cellEditObj){
	if($dp.dd.style.display=="none"){
		ECSideUtil.updateEditCellEx(cellEditObj);
	}
	document.body.onclick=function(){
		if(cellEditObj==null||cellEditObj.parentNode==null){
			return;
		}
		if($dp.dd.style.display=="none"){
			ECSideUtil.updateEditCellEx(cellEditObj);
		}
	};
};

//扩展ECSide内部文本框失去焦点事件，验证输入是否正确
ECSideUtil.updateEditCellEx=function(cellEditObj,editType){
	if (cellEditObj.getAttribute("filterfield")=="true"){
		return false;
	}
	if(ECSideUtil.isValidate()){
		try{
			var validator=cellEditObj.getAttribute("validator");
			if(validator!=undefined){
				var flag=ECSideUtil.validator.element(cellEditObj);
				if(!flag){
					return false;
				}
			}
		}catch(e){
			if(ECSideUtil.isDebug()){
				alert(e.message);
			}
		}
	}
	var cellObj=cellEditObj.parentNode;
	var flag=false;
	var old_cellvalue;
	var new_cellvalue;
	
	var editType=cellEditObj.tagName.toLowerCase();
	old_cellvalue=cellObj.getAttribute("oldCellValue");
	if(old_cellvalue==null){
		old_cellvalue=cellObj.getAttribute("cellValue");;
		cellObj.setAttribute("oldCellValue",old_cellvalue);
	}
	ECSideUtil.updateCellContent(cellObj,cellEditObj);
	new_cellvalue=cellObj.getAttribute("cellValue");
	
	if(old_cellvalue!=new_cellvalue){
		flag=true;
	}
	if(flag==true){
		//Fri Aug 30 07:28:05 2013 wxy 新new的row，坚决不能改成edited状态哦
		if (!ECSideUtil.hasClass(cellObj.parentNode,"add")){
			cellObj.setAttribute("edited","true");
			cellObj.parentNode.setAttribute("edited","true");
		}
	}
	cellObj.setAttribute("editing","false");
	ECSideUtil.addClass(cellObj, "editedCell");
};

//设置全局的ECSideID
ECSideUtil.setGlobalFormId=function(formId){
	ECSideUtil.validator.GLOBALS.FORMID=formId;
};

//ECSide验证对象
ECSideUtil.validator={
	//设置ECSide表格列标题
	setCellTitles:function(titles){
	ECSideUtil.validator.cellTitles=titles;
	},
	addMethod:function(validateName,message,fn){
		ECSideUtil.validator.METHODS[validateName]={
			fn:fn,
			message:message
		};
	},
	addMethods:function(params){
		for(var key in params){
			ECSideUtil.validator.METHODS[key]={
				fn:params[key].fn,
				message:params[key].message
			};
		}
	},
	//校验ECSide输入
	valid:function(formid){
		if(!ECSideUtil.isValidate()){
			return true;
		}
		try{
			var ecsideObj =ECSideUtil.getGridObj(formid);
			var form=ecsideObj.ECForm;
			var str="";
			var formInput=form.getElementsByTagName("input");
			for(var i=0,length=formInput.length;i<length;i++){
				var validator=formInput[i].getAttribute("validator");
				if(validator!=undefined){
					var flag=ECSideUtil.validator.element(formInput[i]);
					if(!flag){
						return false;
					}
				}
			}
			formInput=form.getElementsByTagName("select");
			for(var i=0,length=formInput.length;i<length;i++){
				var validator=formInput[i].getAttribute("validator");
				if(validator!=undefined){
					var validator=formInput[i].getAttribute("validator");
					if(validator!=undefined){
						var flag=ECSideUtil.validator.element(formInput[i]);
						if(!flag){
							return false;
						}
					}
				}
			}
		}catch(e){
			if(ECSideUtil.isDebug()){
				alert(e.message);
			}
			return true;
		}
		return true;
	},
	setMessage:function(validateName,message){
		var method= ECSideUtil.validator.METHODS[validateName];
		if(method!=null){
			method["message"]=message;
		}
	},
	getCellTitle:function(cellName){
		return ECSideUtil.validator.cellTitles[cellName];
	},
	getMethod:function(validateName){
		return ECSideUtil.validator.METHODS[validateName];
	},
	trim:function(text){
		return (text || "").replace(ECSideUtil.validator.DEFAULTS.TRIMPATTERN, "" );
	},
	element:function(element){
		try{
			var validators=element.getAttribute("validator");
			var formId=element.getAttribute("formId");
			if(formId==null){
				formId=ECSideUtil.validator.GLOBALS.FORMID;
			}
			if(formId==null){
				formId=ECSideUtil.validator.DEFAULTS.FORMID;
			}
			var arr=validators.split(",");
			var params=element.getAttribute("parameter");
			params=eval("("+params+")");
			var l=arr.length;
			for(var i=0;i<l;i++){
				var method=ECSideUtil.validator.getMethod(arr[i]);
				var flag=eval(method.fn)(element,params[arr[i]]);
				if(!flag){
					ECSideUtil.validator.setInputError(element);
					var message="";
					if(params[arr[i]].msg==null){
						var cellName=ECSideUtil.getColumnName(element.parentNode,formId);
						var cellTitle=ECSideUtil.validator.getCellTitle(cellName);
						message=ECSideUtil.validator.format(cellTitle+method.message,params[arr[i]]);
					}else{
						message=params[arr[i]].msg;
					}
					alert(message);
					return false;
				}
			}
		}catch(e){
			if(ECSideUtil.isDebug()){
				alert(e.message);
			}
		}
		ECSideUtil.validator.setInputRight(element);
		return true;
	},
	setInputError:function (obj){
		obj.style.borderColor="red";
		obj.style.backgroundColor="#FAF8DC";
	},
	setInputRight:function(obj){
		obj.style.borderColor="#cc9966";
		obj.style.backgroundColor="white";
	},
	DEFAULTS:{
		FORMID:"ec",
		ESCAPED_CODE_POINTS:['\'','\^','\#','\$','%','\&','\|','\:','\[','\]','\{','\}','\=','\"','\>','\<','','?'],
		PATTERN :/^(?!.*?[\'\^\#\$%\&\|\:\[\]\{\}\=\"\>\<?]).*$/,
		TRIMPATTERN : /^(\s|\u00A0)+|(\s|\u00A0)+$/g
	},
	//全局数据
	GLOBALS:{
		FORMID:null,
		isDebug:false,
		isValidate:true
	},
	cellTitles:{},
	METHODS:{
	}
};

//格式化验证信息
ECSideUtil.validator.format=function(source,params){
	if ( arguments.length == 1 ) 
		return source;
	if ( arguments.length > 2 && params.constructor != Array  ) {
		return source;
	}
	if ( params.constructor != Array ) {
		params = [ params ];
	}
	for(var i=0,l=params.length;i<l;i++){
		source = source.replace(new RegExp("\\{" + i + "\\}", "g"), params[i]);
	}
	return source;
};

if(typeof($jQuery)=="undefined"){
	if($){
		$jQuery=$;
	}else{
		$jQuery={};
	}
}
//验证正浮点数
ECSideUtil.validator.validateFloat=function(element,params){
	if(params&&(typeof params)=="array"){
		if(ECSideUtil.isDebug()){
			alert("参数必须为数组！");
		}
		return true;
	}
	var pattern=/^[\.\d]+$/;
	if(!element.val){
		element=$jQuery(element);
	}
	var value=ECSideUtil.validator.trim(element.val());
	if(value==null||value==""){
		return true;
	}
	if(!pattern.test(value)){
		return false;
	}
	var index=value.indexOf(".");
	if(index==0){
		return false;
	}
	if(index==value.length-1){
		return false;
	}
	var numArr=value.split(".");
	var length=numArr.length;
	if(length>2){
		return false;
	}
	if(length==2){
		numArr[0]=ECSideUtil.validator.clearZero(numArr[0]);
		numArr[1]=ECSideUtil.validator.clearZero(numArr[1],false);
		if(numArr[0].length>params[0]||numArr[1].length>params[1]){
			return false;
		}
		element.val(numArr.join("."));
	}else{
		numArr[0]=ECSideUtil.validator.clearZero(numArr[0]);
		if(numArr[0].length>params[0]){
			return false;
		}
		element.val(numArr[0]);
	}
	if(null != params[2] && null != params[3]){
		if(value<parseFloat(params[2])||value>parseFloat(params[3])){
			return false;
		}
	}
	return true;
};

//验证整数
ECSideUtil.validator.validateDigit=function(element,params){
	if(params&&(typeof params)=="array"){
		if(RateCommon.isDebug){
			alert("参数必须为数组！");
		}
		return true;
	}
	var pattern=/^\d+$/;
	if(!element.val){
		element=$jQuery(element);
	}
	var value=ECSideUtil.validator.trim(element.val());
	if(value==null||value==""){
		return true;
	}
	if(!pattern.test(value)){
		return false;
	}
	value=ECSideUtil.validator.clearZero(value);
	value=parseInt(value);
	if(value<parseInt(params[0])||value>parseInt(params[1])){
		return false;
	}
	element.val(value);
	return true;
};
//验证字符串长度
ECSideUtil.validator.validLength=function(element,params){
	if(!element.val){
		element=$jQuery(element);
	}
	var value=ECSideUtil.validator.trim(element.val());
	if(value==null||value==""){
		return true;
	}
	params=parseInt(params);
	value=value.replace(/[^\x00-\xff]/g,"**");
	var len=value.length;
	if(len>params){
		return false;
	}
	return true;
};

//验证汉字字符串长度
ECSideUtil.validator.validLengthhan=function(element,params){
    if(!element.val){
        element=$jQuery(element);
    }
    var value=ECSideUtil.validator.trim(element.val());
    if(value==null||value==""){
        return true;
    }
    params=parseInt(params);
    value=value.replace(/[^\x00-\xff]/g,"**");
    var len=(value.length)/2;
    if(len>params){
        return false;
    }
    return true;
};
//验证特殊字符
ECSideUtil.validator.validChar=function(element,params){
	if(!element.val){
		element=$jQuery(element);
	}
	var value=ECSideUtil.validator.trim(element.val());
	if(value==null||value==""){
		return true;
	}
	if(!ECSideUtil.validator.DEFAULTS.PATTERN.test(value)){
		return false;
	}
	return true;
};
//验证必填项
ECSideUtil.validator.required=function(cellEditObj){
	if(cellEditObj==null){
		return true;
	}
	var value=cellEditObj.value;
	value=ECSideUtil.validator.trim(value);
	if(value==""){
		return false;
	}
	return true;
};
//比较两个单元格值
ECSideUtil.validator.cellCompare=function(element,params){
	try{
		if(element==null){
			return true;
		}
		var td=element.parentNode;
		
		if(td==null){
			return true;
		}
		if(params.location==null){
			params.location=1;
		}
		if(params.direction=="next"){
			for(var i=0;i<params.location;i++){
				td=td.nextSibling;
				while(td.tagName==null||td.tagName.toUpperCase()!="TD"){
					td=td.nextSibling;
				}
			}
		}else{
			for(var i=0;i<params.location;i++){
				td=td.previousSibling;
				while(td.tagName==null||td.tagName.toUpperCase()!="TD"){
					td=td.previousSibling;
				}
			}
		}
		if(td){
			var endValue=element.value;
			endValue=ECSideUtil.validator.trim(endValue);
			var startValue="";
			var child=null;
			for(var i=0,l=td.childNodes.length;i<l;i++){
				if(td.childNodes[i].tagName!=null&&td.childNodes[i].tagName.toUpperCase()=="INPUT"){
					child=td.childNodes[i];
					break;
				}
			}
			if(child==null){
				startValue=ECSideUtil.validator.trim(td.innerText);
			}else{
				startValue=ECSideUtil.validator.trim(child.value);
			}
			if(params.fn){
				if(!eval(params.fn)(endValue,startValue,params.direction)){
					return false;
				}
			}
		}
	}catch(e){
		if(ECSideUtil.isDebug()){
			alert(e.message);
		}
	}
	return true;
};
//服务器提交数据，获取验证结果(张志友修改于2011-07-08)
ECSideUtil.validator.remote=function(element,params){
	var td=element.parentNode;
    var row = td.parentNode;
    while(row.tagName.toUpperCase()!="TR"){
    	row = row.parentNode;
    }
    var rowKey = row["recordKey"];
	if(!element.val){
		element=$jQuery(element);
	}
	var value=ECSideUtil.validator.trim(element.val() + "," + rowKey);
	if(value==null||value==""){
		return true;
	}
	var flag=false;
	$jQuery.ajax({
		url:params.url,
		data:{
			value:value
		},
		type:"post",
		async: false,
		dataType:"json",
		success:function(data){
			if(data=="true"||data==true){
				flag=true;
			}
//			else{
//				element.attr("value","");
//			}
		}
	});
	return flag;
};
//日期跨年校验 added by zhangzhiyou 20110812
ECSideUtil.validator.yearCompare=function(element,params){
	if(params&&(typeof params)=="array"){
		if(RateCommon.isDebug){
			alert("参数必须为数组！");
		}
		return true;
	}
	var flag=false;//返回标志
	var td=element.parentNode;
    var row = td.parentNode;
    while(row.tagName.toUpperCase()!="TR"){
    	row = row.parentNode;
    }
    var cellIndex = parseInt(params[0]);//参与比较的日期所在列号，从0开始计算
    var compareType = parseInt(params[1]);//比较类型：0表示小于等于比较，1表示大于等于比较
    var compareTime = null;
    if(ECSideUtil.hasClass(row,"add")){//新增时
    	var compareTimeObj = $jQuery(row.cells[cellIndex]).children("input")[0];
        compareTime = ECSideUtil.validator.trim($jQuery(compareTimeObj).val());//参与比较的日期
    }else{//修改时
    	if(compareType == 1){
    		compareTime = element.parentNode.previousSibling.innerText;
    	}else{
    		compareTime = element.parentNode.nextSibling.innerText;
    	}	
    }
	if(!element.val){
		element=$jQuery(element);
	}
	var currentTime=ECSideUtil.validator.trim(element.val());//当前日期
	var compareArray = compareTime.split("-");
	var currentArray = currentTime.split("-");
	if(compareType == 1 && currentTime >= compareTime && compareArray[0]==currentArray[0]){
		flag = true;
	}else if(compareType == 0 &&  currentTime <= compareTime && compareArray[0]==currentArray[0]){
		flag = true;
	}	
	return flag;
};
//验证正浮点数
//例如：parameter="{float:[8,2,0,999999]}
//解释： 8位长度 其中两位小数  从0开始。即0-999999.00
ECSideUtil.validator.validateFloat=function(element,params){
	if(params&&(typeof params)=="array"){
		if(RateCommon.isDebug){
			alert("参数必须为数组！");
		}
		return true;
	}
	
	var pattern=/^-?[\.\d]+$/;
	if(!element.val){
		element=$jQuery(element);
	}
	var value=$jQuery.trim(element.val());
	if(value==null||value==""){
		return true;
	}
	
	if(!pattern.test(value)){
		return false;
	}
	var index=value.indexOf(".");
	if(index==0){
		return false;
	}
	if(index==value.length-1){
		return false;
	}
	var numArr=value.split(".");
	var length=numArr.length;
	if(length>2){
		return false;
	}
	if(length==2){
		numArr[0]=ECSideUtil.validator.clearZero(numArr[0]);
		numArr[1]=ECSideUtil.validator.clearZero(numArr[1],false);
		if(numArr[0].length>params[0]||numArr[1].length>params[1]){
			return false;
		}
		element.val(numArr.join("."));
	}else{
		numArr[0]=ECSideUtil.validator.clearZero(numArr[0]);
		if(numArr[0].length>params[0]){
			return false;
		}
		element.val(numArr[0]);
	}
	if(null != params[2] && null != params[3]){
		if(value<parseFloat(params[2])||value>parseFloat(params[3])){
			return false;
		}
	}
	return true;
};

//去掉数字中无用的0
ECSideUtil.validator.clearZero=function(str,place){
	var pattern=/^0*$/;
	if(pattern.test(str)){
		return "0";
	}
	if(place||place==null){
		pattern=/^0*/g;
	}else{
		pattern=/0*$/g;
	}
	str=str.replace(pattern,"");
	return str;
};

//ADD BY LUZE 2011-07-19 START
ECSideUtil.validator.validateNumber = function(element,params){
	if(!element.val){
		element=$jQuery(element);
	}
	var value=ECSideUtil.validator.trim(element.val());
	if(value==null||value==""){
		return true;
	}
	var pattern = /^\d+$/;
	if(!pattern.test(value)){
		return false;
	}
	params=parseInt(params);
	var len=value.length;
	if(len > 1){
		if(value.substring(0,1) == "0"){
			return false;
		}
	}
	if($jQuery.trim(value) == "0"){
		return false;
	}
	if(len>params){
		return false;
	}
	return true;
};
//END

//ADD BY LUZE 2011-12-06 START
//验证必填项
ECSideUtil.validator.truckNoRequired=function(cellEditObj){
	if(cellEditObj==null){
		return true;
	}
	var value=cellEditObj.value;
	value=ECSideUtil.validator.trim(value);
	if(value != ""){
		var defaultVal = "湘A";
		if(value == defaultVal){
			return false;
		}
	}else{
		return false;
	}
	return true;
};
//END

(function(){
	if($==null){
		return;
	}
	if($!=null&&$jQuery==null){
		$jQuery=$;
	}
	ECSideUtil.validator.addMethods({
		required:{
			fn:"ECSideUtil.validator.required",
			message:"必须填写！"
		},
		float:{
			fn:"ECSideUtil.validator.validateFloat",
			message:"最大只能输入{2}到{3}的数字！"
		},
		digit:{
			fn:"ECSideUtil.validator.validateDigit",
			message:"最大只能输入{0}到{1}的数字！"
		},
		length:{
			fn:"ECSideUtil.validator.validLength",
			message:"不能超过{0}个字符！"
		},
		lengthhan:{
		    fn:"ECSideUtil.validator.validLengthhan",
		    message:"不能超过{0}个汉字！"
		},
		character:{
			fn:"ECSideUtil.validator.validChar",
			message:"不能包含特殊字符:"+ECSideUtil.validator.DEFAULTS.ESCAPED_CODE_POINTS.toString()+"！"
		},
		number:{
			fn:"ECSideUtil.validator.validateNumber",
			message:"最大只能输入大于0的{0}位整数！"
		},
		remote:{
			fn:"ECSideUtil.validator.remote",
			message:"值重复！"
		},
		cellCompare:{
			fn:"ECSideUtil.validator.cellCompare",
			message:"值错误！"
		},
		yearCompare:{//added by zhangzhiyou 20110812
			fn:"ECSideUtil.validator.yearCompare",
			message:"结束日期必须大于开始日期！"
		},
		//ADD BY LUZE 2011-12-06 START
		truckNoRequired : {
			fn : "ECSideUtil.validator.truckNoRequired",
			message : "必须填写！"
		}
		//END
	});
})();