jQuery.csGroupMenuListDict1={
		divGroupMenu : "GroupMenu",
		bindLabel:function(){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_AUTHORITY_MANAGER),null,".list_search h1");
			$.csCore.getValue("Button_Submit",null,"#btnSaveGroupMenu");
		},
		bindEvent:function(){
			$("#btnSaveGroupMenu").click($.csGroupMenuListDict1.saveGroupMenu);
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
	                onClick: $.csGroupMenuListDict1.onClick
	            }
			};
			var urlAllFunctions = $.csCore.buildServicePath('/service/groupmenu/getallfunctionsqorder');
		    var allFunctions = $.csCore.invoke(urlAllFunctions);
		    
		    var urlGroupFunctions = $.csCore.buildServicePath('/service/groupmenu/getqgroupfunctions');
			var paramGroupFunctions = $.csControl.appendKeyValue("","groupid",groupid);
		    var groupFunctions = $.csCore.invoke(urlGroupFunctions,paramGroupFunctions);
		    var nodes = [];
		    for(var i=0;i<allFunctions.length;i++){
		    	var checked=false;
		    	if($.csCore.contain(groupFunctions,allFunctions[i].id.toString())){
		    		checked = true;
		    	}
				var node = { id: allFunctions[i].id, pId: allFunctions[i].parentid, name: allFunctions[i].name, checked:checked};
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
			$.csGroupMenuListDict1.fillFormMenu($("input[name='groupID']:checked").val());
			$("input[name='groupID']").click(function(){$.csGroupMenuListDict1.fillFormMenu($(this).val());});
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
			param = $.csControl.appendKeyValue(param,"flag","qorder");
			var datas = $.csCore.invoke(url,param);
			$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
		},
		init:function(){
			$.csGroupMenuListDict1.bindLabel();
			$.csGroupMenuListDict1.bindEvent();
			$.csGroupMenuListDict1.fillFormGroup();
		}
	}