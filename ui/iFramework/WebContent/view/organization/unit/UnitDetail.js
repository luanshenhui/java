/*
 * 初始化方法
 * */
(function($){ 
	jQuery(document).ready(function(){
		jQuery('body').bind('keydown',shieldCommon);

		getUnitType();
		
		//初始化Tab框
		jQuery('#tabs').tabs();
		jQuery("div.tabs").tabs({
	        collapsible: true
	     });
		//hover states on the static widgets
		jQuery('#dialog_link, ul#icons li').hover(
			function() { $(this).addClass('ui-state-hover'); }, 
			function() { $(this).removeClass('ui-state-hover'); }
		);
		
		//obj = window.dialogArguments;//定义一个对象用于接收对话框参数	
		//flagType = obj.flag;
		//unitId = obj.unitId;
		flagType = flagType;
		unitId = unitId;
		if(flagType==1||flagType=="1"){		
			getExtendDetail();
			showDetail(unitId);
		}else if(flagType==0||flagType=="0"){
			getExtendDetail();
		}
		
		//页面控件输入有效性验证
		jQuery("#unitDetail").validate({
			errorClass : "error2",
			errorElement : "div",
			highlight : function(element, errorClass) {
				jQuery(element).addClass(errorClass);
				jQuery("#error_" + element.id).show();
			},
			unhighlight : function(element, errorClass) {
				jQuery(element).removeClass(errorClass);
				jQuery("#img_" + element.id).remove();
				jQuery("#error_" + element.id).remove();
			},
			showErrors : function(error, element) {
				var _this = this;
				showErrorsWithPosition(error, element, _this, webpath);
			},
			rules: {
	    		orgName: {
					required: true,
					specialCharCheck:true,
					byteRangeLength: [0,32]
				},
				orgDes: {
					byteRangeLength: [0,255]
				}
			},
			messages: {
				orgName: {
					required : UNIT_FILL_ORGUNITNAME,
					specialCharCheck:UNIT_FILL_ORGUNITNAME,
					byteRangeLength : UNIT_TEXT_TOO_LONG
				},				
				orgDes: {
					byteRangeLength : UNIT_TEXT_TOO_LONG
				}
			}
		});
	});
})(jQuery); 

/*
 * 获取扩展信息
 * */
var extendData;
function getExtendDetail(){
	jQuery.ajax({
		url:webpath + "/UnitAction.do?method=getExtendDetail",
		type:"post",
		async:false,
		dataType:"json",
		data:{type:"unit"}, //给出扩展信息内容类型
		success:function(data)
		{   
			extendData = data;
			var obj = data.BizTypeDefine.elementList;
			var strHtml = getExtInfo(obj); //获取extInfo
			jQuery("#dyItem").append(strHtml);
			//为cobbobox赋值
			for(var i = 0 ; i<obj.length; i++){				
				if(obj[i].name !="id"){
					if(obj[i].type=="ComboBox"){
						var myOption=document.getElementById(obj[i].name);
						myOption.options[myOption.options.length]=new Option("","");
						for(var j in obj[i].storeValueMap){
							myOption.options[myOption.options.length]=new Option(obj[i].storeValueMap[j],j);
					    }
					}
				}
			}
		}
	});
}

/*
 * 校验扩展的数据
 * */
