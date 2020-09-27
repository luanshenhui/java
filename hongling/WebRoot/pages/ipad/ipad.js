jQuery.csIpad = {
	init: function() {
		$.csIpad.generateClothing();
		var clothingID = $.csControl.getRadioValue('clothingID');
		$.csCore.loadPage("container_customer", "../customer/customer.jsp",
		function() {
			$.csCustomer.init();
		});
//		$.csIpad.loadSize(clothingID, null);
		
		$.csIpad.fillStyle(null);
		$.csIpad.generateBodyType(null,null);
		$.csIpad.bindEvent();
		$.csIpad.autoCompleteFabric();
		$.csCore.loadJS('../../size/sizejsp.js',function(){
			$.csSize.init('', true);
		});
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
			
			//衬衣可追加数量
			if(clothingID == 3000){
				$("#more_shirt").show();
			}else{
				$("#more_shirt").hide();
			}

			// 长短款Style
			if (clothingID == DICT_CLOTHING_SUIT2PCS || clothingID == DICT_CLOTHING_SUIT3PCS || clothingID == DICT_CLOTHING_ShangYi || clothingID == DICT_CLOTHING_DaYi) {
				$("#style_title").show();
				$("#style_title input:radio:first").attr('checked', 'checked');
			} else {
				$("#style_title").hide();
			}
		}
		touchScroll("container_components");
	},bindEvent: function() {
		$("#btnSaveOrden").click($.csIpad.save);
		$("#btnSubmitOrden").click($.csIpad.submitOrden);
		$("#fabricCode").blur($.csIpad.fillOrdenAuto);
	},
	generateClothing: function(clothingID) {
		var clothing = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		var dom = "";
		for (var i = 0; i < clothing.length; i++) {
			dom += "<label><input type='radio' name='clothingID' value='" + clothing[i].ID + "' onclick='$.csIpad.clothingChange(" + clothing[i].ID + ");'/> " + clothing[i].name + "</label>&nbsp;&nbsp;&nbsp;&nbsp;";
			if (i==1) {
				dom+="<br><br>";
			}
		}
		dom += "";
		$("#container_clothings").html(dom);
		if ($.csValidator.isNull(clothingID)) {
			clothingID = clothing[0].ID;
		}
		$("input[value='" + clothingID + "']").attr("checked", "checked");
		$.csIpad.generateEmbroid(clothingID);
		$.csIpad.generateComponent(clothingID,null);
		$.csIpad.generateClothingCategory(null);
	},generateEmbroid: function(clothingID) {
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		$("#container_embroid").html("");
		for (var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search1'></div><div class='list_search'>" + dt.name +"</div>" + "<table id='category_embroid_" + arr[i] + "' class='list_result'>" + $.csIpad.getEmbroidRowHTML(arr[i],0) + "</table>";
			$("#container_embroid").append(dom);
			$.csIpad.fillEmbroidComposition(arr[i],0);
		}
		$("div.list_search").css({'line-height':'14px'});
		$("div.list_search1").css({'width':'14px','height':'3px'});
	}
	,
	generateClothingCategory: function(clothingID) {
		$("#container_size2").empty();
		$("#container_size2").append("<div>&nbsp;</div>");
		var id=0;
		if($.csValidator.isNull(clothingID)){
			id=1;
		}
		else
		{
			id=clothingID;
		}
		//alert(clothingID);
		var singleClothings = this.getSingleClothingsByargs(id);
		var dom = "";
		var dom2="";
			$.each(singleClothings,
			function(i, singleClothing) {
				$("#container_size2").append("<div>" + singleClothing.name + "</div>");
				$("#container_size2").append("<div id='part_" + singleClothing.ID + "'></div>");
				dom2=$.csIpad.generateParts(singleClothing.ID);
				$("div #part_"+singleClothing.ID).html(dom2);
			});
			$("#container_size2 div table tr td")
			.css({" margin-left":"0px",
					" margin-right":"0px",
					"line-height":"12px",
					"font-size":"14px"
				});
			$("#container_size2 div table tr td input")
			.css({"width":"80px","height":"16px"

				});
		if(singleClothings.length==3){
			var nbsp="";
			for(var i=0;i<20;i++){
				nbsp+="&nbsp;";
			}
			$("div #part_"+"4000").html(nbsp+"【马甲无需尺寸】");
			$("div #part_"+"4000").css({"color":"red","font-size":"16px;"});
		}
		
	}
	,
	getSingleClothingsByargs:function(clothingID){
		var param = $.csControl.appendKeyValue('', 'categoryid', clothingID);
		var singleClothings = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getsingleclothingsbyargs'),param);
		return singleClothings;
	}
	,
	generateParts: function(singleClothingID) {
		$("#part_"+singleClothingID).css("padding-left","0px");
			/*var sizeUnitID = $.csControl.getRadioValue("sizeUnitID");*/
			var param = $.csControl.appendKeyValue("", "unitid", 10266);
			param = $.csControl.appendKeyValue(param, "sizecategoryid", 10052);
			param = $.csControl.appendKeyValue(param, "areaid", $.csControl.getRadioValue("area"));
			param = $.csControl.appendKeyValue(param, "specheight", $.csControl.getRadioValue("size_spec_height_" + singleClothingID));
			param = $.csControl.appendKeyValue(param, "specchest", $.csControl.getRadioValue("size_spec_chest_" + singleClothingID));
			param = $.csControl.appendKeyValue(param, "singleclothingid", singleClothingID);
			var parts = $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingparts'), param);
			var dom = "<table><tr>";
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
				
				dom += "<td class='part_label' width='30'>" + parts[i].partName + "&nbsp;&nbsp;</td><td onclick=''  title='" + parts[i].sizeFrom + " - " + parts[i].sizeTo + "'>";
				dom += "<input type='text' " + readonly + " onfocus='$.csIpad.showPartMessage(this);' ";
				if ($.browser.mozilla) {
					dom += " onkeypress= 'if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return   false;} '";
				} else {
					dom += " onkeypress= 'if((event.keyCode <48||event.keyCode> 57) && event.keyCode!=46 && event.keyCode!=8){return   false;} '";
				}
				var tun = "";
				if(singleClothingID==2000 && this.buildPartID(parts[i].partID) == "part_label_10108"){
					tun = singleClothingID;
				}
				var valueSize =$("#"+this.buildPartID(parts[i].partID)).val();
				if(undefined != valueSize && "" != valueSize && "" == defaultValue){
					defaultValue = valueSize;
				}
				var id = this.buildPartID(parts[i].partID);
//				var obj = $("#"+id);
				dom += " onkeyup=$.csIpad.onlyNumber(this)  onblur=$.csIpad.validatePartRange('" + this.buildPartID(parts[i].partID) + "','" + parts[i].ID + "','" + parts[i].sizeFrom + "','" + parts[i].sizeTo + "',this) value='" + defaultValue + "' id='" + this.buildPartID(parts[i].partID) + "' name='" +tun+ this.buildPartID(parts[i].partID) + "'/><span></span></td><td class='" + star + "' width='16'>&nbsp;</td>";
				if((i+1)%4==0){
					dom+="<tr></tr>";
				}
			}
			dom += "</tr></table>";
			return dom;
		
	}
	,
	validatePartRange: function(partID, sizeStandardID, fromValue, toValue,element) {
		//$(event.target).next().html('');
		//$(event.target).css({'background':'#ffffff'});
		//$('#'+partID).parent().find('span').first().html('');
		//$("#"+$(element).attr('id')).next().html('');
		//alert($(obj).attr('name'));
		//alert();
		$('input[name~="'+$(element).attr('name')+'"]').next().html('');
		$('#'+partID).css({'background':'#ffffff'});
		
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
							//$(".lbd").css({"color":"red"});
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
								$(".lbd").html($("#" + $.csSize.buildPartID(current.partID)).parent().prev().html() + " : " + min + " - " + max);
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
		}
		$.csSize.onlyNumber(obj);
	}
	,
	getPartLabel: function(partID) {
		return $("#" + partID).parent().prev().html();
	}
	,
	getClothingPartsByGroup: function(sizeStandardID) {
		var param = $.csControl.appendKeyValue("", "unitid", 10266);
		param = $.csControl.appendKeyValue(param, "sizestandardid", sizeStandardID);
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingpartsbygroup'), param);
	}
	,
	getSizeRangeBySign: function(sign) {
		var param = $.csControl.appendKeyValue("", "sign", sign);
		param = $.csControl.appendKeyValue(param, "unitid", 10266);
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizerangebysign'), param);
	}
	,
	getSizeStandardByID: function(id) {
		var param = $.csControl.appendKeyValue("", "id", id);
		param = $.csControl.appendKeyValue(param, "unitid", 10266);
		return $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizestandardbyid'), param);
	}
	,
	getSizeRangeByStandardAndSign: function(sizeStandardID, sign) {
		var param = $.csControl.appendKeyValue("", "sign", sign);
		param = $.csControl.appendKeyValue(param, "sizestandardid", sizeStandardID);
		param = $.csControl.appendKeyValue(param, "unitid", 10266);
		var datas=$.csCore.invoke($.csCore.buildServicePath('/service/size/getsizerangebysizestandardandsign'), param);
		//alert(datas.length);
		//alert(datas[0].sizeStandardIDs);
		return datas;
	}
	,
	onlyNumber:function onlyNumber(obj){
	    //得到第一个字符是否为负号
	    var t = obj.value.charAt(0);  
	    //先把非数字的都替换掉，除了数字和. 
	    obj.value = obj.value.replace(/[^\d\.]/g,'');   
	     //必须保证第一个为数字而不是.   
	     obj.value = obj.value.replace(/^\./g,'');   
	     //保证只有出现一个.而没有多个.   
	     obj.value = obj.value.replace(/\.{2,}/g,'.');   
	     //保证.只出现一次，而不能出现两次以上   
	     obj.value = obj.value.replace('.','$#$').replace(/\./g,'').replace('$#$','.');
	}
	,
	showPartMessage: function(element) {
		//alert('in');
		//alert($("#"+$(element).attr('id')).next().html());
		//alert($(element).attr('name'));
		
		$(element).css({'background':'#eeeeee','border-color':'#cccccc','border-style':'solid','border-width':'1px'});
		var title = $(element).parent().attr("title");
		if (title != "null - null") {
			$('input[name~="'+$(element).attr('name')+'"]').next().html(title).css({'color':'red','font-size':'18px;'});
		}
	}
	,
	buildPartID: function(partID) {
		return "part_label_" + partID;
	}
	,
	getSingleClothings: function() {
		var singleClothings = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getsingleclothings'));
		return singleClothings;
	}
	,fillEmbroidComposition: function(clothingID,index) {
		var param = $.csControl.appendKeyValue('', 'categoryid', clothingID);
		var dictsSeries = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getembroids'), param);
		//CXID 编辑页面，刺绣信息 ecode为空，不显示
		for (var j = 0; j < dictsSeries.length; j++) {
			if (j == 0) {
				$("#category_label_" + clothingID + "_Color_"+index).prev().html(dictsSeries[j].name + ":");
				var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_" + clothingID + "_Color_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
			}
			if (j == 1) {
				$("#category_label_" + clothingID + "_Font_"+index).prev().html(dictsSeries[j].name + ":");
				var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_" + clothingID + "_Font_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
			}
			if (j == 2) {
				$("#category_textbox_" + clothingID + "_Content_"+index).prev().html(dictsSeries[j].name + ":");
				$("#category_textbox_" + clothingID + "_Content_"+index).attr("id", "category_textbox_" + dictsSeries[j].ID);
			}
			if (clothingID == DICT_CLOTHING_ChenYi) {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Size_"+index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Size_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
				if (j == 4) {
					$("#category_label_" + clothingID + "_Position_"+index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Position_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
			} else {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Position_"+index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Position_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
			}
		}
	},getEmbroidRowHTML: function(clothingID,index) {
		var size = "";
		var disabled ="";
		if(index>0){
			disabled ="disabled='disabled'";
		}
		if (clothingID == 3000) {
			size = "<td ><span style='color:#ffffff;'><span/><select id='category_label_" + clothingID + "_Size_"+index+"' style='width: 120px' "+disabled+" onclick=$.csIpad.setEmbroidValue('"+clothingID+"','Size')/></td>";
		}
		var embroid = "<tr align='center' index='" + index + "'>" + "<td><span style='color:#ffffff;'><span/><select id='category_label_" + clothingID + "_Position_"+index+"' style='width: 120px' /></td>" + "<td><span style='color:#ffffff;'><span/><select id='category_label_" + clothingID + "_Color_"+index+"' style='width: 120px'  "+disabled+"  onclick=$.csIpad.setEmbroidValue('"+clothingID+"','Color')/></td>" + "<td><span style='color:#ffffff;'><span/><select id='category_label_" + clothingID + "_Font_"+index+"' style='width: 120px'  "+disabled+"  onclick=$.csIpad.setEmbroidValue('"+clothingID+"','Font')/></td>" + "<td><span style='color:#ffffff;'><span/><input type='text' id='category_textbox_" + clothingID + "_Content_"+index+"' style='width:120px;background-color: #131313; border: 1px solid #626061; color: #EAE9E9;height: 20px;line-height: 20px;' class='category_textbox_" + clothingID + "_Content_"+index+"'/></td>" + size +"<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>";
		return embroid;
	},addEmbroidRow: function(clothingID) {
		var lastIndex = $("#category_embroid_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}else{
			lastIndex = parseInt(lastIndex)+1;
		}
		$("#category_embroid_" + clothingID).append($.csIpad.getEmbroidRowHTML(clothingID, lastIndex));
		$.csIpad.fillEmbroidComposition(clothingID, lastIndex);
		$.csIpad.copyEmbroidComposition(clothingID, lastIndex);
		$("#clothing"+clothingID).val(lastIndex);
	},loadSize: function(clothingID) {
		$.cookie("size_category","");
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", clothingID));
		$.csCore.loadPage("container_size", "../size/post.htm",
		function() {
			$.csSizePost.init();
		});
	},clothingChange: function(clothingID) {//切换服装大类
		var ordenID=$("#isAlipay").val();
		if ($.csValidator.isNull(ordenID)) {
			$.csIpad.loadSize(clothingID, null);
			$.csIpad.generateComponent(clothingID);
			$.csIpad.generateEmbroid(clothingID,'');
			$.csIpad.generateBodyType(clothingID,null);//特体信息
			if(clothingID == 3000){
				$("#category_3000").html("<tr index='1'><td><input type='text'  disabled='disabled' id='component_3000_3028'  value='5000' style='width:130px' class='textbox'/> <span style='color: rgb(153, 153, 153);'>长袖</span></td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			}
			$('.lbl').html('');
			$.csIpad.generateClothingCategory(clothingID);
		}else{
			var orden = $.csOrdenCommon.getOrdenByID(ordenID);
			$.csIpad.loadSize(clothingID, orden);//尺寸信息(orden切换大类保存尺寸)
			$.csIpad.generateComponent(clothingID, orden);//工艺信息(orden切换大类保存工艺)
			$.csIpad.generateEmbroid(clothingID,orden);
			$.csIpad.loadOrdenEmbroid(orden);//订单刺绣信息  赋值
			if(orden.clothingID != 3000 && clothingID == 3000){
				$("#category_3000").html("<tr index='1'><td><input type='text'  disabled='disabled' id='component_3000_3028'  value='5000' style='width:130px' class='textbox'/> <span style='color: rgb(153, 153, 153);'>长袖</span></td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			}
		}
//		var clothingID = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempclothingid'));
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
			
			//衬衣可追加数量
			if(clothingID == 3000){
				$("#more_shirt").show();
			}else{
				$("#more_shirt").hide();
			}

			// Style
			/*if (clothingID == DICT_CLOTHING_SUIT2PCS || clothingID == DICT_CLOTHING_SUIT3PCS || clothingID == DICT_CLOTHING_ShangYi || clothingID == DICT_CLOTHING_DaYi) {
				$("#style_title").show();
				$("#style_title input:radio:first").attr('checked', 'checked');
			} else {
				$("#style_title").hide();
			}*/
			var inputRadio ="";
			if (clothingID == DICT_CLOTHING_SUIT2PCS || clothingID == DICT_CLOTHING_SUIT3PCS || clothingID == DICT_CLOTHING_ShangYi) {
//				$("#style_title").show();
//				$("#style_title input:radio:first").attr('checked', 'checked');
				$.each($.csCore.getDicts(DICT_CATEGORY_STYLE), function (i, data) {
		        	if(i == 0){
		                checked = " checked='true' ";
		        	}else {
		                checked = "";
		            };
	            	inputRadio += "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='styleID' value='" + eval("data.ID") + "'>" + eval("data.name") + "</label> ";
		        });
				$("#style_title").html(inputRadio);
			}else if(clothingID == DICT_CLOTHING_DaYi){
				$.each($.csCore.getDicts(DICT_CATEGORY_STYLE), function (i, data) {
					if(i == 0){
		                checked = " checked='true' ";
		        	}else {
		                checked = "";
		            };
		            if(eval("data.ID") != 20102){
		            	inputRadio += "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='styleID' value='" + eval("data.ID") + "'>" + eval("data.name")+ "</label> ";
		            }
				});
				inputRadio += "<label style='display:inline;clear:none;'><input type='radio' name='styleDY' value='0A01'/>"+$.csCore.getValue("DY_0A01")+"</label><label style='display:inline;clear:none;'><input type='radio' name='styleDY' value='0A02' checked='true'/>"+$.csCore.getValue("DY_0A02")+ "</label> ";
	            $("#style_title").html(inputRadio);
			} else {
				$("#style_title").html("");
			}
		}
	},generateComponent: function(clothingID) {
		$("#container_components").html("");
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		for (var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name + "<a onclick='$.csIpad.addComponentRow(" + arr[i] + ")'>" + $("#addText").val()+ "</a></div>" + "<table id='category_" + arr[i] + "' class='list_result'></table><br>";
			$("#container_components").append(dom);
			$.csIpad.addComponentRow(arr[i]);
		}
	},getComponentRowHTML: function(clothingID, index) {
		return "<tr index='" + index + "'>" + "<td><input type='text' id='text_" + clothingID + "_" + index + "' style='width:130px' class='textbox'/><span/></td>" + "<td onclick=$(this).parent().remove();$.csIpad.removeStyle('','"+clothingID+"','"+ index++ +"',$(this)) style='width:30px'><a class='remove'></a></td>" + "</tr>";
	},addComponentRow: function(clothingID) {
		var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}
		$("#category_" + clothingID).append($.csIpad.getComponentRowHTML(clothingID, parseInt(lastIndex) + 1));
		$.csIpad.inputProces(clothingID, parseInt(lastIndex) + 1);
	},
	inputProces : function(clothingID, index){
		var num=0;
		$("#text_" + clothingID + "_" + index).keyup(function(){
			if($("#text_" + clothingID + "_" + index).val().length >3 ){
				var xiLie ="";//配件工艺要符合所属系列
				$("input[id^='component_5000_']").each(function(i) {
					if(i == 0){
						xiLie = $(this).attr("id").substr($(this).attr("id").lastIndexOf("_") + 1);
					}
				});
				var url = $.csCore.buildServicePath('/service/orden/getcomponentbykeyword?id=' + clothingID+'&q='+$("#text_" + clothingID + "_" + index).val()+'&xiLie='+xiLie);
		    	var data = $.csCore.invoke(url);
		    	if(data != null && data.length == 1){
		    		num++;
		    		$.csIpad.checkEcode(data[0],clothingID,$(this), index);
					
					$("#"+ $(this).attr("id")).blur();
		    	}
			}
        });
		if(num==0){
			$.csIpad.autoCompleteDict(clothingID, index);
		}
	},inputProcesLowerLevel : function(dictID, url, clothingID){
		var num=0;
		$("#component_textbox_" + dictID).keyup(function(){
			if($("#component_textbox_" + dictID).val().length >3){
				var url = $.csCore.buildServicePath('/service/dict/getdictbykeyword?parentID=' + dictID +'&q='+$("#component_textbox_" + dictID).val().toLocaleLowerCase());
		    	var data = $.csCore.invoke(url);
		    	if(data != null && data.length == 1){
		    		num++;
		    		$("#component_textbox_" + dictID).attr("id", "component_" + data[0].ID);
		    		$("#component_" + data[0].ID).blur();
		    		$("#component_" + data[0].ID).val(data[0].ecode);
		    	}
			}
        });
		if(num==0){
			$.csIpad.autoCompleteLowerLevelDict(dictID, url, clothingID);
		}
	},
	autoCompleteDict: function(clothingID, index) {
		var xiLie ="";//配件工艺要符合所属系列
		$("input[id^='component_5000_']").each(function(i) {
			if(i == 0){
				xiLie = $(this).attr("id").substr($(this).attr("id").lastIndexOf("_") + 1);
			}
		});
		var url = $.csCore.buildServicePath('/service/orden/getcomponentbykeyword?id=' + clothingID+'&xiLie='+xiLie);
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
				//上衣、西裤、衬衣  扣、里料、线  - 只显示客户指定工艺
				if(DICT_ZDGY.indexOf(item.ecode) >=0){
					if(item.notShowOnFront==DICT_YES){
						return item.ecode + "(" + item.name + ")";
					}else{
						return "";
					}
				}else{
					return item.ecode + "(" + item.allName + ")";
				}
//				return item.ecode + "(" + item.name + ")";
			}
		}).result(function(e, data) {
    		$.csIpad.checkEcode(data,clothingID,$(this), index);
			});
	},
	checkEcode : function(data,clothingID,obj, index){
		var error = 0;
		$("input[id^='doNot_']").each(function() {
			if ($(this).attr("id") ==  "doNot_"+data.ID) {//客户指定工艺
				$.csCore.alert($.csCore.getValue("Orden_Precess_Error"));
				error = 1;
			}
		} //是否选择同一种工艺 
		);
		$("input[id^='component_']").each(function() {
			if ($(this).attr("id") == "component_" + clothingID + "_" + data.ID) {
				$.csCore.alert($.csCore.getValue("Orden_Precess_Error"));
				error = 1;
			}
		} //是否选择同一种工艺 
		);

		var ids = "";
		if (error == 0) {
			//配件必须先录系列
			if(clothingID==5000 && index==1 && data.parentID != 5023){
				$.csCore.alert($.csCore.getValue("Orden_CheckXiLei"));
				error = 1;
			}
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
			obj.next().html("");
			obj.val("");
		} else {
			/*var parentDict = $.csCore.getDictByID(data.parentID);
			var parentparentDict = $.csCore.getDictByID(parentDict.parentID);
			var lowerLevelData = $.csCore.getDictsByParent(data.categoryID, data.ID);
			if (parentDict.ecode != null) {
				obj.next().html(parentparentDict.name + parentDict.name + ":" + data.name);
			}else if (parentDict!=null) {
				obj.next().html(parentDict.name + ":" + data.name);
			}else {
				obj.next().html(data.name);
			}*/
			obj.next().html(data.allName);
			if(data.isDefault==10050){
				obj.next().css({ color: "#999999"});
			}else{
				obj.next().css({ color: "#FFFFFF"});
			}
			obj.attr("readonly", "true");
			obj.attr("id", "component_" + clothingID + "_" + data.ID);
			if(data.ID == '3029'){
				$.csOrdenPost.setTempComponentid("3029");
			}else if(data.ID == '3028'){
				$.csOrdenPost.setTempComponentid("3028");
			}
			var parentDict = $.csCore.getDictByID(data.parentID);
			var lowerLevelData = $.csCore.getDictsByParent(data.categoryID, data.ID);
			if (lowerLevelData.length > 0 && parentDict.statusID == null) {
				obj.next().append("<input type='text' id='component_textbox_" + data.ID + "' style='width:150px' class='textbox'/>");
				var url = $.csCore.buildServicePath('/service/dict/getdictbykeyword?parentID=' + data.ID);
				$.csOrdenPost.inputProcesLowerLevel(data.ID, url, clothingID);
				obj.attr("id", "doNot_" + data.ID);
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
					obj.next().append("<input type='text' id='category_textbox_" + data.ID + "' style='width:150px' class='textbox' " + doms + "/>");
				}
			}
		}
	},
	validate: function() {
		if ($.csCore.contain(DICT_FABRIC_SUPPLY_CATEGORY_CLIENT, $('#fabricCode').val())) {
			$('#fabricCode').val('');
		}
		if ($.csValidator.checkNull("fabricCode", $.csCore.getValue("Common_Required", "Fabric_Moduler"))) {
			return false;
		}
		
		var clothing = $("input[name='clothingID']:checked").val();
		if(clothing ==1){
			var result_XF = $.csIpad.checkEmbroidNull('3');
			var result_XK = $.csIpad.checkEmbroidNull('2000');
			if(result_XF == false || result_XK == false){
				return false;
			}
		}else if(clothing ==2){
			var result_XF = $.csIpad.checkEmbroidNull('3');
			var result_XK = $.csIpad.checkEmbroidNull('2000');
			var result_MJ = $.csIpad.checkEmbroidNull('4000');
			if(result_XF == false || result_XK == false || result_MJ == false){
				return false;
			}
		}else{
			return $.csIpad.checkEmbroidNull(clothing);
		}
		
		return true;
	},
	checkEmbroidNull : function(clothing){
		var index = $("#clothing"+clothing).val();
		var num =0;
		for(var i=0;i<=index;i++){
			if($("#category_label_"+clothing+"_Position_"+i).val() == '-1' 
				|| $("#category_label_"+clothing+"_Position_"+i).val() == undefined){
				num++;
			}
			if($.trim($(".category_textbox_"+clothing+"_Content_"+i).val()) == '' ){
				num++;
			}
			if(num == 1){
				$.csCore.alert($.csCore.getValue("Embroidery_Error"));
				return false;
			}
		}
	},
	save: function() {
		if (!$(".lblCustomer").is(":hidden")) {
			if ($.csCustomer.validate() == false) {
				return false;
			}
		}
		if ($.csIpad.validate() == false) {
			return false;
		}
		if ($.csSize.validatePost() == false) {
			return false;
		}
		
		var data = $.csCore.invoke($.csCore.buildServicePath("/service/orden/submitorden?type=1"), $.csControl.getFormData("form"));
		$.csIpad.saveOrSubmit(data,$.csCore.getValue("Common_Save"));

	},
	submitOrden : function() {
		if (!$(".lblCustomer").is(":hidden")) {
			if ($.csCustomer.validate() == false) {
				return false;
			}
		}
		if ($.csIpad.validate() == false) {
			return false;
		}
		if ($.csSize.validatePost() == false) {
			return false;
		}
		
		$("#shade").show();//显示遮罩层
		setTimeout(
				function(){
					var data = $.csCore.invoke(
	        		$.csCore.buildServicePath("/service/orden/submitorden"), $.csControl.getFormData("form"));
			        $.csIpad.saveOrSubmit(data,$.csCore.getValue("Button_Submit"));
			    },0.1);//延迟0.1毫秒提交(显示遮罩层)
	},
	saveOrSubmit : function(data,type){
        $("#shade").hide();//隐藏遮罩层
		if (!$.csValidator.isNull(data)) {
            if (data.toUpperCase() == "OK") {
                $("form").each( function(){
                	this.reset();
                });
                $.csCore.alert(type+$.csCore.getValue("Bl_Error_1"));
                $.csIpad.init();
            }else {
            	
            	if(data == $.csCore.getValue("Bl_Error_189") || data == $.csCore.getValue("Bl_Error_190")){
	            	$.csCore.alert(data);
        		}else{
        			$("form").each( function(){
                     	this.reset();
                     });
        			$.csCore.alert(data);
                	$.csIpad.init();
        		}
            }
        }
	},
	fillOrdenAuto: function() {
		$('#fabric_result').html('');
		$('#autoContainer').html('');
		if (!$.csValidator.isNull($('#fabricCode').val())) {
			var inventory = $.csIpad.getFabricInventory($('#fabricCode').val());
//			$('#fabric_result').html(inventory);
			if ($.csValidator.isNull(inventory) || inventory <= 0) {
				$('#autoContainer').html("<label style='color:red;'>"+$.csCore.getValue("Orden_FabricArrivedControl") + "</label><br />");
				$.csControl.fillRadios("autoContainer", $.csCore.getDicts(DICT_CATEGORY_ORDEN_AUTO), "autoID", "ID", "name");
			}
		}
	},getFabricInventory: function(code) {
		return $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabricinventory'), $.csControl.appendKeyValue("", "code", code));
	},autoCompleteFabric: function() {
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
			var inventory = $.csIpad.getFabricInventory(data.code);
			var hint = $.csCore.getValue('Fabric_Inventory') + ":" + inventory;
			$('#fabric_result').html(hint);
		});
	},
	generateBodyType: function(clothingID,orden) {
//		var singleClothings = this.getSingleClothings();
		var id=0;
		if($.csValidator.isNull(clothingID)){
			id=1;
		}
		else
		{
			id=clothingID;
		}
		var singleClothings = this.getSingleClothingsByargs(id);
		
		$.each(singleClothings,
		function(i, singleClothing) {
			if (i == 0) {
				clothing = singleClothing.ID;
			}
		});
		
		// 单选钮的项name的命名 option_bodytype_10111,option_bodytype_10112
		var bodyType = $.csCore.invoke($.csCore.buildServicePath('/service/size/getclothingbodytype'), $.csControl.appendKeyValue("", "sizecategoryid", 10052));
		
		var domRadio = "";
		if (!$.csValidator.isNull(bodyType)) {
			var count  ;
			// 特体信息
			for (var i = 0; i < bodyType.length; i++) {
				if (bodyType[i].categoryID != DICT_CATEGORY_BODYTYPE) {
					var bodyTypes = bodyType[i].bodyTypes;
					if (bodyTypes != "") {
						if (i == bodyType.length - 1) {
							domRadio += "<table  class='hline'><tr id='clothing_style'>";
						} else {
							domRadio += "<table  class='hline'><tr>";
						}
						domRadio += "<td colspan='8'>" + bodyType[i].categoryName + "</td>";
						domRadio += "</tr><tr>";
						count = 1;
						for (var j = 0; j < bodyTypes.length; j++) {
							if(count>8&& count%8==0){
								domRadio += "</tr><tr  class='hline'>";
							}
							domRadio += "<td width='12.5%'><label style='line-height:5px;'><input type='checkbox' ";
							if (!orden || !orden.ordenID) {
								if (bodyTypes[j].ID == DICT_BODY_TYPE || bodyTypes[j].ID == DICT_CLONTHING_SIZE) {
									domRadio += "checked='true' ";
								} else if (j == 0 && i < bodyType.length - 1) {
									domRadio += "checked='true' ";
								}
							}
							domRadio += "  name='body_type_" + bodyType[i].categoryID + "' value='" + bodyTypes[j].ID + "' onclick='$.csControl.checkOnce(this);' onfocus='$.csSize.playShow(-1," + 10052 + "," + bodyTypes[j].ID + ");'/> " + bodyTypes[j].name+ "</label></td>";
							count++;
						}
						if((count-1)%8!=0){
							for(var x =0;x<8-count;x++){
								domRadio += "<td width='12.5%'>"+"&nbsp;"+"</td>";
							}
						}
						domRadio += "</tr></table>";
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
								domRadio += "<table  class='hline'><tr id='clothing_style'>";
							} else {
								domRadio += "<table  class='hline'><tr>";
							}
							domRadio += "<td colspan='8' style='font-color:#FFF055'>" + bodyType[i].categoryName + "&nbsp;" + singleClothing.name + "</td>";
							domRadio += "</tr><tr>";
//							alert("bodyType[i].categoryName"+bodyType[i].categoryName+ "\n"+"singleClothing.name"+singleClothing.name)
							count = 1;
							//bodyTypes[j]修身，非常修身。。。
							for (var j = 0; j < bodyTypes.length; j++) {
								if (bodyType[i].categoryID == DICT_CATEGORY_BODYTYPE) {
									var strs = new Array();
//									alert(" bodyTypes["+j+"]是："+JSON.stringify(bodyTypes[j]));
									//3,3000,4000,6000...
									strs = bodyTypes[j].extension.split(",");
									if(count>7 && count%8==0){
										domRadio += "</tr><tr  class='hline'>";
										count = 1;
									}
									for (var n = 0; n < strs.length; n++) {
										if (strs[n] == singleClothing.ID) {
											domRadio += "<td width='12.5%'><label><input type='checkbox' ";
											if (!orden || !orden.ordenID) {
												if (bodyTypes[j].ID == DICT_BODY_TYPE) {
													domRadio += "checked='true' ";
												}
											}
											domRadio += "  name='body_type_" + bodyType[i].categoryID + "_" + singleClothing.ID + "' id='body_type_" + bodyType[i].categoryID + "_" + singleClothing.ID + "_" + bodyTypes[j].ID + "' value='" + bodyTypes[j].ID + "' onclick='$.csControl.checkOnce(this);' onfocus='$.csSize.playShow(-1," + $.csControl.getRadioValue("size_category") + "," + bodyTypes[j].ID + ");'/> " + bodyTypes[j].name + "</label></td>";
										}
									}
								}
								count++;
							}
								if((count-1)%8!=0){
									for(var x =0;x<8-count;x++){
										domRadio += "<td width='12.5%'>"+"&nbsp;"+"</td>";
									}
									count = 1;
								}
							domRadio += "</tr></table>";
						}
					}
				}
			});
		}
		$("#size_bodytype").html(domRadio);
