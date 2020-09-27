var tree;
var checkFlag; //判断是修改保存还是新建保存，用以区分修改节点的后重画的方式
jQuery(document).ready(function(){
	//画iframe，由于 iframe与 jquery ajax不兼容的问题
	//document.getElementById("dialog").innerHTML = '<iframe id="frame" src=""/>';
	var orgTree = document.getElementById("orgTree");
    tree =new dhtmlXTreeObject(document.getElementById("orgTree"),"100%","100%",0);
    tree.setImagePath(webpath+"/view/base/theme/css/redmond/dhtmlxtree/image/DhtxTree/csh_books/");
    //tree.enableCheckBoxes(true);
    tree.attachEvent("onClick",onClickCheck); //点击节点事件
    tree.setOnOpenEndHandler(checkSubNodes);  //解决节点请求回来无法展开
	tree.setOnMouseInHandler(beforeOpenNode);
    tree.setXMLAutoLoading(webpath+"/UnitAction.do?method=getSubUnitTree"); 
	tree.loadXML(webpath+"/UnitAction.do?method=getUnitTree");
	tree.openItem("RootUnit@UNIT");
    if(tree.getSelectedItemId() == "RootUnit@UNIT"){
		jQuery("#btnDel").attr('disabled',true);
	}
    
    window.setTimeout(function() {
		//tree.closeAllItems(0);
	}, 0);
    getUnitTreeManageable();
	onClickCheck();
    //测试设置页面元素可用性,参数是页面的id
    //setPageElementStatus("9039de2a9f0649ca842ea0db8fbde4fd");

});


