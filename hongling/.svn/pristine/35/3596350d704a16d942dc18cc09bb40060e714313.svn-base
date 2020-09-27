var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var basePath = localObj.protocol+"//"+localObj.host+"/"+contextPath;
var server_context=basePath;

jQuery.csSize = {
	requiredParts: "",
	rapid: false,
	// 生成尺寸分类
	generateSizeCategory: function(orden) {
		// 调用getSizeCategory生成单选钮，单选钮 onchange 调用generateSizeForm
		// 默认选中第一个单选钮
		// 默认执行generateSizeForm(第一个单选钮的值);
		var sizeCategory = $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizecategory'));
		var domRadio = "<ul><li class='size_category'><label>" + $.csCore.getValue("Size_Category") + "</label></li>";
		for (var i = 0; i < sizeCategory.length; i++) {
			domRadio += "<li class='size_category'><label><input type='radio' value='" + sizeCategory[i].ID + "' name='size_category' onclick='$.csSize.generateArea()'/>" + sizeCategory[i].name + "</label></li>";
		}
		domRadio += "</ul>";
		$("#size_category").html(domRadio);
		if ($.csSize.rapid != true) {
			$("#size_category").hide();
		}

		var initCategoryID = $.cookie("size_category");
		if ($.csValidator.isNull(initCategoryID) || $.csValidator.isNull(orden)) {
			initCategoryID = sizeCategory[0].ID;
		}
		$("input[value='" + initCategoryID + "']").attr("checked", "checked");

		this.fillSizeUnit();
		this.generateClothingCategory();
		this.generateArea(orden);
//		this.generateBodyType(orden);
	},
	changeSizeUnit : function(){
		this.requiredParts ="";
		$("#size_area").html('');
		var param = $.csControl.appendKeyValue("", "sizecategoryid", $.csControl.getRadioValue("size_category"));
		var areas = $.csCore.invoke($.csCore.buildServicePath('/service/size/getarea'), param);
		if (!$.csValidator.isNull(areas)) {
			var dom = "<ul><li>" + $.csCore.getValue("Size_Code") + "：</li>";
			for (var i = 0; i < areas.length; i++) {
				if(areas[i].ID==10204){
					continue;
				}
				dom += "<li><label><input type='radio' value='" + areas[i].ID + "' name='area' onclick='$.csSize.generateSpec()'/>" + areas[i].name + "</label></li>";
			}
			dom += "</ul>";
			$("#size_area").html(dom);
			if (areas.length > 0) {//无尺码类型默认选中第一个
				$("input[value='" + areas[0].ID + "']").attr("checked", "checked");
			}
		}
		this.generateSpec();
	},
	generateArea: function(orden) {
		this.requiredParts ="";
		$("#size_area").html('');
		var param = $.csControl.appendKeyValue("", "sizecategoryid", $.csControl.getRadioValue("size_category"));
		var areas = $.csCore.invoke($.csCore.buildServicePath('/service/size/getarea'), param);
		/*if ($.csControl.getRadioValue("size_category") == DICT_SIZE_CATEGORY_STANDARD) {
			$("#size_bodytype").hide();
		} else {
			$("#size_bodytype").show();
//			if ($.csControl.getRadioValue("size_category") == DICT_SIZE_CATEGORY_NAKED) {
//				$("#clothing_style").hide();
//			} else {
				$("#clothing_style").show();
//			}
		}*/
		if (!$.csValidator.isNull(areas)) {
			var dom = "<ul><li>" + $.csCore.getValue("Size_Code") + "：</li>";
			for (var i = 0; i < areas.length; i++) {
				if(areas[i].ID==10204){
					continue;
				}
				dom += "<li><label><input type='radio' value='" + areas[i].ID + "' name='area' onclick='$.csSize.generateSpec()'/>" + areas[i].name + "</label></li>";
			}
			dom += "</ul>";
			$("#size_area").html(dom);
			if (areas.length > 0) {
				if (orden != null && orden.sizeAreaID != null) { //选中已存在尺码类型
					$("input[value='" + orden.sizeAreaID + "']").attr("checked", "checked");
				} else { //无尺码类型默认选中第一个
					$("input[value='" + areas[0].ID + "']").attr("checked", "checked");
				}
			}
		}
		this.generateSpec();
		this.fillStyle(orden);
		this.generateBodyType(orden);//特体信息-着装风格-款式
		//订单数量
		/*if($.csControl.getRadioValue("size_category") == 10054 
				|| $.csControl.getRadioValue("clothingID")==3000 || $.csControl.getRadioValue("clothingID")==5000){//标准号或衬衣
			$("#more_shirt").show();
		}else{
			$("#more_shirt").hide();
		}*/
	},
	generateSpec: function() {
		var singleClothings = this.getSingleClothings();
		$.each(singleClothings,
		function(i, singleClothing) {
			$("#3PCS").val("");
			if(singleClothings.length == 3 || (singleClothings.length == 2 && singleClothing.ID == 4000)){//3件套
				$("#3PCS").val("3");
			}
			$("#spec_" + singleClothing.ID).html('');
			var param = $.csControl.appendKeyValue('', 'areaid', $.csControl.getRadioValue("area"));
			param = $.csControl.appendKeyValue(param, 'singleclothingid', singleClothing.ID);
			var specHeights = $.csCore.invoke($.csCore.buildServicePath('/service/size/getspecheight'), param);
			if (!$.csValidator.isNull(specHeights)) {
				var dom = "<ul class='size_spec_height'>";
				var specHeights = specHeights.split(",");
				for (var i = 0; i < specHeights.length; i++) {
					if (!$.csValidator.isNull(specHeights[i])) {
						dom += "<li><label><input type='radio' value='" + specHeights[i] + "' name='size_spec_height_" + singleClothing.ID + "' onclick=$.csSize.generateSpecChest(" + singleClothing.ID + ") />" + specHeights[i] + "</label></li>";
					}
				}
				dom += "</ul>";
				$("#spec_" + singleClothing.ID).append(dom);
				$("#spec_" + singleClothing.ID + " input:radio:first").attr("checked", "checked");
			}
			$.csSize.generateSpecChest(singleClothing.ID);
		});
	},
	generateSpecChest: function(singleClothingID) {
		$("#spec_" + singleClothingID + " .size_spec_chest").empty();
		var param = $.csControl.appendKeyValue('', 'areaid', $.csControl.getRadioValue("area"));
		param = $.csControl.appendKeyValue(param, 'singleclothingid', singleClothingID);
		param = $.csControl.appendKeyValue(param, 'specheight', $.csControl.getRadioValue("size_spec_height_" + singleClothingID));
		var specChests = $.csCore.invoke($.csCore.buildServicePath('/service/size/getspecchest'), param);
		if (!$.csValidator.isNull(specChests)) {
			var dom = "<ul class='size_spec_chest'>";
			var specChests = specChests.split(",");
			for (var i = 0; i < specChests.length; i++) {
				if (!$.csValidator.isNull(specChests[i])) {
					dom += "<li><label><input type='radio' value='" + specChests[i] + "' name='size_spec_chest_" + singleClothingID + "' onclick=$.csSize.generateParts(" + singleClothingID + ") />" + specChests[i] + "</label></li>";
				}
			}
			dom += "</ul>";
			$("#spec_" + singleClothingID).append(dom);
			$("#spec_" + singleClothingID + " .size_spec_chest input:radio:first").attr("checked", "checked");
		}
		$.csSize.generateParts(singleClothingID);
	},
	generateParts: function(singleClothingID) {
		$("#part_"+singleClothingID).css("padding-left","0px");
		if($.csControl.getRadioValue("size_category") == 10052 && singleClothingID == 4000 && $("#3PCS").val()==3) {
			$("#part_4000").html($.csCore.getValue("Label_VestNoSize"));
			$("#part_4000").css("padding-left","60px");
		}else{
			/*var sizeUnitID = $.csControl.getRadioValue("sizeUnitID");*/
			var param = $.csControl.appendKeyValue("", "unitid", $.csControl.getRadioValue("sizeUnitID"));
			param = $.csControl.appendKeyValue(param, "sizecategoryid", $.csControl.getRadioValue("size_category"));
			param = $.csControl.appendKeyValue(param, "areaid", $.csControl.getRadioValue("area"));
			param = $.csControl.appendKeyValue(param, "specheight", $.csControl.getRadioValue("size_spec_height_" + singleClothingID));
			param = $.csControl.appendKeyValue(param, "specchest", $.csControl.getRadioValue("size_spec_chest_" + singleClothingID));
			param = $.csControl.appendKeyValue(param, "singleclothingid", singleClothingID);
			var parts = $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingparts'), param);
			var dom = "<ul>";
			this.requiredParts = "";
			for (var i = 0; i < parts.length; i++) {
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
				dom += "<li class='part_label'>" + parts[i].partName + "</li><li onclick='$.csSize.showPartMessage(this);' class='part_value" + star + "' title='" + parts[i].sizeFrom + " - " + parts[i].sizeTo + "'>";
				dom += "<input type='text' " + readonly + " onfocus='$.csSize.playShow(" + singleClothingID + "," + parts[i].sizeCategoryID + "," + parts[i].partID + ")'";
//				if ($.browser.mozilla) {
//					dom += " onkeypress= 'if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return   false;} '";
//				} else {
//					dom += " onkeypress= 'if((event.keyCode <48||event.keyCode> 57) && event.keyCode!=46 && event.keyCode!=8){return   false;} '";
//				}
				var tun = "";
				if(singleClothingID==2000 && this.buildPartID(parts[i].partID) == "part_label_10108"){
					tun = singleClothingID;
				}
				var valueSize =$("#"+this.buildPartID(parts[i].partID)).val();
				if(undefined != valueSize && "" != valueSize && "" == defaultValue){
					/*if(sizeUnitID == 10265){//英寸
						defaultValue = valueSize/2.54;
					}else{//厘米
						defaultValue = valueSize*2.54;
					}
					defaultValue=defaultValue.toFixed(2);*/
					if("" == defaultValue){
						defaultValue = "";
					}else{
						defaultValue = valueSize;
					}
				}
				var id = this.buildPartID(parts[i].partID);
//				var obj = $("#"+id);
//				alert($("#"+id).value.charAt(0));
				dom += " onkeyup=$.csSize.onlyNumber(this)  onblur=$.csSize.validatePartRange('" + this.buildPartID(parts[i].partID) + "','" + parts[i].ID + "','" + parts[i].sizeFrom + "','" + parts[i].sizeTo + "') value='" + defaultValue + "' id='" + this.buildPartID(parts[i].partID) + "' name='" +tun+ this.buildPartID(parts[i].partID) + "'/></li>";
			}
			dom += "</ul>";
			$("#part_" + singleClothingID).html(dom);
			try {
				$.csSize.playShow(singleClothingID, $.csControl.getRadioValue("size_category"), parts[0].partID);
			} catch(e) {}
		}
	},
	onlyNumber:function onlyNumber(obj){
	    //得到第一个字符是否为负号
	    var t = obj.value.charAt(0);  
	    //先把非数字的都替换掉，除了数字和. 以及-
	     obj.value = obj.value.replace(/[^\d\.-]/g,'');   
	     //必须保证第一个为数字而不是.   
	     obj.value = obj.value.replace(/^\./g,'');   
	     //保证只有出现一个.而没有多个.   
	     obj.value = obj.value.replace(/\.{2,}/g,'.');  
	   //保证只有出现一个-而没有多个-
	     obj.value = obj.value.replace(/\-{2,}/g,'-');   
	     //保证.只出现一次，而不能出现两次以上   
	     obj.value = obj.value.replace('.','$#$').replace(/\./g,'').replace('$#$','.');
	   //保证-只出现一次，而不能出现两次以上   
	     obj.value = obj.value.replace('-','$#$').replace(/\-/g,'').replace('$#$','-');
	},
	showPartMessage: function(element) {
		var title = $(element).attr("title");
		if (title != "null - null") {
			title = $(element).prev().html() + " : " + title;
			$("#size_message").html(title);
		}
	},
	generateBodyType: function(orden) {
		var singleClothings = this.getSingleClothings();
		$.each(singleClothings,
		function(i, singleClothing) {
			if (i == 0) {
				clothing = singleClothing.ID;
			}
		});
		// 单选钮的项name的命名 option_bodytype_10111,option_bodytype_10112
		var bodyType = $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingbodytype'), $.csControl.appendKeyValue("", "sizecategoryid", $.csControl.getRadioValue("size_category")));
		var domRadio = "";
		if (!$.csValidator.isNull(bodyType)) {
			// 特体信息
			for (var i = 0; i < bodyType.length; i++) {
				if (bodyType[i].categoryID != DICT_CATEGORY_BODYTYPE) {
					var bodyTypes = bodyType[i].bodyTypes;
					if (bodyTypes != "") {
						if (i == bodyType.length - 1) {
							domRadio += "<ul id='clothing_style' class='hline'>";
						} else {
							domRadio += "<ul class='hline'>";
						}
						domRadio += "<li style='width:620px;clear:both;font-weight:bold;'>" + bodyType[i].categoryName + "</li>";
						for (var j = 0; j < bodyTypes.length; j++) {
							domRadio += "<li><label><input type='checkbox' ";
							if (!orden || !orden.ordenID) {
								if (bodyTypes[j].ID == DICT_BODY_TYPE || bodyTypes[j].ID == DICT_CLONTHING_SIZE) {
									domRadio += "checked='true' ";
								} else if (j == 0 && i < bodyType.length - 1) {
									domRadio += "checked='true' ";
								}
							}
							domRadio += "  name='body_type_" + bodyType[i].categoryID + "' value='" + bodyTypes[j].ID + "' onclick='$.csControl.checkOnce(this);'  onfocus='$.csSize.playShow(-1," + $.csControl.getRadioValue("size_category") + "," + bodyTypes[j].ID + ");'/> " + bodyTypes[j].name + "</label></li>";
						}
						domRadio += "</ul>";
					}
				}
			}
			// 着装风格
			$.each(singleClothings,
			function(i, singleClothing) {
				for (var i = 0; i < bodyType.length; i++) {
					if (bodyType[i].categoryID == DICT_CATEGORY_BODYTYPE) {
						var bodyTypes = bodyType[i].bodyTypes;
						if (bodyTypes != "") {
							if (i == bodyType.length - 1) {
								domRadio += "<ul id='clothing_style' class='hline'>";
							} else {
								domRadio += "<ul class='hline'>";
							}
							domRadio += "<li style='width:620px;clear:both;font-weight:bold;'>" + bodyType[i].categoryName + "&nbsp;" + singleClothing.name + "</li>";
							for (var j = 0; j < bodyTypes.length; j++) {
								if (bodyType[i].categoryID == DICT_CATEGORY_BODYTYPE) {
									var strs = new Array();
									strs = bodyTypes[j].extension.split(",");
									for (var n = 0; n < strs.length; n++) {
										if (strs[n] == singleClothing.ID) {
											domRadio += "<li><label><input type='checkbox' ";
											if (!orden || !orden.ordenID) {
												if (bodyTypes[j].ID == DICT_BODY_TYPE) {
													domRadio += "checked='true' ";
												}
											}
											if(orden != null){
												if(orden.clothingID != $.csControl.getRadioValue("clothingID") && bodyTypes[j].ID == DICT_BODY_TYPE){
													if(orden.clothingID == 1 && (singleClothing.ID == 3000  || singleClothing.ID == 4000 || singleClothing.ID == 6000)){
														domRadio += "checked='true' ";
													}else if(orden.clothingID == 2 && (singleClothing.ID == 3000 || singleClothing.ID == 6000)){
														domRadio += "checked='true' ";
													}else if(orden.clothingID == 3 && (singleClothing.ID == 2000 ||singleClothing.ID == 3000 ||singleClothing.ID == 4000 || singleClothing.ID == 6000)){
														domRadio += "checked='true' ";
													}else if(orden.clothingID == 2000 && (singleClothing.ID == 3 ||singleClothing.ID == 3000 ||singleClothing.ID == 4000 || singleClothing.ID == 6000)){
														domRadio += "checked='true' ";
													}else if(orden.clothingID == 3000 && (singleClothing.ID == 3 ||singleClothing.ID == 2000 ||singleClothing.ID == 4000 || singleClothing.ID == 6000)){
														domRadio += "checked='true' ";
													}else if(orden.clothingID == 4000 && (singleClothing.ID == 3 ||singleClothing.ID == 2000 ||singleClothing.ID == 3000 || singleClothing.ID == 6000)){
														domRadio += "checked='true' ";
													}else if(orden.clothingID == 6000 && (singleClothing.ID == 3 ||singleClothing.ID == 2000 ||singleClothing.ID == 3000 || singleClothing.ID == 4000)){
														domRadio += "checked='true' ";
													}
												}
											}
											
											domRadio += "  name='body_type_" + bodyType[i].categoryID + "_" + singleClothing.ID + "' id='body_type_" + bodyType[i].categoryID + "_" + singleClothing.ID + "_" + bodyTypes[j].ID + "' value='" + bodyTypes[j].ID + "' onclick='$.csControl.checkOnce(this);' onfocus='$.csSize.playShow(-1," + $.csControl.getRadioValue("size_category") + "," + bodyTypes[j].ID + ");'/> " + bodyTypes[j].name + "</label></li>";
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
	generateClothingCategory: function() {
		$("#size_spec_part").html('');
		var singleClothings = this.getSingleClothings();
		var dom = "";
		$.each(singleClothings,
		function(i, singleClothing) {
			dom += "<div>" + singleClothing.name + "</div>";
			dom += "<div id='spec_" + singleClothing.ID + "'></div>";
			dom += "<div id='part_" + singleClothing.ID + "'></div>";
		});

		$("#size_spec_part").html(dom);
	},
	buildPartID: function(partID) {
		return "part_label_" + partID;
	},
	getTempFabricCode: function() {
		return $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempfabriccode'));
	},
	validatePost: function() {
		if ($.csValidator.isNull(this.getTempFabricCode())) {
			$.csCore.alert($.csCore.getValue("Common_PleaseSelect", "Fabric_Moduler"));
			return false;
		}
		if ($.csValidator.isNull(this.requiredParts)) {
			return true;
		}
		if($.csControl.getRadioValue("size_category") == 10054){
			var temp = this.requiredParts.split(",");
			for (var i = 0; i < temp.length; i++) {
				partID = this.buildPartID(temp[i]);
				if ($.csValidator.checkNull(partID, $.csCore.getValue("Common_Required", "Size_Star"))) {
					return false;
				}
			}
		}
		//净体套装臀围尺寸必须一致 
		var clothingID= $.csControl.getRadioValue("clothingID");
		if(clothingID == undefined){
			clothingID = $.cookie('clothingid');
		}
//		alert(clothingID);alert($.csControl.getRadioValue("size_category"));
		if($.csControl.getRadioValue("size_category") == 10052  && (clothingID==1 || clothingID==2)){
			var tun_XF = $("input[name='part_label_10108']").attr("value"); 
			var tun_XK = $("input[name='2000part_label_10108']").attr("value"); 
//			alert(tun_XF+":"+tun_XK);
			if(tun_XF != tun_XK){
				$.csCore.alert($.csCore.getValue("SIZE_ERROR"));
				return false;
			}
		}
		return true;
	},
	getPartLabel: function(partID) {
		return $("#" + partID).parent().prev().html();
	},
	validatePartRange: function(partID, sizeStandardID, fromValue, toValue,obj) {
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
		/*var sizeStandardGroups = this.getClothingPartsByGroup(sizeStandardID);
		if (!$.csValidator.isNull(sizeStandardGroups)) {
			$.each(sizeStandardGroups,
			function(i, sizeStandardGroup) {
				var value = $("#" + partID).val();
				var newPartID = $.csSize.buildPartID(sizeStandardGroup.partID);
				if ($.csValidator.isNull($("#" + newPartID).val())) {
					$("#" + newPartID).val(value);
				}
			});
		}
		// -
		var sizeRangeMinus = $.csSize.getSizeRangeByStandardAndSign(sizeStandardID, "-");
		if (!$.csValidator.isNull(sizeRangeMinus)) {
			for (var i = 0; i < sizeRangeMinus.length; i++) {
				var sizeStandards = sizeRangeMinus[i].sizeStandardIDs.split(',');
				if (sizeStandards.length == 2) {
					var a = $.csSize.getSizeStandardByID(sizeStandards[0]);
					var b = $.csSize.getSizeStandardByID(sizeStandards[1]);
					var av = $("#" + $.csSize.buildPartID(a.partID)).val();
					var bv = $("#" + $.csSize.buildPartID(b.partID)).val();
					if (!$.csValidator.isNull(av) && !$.csValidator.isNull(bv)) {
						var result = av - bv;
						if (result < sizeRangeMinus[i].sizeFrom || result > sizeRangeMinus[i].sizeTo) {
							var current = $.csSize.getSizeStandardByID(sizeStandardID);
							$("#" + $.csSize.buildPartID(current.partID)).val('');
							var message = this.getPartLabel($.csSize.buildPartID(a.partID)) + " - " + this.getPartLabel($.csSize.buildPartID(b.partID));
							if (sizeRangeMinus[i].sizeFrom != -1000) {
								message = sizeRangeMinus[i].sizeFrom + " < " + message;
							}
							if (sizeRangeMinus[i].sizeTo != 1000) {
								message = message + " < " + sizeRangeMinus[i].sizeTo;
							}
							$("#size_message").html(message);
						}
					}
				}
			}
		}
		// *
		var sizeRangeMultiplication = $.csSize.getSizeRangeByStandardAndSign(sizeStandardID, "*");
		if (!$.csValidator.isNull(sizeRangeMultiplication)) {
			for (var i = 0; i < sizeRangeMultiplication.length; i++) {
				var sizeStandards = sizeRangeMultiplication[i].sizeStandardIDs.split(',');
				if (sizeStandards.length == 2) {
					var a = $.csSize.getSizeStandardByID(sizeStandards[0]);
					var b = $.csSize.getSizeStandardByID(sizeStandards[1]);
					var av = $("#" + $.csSize.buildPartID(a.partID)).val();
					var bv = $("#" + $.csSize.buildPartID(b.partID)).val();
					if (!$.csValidator.isNull(av) && !$.csValidator.isNull(bv)) {
						var span = (av - a.rangeStart) / a.rangeStep;
						var bvs = b.rangeStart + b.rangeStep * span; // 标准
						// alert(bvs);
						if (bvs > b.rangeStart) {
							var min = bvs + sizeRangeMultiplication[i].sizeFrom;
							// alert(min);
							var max = bvs + sizeRangeMultiplication[i].sizeTo;
							// alert(max);
							if (bv < min || bv > max) {
								var current = $.csSize.getSizeStandardByID(sizeStandardID);
								$("#" + $.csSize.buildPartID(current.partID)).val('');
								// $("#" +
								// $.csSize.buildPartID(current.partID)).attr('title',min+'-'+max);
								$("#size_message").html($("#" + $.csSize.buildPartID(current.partID)).parent().prev().html() + " : " + min + " - " + max);
								$("#" + $.csSize.buildPartID(current.partID)).parent().attr("title", min + " - " + max);
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
			var sizeRangeDivision = $.csSize.getSizeRangeBySign("/");
			if (!$.csValidator.isNull(sizeRangeDivision)) {
				var standardChest = $.csSize.getSizeStandardByID(2);
				var standardWaist = $.csSize.getSizeStandardByID(3);
				if (!$.csValidator.isNull(standardChest) && !$.csValidator.isNull(standardWaist)) {
					var vChest = $("#" + $.csSize.buildPartID(standardChest.partID)).val();
					var vWaist = $("#" + $.csSize.buildPartID(standardWaist.partID)).val();
					if (!$.csValidator.isNull(vChest) && !$.csValidator.isNull(vWaist)) {
						var result = vChest - vWaist;
						for (var i = 0; i < sizeRangeDivision.length; i++) {
							if (result > sizeRangeDivision[i].sizeFrom && result <= sizeRangeDivision[i].sizeTo) {
								$("input[type=checkbox][value=" + sizeRangeDivision[i].sizeStandardIDs + "]").parent().hide();
							}
						}
					}
				}
			}
		}*/
		$.csSize.onlyNumber(obj);
	},

	playShow: function(singleClothingID, sizeCategoryID, dictID) {
		if(undefined != $("#part_label_"+dictID).parent().attr('title')){
			$.csSize.showPartMessage($("#part_label_"+dictID).parent());
		};
		$("#size_video").html('');
		$("#size_video_ipad").html('');
		var path = server_context +"/size/"+ $.csCore.getCurrentVersion() + "/";
		if (singleClothingID != -1 && sizeCategoryID == DICT_SIZE_CATEGORY_CLOTH) {
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

		if ((sizeCategoryID == DICT_SIZE_CATEGORY_NAKED) || (singleClothingID == -1 && sizeCategoryID == -1)) {
//			if (!$.csValidator.isExistImg(videoFile)) {
//				dom += $.csCore.playVideo(width, height, videoFile);
//				dom_ipad += "<div style='width:240px;height:180px;' id='video_ipad' href='" + videoFile_ipad + "'></div>";
//			}
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
			if ($.csSize.rapid == true) {
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
			$f("video_ipad", server_context+"/scripts/jquery/flowplayer/flowplayer-3.2.15.swf").ipad();
		} else {
			$("#size_video").show();
			$("#size_video_ipad").hide();
		}
	},
	fillSizeUnit: function() {
		$.csControl.fillRadios("unitContainer", $.csCore.getDicts(DICT_CATEGORY_HEIGHTUNIT), "sizeUnitID", "ID", "name");
		$("#unitContainer input").click(function() {
//			$.csSize.generateArea();
			$.csSize.changeSizeUnit();
		});
	},
	fillStyle: function(orden) {
		$("#styleContainer").html("");
		if ($.csControl.getRadioValue("size_category") == DICT_SIZE_CATEGORY_NAKED) {
			var strDY="";
			if(orden != null && orden.styleDY != null){
				var arr=["0A01","0A02"];
				var checkedDY="";
				for(var i=0;i<arr.length;i++){
					if(orden.styleDY == arr[i]){
						checkedDY=" checked='true' ";
					}else{
						checkedDY="";
					}
					strDY+="<label style='display:inline;clear:none;'><input type='radio' name='styleDY' value='"+arr[i]+"' "+checkedDY+"/>"+$.csCore.getValue("DY_"+arr[i])+ "</label> ";
				}
			}else{
				strDY="<label style='display:inline;clear:none;'><input type='radio' name='styleDY' value='0A01'/>"+$.csCore.getValue("DY_0A01")+"</label><label style='display:inline;clear:none;'><input type='radio' name='styleDY' value='0A02' checked='true'/>"+$.csCore.getValue("DY_0A02")+ "</label> ";;
			}
			var clothingID = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempclothingid'));
	        var div = $('#styleContainer');
	        $.each($.csCore.getDicts(DICT_CATEGORY_STYLE), function (i, data) {
	        	if(orden != null && orden.styleID != null && eval("data.ID")==orden.styleID){
	                checked = " checked='true' ";
	        	}else if((orden == null && i == 0) || (orden != null && orden.styleID == null && i == 0)){
	                checked = " checked='true' ";
	        	}else {
	                checked = "";
	            };
	            if(clothingID == 6000 && eval("data.ID") != 20102){
	            	var inputRadio = "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='styleID' value='" + eval("data.ID") + "'>" + eval("data.name")+ "</label> ";
		            div.append(inputRadio);
	            }else if(clothingID != 6000){
	            	var inputRadio = "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='styleID' value='" + eval("data.ID") + "'>" + eval("data.name") + "</label> ";
		            div.append(inputRadio);
	            }
	        });
	        if(clothingID == 6000){
	            div.append(strDY + "</label>");
            }
	        /* if (orden != null && orden.styleID != null) {
			$.csControl.fillRadio("styleContainer", $.csCore.getDicts(DICT_CATEGORY_STYLE), "styleID", "ID", "name", orden.styleID);
		} else {
			$.csControl.fillRadios("styleContainer", $.csCore.getDicts(DICT_CATEGORY_STYLE), "styleID", "ID", "name");
		}*/
		}
	},
	getSingleClothings: function() {
		var singleClothings = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getsingleclothings'));
		return singleClothings;
	},
	getClothingPartsByGroup: function(sizeStandardID) {
		var param = $.csControl.appendKeyValue("", "unitid", $.csControl.getRadioValue("sizeUnitID"));
		param = $.csControl.appendKeyValue(param, "sizestandardid", sizeStandardID);
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingpartsbygroup'), param);
	},
	getSizeRangeByStandardAndSign: function(sizeStandardID, sign) {
		var param = $.csControl.appendKeyValue("", "sign", sign);
		param = $.csControl.appendKeyValue(param, "sizestandardid", sizeStandardID);
		param = $.csControl.appendKeyValue(param, "unitid", $.csControl.getRadioValue("sizeUnitID"));
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizerangebysizestandardandsign'), param);
	},
	getSizeRangeBySign: function(sign) {
		var param = $.csControl.appendKeyValue("", "sign", sign);
		param = $.csControl.appendKeyValue(param, "unitid", $.csControl.getRadioValue("sizeUnitID"));
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizerangebysign'), param);
	},
	getSizeStandardByID: function(id) {
		var param = $.csControl.appendKeyValue("", "id", id);
		param = $.csControl.appendKeyValue(param, "unitid", $.csControl.getRadioValue("sizeUnitID"));
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizestandardbyid'), param);
	},
	changeAmount : function(){//追加西裤与数量只能二选一
		if($("#morePants").attr("checked") != "checked"){
			$("#shirtAmount").attr('disabled',false);
		}else{
			$("#shirtAmount").attr('disabled',true);
			$("#shirtAmount").val(1);
		}
	},
	init: function(orden, rapid) {
		$.csSize.rapid = rapid;
		$.csSize.generateSizeCategory(orden);
		if (!$.csValidator.isNull(orden) && !$.csValidator.isNull(orden.ordenID)) {
			$.csControl.initSingleCheck(orden.sizeCategoryID);
			$("input[value='" + orden.sizeUnitID + "']").attr("checked", "checked");
			$.csSize.generateArea(orden);
			if (!$.csValidator.isNull(orden.sizePartValues)) {
				var partValues = orden.sizePartValues.split(",");
				$.each(partValues,
				function(i, partValue) {
					var key_value = partValue.split(":");
					var clothing_xk="";
					if(undefined != key_value[1]){
						if(key_value[0]==10108 && orden.clothingID ==DICT_CLOTHING_PANT){
							clothing_xk="2000";
						}
						$('input[name=' + clothing_xk + $.csSize.buildPartID(key_value[0]) + ']').val(key_value[1]);
					}else{
						clothing_xk="2000";
						$('input[name=' + clothing_xk + $.csSize.buildPartID(10108) + ']').val(key_value[0]);
					}
//					$('input[name=' + $.csSize.buildPartID(key_value[0]) + ']').val(key_value[1]);
					// $('#' +
					// $.csSize.buildPartID(key_value[0])).val(key_value[1]);
				});
			}

			if (!$.csValidator.isNull(orden.sizeBodyTypeValues)) {
				var bodyTypes = orden.sizeBodyTypeValues.split(",");
				$.each(bodyTypes,
				function(i, bodyType) {
					$.csControl.initSingleCheck(bodyType);
				});
			}
			// 着装风格
			if (!$.csValidator.isNull(orden.componentTexts)) {
				var details = orden.ordenDetails;
				for (var n = 0; n < details.length; n++) {
					var style = orden.componentTexts.split(",");
					for (var i = 1; i < style.length; i++) {
						var clothingstyle = style[i].split(":");
						if (details[n].singleClothingID == clothingstyle[0]) {
							// $.csControl.initSingleCheck(clothingstyle[1]);
							$.csControl.initSingleCheckById("body_type_32_" + clothingstyle[0] + "_" + clothingstyle[1]);
						}
					}
				}
			}
			//订单数量
			/*if($.csControl.getRadioValue("size_category") == 10054 || orden.clothingID == 3000 || orden.clothingID == 5000){//标准号
				$("#more_shirt").show();*/
				$("#shirtAmount").val(orden.ordenDetails[0].amount);
			/*}else{
				$("#more_shirt").hide();
			}*/
			if(orden.morePants==10050){//追加一条西裤
				$("#morePants").attr("checked",true);
				$("#shirtAmount").val(1);
				$("#shirtAmount").attr('disabled',true);
			}
//			if(orden.clothingID == DICT_CLOTHING_ChenYi){
//				$("#shirtAmount").val(orden.ordenDetails[0].amount);
//			}
		}else{//美洲系统 尺寸单位默认英寸
			var realm = window.location.href; 
			if(realm.indexOf("172.17.4.5") >=0 || realm.indexOf("us.rcmtm.com") >=0){
				$("input[value='10265']").attr("checked", "checked");
				$.csSize.changeSizeUnit();
			}
		}
		var clothingID = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempclothingid'));
		if(clothingID != 1 && clothingID != 2 && clothingID != 4 && clothingID != 2000){
			$("#morePants").attr("checked",false);
			/*$("#shirtAmount").val(1);*/
			$("#shirtAmount").attr('disabled',false);
		}
		if (!$.csValidator.isNull(clothingID)) {
//			$.csCore.getValue("Orden_MorePants",null,"#more_pants p");
			//订单数量
			var clothing = $.csCore.getDictByID(clothingID);
			var singles = clothing.extension.split(",");
			if (singles.length <= 1) {
				$('#more_pants').hide();
				if (singles == DICT_CLOTHING_PANT) {
					$('#more_pants').show();
				}
			} else {
				if (clothing.ID == DICT_CLOTHING_SUIT2PCS_AC) {
					$('#more_pants').hide();
				}else{
					$('#more_pants').show();
					$('#more_pants label input').attr('value', DICT_YES);
				}
			}
			/*if($.cookie("size_category") == 10054 || $.csControl.getRadioValue("size_category") == 10054 || clothingID == 3000 || clothingID == 5000){//标准号
				$("#more_shirt").show();
			}else{
				$("#more_shirt").hide();
			}*/
			// Style 长款、短款、正常款
			if (clothingID == DICT_CLOTHING_SUIT2PCS || clothingID == DICT_CLOTHING_SUIT3PCS || clothingID == DICT_CLOTHING_ShangYi 
					|| clothingID == DICT_CLOTHING_DaYi || clothingID == DICT_CLOTHING_SUIT2PCS_AC) {
				$("#style_title").show();
			} else {
				$("#style_title").hide();
			}
		}
		//选中已有的衣服大小号
		if (!$.csValidator.isNull(orden)) {
			if (!$.csValidator.isNull(orden.ordenDetails)) {
				$.each(orden.ordenDetails,
				function(i, detail) {
					if (!$.csValidator.isNull(detail.specHeight)) {
						$("[name='size_spec_height_" + detail.singleClothingID + "']:radio").each(function() {
							if (this.value == detail.specHeight) {
								this.checked = true;
							}
						});
					}
				});
			}
		}
	}
};