//		$("#size_bodytype table tr").css("line-height","10px");
//		$("#size_bodytype table tr td").css({"font-size":12});
//		$("#size_bodytype table:first tr").css("line-height","50px");
//		$("#size_bodytype table:first tr").attr("height",50);
//		$("#size_bodytype table:first tr").attr("height","50px");
//		$("#size_bodytype table:first tr td input").height("5px");
//		$("#size_bodytype table:first tr").height("5px");
//		$("#size_bodytype table:first tr td").removeAttr("style");
//		$("#size_bodytype table:first").attr("height").attr("height",12);
		
	},generateSizeCategory: function(orden) {
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
		if ($.csValidator.isNull(initCategoryID)) {
			initCategoryID = sizeCategory[0].ID;
		}
		$("input[value='" + initCategoryID + "']").attr("checked", "checked");

		this.fillSizeUnit();
		this.generateClothingCategory();
		this.generateArea(orden);
//		this.generateBodyType(orden);
	},fillStyle: function(orden) {
		$(".style_title").html("");
		$("#styleContainer").html("");
//		if (10052 == DICT_SIZE_CATEGORY_NAKED) {
			$(".style_title").html($.csCore.getValue("Size_Style") + ":");
			if (orden != null && orden.styleID != null) {
				$.csControl.fillRadio("styleContainer", $.csCore.getDicts(DICT_CATEGORY_STYLE), "styleID", "ID", "name", orden.styleID);
			} else {
				$.csControl.fillRadios("styleContainer", $.csCore.getDicts(DICT_CATEGORY_STYLE), "styleID", "ID", "name");
			}
//		}
	}
};
$(document).ready(function() {
	$.csIpad.init();
});