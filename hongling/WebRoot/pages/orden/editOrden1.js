jQuery.csOrdenPost = {
	// js获取项目根路径，如： http://localhost:8080/hongling
	getPath : function getRootPath() {
		// 获取当前网址，如： http://localhost:8080/hongling/orden/meun.jsp
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址，如： http://localhost:8080
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/hongling
		var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
		return (localhostPaht + projectName);
	},
	isInit : function() {
		return $('#isInit').val();
	},
	bindEvent : function() {
		$("#btnSubmitOrden").click($.csOrdenPost.submitOrden);
		$("#btnSaveOrden").click($.csOrdenPost.save);
		$("#btnCancelOrden").click($.csOrdenPost.cancelOrden);
		$("#fabricCode").blur($.csOrdenPost.fillOrdenAuto);
	},
	cancelOrden : function() {
		if ($.cookie("ordenSearchUrl") != null) {
			window.location.href = '/hongling/orden/dordenPage.do?' + $.cookie("ordenSearchUrl");
		} else {
			window.location.href = '/hongling/orden/dordenPage.do';
		}
	},
	validate : function() {
		if ($("#memos").val().length > 200) {
			$("#memos").val($("#memos").val().substring(0, 200));

		}
		if ($.csCore.contain(DICT_FABRIC_SUPPLY_CATEGORY_CLIENT, $('#fabricCode').val())) {
			$('#fabricCode').val('');
		}
		if ($.csValidator.checkNull("fabricCode", $.csCore.getValue("Common_Required", "Fabric_Moduler"))) {
			return false;
		}

		var clothing = $("input[name='clothingID']:checked").val();
		if (clothing == 1) {
			var result_XF = $.csOrdenPost.checkEmbroidNull('3');
			var result_XK = $.csOrdenPost.checkEmbroidNull('2000');
			if (result_XF == false || result_XK == false) {
				return false;
			}
		} else if (clothing == 2) {
			var result_XF = $.csOrdenPost.checkEmbroidNull('3');
			var result_XK = $.csOrdenPost.checkEmbroidNull('2000');
			var result_MJ = $.csOrdenPost.checkEmbroidNull('4000');
			if (result_XF == false || result_XK == false || result_MJ == false) {
				return false;
			}
		} else if (clothing == 4) {
			var result_MJ = $.csOrdenPost.checkEmbroidNull('4000');
			var result_XK = $.csOrdenPost.checkEmbroidNull('2000');
			if (result_XK == false || result_MJ == false) {
				return false;
			}
		} else if (clothing == 6) {
			var result_XF = $.csOrdenPost.checkEmbroidNull('3');
			var result_MJ = $.csOrdenPost.checkEmbroidNull('4000');
			if (result_XF == false || result_MJ == false) {
				return false;
			}
		} else {
			return $.csOrdenPost.checkEmbroidNull(clothing);
		}
		// 净体套装臀围尺寸必须一致
		var clothingID = $.csControl.getRadioValue("clothingID");
		if ($.csControl.getRadioValue("size_category") == 10052 && (clothingID == 1 || clothingID == 2)) {
			var tun_XF = $("input[name='part_label_10108']").attr("value");
			var tun_XK = $("input[name='2000part_label_10108']").attr("value");
			if (tun_XF != tun_XK) {
				$.csCore.alert($.csCore.getValue("SIZE_ERROR"));
				return false;
			}
		}
		return true;
	},
	checkEmbroidNull : function(clothing) {
		// 清除空行
		var embCount = $('#category_embroid_' + clothing + " tr").length;
		var rowNum = 0;
		for ( var i = 0; i < embCount; i++) {
			var selectDom = $('#category_embroid_' + clothing + " tr").eq(i - rowNum).find('select');
			var inputDom = $('#category_embroid_' + clothing + " tr").eq(i - rowNum).find('input');
			var selectColCount = selectDom.length;
			var inputColCount = inputDom.length;
			var isEmpty = true;
			for ( var j = 0; j < selectColCount; j++) {
				if (selectDom.eq(j).val() == undefined || selectDom.eq(j).val() == '-1') {
					isEmpty = true;
				} else {
					isEmpty = false;
					break;
				}
			}
			for ( var m = 0; m < inputColCount; m++) {
				if (!isEmpty) {
					break;
				}
				if (inputDom.eq(m).val() == undefined || inputDom.eq(m).val() == '') {
					isEmpty = true;
				} else {
					isEmpty = false;
					break;
				}
			}
			if (isEmpty) {
				$('#category_embroid_' + clothing + " tr").eq(i - rowNum).remove();
				rowNum++;
			}
		}
		var selecteDoms = $("#category_embroid_" + clothing + " select");
		for ( var i = 0; i < selecteDoms.length; i++) {
			if (selecteDoms.eq(i).val() == undefined || selecteDoms.eq(i).val() == '-1') {
				$.csCore.alert($.csCore.getValue("Embroidery_Error"));
				return false;
			}
		}
		var inputDoms = $("#category_embroid_" + clothing + " input");
		for ( var i = 0; i < inputDoms.length; i++) {
			if (inputDoms.eq(i).val() == undefined || inputDoms.eq(i).val() == '') {
				$.csCore.alert($.csCore.getValue("Embroidery_Error"));
				return false;
			}
		}
		// 刺绣位置不能重复
		for ( var i = 0; i < embCount; i++) {
			for ( var j = 0; j < embCount; j++) {
				if (i != j && $("#category_label_" + clothing + "_Position_" + i).val() != undefined && $("#category_label_" + clothing + "_Position_" + j).val() != undefined && $("#category_label_" + clothing + "_Position_" + i).val() == $("#category_label_" + clothing + "_Position_" + j).val()) {
					$.csCore.alert($.csCore.getValue("Orden_Embroidery_Error"));
					return false;
				}
			}
		}
	},
	checkLength : function(s) {
		var l = 0;
		var a = s.split("");
		for ( var i = 0; i < a.length; i++) {
			if (a[i].charCodeAt(0) < 299) {
				l++;
			} else {
				l += 2;
			}
		}
		return l;
	},
	buildTextID : function(id) {
		return "category_textbox_" + id;
	},
	// 生成服务分类,初始化
	generateClothing : function(clothingID, orden) {
		$.csProcess.inputProcess(clothingID);
		// 初始化标识,第一次是从后加载的
		if (this.isInit() != "1") {
			var clothing = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
			var dom = "<ul>";
			for ( var i = 0; i < clothing.length; i++) {
				dom += "<li><label><input type='radio' name='clothingID' value='" + clothing[i].ID + "' onclick='$.csOrdenPost.clothingChange(" + clothing[i].ID + ");'/> " + clothing[i].name + "</label></li>";
			}
			dom += "</ul>";
			$("#container_clothings").html(dom);
			if ($.csValidator.isNull(clothingID)) {
				clothingID = clothing[0].ID;
			}
			$("input[value='" + clothingID + "']").attr("checked", "checked");
			// 生成工艺信息
			$.csOrdenPost.generateComponent(clothingID, null);
		}
	},
	generateComponent : function(clothingID, orden) {
		// 初始化标识,第一次是从后加载的
		if (this.isInit() == "1") {
			return;
		}
		$("#container_component").html("");
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		for ( var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name + "<a onclick='$.csOrdenPost.addComponentRow(" + arr[i] + ")'>" + $("#addText").val() + "</a></div>" + "<table id='category_" + arr[i] + "' class='list_result'></table>";
			$("#container_component").append(dom);
			$.csOrdenPost.addComponentRow(arr[i]);
		}
		if (orden != null) {// 工艺信息(orden切换大类保存工艺)
			$.csOrdenPost.loadOrdenProcess(orden);
		}
	},
	getComponentRowHTML : function(clothingID, index) {
		return "<tr index='" + index + "'>" + "<td><input type='text' id='text_" + clothingID + "_" + index + "' style='width:130px' class='textbox'/><span/></td>" + "<td onclick='$(this).parent().remove();' " + "style='width:30px'><a class='remove'></a></td>" + "</tr>";
	},
	addComponentRow : function(clothingID) {
		var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}
		$("#category_" + clothingID).append($.csOrdenPost.getComponentRowHTML(clothingID, parseInt(lastIndex) + 1));
	},
	removeStyle : function(dictID, clothing, index, obj) {// 删除固化款式
		// 删除原有款式工艺
		var parentID = [ 1374, 2618, 4639, 3713, 6602, 90082, 95031, 98023 ];
		for ( var i = 0; i <= parentID.length; i++) {
			if (dictID == "") {// 新增时
				// 删除目标的行数
				var newIndex = obj.parent().attr("index");

				// 获得款式中工艺的最后 一条的Index(需要减去第一条index才是条数)
				var lastIndex = $("#category_" + clothing + " tr:last").attr("index");

				if (lastIndex > 0 && Number(lastIndex) > Number(newIndex)) {
					// 获得款式工艺中开始查条的起点(应该是newIndex的下一行)
					var smallIndex = 1;
					for ( var n = lastIndex; n > 1; n--) {
						if ($("#stylesProc_" + n).length > 0) {
							smallIndex = n;
						}
					}
					for ( var j = lastIndex; j > 1; j--) {
						var nIndex = smallIndex - 1;
						if ($("#stylesProc_" + j).length > 0 && nIndex == newIndex) {
							// $("#styles_"+clothing + "_" +
							// j).parent().remove();
							$("#stylesProc_" + j).parent().remove();
						}
					}
				}
			} else {// 编辑时
				if (dictID == parentID[i]) {
					for ( var j = index; j >= 0; j--) {
						$("#stylesProc_" + j).parent().remove();
					}
				}
			}
		}

	},
	clothingChange : function(clothingID) {// 切换服装大类
		var clothRadios = $('#container_clothings input:radio');
		for ( var i = 0; i < clothRadios.length; i++) {
			if (clothRadios[i].checked) {
				$(clothRadios[i]).parent().addClass('clothRadioChecked');
			} else {
				$(clothRadios[i]).parent().removeClass('clothRadioChecked').addClass('clothRadio');
			}
		}
		var oldclothingID = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempclothingid'));
		if (oldclothingID == clothingID) {
			return;
		}

		var size_category = $.csControl.getRadioValue("size_category");
		// 面料
		if ('' != $('#fabricCode').val()) {
			var fbs = "1,2,4,3,2000,4000,5000,90000,95000,98000,5,6,7";
			// 面料

			if (oldclothingID != clothingID && (fbs.indexOf(oldclothingID) < 0 || fbs.indexOf(clothingID) < 0)) {
				$('#fabricCode').val('');
			}
		}
		$('#autoContainer').html('');
		$('#fabric_result').html("");

		var localObj = window.location;
		var contextPath = localObj.pathname.split("/")[1];
		var basePath = localObj.protocol + "//" + localObj.host + "/" + contextPath;
		var server_context = basePath;

		$('#container_component').html('');
		$('#container_embroid').html('');
		$('#size_categoryUL').html('');
		$('#size_spec_part').html('');
		$('#size_bodytype').html('');
		$('#styleContainer').html('');
		$('#size_areaUL').html('');
		$('#size_video').html('');
		var size_unitID = $.csControl.getRadioValue("sizeUnitID");
		$.ajax({
			url : server_context + '/ordenajax/changeClothingAction.do',
			dataType : "json",
			async : false,
			data : {
				changeClothID : clothingID,
				changeOrdenID : $('#ordenID2').val(),
				size_unit : size_unitID
			},
			success : function(data) {
				$('#container_component').html(data.processHtml);
				$('#container_embroid').html(data.embroideryHtml);
				$('#size_categoryUL').html(data.size_categoryHtml);
				$('#size_spec_part').html(data.size_inputHtml);
				$('#size_bodytype').html(data.bodyTypeHtml);
				$('#styleContainer').html(data.titleHtml);
				$('#size_areaUL').html(data.size_areaHtml);
				$('#size_video').html(data.imgHtml);
				$.csProcess.inputProcess(clothingID);
			}
		});

		if ('1' != clothingID && '2' != clothingID && '4' != clothingID && '2000' != clothingID) {
			$('#morePants').attr('checked', '').removeAttr('checked');
			;
			$('#shirtAmount').attr('disabled', '').removeAttr('disabled').val('1');
			$('#more_pants').hide();
		} else {
			$('#more_pants').attr('display', 'block');
			$('#more_pants').show();
		}
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", clothingID));
		$.csOrdenPost.autoCompleteFabric();
		return;
		var ordenID = $("#isAlipay").val();
		if ($.csValidator.isNull(ordenID)) {
			$.csOrdenPost.loadSize(clothingID, null);
			$.csOrdenPost.generateComponent(clothingID, null);
			$.csOrdenPost.generateEmbroid(clothingID, '');
			if (clothingID == 3000) {
				$("#category_3000").html("<tr index='1'><td><input type='text'  disabled='disabled' id='component_3000_3028'  value='5000' style='width:130px' class='textbox'/> <span style='color: rgb(153, 153, 153);'>长袖</span></td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			}
		} else {
			var orden = $.csOrdenCommon.getOrdenByID(ordenID);
			$.csOrdenPost.loadSize(clothingID, orden);// 尺寸信息(orden切换大类保存尺寸)
			$.csOrdenPost.generateComponent(clothingID, orden);// 工艺信息(orden切换大类保存工艺)
			$.csOrdenPost.generateEmbroid(clothingID, orden);
			$.csOrdenPost.loadOrdenEmbroid(orden);// 订单刺绣信息 赋值
			if (orden.clothingID != 3000 && clothingID == 3000) {
				$("#category_3000").html("<tr index='1'><td><input type='text'  disabled='disabled' id='component_3000_3028'  value='5000' style='width:130px' class='textbox'/> <span style='color: rgb(153, 153, 153);'>长袖</span></td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			}
		}
	},
	loadSize : function(clothingID, orden) {
		$('#container_size').empty();
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", clothingID));
		$.csCore.loadPage("container_size", $.csOrdenPost.getPath() + "/pages/size/size9.jsp", function() {
			$.csSize.init(orden, true);
		});
	},
	loadOrdenEmbroid : function(orden) {// 订单刺绣信息 赋值
		if (orden.ordenDetails != null) {
			for ( var n = 0; n < orden.ordenDetails.length; n++) {
				if (orden.ordenDetails[n].emberoidery != null) {
					for ( var m = 0; m < orden.ordenDetails[n].emberoidery.length; m++) {
						if (orden.ordenDetails[n].emberoidery[m].location != null) {
							$("#category_label_" + orden.ordenDetails[n].singleClothingID + "_Position_" + m).val(orden.ordenDetails[n].emberoidery[m].location.ID);
						}
						if (orden.ordenDetails[n].emberoidery[m].color != null) {
							$("#category_label_" + orden.ordenDetails[n].singleClothingID + "_Color_" + m).val(orden.ordenDetails[n].emberoidery[m].color.ID);
						}
						if (orden.ordenDetails[n].emberoidery[m].font != null) {
							$("#category_label_" + orden.ordenDetails[n].singleClothingID + "_Font_" + m).val(orden.ordenDetails[n].emberoidery[m].font.ID);
						}
						$(".category_textbox_" + orden.ordenDetails[n].singleClothingID + "_Content_" + m).val(orden.ordenDetails[n].emberoidery[m].content);
						if (orden.ordenDetails[n].singleClothingID == 3000) {
							if (orden.ordenDetails[n].emberoidery[m].size != null) {
								$("#category_label_" + orden.ordenDetails[n].singleClothingID + "_Size_" + m).val(orden.ordenDetails[n].emberoidery[m].size.ID);
							}
						}
						if (orden.ordenDetails[n].singleClothingID == 5000) {
							// 不许录绣字大小的配件刺绣位置，特定这几个
							var arr = [ 82336, 83028, 83029, 83030, 83031, 83032, 83033 ];
							$.each(arr, function(i) {
								if ($("#category_label_5000_Position_" + m).val() == arr[i]) {
									$("#category_label_5000_Size_" + m).attr("disabled", true);
								}
							});
						}
					}
				}
			}
		}
	},
	loadOrdenProcess : function(orden) {
		// 初始化标识,第一次是从后加载的
		if (this.isInit() == "1") {
			return;
		}

		var dict = $.csCore.getDictByID(orden.clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		for ( var i = 0; i < arr.length; i++) {
			$("#category_" + arr[i]).html("");
			var param = $.csControl.appendKeyValue('', 'ordenID', orden.ordenID);
			param = $.csControl.appendKeyValue(param, 'clothingID', arr[i]);
			$.ajax({
				url : $.csCore.buildServicePath("/service/orden/getordenprocessbyclothingid"),
				data : {
					formData : param
				},
				type : "post",
				dataType : "json",
				async : false,
				success : function(data, textStatus, jqXHR) {
					$("#category_" + arr[i]).html(data);
				},
				error : function(xhr) {
					d = xhr.responseText;
				}
			});
		}
	},
	generateEmbroid : function(clothingID, orden) {
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		$("#container_embroid").html("");
		for ( var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name + "<a onclick='$.csOrdenPost.addEmbroidRow(" + arr[i] + ")'>" + $("#addText").val() + "</a><input id='clothing" + arr[i] + "' style=' display: none;'/></div>" + "<table id='category_embroid_" + arr[i] + "' class='list_result'>" + $.csOrdenPost.getEmbroidRowHTML(arr[i], 0) + "</table>";
			$("#container_embroid").append(dom);
			if (orden != '' && orden.ordenDetails != null) {
				var num = 0;
				for ( var n = 0; n < orden.ordenDetails.length; n++) {
					if (orden.ordenDetails[n].singleClothingID == arr[i]) {
						if (orden.ordenDetails[n].emberoidery != null && orden.ordenDetails[n].emberoidery.length > 0) {
							num++;
							for ( var m = 0; m < orden.ordenDetails[n].emberoidery.length; m++) {
								if (m > 0) {
									$.csOrdenPost.addEmbroidRow(arr[i]);
								}
								$.csOrdenPost.fillEmbroidComposition(arr[i], m);
							}
						} else {
							num++;
							$.csOrdenPost.fillEmbroidComposition(arr[i], 0);
						}
					}
				}
				if (num == 0) {
					$.csOrdenPost.fillEmbroidComposition(arr[i], 0);
				}
			} else {
				$.csOrdenPost.fillEmbroidComposition(arr[i], 0);
			}
		}
	},
	addEmbroidRow : function(clothingID) {
		var lastIndex = $("#category_embroid_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		} else {
			lastIndex = parseInt(lastIndex) + 1;
		}
		$("#category_embroid_" + clothingID).append($.csOrdenPost.getEmbroidRowHTML(clothingID, lastIndex));
		$.csOrdenPost.fillEmbroidComposition(clothingID, lastIndex);
		$.csOrdenPost.copyEmbroidComposition(clothingID, lastIndex);
		$("#clothing" + clothingID).val(lastIndex);
	},
	getEmbroidRowHTML : function(clothingID, index) {
		var size = "";
		var disabled = "";
		if (clothingID == 3000 || clothingID == 5000) {
			size = "<td ><span/><select id='category_label_" + clothingID + "_Size_" + index + "' style='width: 120px' /></td>";
		}
		var embroid = "<tr align='center' index='" + index + "'>" + "<td><span/><select id='category_label_" + clothingID + "_Position_" + index + "' style='width: 120px' onchange=$.csOrdenPost.changePosition('" + clothingID + "','" + index + "')/></td>" + "<td><span/><select id='category_label_" + clothingID + "_Color_" + index + "' style='width: 120px' /></td>" + "<td><span/><select id='category_label_" + clothingID + "_Font_" + index + "' style='width: 120px' /></td>" + "<td><span/><input type='text' id='category_textbox_" + clothingID + "_Content_" + index + "' style='width:120px;background-color: #FFF; border: 1px solid #626061; color: #000;height: 20px;line-height: 20px;' class='category_textbox_" + clothingID + "_Content_" + index + "'/></td>" + size + "<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>";
		return embroid;
	},
	fillEmbroidComposition : function(clothingID, index) {
		var param = $.csControl.appendKeyValue('', 'categoryid', clothingID);
		var dictsSeries = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getembroids'), param);
		// CXID 编辑页面，刺绣信息 ecode为空，不显示
		for ( var j = 0; j < dictsSeries.length; j++) {
			if (j == 0) {
				$("#category_label_" + clothingID + "_Color_" + index).prev().html(dictsSeries[j].name + ":");
				var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_" + clothingID + "_Color_" + index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
			}
			if (j == 1) {
				$("#category_label_" + clothingID + "_Font_" + index).prev().html(dictsSeries[j].name + ":");
				var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_" + clothingID + "_Font_" + index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
			}
			if (j == 2) {
				$("#category_textbox_" + clothingID + "_Content_" + index).prev().html(dictsSeries[j].name + ":");
				$("#category_textbox_" + clothingID + "_Content_" + index).attr("id", "category_textbox_" + dictsSeries[j].ID);
			}
			if (clothingID == DICT_CLOTHING_ChenYi) {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Size_" + index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Size_" + index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
				if (j == 4) {
					$("#category_label_" + clothingID + "_Position_" + index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csOrdenPost.fillOptions("category_label_" + clothingID + "_Position_" + index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
			} else {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Position_" + index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csOrdenPost.fillOptions("category_label_" + clothingID + "_Position_" + index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
				if (j == 4 && clothingID == 5000) {
					$("#category_label_" + clothingID + "_Size_" + index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Size_" + index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
			}
		}
	},
	copyEmbroidComposition : function(clothingID, index) {
		$("#category_label_" + clothingID + "_Color_" + index).val($("#category_label_" + clothingID + "_Color_0").val());
		$("#category_label_" + clothingID + "_Font_" + index).val($("#category_label_" + clothingID + "_Font_0").val());
		if (clothingID == 3000 || clothingID == 5000) {
			$("#category_label_" + clothingID + "_Size_" + index).val($("#category_label_" + clothingID + "_Size_0").val());
		}

	},
	setEmbroidValue : function(clothingID, type) {
		var index = $("#clothing" + clothingID).val();
		for ( var i = 1; i <= index; i++) {
			$("#category_label_" + clothingID + "_" + type + "_" + i).val($("#category_label_" + clothingID + "_" + type + "_0").val());
		}
	},
	changePosition : function(clothingID, index) {
		var n = 0;
		if (clothingID == 5000) {
			// 不许录绣字大小的配件刺绣位置，特定这几个
			var arr = [ 82336, 83028, 83029, 83030, 83031, 83032, 83033 ];
			$.each(arr, function(i) {
				if ($("#category_label_5000_Position_" + index).val() == arr[i]) {
					$("#category_label_5000_Size_" + index).val(80978);
					$("#category_label_5000_Size_" + index).attr("disabled", true);
					n++;
				}
			});
		}
		if (clothingID == 5000 && n == 0) {
			$("#category_label_5000_Size_" + index).attr("disabled", false);
		}
	},
	fillOptions : function(select, datas, fieldValue, fieldText, firstHint) {
		select = $('#' + select).empty();
		if (firstHint != null && firstHint != "") {
			var optionFirst = "<option title='" + firstHint + "' value='-1'>" + firstHint + "</option>";
			select.append(optionFirst);
		}
		;
		$.each(datas, function(i, data) {
			if (data.ecode != null) {
				var actionValue = "data.ID";
				var actionText = "data." + fieldText;
				var textTength = "data.memo";
				var option = "<option title='" + eval(actionText) + "' value='" + eval(actionValue) + "' memo='" + eval(textTength) + "'>" + eval(actionText) + "</option>";
				select.append(option);
			}
		});
	},
	autoCompleteFabric : function() {
		$("#fabricCode").unautocomplete();
		var clothingID = $.csControl.getRadioValue("clothingID");
		var fabrics=sessionStorage.getItem("fabrics_"+clothingID);
		if (fabrics==null) {
			var fabrics =$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getFabricByClothingID'));
			sessionStorage.setItem("fabrics_"+clothingID,JSON.stringify(fabrics));
		}else{
			fabrics=JSON.parse(fabrics);
		}
		$("#fabricCode").autocomplete(fabrics, {
			minChars : 1, // 自动完成激活之前填入的最小字符
			width : 150, // 提示的宽度，溢出隐藏
			scrollHeight : 300, // 提示的高度，溢出显示滚动条
			selectFirst : true,
			cacheLength : 10,
			matchSubset : true,
			multiple : false,
			formatResult: function(row) {
				return row.code;
			},
			formatItem: function(item) {
				return item.code + "[" + item.categoryName + "]";
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
	fillOrdenAuto : function() {
		var fabricCode = $('#fabricCode').val();
		// 录入面料必须是字母与数字组合，长度不小于三的
		if (fabricCode.length <= 3) {
			$('#fabricCode').val('');
			return;
		}
		;
		$('#fabric_result').html('');
		$('#autoContainer').html('');
		if (!$.csValidator.isNull($('#fabricCode').val())) {
			var inventory = $.csOrdenPost.getFabricInventory($('#fabricCode').val());
			if ($.csValidator.isNull(inventory) || inventory <= 0) {
				$.csControl.fillRadios("autoContainer", $.csCore.getDicts(DICT_CATEGORY_ORDEN_AUTO), "autoID", "ID", "name");
			}
		}
	},
	getFabricInventory : function(code) {
		return $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabricinventory'), $.csControl.appendKeyValue("", "code", code));
	},
	setTempComponentid : function(component) {// 衬衣长短袖显示尺寸
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempcomponentid'), $.csControl.appendKeyValue("", "id", component));
	},

	/**
	 * 保存订单
	 * 
	 * @returns {Boolean}
	 */
	save : function() {
		// 非保存状态，不能提交订单
		$.csOrdenPost.checkOrdenStatus($("#ordenID").val());
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
		var url=$.csCore.buildServicePath("/service/orden/submitorden?type=1");
		var formData=$.csControl.getFormData("form");
		$.ajax({
			"type" : "post",
			"url" : url,
			"data" : { formData: formData },
			"datatype" : "json",
			"success" : function(data) {
				data = JSON.parse(data);
				if (data.indexOf('ordenID') >= 0) {
					var idAndErr = data.split("&");
					if ('' == $("#ordenID").val()) {
						$("#ordenID").val(idAndErr[0].split(":")[1]);
					}
					data = idAndErr[1];
				}
				$.csOrdenPost.saveOrSubmit(data, ordenID);
			},
			beforeSend : function() {
				// Handle the beforeSend event
				$("#submitWait").hide();
				$("#shade").show();// 显示遮罩层
			}
		});
	},
	submitOrden : function() {
		$("#submitWait").hide();
		// 非保存状态，不能提交订单
		$.csOrdenPost.checkOrdenStatus($("#ordenID").val());

		if (!$(".lblCustomer").is(":hidden")) {
			if ($.csCustomer.validate() == false) {
				$("#submitWait").show();
				return false;
			}
		}
		if ($.csOrdenPost.validate() == false) {
			$("#submitWait").show();
			return false;
		}
		if ($.csSize.validatePost() == false) {
			$("#submitWait").show();
			return false;
		}

		var ordenID = $("#ordenID").val();
		var isAlipay = $("#isPay").val();
		var member = $.csCore.getCurrentMember();
		if(member.statusID == 10043){
			$.csCore.alert($.csCore.getValue("CHECK_USERNO"));
			return false;
		}
		
		if ((member.companyID == 1002 || member.companyID == 1003) && member.userStatus == 10050) {
			$("#pay_srbj").hide();
			$("#shade").show();// 显示遮罩层
			setTimeout(function() {
				
				var url=$.csCore.buildServicePath("/member/submitorden");
				var formData=$.csControl.getFormData("form");
				$.ajax({
					"type" : "post",
					"url" : url,
					"data" : { formData: formData },
					"datatype" : "json",
					"success" : function(data) {
						data = JSON.parse(data);
						if (data.indexOf('ordenID') >= 0) {
							var idAndErr = data.split("&");
							if ('' == $("#ordenID").val()) {
								$("#ordenID").val(idAndErr[0].split(":")[1]);
							}
							data = idAndErr[1];
						}
						$("#shade").hide();// 隐藏遮罩层
						if (!$.csValidator.isNull(data)) {
							if (data.toUpperCase() == "OK") {
								var payToCCB = $.csCore.invoke($.csCore.buildServicePath('/member/ordenpaytosr'));
								$("#alipay_submit").html(payToCCB);
								$.csCore.invoke($.csCore.buildServicePath('/member/sendordendetail'));
								$("#form").resetForm();

								if ($.cookie("ordenSearchUrl") != null) {
									window.location.href = '/hongling/orden/dordenPage.do?' + $.cookie("ordenSearchUrl");
								} else {
									window.location = this.getPath() + '/orden/ordenListPage_transitAction.do';
								}
							} else {
								$("#submitWait").show();
								$.csCore.alert(data);
							}
						}
					},
					beforeSend : function() {
						// Handle the beforeSend event
						$("#submitWait").hide();
						$("#shade").show();// 显示遮罩层
					}
				});
				
			}, 0.1);// 延迟0.1毫秒提交(显示遮罩层)
		} else if (member.payTypeID == DICT_MEMBER_PAYTYPE_ONLINE && isAlipay != DICT_YES) {// 在线支付+判断是否已支付
			$("#pay_bj").show();
		} else {// 非在线支付 或 在线支付已支付但提交失败
			$("#shade").show();// 显示遮罩层

			setTimeout(function() {
				
				var url=$.csCore.buildServicePath("/service/orden/submitorden");
				var formData=$.csControl.getFormData("form");
				$.ajax({
					"type" : "post",
					"url" : url,
					"data" : { formData: formData },
					"datatype" : "json",
					"success" : function(data) {
						data = JSON.parse(data);
						if (data.indexOf('ordenID') >= 0) {
							var idAndErr = data.split("&");
							if ('' == $("#ordenID").val()) {
								$("#ordenID").val(idAndErr[0].split(":")[1]);
							}
							data = idAndErr[1];
						}
						$.csOrdenPost.saveOrSubmit(data, ordenID);
					},
					beforeSend : function() {
						// Handle the beforeSend event
						$("#submitWait").hide();
						$("#shade").show();// 显示遮罩层
					}
				});
				
			}, 0.1);// 延迟0.1毫秒提交(显示遮罩层)
		}
	},
	saveOrSubmit : function(data, ordenID) {
		$("#shade").hide();// 隐藏遮罩层
		if (!$.csValidator.isNull(data)) {
			if (data.toUpperCase() == "OK") {
				$("#form").resetForm();
				if (!$.csValidator.isNull(ordenID) && ordenID.length == 36) {
					$.csCustomerPost.listOrdens();
				} else {
					if ($.cookie("ordenSearchUrl") != null) {
						self.location = document.referrer;
					} else {
						self.location = document.referrer;
					}
				}
			} else {
				if ("" == ordenID) {// 复制订单、快速下单
					// 面料价格未维护
					if (data == $.csCore.getValue("Bl_Error_189") || data == $.csCore.getValue("Bl_Error_190")) {
						$("#submitWait").show();
						$.csCore.alert(data);
					} else {
						$("#submitWait").show();
						$.csCore.alert(data);

					}
				} else {// 编辑
					$("#submitWait").show();
					$.csCore.alert(data);
				}
			}
		}
	},
	ordenPay : function(type) {
		if (type == 1) {// 支付宝
			$("#pay_bj").hide();
			var param = $.csControl.getFormData("form");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/alipay/submitorden'), param);
			if (data.indexOf('ordenID') >= 0) {
				var idAndErr = data.split("&");
				if ('' == $("#ordenID").val()) {
					$("#ordenID").val(idAndErr[0].split(":")[1]);
				}
				data = idAndErr[1];
			}
			if (data.substr(0, 2) == "OK") {
				$("#alipay_submit").html(data.substr(2, data.length - 2));
			} else {
				$.csCore.alert(data);
			}
		} else if (type == 2) {// paypail
			$("#pay_bj").hide();
			var param = $.csControl.getFormData("form");
			param = $.csControl.appendKeyValue(param, "type", "2");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
			$("#alipay_submit").html(data);
		} else {
			$("#pay_bj").hide();
		}
	},
	checkOrdenStatus : function(id) {
		if (id != "") {
			var orden = $.csOrdenCommon.getOrdenByID(id);
			if (orden.statusID != 10035) {// 非保存状态，不能提交订单
				$.csCore.alert($.csCore.getValue("Bl_Error_18"));
				if ($.cookie("ordenSearchUrl") != null) {
					window.location.href = '/hongling/orden/dordenPage.do?' + $.cookie("ordenSearchUrl");
				} else {
					window.location = this.getPath() + '/orden/ordenListPage_transitAction.do';
				}
			}
		}
	},
	init : function(id, isPost) {
		$("#containter_out").css({
			"width" : "1000px",
			"margin" : "auto",
			"clear" : "both"
		});
		$("#form").resetForm();
		$.csOrdenPost.bindEvent();
		$.csOrdenPost.autoCompleteFabric();
		if ($.csValidator.isNull(id)) {
			// 把服装分类放到session里 默认二件套
			$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", 1));
			$.csOrdenPost.generateClothing('', '');
		} else {
			var orden = $.csOrdenCommon.getOrdenByID(id);
			// 把服装分类放到session里
			$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", orden.clothingID));
			if (orden.statusID != 10035 && !isPost) {// 非保存状态，不能提交订单
				$.csCore.alert($.csCore.getValue("Bl_Error_18"));
				if ($.cookie("ordenSearchUrl") != null) {
					window.location.href = '/hongling/orden/dordenPage.do?' + $.cookie("ordenSearchUrl");
				} else {
					window.location = this.getPath() + '/orden/ordenListPage_transitAction.do';
				}
			}
			$.csOrdenPost.generateClothing(orden.clothingID, orden);
			$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", orden.clothingID));
			if ($.csValidator.isNull(orden.customer)) {
				$(".lblCustomer").hide();
			} else {
				$(".lblCustomer").show();
			}
			$.updateWithJSON(orden);
			if (orden.clothingID == 3000 && !$.csValidator.isNull(orden.components)) {
				var components = orden.components.split(",");
				$.each(components, function(i, component) {
					if (component == 3029) {
						$.csOrdenPost.setTempComponentid("3029");
					} else if (component == 3028) {
						$.csOrdenPost.setTempComponentid("3028");
					}
				});
			}
			if (isPost) {
				$('#ordenID').val('');
			}
			$.csOrdenPost.loadOrdenEmbroid(orden);// 订单刺绣信息 赋值

			if (!$.csValidator.isNull(orden.sizeBodyTypeValues)) {
				// 选中订单保存的特体信息
				var bodyTypes = orden.sizeBodyTypeValues.split(",");
				$.each(bodyTypes, function(i, bodyType) {
					$.csControl.initSingleCheck(bodyType);
				});
			}
			$.csOrdenPost.loadOrdenProcess(orden);
			// 款式
			if (!$.csValidator.isNull(orden.styleID) && orden.sizeCategoryID == DICT_SIZE_CATEGORY_NAKED && (orden.clothingID == DICT_CLOTHING_SUIT2PCS || orden.clothingID == DICT_CLOTHING_ShangYi || orden.clothingID == DICT_CLOTHING_SUIT3PCS || orden.clothingID == DICT_CLOTHING_DaYi)) {
				$.csControl.initSingleCheck(orden.styleID);
			}

			// 加单裤或数量判断
			if (orden.morePants == 10050) {
				$("#morePants").attr("checked", true);
				$("#shirtAmount").attr('disabled', true);
				$("#shirtAmount").val(1);
			} else {
				$("#morePants").attr("checked", false);
				$("#shirtAmount").attr('disabled', false);
				$("#shirtAmount").val(orden.morePants);
			}

			$("#isAlipay").val(orden.ordenID);
			$("#isPay").val(orden.isAlipay);
		}
	},
	clearNoNum : function(obj) {
		obj.value = obj.value.replace(/[^\d.]/g, "");
		obj.value = obj.value.replace(/^\./g, "");
		obj.value = obj.value.replace(/\.{2,}/g, ".");
		obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
	}
};
$(document).ready(function() {
	var ordenID = $('#ordenID2').val();
	var copyFlag = $('#copyFlag').val();
	if (ordenID != null && ordenID != "") {
		if (copyFlag == '1') {
			// 新增&复制
			$.csOrdenPost.init(ordenID, true);
		} else {
			// 编辑
			$.csOrdenPost.init(ordenID, false);
		}
	} else {
		$.csOrdenPost.init(ordenID, true);
	}

	$.csCustomer.autoCompleteCustomerName();
	// 清空初始化标识
	$('#isInit').val("");
});