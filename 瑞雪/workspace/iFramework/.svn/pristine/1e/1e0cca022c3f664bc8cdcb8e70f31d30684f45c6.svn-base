var appName;
var leftTreeRootNode2;
var rightTreeRootNode2;
var copyText;
var bottomRootNode;
var bottomRootNode1;
var condition;

var validateFlag = "";
function add(num) {
	document.getElementById("num").value = num;
	var flag = getFlag('flagSelect');
	var con = "(" + document.getElementById("leftText").value + flag
			+ document.getElementById("rightText").value + ")";
	bottomRootNode = new Ext.tree.TreeNode({
		text : con,
		iconCls : 'bsubexpressions'
	});
	bottomRootNode1 = new Ext.tree.TreeNode({
		text : con,
		iconCls : 'bsubexpressions'
	});
	ajaxCommit(num, con);

}
function checkCon() {
	if (trim(document.transitionForm.expression.value) != "") {
		var num = "1";
		var expression = document.transitionForm.expression.value;
		if (!checkSemicolon(expression)) {
			return;
		}
		conn.request({
			url : '<%=request.getContextPath()%>/toTransitionValidate.do',
			method : 'post',
			params : {
				'id' : '<%= request.getAttribute("procId")%>',
				"ValidateType" : num,
				"expression" : expression,
				"xmlStr" : document.transitionForm.xmlStr.value,
				"variableString" : document
						.getElementById('transitionVariables').value
			},
			headers : {
				'ajax' : 'true'
			},
			callback : checkContion
		});
	} else {
		submit_onclick();
	}
}
function checkContion(options, success, response) {
	if (response.responseText == "1") {
		submit_onclick();
	} else {
		if (response.responseText == "2") {
			alert("表达式必须为布尔型");
		} else {
			alert("语法错误");
		}
	}
};
function checkForm(){
	if(trim(document.transitionForm.expression.value)!=""){
		var num="1";
		var expression=document.transitionForm.expression.value;
		if(!checkSemicolon(expression)){
			return;
		}
		conn.request({
            url: '<%=request.getContextPath()%>/toTransitionValidate.do',
            method: 'post',
            params: {'id':'<%= request.getAttribute("procId")%>',"ValidateType":num,"expression":expression,"xmlStr": document.transitionForm.xmlStr.value,"variableString":document.getElementById('transitionVariables').value},
            headers :{'ajax':'true'},
            callback: checkForm_callback
          });	
	}
}
function checkForm_callback(options, success, response) {
	if (response.responseText == "1") {
		alert("语法正确");
	} else {
		if (response.responseText == "2") {
			alert("表达式必须为布尔型");
		} else {
			alert("语法错误");
		}
	}
}
function checkSemicolon(expression) {
	if (";" != expression.substring(expression.length - 1, expression.length)) {
		alert("表达式应以分号结束");
		return false;
	}
	var semicolonCount = expression.length
			- (expression.replace(new RegExp(";", "g"), "")).length;// 计算表达式中的分号数。
	if (1 < semicolonCount) {
		alert("表达式中存在多个结束符");
		return false;
	}
	return true;
}
function commitValue(){
	var name='<%=request.getParameter("applicationPageName")%>';
	switch(name){
		case "openAutoNodeApplication":window.opener.document.autoNodeForm.application.value = appName;break;
		case "openDelayApplication": window.opener.document.getElementById("delayApplication").value = appName;break;
		case "openAlertApplication": window.opener.document.getElementById("alertApplication").value = appName;break;
		default: window.opener.document.manualNodeForm.application.value = appName;
	}
	window.close();
}

function getFlag(id) {
	var obj = document.getElementById(id);
	for ( var i = 0; i < obj.length; i++) {
		if (obj[i].selected == true) {
			optionText = obj[i].text;
			return optionText;
		}
	}
}

function addCondition(num) {
	document.getElementById("num").value = num;
	var flag = getFlag('flagSelect');
	condition = document.getElementById("leftText").value + flag
			+ document.getElementById("rightText").value + ";";
	ajaxCommit(num, condition);
}

function LoadName() {
	var selectObj = document.getElementById("selectVariable");
	jQuery("#selectVariable").click(function() {
		var selectedText = selectObj.options[selectObj.selectedIndex].text;
		setValue(selectedText);
	});

}

function setValue(myValue) {
	var myField = document.getElementById("routeCondition");
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

//   	
function omit() {
	var priorityValue = document.getElementById("routePriority");
	priorityValue.value = "-1";
	priorityValue.readOnly = true;
	priorityValue.disabled = true;
}

//
function usal() {
	var priority = document.getElementById("routePriority");
	priority.value = "0";
	priority.readOnly = false;
	priority.disabled = false;
}

function getTypeValue() {
	var names = document.getElementsByName("radioType");
	for ( var i = 0; i < names.length; i++) {
		if (names[i].checked == true) {
			return names[i].value;
		}
	}
}

function trim(str) {
	return str.replace(/\s/g, "");
}

function submit_onclick() {
	if (trim(document.getElementById("transName").value) == "") {
		document.transitionForm.transName.focus();
		alert("名称不可以为空");
		document.transitionForm.transName.value = "";
		return false;
	}
	if (document.getElementById("routeCondition").value == "") {
		alert("条件表达式不可以为空！");
		return false;
	}
	
	if (document.getElementById("routePriority").value == "") {
		alert("优先级不可以为空！");
		return false;
	}
	var procid = jQuery("#procid").val();
	var procversion = jQuery("#procversion").val();
	var transId = jQuery("#transId").val();
	var transName = jQuery("#transName").val();
	var transDesc = jQuery("#transDesc").val();
	var routePriority = jQuery("#routePriority").val();
	var routeCondition = jQuery("#routeCondition").val();
	var fromActId = jQuery("#fromActId").val();
	var toActId = jQuery("#toActId").val();

	var sURL = webpath + "/WfTransitionAction.do?method=update";
	//调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : {
			transName : transName,
			transDesc : transDesc,
			routePriority : routePriority,
			routeCondition : routeCondition,
			procid : procid,
			procversion : procversion,
			transId : transId,
			fromActId : fromActId,
			toActId : toActId,
			transDesc:transDesc
		},
		success : function(data) {
			if (data.errorMessage) {
				alert(data.errorMessage);
			} else { 
				window.opener.updateTransition(transId,transName);
				window.close();
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("网络错误");
		}
	});
}
