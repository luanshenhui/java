jQuery.csMemberMenus={
		divGroupMenu : "MemberMenus",
		MemberID:"",
		bindLabel:function(){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_AUTHORITY_MANAGER),null,".list_search h1");
			$.csCore.getValue("Button_Submit",null,"#btnSaveMemberMenus");
		},
		bindEvent:function(){
			$("#btnSaveMemberMenus").click($.csMemberMenus.saveMemberMenus);
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
	                onClick: $.csMemberMenus.onClick
	            }
			};

		    var allFunctions = $.csCore.invoke($.csCore.buildServicePath('/service/groupmenu/getallfunctions'));
		    
			var param = $.csControl.appendKeyValue("","memberid",$.csMemberMenus.MemberID);
		    var groupFunctions = $.csCore.invoke($.csCore.buildServicePath('/service/member/getmemberfunctions'),param);
		    var nodes = [];
		    for(var i=0;i<allFunctions.length;i++){
		    	var checked=false;
		    	if($.csCore.contain(groupFunctions,allFunctions[i].ID.toString())){
		    		checked = true;
		    	}
				var node = { id: allFunctions[i].ID, pId: allFunctions[i].parentID, name: allFunctions[i].name, checked:checked};
	            nodes.push(node);
		    }

	        $.fn.zTree.init($("#menus"), setting, nodes);
	    },
	    onClick: function (event, treeId, treeNode, clickFlag) {
	        var zTree = $.fn.zTree.getZTreeObj("menus");
	        zTree.expandNode(treeNode);
	    },
		saveMemberMenus:function(){
			var treeObj = $.fn.zTree.getZTreeObj("menus");
			var nodes = treeObj.getCheckedNodes(true);
			var menus="";
			$.each(nodes,function(i,dd){
				menus+=dd.id+",";
			});

			var url = $.csCore.buildServicePath('/service/member/savemembermenu');
			var param = $.csControl.appendKeyValue("","memberid",$.csMemberMenus.MemberID);
			param = $.csControl.appendKeyValue(param,"menus",menus);
			var datas = $.csCore.invoke(url,param);
			$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
		},
		init:function(id,name){
			$.csMemberMenus.MemberID = id;
			$("#memberName").html(name);
			$.csMemberMenus.bindLabel();
			$.csMemberMenus.bindEvent();
			$.csMemberMenus.fillFormMenu();
		}
	}