function checkExtendDetail(){
	var data = extendData;
	var obj = data.BizTypeDefine.elementList;
	for(var i = 0 ; i<obj.length; i++){	
		if(obj[i].name !="id"){
			if(obj[i].type=="TextField"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null || value.replace(/[^\x00-\xff]/g,"**").length > 32){
						jQuery("#tabs").tabs('select', 1);  //tab切换
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}
				if(obj[i].regex !="" && value != ""){
					var reg = new RegExp(obj[i].regex);
					if(!reg.test(value)){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();;
						return false;
					}
				}
				if(value.replace(/[^\x00-\xff]/g,"**").length > 32){
					alert(UNIT_TEXT_TOO_LONG);
					document.getElementById(obj[i].name).focus();
					return false;
				}	
			}
         if (obj[i].type=="DateField"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}				
			}
         if(obj[i].type=="NumberField"){
			var value = document.getElementById(obj[i].name).value;
			if(obj[i].allowBlank=="false"){
				if(value =="" || value == null || value.replace(/[^\x00-\xff]/g,"**").length > 5){
					jQuery("#tabs").tabs('select', 1);
					alert(obj[i].errorInfoText);
					document.getElementById(obj[i].name).focus();
					return false;
				}
			}
		    if (obj[i].regex !="" && value != ""){
				var reg = new RegExp(obj[i].regex);
				if(!reg.test(value)){
					jQuery("#tabs").tabs('select', 1);
					alert(obj[i].errorInfoText);
					document.getElementById(obj[i].name).focus();;
					return false;
				}				
			}
			if(value.replace(/[^\x00-\xff]/g,"**").length > 5){
				jQuery("#tabs").tabs('select', 1);
				alert(UNIT_TEXT_TOO_LONG);
				document.getElementById(obj[i].name).focus();
				return false;
			    }
			}
         if(obj[i].type=="ComboBox"){
				var value = document.getElementById(obj[i].name).value;
				if(obj[i].allowBlank=="false"){
					if(value =="" || value == null){
						jQuery("#tabs").tabs('select', 1);
						alert(obj[i].errorInfoText);
						document.getElementById(obj[i].name).focus();
						return false;
					}
				}
			}			
		}
	}
	return true;
}

/*
 * 获取组织类型
 * */
function getUnitType(){
	jQuery.ajax({
		url:webpath + "/UnitAction.do?method=getUnitType",
		type:"post",
		dataType:"json",
		data:{type:"unittype"}, //unittype在数据库wf_org_dictionary表中写死的字段值
		success:function(data)
		        {
		           for(i=0;i<=data.length;i++){
			           	if (i==0){
			           		document.getElementById("orgType").options[i] = new Option("","");
			           	}else{
			           		document.getElementById("orgType").options[i] = new Option(data[i-1][1],data[i-1][0]);
			           	}   	
	               }
	            }
	});
}

/*
 * 保存数据
 * */
function save(){
	//有效性检验
	var returnValue;
	if (checkValidate()&& checkExtendDetail() ){
		returnValue = saveFormElement();
		return returnValue;
	}else{
		returnValue = "false";
	}
	return returnValue;
}

/*
 * 检验数据
 * */
function checkValidate(){
	if(!jQuery("#unitDetail").valid())return false;
	
//	var detailForm;
//	eval('detailForm = document.unitDetail');
//	if(!g_check.checkForm(detailForm)){
//		//alert(g_check.message);
//		return false;
//	}
	
//	if (jQuery("#orgName").val()==null || jQuery("#orgName").val()==""){
//		jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
//		alert(UNIT_FILL_ORGUNITNAME);
//		jQuery("#orgName").focus();
//		return false;
//	}else {
//		var leng = jQuery("#orgName").val().replace(/[^\x00-\xff]/g,"**").length;
//		if(leng>32){
//			jQuery("#tabs").tabs('select', 0); 
//			alert(UNIT_TEXT_TOO_LONG);
//			jQuery("#orgName").focus();
//			return false ;
//	}
//	if(jQuery("#orgDes").val().replace(/[^\x00-\xff]/g,"**").length>255){
//		jQuery("#tabs").tabs('select', 0); 
//		alert(UNIT_TEXT_TOO_LONG);
//		jQuery("#orgDes").focus();
//		return false ;
//	}
////	if (jQuery("#orgType").val()==null || jQuery("#orgType").val()==""){
////		alert("组织类型");
////		return false;
////	}	
//    }
	return true;
}

//var flagType ; // 区分新增保存和修改保存，新增保存为0，修改保存为1
//var unitId; //新增页面：所选节点的父节点id；修改页面：选择修改节点的id
var stationId;//上级领导岗位id
/*
 * 新增保存和修改保存
 * */
