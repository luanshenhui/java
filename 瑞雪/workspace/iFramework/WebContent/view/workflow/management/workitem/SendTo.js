jQuery(document).ready(function(){
	// TODO 设置特送的节点实例数据集
	
	
	// 设置组织树
	var setting = {
		data: {
			key: {
				title:"name"
			},
			simpleData: {
				enable : true,
				idKey : "id",
				pIdKey : "parentId",
				rootPId : '****'
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
//	var zNodes =[
//		 			{ id:1, pId:0, name:"组织机构",type:0, open:true,iconOpen:webpath+"/view/common/css/zTreeStyle/img/diy/1_open.png", iconClose:webpath+"/view/common/css/zTreeStyle/img/diy/1_close.png"},
//		 			{ id:111, pId:1, name:"父节点11 - 折叠",type:1,icon:webpath+"/view/common/css/zTreeStyle/img/diy/2.png"},
//		 			{ id:10, pId:111, name:"admin",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//		 			{ id:11, pId:111, name:"张三",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//		 			{ id:12, pId:111, name:"李四",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//		 			{ id:13, pId:111, name:"王五",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//		 			{ id:14, pId:111, name:"赵六",type:0,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//		 			{ id:16, pId:111, name:"测试角色",type:1,icon:webpath+"/view/common/css/zTreeStyle/img/diy/3.png"},
//		 			{ id:15, pId:1, name:"父节点12 - 折叠",type:1},
//		 			{ id:121, pId:15, name:"叶子节点121",type:2},
//		 			{ id:122, pId:15, name:"叶子节点122",type:2},
//		 			{ id:123, pId:15, name:"叶子节点123",type:2},
//		 			{ id:124, pId:15, name:"叶子节点124",type:2},
//		 			{ id:16, pId:1, name:"父节点13 - 没有子节点",type:1,isParent:true},
//		 			{ id:2, pId:0, name:"父节点2 - 折叠",type:0},
//		 			{ id:21, pId:2, name:"父节点21 - 展开",type:0, open:true},
//		 			{ id:211, pId:21, name:"叶子节点211",type:2},
//		 			{ id:212, pId:21, name:"叶子节点212",type:2},
//		 			{ id:213, pId:21, name:"叶子节点213",type:2},
//		 			{ id:214, pId:21, name:"叶子节点214",type:2},
//		 			{ id:22, pId:2, name:"父节点22 - 折叠",type:0},
//		 			{ id:221, pId:22, name:"叶子节点221",type:2},
//		 			{ id:222, pId:22, name:"叶子节点222",type:2},
//		 			{ id:223, pId:22, name:"叶子节点223",type:2},
//		 			{ id:224, pId:22, name:"叶子节点224",type:2},
//		 			{ id:23, pId:2, name:"父节点23 - 折叠",type:0},
//		 			{ id:231, pId:23, name:"叶子节点231",type:2},
//		 			{ id:232, pId:23, name:"叶子节点232",type:2},
//		 			{ id:233, pId:23, name:"叶子节点233",type:2},
//		 			{ id:234, pId:23, name:"叶子节点234",type:2},
//		 			{ id:3, pId:0, name:"XXX",type:1}
//		 			];
	jQuery.fn.zTree.init($("#treeDemo"), setting, zNodes);

});

// 普送提交
function ok_click() {
	var combo = document.forms[0].sendtos;
	var id = combo.value;
	if (id == null || id == "") {
		document.getElementById("warning").style.display = "";
		return;
	}
	
	var targetActivity = id;

	var sURL = webpath + "/WorkitemManagementAction.do?method=doSend";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "json",
		data : {activityInstId : activityInstId,
				targetActivity : targetActivity
		},
		success : function(data) {
			if (data.errorMessage){
				alert(data.errorMessage);
			} else {
				alert(data.info);
				window.close();
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("特送操作失败。");
		}
	});
}

// 特送提交
function ok_onclick() {
	var m_sendToParts = "";
	var lengthM = document.forms[0].sendToParts.length;
	for ( var i = 0; i < lengthM; i++) {
		eval("document.forms[0].sendToParts.options[" + i + "].selected = true");
		var selValue = document.forms[0].sendToParts[i].value;
		m_sendToParts += selValue + ";";
	}

	var m_copyToParts = "";
	lengthC = document.forms[0].copyToParts.length;
	for ( var i = 0; i < lengthC; i++) {
		eval("document.forms[0].copyToParts.options[" + i + "].selected = true");
		var selValue = document.forms[0].copyToParts[i].value;
		m_copyToParts += selValue + ";";
	}
	
	var combo = document.forms[0].sendtos;
	var id = combo.value;
	if (id == null || id == "" || lengthC < 1 && lengthM < 1) {
		document.getElementById("warning").innerHTML = "您没有选择主送和抄送的人员或者是没有配置特送节点信息！";
		document.getElementById("warning").style.display = "";
		return;
	}
	document.forms[0].sendtoId.value = id;

	var targetActivity = id;

	var sURL = webpath + "/WorkitemManagementAction.do?method=doSendPre";
	// 调用AJAX请求函数
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "json",
		data : {m_sendToParts : m_sendToParts,
				activityInstId : activityInstId,
				m_copyToParts : m_copyToParts,
				targetActivity : targetActivity
		},
		success : function(data) {
			if (data.errorMessage){
				alert(data.errorMessage);
			} else {
				alert(data.info);
				window.close();
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			if (data.errorMessage)
				alert(data.errorMessage);
			else
				alert("特送操作失败。");
		}
	});
}

function cancel_onclick() {
	window.close();
}

function addMainto() {
	addSelect(document.forms[0].sendToParts);
}

function removeMainto() {
	removeSelect(document.forms[0].sendToParts);
}

function addCopyto() {
	addSelect(document.forms[0].copyToParts);
}

function removeCopyto() {
	removeSelect(document.forms[0].copyToParts);
}

function addSelect(select) {
	var length = select.length;
	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	var flag = true;
	var items = treeObj.getSelectedNodes();
	var n = items.length;
	
	for ( var j = 0; j < n; j++) {
		flag = true;
		var item = items[j];
		var optionValue = "";
		var partName = item.name;

		// 1==role==角色
		if (item.type == "1") {
			optionValue = "1," + item.id + "," + item.name;
		} else if (item.type == "0") { // 0==people==人员
			optionValue = "0," + item.id + "," + item.name;
		}

		for ( var i = 0; i < length; i++) {
			var selected = eval("select.options[" + i + "].value");
			if (optionValue == selected) {
				flag = false;
			}
		}
		if (flag) {
			var option = new Option(partName, optionValue);
			flag = true;
			eval("select.options[" + length + "] = option");
			length++;
		}

	}
	document.getElementById("warning").style.display = "none";
}

function removeSelect(select) {
	var actorSelect = null;
	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	
	var length = select.length;
	for ( var i = 0; i < length; i++) {
		var selected = eval("select.options[" + i + "].selected");
		if (selected) {
			eval("select.options[" + i + "]=null");
			length--;
			i--;
		}
	}

	document.getElementById("warning").style.display = "none";
}

function comboClick() {
	document.getElementById("warning").style.display = "none";
}