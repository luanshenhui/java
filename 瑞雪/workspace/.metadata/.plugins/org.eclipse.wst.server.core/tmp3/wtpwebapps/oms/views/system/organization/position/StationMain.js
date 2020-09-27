/*
 * 组织树
 * */
var tree;
$(document).ready(function(){
	$("#splitter").jsplit({ 
		MaxW:"550px"//设置最大宽度
        ,MinW:"150px"//设置最小宽度
        ,FloatD:"left"//设置块浮动方向
        ,IsClose:false//设置初始状态
        ,BgUrl:"url(" + webpath+ "/view/base/theme/css/redmond/jsplit/image/sp_bg.gif)"//设置分隔条背景图片地址
        ,Bg:"right 0 repeat-y"//设置分隔条背景图片position,颜色等
        ,Btn:{btn:false//是否显示上下按钮 false为不显示
             ,oBg:{Out:"0 0",Hover:"-6px 0"}//设置打开状态时候按钮背景：鼠标离开(默认)，经过
             ,cBg:{Out:"-12px 0",Hover:"-18px 0"}}//设置打开状态时候按钮背景：鼠标离开(默认)，经过
        ,Fn:function(){}//拖动，点击分隔条时候触发的方法
	});
	
	tree =new dhtmlXTreeObject("unitTree","100%","100%",0);
    tree.setImagePath(webpath+"/view/base/theme/css/redmond/dhtmlxtree/image/DhtxTree/csh_books/");
    //tree.enableCheckBoxes(true);
    tree.attachEvent("onClick",selectSta);
    tree.setOnOpenEndHandler(checkSubNodes);  //解决节点请求回来无法展开
	tree.setOnMouseInHandler(beforeOpenNode);
    tree.setXMLAutoLoading(webpath+"/UnitAction.do?method=getSubUnitTree"); 
	tree.loadXML(webpath+"/UnitAction.do?method=getUnitTree");	
	tree.openItem("RootUnit@UNIT");
	window.setTimeout(function() {
		//tree.closeAllItems(0);
	}, 0);
	
	getUnitTreeManageable();
	initSta();
	
	//显示对话框页面，要放在按钮点击事件的前面，否则dialog不会隐藏
//	$("#unitDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		height: 'auto',
//		width:350,
//		resizable: false,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//				$(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["unitFrame"].save(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("unitFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.save();
//	    		if(returnObj !="false"){ //如果校验通过关闭页面，否则不关闭
//	    		if (returnObj){
//	    			if(chechflag == "0"){
//		    			var parentId = returnObj.staDetail.parentStationId;
//		    			if(parentId ==""){
//		    				parentId = 0; // 没有parentId时，给其赋值，以便画出新加节点
//		    			}
//		    			var itemId = returnObj.staDetail.stationId;
//		    			var itemText = returnObj.staDetail.stationName;
//		    			staTree.insertNewItem(parentId,itemId,itemText);
//	    			}
//	    			if(chechflag == "1"){
//	    				if(returnObj){
//	    					var itemId = returnObj.staDetail.stationId;
//	    					var newLabel = returnObj.staDetail.stationName;
//	    					var newTooltip = returnObj.staDetail.stationName;
//	    					staTree.setItemText(itemId,newLabel,newTooltip);
//	    				}
//	    			}
//	    		}	 		      	
//	    	    $(this).dialog('close');  	
//	    		}
//			}			
//		}
//	});
	
	//改button文字
//    jQuery(jQuery("button", jQuery("#unitDialog").parent())[1]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#unitDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
	
	//StationDetail.jsp中的方法
//	$("#userDialog").dialog({
//		bgiframe: true,
//		autoOpen: false,
//		height: 'auto',
//		width:630,
//		resizable:false,
//		modal: true,
//		buttons: {
//		    '关闭': function() {
//				$(this).dialog('close');
//	    },
//			'保存 ': function() {
//	    		//var returnObj = document.frames["userFrame"].confirmUserSelect(); //调子页面的保存方法
//	    		var centreFrameObj = window.document.getElementById("userFrame");//兼容IE与firefox
//	    		var returnObj = centreFrameObj.contentWindow.confirmUserSelect();
//	    		if(returnObj){
//	    			var itemIds = returnObj.itemIds;
//	    			var itemTexts = returnObj.itemTexts;
//	    			document.frames["unitFrame"].document.getElementById("staUser").value=itemTexts;
//	    			document.frames["unitFrame"].document.getElementById("staUserHidden").value=itemIds;
//	    			//$("#staUser").val(itemTexts);
//	    			staUserId = itemIds;
//	    		}	 		      	
//	    	    $(this).dialog('close');  				
//			}
//		}
//	});		
//	//改button文字
//    jQuery(jQuery("button", jQuery("#userDialog").parent())[1]).text(PROMPT_SAVE_BUTTON);
//    jQuery(jQuery("button", jQuery("#userDialog").parent())[0]).text(PROMPT_CLOSE_BUTTON);
});