function saveFormElement(){
	debugger
	var returnValue;
    if (flagType == 0||flagType == "0"){
	     var name = jQuery("#orgName").val();
	     var des = jQuery("#orgDes").val();
//	     if(stationId){
//	    	 var sta = stationId;
//	     }else{	 
//	    	 var sta = jQuery("#orgSta").val();
//	     }
	     var sta = jQuery("#stationIdHidden").val();
	     var id = unitId;
	     //var type = jQuery("#orgType").val();
	     var type = jQuery("#orgType").find("option:selected").text();
	     getUserId();
	     if(userIdStr==""||userIdStr==null){
	    	 var userID="";
	     }else{
	    	 var userID=userIdStr;
	     }
	     //序列化扩展信息
	     var extInfo = jQuery("form").serialize();
	     extInfo = decodeURIComponent(extInfo,true);//对序列后信息进行解码，以解决乱码问题。但是时间中的空格问题无法解决
		 var sURL = webpath + "/UnitAction.do?method=saveUnit";
	     //调用AJAX请求函数	
		 jQuery.ajax({
				url:sURL,
				type:"post",
				async: false,
				dataType:"text",
				data:{orgName:name,orgDes:des,orgSta:sta,orgType:type,id:id,userId:userID,flag:"0",extInfo:extInfo
			 			},
		        success:function(data){
					if (data.indexOf("session timeout") != -1)
						top.location.href = webpath + "/login.jsp";

			 		returnValue = data;
					//window.returnValue = data;
					//window.close();
				}	
			});
		 return returnValue;
    }
    if(flagType == 1||flagType == "1"){
    	var name = jQuery("#orgName").val();
	    var des = jQuery("#orgDes").val();
	    var sta = jQuery("#stationIdHidden").val();
    	//var sta = stationId;
    	var type = jQuery("#orgType").find("option:selected").text();
    	getUserId();
	     if(userIdStr==""||userIdStr==null){
	    	 var userID="";
	     }else{
	    	 var userID=userIdStr;
	     }
	     var extInfo = jQuery("form").serialize();
	     extInfo = decodeURIComponent(extInfo,true);//对序列后信息进行解码，以解决乱码问题。但是时间中的空格问题无法解决
    	var sURL = webpath + "/UnitAction.do?method=saveUnit";
	     //调用AJAX请求函数	
		 jQuery.ajax({
				url:sURL,
				type:"post",
				async: false,
				dataType:"text",
				data:{orgName:name,orgDes:des,orgSta:sta,orgType:type,id:unitId,userId:userID,flag:"1",extInfo:extInfo},
		        success:function(data){
					if (data.indexOf("session timeout") != -1)
						top.location.href = webpath + "/login.jsp";
					returnValue = data;
					//window.returnValue = data;
					//window.close();
				}	
			});
		 return returnValue;
    }
}
/*
 * 获取组织树
 * */
var nodeId; //组织树 id
function showOrg(){
//	window.parent.showOrg();
	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp";
	window.parent.dialogPopup_L3(sURL,UNIT_NAME,300,420,true,"save",null,unitSelectCallback,emptyUnitSelect);
//	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp";
//	document.getElementById("unitFrame").src=sURL;				
//	jQuery("#unitDialog").dialog('open');
//	var sendPara = new Object();
//	sendPara.isMultiSelect = null;
//	var orgValue = window.showModalDialog('./UnitSelect.jsp',sendPara,'dialogWidth=510px;status:no;scroll:no;dialogHeight=380px');
//	if (orgValue != null){
//		jQuery("#org").val(orgValue.itemText); 
//		nodeId = orgValue.itemId;
//		var queryPara={"itemId" : nodeId};
//		ECSideUtil.queryECForm("table1",queryPara,true);
//	}	
}
function unitSelectCallback(orgValue){
	if (orgValue != null){	    				    			
	    jQuery("#org").val(orgValue.itemText);
	    nodeId = orgValue.itemId;
		var queryPara={"itemId" : nodeId};
		ECSideUtil.queryECForm("table1",queryPara,true);
	}
}
//清空父岗位
function emptyUnitSelect(){
	jQuery("#org").val("");
	//什么也查不到
	var queryPara={"itemId" : "doraymefarsolaxi"};
	ECSideUtil.queryECForm("table1",queryPara,true);
}
//清空父岗位
function emptyStation(){
	jQuery("#orgSta").val("");
	jQuery("#stationIdHidden").val("");
}
/*
 * 获取上级领导岗位
 * */
