jQuery(document).ready(function() {
	var setting = {
		data : {
			key : {
				title : "name"
			},
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "parentId",
				rootPId : '****'
			}
		},
		callback : {
			onClick : onClick
		}
	};
	
	function onClick(event, treeId, treeNode, clickFlag) {
		var nodes = treeNode.children;
		getSelectList(nodes);
	}

	var zNodes;
	var sURL = webpath + "/WfProcessAction.do?method=getOrgTree";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "POST",
		dataType : "json",
		data : {

		},
		success : function(data) {
			zNodes = data.OrgTree;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert("网络错误");
			blnReturn = "false";
		}
	});
	
//	var zNodes =[
//	 			{ id:1, pId:0, name:"组织机构",type:0, open:true,iconOpen:webpath+"/view/common/css/zTreeStyle/img/diy/1_open.png", iconClose:webpath+"/view/common/css/zTreeStyle/img/diy/1_close.png"},
//	 			{ id:111, pId:1, name:"父节点11 - 折叠",type:1,icon:webpath+"/view/common/css/zTreeStyle/img/diy/2.png"},
//	 			{ id:10, pId:111, name:"admin",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//	 			{ id:11, pId:111, name:"张三",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//	 			{ id:12, pId:111, name:"李四",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//	 			{ id:13, pId:111, name:"王五",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//	 			{ id:14, pId:111, name:"赵六",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//	 			{ id:16, pId:111, name:"测试角色",type:1,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//	 			{ id:15, pId:1, name:"父节点12 - 折叠",type:1},
//	 			{ id:121, pId:15, name:"叶子节点121",type:2},
//	 			{ id:122, pId:15, name:"叶子节点122",type:2},
//	 			{ id:123, pId:15, name:"叶子节点123",type:2},
//	 			{ id:124, pId:15, name:"叶子节点124",type:2},
//	 			{ id:16, pId:1, name:"父节点13 - 没有子节点",type:1,isParent:true},
//	 			{ id:2, pId:0, name:"父节点2 - 折叠",type:0},
//	 			{ id:21, pId:2, name:"父节点21 - 展开",type:0, open:true},
//	 			{ id:211, pId:21, name:"叶子节点211",type:2},
//	 			{ id:212, pId:21, name:"叶子节点212",type:2},
//	 			{ id:213, pId:21, name:"叶子节点213",type:2},
//	 			{ id:214, pId:21, name:"叶子节点214",type:2},
//	 			{ id:22, pId:2, name:"父节点22 - 折叠",type:0},
//	 			{ id:221, pId:22, name:"叶子节点221",type:2},
//	 			{ id:222, pId:22, name:"叶子节点222",type:2},
//	 			{ id:223, pId:22, name:"叶子节点223",type:2},
//	 			{ id:224, pId:22, name:"叶子节点224",type:2},
//	 			{ id:23, pId:2, name:"父节点23 - 折叠",type:0},
//	 			{ id:231, pId:23, name:"叶子节点231",type:2},
//	 			{ id:232, pId:23, name:"叶子节点232",type:2},
//	 			{ id:233, pId:23, name:"叶子节点233",type:2},
//	 			{ id:234, pId:23, name:"叶子节点234",type:2},
//	 			{ id:3, pId:0, name:"角色1",type:1, isParent:true, open:true}
//	 			];
	jQuery.fn.zTree.init($("#treeDemo"), setting, zNodes);
});
//return role and person information 
var unit;
var role;
var roleid;
var person;
var personid;
var roleType;
var personType;
function roleNode(){
	return role;
}

function roleId(){
	return roleid;
}

function personNode(){
	return person;
}

function personId(){
	return personid;
}

function roleType(){
	return roleType;
}

function personType(){
	return personType;
}
function personType(){
	return personType;
}
function checkSelect1Option(id){
	var obj=document.getElementById("select1");
	for(var i=0;i<obj.length;i++){
		if(obj[i].value==id){
			return false;
		}
	}
}    
//Add text to select2 
function addSelect2Text(id){
	var obj=document.getElementById(id);
	var optionText="";
	var optionValue="";
	var obj1=document.getElementById('select2'); 
	for(var i=0;i<obj.length;i++){
		if(obj[i].selected==true){
			optionText=obj[i].text;
			optionValue=obj[i].value;
			obj[i].selected=false;
            if(checkAdd(optionValue))  
            	obj1.options.add(new Option(optionText,optionValue));
		}
	}
}