//初始化右侧岗位tree; 否则在不点击 左侧 组织tree时，取不到unitId而报脚本错误
function initSta(){
	$("#staTree").empty();  // jquery 清空原来div下的tree
	var unitId = "RootUnit@UNIT"; //组织树根节点
	var unitName = tree.getItemText(unitId);//获取选中节点的名称
	staTree =new dhtmlXTreeObject("staTree","100%","100%",0);
	staTree.setImagePath(webpath+"/view/base/theme/css/redmond/dhtmlxtree/image/DhtxTree/csh_books/");
	//staTree.enableTreeLines(false); //不显示树线
	//tree.enableCheckBoxes(true);
	staTree.loadXML(webpath+"/StationAction.do?method=getStationInUnit&unitId="+unitId);	
	window.setTimeout(function() {
		//staTree.closeAllItems(0);
	}, 0);	
	var strHtml = unitName+' '+STAT_STAT_MNGT;
	$("#stationTitle").append(strHtml);
}

function getUnitTreeManageable(){
	$.ajax({
		url:webpath + "/UnitAction.do?method=getUnitTreeManageable",
		type:"post",
		async:false,
		dataType:"json",
		success:function(data){
			if(data.errorMessage==null || data.errorMessage==undefined){
				for(var i=0;i<data.length;i++){
					if(data[i].MANAGEABLE != 1){
						tree.showItemCheckbox(data[i].UNIT_ID,false); //隐藏复选框
						tree.setItemColor(data[i].UNIT_ID,"#aaaaaa","#aaaaaa");//节点字体颜色置灰
					}
				}
				//置标题栏名称
				var unitId = tree.getSelectedItemId();//获取选中节点ID
				var unitName = tree.getItemText(unitId);//获取选中节点的名称
				var itemColor = tree.getItemColor(unitId);	
				//通过节点颜色判断是否有操作权限
				if(itemColor.acolor == "#aaaaaa"){
					$("#btnAdd").attr('disabled',true);
					$("#btnUpdate").attr('disabled',true);
					$("#btnDel").attr('disabled',true);
				}else{
					$("#btnAdd").attr('disabled',false);
					$("#btnUpdate").attr('disabled',false);
					$("#btnDel").attr('disabled',false);
				}
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
		}
	});	
}

/*
 * 点击获取领导岗位
 * */
var staTree;
function selectSta(){
	//document.getElementById("staTree").innerHTML = ""; //清空原来div下的tree
	$("#staTree").empty();  // jquery 清空原来div下的tree
	var unitId = tree.getSelectedItemId();//获取选中节点ID
	var unitName = tree.getItemText(unitId);//获取选中节点的名称
	var itemColor = tree.getItemColor(unitId);	
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		$("#btnAdd").attr('disabled',true);
		$("#btnUpdate").attr('disabled',true);
		$("#btnDel").attr('disabled',true);
	}else{
		$("#btnAdd").attr('disabled',false);
		$("#btnUpdate").attr('disabled',false);
		$("#btnDel").attr('disabled',false);
	}
	staTree =new dhtmlXTreeObject("staTree","100%","100%",0);
	staTree.setImagePath(webpath+"/view/base/theme/css/redmond/dhtmlxtree/image/DhtxTree/csh_books/");
	//staTree.enableTreeLines(false); //不显示树线
	//tree.enableCheckBoxes(true);
	staTree.loadXML(webpath+"/StationAction.do?method=getStationInUnit&unitId="+unitId);
	window.setTimeout(function() {
		//staTree.closeAllItems(0);
	}, 0);
	$("#stationTitle").empty();//清空原标题名称
	var strHtml = unitName+' '+STAT_STAT_MNGT;
	$("#stationTitle").append(strHtml);
     
}

