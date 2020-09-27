// 款式组合设计的JS
jQuery.csAssembleList = {
	moduler : "Assemble",
	bindLabel : function() {
		$.csCore.getValue("Orden_Number", null, ".lblNumber");

	},
	bindEvent : function() {
		$.csDate.datePicker("fromDate", $.csDate.getLastYear());
		$.csDate.datePicker("toDate");
		$.csCore.pressEnterToSubmit('keyword', 'btnSearch');
		$("#btnSearch").click(function() {
			$.csAssembleList.list(0);
		});
		$("#btnCreateAssemble").click(function() {
			$.csAssembleList.openPost(null);
		});
		$("#btnRemoveAssemble").click($.csAssembleList.remove);
		$("#btnExportAssemble").click($.csAssembleList.exportAssemble);
		$("#searchClothingID").change($.csAssembleList.changeCloth);
		$("#btnImportAssemble").click($.csAssembleList.importAssemble);
		$("#btnImportAssembleAll").click($.csAssembleList.importStyle);
	},
	fillCategory : function() {
		var datas = $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/GetMenuCategoryOptions'));
		$.csControl.fillOptions('searchCategory', datas.data, "ID", "name",
				$.csCore.getValue("Common_All"));
	},
	list : function(pageIndex) {
		var param = $.csControl.getFormData('AssembleSearch');
		param = $.csControl.appendKeyValue(param, 'pageindex', pageIndex);
		var data = $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/listAssemble'), param);
		$.csCore.processList($.csAssembleList.moduler, data);
		if (pageIndex == 0) {
			$.csCore.initPagination($.csAssembleList.moduler + "Pagination",
					data.count, PAGE_SIZE, $.csAssembleList.list);
		}
		// $.csAssembleCommon.bindLabel();
		$.csAssembleList.bindLabel();
		// $.csAssembleList.checkAccess();
	},
	remove : function() {
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/assemble/removeAssemble');
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'),
				"$.csAssembleList.confirmRemove('" + url + "','" + removedIDs
						+ "')");
	},
	confirmRemove : function(url, removedIDs) {
		var param = $.csControl.appendKeyValue("", "removedIDs", removedIDs);
		var data = $.csCore.invoke(url, param);
		if (data != null) {
			if (data == "OK") {
				removedIDs = removedIDs.split(',');
				for ( var i = 0; i <= removedIDs.length - 1; i++) {
					$('#row' + removedIDs[i]).remove();
				}
				$.csAssembleList.list(0);
			} else {
				$.csCore.alert(data);
			}
		}
	},
	openPost : function(id) {
		$.csCore.loadModal('../style_assemble/post.jsp', 800, 450, function() {
			$.csAssemblePost.init(id, true);
		});
	},
	// 浏览信息
	openView : function(id) {
		$.csCore.loadModal('../style_assemble/view.jsp', 800, 500, function() {
			$.csAssembleView.init(id);
		});
	},
	exportAssemble : function() {
		var url = $.csCore
				.buildServicePath('/service/assemble/exportAssemble?formData=');
		url += $.csControl.getFormData('AssembleSearch');
		window.open(url);
	},
	importAssemble : function() {
		$.csCore.loadModal('../style_assemble/importAssemble.jsp', 550, 200, function() {
			$.csImportAssemble.init();
		});
	},
	importStyle : function() {
		$.csCore.loadModal('../style_assemble/importStyle.jsp', 550, 200, function() {
			$.csImportStyle.init();
		});
	},
	init : function() {
		$.csAssembleList.bindLabel();
		$.csAssembleList.bindEvent();
		$.csAssembleList.fillClothCategorys();
		// $.csAssembleList.fillCategory();
		$.csAssembleList.list(0);
	},
	fillClothCategorys : function() {
		var cloths = $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/getClothCategorys'));
		$.csControl
				.fillOptions('searchClothingID', cloths, "ID", "name", "请选择");
	},
	changeCloth : function() {
		var clothingID = $('#searchClothingID').val();
		var param = $.csControl.appendKeyValue('', 'clothingID', clothingID);
		var styleIDs = $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/getStyleByClothingId'),
				param);
		$.csControl.fillOptions('searchStyleID', styleIDs, "ID", "NAME", "请选择");
	}
};
