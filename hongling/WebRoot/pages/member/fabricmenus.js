jQuery.csMemberFabricMenus={
		divGroupMenu : "MemberMenus",
		MemberID:"",
		bindLabel:function(){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_AUTHORITY_MANAGER),null,".list_search h1");
			$.csCore.getValue("Button_Submit",null,"#btnSaveMemberFabircMenus");
		},
		bindEvent:function(){
			$("#btnSaveMemberFabircMenus").click($.csMemberFabricMenus.saveMemberMenus);
		},
		fillFormMenu:function(){
			$("#menus").html("");
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
	                onClick: $.csMemberFabricMenus.onClick
	            }
			};

		    var allFunctions = $.csCore.invoke($.csCore.buildServicePath('/service/groupmenu/getallfabricfunctions'));
		    
			var param = $.csControl.appendKeyValue("","memberid",$.csMemberFabricMenus.MemberID);
		    var groupFunctions = $.csCore.invoke($.csCore.buildServicePath('/service/member/getmemberfabricfunctions'),param);
		    var nodes = [];
		    for(var i=0;i<allFunctions.length;i++){
		    	var checked=false;
		    	if(groupFunctions != null && $.csCore.contain(groupFunctions,allFunctions[i].code.toString())){
		    		checked = true;
		    	}
				var node = { id: allFunctions[i].code, pId: allFunctions[i].categroyid, name: allFunctions[i].code, checked:checked};
	            nodes.push(node);
		    }

	        $.fn.zTree.init($("#fabricmenus"), setting, nodes);
	    },
	    onClick: function (event, treeId, treeNode, clickFlag) {
	        var zTree = $.fn.zTree.getZTreeObj("fabricmenus");
	        zTree.expandNode(treeNode);
	    },
		saveMemberMenus:function(){
			var treeObj = $.fn.zTree.getZTreeObj("fabricmenus");
			var nodes = treeObj.getCheckedNodes(true);
			var menus="";
			$.each(nodes,function(i,dd){
				menus+=dd.id+",";
			});

			var url = $.csCore.buildServicePath('/service/member/savemembermenu');
			var param = $.csControl.appendKeyValue("","memberid",$.csMemberFabricMenus.MemberID);
			param = $.csControl.appendKeyValue(param,"menus",menus);
			param = $.csControl.appendKeyValue(param,"flag","fabric");
			var datas = $.csCore.invoke(url,param);
			$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
		},
		init:function(id,name){
			$.csMemberFabricMenus.MemberID = id;
			$("#memberName").html(name);
			$.csMemberFabricMenus.bindLabel();
			$.csMemberFabricMenus.bindEvent();
			$.csMemberFabricMenus.fillFormMenu();
		}
	};