/*
 * 新增岗位
 */
var chechflag;
function addSta(){
	var unitId = tree.getSelectedItemId();
	if(unitId == "" || unitId == null){
		alert(STAT_SELECT_ORG);
		return;
	}
	
	if(staTree.getSelectedItemId()){
		//sendPara.staId = staTree.getSelectedItemId();	
		sendstaId = staTree.getSelectedItemId();
	}else{		
		//sendPara.staId = null;
		sendstaId = null;
	}
	var sendunitId = unitId;
	var sendflag = 0;
	chechflag = sendflag;
	var sURL = webpath + "/view/organization/position/StationDetail.jsp?sendunitId="+sendunitId+"&sendflag="+sendflag+"&sendstaId="+sendstaId;
	window.parent.dialogPopup_L2(sURL,STAT_STAT_DETAIL,250,350,true,"save",null,addStaCallback);
	//document.getElementById("unitFrame").src=sURL;				
	//$("#unitDialog").dialog('open');
//	var sendPara = new Object();
//	var unitId = tree.getSelectedItemId();
//	if(unitId == "" || unitId == null){
//		alert("请选择组织");
//		return;
//	}
//	
//	if(staTree.getSelectedItemId()){
//		sendPara.staId = staTree.getSelectedItemId();		
//	}else{		
//		sendPara.staId = null;
//	}
//	sendPara.unitId = unitId;
//	sendPara.flag = 0;
//	var returnObj = window.showModalDialog('./StationDetail.jsp',sendPara,'dialogWidth=360px;status:no;scroll:no;dialogHeight=200px');
//	if (returnObj){
//		var parentId = returnObj.staDetail.parentStationId;
//		if(parentId ==""){
//			parentId = 0; // 没有parentId时，给其赋值，以便画出新加节点
//		}
//		var itemId = returnObj.staDetail.stationId;
//		var itemText = returnObj.staDetail.stationName;
//		staTree.insertNewItem(parentId,itemId,itemText);
//	}	
}
/**
 * addSta方法的回调函数
 * @param returnObj
 * @return
 */
function addStaCallback(returnValue){
	if (returnValue){
		var parentId = returnValue.staDetail.parentStationId;
		if(parentId ==""){
			parentId = 0; // 没有parentId时，给其赋值，以便画出新加节点
		}
		var itemId = returnValue.staDetail.stationId;
		var itemText = returnValue.staDetail.stationName;
		staTree.insertNewItem(parentId,itemId,itemText,null,"WF_ORG_STATION.gif","WF_ORG_STATION.gif","WF_ORG_STATION.gif");
	}
}

/*
 * 删除岗位
 */
function delSta(){
	var staionId = staTree.getSelectedItemId();
	//alert(staionId);
	if(staionId == null || staionId == ""){
		alert(STAT_SELECT_STATION);
		return ;
	}
	confirm(PROMPT_CONFIRM_DELETE,function(){
		$.ajax({
			url:webpath + "/StationAction.do?method=deleteStation",
			type:"post",
			async:false,
			dataType:"json",
			data:{staId:staionId},
			success:function(data){
				if(data.errorMessage==null || data.errorMessage==undefined){
					staTree.deleteItem(data.staDetail.stationId);
					alert(DELETE_OK);
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
				}
			}
		});
	});
}

/*
 * 修改
 */
