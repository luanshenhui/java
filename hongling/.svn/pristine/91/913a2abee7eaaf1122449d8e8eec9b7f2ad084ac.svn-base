jQuery.csStyleTree = {
	divGroupMenu : "StyleTree",
	ClothID : "",
	bindLabel : function() {
		// $.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_AUTHORITY_MANAGER),null,".list_search
		// h1");
		// $.csCore.getValue("Button_Submit",null,"#btnSaveStyleTree");
	},
	bindEvent : function() {
		$("#btnSaveStyleTree").click(/* $.csStyleTree.saveStyleTree */);
	},
	fillStyles : function() {
		var zTree1;
		var setting;

		setting = {
			checkable : true,
			checkStyle : "radio",
			checkRadioType : "level",
			callback : {
				change : zTreeOnChange
			}
		};

		$(document).ready(function() {
			refreshTree();
		});

		function zTreeOnChange(event, treeId, treeNode) {
			getCheckedNodesLength();
		}

		function getRadioType() {
			var level = $("#level").attr("checked") ? "level" : "";
			var all = $("#all").attr("checked") ? "all" : "";

			return level + all;
		}

		function refreshTree() {
			setting.checkRadioType = getRadioType();
			zTree1 = $("#treeDemo").zTree(setting, zNodes);
			$("#checkRadioTypeCode").html(setting.checkRadioType);
			getCheckedNodesLength();
		}

		function getCheckedNodesLength() {
			var tmp = zTree1.getCheckedNodes(true);
			$("#checkedNum").html(tmp.length);
		}

		var allStyles = $.csCore
				.invoke($.csCore
						.buildServicePath('/service/assemble/getAssembleStyle?id='
								+ id));
	},

	fillFormMenu : function(id) {
		$("#styles").html("");
		var setting = {
			check : {
				enable : true,
				// 选中影响 父、子，取消只影响子节点
				chkboxType : {
					"Y" : "ps",
					"N" : "s"
				}
			},

			data : {
				simpleData : {
					enable : true
				}
			},
			view : {
				showIcon : false
			},
			callback : {
				onClick : $.csStyleTree.onClick,
				onCheck : $.csStyleTree.onCheck
			}
		};
		var groupFunctions = null;
		if (id == null || id == "") {
			id = $('#clothingID').val();
		} else {
			var assemble = $.csAssemblePost.getAssembleByID(id);
			groupFunctions = assemble.process;
			id = assemble.clothingID;
		}
		var allStyles = $.csCore
				.invoke($.csCore
						.buildServicePath('/service/assemble/getAssembleStyle?id='
								+ id));
		// var groupFunctions = $.csCore.invoke($.csCore
		// .buildServicePath('/service/member/getmemberfunctions'), param);
		var nodes = [];
		for ( var i = 0; i < allStyles.length; i++)

		{
			var checked = false;
			if (null != groupFunctions && $.csCore.contain

			(groupFunctions, allStyles[i].ID

			.toString())) {
				checked = true;
			}
			var node = {

				id : allStyles[i].ID,
				pId : allStyles[i].PARENTID,
				name : allStyles[i].NAME,
				checked : checked,
				statusID : allStyles[i].STATUSID,
				isSingleCheck : allStyles[i].ISSINGLECHECK

			};
			nodes.push(node);
			// for ( var j = 0; j < nodes.length; j++) {
			// if (nodes[i].checked) {
			// var currnode = nodes[i];
			// }
			// }
		}
		$.fn.zTree.init($("#styles"), setting, nodes);
	},

	onClick : function(event, treeId, treeNode, clickFlag) {

		var zTree = $.fn.zTree.getZTreeObj("styles");
		zTree.expandNode(treeNode);
	},
	// 验证 最底级的 不能复选
	onCheck : function(event, treeId, treeNode) {

		if (!treeNode.isParent) {
			/** 满足以下条件的只能单选 */
			if (treeNode.statusID == 10001
					|| (treeNode.getParentNode().statusID == 10002 && treeNode
							.getParentNode().isSingleCheck == 10050)) {

				// // alert("验证" + treeNode.name + "__**__" + treeId);
				if (!$.csStyleTree.validationChkBox(treeNode)) {
					$.csCore.alert("此类工艺不能复选");
					treeNode.checked = false;
				}
				;

			}

		}
	},
	/** 复选框信息验证 */
	validationChkBox : function(obj) {
		var nodes = obj.getParentNode().children;
		var checkedCount = 0;

		for ( var i = 0; i < nodes.length; i++) {
			if (nodes[i].checked) {
				checkedCount++;
			}
			if (checkedCount >= 2) {
				var temp = nodes[i].getParentNode();
				var str = "";
				while (null != temp.getParentNode()) {
					str = "-" + temp.name + str;
					temp = temp.getParentNode();
				}
				$.csCore.alert(str.substring(1, str.length) + " 只能选一项");
				return false;
			}
		}
		return true;

	},
	saveStyleTree : function() {

		var treeObj = $.fn.zTree.getZTreeObj("styles");
		var nodes = treeObj.getCheckedNodes(true);
		var styles = "";
		$.each(nodes, function(i, dd) {
			styles += dd.id + ",";
		});
		// for ( var i = 0; i < nodes.length; i++) {
		// // 只存末节点处理
		// if (!nodes[i].isParent) {
		// styles += nodes[i].id + ",";
		// }
		// }
		alert("保存 的工艺信息是:");
		var url = $.csCore.buildServicePath('/service/member/savemembermenu');
		var param = $.csControl.appendKeyValue("", "clothid",
				$.csStyleTree.ClothID);
		param = $.csControl.appendKeyValue(param, "styles", styles);
		var datas = $.csCore.invoke(url, param);
		$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
	},
	init : function(id, name) {

		var clothid = $('#clothingID').val();
		$.csStyleTree.ClothID = id;
		// $("#memberName").html(name);
		$.csStyleTree.bindLabel();
		$.csStyleTree.bindEvent();
		$.csStyleTree.fillFormMenu(id);
	}
}