function showSta(){
//	window.parent.showSta();
	var sURL = webpath + "/view/organization/unit/StationSelect.jsp";
	window.parent.dialogPopup_L3(sURL,UNIT_LEADER_STATION,300,520,true,"save",null,stationSelectCallback,emptyStation);
//	document.getElementById("staFrame").src=sURL;				
//	jQuery("#staDialog").dialog('open');
//	var orgValue = window.showModalDialog('./StationSelect.jsp',null,'dialogWidth=510px;status:no;scroll:no;dialogHeight=380px');
//	if (orgValue != null){
//		jQuery("#orgSta").val(orgValue.itemText); 
//		stationId = orgValue.itemId;
//	}	
}
function stationSelectCallback(returnObj){
	if (returnObj != null){	
	    jQuery("#orgSta").val(returnObj.itemText);
	    jQuery("#stationIdHidden").val(returnObj.itemId);
	}
	
	
}
/*
 * 修改  显示详细信息 
 * */
function showDetail(unitId){
	getUnitType();
	jQuery.ajax({
		url:webpath + "/UnitAction.do?method=getUnitDetail",
		type:"post",
		dataType:"json",
		data:{itemId:unitId,flag:"1"},
		success:function(data){
			        if(data){
			        	jQuery("#orgName").val(data.unitDetail.unitName);
			        	jQuery("#orgDes").val(data.unitDetail.unitDescription);
			        	jQuery("#orgSta").val(data.unitDetail.stationName);
			        	stationId = data.unitDetail.stationId;
			        	jQuery("#stationIdHidden").val(stationId);
			        	unitId = data.unitDetail.unitId;
			        	
			        	for(var k=0;k<$("orgType").options.length;k++){
				       		if($("orgType").options[k].text == data.unitDetail.unitType){
				       		 	$("orgType").options[k].selected=true;		 	
			       		    }
			       	    }			        	
			        }
			        var queryPara={"itemId" : unitId};
			    	ECSideUtil.queryECForm("table2",queryPara,true);
			    	
			    	//给扩展信息赋值
			    	var mapData = data.unitDetail.extInfoMap;
			    	var dataExt = extendData;
			    	var obj = dataExt.BizTypeDefine.elementList;
			    	for(var i = 0 ; i<obj.length; i++){				
			    		if(obj[i].name !="id"){
			    			//document.getElementById(obj[i].name).value = mapData[obj[i].name];
			    			var eleId = "#"+obj[i].name;
			    			//jQuery(eleId).val(mapData[obj[i].name]);
			    			if(mapData[obj[i].name] == " "){
			    				jQuery(eleId).val("");
			    			}else{
			    				jQuery(eleId).val(mapData[obj[i].name]);
			    			}
			    		}
			    	}	
	            }		        
	});	
}

/*
 * 选择用户移入
 * */
function input(){
	var cheVal = ECSideUtil.getPageCheckValue("checkId");
	if(cheVal.length==0){
		alert(UNIT_SELECT_DATA);
		return;
	}	
	var obj = document.getElementById("table2").getElementsByTagName("input");
	var num = 0;
	var array = new Array();
	for(var m=0;m<obj.length;m++){
		if(obj[m].type == "checkbox"){
			for(var z=0;;z++){
			    array[z]=obj[m].value;
			}
		}	
	}	
	if(array.length==0){
		moveLiftToRight();
	}
	for(var w=0;w<cheVal.length;w++){
		for(var x=0;x<array.length;x++)
		if(cheVal[w].value == array[x]){
			moveLiftToRight();
		}
	}		

	ECSideUtil.refresh("table2");
     
}

/*
 * 选择用户移入
 * */
