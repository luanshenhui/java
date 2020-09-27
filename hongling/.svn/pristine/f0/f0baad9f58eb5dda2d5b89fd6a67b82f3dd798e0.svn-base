jQuery.csGroupMenuList={
		divGroupMenu : "GroupMenu",
		bindLabel:function(){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_AUTHORITY_MANAGER),null,".list_search h1");
			$.csCore.getValue("Button_Submit",null,"#btnSaveGroupMenu");
		},
		bindEvent:function(){
			$("#btnSaveGroupMenu").click($.csGroupMenuList.saveGroupMenu);
		},
		fillFormMenu:function(groupid){
			$("#groupMenu").html("");
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
	                onClick: $.csGroupMenuList.onClick
	            }
			};
			var urlAllFunctions = $.csCore.buildServicePath('/service/groupmenu/getallfunctions');
		    var allFunctions = $.csCore.invoke(urlAllFunctions);
		    
		    var urlGroupFunctions = $.csCore.buildServicePath('/service/groupmenu/getgroupfunctions');
			var paramGroupFunctions = $.csControl.appendKeyValue("","groupid",groupid);
		    var groupFunctions = $.csCore.invoke(urlGroupFunctions,paramGroupFunctions);
		    var nodes = [];
		    for(var i=0;i<allFunctions.length;i++){
		    	var checked=false;
		    	if($.csCore.contain(groupFunctions,allFunctions[i].ID.toString())){
		    		checked = true;
		    	}
				var node = { id: allFunctions[i].ID, pId: allFunctions[i].parentID, name: allFunctions[i].name, checked:checked};
	            nodes.push(node);
		    }

	        $.fn.zTree.init($("#groupMenu"), setting, nodes);
	    },
	    onClick: function (event, treeId, treeNode, clickFlag) {
	        var zTree = $.fn.zTree.getZTreeObj("groupMenu");
	        zTree.expandNode(treeNode);
	    },
		fillFormGroup:function(){
			$.csControl.fillRadios("group",$.csCore.getDicts(DICT_CATEGORY_MEMBER_GROUP),"groupID", "ID" , "name");
			$.csGroupMenuList.fillFormMenu($("input[name='groupID']:checked").val());
			$("input[name='groupID']").click(function(){$.csGroupMenuList.fillFormMenu($(this).val());});
		},
		saveGroupMenu:function(){
			var treeObj = $.fn.zTree.getZTreeObj("groupMenu");
			var nodes = treeObj.getCheckedNodes(true);
			var menus="";
			$.each(nodes,function(i,dd){
				menus+=dd.id+",";
			});

			var url = $.csCore.buildServicePath('/service/groupmenu/savegroupmenu');
			var param = $.csControl.appendKeyValue("","groupid",$("input[name='groupID']:checked").val());
			param = $.csControl.appendKeyValue(param,"menus",menus);
			var datas = $.csCore.invoke(url,param);
			$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
		},
		init:function(){
			$.csGroupMenuList.bindLabel();
			$.csGroupMenuList.bindEvent();
			$.csGroupMenuList.fillFormGroup();
		}
	}