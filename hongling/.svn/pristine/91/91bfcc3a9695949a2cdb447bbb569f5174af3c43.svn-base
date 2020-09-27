// 款式组合设计的添加 页面
jQuery.csMenus = {
	bindLabel : function() {
		$.csCore.getValue("Button_Submit", null, "#ok");
		$.csCore.getValue("Button_Cancel", null, "#divhide");
	},
	bindEvent : function() {
		// 提交树回写names
		$("#ok").click($.csMenus.backStyles);
		// 点击取消 了隐藏Tree
		$("#divhide").click($.csMenus.treehide);
		// 验证code 唯一性
		$("#code").blur($.csMenus.validateCode);
	},
	/** 提交设计的款式后处理拼接的 款式name */
	backStyles : function() {
		var treeObj = $.fn.zTree.getZTreeObj("styles");
		var nodes = treeObj.getCheckedNodes(true);
		for ( var i = 0; i < nodes.length; i++) {
			if (!nodes[i].isParent) {
				/** 满足以下条件的只能单选 */
				if (nodes[i].statusID == 10001
						|| (nodes[i].getParentNode().statusID == 10002 && nodes[i]
								.getParentNode().isSingleCheck == 10050)) {
					if (!$.csStyleTree.validationChkBox(nodes[i])) {
						return;
					}
				}
			}
		}

		var styleIDS = "";
		var styleName = "";
		$.each(nodes, function(i, dd) {
			if (!dd.isParent) {
				styleIDS += dd.id + ",";
				var obj = dd;
				var str = "";
				while (null != obj.getParentNode()) {
					str = "-" + obj.name + str;
					obj = obj.getParentNode();
				}
				str = str.substring(1, str.length);
				styleName += (str + "\n");
			}
		});
		styleIDS = styleIDS.substring(0, styleIDS.lastIndexOf(","));
		$('#process').val(styleIDS);
		$('#styleTree').val(styleName);
		$.csCore.close();
	},
	/** 点击取消隐藏树 */
	treehide : function() {
		$.csCore.close();
	},
	/** 检查代码唯 一性的 */
	validateCode : function() {
		var requestUrl = $.csCore
				.buildServicePath('/service/assemble/validateCode');
		var inputCode = $('#code').val();
		if (inputCode != null && inputCode.trim() != "") {
			$.ajaxSetup({
				cache : false
			});
			$.ajax({
				url : requestUrl,
				type : 'post',
				data : {
					"code" : inputCode
				},
				async : false,
				dataType : "json",
				success : function(data) {
					if (data != null) {
						if (data.count != 0) {
							$.csCore.alert("代码已被占用");
							$('#code').val("");
						}
					}
				}
			});
		}
		;
	},
	init : function(assembleID, clothingID) {
		$("#clothingID").val(clothingID);
		$.csMenus.bindLabel();
		$.csMenus.bindEvent();
		$.csStyleTree.init(assembleID);
		$.csMenus.showTree();
	}
};