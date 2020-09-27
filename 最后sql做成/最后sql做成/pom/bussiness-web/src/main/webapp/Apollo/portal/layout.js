var zTreeNodes;
var setting = {
		check : {
			enable : true
		},
		data : {
			simpleData : {
				enable : true
			}
		},
		callback: {
			onClick: zTreeOnClick,
			onRightClick: zTreeOnRightClick,
			beforeClick: function(treeId, treeNode) {
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				if (treeNode.isParent) {
					zTree.expandNode(treeNode);
					return false;
				} else {
					return true;
				}
			}
		},
		view: {
			dblClickExpand: false,
			showLine: true,
			selectedMulti: false
		}
};
var zNodes;
//权限树点击事件
function zTreeOnClick(event, treeId, treeNode) {
	var view = treeNode.targetUrl;
	if(treeNode.id === 10020  || treeNode.id === 16000 ||treeNode.id === 10025 || treeNode.id ===13847 || treeNode.id ===30074 ){
		 window.open(view);
	}else{
		//增加一个tab面板 
		if(treeNode.isView === 1){
			var t = $('#index_centerTabs');
			//t.tabs("loading","ddd");
			if (t.tabs('exists', treeNode.name)) {
				t.tabs('select', treeNode.name);
				var current_tab = t.tabs('getSelected'); 
				t.tabs('update',{  
				     tab:current_tab,  
				     options : {  
				    	title:treeNode.name, 
						content : '<iframe src="' + view + '" frameborder="0" style="border:0;width:100%;height:99%;"></iframe>', 
						closable:true 
				     }  
				});  
			} else {
				t.tabs('add', { 
					title:treeNode.name, 
					content : '<iframe src="' + view + '" frameborder="0" style="border:0;width:100%;height:99%;"></iframe>', 
					closable:true 
				});
			}
		}
	}
};
function zTreeOnRightClick(event, treeId, treeNode) {
	var view = treeNode.targetUrl;
	if(treeNode.isView === 1){
		 window.open(view);
	}
}
function showRMenu(type, x, y) {
	alert("type:" + type);
	$("#rMenu ul").show();
	if (type=="root") {
		$("#m_del").hide();
		$("#m_check").hide();
		$("#m_unCheck").hide();
	}
	$("#rMenu").css({"top":y+"px", "left":x+"px", "visibility":"visible"});
}
function hideRMenu() {
	if (rMenu) rMenu.style.visibility = "hidden";
}
$(function(){
	var data = menuData;
	zNodes =  data;
	zTreeNodes = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
	
	rMenu = document.getElementById("rMenu");
	$("body").bind("mousedown", 
		function(event){
			if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
				rMenu.style.visibility = "hidden";
			}
	});
});

function initLeft(){
	var cookieUserName = miniCookie.getCookie("ssoUserName");
	var args = {
		'userName':cookieUserName
	};
	GetData('user','prsuser', 'PrsPrivilege', args);
	$('#index_tree').tree({//manage/privilege.htm data/tree.json
		url : 'js/menu.json',
		parentField : 'pid',
		lines : true,
		onClick : function(node) {
			//增加一个tab面板 
			var t = $('#index_centerTabs');
			if (t.tabs('exists', node.text)) {
				t.tabs('select', node.text);
				var tab = t.tabs('getSelected');
				t.tabs('update', { 
					title:node.text, 
					content : '<iframe src="' + node.text + '" frameborder="0" style="border:0;width:100%;height:99%;"></iframe>', 
					closable:true 
				});
			} else {
				t.tabs('add', { 
					title:node.text, 
					content : '<iframe src="' + node.text + '" frameborder="0" style="border:0;width:100%;height:99%;"></iframe>', 
					closable:true 
				});
			}
		}
	});
}
function PrsPrivilegeSuccess(obj) {
	if (obj.result == 1) {
		zTreeNodes=$.fn.zTree.init($("#treeDemo"), setting, data);
	}else{
	    //$.messager.alert('提示',obj.resultMessage,'info');
	}
}
function PrsPrivilegeError(obj) {
    $.messager.alert('提示',obj,'info');
}