//Check value is not the same
function checkAdd(optionValue)
{
    var obj1=document.getElementById('select2');
    if(obj1.options.length==0){return true;}
        else{ 
            for(var i=0;i<obj1.length;i++){
                if(obj1[i].value==optionValue)
                return false;    
        }
        return true;
    }
}
//设置待选择列表
function getSelectList(nodes){
	if (nodes && nodes != undefined) {
		var childLen =  nodes.length;
		deleteAll("select1");
		for(var i=0;i<childLen;i++){
			var oNewNode = document.createElement("option");
			document.getElementById("select1").appendChild(oNewNode);
			oNewNode.innerHTML=nodes[i].name;
			oNewNode.value = nodes[i].id+","+nodes[i].type;
		}
	}
}

//remove the select2's value
function removeSelect2Value(id){
   var obj=document.getElementById(id);
   for(var i=obj.length-1;i>=0;i--){
		if(obj[i].selected==true){
		    obj.removeChild(obj[i]);
		}
	}

}

//Delete all select2's value
function deleteAll(id){
	var obj= document.getElementById(id);
		for(var i=obj.length-1;i>=0;i--){
		    obj.removeChild(obj[i]);
	}
}

//Add all select1's value to select2
function addAll(id){
	var obj=document.getElementById(id);
	var optionText="";
	var optionValue="";
	for(var b=0;b<obj.length;b++){
		optionText=obj[b].text; 
		optionValue=obj[b].value;
		obj[b].selected=false;
		if(checkAdd(optionValue)==true) 
			document.getElementById("select2").options.add(new Option(optionText,optionValue)); 
	}
}

// Commit the value to the parent page
function commitValue() {
	var unitValue = "";
	var unit = "";
	var person = "";
	var personid = "";
	var obj = document.getElementById("select2");
	for ( var i = 0; i < obj.length; i++) {
		var selText = obj[i].innerHTML;
		var selValue = obj[i].value;
		unitValue = selText + "," + selValue + ";";
		unit += unitValue;
	}

	var cust_all = unit.split(";");
	for ( var i = 0; i < cust_all.length; i++) {
		var cust_text = cust_all[i].split(",");
		var utext = cust_text[1];
		var uvalue = cust_text[0];
		if (utext != undefined && uvalue != "") {
			person += uvalue + ";";
			personid += utext + ";";
		}
	}
	var cType = window.opener.document.getElementById("cType");
	// var lastDef = defineValue.lastIndexOf(";");
	// defineValue = defineValue.substring(0,lastDef);
	var lastPer = person.lastIndexOf(";");
	var lastpid = personid.lastIndexOf(";");
	var lastunit = unit.lastIndexOf(";");
	// send value
	person = person.substring(0, lastPer);
	// window.opener.document.getElementById('primaryPerson').value=defineText+person;
	window.opener.document.getElementById('primaryPerson').value = person;
	// window.opener.document.manualNodeForm.primaryPreDefine.value=defineValue;
	personid = personid.substring(0, lastpid);
	window.opener.document.getElementById('tempId').value = personid;
	unit = unit.substring(0, lastunit);
	window.opener.document.getElementById('unit').value = unit;
}

// Get the checkBox's value
function getCheckBoxValue(name){
    var names = document.getElementsByName(name);
    var checkBoxValue="";
    for(var i=0;i<names.length;i++){
      if(names[i].checked==true){
        var checkValue=names[i].id;
      	checkBoxValue=checkBoxValue+checkValue+";";
      }else{
      	//checkBoxValue=checkBoxValue+checkValue+";";
      }
       
    }
	return checkBoxValue;
}  

//Get the checkBox's text
function getCheckBoxText(name){
    var names = document.getElementsByName(name);
    var checkBoxText="";
    for(var i=0;i<names.length;i++){
      if(names[i].checked==true){
        var checkText=names[i].value;
      	checkBoxText=checkBoxText+checkText+";";
      }else{
      	//checkBoxValue=checkBoxValue+checkValue+";";
      }
       
    }
	return checkBoxText;
}  

