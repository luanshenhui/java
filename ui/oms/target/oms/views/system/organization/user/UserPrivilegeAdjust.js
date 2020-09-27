var tree;
$(document).ready(function(){
	$('body').bind('keydown',shieldCommon);
	//处理传入的参数
	//obj = window.dialogArguments;// 定义一个对象用于接收对话框参数
	//处理树
	tree =new dhtmlXTreeObject("menuTree","100%","100%",0);
    tree.setImagePath(webpath+"/view/base/theme/css/redmond/dhtmlxtree/image/DhtxTree/csh_books/");
    tree.enableCheckBoxes(true);
    //tree.attachEvent("onClick",HandleMClk1);
	tree.setOnMouseInHandler(beforeOpenNode);
	tree.setOnOpenEndHandler(checkSubNodes);
	tree.setOnCheckHandler(nodeCheckHandler);
	
	tree.loadXML(webpath+"/MenuAction.do?method=getMenuTree");
	tree.setXMLAutoLoading(webpath+"/MenuAction.do?method=getElementsByMenuItemID");
	//把树全展开
	tree.openAllItems(null);
	
	//根据当前选择的（角色、组织、岗位）来获取它对于资源的访问性
	requestPrivilegeAndDrawTree(userID, "user");
	
	//初始化addList和delList里的数据。
	addList = new ArrayList();
	delList = new ArrayList();
	// document.getElementById("userName").innerText=userFullName+"权限调整";
});

/**
 * 树结点点击事件处理
 * @return
 */
function nodeCheckHandler(id,state){
	//state：1是选中，0是未选中
	if (state == "1" || state == 1){
		if(delList.contains(id))
			delList.remove(id);
		else if(!addList.contains(id))
			addList.add(id);
	} else {
		if(addList.contains(id))
			addList.remove(id);
		else if(!delList.contains(id))
			delList.add(id);
	}
}


/**
 * 根据类型获取权限，并且给权限树打挑
 * @return
 */
function requestPrivilegeAndDrawTree(id,type){
	var sURL1 = webpath + "/PrivilegeAction.do?method=getPageElementPrivilege";
	$.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		data : {
			type : type,
			id : id,
			isAdminRole : "false"
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//根据资源授权情况，在树上选中结点
				for(var k in data.authMap) {
				  tree.setCheck(k,1);
				}
				//tree.enableThreeStateCheckboxes(true);
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert("操作失败，可能是网络原因");
			// 通常 textStatus 和 errorThrown 之中 
		    // 只有一个会包含信息 
		    //this;  调用本次AJAX请求时传递的options参数
		}
	});
}

/**
 * 打开一个结点以前，先检查一下结点下面是否有子结点，用于动态加载子结点后，设置check状态
 * @return
 */
function beforeOpenNode(id){
	//alert(id);
	//alert(state);
	beforeOpenSubNodes = tree.hasChildren(id);
	//alert(beforeOpenSubNodesCount);
	return true;
}
/**
 * 当用ajax打开子结点后，取这些子结点的check状态
 * @return
 */
function checkSubNodes(id,state){
	//alert(beforeOpenSubNodes);
	//alert(tree.hasChildren(id));
	//alert(state);
	//beforeOpenSubNodes = 0;
	//当点击的结点是子结点时才取
	if (beforeOpenSubNodes == 0 && state <= 0){
		var sURL1 = webpath + "/PrivilegeAction.do?method=getPageElementPrivilege";
		$.ajax( {
			url : sURL1,
			type : "post",
			dataType : "json",
			data : {
				type : "user",
				//id : obj.userID,
				id : userID,
				isAdminRole : "false",
				menuID : id
			},
			success : function(data) {
				if(data.errorMessage == undefined){
					//根据资源授权情况，在树上选中结点
					for(var k in data.authMap) {
					  tree.setCheck(k,1);
					}
					//tree.enableThreeStateCheckboxes(true);
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = webpath + "/login.jsp";
					else
						alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("操作失败，可能是网络原因");
				// 通常 textStatus 和 errorThrown 之中 
			    // 只有一个会包含信息 
			    //this;  调用本次AJAX请求时传递的options参数
			}
		});
	}
		
	return true;
}

/**
 * 支持单选和多选、带岗位和不带岗位。
 * @return 如果是单选返回选定的itemId和itemText，如果是多选，返回itemIds和itemTexts
 * 注意：对于带岗位模式，不管是单选，还是多选，返回的id里，都带@UNIT或者@STATION用以区别类型
 */
function save(){
	var returnObj = new Object();
	
//	//获取所有选中的menu结点的id
//	var itemIds = tree.getAllCheckedBranches();
//	if (itemIds.length <= 0){
//		returnObj.itemIds = "";
//		returnObj.itemTexts = "";
//		window.returnValue = returnObj;
//		window.close();
//	}
//	//如果最后一个字符是“,”则把它去掉
//	if(itemIds.substring(itemIds.length -1,itemIds.length) == ",")
//		itemIds = itemIds.substring(0,itemIds.length-1);
//
//	//把id字符串转成数组
//	var itemIdArray = itemIds.split(",");
//	var itemTexts = "";
//	for (i=0;i<itemIdArray.length;i++)
//	{
//		if (itemIdArray[i] == "")
//			break;
//		itemTexts += tree.getItemText(itemIdArray[i]);
//		if(i < itemIdArray.length-1)
//			itemTexts += ",";
//	}
//	returnObj.itemIds = itemIds;
//	returnObj.itemTexts = itemTexts;
	
	if(addList.length <= 0 && delList.length <= 0) {
		window.parent.alert("数据没有改变");
		return;
	}

	//保存用户权限
	var returnValue;
	var sURL1 = webpath + "/PrivilegeAction.do?method=savePrivileges";
	$.ajax( {
		url : sURL1,
		type : "post",
		async: false,
		dataType : "json",
		data : {
			type : "user",
			//id : obj.userID,
			id : userID,
			resIDs4Add: addList.toArray().toString(),
			resIDs4Del: delList.toArray().toString(),
			isAdminRole : "false"
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				window.parent.alert("保存成功");
				//window.returnValue = returnObj;
				returnValue = returnObj;
				//window.close();
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					window.parent.alert(data.errorMessage);
				
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			window.parent.alert("操作失败，可能是网络原因");
			// 通常 textStatus 和 errorThrown 之中 
		    // 只有一个会包含信息 
		    //this;  调用本次AJAX请求时传递的options参数
		}
	});
	return returnValue;
}