function moveLeftToRight(){
	debugger
	var checkebox = ECSideUtil.getCheckedBox("checkId"); 
	var ecsideObj =ECSideUtil.getGridObj("table2");
	for(var i = 0;i<checkebox.length;i++){
		if(!isRecordExist("table2",checkebox[i].value)){
		    var selROW = checkebox[i].parentNode.parentNode;
			var rowsNum=0;
			if (ecsideObj.ECListBody.rows){
				rowsNum=ecsideObj.ECListBody.rows.length;
			}
			var newTr=ecsideObj.ECListBody.insertRow(rowsNum);
			ECSideUtil_addEvent( newTr,"click", ECSideUtil.selectRow.bind(this,newTr,ecsideObj.id) );
			//newTr.rows = selROW.rows;
			newTr.className="add";
			var cells=[];
			for (var j=0;j<ecsideObj.columnNum;j++ ){
				cells[j]=newTr.insertCell(j);
				//表格宽度目前是写死的
				if(j == 0)
					cells[j].width="53";
				if(j == 1)
					cells[j].width="165";
				if(j == 2)
					cells[j].width="96";
				cells[j].style.textAlign = "center";
				cells[j].innerHTML=selROW.cells[j].innerHTML;
				if(j==0){
					cells[0].children[0].checked = false;
					cells[0].children[0].id="checkId2";
					cells[0].children[0].name="checkId2";
				}
			}
			var topTr=ECSideUtil.getPosTop(newTr);
			if (ecsideObj.ECListBodyZone){
				ecsideObj.ECListBodyZone.scrollTop=topTr;
			}	
		}
	}
}

/*
 * 判断右侧表格中，是否已经存在一个同样的记录
 * */
function isRecordExist(tableId,rowID){
	var flag = false;
	var returnValue;
	var ecsideObj=ECSideUtil.getGridObj(tableId);
	var listBody = ecsideObj.ECListBody.rows;
	for(j=0; j<listBody.length; j++){
		if(listBody[j].cells[0].children[0]){
			var tempID = listBody[j].cells[0].children[0].value;
			// alert(rowID + ":" + tempID);
			if (tempID == rowID){
				flag = true;
				break;
			}
		}
	}
	return flag;
}

/*
 * 获取右侧列表中的用户ID
 * */
var userIdStr="";
function getUserId(){
	//循环TABLE2中的所有元素，找checkbox
	var str = "";
	var f=0;
	var obj = document.getElementById("table2").getElementsByTagName("input");
	for(i=0; i<obj.length;i++){
		if(document.getElementById("table2").getElementsByTagName("input")[i].type=="checkbox"){			
			//var s = document.getElementById("table2").getElementsByTagName("input")[i].value;
			f=f+1;
			if(f==1){
				str = document.getElementById("table2").getElementsByTagName("input")[i].value;
				continue;
			}else{
				str += ",";
			}
			str += document.getElementById("table2").getElementsByTagName("input")[i].value;
		}
	}
	userIdStr = str;
}

/*
 * 移出选择用户 
 * */
function outPut(){	
	var object = document.getElementById("table2").getElementsByTagName("input");
	//倒着删除，以避免删除内容后引起object.length变化倒着有些数据无法删除
	for(i=object.length-1; i>=0;i--){
		if(object[i].type=="checkbox" && object[i].checked){  //根据checked属性true或false判断是否选中
		  object[i].parentNode.parentNode.parentNode.removeChild(object[i].parentNode.parentNode);//删除选中节点
		//obj[i].parentNode.parentNode.innerHTML=obj[i].parentNode.parentNode.removeChildren();
		}
	}
	//是否应该把table2上的checkbox不选中
	var ecsideObj =ECSideUtil.getGridObj("table2");
	var rowsNum=0;
	if (ecsideObj.ECListBody.rows){
		rowsNum=ecsideObj.ECListBody.rows.length
	}
	if (rowsNum <= 1){
		//表头上的checkbox图片。
		if(ecsideObj.ECListHead.rows[0].cells[0].children[1].children[0].className){
			if(ecsideObj.ECListHead.rows[0].cells[0].children[1].children[0].className == "checkedboxHeader")
				ecsideObj.ECListHead.rows[0].cells[0].children[1].children[0].className = "checkboxHeader";
		}
	}
	//over
}

function reFreshTable(orgValue){
	jQuery("#org").val(orgValue.itemText); 
	nodeId = orgValue.itemId;
    var queryPara={"itemId" : nodeId};
    ECSideUtil.queryECForm("table1",queryPara,true);
}