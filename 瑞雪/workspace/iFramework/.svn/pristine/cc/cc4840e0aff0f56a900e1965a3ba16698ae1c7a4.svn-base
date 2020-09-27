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
		//var nodes = treeNode.children;
		//getSelectList(nodes);
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
//	
//	var zNodes = [ {
//		id : 1,
//		pId : 0,
//		name : "组织机构",
//		type : 0,
//		open : true,
//		iconOpen : webpath + "/view/common/css/zTreeStyle/img/diy/1_open.png",
//		iconClose : webpath + "/view/common/css/zTreeStyle/img/diy/1_close.png"
//	}, {
//		id : 111,
//		pId : 1,
//		name : "父节点11 - 折叠",
//		type : 1,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/2.png"
//	}, {
//		id : 10,
//		pId : 111,
//		name : "admin",
//		type : 0,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/3.png"
//	}, {
//		id : 11,
//		pId : 111,
//		name : "张三",
//		type : 0,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/3.png"
//	}, {
//		id : 12,
//		pId : 111,
//		name : "李四",
//		type : 0,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/3.png"
//	}, {
//		id : 13,
//		pId : 111,
//		name : "王五",
//		type : 0,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/3.png"
//	}, {
//		id : 14,
//		pId : 111,
//		name : "赵六",
//		type : 0,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/3.png"
//	}, {
//		id : 16,
//		pId : 111,
//		name : "测试角色",
//		type : 1,
//		icon : webpath + "/view/common/css/zTreeStyle/img/diy/3.png"
//	}, {
//		id : 15,
//		pId : 1,
//		name : "父节点12 - 折叠",
//		type : 1
//	}, {
//		id : 121,
//		pId : 15,
//		name : "叶子节点121",
//		type : 2
//	}, {
//		id : 122,
//		pId : 15,
//		name : "叶子节点122",
//		type : 2
//	}, {
//		id : 123,
//		pId : 15,
//		name : "叶子节点123",
//		type : 2
//	}, {
//		id : 124,
//		pId : 15,
//		name : "叶子节点124",
//		type : 2
//	}, {
//		id : 16,
//		pId : 1,
//		name : "父节点13 - 没有子节点",
//		type : 1,
//		isParent : true
//	}, {
//		id : 2,
//		pId : 0,
//		name : "父节点2 - 折叠",
//		type : 0
//	}, {
//		id : 21,
//		pId : 2,
//		name : "父节点21 - 展开",
//		type : 0,
//		open : true
//	}, {
//		id : 211,
//		pId : 21,
//		name : "叶子节点211",
//		type : 2
//	}, {
//		id : 212,
//		pId : 21,
//		name : "叶子节点212",
//		type : 2
//	}, {
//		id : 213,
//		pId : 21,
//		name : "叶子节点213",
//		type : 2
//	}, {
//		id : 214,
//		pId : 21,
//		name : "叶子节点214",
//		type : 2
//	}, {
//		id : 22,
//		pId : 2,
//		name : "父节点22 - 折叠",
//		type : 0
//	}, {
//		id : 221,
//		pId : 22,
//		name : "叶子节点221",
//		type : 2
//	}, {
//		id : 222,
//		pId : 22,
//		name : "叶子节点222",
//		type : 2
//	}, {
//		id : 223,
//		pId : 22,
//		name : "叶子节点223",
//		type : 2
//	}, {
//		id : 224,
//		pId : 22,
//		name : "叶子节点224",
//		type : 2
//	}, {
//		id : 23,
//		pId : 2,
//		name : "父节点23 - 折叠",
//		type : 0
//	}, {
//		id : 231,
//		pId : 23,
//		name : "叶子节点231",
//		type : 2
//	}, {
//		id : 232,
//		pId : 23,
//		name : "叶子节点232",
//		type : 2
//	}, {
//		id : 233,
//		pId : 23,
//		name : "叶子节点233",
//		type : 2
//	}, {
//		id : 234,
//		pId : 23,
//		name : "叶子节点234",
//		type : 2
//	}, {
//		id : 3,
//		pId : 0,
//		name : "角色1",
//		type : 1,
//		isParent : true,
//		open : true
//	} ];
	jQuery.fn.zTree.init($("#treeDemo"), setting, zNodes);

	if (document.all) {
		document.getElementById("delete").label = "<<<";
	}
	var operation;
	if (document.forms[0].operation) {
		operation = document.forms[0].operation.value;
	}
	if (operation == "ok") {
		if (parent.refresh) {
			parent.refresh();
			parent.closeDialog();
			return;
		}
		// 兼容在V4下展现
		for ( var i = 0; i < parent.frames.length; i++) {
			var frame = parent.frames[i];
			if (frame.refresh) {
				frame.refresh();
				unieap.getDialog().close();
				break;
			}
		}
	}
});

function ok_onclick() {
	var unitValue = "";
	var signers = "";

	var selector = document.forms[0].assignTo;
	var length = selector.length;
	for ( var i = 0; i < length; i++) {
		eval("selector.options[" + i + "].selected = true");
		
		var selText = selector[i].innerHTML;
		var selValue = selector[i].value;
		unitValue = selText + "," + selValue + ";";
		signers += unitValue;
	}

	var signType = document.forms[0].signType.value;

	if (length > 0) {
		document.forms[0].operation.value = "update";

		var sURL = webpath + "/WorkitemManagementAction.do?method=doAddSigner";
		// 调用AJAX请求函数
		jQuery.ajax({
			url : sURL,
			async : false,
			type : "get",
			dataType : "json",
			data : "signers=" + signers + "&signType=" + signType +"&workitemId=" + currWorkitemId,
			success : function(data) {
				if (data.errorMessage)
					alert(data.errorMessage);
				else {
					alert(data.info);
					window.close();
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				if (data.errorMessage)
					alert(data.errorMessage);
				else
					alert("操作不成功。");
			}
		});

	} else {
		document.getElementById("warning").innerHTML = "没有人员被选中！";
		document.getElementById("warning").style.display = "";
		return;
	}
}

function cancel_onclick() {
	parent.returnValue = false;
	parent.closeDialog();
}

function on_load() {

}

function check_select() {
	var selected = document.forms[0].selected;
	return (typeof (selected) != "undefined" && selected.value != "");
}

function addReassign() {
	addSelect(document.forms[0].assignTo);
}

function removeReassign() {
	removeSelect(document.forms[0].assignTo);
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
		var optionValue = item.id;
		var partName = item.name;

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
	// var actorSelect = treeObj.getSelectedNodes();
	
	var length = select.length;
	for ( var i = 0; i < length; i++) {
		var selected = eval("select.options[" + i + "].selected");
		if (selected) {
			// actorSelect.uncheck(eval("select.options[" + i + "].value"));
			eval("select.options[" + i + "]=null");
			length--;
			i--;
		}
	}

	document.getElementById("warning").style.display = "none";
}