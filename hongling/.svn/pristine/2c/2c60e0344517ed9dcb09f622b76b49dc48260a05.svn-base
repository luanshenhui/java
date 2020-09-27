jQuery.csMemberMenusQorder={
		divGroupMenu : "MemberQorderMenus",
		MemberID:"",
		bindLabel:function(){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_AUTHORITY_MANAGER),null,".list_search h1");
//			$.csCore.getValue("Button_Submit",null,"#btnSaveMemberMenus");
		},
		bindEvent:function(){
			$("#btnSaveMemberMenus").click($.csMemberMenusQorder.saveMemberMenus);
		},
		fillFormMenu:function(){
			$("#qordermenus").html("");
			var setting = {
				check:{
					enable: true,
	                chkboxType: { "Y" : "ps", "N" : "s" }
				},
				data:{
					simpleData: {enable: true}
				},
				view:{
					showIcon:false
	            },
	            callback: {
	                onClick: $.csMemberMenusQorder.onClick
	            }
			};

		    var allFunctions = $.csCore.invoke($.csCore.buildServicePath('/service/groupmenu/getallfunctionsqorder'));
		    
			var param = $.csControl.appendKeyValue("","memberid",$.csMemberMenusQorder.MemberID);
			param = $.csControl.appendKeyValue(param,"flag","qorder");
		    var groupFunctions = $.csCore.invoke($.csCore.buildServicePath('/service/member/getmemberfunctions'),param);
		    var nodes = [];
		    for(var i=0;i<allFunctions.length;i++){
		    	var checked=false;
		    	if($.csCore.contain(groupFunctions,allFunctions[i].id.toString())){
		    		checked = true;
		    	}
				var node = { id: allFunctions[i].id, pId: allFunctions[i].parentid, name: allFunctions[i].name, checked:checked};
	            nodes.push(node);
		    }

	        $.fn.zTree.init($("#qordermenus"), setting, nodes);
	    },
	    onClick: function (event, treeId, treeNode, clickFlag) {
	        var zTree = $.fn.zTree.getZTreeObj("qordermenus");
	        zTree.expandNode(treeNode);
	    },
		saveMemberMenus:function(){
			var treeObj = $.fn.zTree.getZTreeObj("qordermenus");
			var nodes = treeObj.getCheckedNodes(true);
			var menus="";
			$.each(nodes,function(i,dd){
				menus+=dd.id+",";
			});
			var url = $.csCore.buildServicePath('/service/member/savemembermenu');
			var param = $.csControl.appendKeyValue("","memberid",$.csMemberMenusQorder.MemberID);
			param = $.csControl.appendKeyValue(param,"menus",menus);
			param = $.csControl.appendKeyValue(param,"flag","qorder");
			var datas = $.csCore.invoke(url,param);
			$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
		},
		init:function(id,name){
			$.csMemberMenusQorder.MemberID = id;
			$("#memberName").html(name);
			$.csMemberMenusQorder.bindLabel();
			$.csMemberMenusQorder.bindEvent();
			$.csMemberMenusQorder.fillFormMenu();
		}
	}