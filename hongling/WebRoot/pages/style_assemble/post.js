// 款式组合设计的添加 页面
jQuery.csAssemblePost = {
	bindLabel : function() {
		$.csCore.getValue("Button_Submit", null, "#btnSave");
		$.csCore.getValue("Button_Cancel", null, "#btnCancel");

	},
	bindEvent : function() {
		$("#btnSave").click($.csAssemblePost.save);
		$("#btnCancel").click($.csCore.close);
		// 服装类别改变事件
		$("#clothingID").change($.csAssemblePost.changeCloth);
		// 添加特殊工艺行
		$("#addSpecialProcess").click($.csAssemblePost.addComponentRow);
	},
	showTree : function() {
		if ($('#clothingID').val() != null && "" != $('#clothingID').val()
				&& -1 != $('#clothingID').val()) {
			$.csCore.loadModal('../style_assemble/menus.jsp', 800, 500,
					function() {
						$.csMenus.init($("#assembleID").val(), $("#clothingID")
								.val());
					});
		} else {
			$.csCore.alert("请先选择服装种类");
			$('#clothingID').focus();
			return;
		}
	},
	/** 服装类型改变事件 */
	changeCloth : function() {
		// 清空 版型风格和 款式风格
		$('#clothingStyle').empty();
		$('#styleID').empty();
		$('#sppro').html('');
		$('#styleID').empty();
		$('#styleTree').val("");
		$("#assembleID").val("");
		$("#defaultFabric").val("");
		$("#fabrics").val("");
		$.csAssembleCommon.fillStyleIDS(null);
	},
	// 添加特殊工艺添行
	addComponentRow : function() {
		var clothingID = $('#clothingID').val();
		if (null == clothingID || "" == clothingID || -1 == clothingID) {

			$.csCore.alert("请先选择服装种类");
			$('#clothingID').focus();
			return;
		}
		var lastIndex = $("#sppro  tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}
		$("#sppro").append(
				$.csAssemblePost.getComponentRowHTML(clothingID,
						parseInt(lastIndex) + 1));
		// $.csAssemblePost.autoCompleteDict(clothingID, parseInt(lastIndex) +
		// 1);
		$.csAssemblePost.inputProces(clothingID, parseInt(lastIndex) + 1);
	},
	// 特殊工艺行
	getComponentRowHTML : function(clothingID, index) {
		return "<tr index='"
				+ index
				+ "'>"
				+ "<td><input type='text' id='text_"
				+ clothingID
				+ "_"
				+ index
				+ "' style='width:130px' class='textbox'/><span/></td>"
				+ "<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>"
				+ "</tr>";
	},

	inputProces : function(clothingID, index) {
		var num = 0;
		$("#text_" + clothingID + "_" + index)
				.keyup(
						function() {
							if ($("#text_" + clothingID + "_" + index).val().length == 2
									|| $("#text_" + clothingID + "_" + index)
											.val().length > 3) {
								var url = $.csCore
										.buildServicePath('/service/assemble/getSPProcessByKeyword?id='
												+ clothingID
												+ '&q='
												+ $(
														"#text_" + clothingID
																+ "_" + index)
														.val());
								var data = $.csCore.invoke(url);
								if (data != null && data.length == 1) {
									num++;
									$.csAssemblePost.checkEcode(data[0],
											clothingID, $(this));

									$("#" + $(this).attr("id")).blur();
								}
							}
						});
		if (num == 0) {
			$.csAssemblePost.autoCompleteDict(clothingID, index);
		}
	},

	checkEcode : function(data, clothingID, obj) {
		var error = 0;
		$("input[id^='doNot_']").each(function() {
			if ($(this).attr("id") == "doNot_" + data.ID) {// 客户指定工艺
				$.csCore.alert($.csCore.getValue("Orden_Precess_Error"));
				error = 1;
			}
		} // 是否选择同一种工艺
		);
		$("input[id^='component_']")
				.each(
						function() {
							if ($(this).attr("id") == "component_" + clothingID
									+ "_" + data.ID) {
								$.csCore.alert($.csCore
										.getValue("Orden_Precess_Error"));
								error = 1;
							}
						} // 是否选择同一种工艺
				);
		var ids = "";
		if (error == 0) {
			$("input[id^='component_']").each(
					function() {
						var thisID = $(this).attr("id").substr(
								$(this).attr("id").lastIndexOf("_") + 1);
						ids += thisID + ",";
						var dict = $.csCore.getDictByID(thisID);
						var parentDict = $.csCore.getDictByID(dict.parentID);
						if (parentDict.isSingleCheck == 10050
								&& dict.parentID == data.parentID) {
							// 是选择同一种上级的工艺
							$.csCore.alert($.csCore
									.getValue("Orden_Precess_CheckTwo"));
							error = 1;
						}
						if (dict.statusID == 10001
								&& dict.parentID == data.parentID) {
							// 是选择同一种上级的工艺
							$.csCore.alert($.csCore
									.getValue("Orden_Precess_CheckTwo"));
							error = 1;
						}
					});
		}
		if (error == 0 && ids.length > 0) {
			// 同一上级可多选判断是否工艺冲突
			var url = $.csCore
					.buildServicePath("/service/orden/getdisabledbyother?ids="
							+ ids + "&id=" + data.ID);
			var result = $.csCore.invoke(url);
			if (result == true) {
				$.csCore.alert($.csCore.getValue("Orden_Precess_Conflict"));
				error = 1;
			}
		}
		if (error > 0) {
			obj.next().html("");
			obj.val("");
		} else {
			var parentDict = $.csCore.getDictByID(data.parentID);
			var parentparentDict = $.csCore.getDictByID(parentDict.parentID);
			var lowerLevelData = $.csCore.getDictsByParent(data.clothingID,
					data.ID);
			if (parentDict.ecode != null) {
				obj.next().html(
						parentparentDict.name + parentDict.name + ":"
								+ data.name);
			} else {
				obj.next().html(data.name);
				if (data.isDefault == 10050) {
					obj.next().css({
						color : "#999999"
					});
				}
			}
			obj.attr("disabled", "true");
			obj.attr("id", "component_" + clothingID + "_" + data.ID);
			if (data.ID == '3029') {
				$.csAssemblePost.setTempComponentid("3029");
			} else if (data.ID == '3028') {
				$.csAssemblePost.setTempComponentid("3028");
			}
			if (lowerLevelData.length > 0 && parentDict.statusID == null) {
				obj.next().append(
						"<input type='text' id='component_textbox_" + data.ID
								+ "' style='width:150px' class='textbox'/>");
				var url = $.csCore
						.buildServicePath('/service/dict/getdictbykeyword?parentID='
								+ data.ID);
				$.csAssemblePost.inputProcesLowerLevel(data.ID, url);
				obj.attr("id", "doNot_" + data.ID);
			} else {
				if (!lowerLevelData.length > 0
						&& data.statusID == DICT_CUSTOMER_SPECIFIED) {
					var doms = "";
					if (PRICE.indexOf(data.ID) > -1) { // 价格,只允许输入数字和小数点
						if ($.browser.mozilla) {
							doms = " onkeypress= 'if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return   false;} '";
						} else {
							doms = " onkeypress= 'if((event.keyCode <48||event.keyCode> 57) && event.keyCode!=46 && event.keyCode!=8){return   false;} '";
						}
					}
					obj.next().append(
							"<input type='text' id='category_textbox_"
									+ data.ID
									+ "' style='width:150px' class='textbox' "
									+ doms + "/>");
				}
			}
		}
	},
	autoCompleteDict : function(clothingID, index) {
		var url = $.csCore
				.buildServicePath('/service/assemble/getSPProcessByKeyword?id='
						+ clothingID);
		$("#text_" + clothingID + "_" + index).autocomplete(url, {
			selectFirst : true,
			cacheLength : 10,
			matchSubset : true,
			multiple : false,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ID,
						result : row.ecode
					};
				});
			},
			formatItem : function(item) {
				// 上衣、西裤、衬衣 扣、里料、线 - 只显示客户指定工艺
				if (DICT_ZDGY.indexOf(item.ecode) >= 0) {
					if (item.notShowOnFront == DICT_YES) {
						return item.ecode + "(" + item.name + ")";
					} else {
						return "";
					}
				} else {
					return item.ecode + "(" + item.name + ")";
				}
			}
		}).result(function(e, data) {
			$.csAssemblePost.checkEcode(data, clothingID, $(this));
		});
	},
	inputProcesLowerLevel : function(dictID, url) {
		var num = 0;
		$("#component_textbox_" + dictID)
				.keyup(
						function() {
							if ($("#component_textbox_" + dictID).val().length > 3) {
								var url = $.csCore
										.buildServicePath('/service/dict/getdictbykeyword?parentID='
												+ dictID
												+ '&q='
												+ $(
														"#component_textbox_"
																+ dictID).val()
														.toLocaleLowerCase());
								var data = $.csCore.invoke(url);
								if (data != null && data.length == 1) {
									num++;
									$("#component_textbox_" + dictID).attr(
											"id", "component_" + data[0].ID);
									$("#component_" + data[0].ID).blur();
									$("#component_" + data[0].ID).val(
											data[0].ecode);
								}
							}
						});
		if (num == 0) {
			$.csAssemblePost.autoCompleteLowerLevelDict(dictID, url);
		}
	},

	autoCompleteLowerLevelDict : function(dictID, url) {
		$("#component_textbox_" + dictID).autocomplete(url, {
			multiple : false,
			mustMatch : true,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ID,
						result : row.ecode
					};
				});
			},
			formatItem : function(item) {
				return item.ecode + "(" + item.name + ")";
			}
		}).result(
				function(e, data) {
					if (!$.csValidator.isNull(data)) {
						$("#component_textbox_" + dictID).attr("id",
								"component_" + data.ID);
					}
				});
	},

	autoTemplate : function() {
		var url = $.csCore
				.buildServicePath('/service/assemble/getAssemblebykeyword');
		$("#ordenid").autocomplete(url, {
			selectFirst : true,
			multiple : false,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ordenID,
						result : row.ordenID
					};
				});
			},
			formatItem : function(item) {
				return item.ordenID + "(" + item.sysCode + ")";
			}
		}).result(function(e, data) {
			$("#ownedStore").val(data.pubMemberName);
			$("#clothingCategory").val(data.clothingName);
			$("#name").val(data.customer.name);
			$("#tel").val(data.customer.tel);
			$("#sortID").val(data.clothingID);
		});
	},
	save : function() {
		 if ($.csAssemblePost.validate()) {
		var processStr = "";
		var p = ":";
		var i = 0;
		$('#sppro input').each(function() {
			// 每个值之间用','分开
			if (i % 2 != 0) {
				p = ",";
			}
			processStr += $(this).val() + p;
			p = ":";
			i++;
		});
		processStr = ","+processStr
		processStr = processStr.substring(0, processStr.lastIndexOf(","));
		$('#specialProcess').val(processStr);
		if ($.csCore.postData($.csCore
				.buildServicePath("/service/assemble/saveAssemble"), "form")) {
			$.csAssembleList.list(0);
			$.csCore.close();
		}
		 }
	},
	validate : function() {
		// 代码不空
		if ($.csValidator.checkNull("code", "组合代码必须填写")) {
			return false;
		}
		// 服装不空
		if ($.csValidator.checkNull("clothingID", "服装种类必须填写")) {
			return false;
		}
		// 款式风格
		if ($.csValidator.checkNull("styleID", "款式风格必须填写")) {
			return false;
		}
		// 工艺信息
		if ($.csValidator.checkNull("process", "工艺信息必须填写")) {
			return false;
		}
		// 默认面料
		if ($.csValidator.checkNull("defaultFabric", "默认面料必须填写")) {
			return false;
		}
		return true;
	},
	addFabric : function(type) {// 添加面料：0默认 1推荐
		var clothing = $("#clothingID").val();
		if (clothing == -1) {
			$.csCore.alert("请选择服装类型");
		} else {
			$.csCore.loadModal('../style_assemble/fabric_list.jsp', 800, 500,
					function() {
						$.csAssembleFabric.init(type, clothing);
					});
		}
	},

	init : function(id) {
		$.csAssemblePost.bindLabel();
		$.csAssemblePost.bindEvent();
		$.csAssembleCommon.fillClothCategorys();
		if ($.csValidator.isNull(id) || null == id || id == "") {
			$("#form h1").html("新增款式组合");
		} else {
			$("#form h1").html("修改款式组合");
			var assemble = $.csAssemblePost.getAssembleByID(id);
			$.csAssembleCommon.fillStyleIDS(assemble.clothingID);
			// $.csStyleTree.init(assemble.ID);
			$("#ID").val(assemble.ID);
			$("#assembleID").val(assemble.ID);
			$("#code").val(assemble.code);
			$("#clothingID").val(assemble.clothingID);
			$('#styleTree').val(assemble.processDesc);
			$("#styleID").val(assemble.styleID);
			$('#process').val(assemble.process);
			$("#brands").val(assemble.brands);
			$("#defaultFabric").val(assemble.defaultFabric);
			$("#fabrics").val(assemble.fabrics);
			$("#titleCn").val(assemble.titleCn);
			$("#titleEn").val(assemble.titleEn);
			$.csAssemblePost.loadProcess(assemble.ID);
		}
	},
	getAssembleByID : function(id) {
		var param = $.csControl.appendKeyValue("", "id", id);
		return $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/getAssembleByID'), param);
	},
	// 修改页面 特殊工艺信息
	loadProcess : function(id) {
		if (null != id && "" != id) {
			$
					.ajax({
						url : $.csCore
								.buildServicePath("/service/assemble/getProcess"),
						data : {
							id : id
						},
						type : "post",
						dataType : "json",
						async : false,
						success : function(data, textStatus, jqXHR) {
							$('#sppro').html(data);
						},
						error : function(xhr) {
							d = xhr.responseText;
						}
					});
		}
	}
};