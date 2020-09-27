jQuery(document).ready(function(){
/*	deleteAll("selectVariable");
	//变量字符串
	var variables = window.opener.document.getElementById('transitionVariables').value;
	var variablesArray = variables.split(";");
	for(var i=0;i<variablesArray.length-1;i++){
		//变量信息：变量Id,变量名称，变量默认值，变量描述
		var variableArray = variablesArray[i].split(",");
		var oNewNode = document.createElement("option");
		document.getElementById("selectVariable").appendChild(oNewNode);
		oNewNode.value = variableArray[0];
		oNewNode.innerHTML=variableArray[1];
	}*/
	var selectObj=document.getElementById("selectVariable");
	jQuery("#selectVariable").click(function(){
		var selectedText = selectObj.options[selectObj.selectedIndex].text;
		setValue(selectedText);
	});
	
});

function setValue(myValue) {
	var conditionStrs = document.getElementsByName('conditionValue');
	var myField = conditionStrs[0];
	if (document.selection) {
		myField.focus();
		sel = document.selection.createRange();
		sel.text = myValue;
		sel.select();
	} else if (myField.selectionStart || myField.selectionStart == "0") {
		var startPos = myField.selectionStart;
		var endPos = myField.selectionEnd;
		myField.value = myField.value.substring(0, startPos) + myValue
				+ myField.value.substring(endPos, myField.value.length);
	} else {
		myField.value += myValue;
	}
	myField.focus();
}
function trim(str){ 
		return str.replace(/\s/g, "");    
} 

function checkForm(){
	var conditionStrs = document.getElementsByName('conditionValue');
	var conditionStr=conditionStrs[0];
	if(trim(conditionStr.value)!=""){
		var num="1";
		var expression=conditionStr.value;
		if(!checkSemicolon(expression)){
			return;
		}
		
		// TODO 这里访问后台，校验表达式正确性
		
/*		if(response.responseText=="1"){
			alert("语法正确");
		}else{
			if(response.responseText=="2"){
				alert("表达式必须为布尔型");
			}else{
				alert("语法错误");
			}
		}*/
	}
}

function checkSemicolon(expression){
	if(";"!=expression.substring(expression.length-1, expression.length)){
		alert("表达式应以分号结束");
		return false ;
	}
	var semicolonCount = expression.length - (expression.replace(new RegExp(";","g"),"")).length;//计算表达式中的分号数。
	if(1<semicolonCount){
		alert("表达式中存在多个结束符");
		return false;
	}
	return true;
}

function checkCon(){
	var conditionStrs = document.getElementsByName('conditionValue');
	var conditionStr=conditionStrs[0];
	if(trim(conditionStr.value)!=""){
		setParentValue();
/*		var expression=conditionStr.value;
		if(!checkSemicolon(expression)){
			return;
		}
		conn.request({
            url: '<%=request.getContextPath()%>/toTransitionValidate.do',
            method: 'post',
            params: {"expression":expression,"xmlStr": window.opener.document.forms[0].xmlStr.value,"variableString":window.opener.document.getElementById('transitionVariables').value},
            headers :{'ajax':'true'},
            callback: checkContion
          });*/
      }else{
      	setParentValue();
      }
}
function  checkContion(options, success, response) {
	if(response.responseText=="1"){
		setParentValue();
	}else{
		if(response.responseText=="2"){
			alert("表达式必须为布尔型");
		}else{
			alert("语法错误");
		}
	}
};

function setParentValue() {
	var conditionStrs = document.getElementsByName('conditionValue');
	var conditionType = document.getElementById("conditionType").value;
	var conditionStr=conditionStrs[0];
	var conditionValue = conditionStr.value;
	if(conditionType == "preCondition"){
		window.opener.document.getElementById("preCondition").value = conditionValue;
	}else if(conditionType == "postCondition"){
		window.opener.document.getElementById("postCondition").value = conditionValue;
	}
	window.opener = null;
	window.close();
} 
//清除变量表达式列表
function deleteAll(id){
	var obj= document.getElementById(id);
		for(var i=obj.length-1;i>=0;i--){
		    obj.removeChild(obj[i]);
	}
}