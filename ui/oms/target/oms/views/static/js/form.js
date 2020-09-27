var formObject=[];

/**
 * 页面初始化
 */
$(function () {
	//相等关系
	addHidden("forsubmiteq");
	//不相等关系
	addHidden("forsubmitneq");
	//大于关系
	addHidden("forsubmitgt");
	//大于等于
	addHidden("forsubmitgte");
	//小于关系
	addHidden("forsubmitlt");
	//小于等于
	addHidden("forsubmitlte");
	//like '%xxx'
	addHidden("forsubmitllike");
	//like 'xxx%'
	addHidden("forsubmitrlike");
	//like '%xxx%'
	addHidden("forsubmitlike");
	//in(多选，多个checkbox)
	addHidden("forsubmitin");
	//not in(多选，多个checkbox)
	addHidden("forsubmitnotin");
	
});

/**
 * 生成要作为检索条件的隐藏控件
 * @param className
 * @returns
 */
function addHidden(className){
	$(".advance-query ."+className ).each(function(){
		$(this).after('<input type="hidden" id="hid' + $(this).attr('id') +
				'"  name="hid' + $(this).attr('name') + '" class="'+className+'" fieldname="' +
				$(this).attr('fieldname') + '"  fieldtype="' + $(this).attr('fieldtype') + 
				'" fieldoperator="' + $(this).attr('fieldoperator') + '"  />');
		$(this).removeClass(className);
	});
}
/**
 * 将画面上的控件的数据的值，设置到相应的hidden控件里面
 */
function setHidValue(formId) {
	
	$("#"+formId + " input:hidden").each(function(){
		var id = $(this).attr('id');
		id=id.substr(3);
		var value = "";
		switch ($("#"+id).attr("type")) {
		case "text":
			value = $("#"+id).val();
			break;
        case "checkbox":
        	if($("#"+id).attr('checked')){
        		value = $("#"+id).val();
        	}
            break;
        case "radio":
        	if($("#"+id).attr('checked')){
        		value = $("#"+id).val();
        	}
            break;
		default:
			value = $("#"+id).val();
        	break;
		}
		$(this).val(value);
	});
}

/**
 * form需要提交的项目转为json 
 * @returns
 */
function formToJson(formId){
	formObject=new Array();
	//相等关系
	setFormValue(formId,"forsubmiteq","eq");
	//不相等关系
	setFormValue(formId,"forsubmitneq","neq");
	//大于关系
	setFormValue(formId,"forsubmitgt","gt");
	//大于等于
	setFormValue(formId,"forsubmitgte","gte");
	//小于关系
	setFormValue(formId,"forsubmitlt","lt");
	//小于等于
	setFormValue(formId,"forsubmitlte","lte");
	//like '%xxx'
	setFormValue(formId,"forsubmitllike","llike");
	//like 'xxx%'
	setFormValue(formId,"forsubmitrlike","rlike");
	//like '%xxx%'
	setFormValue(formId,"forsubmitlike","like");
	//in(多选，多个checkbox)
	setFormValue(formId,"forsubmitin","in");
	//not in(多选，多个checkbox)
	setFormValue(formId,"forsubmitnotin","notin");
	
	return JSON.stringify(formObject);
}

/**
 * 设置检索条件
 * @param formId 要扫描的formID
 * @returns
 */
function setFormValue(formId,className,operator){
	var name=""; 		//控件对应的名称（id）
	var field=""; 		//控件对应的字段名称
	var value=""; 		//控件对应的值
	var operator1=""; 	//运算符号
	var type=""; 		//运算符号
	
	//关系
	$("#"+formId + " ."+className).each(function(){
		operator1 = $(this).attr("fieldoperator");
		type=$(this).attr("fieldtype");
		//如果是INPUT标签
		if("INPUT" == $(this).get(0).tagName){
			name = $(this).attr("id");
			field = $(this).attr("fieldname");
			switch ($(this).attr("type")) {
			case "text":
				value = $(this).val();
				break;
	        case "checkbox":
	        	if($(this).attr('checked')){
	        		value = $(this).val();
	        	}
	            break;
	        case "radio":
	        	if($(this).attr('checked')){
	        		value = $(this).val();
	        	}
	            break;
	        case "hidden":
	        	value = $(this).val();
	            break;
			default:
				value = $(this).val();
            	break;
			}
			formObject.push(getPropertyObj(name,field,value,operator,operator1,type));
		} 
		
		if("SELECT" == $(this).get(0).tagName){
			name = $(this).attr("id");
			field = $(this).attr("fieldname");
			value = $(this).val();
			formObject.push(getPropertyObj(name,field,value,operator,operator1,type));
		}
		
		//其他情况
		
	});
}
/**
 * 
 * @param name  控件对应的名称
 * @param field 控件对应的字段名称
 * @param value 控件对应的值
 * @param operator 运算符号 eq:相等 gl:大于 
 * @param operator1 运算符号 and or 
 * @param type 字段类型 string int float dateTime cellphone email
 * @returns
 */
function getPropertyObj(name,field,value,operator,operator1,type){
	var propertyObj = new Object();
	propertyObj.name = name;
	propertyObj.field = field;
	propertyObj.value = value;
	propertyObj.operator = operator;
	propertyObj.operator1 = operator1;
	propertyObj.type = type;
	return propertyObj;
}