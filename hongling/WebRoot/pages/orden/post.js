jQuery.csOrdenPost = {
	bindLabel: function() {
		$.csCore.getValue("Orden_ClothingInfo",null,".lblClothingInfo");
		$.csCore.getValue("Customer_Info",null,".lblCustomer");
		$.csCore.getValue("Fabric_Info",null,".lblFabricInfo");
		$.csCore.getValue("Fabric_Moduler",null,".lblFabric");
		$.csCore.getValue("Orden_Detail",null,".lblDetail");
		$.csCore.getValue("Embroid_Info",null,".lblEmbroid");
		$.csCore.getValue("Size_Info",null,".lblSizeInfo");
		$.csCore.getValue("Common_Save",null,"#btnSaveOrden");
		$.csCore.getValue("Button_Submit",null,"#btnSubmitOrden");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelOrden");
	},
	bindEvent: function() {
		$("#btnSaveOrden").click();
		$("#btnSubmitOrden").click($.csOrdenPost.submitOrden);
		$("#btnSaveOrden").click($.csOrdenPost.save);
		$("#btnCancelOrden").click($.csCore.close);
		$("#fabricCode").blur($.csOrdenPost.fillOrdenAuto);
	},
	validate: function() {
		if ($.csCore.contain(DICT_FABRIC_SUPPLY_CATEGORY_CLIENT, $('#fabricCode').val())) {
			$('#fabricCode').val('');
		}
		if ($.csValidator.checkNull("fabricCode", $.csCore.getValue("Common_Required", "Fabric_Moduler"))) {
			return false;
		}
		return true;
	},
	buildTextID: function(id) {
		return "category_textbox_" + id;
	},
	generateClothing: function(clothingID) {
		var clothing = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		var dom = "<ul>";
		for (var i = 0; i < clothing.length; i++) {
			dom += "<li><label><input type='radio' name='clothingID' value='" + clothing[i].ID + "' onclick='$.csOrdenPost.clothingChange(" + clothing[i].ID + ");'/> " + clothing[i].name + "</label></li>";
		}
		dom += "</ul>";
		$("#container_clothings").html(dom);
		if ($.csValidator.isNull(clothingID)) {
			clothingID = clothing[0].ID;
		}
		$("input[value='" + clothingID + "']").attr("checked", "checked");
		$.csOrdenPost.generateComponent(clothingID);
		$.csOrdenPost.generateEmbroid(clothingID);
	},
	generateComponent: function(clothingID) {
		$("#container_component").html("");
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		for (var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name + "<a onclick='$.csOrdenPost.addComponentRow(" + arr[i] + ")'>" + $.csCore.getValue("Button_Add") + "</a></div>" + "<table id='category_" + arr[i] + "' class='list_result'></table>";
			$("#container_component").append(dom);
			$.csOrdenPost.addComponentRow(arr[i]);
		}
	},
	getComponentRowHTML: function(clothingID, index) {
		return "<tr index='" + index + "'>" + "<td><input type='text' id='text_" + clothingID + "_" + index + "' style='width:130px' class='textbox'/><span/></td>" + "<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>" + "</tr>";
	},
	addComponentRow: function(clothingID) {
		var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}
		$("#category_" + clothingID).append($.csOrdenPost.getComponentRowHTML(clothingID, parseInt(lastIndex) + 1));
		$.csOrdenPost.autoCompleteDict(clothingID, parseInt(lastIndex) + 1);
	},
	autoCompleteDict: function(clothingID, index) {
		var url = $.csCore.buildServicePath('/service/orden/getcomponentbykeyword?id=' + clothingID);
		$("#text_" + clothingID + "_" + index).autocomplete(url, {
			selectFirst: true,
			cacheLength:10,
			matchSubset :true,
			multiple: false,
			dataType: "json",
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.ID,
						result: row.ecode
					};
				});
			},
			formatItem: function(item) {
				return item.ecode + "(" + item.name + ")";
			}
		}).result(function(e, data) {
			$.csOrdenPost.autoCompleteLowerLevelDict(data.ID, url);
			var error = 0;
			$("input[id^='component_']").each(function() {
				if ($(this).attr("id") == "component_" + clothingID + "_" + data.ID) {
					$.csCore.alert($.csCore.getValue("Orden_Precess_Error"));
					error = 1;
				}
			} //是否选择同一种工艺 
			);
			var ids = "";
			if (error == 0) {
				$("input[id^='component_']").each(function() {
					var thisID = $(this).attr("id").substr($(this).attr("id").lastIndexOf("_") + 1);
					ids += thisID + ",";
					var dict = $.csCore.getDictByID(thisID);
					var parentDict = $.csCore.getDictByID(dict.parentID);
					if (parentDict.isSingleCheck == 10050 && dict.parentID == data.parentID) {
						//是选择同一种上级的工艺
						$.csCore.alert($.csCore.getValue("Orden_Precess_CheckTwo"));
						error = 1;
					}
					if (dict.statusID == 10001 && dict.parentID == data.parentID) {
						//是选择同一种上级的工艺
						$.csCore.alert($.csCore.getValue("Orden_Precess_CheckTwo"));
						error = 1;
					}
				});
			}
			if (error == 0 && ids.length > 0) {
				//同一上级可多选判断是否工艺冲突
				var url = $.csCore.buildServicePath("/service/orden/getdisabledbyother?ids=" + ids + "&id=" + data.ID);
				var result = $.csCore.invoke(url);
				if (result == true) {
					$.csCore.alert($.csCore.getValue("Orden_Precess_Conflict"));
					error = 1;
				}
			}
			if (error > 0) {
				$(this).next().html("");
				$(this).val("");
			} else {
				var parentDict = $.csCore.getDictByID(data.parentID);
				var parentparentDict = $.csCore.getDictByID(parentDict.parentID);
				var lowerLevelData = $.csCore.getDictsByParent(data.categoryID, data.ID);
				if (parentDict.ecode != null) {
					$(this).next().html(parentparentDict.name + parentDict.name + ":" + data.name);
				} else {
					$(this).next().html(data.name);
				}
				$(this).attr("disabled", "true");
				$(this).attr("id", "component_" + clothingID + "_" + data.ID);
				if (lowerLevelData.length > 0 && parentDict.statusID == null) {
					$(this).next().append("<input type='text' id='component_textbox_" + data.ID + "' style='width:150px' class='textbox'/>");
					var url = $.csCore.buildServicePath('/service/dict/getdictbykeyword?parentID=' + data.ID);
					$.csOrdenPost.autoCompleteLowerLevelDict(data.ID, url);
					$(this).attr("id", "doNot_" + data.ID);
				} else {
					if (!lowerLevelData.length > 0 && data.statusID == DICT_CUSTOMER_SPECIFIED) {
						var doms = "";
						if (PRICE.indexOf(data.ID) > -1) { //价格,只允许输入数字和小数点
							if ($.browser.mozilla) {
								doms = " onkeypress= 'if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return   false;} '";
							} else {
								doms = " onkeypress= 'if((event.keyCode <48||event.keyCode> 57) && event.keyCode!=46 && event.keyCode!=8){return   false;} '";
							}
						}
						$(this).next().append("<input type='text' id='category_textbox_" + data.ID + "' style='width:150px' class='textbox' " + doms + "/>");
					}
				}
			}
		});
	},
	autoCompleteLowerLevelDict: function(dictID, url) {
		$("#component_textbox_" + dictID).autocomplete(url, {
			multiple: false,
			mustMatch: true,
			dataType: "json",
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.ID,
						result: row.ecode
					};
				});
			},
			formatItem: function(item) {
				return item.ecode + "(" + item.name + ")";
			}
		}).result(function(e, data) {
			if (!$.csValidator.isNull(data)) {
				$("#component_textbox_" + dictID).attr("id", "component_" + data.ID);
			}
		});

	},
	clothingChange: function(clothingID) {
		var ordenID=$("#isAlipay").val();
		if ($.csValidator.isNull(ordenID)) {
			$.csOrdenPost.loadSize(clothingID, null);
		}else{
			var orden = $.csOrdenCommon.getOrdenByID(ordenID);
			$.csOrdenPost.loadSize(clothingID, orden);
		}
		$.csOrdenPost.generateComponent(clothingID);
//		$.csOrdenPost.generateComponent(clothingID);
		$.csOrdenPost.generateEmbroid(clothingID);
	},
	loadSize: function(clothingID, orden) {
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", clothingID));
		$.csCore.loadPage("container_size", "../size/size.htm",
		function() {
			$.csSize.init(orden, true);
		});
	},
	loadOrdenProcess: function(orden) {
		var dict = $.csCore.getDictByID(orden.clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		for (var i = 0; i < arr.length; i++) {
			$("#category_" + arr[i]).html("");
			var param = $.csControl.appendKeyValue('', 'ordenID', orden.ordenID);
			param = $.csControl.appendKeyValue(param, 'clothingID', arr[i]);
			 $.ajax({
                 url: $.csCore.buildServicePath("/service/orden/getordenprocessbyclothingid"),
                 data: { formData: param },
                 type: "post",
                 dataType: "json",
                 async: false,
                 success: function (data, textStatus, jqXHR) {
					$("#category_" + arr[i]).html(data);
                 },
                 error: function (xhr) {
                     d = xhr.responseText;
                 }
             });
		}
	},
	generateEmbroid: function(clothingID) {
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		$("#container_embroid").html("");
		for (var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name + "</div>" + "<table id='category_embroid_" + arr[i] + "' class='list_result'>" + $.csOrdenPost.getEmbroidRowHTML(arr[i]) + "</table>";
			$("#container_embroid").append(dom);
			$.csOrdenPost.fillEmbroidComposition(arr[i]);
		}
	},
	getEmbroidRowHTML: function(clothingID) {
		var size = "";
		if (clothingID == 3000) {
			size = "<td><span/><select id='category_label_" + clothingID + "_Size' style='width: 120px'/></td>";
		}
		var embroid = "<tr align='center'>" + "<td><span/><select id='category_label_" + clothingID + "_Position' style='width: 120px' /></td>" + "<td><span/><select id='category_label_" + clothingID + "_Color' style='width: 120px'/></td>" + "<td><span/><select id='category_label_" + clothingID + "_Font' style='width: 120px'/></td>" + "<td><span/><input type='text' id='category_textbox_" + clothingID + "_Content' style='width:120px;' class='textbox'/></td>" + size + "</tr>";
		return embroid;
	},
	fillEmbroidComposition: function(clothingID) {
		var param = $.csControl.appendKeyValue('', 'categoryid', clothingID);
		var dictsSeries = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getembroids'), param);
		//CXID 编辑页面，刺绣信息 ecode为空，不显示
		for (var j = 0; j < dictsSeries.length; j++) {
			if (j == 0) {
				$("#category_label_" + clothingID + "_Color").prev().html(dictsSeries[j].name + ":");
				var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_" + clothingID + "_Color", dicts, "CXID", "name", $.csCore.getValue("Common_PleaseSelect", "Common_MetaKeywords") + dictsSeries[j].name);
			}
			if (j == 1) {
				$("#category_label_" + clothingID + "_Font").prev().html(dictsSeries[j].name + ":");
				var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_" + clothingID + "_Font", dicts, "CXID", "name", $.csCore.getValue("Common_PleaseSelect", "Common_MetaKeywords") + dictsSeries[j].name);
			}
			if (j == 2) {
				$("#category_textbox_" + clothingID + "_Content").prev().html(dictsSeries[j].name + ":");
				$("#category_textbox_" + clothingID + "_Content").attr("id", "category_textbox_" + dictsSeries[j].ID);
			}
			if (clothingID == DICT_CLOTHING_ChenYi) {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Size").prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Size", dicts, "CXID", "name", $.csCore.getValue("Common_PleaseSelect", "Common_MetaKeywords") + dictsSeries[j].name);
				}
				if (j == 4) {
					$("#category_label_" + clothingID + "_Position").prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Position", dicts, "CXID", "name", $.csCore.getValue("Common_PleaseSelect", "Common_MetaKeywords") + dictsSeries[j].name);
				}
			} else {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Position").prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Position", dicts, "CXID", "name", $.csCore.getValue("Common_PleaseSelect", "Common_MetaKeywords") + dictsSeries[j].name);
				}
			}
		}
	},
	autoCompleteFabric: function() {
		var url = $.csCore.buildServicePath('/service/fabric/getfabricbykeyword');
		$("#fabricCode").autocomplete(url, {
			multiple: false,
			dataType: "json",
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.code,
						result: row.code
					};
				});
			},
			formatItem: function(item) {
				return item.code + "(" + item.categoryName + ")";
			}
		}).result(function(e, data) {
			if (data.fabricSupplyCategoryID != DICT_FABRIC_SUPPLY_CATEGORY_REDCOLLAR) {
				if (data.fabricSupplyCategoryID != DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_LARGE) {
					$("#fabricCode").next().html("<input type='text' id='MXK103' style='width:150px;' class='textbox'/>(成份)");
				}
			}
			$('#autoContainer').html("");
			var inventory = $.csOrdenPost.getFabricInventory(data.code);
			var hint = $.csCore.getValue('Fabric_Inventory') + ":" + inventory;
			$('#fabric_result').html(hint);
		});
	},
	fillOrdenAuto: function() {
		$('#fabric_result').html('');
		$('#autoContainer').html('');
		if (!$.csValidator.isNull($('#fabricCode').val())) {
			var inventory = $.csOrdenPost.getFabricInventory($('#fabricCode').val());
			if ($.csValidator.isNull(inventory) || inventory <= 0) {
				$('#autoContainer').html($.csCore.getValue("Orden_FabricArrivedControl") + "<br />");
				$.csControl.fillRadios("autoContainer", $.csCore.getDicts(DICT_CATEGORY_ORDEN_AUTO), "autoID", "ID", "name");
			}
		}
	},
	getFabricInventory: function(code) {
		return $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabricinventory'), $.csControl.appendKeyValue("", "code", code));
	},
	save: function() {
		if (!$(".lblCustomer").is(":hidden")) {
			if ($.csCustomer.validate() == false) {
				return false;
			}
		}
		if ($.csOrdenPost.validate() == false) {
			return false;
		}
		if ($.csSize.validatePost() == false) {
			return false;
		}

		var ordenID = $("#ordenID").val();
		if ($.csCore.postData($.csCore.buildServicePath("/service/orden/submitorden?type=1"), "form")) {
			if (!$.csValidator.isNull(ordenID) && ordenID.length == 36) {
				$.csCustomerPost.listOrdens();
			} else {
				$.csOrdenList.list(0);
			}
			$.csCore.close();
		}
	},
	submitOrden: function() {
		if (!$(".lblCustomer").is(":hidden")) {
			if ($.csCustomer.validate() == false) {
				return false;
			}
		}
		if ($.csOrdenPost.validate() == false) {
			return false;
		}
		if ($.csSize.validatePost() == false) {
			return false;
		}
		if($('#fabricCode').val().substr(0, 3) != "MDT" && $('#fabricCode').val().substr(0, 3) != "SDT" ){
		var inventory = $.csOrdenPost.getFabricInventory($('#fabricCode').val());
		if ($.csValidator.isNull(inventory) || inventory <= 0) {
			$.csCore.alert("面料不足！");
			return false;
			}
		}

		var ordenID = $("#ordenID").val();
		if ($.csCore.postData($.csCore.buildServicePath("/service/orden/submitorden"), "form")) {
			if (!$.csValidator.isNull(ordenID) && ordenID.length == 36) {
				$.csCustomerPost.listOrdens();
			} else {
				$.csOrdenList.list(0);
			}
			$.csCore.close();
		}
	},
	//	submitOrden : function() {
	//		if (!$(".lblCustomer").is(":hidden")) {
	//			if ($.csCustomer.validate() == false) {
	//				return false;
	//			}
	//		}
	//		if ($.csOrdenPost.validate() == false) {
	//			return false;
	//		}
	//		var ordenID = $("#ordenID").val();
	//		var isAlipay = $("#isAlipay").val();
	//		var member = $.csCore.getCurrentMember();
	//		if(member.payTypeID == DICT_MEMBER_PAYTYPE_ONLINE && isAlipay != DICT_YES){//虚拟支付+判断是否已支付
	//			$("#pay_bj").show();
	//		}else{//非虚拟支付 或 虚拟支付已支付但提交失败
	//			if ($.csCore.postData($.csCore
	//					.buildServicePath("/service/orden/submitorden"), "form")) {
	//				if (!$.csValidator.isNull(ordenID) && ordenID.length == 36) {
	//					$.csCustomerPost.listOrdens();
	//				} else {
	//					$.csOrdenList.list(0);
	//				}
	//				$.csCore.close();
	//			}
	//		}
	//	},
	//	ordenPay : function(type){
	//		if(type == 1){//支付宝
	//			$("#pay_bj").hide();
	//			var param =  $.csControl.getFormData("form");
	//			param = $.csControl.appendKeyValue(param,"type","1");
	//			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
	//			$("#alipay_submit").html(data);
	//	       // $.csOrdenList.list(0);
	//		}else if(type == 2){//paypail
	//			$("#pay_bj").hide();
	//			var param =  $.csControl.getFormData("form");
	//			param = $.csControl.appendKeyValue(param,"type","2");
	//			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
	//			$("#alipay_submit").html(data);
	//		}else{
	//			$("#pay_bj").hide();
	//		}
	//	},
	init: function(id, isPost) {
		$("#form").resetForm();
//		$.csOrdenCommon.bindLabel();
		$.csOrdenPost.bindLabel();
		$.csOrdenPost.bindEvent();
		$.csOrdenPost.autoCompleteFabric();
		var clothingID = $.csControl.getRadioValue('clothingID');
		if ($.csValidator.isNull(id)) {
			$.csOrdenPost.generateClothing();
			$.csCore.getValue("Common_Add","Orden_Moduler","#form h1");
			$.csCore.loadPage("container_customer", "../customer/customer.htm",
			function() {
				$.csCustomer.init();
			});
			$.csOrdenPost.loadSize(clothingID, null);
		} else {
			var orden = $.csOrdenCommon.getOrdenByID(id);
			$.csOrdenPost.generateClothing(orden.clothingID);
			if ($.csValidator.isNull(orden.customer)) {
				$(".lblCustomer").hide();
			} else {
				$(".lblCustomer").show();
				$.csCore.loadPage("container_customer", "../customer/customer.htm",
				function() {
					orden.customer.oldName=orden.customer.name;
					$.csCustomer.init(orden.customer);
				});
			}
			$.csOrdenPost.loadSize(orden.clothingID, orden);
			$.updateWithJSON(orden);
			if (isPost) {
				$('#ordenID').val('');
				$.csCore.getValue("Orden_Redo",null,"#form h1");
			} else {
				$.csCore.getValue("Common_Edit","Orden_Moduler","#form h1");
			}
			if (!$.csValidator.isNull(orden.components)) {
				var components = orden.components.split(",");
				$.each(components,
				function(i, component) {
					if (component != 1) {
						$.csControl.initSingleCheck(component);
					}
				});
			}
			if (!$.csValidator.isNull(orden.componentTexts)) {
				var componentTexts = orden.componentTexts.split(",");
				$.each(componentTexts,
				function(i, componentText) {
					var key_value = componentText.split(":");
					$('#' + $.csOrdenPost.buildTextID(key_value[0])).val(key_value[1]);
				});
			}

			if (!$.csValidator.isNull(orden.sizePartValues)) {
				var partValues = orden.sizePartValues.split(",");
				$.each(partValues,
				function(i, partValue) {
					var key_value = partValue.split(":");
					// $('#' +
					// $.csSize.buildPartID(key_value[0])).val(key_value[1]);
				});
			}
			if (!$.csValidator.isNull(orden.sizeBodyTypeValues)) {
				var type = $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingbodytype'), $.csControl.appendKeyValue("", "sizecategoryid", orden.sizeCategoryID));
				// 选中订单保存的特体信息
				var bodyTypes = orden.sizeBodyTypeValues.split(",");
				$.each(bodyTypes,
				function(i, bodyType) {
					$.csControl.initSingleCheck(bodyType);
				});
			}
			$.csOrdenPost.loadOrdenProcess(orden);
			//客户单号
			$("#userNo").val(orden.userordeNo);
			//款式
			if (!$.csValidator.isNull(orden.styleID) && orden.clothingID > DICT_CLOTHING_ShangYi && orden.sizeCategoryID == DICT_SIZE_CATEGORY_NAKED) {
				$.csControl.initSingleCheck(orden.styleID);
			}

			$("#isAlipay").val(orden.ordenID);
		}
	}
};