jQuery(document).ready(function(){
	var setting = {
		data: {
			key: {
				title:"name"
			},
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "parentId",
				rootPId: "****"
			}
		},
		callback: {
			onClick: onClick
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

/*	var zNodes =[
	{"id":"RootUnit","name":"组织机构与人员","parentId":"****","type":""},
	{"id":"10","name":"admin","parentId":"1000","type":"0"},
	{"id":"1000","name":"湖北","parentId":"RootUnit","type":""},
	{"id":"1003","name":"武汉","parentId":"1000","type":""},
	{"id":"1004","name":"黄石","parentId":"1000","type":""},
	{"id":"1005","name":"咸宁","parentId":"1000","type":""},
	{"id":"1006","name":"荆州","parentId":"1000","type":""},
	{"id":"1007","name":"宜昌","parentId":"1000","type":""},
	{"id":"1008","name":"荆门","parentId":"1000","type":""},
	{"id":"1009","name":"十堰","parentId":"1000","type":""},
	{"id":"1010","name":"恩施","parentId":"1000","type":""},
	{"id":"1011","name":"随州","parentId":"1000","type":""},
	{"id":"1012","name":"江汉","parentId":"1000","type":""},
	{"id":"1013","name":"襄阳","parentId":"1000","type":""},
	{"id":"1014","name":"鄂州","parentId":"1000","type":""},
	{"id":"1015","name":"孝感","parentId":"1000","type":""},
	{"id":"1016","name":"黄冈","parentId":"1000","type":""},
	{"id":"RootRole","name":"角色","parentId":"****","type":""},
	{"id":"20002","name":"省中心分管各地市管理员一","parentId":"RootRole","type":"1"},
	{"id":"20003","name":"武汉系统管理员","parentId":"RootRole","type":"1"}
	];*/
			jQuery.fn.zTree.init($("#treeDemo"), setting, zNodes);
			//变量
			var selectObj=document.getElementById("selectVariable");
			jQuery("#selectVariable").change(function(){
				var selectedText = selectObj.options[selectObj.selectedIndex].text;
				var selectedValue = selectObj.options[selectObj.selectedIndex].value;
				setValue(selectedText,selectedValue);
			});

});
function setValue(selectedText,selectedValue){
	//相关数据名称+相关数据名称+类型
	jQuery("#variable").val(selectedText+","+selectedText+",4;");
	
}
//return role and person information 
var unit;
var role;
var roleid;
var person;
var personid;
var roleType;
var personType;


String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {  
        if (!RegExp.prototype.isPrototypeOf(reallyDo)) {  
            return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);  
        } else {  
            return this.replace(reallyDo, replaceWith);  
        }  
};

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
function checkSelect1Option(id){
	var obj=document.getElementById("select1");
	for(var i=0;i<obj.length;i++){
		if(obj[i].value==id){
			return false;
		}
	}
}
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
function checkSelect2Option(id){
	var obj=document.getElementById("select2");
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
		if(checkAdd(optionValue)==true){ 
			document.getElementById("select2").options.add(new Option(optionText,optionValue)); 
			}
	}
}