//Add Value To Select
function AddValueToSelect(){
	var cType=window.opener.document.getElementById("cType");
	if(cType.value=="0"){
	/*
	var def = window.opener.document.manualNodeForm.primaryPreDefine.value;
	var def_all = def.split(";");
	for(var i=0;i<def_all.length;i++){
		if(def_all[i]=="2"){
			document.getElementById('2').checked = true
		}
		if(def_all[i]=="3"){
			document.getElementById('3').checked = true
		}
		if(def_all[i]=="4"){
			document.getElementById('4').checked = true
		}
		if(def_all[i]=="5"){
			document.getElementById('5').checked = true
		}
	}*/
	var unitValue = window.opener.document.getElementById('punit').value;
	if(unitValue!=""){
		var cust_all = unitValue.split(";");
   		for(var i=0;i<cust_all.length;i++){
		   var cust_text = cust_all[i].split(",");
		   var utext = cust_text[1];
		   var uvalue = cust_text[0];
	   	   if(utext!=undefined&&uvalue!=""){
		   		document.getElementById("select2").options.add(new Option(uvalue,utext)); 
	   		}
   		}	
		}
	}else if(cType.value=="1"){
	/*
	var def = window.opener.document.manualNodeForm.minorPreDefine.value;
	var def_all = def.split(";");
	for(var i=0;i<def_all.length;i++){
		if(def_all[i]=="2"){
			document.getElementById('2').checked = true
		}
		if(def_all[i]=="3"){
			document.getElementById('3').checked = true
		}
		if(def_all[i]=="4"){
			document.getElementById('4').checked = true
		}
		if(def_all[i]=="5"){
			document.getElementById('5').checked = true
		}
	}*/
	var unitValue = window.opener.document.getElementById('munit').value;
	if(unitValue!=""){
		var cust_all = unitValue.split(";");
   		for(var i=0;i<cust_all.length;i++){
		   var cust_text = cust_all[i].split(",");
		   var utext = cust_text[1];
		   var uvalue = cust_text[0];
	   	   if(utext!=undefined&&uvalue!=""){
		   		document.getElementById("select2").options.add(new Option(uvalue,utext)); 
	   		}
   		}	
		}
	}
}

// Add Value To Proc Select
function AddValueToProcSelect() {
	var unitValue;
	if (document.all) {
		document.getElementById("select1").size = "24";
		document.getElementById("select2").size = "24";
	} else {
		document.getElementById("select1").style.height = "360px";
		document.getElementById("select2").style.height = "360px";
	}
	if (document.getElementById('cType').value == "0") {
		unitValue = window.opener.document.getElementById('munit').value;
	} else {
		unitValue = window.opener.document.getElementById('punit').value;
	}

	if (unitValue != "") {
		var cust_all = unitValue.split(";");
		for ( var i = 0; i < cust_all.length; i++) {
			var cust_text = cust_all[i].split(",");
			var uvalue = cust_text[1]+","+cust_text[2];
			var utext = cust_text[0];
			if (utext != undefined && uvalue != "") {
				document.getElementById("select2").options.add(new Option(
						utext, uvalue));
			}
		}
	}
}

// Commit the value to the parent process page
function commitProcessValue() {
	var unitValue = "";
	var unit = "";
	var person = "";
	var personid = "";
	var persontype = "";
	var obj = document.getElementById("select2");
	for ( var i = 0; i < obj.length; i++) {
		var selText = obj[i].innerHTML;
		var selValue = obj[i].value;
		unitValue = selText + "," + selValue + ";";
		unit += unitValue;
	}

	var cust_all = unit.split(";");
	for ( var i = 0; i < cust_all.length - 1; i++) {
		var cust_text = cust_all[i].split(",");
		var utext = cust_text[0];
		var uvalue = cust_text[1];
		var utype = cust_text[2];
		if (utext != undefined && uvalue != "") {
			person += utext + ";";
			personid += uvalue + ";";
			persontype += utype + ";";
		}
	}
	var cType = document.getElementById("cType").value;
	var lastPer = person.lastIndexOf(";");
	var lastpid = personid.lastIndexOf(";");
	var lastpType = persontype.lastIndexOf(";");
	var lastunit = unit.lastIndexOf(";");

	// send value
	person = person.substring(0, lastPer);
	personid = personid.substring(0, lastpid);
	persiontype = persontype.substring(0, lastpType);
	unit = unit.substring(0, lastunit);
	if (cType == "0") {
		window.opener.document.getElementById('monitor').value = person;
		window.opener.document.getElementById("monitors").value = personid;
/*		window.opener.document.getElementById("monitorType").value = persontype;*/
		window.opener.document.getElementById('munit').value = unit;
	} else {
		window.opener.document.getElementById('validCreator').value = person;
		window.opener.document.getElementById("validCreators").value = personid;
/*		window.opener.document.getElementById("creatorType").value = persontype;*/
		window.opener.document.getElementById('punit').value = unit;
	}
	var sURL = webpath + "/WfProcessAction.do?method=saveProcessParticipants";
	// 调用AJAX请求函数
	$jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "text",
		data : "processId=" + processId + "&processVersion=" + 
		processVersion + "&cType="+cType+"&participantString="+unit,
		success : function(data) {
			window.close();
		}
	});
	window.close();
}