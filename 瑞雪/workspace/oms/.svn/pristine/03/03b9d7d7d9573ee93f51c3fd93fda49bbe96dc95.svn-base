var tree;
$(document).ready(function(){
	$('body').bind('keydown',shieldCommon);
//	$("#splitter").jsplit({ 
//		MaxW:"300px"//设置最大宽度
//        ,MinW:"90px"//设置最小宽度
//        ,FloatD:"left"//设置块浮动方向
//        ,IsClose:false//设置初始状态
//        ,BgUrl:"url(" + "/view/base/theme/css/redmond/jsplit/image/sp_bg.gif)"//设置分隔条背景图片地址
//        ,Bg:"right 0 repeat-y"//设置分隔条背景图片position,颜色等
//        ,Btn:{btn:false//是否显示上下按钮 false为不显示
//             ,oBg:{Out:"0 0",Hover:"-6px 0"}//设置打开状态时候按钮背景：鼠标离开(默认)，经过
//             ,cBg:{Out:"-12px 0",Hover:"-18px 0"}}//设置打开状态时候按钮背景：鼠标离开(默认)，经过
//        ,Fn:function(){}//拖动，点击分隔条时候触发的方法
//	});
	
	tree =new dhtmlXTreeObject(document.getElementById("orgTree"),"100%","100%",0);
    tree.setImagePath("/csh_books/");
    //tree.enableCheckBoxes(true);
    tree.attachEvent("onClick",selectSta);
    tree.setOnOpenEndHandler(checkSubNodes);  //解决节点请求回来无法展开
	tree.setOnMouseInHandler(beforeOpenNode);
    tree.setXMLAutoLoading("/unit/getSubUnitTree.action"); 
	tree.loadXML("/unit/getUnitTree.action");	
	tree.openItem("RootUnit@UNIT");
	
    getUnitTreeManageable();
    selectSta();
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
		getSubUnitTreeManageable(id);
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

function save(){
	var returnValue;
	var itemId = staTree.getSelectedItemId();
    if(itemId ==""){
        window.top.window.showModalAlert("请选择一个岗位");
		return returnValue = "false";
	}else{
	var itemText = staTree.getItemText(itemId);
	var returnObj = new Object();
	returnObj.itemId = itemId;
	returnObj.itemText = itemText;
	returnValue = returnObj;
	return returnValue;
	}
	//window.returnValue = returnObj;
	//window.close();
}

/*
 * 点击获取领导岗位
 * */
var staTree;
function selectSta(){
	//document.getElementById("staTree").innerHTML = ""; //清空原来div下的tree
	$("#staTree").empty();  // jquery 清空原来div下的tree
	var unitId = tree.getSelectedItemId();

	staTree =new dhtmlXTreeObject("staTree","100%","100%",0);
	staTree.setImagePath("/csh_books/");
	//staTree.enableTreeLines(false); //不显示树线
	//tree.enableCheckBoxes(true);
    //tree.attachEvent("onclick",selectSta);
	staTree.loadXML("/station/getStationInUnit.action?unitId="+unitId);
	window.setTimeout(function() {
		//staTree.closeAllItems(0);
	}, 0);
}