function updateSta(){
	var unitId = tree.getSelectedItemId();//获取选中节点ID
//	if(unitId == "" || unitId == null){
//		alert("请选择组织");
//		return;
//	}
	var itemColor = tree.getItemColor(unitId);	
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		$("#btnAdd").attr('disabled',true);
	}else{
		$("#btnAdd").attr('disabled',false);
	}
	if(!tree.getSelectedItemId()){
		alert(STAT_SELECT_ORG);
		return;
	}else if(!staTree.getSelectedItemId()){
		alert(STAT_SELECT_STATION);
		return;
	}
	sendunitId = tree.getSelectedItemId();
	sendstaId = staTree.getSelectedItemId();
	sendflag = 1; // 0 为新增保存；1为修改保存
	chechflag = sendflag;
	var sURL = webpath + "/view/organization/position/StationDetail.jsp?sendunitId="+sendunitId+"&sendflag="+sendflag+"&sendstaId="+sendstaId;
	window.parent.dialogPopup_L2(sURL,STAT_STAT_DETAIL,220,350,true,"save",null,updateStaCallback);
	//document.getElementById("unitFrame").src=sURL;
	//$("#unitDialog").dialog('open');
//	var sendPara = new Object();
//	if(!tree.getSelectedItemId()){
//		alert("请选择组织单元");
//		return;
//	}else if(!staTree.getSelectedItemId()){
//		alert("请选择岗位");
//		return;
//	}
//	sendPara.unitId = tree.getSelectedItemId();
//	sendPara.staId = staTree.getSelectedItemId();
//	sendPara.flag = 1; // 0 为新增保存；1为修改保存
//	var returnObj = window.showModalDialog('./StationDetail.jsp',sendPara,'dialogWidth=360px;status:no;scroll:no;dialogHeight=200px');
//	if(returnObj){
//		//var obj = eval('(' + returnObj + ')');  //转换json
//		var itemId = returnObj.staDetail.stationId;
//		var newLabel = returnObj.staDetail.stationName;
//		var newTooltip = returnObj.staDetail.stationName;
//		staTree.setItemText(itemId,newLabel,newTooltip);
//	}
}

/**
 * updateSta方法的回调函数
 * @param returnObj
 * @return
 */
function updateStaCallback(returnValue){
	if(returnValue){
		var itemId = returnValue.staDetail.stationId;
		var newLabel = returnValue.staDetail.stationName;
		var newTooltip = returnValue.staDetail.stationName;
		staTree.setItemText(itemId,newLabel,newTooltip,null,"WF_ORG_STATION.gif","WF_ORG_STATION.gif","WF_ORG_STATION.gif");
	}
}

/*
 * tree设置节点展开
 * */
var nodeClickArray = new ArrayList(); //节点点击数组
var beforeOpenSubNodes;
function checkSubNodes(id,state){
	//记录点击过的节点，第一次单击则请求数据，然后记录；当再次点击后则不再请求数据。
	if(nodeClickArray.contains(id))
		return true;
	else{
		nodeClickArray.add(id);
		//如果父结点是灰的，则需要对子结点的使用状态进行判断
		//如果父结点不是灰的，则所有子结点是可用状态。
		var itemColor = tree.getItemColor(id);
		//通过节点颜色判断是否有操作权限
		if(itemColor.acolor == "#aaaaaa"){
			getSubUnitTreeManageable(id);
		}
	}
	if(beforeOpenSubNodes>0)
		return true;
	if(beforeOpenSubNodes==0 && state == -1){
		tree.openItem(id);	
	}
    beforeOpenSubNodes = 1;
	return true;
}
function beforeOpenNode(id){
	beforeOpenSubNodes = tree.hasChildren(id);
	return true;
}
function getSubUnitTreeManageable(id){
	$.ajax({
		url:webpath + "/UnitAction.do?method=getSubUnitTreeManageable",
		type:"post",
		async:false,
		dataType:"json",
		data:{id:id},
		success:function(data){
			if(data.errorMessage==null || data.errorMessage==undefined){
				for(var i=0;i<data.length;i++){
					if(data[i].MANAGEABLE != 1){
						tree.showItemCheckbox(data[i].UNIT_ID,false); //隐藏复选框
						tree.setItemColor(data[i].UNIT_ID,"#aaaaaa","#aaaaaa");//节点字体颜色置灰
					}
				}
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
		}
	});
}
/*
 * 岗位下用户
 * */
function showStaUser(){
//	var sURL = webpath + "/UserAction.do?method=getUser&forward=userSelect";
//	document.getElementById("userFrame").src=sURL;
//	$("#userDialog").dialog('open');
}

