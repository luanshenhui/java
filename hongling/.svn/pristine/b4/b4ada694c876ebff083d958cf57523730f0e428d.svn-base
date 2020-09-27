jQuery.csSize_bzh = {
	requiredParts : "",
	rapid : false,
	// 生成尺寸分类
	generateSizeCategory : function(orden) {
		// 调用getSizeCategory生成单选钮，单选钮 onchange 调用generateSizeForm
		// 默认选中第一个单选钮
		// 默认执行generateSizeForm(第一个单选钮的值);
		var sizeCategory = $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getsizecategory'));
		var domRadio = "<ul><li class='size_category'><label>"
				+ $.csCore.getValue("Size_Category") + "</label></li>";
		for ( var i = 0; i < sizeCategory.length; i++) {
			domRadio += "<li class='size_category'><label><input type='radio' value='"
					+ sizeCategory[i].ID
					+ "' name='size_category' onclick='$.csSize_bzh.generateArea()'/>"
					+ sizeCategory[i].name + "</label></li>";
		}
		domRadio += "</ul>";
		$("#size_category").html(domRadio);
		if ($.csSize_bzh.rapid != true) {
			$("#size_category").hide();
		}

		var initCategoryID = $.cookie("size_category");
		if ($.csValidator.isNull(initCategoryID)) {
			initCategoryID = sizeCategory[0].ID;
		}
		$("input[value='" + initCategoryID + "']").attr("checked", "checked");

		this.fillSizeUnit();
		this.generateClothingCategory();
		this.generateArea(orden);
		this.generateBodyType(orden);
	},
	generateArea : function(orden) {
		$("#size_area").html('');
		var param = $.csControl.appendKeyValue("", "sizecategoryid",
				$.csControl.getRadioValue("size_category"));
		var areas = $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getarea'), param);
		if ($.csControl.getRadioValue("size_category") == DICT_SIZE_CATEGORY_STANDARD) {
			$("#size_bodytype").hide();
		} else {
			$("#size_bodytype").show();
			if ($.csControl.getRadioValue("size_category") == DICT_SIZE_CATEGORY_CLOTH) {
				$("#clothing_style").hide();
			} else {
				$("#clothing_style").show();
			}
		}
		if (!$.csValidator.isNull(areas)) {
			var dom = "<ul><li>" + $.csCore.getValue("Size_Code") + "：</li>";
			for ( var i = 0; i < areas.length; i++) {
				dom += "<li><label><input type='radio' value='" + areas[i].ID
						+ "' name='area' onclick='$.csSize_bzh.generateSpec()'/>"
						+ areas[i].name + "</label></li>";
			}
			dom += "</ul>";
			$("#size_area").html(dom);
			if (areas.length > 0) {
				$("input[value='" + areas[0].ID + "']").attr("checked",
						"checked");
			}
		}
		this.generateSpec();
		this.fillStyle(orden);
	},
	generateSpec : function() {
		var singleClothings = this.getSingleClothings();
		$.each(singleClothings, function(i, singleClothing) {
			$("#spec_" + singleClothing.ID).html('');
			var param = $.csControl.appendKeyValue('', 'areaid', $.csControl
					.getRadioValue("area"));
			param = $.csControl.appendKeyValue(param, 'singleclothingid',
					singleClothing.ID);
			var specHeights = $.csCore.invoke($.csCore
					.buildServicePath('/service/size/getspecheight'), param);
			if (!$.csValidator.isNull(specHeights)) {
				var dom = "<ul class='size_spec_height'>";
				var specHeights = specHeights.split(",");
				for ( var i = 0; i < specHeights.length; i++) {
					if (!$.csValidator.isNull(specHeights[i])) {
						dom += "<li><label><input type='radio' value='"
								+ specHeights[i] + "' name='size_spec_height_"
								+ singleClothing.ID
								+ "' onclick=$.csSize_bzh.generateSpecChest("
								+ singleClothing.ID + ") />" + specHeights[i]
								+ "</label></li>";
					}
				}
				dom += "</ul>";
				$("#spec_" + singleClothing.ID).append(dom);
				$("#spec_" + singleClothing.ID + " input:radio:first").attr(
						"checked", "checked");
			}
			$.csSize_bzh.generateSpecChest(singleClothing.ID);
		});
	},
	generateSpecChest : function(singleClothingID) {
		$("#spec_" + singleClothingID + " .size_spec_chest").empty();
		var param = $.csControl.appendKeyValue('', 'areaid', $.csControl
				.getRadioValue("area"));
		param = $.csControl.appendKeyValue(param, 'singleclothingid',
				singleClothingID);
		param = $.csControl.appendKeyValue(param, 'specheight', $.csControl
				.getRadioValue("size_spec_height_" + singleClothingID));
		var specChests = $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getspecchest'), param);
		if (!$.csValidator.isNull(specChests)) {
			var dom = "<ul class='size_spec_chest'>";
			var specChests = specChests.split(",");
			for ( var i = 0; i < specChests.length; i++) {
				if (!$.csValidator.isNull(specChests[i])) {
					dom += "<li><label><input type='radio' value='"
							+ specChests[i] + "' name='size_spec_chest_"
							+ singleClothingID
							+ "' onclick=$.csSize_bzh.generateParts("
							+ singleClothingID + ") />" + specChests[i]
							+ "</label></li>";
				}
			}
			dom += "</ul>";
			$("#spec_" + singleClothingID).append(dom);
			$(
					"#spec_" + singleClothingID
							+ " .size_spec_chest input:radio:first").attr(
					"checked", "checked");
		}
		$.csSize_bzh.generateParts(singleClothingID);
	},
	generateParts : function(singleClothingID) {
		var param = $.csControl.appendKeyValue("", "unitid", $.csControl
				.getRadioValue("sizeUnitID"));
		param = $.csControl.appendKeyValue(param, "sizecategoryid", $.csControl
				.getRadioValue("size_category"));
		param = $.csControl.appendKeyValue(param, "areaid", $.csControl
				.getRadioValue("area"));
		param = $.csControl.appendKeyValue(param, "specheight", $.csControl
				.getRadioValue("size_spec_height_" + singleClothingID));
		param = $.csControl.appendKeyValue(param, "specchest", $.csControl
				.getRadioValue("size_spec_chest_" + singleClothingID));
		param = $.csControl.appendKeyValue(param, "singleclothingid",
				singleClothingID);
		var parts = $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getclothingparts'), param);
		var dom = "<ul>";
		for ( var i = 0; i < parts.length; i++) {
			var defaultValue = parts[i].defaultValue;
			if (defaultValue == null) {
				defaultValue = "";
			}
			star = "";
			if (parts[i].isRequired == DICT_YES) {
				if (this.requiredParts != "") {
					this.requiredParts += "," + parts[i].partID;
				} else {
					this.requiredParts += parts[i].partID;
				}
				star = " star";
			}
			readonly = "";
			if (parts[i].isReadonly == DICT_YES) {
				readonly = " readonly='yes' style='color:#bbb;'";
			}
			dom += "<li class='part_label'>"
					+ parts[i].partName
					+ "</li><li onclick='$.csSize_bzh.showPartMessage(this);' class='part_value"
					+ star + "' title='" + parts[i].sizeFrom + " - "
					+ parts[i].sizeTo + "'>";
			dom += "<input type='text' " + readonly
					+ " onfocus='$.csSize_bzh.playShow(" + singleClothingID + ","
					+ parts[i].sizeCategoryID + "," + parts[i].partID + ")'";
			if ($.browser.mozilla) {
				dom += " onkeypress= 'if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return   false;} '";
			} else {
				dom += " onkeypress= 'if((event.keyCode <48||event.keyCode> 57) && event.keyCode!=46 && event.keyCode!=8){return   false;} '";
			}
			dom += " onblur=$.csSize_bzh.validatePartRange('"
					+ this.buildPartID(parts[i].partID) + "','" + parts[i].ID
					+ "','" + parts[i].sizeFrom + "','" + parts[i].sizeTo
					+ "') value='" + defaultValue + "' id='"
					+ this.buildPartID(parts[i].partID) + "' name='"
					+ this.buildPartID(parts[i].partID) + "'/></li>";
		}
		dom += "</ul>";
		$("#part_" + singleClothingID).html(dom);
		try {
			$.csSize_bzh.playShow(singleClothingID, $.csControl
					.getRadioValue("size_category"), parts[0].partID);
		} catch (e) {
		}
	},
	showPartMessage : function(element) {
		var title = $(element).attr("title");
		if (title != "null - null") {
			title = $(element).prev().html() + " : " + title;
			$("#size_message").html(title);
		}
	},
	generateBodyType : function(orden) {
		var singleClothings = this.getSingleClothings();
		$.each(singleClothings, function(i, singleClothing) {
			if (i == 0) {
				clothing = singleClothing.ID;
			}
		});
		// 单选钮的项name的命名 option_bodytype_10111,option_bodytype_10112
		var bodyType = $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getclothingbodytype'),
				$.csControl.appendKeyValue("", "sizecategoryid", $.csControl
						.getRadioValue("size_category")));
		var domRadio = "";
		if (!$.csValidator.isNull(bodyType)) {
			// 特体信息
			for ( var i = 0; i < bodyType.length; i++) {
				if (bodyType[i].categoryID != DICT_CATEGORY_BODYTYPE) {
					var bodyTypes = bodyType[i].bodyTypes;
					if (bodyTypes != "") {
						if (i == bodyType.length - 1) {
							domRadio += "<ul id='clothing_style' class='hline'>";
						} else {
							domRadio += "<ul class='hline'>";
						}
						domRadio += "<li style='width:620px;clear:both;font-weight:bold;'>"
								+ bodyType[i].categoryName + "</li>";
						for ( var j = 0; j < bodyTypes.length; j++) {
							domRadio += "<li><label><input type='checkbox' ";
							if (!orden || !orden.ordenID) {
								if (bodyTypes[j].ID == DICT_BODY_TYPE
										|| bodyTypes[j].ID == DICT_CLONTHING_SIZE) {
									domRadio += "checked='true' ";
								} else if (j == 0 && i < bodyType.length - 1) {
									domRadio += "checked='true' ";
								}
							}
							domRadio += "  name='body_type_"
									+ bodyType[i].categoryID
									+ "' value='"
									+ bodyTypes[j].ID
									+ "' onfocus='$.csControl.checkOnce(this);$.csSize_bzh.playShow(-1,"
									+ $.csControl
											.getRadioValue("size_category")
									+ "," + bodyTypes[j].ID + ");'/> "
									+ bodyTypes[j].name + "</label></li>";
						}
						domRadio += "</ul>";
					}
				}
			}
			// 着装风格
			$
					.each(
							singleClothings,
							function(i, singleClothing) {
								for ( var i = 0; i < bodyType.length; i++) {
									if (bodyType[i].categoryID == DICT_CATEGORY_BODYTYPE) {
										var bodyTypes = bodyType[i].bodyTypes;
										if (bodyTypes != "") {
											if (i == bodyType.length - 1) {
												domRadio += "<ul id='clothing_style' class='hline'>";
											} else {
												domRadio += "<ul class='hline'>";
											}
											domRadio += "<li style='width:620px;clear:both;font-weight:bold;'>"
													+ bodyType[i].categoryName
													+ "&nbsp;"
													+ singleClothing.name
													+ "</li>";
											for ( var j = 0; j < bodyTypes.length; j++) {
												if (bodyType[i].categoryID == DICT_CATEGORY_BODYTYPE) {
													var strs = new Array();
													strs = bodyTypes[j].extension
															.split(",");
													for ( var n = 0; n < strs.length; n++) {
														if (strs[n] == singleClothing.ID) {
															domRadio += "<li><label><input type='checkbox' ";
															if (!orden
																	|| !orden.ordenID) {
																if (bodyTypes[j].ID == DICT_BODY_TYPE) {
																	domRadio += "checked='true' ";
																}
															}
															domRadio += "  name='body_type_"
																	+ bodyType[i].categoryID
																	+ "_"
																	+ singleClothing.ID
																	+ "' id='body_type_"
																	+ bodyType[i].categoryID
																	+ "_"
																	+ singleClothing.ID
																	+ "_"
																	+ bodyTypes[j].ID
																	+ "' value='"
																	+ bodyTypes[j].ID
																	+ "' onfocus='$.csControl.checkOnce(this);$.csSize_bzh.playShow(-1,"
																	+ $.csControl
																			.getRadioValue("size_category")
																	+ ","
																	+ bodyTypes[j].ID
																	+ ");'/> "
																	+ bodyTypes[j].name
																	+ "</label></li>";
														}
													}
												}
											}
											domRadio += "</ul>";
										}
									}
								}
							});
		}
		$("#size_bodytype").html(domRadio);
	},
	generateClothingCategory : function() {
		$("#size_spec_part").html('');
		var singleClothings = this.getSingleClothings();
		var dom = "";
		$.each(singleClothings, function(i, singleClothing) {
			dom += "<div>" + singleClothing.name + "</div>";
			dom += "<div id='spec_" + singleClothing.ID + "'></div>";
			dom += "<div id='part_" + singleClothing.ID + "'></div>";
		});

		$("#size_spec_part").html(dom);
	},
	buildPartID : function(partID) {
		return "part_label_" + partID;
	},
	getTempFabricCode : function() {
		return $.csCore.invoke($.csCore
				.buildServicePath('/service/orden/gettempfabriccode'));
	},
	validatePost : function() {
		if ($.csValidator.isNull(this.getTempFabricCode())) {
			$.csCore.alert($.csCore.getValue("Common_PleaseSelect",
					"Fabric_Moduler"));
			return false;
		}
		if ($.csValidator.isNull(this.requiredParts)) {
			return true;
		}
		var temp = this.requiredParts.split(",");
		for ( var i = 0; i < temp.length; i++) {
			partID = this.buildPartID(temp[i]);

			if ($.csValidator.checkNull(partID, $.csCore.getValue(
					"Common_Required", "Size_Star"))) {
				return false;
			}
		}
		return true;
	},
	getPartLabel : function(partID) {
		return $("#" + partID).parent().prev().html();
	},
	validatePartRange : function(partID, sizeStandardID, fromValue, toValue) {
		if (!$.csValidator.isNull(fromValue) && !$.csValidator.isNull(toValue)) {
			var inputPart = $("#" + partID);
			var inputValue = inputPart.val();
			if (inputValue == "") {
				inputValue = "0";
			}
			inputValue = parseFloat(inputValue);
			fromValue = parseFloat(fromValue);
			toValue = parseFloat(toValue);
			if (inputValue < fromValue || inputValue > toValue) {
				inputPart.val("");
				return false;
			}
		}
		var sizeStandardGroups = this.getClothingPartsByGroup(sizeStandardID);
		if (!$.csValidator.isNull(sizeStandardGroups)) {
			$.each(sizeStandardGroups, function(i, sizeStandardGroup) {
				var value = $("#" + partID).val();
				var newPartID = $.csSize_bzh.buildPartID(sizeStandardGroup.partID);
				if ($.csValidator.isNull($("#" + newPartID).val())) {
					$("#" + newPartID).val(value);
				}
			});
		}
		// -
		var sizeRangeMinus = $.csSize_bzh.getSizeRangeByStandardAndSign(
				sizeStandardID, "-");
		if (!$.csValidator.isNull(sizeRangeMinus)) {
			for ( var i = 0; i < sizeRangeMinus.length; i++) {
				var sizeStandards = sizeRangeMinus[i].sizeStandardIDs
						.split(',');
				if (sizeStandards.length == 2) {
					var a = $.csSize_bzh.getSizeStandardByID(sizeStandards[0]);
					var b = $.csSize_bzh.getSizeStandardByID(sizeStandards[1]);
					var av = $("#" + $.csSize_bzh.buildPartID(a.partID)).val();
					var bv = $("#" + $.csSize_bzh.buildPartID(b.partID)).val();
					if (!$.csValidator.isNull(av) && !$.csValidator.isNull(bv)) {
						var result = av - bv;
						if (result < sizeRangeMinus[i].sizeFrom
								|| result > sizeRangeMinus[i].sizeTo) {
							var current = $.csSize_bzh
									.getSizeStandardByID(sizeStandardID);
							$("#" + $.csSize_bzh.buildPartID(current.partID)).val(
									'');
							var message = this.getPartLabel($.csSize_bzh
									.buildPartID(a.partID))
									+ " - "
									+ this.getPartLabel($.csSize_bzh
											.buildPartID(b.partID));
							if (sizeRangeMinus[i].sizeFrom != -1000) {
								message = sizeRangeMinus[i].sizeFrom + " < "
										+ message;
							}
							if (sizeRangeMinus[i].sizeTo != 1000) {
								message = message + " < "
										+ sizeRangeMinus[i].sizeTo;
							}
							$("#size_message").html(message);
						}
					}
				}
			}
		}
		// *
		var sizeRangeMultiplication = $.csSize_bzh.getSizeRangeByStandardAndSign(
				sizeStandardID, "*");
		if (!$.csValidator.isNull(sizeRangeMultiplication)) {
			for ( var i = 0; i < sizeRangeMultiplication.length; i++) {
				var sizeStandards = sizeRangeMultiplication[i].sizeStandardIDs
						.split(',');
				if (sizeStandards.length == 2) {
					var a = $.csSize_bzh.getSizeStandardByID(sizeStandards[0]);
					var b = $.csSize_bzh.getSizeStandardByID(sizeStandards[1]);
					var av = $("#" + $.csSize_bzh.buildPartID(a.partID)).val();
					var bv = $("#" + $.csSize_bzh.buildPartID(b.partID)).val();
					if (!$.csValidator.isNull(av) && !$.csValidator.isNull(bv)) {
						var span = (av - a.rangeStart) / a.rangeStep;
						var bvs = b.rangeStart + b.rangeStep * span;// 标准
						// alert(bvs);
						if (bvs > b.rangeStart) {
							var min = bvs + sizeRangeMultiplication[i].sizeFrom;
							// alert(min);
							var max = bvs + sizeRangeMultiplication[i].sizeTo;
							// alert(max);
							if (bv < min || bv > max) {
								var current = $.csSize_bzh
										.getSizeStandardByID(sizeStandardID);
								$("#" + $.csSize_bzh.buildPartID(current.partID))
										.val('');
								// $("#" +
								// $.csSize_bzh.buildPartID(current.partID)).attr('title',min+'-'+max);
								$("#size_message")
										.html(
												$(
														"#"
																+ $.csSize_bzh
																		.buildPartID(current.partID))
														.parent().prev().html()
														+ " : "
														+ min
														+ " - "
														+ max);
								$("#" + $.csSize_bzh.buildPartID(current.partID))
										.parent().attr("title",
												min + " - " + max);
							}
						}
					}
				}
			}
		}

		// / 胸围 - 中腰围 屏蔽 加放量
		if (sizeStandardID == 2 || sizeStandardID == 3) {
			$("input[type=checkbox][value=" + 10280 + "]").parent().show();
			$("input[type=checkbox][value=" + 10281 + "]").parent().show();
			$("input[type=checkbox][value=" + 10282 + "]").parent().show();
			var sizeRangeDivision = $.csSize_bzh.getSizeRangeBySign("/");
			if (!$.csValidator.isNull(sizeRangeDivision)) {
				var standardChest = $.csSize_bzh.getSizeStandardByID(2);
				var standardWaist = $.csSize_bzh.getSizeStandardByID(3);
				if (!$.csValidator.isNull(standardChest)
						&& !$.csValidator.isNull(standardWaist)) {
					var vChest = $(
							"#" + $.csSize_bzh.buildPartID(standardChest.partID))
							.val();
					var vWaist = $(
							"#" + $.csSize_bzh.buildPartID(standardWaist.partID))
							.val();
					if (!$.csValidator.isNull(vChest)
							&& !$.csValidator.isNull(vWaist)) {
						var result = vChest - vWaist;
						for ( var i = 0; i < sizeRangeDivision.length; i++) {
							if (result > sizeRangeDivision[i].sizeFrom
									&& result <= sizeRangeDivision[i].sizeTo) {
								$(
										"input[type=checkbox][value="
												+ sizeRangeDivision[i].sizeStandardIDs
												+ "]").parent().hide();
							}
						}
					}
				}
			}
		}
	},

	playShow : function(singleClothingID, sizeCategoryID, dictID) {
		$("#size_video").html('');
		$("#size_video_ipad").html('');
		var path = "../../size/" + $.csCore.getCurrentVersion() + "/";
		if (singleClothingID != -1
				&& sizeCategoryID == DICT_SIZE_CATEGORY_CLOTH) {
			path += singleClothingID + "_";
		}
		path += dictID;
		var videoFile = path + ".flv";
		var videoFile_ipad = path + ".mp4";
		var imageFile = path + ".png";
		var width = 240;
		var height = 180;
		var dom = "";
		var dom_ipad = "";

		if ((sizeCategoryID == DICT_SIZE_CATEGORY_NAKED)
				|| (singleClothingID == -1 && sizeCategoryID == -1)) {
			if ($.csValidator.isExistImg(videoFile)) {
				dom += $.csCore.playVideo(width, height, videoFile);
				dom_ipad += "<div style='width:240px;height:180px;' id='video_ipad' href='"
						+ videoFile_ipad + "'></div>";
			}
			if ($.csValidator.isExistImg(imageFile)) {
				dom += $.csCore.playImg(width, height, imageFile);
				dom_ipad += $.csCore.playImg(width, height, imageFile);
			}
		}

		if (sizeCategoryID == DICT_SIZE_CATEGORY_CLOTH) {
			if ($.csValidator.isExistImg(imageFile)) {
				dom = $.csCore.playImg(width, height, imageFile);
				dom_ipad = $.csCore.playImg(width, height, imageFile);
			}
		}
		if ($.csValidator.isExistImg(imageFile)) {
			$("#size_video").html(dom);
			$("#size_video_ipad").html(dom_ipad);
			if ($.csSize_bzh.rapid == true) {
				$("#size_video").addClass("rapid");
				$("#size_video_ipad").addClass("rapid");
			} else {
				$("#size_video").addClass("front");
				$("#size_video_ipad").addClass("front");
			}
		}
		if ($.browser.safari) {
			$("#size_video").hide();
			$("#size_video_ipad").show();
			$f("video_ipad",
					"../../scripts/jquery/flowplayer/flowplayer-3.2.15.swf")
					.ipad();
		} else {
			$("#size_video").show();
			$("#size_video_ipad").hide();
		}
	},
	fillSizeUnit : function() {
		$.csControl
				.fillRadios("unitContainer", $.csCore
						.getDicts(DICT_CATEGORY_HEIGHTUNIT), "sizeUnitID",
						"ID", "name");
		$("#unitContainer input").click(function() {
			$.csSize_bzh.generateArea();
		});
	},
	fillStyle : function(orden) {
		$(".styleTitle").html("");
		$("#styleContainer").html("");
		if ($.csControl.getRadioValue("size_category") == DICT_SIZE_CATEGORY_NAKED) {
			$(".styleTitle").html($.csCore.getValue("Size_Style") + ":");
			if (orden != null && orden.styleID != null) {
				$.csControl.fillRadio("styleContainer", $.csCore
						.getDicts(DICT_CATEGORY_STYLE), "styleID", "ID",
						"name", orden.styleID);
			} else {
				$.csControl
						.fillRadios("styleContainer", $.csCore
								.getDicts(DICT_CATEGORY_STYLE), "styleID",
								"ID", "name");
			}
		}
	},
	getSingleClothings : function() {
		var singleClothings = $.csCore.invoke($.csCore
				.buildServicePath('/service/clothing/getsingleclothings'));
		return singleClothings;
	},
	getClothingPartsByGroup : function(sizeStandardID) {
		var param = $.csControl.appendKeyValue("", "unitid", $.csControl
				.getRadioValue("sizeUnitID"));
		param = $.csControl.appendKeyValue(param, "sizestandardid",
				sizeStandardID);
		return $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getclothingpartsbygroup'),
				param);
	},
	getSizeRangeByStandardAndSign : function(sizeStandardID, sign) {
		var param = $.csControl.appendKeyValue("", "sign", sign);
		param = $.csControl.appendKeyValue(param, "sizestandardid",
				sizeStandardID);
		param = $.csControl.appendKeyValue(param, "unitid", $.csControl
				.getRadioValue("sizeUnitID"));
		return $.csCore
				.invoke(
						$.csCore
								.buildServicePath('/service/size/getsizerangebysizestandardandsign'),
						param);
	},
	getSizeRangeBySign : function(sign) {
		var param = $.csControl.appendKeyValue("", "sign", sign);
		param = $.csControl.appendKeyValue(param, "unitid", $.csControl
				.getRadioValue("sizeUnitID"));
		return $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getsizerangebysign'), param);
	},
	getSizeStandardByID : function(id) {
		var param = $.csControl.appendKeyValue("", "id", id);
		param = $.csControl.appendKeyValue(param, "unitid", $.csControl
				.getRadioValue("sizeUnitID"));
		return $.csCore.invoke($.csCore
				.buildServicePath('/service/size/getsizestandardbyid'), param);
	},
	saveOrden:function (){
		if($.csSize_bzh.validatePost()){
			if($.csCore.postData($.csCore.buildServicePath('/service/orden/saveorden'), 'sizeform')){
		    	$.csCore.close();
		    	$.csCore.loadModal('../customer/more.htm',1065,500,function(){$.csCustomerMore.init();});
		    }
		}
	},
	init : function(orden, rapid) {
		$.csCore.getValue("Size_Info",null,"#sizeInfo");
		$.csCore.getValue("Dict_10054",null,"#size_img_title");
		$("#size_title").html($.csCore.getValue("Size_Title1")+"<br/>"
				+$.csCore.getValue("Size_Title2")+"<br/>"
				+$.csCore.getValue("Size_Title3"));
		$.csCore.getValue("Button_SaveMyDesign",null,"#btnSaveSize");
		$("#btnSaveSize").click($.csSize_bzh.saveOrden);
		
		$.csSize_bzh.rapid = rapid;
		$.csSize_bzh.generateSizeCategory(orden);
		var clothingID = $.csCore.invoke($.csCore
				.buildServicePath('/service/orden/gettempclothingid'));
		if (!$.csValidator.isNull(clothingID)) {
			$.csCore.getValue("Orden_MorePants",null,"#more_pants p");
			var clothing = $.csCore.getDictByID(clothingID);
			var singles = clothing.extension.split(",");
			if (singles.length <= 1) {
				$('#more_pants').hide();
				if (singles == DICT_CLOTHING_PANT) {
					$('#more_pants').show();
				}
			} else {
				$('#more_pants').show();
				$('#more_pants label input').attr('value', DICT_YES);
			}
		}
	}
};