//Commit the value to the parent page
function commitValue(){
var unitValue = "";
var unit = "";
var person="";
var personid="";
var persontype="";

var obj = document.getElementById("select2");
	for(var i=0;i<obj.length;i++){
		var selText = obj[i].innerHTML;
		var selValue = obj[i].value;
		unitValue = selText+","+selValue+";";
		unit += unitValue;
	}
	// 相关数据      类型：4
	var variableName=jQuery("#variable").val();
	unit += variableName;
	
	//实例创建者
 	var predefine="";
    var def_all = document.getElementsByName('define');
   	for(var i=0;i<def_all.length;i++){
		if(def_all[i].checked){
			predefine =predefine+def_all[i].value+",processInitCreator,5;";
		}
	}
   	unit += predefine;
   	
   var cust_all = unit.split(";");
   for(var i=0;i<cust_all.length;i++){
	   var cust_text = cust_all[i].split(",");
	   var utext = cust_text[0];
	   var uvalue = cust_text[1];
	   var utype = cust_text[2];
	   if(utext!=undefined&&uvalue!=""){
		   	person += utext+";";
	   		personid += uvalue+";";
	   		persontype+= utype+";";
	   }
   }	
   	  var cType=window.opener.document.getElementById("cType").value;
   	  var lastPer = person.lastIndexOf(";");
   	  var lastpid = personid.lastIndexOf(";");
   	  var lastpType = persontype.lastIndexOf(";");
   	  var lastunit = unit.lastIndexOf(";");

		//person = person.substring(0,lastPer);
	   	person = person.substring(0,lastPer);
		personid = personid.substring(0,lastpid);
		persiontype = persontype.substring(0,lastpType);
		unit = unit.substring(0,lastunit);

		if(cType=="1"){
			window.opener.document.getElementById('primaryPerson').value=person;
			window.opener.document.getElementById('punit').value = unit;
		}else{
			window.opener.document.getElementById('minorPerson').value=person;
			window.opener.document.getElementById('munit').value = unit;
		}
		var sURL = webpath + "/WfManualActivity.do?method=saveManualActParticipants";
		// 调用AJAX请求函数
		$jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : "processId=" + processId + "&processVersion=" + 
			processVersion + "&cType="+cType+"&participantString="+unit+"&actId="+actId,
			success : function(data) {
				window.close();
			}
		});
		window.close();
}
function getRadioValue(name){
	var names=document.getElementsByName(name);
		for(var i=0;i<names.length;i++){
			if(names[i].checked==true){
				return names[i].value;
			}
		}
}
function getDef(){
	var def=document.getElementsByName("define");
	var defString="";
	for(var i=0;i<def.length;i++){
		if(def[i].checked==true){
		defString+=def[i].id+";";
	}
	
}
return defString;
}
function getLayoutHeight(){
	var initHeight=210;
	if(document.body.clientHeight>600){
			initHeight=400;
	}
	return initHeight;
}
//Add Value To Select
function AddValueToSelect(){
	createNodeSelect();
	creatVariableSelect();
	if(document.all){
		document.getElementById("select1").size="15";
		document.getElementById("select2").size="15";
	}else{
		document.getElementById("select1").style.height="200px";
		document.getElementById("select2").style.height="200px";
	}
	var cType=window.opener.document.getElementById("cType");
	if(cType.value=="1"){

	var def = window.opener.document.manualNodeForm.primaryPreDefine.value;
	var def_all = def.split(";");
	for(var i=0;i<def_all.length;i++){
		if(def_all[i]=="2"){
			document.getElementById('2').checked = true;
		}
		if(def_all[i]=="3"){
			document.getElementById('3').checked = true;
		}
		if(def_all[i]=="4"){
			document.getElementById('4').checked = true;
		}
		if(def_all[i]=="5"){
			document.getElementById('5').checked = true;
		}
	}
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
	}else if(cType.value=="0"){
	
	var def = window.opener.document.manualNodeForm.minorPreDefine.value;
	var def_all = def.split(";");
	for(var i=0;i<def_all.length;i++){
		if(def_all[i]=="2"){
			document.getElementById('2').checked = true;
		}
		if(def_all[i]=="3"){
			document.getElementById('3').checked = true;
		}
		if(def_all[i]=="4"){
			document.getElementById('4').checked = true;
		}
		if(def_all[i]=="5"){
			document.getElementById('5').checked = true;
		}
	}
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
	showVariable();
	showNodeArrary();
}

//Add Value To Proc Select
function AddValueToProcSelect(){
	var unitValue;
	if(document.all){
		document.getElementById("select1").size="24";
		document.getElementById("select2").size="24";
	}else{
		document.getElementById("select1").style.height="200px";
		document.getElementById("select2").style.height="200px";
	}
	if(document.getElementById('cType').value=="0"){
		unitValue = window.opener.document.getElementById('munit').value;
	}else{
		unitValue = window.opener.document.getElementById('punit').value;
	}
	if(unitValue!=""){
		var cust_all = unitValue.split(";");
   		for(var i=0;i<cust_all.length;i++){
		   var cust_text = cust_all[i].split(",");
		   var uvalue = cust_text[1]+","+cust_text[2];
		   var utext = cust_text[0];
		   if(utext!=undefined&&uvalue!=""){
			   if(cust_text[2]=='4'){
				   var obj = document.getElementById("selectVariable").options;
				   for(var j=0;j<obj.length;j++){
					   if(obj[j].text==cust_text[0]){
						   obj[j].selected=true;
					   }
				   }
			   }else if(cust_text[2]=='5'){
				   document.getElementById("define").checked=true;
			   }else{
		   			document.getElementById("select2").options.add(new Option(utext,uvalue)); 
			   }
		   }
		  
	   	   
   		}	
		}
}

//Commit the value to the parent process page
function commitProcessValue(){
var unitValue = "";
var unit = "";
var person="";
var personid="";
var obj = document.getElementById("select2");
	for(var i=0;i<obj.length;i++){
		var selText = obj[i].innerHTML;
		var selValue = obj[i].value;
		unitValue = selText+","+selValue+";";
		unit += unitValue;
	}

   var cust_all = unit.split(";");
   for(var i=0;i<cust_all.length;i++){
	   var cust_text = cust_all[i].split(",");
	   var utext = cust_text[1];
	   var uvalue = cust_text[0];
	   if(utext!=undefined&&uvalue!=""){
	   		person += uvalue+";";
	   		personid += utext+";";
	   }
   }	
   	  var cType=document.getElementById("cType");
   	  var lastPer = person.lastIndexOf(";");
   	  var lastpid = personid.lastIndexOf(";");
   	  var lastunit = unit.lastIndexOf(";");

		//send value
		person = person.substring(0,lastPer);
		window.opener.document.getElementById('monitor').value=person;
		personid = personid.substring(0,lastpid);
		window.opener.document.procForm.monitors.value = personid;
		unit = unit.substring(0,lastunit);
		window.opener.document.getElementById('munit').value = unit;
	}
function showNodeArrary(){
    var cType=window.opener.document.getElementById("cType").value;
     var nodeArraryString="";
    if(cType=="1"){
        nodeArraryString=window.opener.document.manualNodeForm.nodeArraryString.value;
    }else{
        nodeArraryString=window.opener.document.manualNodeForm.minorNodeArraryString.value;
    }
    if(nodeArraryString==""){
    }else{
        var nodeArrary=document.getElementsByName("node");
        for(var i=0;i<nodeArrary.length;i++){
            if(nodeArraryString.indexOf(nodeArrary[i].id)!=-1){
                nodeArrary[i].checked=true;
            }
        }
    }
}
function showVariable(){
    var nodeArraryString="";
    var cType=window.opener.document.getElementById("cType").value;
    if(cType=="1"){
        nodeArraryString=window.opener.document.manualNodeForm.variablesString.value;
    }else{
       nodeArraryString=window.opener.document.manualNodeForm.minorVariablesString.value; 
    }
    if(nodeArraryString==""){
    }else{
        var nodeArrary=document.getElementsByName("manualNodeVariables");
        for(var i=0;i<nodeArrary.length;i++){
            if(nodeArraryString.indexOf(nodeArrary[i].id)!=-1){
                nodeArrary[i].checked=true;
            }
        }
    }
}
function commitVariable(){
    var variableSring="";
    var cType=window.opener.document.getElementById("cType").value;
    var nodeArrary=document.getElementsByName("manualNodeVariables");
     for(var i=0;i<nodeArrary.length;i++){
            if(nodeArrary[i].checked==true){
                variableSring+=nodeArrary[i].id+";";
             }
        }
     if(cType=="1"){
    	 window.opener.document.getElementByID("variablesString").value=variableSring;
     }else{
    	 window.opener.document.getElementByID("minorVariablesString").value=variableSring;
     }
}
function commitNode(){
    var variableSring="";
    var cType=window.opener.document.getElementById("cType").value;
    var nodeArrary=document.getElementsByName("node");
     for(var i=0;i<nodeArrary.length;i++){
            if(nodeArrary[i].checked==true){
                variableSring+=nodeArrary[i].id+";";
            }
        }
    if(cType=="1"){
        window.opener.document.getElementById("nodeArraryString").value=variableSring;
    }else{
        window.opener.document.getElementById("minorNodeArraryString").value=variableSring;
    }
      
}

function createNodeSelect(){
	var str=window.opener.document.getElementById("manualNode").value;
	str = str.replaceAll("\r\n","");
	var node=str.split(";");
	var str1='<table>';
	for(var i=0;i<node.length-1;i++){
			str1=str1+'<tr><td> <input type="checkbox" name="node" id='+'"'+node[i].split(",")[0]+'"'+'/></td><td>'+node[i].split(",")[1]+'</td><tr>';
				
	}
	str1=str1+'</table>';

	document.getElementById("selectNode").innerHTML=str1;
	
	
}
function creatVariableSelect(){
	
	var str=window.opener.document.getElementById("nodeVariables").value;
	var variables=str.split(";");
		var str1='<table>';
	for(var i=0;i<variables.length-1;i++){
		str1=str1+'<tr><td> <input type="checkbox" name="manualNodeVariables" id='+'"'+variables[i].split(",")[0]+'"'+'/></td><td>'+variables[i].split(",")[1]+'</td><tr>';
	}
	var nodeArraryString="";
    var cType=window.opener.document.getElementById("cType").value;
    if(cType=="1"){
        nodeArraryString=window.opener.document.manualNodeForm.variablesString.value;
    }else{
       nodeArraryString=window.opener.document.manualNodeForm.minorVariablesString.value; 
    }
    if(nodeArraryString ==""){
    }else{
    	var nodeArray;
    	if (nodeArraryString.indexOf(";") != -1) {
    		nodeArray = nodeArraryString.split(";");
    	} else {
    		nodeArray = new Array();
    		nodeArray.push(nodeArraryString);
    	}
    	for (var i=0; i<nodeArray.length; i++) {
    		var hasExist = false;
    		for (var j=0; j<variables.length-1; j++) {
    			if (nodeArray[i] == variables[j].split(",")[0]) {
     				hasExist = true;
     				break;
     			}
    		}
    		if (!hasExist && nodeArray[i] != "") {
    			str1 = str1 + '<tr><td><input type="checkbox" name="manualNodeVariables" id='+'"'+nodeArray[i]+'"'+'/></td><td>'+nodeArray[i]+'</td></tr>';
    		}
     	}
    }
	str1=str1+'</table>';

	document.getElementById("selectVariable").innerHTML=str1;

}      