function getUnitTreeManageable(){	
	jQuery.ajax({
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
 * 新建
 * */
function addOrg(){
	var sendPara = new Object();
	if(!tree.getSelectedItemId()){
		alert(UNIT_SELECT_NODE_FIRST);
		return;
	}
	//sendPara.unitId = tree.getSelectedItemId();
	//sendPara.flag = 0; // 0 为新增保存；1为修改保存
	var sendunitId = tree.getSelectedItemId();
	var itemColor = tree.getItemColor(sendunitId);	
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		alert(UNIT_NO_PRIVILEGES);
		return;
	}
	var sendflag = 0; // 0 为新增保存；1为修改保存
	checkFlag = sendflag;
	var sURL = webpath + "/view/organization/unit/UnitDetail.jsp?sendunitId="+sendunitId+"&sendflag="+sendflag;
	//document.getElementById("unitDetailFrame").src=sURL;
	window.parent.dialogPopup_L2(sURL,"新建组织单元",560,670,true,"save",null,addOrgCallback);
	//jQuery("#unitDetailDialog").dialog('open');
//	var sendPara = new Object();
//	if(!tree.getSelectedItemId()){
//		alert("请选择节点!");
//		return;
//	}
//	sendPara.unitId = tree.getSelectedItemId();
//	sendPara.flag = 0; // 0 为新增保存；1为修改保存	
//	var returnObj = window.showModalDialog('./UnitDetail.jsp',sendPara,'dialogWidth=640px;status:no;scroll:no;dialogHeight=460px');
//	if (returnObj){
//		var obj = eval('(' + returnObj + ')');  //转换json
//		var parentId = obj.itemDetail.parentUnitId;
//		var itemId = obj.itemDetail.unitId;
//		var itemText = obj.itemDetail.unitName;
//		//tree.insertNewItem(parentId,itemId,itemText);
//		tree.refreshItem(parentId);
//	}
}
function addOrgCallback(returnValue){
	if (returnValue){
		if(checkFlag == "0"){
			var obj = eval('(' + returnValue + ')');  //转换json
			var parentId = obj.itemDetail.parentUnitId;
			var itemId = obj.itemDetail.unitId;
			var itemText = obj.itemDetail.unitName;	        		
			//tree.insertNewItem(parentId,itemId,itemText);
			tree.refreshItem(parentId);
		}
		if(checkFlag == "1"){
			var obj = eval('(' + returnValue + ')');  //转换json
			var itemId = obj.itemDetail.unitId;
			var newLabel = obj.itemDetail.unitName;
			var newTooltip = obj.itemDetail.unitName;	        		
			tree.setItemText(itemId,newLabel,newTooltip);
		}
		alert(SAVE_OK);
	}   		      					
}
/*
 * 修改
 * */
function updateOrg(){
	if(!tree.getSelectedItemId()){
		alert(UNIT_SELECT_NODE_FIRST);
		return;
	}
	//sendPara.unitId = tree.getSelectedItemId();
	//sendPara.flag = 1; // 0 为新增保存；1为修改保存
	var sendunitId = tree.getSelectedItemId();
	var itemColor = tree.getItemColor(sendunitId);
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		alert(UNIT_NO_PRIVILEGES);
		return;
	}
	var sendflag = 1; // 0 为新增保存；1为修改保存
	checkFlag = sendflag;
	var sURL = webpath + "/view/organization/unit/UnitDetail.jsp?sendunitId="+sendunitId+"&sendflag="+sendflag;
	//document.getElementById("unitDetailFrame").src=sURL;	
	window.parent.dialogPopup_L2(sURL,"修改组织单元",560,670,true,"save",null,addOrgCallback);
	//jQuery("#unitDetailDialog").dialog('open');

//	var sendPara = new Object();
//	if(!tree.getSelectedItemId()){
//		alert("请选择节点!");
//		return;
//	}
//	sendPara.unitId = tree.getSelectedItemId();
//	sendPara.flag = 1; // 0 为新增保存；1为修改保存
//	var returnObj = window.showModalDialog('./UnitDetail.jsp',sendPara,'dialogWidth=640px;status:no;scroll:no;dialogHeight=460px');
//	if(returnObj){
//		var obj = eval('(' + returnObj + ')');  //转换json
//		var itemId = obj.itemDetail.unitId;
//		var newLabel = obj.itemDetail.unitName;
//		var newTooltip = obj.itemDetail.unitName;
//		//alert("itemId="+itemId);
//	    //tree.refreshItem(itemId);
//	    tree.setItemText(itemId,newLabel,newTooltip);
//	}
}

/*
 * 删除组织
 * */
function delOrg(){
	var unitId = tree.getSelectedItemId();
	if(!unitId){
		alert(UNIT_SELECT_NODE_TO_DELETE);
		return;
	}
	if(unitId == "RootUnit@UNIT"){
		alert(UNIT_NODE_CANT_DELETE);
		return;
	}
	var itemColor = tree.getItemColor(unitId);
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		alert(UNIT_NO_PRIVILEGES);
		return;
	}
	//删除提示
	confirm(PROMPT_CONFIRM_DELETE,function(){
		jQuery.ajax({
			url:webpath + "/UnitAction.do?method=deleteUnit",
			type:"post",
			async : false,
			dataType:"json",
			data:{itemId:unitId},
			success:function(data){
				if(data.errorMessage==null || data.errorMessage==undefined){
					tree.deleteItem(unitId,"");
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
		//debugger;
		//2011年4月12日 wangxy
		//如果父结点是灰的，则需要对子结点的使用状态进行判断
		//如果父结点不是灰的，则所有子结点是可用状态。
		var itemColor = tree.getItemColor(id);
		//通过节点颜色判断是否有操作权限
		if(itemColor.acolor == "#aaaaaa"){
			getSubUnitTreeManageable(id);
		}
		//over
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
	jQuery.ajax({
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
 * 获取组织树
 * */
var nodeId; //组织树 id
function showOrg(){
	var sURL = webpath + "/view/organization/unit/UnitSelect.jsp";
	document.getElementById("unitFrame").src=sURL;				
	jQuery("#unitDialog").dialog('open');	
}

/*
 * 获取上级领导岗位
 * */
function showSta(){
	var sURL = webpath + "/view/organization/unit/StationSelect.jsp";
	document.getElementById("staFrame").src=sURL;				
	jQuery("#staDialog").dialog('open');
}

//点击节点时，判断是否可用
function onClickCheck(){
	var unitId = tree.getSelectedItemId();
	var itemColor = tree.getItemColor(unitId);
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		jQuery("#btnAdd").attr('disabled',true);
		jQuery("#btnUpdate").attr('disabled',true);
		jQuery("#btnDel").attr('disabled',true);
	}else{
		jQuery("#btnAdd").attr('disabled',false);
		jQuery("#btnUpdate").attr('disabled',false);
		jQuery("#btnDel").attr('disabled',false);
		//var classString = jQuery("#btnDel").attr("class");
		//可能存在bug，样式会不断变长
		//jQuery("#btnDel").attr("class",classString +"ui-button ui-widget ui-state-default ui-corner-all");

	}
	//点击根节点时，删除按钮置灰
	var selectedItemId = tree.getSelectedItemId();
	if(selectedItemId == "RootUnit@UNIT"){
		jQuery("#btnDel").attr('disabled',true);
	}
}