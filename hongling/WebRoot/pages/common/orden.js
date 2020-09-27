jQuery.csOrden = {
	ITEMCHECK_CSS: "itemcheck",
	PRODUCT_VIEW: "PRODUCT_VIEW",
	bindLabel: function() {
		var member = $.csCore.getCurrentMember();
		if(member.username == 'CLX'){//联翔服装设计有限公司
			$.cookie("logo",0);
		}else{
			if($.cookie("realmname_logoname") != null){
				$("#logo").css("background","url(../../themes/default/images/realm/"+ $.cookie("realmname_logoname") +".gif) no-repeat center center");
			}else{
				if(member.businessUnit == 20137){//红领
					$("#logo").css("background","url(../../themes/default/images/hongling.gif) no-repeat center center");
					$("#logo").height(73);
				}else if(member.businessUnit == 20138 || member.businessUnit == 20144 || member.businessUnit == 20140){//凯妙、瑞璞
					$("#logo").css("background","url(../../themes/default/images/cameo.gif) no-repeat center center");
				}else{//RCMTM
					$("#logo").css("background","url(../../themes/default/images/login_logo.gif) no-repeat center center");
				}
				$.cookie("logo",member.businessUnit);
			}
		}
		$.csCore.getValue("Size_Info",null,"#Common_Size");
		$.csCore.getValue("Common_SubmitOrder",null,"#Common_SubmitOrder");
		if ($.csValidator.isNull($.cookie($.csOrden.PRODUCT_VIEW))) {
			$.cookie($.csOrden.PRODUCT_VIEW, DICT_VIEW_FRONT);
		}
		if ($.cookie($.csOrden.PRODUCT_VIEW) == DICT_VIEW_FRONT) {
			$.csCore.getValue("Button_BackView",null,"#fb_view");
		} else {
			$.csCore.getValue("Button_FrontView",null,"#fb_view");
		}
		$.csCore.getValue("Button_ClassicDesign",null,"#classes_logo_text");
		$.csCore.getValue("Button_Search",null,"#find_title");
	},
	bindEvent: function() {
		$("#entry").attr("href", "backend.htm");
		$("#Common_Size").click(function() {
			var member = $.csCore.getCurrentMember();
			if (member.isMTO == DICT_YES) {
				$.cookie("size_category", DICT_SIZE_CATEGORY_STANDARD);
				$.csCore.loadModal('../size/size_bzh.htm', 950, 440,
				function() {
					$.csSize_bzh.init();
				});
			} else {
				$.csCore.loadModal('../size/select.htm', 998, 440,
				function() {
					$.csSizeSelect.init();
				});
			}
		});
		$("#Common_SubmitOrder").click(function() {
			$.csCore.loadModal('../customer/post.htm', 980, 540,
			function() {
				$.csCustomerPost.init();
			});
		});
		$("#classes_logo_text").click(function() {
			$.csCore.loadModal('../orden/classic.htm', 970, 480,
			function() {
				$.csClassic.init();
			});
		});
		$("#button_down").click($.csOrden.getNextMenu);
		$("#button_up").click($.csOrden.getBackMenu);
		$("#fb_view").click($.csOrden.changeView);
		$("#alipay").click(function() {
			window.open('https://auth.alipay.com/');
		});
		$("#paypal").click(function() {
			if ($("#versions").val() > 1) {
				window.open('https://www.paypal.com/c2/webapps/mpp/home?locale.x=en_C2');
			} else {
				window.open('https://www.paypal.com/c2/webapps/mpp/home?locale.x=zh_C2');
			}
		});		
	},
	changeView: function() {
		if ($.cookie($.csOrden.PRODUCT_VIEW) == DICT_VIEW_FRONT) {
			$.cookie($.csOrden.PRODUCT_VIEW, DICT_VIEW_BACK);
			$.csCore.getValue("Button_FrontView",null,"#fb_view");
		} else {
			$.cookie($.csOrden.PRODUCT_VIEW, DICT_VIEW_FRONT);
			$.csCore.getValue("Button_BackView",null,"#fb_view");
		}
		$.csOrden.loadProduct($.cookie($.csOrden.PRODUCT_VIEW));
	},
	loadClothing: function() {
		 $.ajax({
             url: $.csCore.buildServicePath('/service/orden/getclothing'),
             data: '',
             type: "post",
             dataType: "json",
             success: function (datas, textStatus, jqXHR) {
            	 if (datas != null && datas.length > 0) {
         			var clothing = "";
         			for (var i = 0; i < datas.length; i++) {
         				clothing += "<a id=p" + datas[i].ID + " onclick='$.csOrden.loadAccordion(this," + datas[i].ID + ")'>" + datas[i].name + "</a>";
         			}
         			$('#orden_clothing').html(clothing);
         			
         			var clothingID = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempclothingid'));
         			if(clothingID == 3){
         				$.csOrden.loadAccordion($('#orden_clothing').find('a')[2], datas[2].ID);
         			}else if(clothingID == 2000){
         				$.csOrden.loadAccordion($('#orden_clothing').find('a')[3], datas[3].ID);
         			}else if(clothingID == 3000){
         				$.csOrden.loadAccordion($('#orden_clothing').find('a')[4], datas[4].ID);
         			}else{
         				$.csOrden.loadAccordion($('#orden_clothing').find('a')[0], datas[0].ID);
         			}
//         			$.csOrden.loadAccordion($('#orden_clothing').find('a')[0], datas[0].ID);
         		}
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });
	},
	loadAccordion: function(clickedClothing, parentID) {
		$("body").removeClass("orden_" + $.cookie('clothingid'));
		$("body").addClass("orden_" + parentID);
		$.cookie("isClassic", "false");
		//        $.cookie('clothingid', parentID, {
		//            path: "/"
		//        });
		//选择经典设计后$.cookie('clothingid')值总是不变，导致“下一步”不好用。
		$.cookie('clothingid', parentID);
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", parentID));

		var url = $.csCore.buildServicePath('/service/orden/getaccordion');
		var param = $.csControl.appendKeyValue("", "parentid", parentID);
		 $.ajax({
             url: url,
             data: { formData: param },
             type: "post",
             dataType: "json",
             success: function (datas, textStatus, jqXHR) {
            	 index = 0;
         		if (!$.csValidator.isNull(datas)) {
         			var domLi = "";
         			for (var i = 0; i < datas.length; i++) {
         				domLi += "<div><div id=p" + datas[i].ID + " class='accordion' onclick='$.csOrden.loadRootMenu(this," + datas[i].ID + ")'>" + datas[i].name + "</div></div>";
         			}
         			$('#orden_clothing_category').html(domLi);
         			for (var i = 0; i < datas.length; i++) {
         				$("#p" + datas[i].ID).css("background-image", "url(../../scripts/jquery/menu/images/" + datas[i].ID + ".png)");
         			}
         			jQuery.csOrden.loadComponent($('#p' + datas[0].ID), datas[0].ID, 1);
         			$.csCore.getValue("Size_Info",null,"#Common_Size");
         			$.csCore.getValue("Common_SubmitOrder",null,"#Common_SubmitOrder");
         			$("#Common_Size").css("background-image", "url(../../scripts/jquery/menu/images/common_size.png)");
         			$("#Common_SubmitOrder").css("background-image", "url(../../scripts/jquery/menu/images/common_submitorder.png)");
         		}
                 
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });

		$(clickedClothing).siblings().css("color", "").css("background-color", "");
		$(clickedClothing).css("color", "#FFF").css("background-color", "#282828");

		this.loadProduct(DICT_VIEW_FRONT);
		// 显示搜索
		var dom = "<input class='find_text' id='find_" + parentID + "'/>";
		$("#find_text").html(dom);
		$("#find_content").show();
		$.csOrden.autoFabricFind(parentID);
	},
	loadRootMenu: function(clickedMenu, parentID) {
		$.cookie('accordionid', parentID, {
			path: "/"
		});
		// var datas;
		if ($(clickedMenu).next().length > 0) {
			if ($(clickedMenu).next(':hidden').length > 0) {
				$(clickedMenu).next().show();
			} else {
				$(clickedMenu).next().hide();
			}
		} else {
			$('.menu').remove();
			$(clickedMenu).siblings().find('ul').remove();
			var url = $.csCore.buildServicePath('/service/orden/getmenu');
			var param = $.csControl.appendKeyValue("", "parentid", parentID);
			 $.ajax({
                 url: url,
                 data: { formData: param },
                 type: "post",
                 dataType: "json",
                 success: function (datas, textStatus, jqXHR) {
                	 if (!$.csValidator.isNull(datas)) {
         				$(clickedMenu).addClass('fly');
         				var domDiv = "<div class='menu' ><ul>";
         				for (var i = 0; i < datas.length; i++) {
         					domDiv += "<li id=p" + datas[i].ID + " onclick='$.csOrden.loadPopMenu(this," + datas[i].ID + ");'>&nbsp;&nbsp;&nbsp;&nbsp;" + datas[i].name + "</li>";
         				}
         				domDiv += "</ul></div>";
         				$(clickedMenu).after(domDiv);
         				if ($.cookie("isClassic") != null && $.cookie("isClassic") != "false") {
         					var dict = $(clickedMenu).attr("id");
         					var arr = new Array();
         					var dicts = new Array();
         					dicts = $.csCore.getDictsByParent(1, $(clickedMenu).attr("id").substring(1));
         					for (j = 0; j < dicts.length; j++) {
         						if (DICT_DESIGN_STYLE.indexOf(dicts[j].ID, 0) > -1) {
         							$("#p" + dicts[j].ID).css("display", "none");
         						}
         					}
         				}
         			}
         			if (DICT_CLOTHING_ShangYi == parentID || DICT_CLOTHING_PANT == parentID) {
         				var play = $("#p" + datas[0].ID).css("display");
         				if (play == "none") { //经典设计-设计款式隐藏，点击上衣、西裤款式直接进入深度设计中
         					$.csOrden.loadPopMenu($('.menu').find('li')[1], datas[1].ID);
         				} else { //点击上衣、西裤款式直接进入设计款式中
         					$.csOrden.loadPopMenu($('.menu').find('li')[0], datas[0].ID);
         				}
         			}
                 },
                 error: function (xhr) {
                     d = xhr.responseText;
                 }
             });
			// $.csOrden.loadPopMenu($('.menu').find('li')[0],datas[0].ID);
			// $(".menu").find("li").click(function
			// (event){event.stopPropagation();});
		}
		// 显示搜索
		var fabricId = new Array();
		fabricId = DICT_FABRIC.split(",");
		var j = 0;
		for (var i = 0; i < fabricId.length; i++) {
			if (parentID == fabricId[i]) { // 面料
				var dom = "<input class='find_text' id='find_" + parentID + "'/>";
				$("#find_text").html(dom);
				$("#find_content").show();
				j++;
			}
		}
		if (j == 0) {
			$("#find_content").hide();
		} else {
			$.csOrden.autoFabricFind(parentID);
		}
	},
	loadPopMenu: function(clickedMenu, parentID) {
		$.cookie("lapel", "ok"); //用于判断驳头型切换是来自点击列表还是点击小图
		$(clickedMenu).siblings().find('ul').remove();
		if ($(clickedMenu).find('ul').length > 0) {
			if ($(clickedMenu).children('ul:hidden').length > 0) {
				$(clickedMenu).children('ul').show();
			} else {
				$(clickedMenu).children('ul').hide();
			}
		} else {
			var url = $.csCore.buildServicePath('/service/orden/getmenu');
			var param = $.csControl.appendKeyValue("", "parentid", parentID);
			 $.ajax({
                 url: url,
                 data: { formData: param },
                 type: "post",
                 dataType: "json",
                 success: function (datas, textStatus, jqXHR) {
                	 if (datas != "" && datas != null) {
         				$(clickedMenu).addClass('fly');
         				var domDiv = "<ul>";
         				for (var i = 0; i < datas.length; i++) {
         					var j = 0;
         					j = i + 1;
         					if (datas[i].code.length < 4) {
         						j = "";
         					}
         					domDiv += "<li id=p" + datas[i].ID + " onclick='$.csOrden.loadPopMenu(this," + datas[i].ID + ")'>>&nbsp;" + datas[i].name + "</li>";
         				}
         				domDiv += "</ul>";
         				$(clickedMenu).append(domDiv);
         				$.csOrden.loadPopMenu($(clickedMenu).find('li')[0], datas[0].ID);
         				$(clickedMenu).find("li").click(function(event) {
         					event.stopPropagation();
         				});
         				$(clickedMenu).children('ul').show();
         			} else {
         				jQuery.csOrden.loadComponent(clickedMenu, parentID);
         				// 显示搜索
         				var dict = $.csCore.getDictByID(parentID);
         				if (dict.categoryID == 8) { // 面料
         					$("#find_content").show();

         				} else { // 线、扣、袖里、领地呢、里料
         					var qtId = new Array();
         					qtId = DICT_QT.split(",");
         					var num = 0;
         					for (var n = 0; n < qtId.length; n++) {
         						if (parentID == qtId[n]) {
         							var dom = "<input class='find_text' id='find_" + parentID + "'/>";
         							$("#find_text").html(dom);
         							$("#find_content").show();
         							num++;
         						}
         					}
         					if (num == 0) {
         						$("#find_content").hide();
         					} else {
         						$.csOrden.autoDictFind(parentID);
         					}
         				}
         			}
                 },
                 error: function (xhr) {
                     d = xhr.responseText;
                 }
             });
		}
		$.cookie("lapel", ""); //清空
	},
	loadComponent: function(clickedMenu, parentID, type) {
		$(".menu").find('li').css("background-color", "");
		$(".menu").find('li').css("color", "");
		if ($.csValidator.isNull(type)) {
			$(clickedMenu).css("background-color", "#282828").css("color", "#fff");
		}
		$.cookie('currentmenuid', parentID, {
			path: "/"
		});
		var tempCode = this.getTempComponentIDs();
		$("#show_small").html("");
		 $.ajax({
             url: $.csCore.buildServicePath('/service/orden/getcomponent'),
             data: { formData:  $.csControl.appendKeyValue("", "parentid", parentID) },
             type: "post",
             dataType: "json",
             success: function (datas, textStatus, jqXHR) {
            	 var ComponentPageSize = 8;
         		var ComponentHeight = 74;
         		// var objPageSize =
         		// $.csCore.invoke($.csCore.buildServicePath('/service/orden/getcomponentpagesize'),$.csControl.appendKeyValue("","parentid",parentID));
         		// if(!$.csValidator.isNull(objPageSize)){	
         		// ComponentPageSize = objPageSize.pageSize;
         		// ComponentHeight = objPageSize.height+4;
         		// }
         		// $(".next_slide,.prev_slide,.slides_container
         		// div.slide").height(height+4);
         		var test = "";
         		for (var i = 0; i < datas.length; i++) {
         			var objPageSize = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getcomponentpagesize'), $.csControl.appendKeyValue("", "parentid", datas[i].category));
         			if (!$.csValidator.isNull(objPageSize)) {
         				ComponentPageSize = objPageSize.pageSize;
         				ComponentHeight = objPageSize.height + 4;
         			}
         			var domDiv = "";

         			domDiv += "<div id='orden_component" + datas[i].category + "' class='component'>";
         			domDiv += "<a class='prev_slide'></a>";
         			domDiv += "<div class='slides_container'>";
         			domDiv += "<div class='slide'>";
         			domDiv += jQuery.csOrden.createSlideItem(datas[i].details[0], tempCode);
         			// alert(datas[i].details.length);
         			// alert(ComponentPageSize);
         			for (var j = 1; j < datas[i].details.length; j++) {
         				if (j % ComponentPageSize == 0) {
         					domDiv += "</div>";
         					domDiv += "<div class='slide'>";
         					test += datas[i].details[j].imgUrl + "\n";
         					domDiv += jQuery.csOrden.createSlideItem(datas[i].details[j], tempCode);
         				} else {
         					test += datas[i].details[j].imgUrl + "\n";
         					domDiv += jQuery.csOrden.createSlideItem(datas[i].details[j], tempCode);
         				}
         			}
         			domDiv += "</div>";
         			domDiv += "</div>";
         			domDiv += "<a class='next_slide'></a>";
         			domDiv += "</div>";
         			$("#show_small").append(domDiv);

         			// if(!$.csValidator.isNull(datas[0]) &&
         			// !$.csValidator.isNull(datas[0].details[0]) &&
         			// !$.csValidator.isNull(datas[0].details[0].jsEvent)){
         			// loadMediumComponent
         			// loadMediumFabric
         			// eval(datas[0].details[0].jsEvent);
         			// }
         			$(".next_slide,.prev_slide,.slides_container div.slide").height(ComponentHeight);
         			$('#orden_component' + datas[i].category).slides({
         				generatePagination: false
         			});
         		}
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });

		// alert(domDiv);
		if ($('#show_medium').find('img').length <= 0) {
			$.csOrden.loadMediumFabric(this.getTempFabricCode());
			// this.loadProduct(DICT_VIEW_FRONT);
		}

		this.loadMediumParameter(parentID, tempCode, "");
		this.loadComponentText(parentID);
		$.csOrden.write($("input[type='text']").attr("id"));
		//无面料标、商标时自定义面料标、商标内容不允许输入
		if ($.cookie("BIAO") != null) {
			this.textCheck($.cookie("BIAO"));
		}
	},
	createSlideItem: function(details, tempCode) {
		if (!$.csValidator.isNull(details)) {
			strClass = "";
			if ($.csCore.contain(tempCode, details.ID)) {
				strClass = " class='" + this.ITEMCHECK_CSS + "' ";
				eval(details.jsEvent);
			}
			return "<div class='item' onclick=" + details.jsEvent + "><img " + strClass + " id='img_" + details.ID + "' src='" + details.imgUrl + "' title='" + details.name + "'></div>";
		}
		// loadMediumComponent
		// loadMediumFabric
		return "";
	},
	loadComponentText: function(parentID) {
		var dom = "";
		var url = $.csCore.buildServicePath('/service/orden/getcomponenttext');
		var param = $.csControl.appendKeyValue("", "parentid", parentID);
		 $.ajax({
             url: url,
             data: { formData:param},
             type: "post",
             dataType: "json",
             success: function (datas, textStatus, jqXHR) {
            	 for (var i = 0; i < datas.length; i++) {
         			var value = $.csOrden.getTempComponentText(datas[i].ID);
         			dom += "<div class='component_text'>" + datas[i].name + "<input type='text' maxlength='25' value='" + value + "' onkeyup='$.csOrden.write(" + datas[i].ID + ");' onblur='$.csOrden.setComponentText(this)' id='" + datas[i].ID + "'/></div>";
         			// $('#show_medium #medium_text').html(value);
         			// $.csOrden.write(datas[i].ID);
         			// this.writeCss(datas[i].ID);
         		}
            	$("#show_small").append(dom);
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });
		return dom;
	},
	getNextMenu: function() {
		var allLi = $(".menu").find('li');
		var currentmenuid = $.cookie('currentmenuid');
		var dict = $.csCore.getDictByID(currentmenuid);
		if (!$.csValidator.isNull(dict)) {
			if (dict.categoryID == 8) {
				if ($.cookie('clothingid') == 1 || $.cookie('clothingid') == 2) {
					$('#p3').click();
					//                    $('#p24').click();
					//                    if ($.csOrden.isIE8()) {
					//                        $('#p24').click();
					//                    }
				}
				if ($.cookie('clothingid') == 3) {
					//经典设计-设计款式隐藏，点击上衣下一步直接进入深度设计中
					if ($("#p24").css("display") == "none") {
						$('#p298').click();
						$('#p299').click();
					} else {
						$('#p24').click();
						$('#p31').click();
					}
				}
				if ($.cookie('clothingid') == 2000) {
					//经典设计-设计款式隐藏，点击西裤下一步直接进入深度设计中
					if ($("#p2021").css("display") == "none") {
						$('#p2157').click();
						$('#p2158').click();
					} else {
						$('#p2021').click();
						$('#p2027').click();
					}
				}
				if ($.cookie('clothingid') == 3000) {
					//经典设计-设计款式隐藏，点击衬衣下一步直接进入深度设计中
					if ($("#p3016").css("display") == "none") {
						$('#p3184').click();
						$('#p3185').click();
					} else {
						$('#p3016').click();
						$('#p3026').click();
					}
				}
				if ($.cookie('clothingid') == 4000) {
					//经典设计-设计款式隐藏，点击马夹下一步直接进入深度设计中
					if ($("#p4016").css("display") == "none") {
						$('#p4075').click();
						$('#p4076').click();
					} else {
						$('#p4016').click();
						$('#p4022').click();
					}
				}
				if ($.cookie('clothingid') == 6000) {
					//经典设计-设计款式隐藏，点击大衣下一步直接进入深度设计中
					if ($("#p6007").css("display") == "none") {
						$('#p6276').click();
						$('#p6409').click();
					} else {
						$('#p6007').click();
						$('#p6013').click();
					}
				}
				return;
			}
			if (currentmenuid == 417 && ($.cookie('clothingid') == 1 || $.cookie('clothingid') == 2)) {
				$('#p2000').click();
				//                $('#p2021').click();
				//                if ($.csOrden.isIE8()) {
				//                    $('#p2021').click();
				//                }
				return;
			}
			if (currentmenuid == 2318 && $.cookie('clothingid') == 2) {
				$('#p4000').click();
				$('#p4016').click();
				if ($.csOrden.isIE8()) {
					$('#p4016').click();
				}
				return;
			}
			if (currentmenuid == 293 && $.cookie('clothingid') == 3) {
				$('#p298').click();
				$('#p299').click();
				return;
			}
			if (currentmenuid == 2141 && $.cookie('clothingid') == 2000) {
				$('#p2157').click();
				$('#p2158').click();
				return;
			}
			if (currentmenuid == 3173 && $.cookie('clothingid') == 3000) {
				$('#p3184').click();
				$('#p3185').click();
				return;
			}
			if (currentmenuid == 4069 && $.cookie('clothingid') == 4000) {
				$('#p4075').click();
				$('#p4076').click();
				return;
			}
			if (currentmenuid == 6256 && $.cookie('clothingid') == 6000) {
				$('#p6276').click();
				$('#p6409').click();
				return;
			}
			// alert(currentmenuid+ dict.name);
		}
		for (var i = 0; i < allLi.length; i++) {
			if (("p" + currentmenuid) == $(allLi[i]).attr("id")) {
				if ($(allLi[i + 1]).length < 1) {

					if ($($(".menu").parent().next().find('.accordion')[0]).length < 1) {
						$(".menu").parent().parent().next().find('.accordion').click();
					} else {
						$($(".menu").parent().next().find('.accordion')[0]).click();
					}
				} else {
					var ss = $(allLi[i + 1]).attr("id").split("p")[1];
					$.csOrden.loadPopMenu($(allLi[i + 1]), ss);
				}
				return;
			}
		}
	},
	isIE8: function() {
		if ($.browser.msie && ($.browser.version == "8.0")) {
			return true;
		} else {
			return false;
		}
	},
	getBackMenu: function() {
		var allLi = $(".menu").find('li');
		var currentmenuid = $.cookie('currentmenuid');
		//alert(currentmenuid);
		// alert($('#orden_clothing_category').html());
		// alert($.cookie('clothingid'));
		if (currentmenuid == 31) {
			$('#p8001').click();
			$('#p8019').click();
			$('#p8022').click();
			return;
		}
		if (currentmenuid == 8020) {
			$('#p8009').click();
			$('#p8073').click();
			return;
		}
		if (currentmenuid == 8010) {
			$('#p8014').click();
			$('#p8018').click();
			return;
		}
		if (currentmenuid == 299) { //深度设计
			//经典设计-设计款式隐藏，点击上衣深度设计上一步直接进入面料选择中
			if ($("#p24").css("display") == "none") {
				$('#p8001').click();
				$('#p8019').click();
				$('#p8022').click();
			} else {
				$('#p24').click();
				$('#p293').click();
			}
			return;
		}
		if (currentmenuid == 2027 && $.cookie('clothingid') != 2000) {
			$('#p3').click();
			//            $('#p298').click();
			//            $('#p417').click();
			return;
		}
		if (currentmenuid == 2158) {
			//经典设计-设计款式隐藏，点击西裤深度设计上一步直接进入面料选择中
			if ($("#p2021").css("display") == "none") {
				$('#p8001').click();
				$('#p8019').click();
				$('#p8022').click();
			} else {
				$('#p2021').click();
				$('#p2141').click();
			}
			return;
		}
		if (currentmenuid == 4022 && $.cookie('clothingid') != 4000) {
			$('#p2000').click();
			//            $('#p2157').click();
			//            $('#p2318').click();
			return;
		}
		if (currentmenuid == 4077) {
			$('#p4016').click();
			$('#p4069').click();
			return;
		}
		if (currentmenuid == 4088) {
			$('#p4076').click();
			$('#p4081').click();
			return;
		}
		if (currentmenuid == 2027 && $.cookie('clothingid') == 2000) {
			$('#p8001').click();
			$('#p8019').click();
			$('#p8022').click();
			return;
		}
		if (currentmenuid == 3185) {
			//经典设计-设计款式隐藏，点击衬衣深度设计上一步直接进入面料选择中
			if ($("#p3016").css("display") == "none") {
				$('#p8030').click();
				$('#p8040').click();
				$('#p8043').click();
			} else {
				$('#p3016').click();
				$('#p3173').click();
			}
			return;
		}
		if (currentmenuid == 3026) {
			$('#p8030').click();
			$('#p8040').click();
			$('#p8043').click();
			return;
		}
		if (currentmenuid == 8052) {
			$('#p8035').click();
			$('#p8047').click();
			return;
		}
		if (currentmenuid == 4022 && $.cookie('clothingid') == 4000) {
			$('#p8001').click();
			$('#p8019').click();
			$('#p8022').click();
			return;
		}
		if (currentmenuid == 6013) {
			$('#p8050').click();
			$('#p8082').click();
			$('#p8090').click();
			return;
		}
		if (currentmenuid == 4076) {
			//经典设计-设计款式隐藏，点击马夹深度设计上一步直接进入面料选择中
			if ($("#p4016").css("display") == "none") {
				$('#p8001').click();
				$('#p8019').click();
				$('#p8022').click();
			} else {
				$('#p4016').click();
				$('#p4069').click();
			}
			return;
		}
		if (currentmenuid == 6409) {
			//经典设计-设计款式隐藏，点击大衣深度设计上一步直接进入面料选择中
			if ($("#p4016").css("display") == "none") {
				$('#p8050').click();
				$('#p8082').click();
				$('#p8090').click();
			} else {
				$('#p6007').click();
				$('#p6256').click();
			}
			return;
		}

		for (var i = 0; i < allLi.length; i++) {
			if (("p" + currentmenuid) == $(allLi[i]).attr("id")) {
				$(allLi[i - 1]).click().click();
				if (currentmenuid == $.cookie('currentmenuid')) {
					$(allLi[i - 2]).click();
					if (currentmenuid == $.cookie('currentmenuid')) {
						$(allLi[i - 3]).click();
					}
				}
				return;
			}
		}
	},
	write: function(key) {
		$('#show_medium #medium_text').html('');
		if (!$.csValidator.isNull($("#" + key).val()) && $("#" + key).val() != "on") {
			if ($("#medium_text").length <= 0) {
				$('#show_medium').append("<div id='medium_text'></div>");
			}
			$('#show_medium #medium_text').html($("#" + key).val());
			this.writeCss(key);
		}
	},
	writeCss: function(key) {
		var color = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getelementcolor'), $.csControl.appendKeyValue("", "contentid", key));
		var font = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getelementfont'), $.csControl.appendKeyValue("", "contentid", key));
		var position = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getposition'), $.csControl.appendKeyValue("", "contentid", key));
		var parts = position.split(",");
		var top = parts[0] + "px";
		var left = parts[1] + "px";
		$('#show_medium #medium_text').css("color", color).css("font-family", font).css("left", left).css("top", top).css("font-size", "18px");
	},
	setComponentText: function(element) {
		var value = $(element).val();
		var label = $(element).attr('id');

		var url = $.csCore.buildServicePath('/service/orden/settempcomponenttext');
		var param = $.csControl.appendKeyValue("", "label", label);
		param = $.csControl.appendKeyValue(param, "value", value);
		$.csCore.invoke(url, param);
		$.csOrden.write(label);
	},
	setTempParameter: function(id) {
		var url = $.csCore.buildServicePath('/service/orden/settempparameterid');
		var param = $.csControl.appendKeyValue("", "id", id);
		$.csCore.invoke(url, param);
		this.displayMediumImage(id, "", "");
		var parameter = $.csCore.getDictByID(id);
		this.loadProduct(this.getViewID(parameter.extension));
		$.csOrden.write($("input[type='text']").attr("id"));
		this.checkLength(id); //设置刺绣内容长度
	},
	checkLength: function(id) {//衬衣
		var textval = $("#3676").val();
		if (id == 3250) {//左胸部
			$("#3676").attr("maxlength", "4");
			if(textval.length>4){
				$("#3676").val(textval.substring(0,4));
				this.setComponentText($("#3676"));
			}
		} else if (id == 3249 || id == 3247) {//左右袖头面
			$("#3676").attr("maxlength", "6");
			if(textval.length>6){
				$("#3676").val(textval.substring(0,6));
				this.setComponentText($("#3676"));
			}
		} else if (id == 3530) {//底领面
			$("#3676").attr("maxlength", "9");
		} else if (id == 3780) {//口袋口
			$("#3676").attr("maxlength", "5");
			if(textval.length>5){
				$("#3676").val(textval.substring(0,5));
				this.setComponentText($("#3676"));
			}
		}
	},
	loadMediumFabric: function(parentID) {
		var strMediumImg = "<div id='fabric_medium'><div id='fabric_detail'></div><img src='../../process/fabric/" + parentID + "_M.png'></div>";

		$('#show_medium').html(strMediumImg);

		var url = $.csCore.buildServicePath('/service/fabric/getfabricbycode');
		var param = $.csControl.appendKeyValue("", "code", parentID);
		 $.ajax({
             url: url,
             data: { formData: param },
             type: "post",
             dataType: "json",
             success: function (fabric, textStatus, jqXHR) {
            	 if (!$.csValidator.isNull(fabric)) {
         			var fabricDetail = "<br/><br/>" + fabric.code + "<br/>";
         			if (!$.csValidator.isNull(fabric.categoryName)) {
         				// fabricDetail += fabric.categoryName + "<br/>";
         			}
         			if (!$.csValidator.isNull(fabric.colorName)) {
         				fabricDetail += fabric.colorName + "/";
         			}
         			if (!$.csValidator.isNull(fabric.seriesName)) {
         				// fabricDetail+= fabric.seriesName+ "<br/>";
         			}
         			if (!$.csValidator.isNull(fabric.compositionName)) {
         				fabricDetail += fabric.compositionName + "/";
         			}
         			if (!$.csValidator.isNull(fabric.shaZhi)) {
         				fabricDetail += fabric.shaZhi + "/";
         			}
         			if (fabricDetail.endWith('/')) {
         				fabricDetail = fabricDetail.substring(0, fabricDetail.length - 1);
         			}
         			$('#fabric_detail').html(fabricDetail);
         		}
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });
		
		this.checkOneItem(parentID);
		// 存储选中的面料
		var url = $.csCore.buildServicePath('/service/orden/settempfabriccode');
		var param = $.csControl.appendKeyValue("", "fabriccode", parentID);
		$.csCore.invoke(url, param);
		this.loadProduct(DICT_VIEW_FRONT);
	},
	getViewID: function(viewId) {
		if (!$.csValidator.isNull(viewId)) {
			var views = viewId.toString().split(',');
			if (views.length > 1) {
				viewId = $.cookie($.csOrden.PRODUCT_VIEW);
			}
		}
		return viewId;
	},
	loadMediumComponent: function(parentID, viewId) {
		// var tempFabricCode = this.getTempFabricCode();
		$('#fabric_detail').html('');
		
		this.getViewID(viewId);
		this.checkOneItem(parentID);
		
		// 存储选中的部件
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempcomponentid'), $.csControl.appendKeyValue("", "id", parentID));
		this.loadMediumParameter("", "");
		this.displayMediumImage(parentID, viewId); //暂时修改发现问题再说
		$.csOrden.write($("input[type='text']").attr("id"));
		this.loadProduct(viewId);
		if($("input[type=radio]:checked").attr("id") ==  427){
			
			this.displayMediumImage(427, "", "");
			var parameter = $.csCore.getDictByID(427);
			this.loadProduct(this.getViewID(parameter.extension));
		}
	},
	loadMediumParameter: function(parentID, tempCode) {
		if ($.csValidator.isNull(parentID)) {
			parentID = $.cookie('currentmenuid');
		}
		if ($.csValidator.isNull(tempCode)) {
			tempCode = this.getTempComponentIDs();
		}
		$('#show_medium #medium_parameter_container').html('');
		var url = $.csCore.buildServicePath('/service/orden/getparametercategory');
		var param = $.csControl.appendKeyValue("", "parentid", parentID);
		var categorys = $.csCore.invoke(url, param);
		$.each(categorys,
		function(i, category) {
			 $.ajax({
	             url:$.csCore.buildServicePath('/service/orden/getparameters'),
	             data: { formData: $.csControl.appendKeyValue("", "parentid", category.ID)},
	             type: "post",
	             dataType: "json",
	             async: false,//暂时这么改 没找到原因
	             success: function (parameters, textStatus, jqXHR) {
	            	 var dom = "<div id='medium_parameter_container'>";
	            	 if (parameters.length > 0) {
	     				dom += "<div class='medium_parameter'>";
	     				dom += "<h1>" + category.name + "</h1>";
	     				var strRadio = "";
	     				if (parentID == LAPEL) { //驳头选择
	     					if ($.cookie("lapel") == "ok") { //点击列表驳头型
	     						var strFind = "";
	     						$.each(parameters,
	     						function(j, parameter) {
	     							if ($.csCore.contain(tempCode, parameter.ID)) {
	     								strFind = parameter.ID; //已选择驳头宽
	     							}
	     						});
	     						$.each(parameters,
	     						function(j, parameter) {
	     							if (parameter.ID == strFind) {
	     								strRadio = " checked='true' ";
	     							} else {
	     								strRadio = "";
	     							}
	     							dom += "<label><input type='radio' " + strRadio + " onclick='$.csOrden.setTempParameter(" + parameter.ID + ");' id='" + parameter.ID + "' name='" + category.ID + "'/>" + parameter.name + "</label>";
	     						});
	     					} else { //点击小图换驳头型，添加默认驳头
	     						var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getlapelwidthid'));
	     						$.each(parameters,
	     						function(j, parameter) {
	     							if (parameter.ID == data) {
	     								strRadio = " checked='true' ";
	     							} else {
	     								strRadio = "";
	     							}
	     							dom += "<label><input type='radio' " + strRadio + " onclick='$.csOrden.setTempParameter(" + parameter.ID + ");' id='" + parameter.ID + "' name='" + category.ID + "'/>" + parameter.name + "</label>";
	     						});
	     					}
	     				} else {
	     					$.each(parameters,
	     					function(j, parameter) {
	     						var strChecked = "";
	     						if ($.csCore.contain(tempCode, parameter.ID)) {
	     							strChecked = " checked='true' ";
	     							//id= parameter.ID;
	     						}
	     						//西裤手表袋，位置默认--左
	     						if(category.ID == 2999 && j==0){
	     							var n=0;
	     							$.each(parameters,
	     								function(j, parameter) {
	     									if ($.csCore.contain(tempCode, parameter.ID)) {
	     										n++;
	     									}
	     								});
	     							if(n == 0){
	     								strChecked = " checked='true' ";
	     								$.csOrden.setTempParameter(2064);
	     							}
	     						}
	     						if (parameter.isSingleCheck == DICT_YES || category.isSingleCheck == DICT_YES) {
	     							dom += "<label title='"+parameter.ID+"'><input type='radio' " + strChecked + "  onclick='$.csOrden.setTempParameter(" + parameter.ID + ");' id='" + parameter.ID + "' name='" + category.ID + "'/>" + parameter.name + "</label>";
	     						} else {
	     							dom += "<label><input type='checkbox' " + strChecked + "  onclick='$.csOrden.setTempParameter(" + parameter.ID + ");' id='" + parameter.ID + "' />" + parameter.name + "</label>";
	     						}
	     					});
	     				}
	     				dom += "</div>";
	     			}
	            	dom += "</div>";
	         		$('#show_medium').append(dom);
	             },
	             error: function (xhr) {
	                 d = xhr.responseText;
	             }
	         });
			
		});
		if($("input[type=radio]:checked").attr("id") ==  427){
			
			this.displayMediumImage(427, "", "");
			var parameter = $.csCore.getDictByID(427);
			this.loadProduct(this.getViewID(parameter.extension));
		}
	},
	displayMediumImage: function(parentID, viewId) {
		$('#show_medium img').remove();
		var divDom = "";
		var url = $.csCore.buildServicePath('/service/orden/getmediumcomponent');
		var param = $.csControl.appendKeyValue("", "componentid", parentID);
		param = $.csControl.appendKeyValue(param, "viewid", viewId);
		 $.ajax({
             url:url,
             data: { formData: param},
             type: "post",
             dataType: "json",
             success: function (mediumComponents, textStatus, jqXHR) {
            	 var imgs = "";
         		if (mediumComponents != null) {
         			for (var i = 0; i < mediumComponents.length; i++) {

         				var splits = mediumComponents[i].imgUrl.split(",");

         				for (var j = 0; j < splits.length; j++) {

         					var zindex = mediumComponents[i].zindex;
         					if (!$.csValidator.isNull(zindex)) {
         						if (j > 0) {
         							zindex = parseInt(zindex) - 32;
         						}
         					}
         					imgs += splits[j] + " " + zindex + "\n";
         					divDom += "<img style='z-index:" + zindex + "' src='" + splits[j] + "'>";
         				}
         			}
         		}
         		//alert("中图\n" + imgs);
         		$('#show_medium').append(divDom);
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });
	},
	loadProduct: function(viewId) {
		viewId = this.getViewID(viewId);
		if (viewId == DICT_VIEW_FRONT || viewId == DICT_VIEW_BACK) {
			$("#fb_view").show();
		} else {
			$("#fb_view").hide();
		}
		var url = $.csCore.buildServicePath('/service/orden/gettempproduct');
		var param = $.csControl.appendKeyValue("", "viewid", viewId);
		 $.ajax({
             url: url,
             data: { formData: param },
             type: "post",
             dataType: "json",
             success: function (tempProducts, textStatus, jqXHR) {
            	 var divDom = "";
                 var imgUrl = "";
                 if (!$.csValidator.isNull(tempProducts)) {
                     for (var i = 0; i < tempProducts.length; i++) {
                         imgUrl += tempProducts[i].imgUrl + " " + tempProducts[i].zindex + "\n";
                         if (!$.csValidator.isNull(tempProducts[i].imgUrl)) {
                             divDom += "<img style='z-index:" + tempProducts[i].zindex + "' src='" + tempProducts[i].imgUrl + "'>";
                         }
                     }
                 }
                 //alert("大图\n" + imgUrl);
                 $("#show_large").html(divDom);
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });

    },
	checkOneItem: function(parentID) {
		$("#img_" + parentID).parent().parent().parent().find(".item img").removeClass(this.ITEMCHECK_CSS);
		$("#img_" + parentID).addClass(this.ITEMCHECK_CSS);
	},

	getTempFabricCode: function() {
		return $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempfabriccode'));
	},

	getTempComponentIDs: function() {
		return $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempcomponentids'));
	},

	getTempComponentText: function(id) {
		var url = $.csCore.buildServicePath('/service/orden/gettempcomponenttext');
		var param = $.csControl.appendKeyValue("", "id", id);
		return $.csCore.invoke(url, param);
	},
	autoFabricFind: function(parentID) {
		clothingid =  $.cookie("clothingid");
		//alert(clothingid);
		var url = $.csCore.buildServicePath('/service/fabric/getfabricbykeyword?categortid='+ clothingid);
		$("#find_" + parentID).autocomplete(url, {
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
			$.csOrden.loadMediumFabric(data.code);
		});
	},
	autoDictFind: function(parentID) {
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getcomponent'), $.csControl.appendKeyValue("", "parentid", parentID));
		var param = $.csControl.appendKeyValue("", "id", datas[0].details[0].ID);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/dict/getdictbyid'), param);
		var nParentID = data.parentID;

		var url = $.csCore.buildServicePath('/service/dict/getdictbykeyword?parentID=' + nParentID);
		$("#find_" + parentID).autocomplete(url, {
			multiple: false,
			dataType: "json",
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.id,
						result: row.ecode
					};
				});
			},
			formatItem: function(item) {
				return item.name + "(" + item.ecode + ")";
			}
		}).result(function(e, data) {
			$.csOrden.loadMediumComponent(data.ID, data.extension);
		});
	},
	clickLoadMediumFabric: function(parentID) {
		$("*[id^='find_']").val("");
		$.csOrden.loadMediumFabric(parentID);
	},
	clickLoadMediumComponent: function(parentID, viewId) {
		if ($.cookie("lapel") != "ok") { //前门扣-->驳头宽
			var param = $.csControl.appendKeyValue("", "id", parentID);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/dict/getdictbyid'), param);
			if (data.parentID == FRONTBUTTON) {
				$.csCore.invoke($.csCore.buildServicePath('/service/orden/getlapelwidthid'), param);
			}
		}
		$("*[id^='find_']").val("");
		$.csOrden.loadMediumComponent(parentID, viewId);
		this.textCheck(parentID); //清空面料标、商标
	},
	textCheck: function(parentID) {
		if (parentID == 3270) {
			this.setComponentTextNull(20113);
			$.cookie("BIAO", parentID);
		} else if (parentID == 2512) {
			this.setComponentTextNull(20112);
			$.cookie("BIAO", parentID);
		} else if (parentID == 564) {
			this.setComponentTextNull(20111);
			$.cookie("BIAO", parentID);
		} else if (parentID == 3273) {
			this.setComponentTextNull(20116);
			$.cookie("BIAO", parentID);
		} else if (parentID == 2641) {
			this.setComponentTextNull(20115);
			$.cookie("BIAO", parentID);
		} else if (parentID == 576) {
			this.setComponentTextNull(20114);
			$.cookie("BIAO", parentID);
		}
		if (parentID == 1014) {
			$("#20111").removeAttr("readonly");
			$.cookie("BIAO", null);
		} else if (parentID == 2590) {
			$("#20112").removeAttr("readonly");
			$.cookie("BIAO", null);
		} else if (parentID == 3280) {
			$("#20113").removeAttr("readonly");
			$.cookie("BIAO", null);
		} else if (parentID == 3272) {
			$("#20116").removeAttr("readonly");
			$.cookie("BIAO", null);
		} else if (parentID == 2642) {
			$("#20115").removeAttr("readonly");
			$.cookie("BIAO", null);
		} else if (parentID == 1185) {
			$("#20114").removeAttr("readonly");
			$.cookie("BIAO", null);
		}
	},
	setComponentTextNull: function(label) {
		$("#" + label).val("");
		$("#" + label).attr("readOnly", "true");
		var url = $.csCore.buildServicePath('/service/orden/settempcomponenttext');
		var param = $.csControl.appendKeyValue("", "label", label);
		param = $.csControl.appendKeyValue(param, "value", "");
		$.csCore.invoke(url, param);
	},
	loadAlipay: function() {
		var member = $.csCore.getCurrentMember();
		//用户级别：1.hongling 2.后台管理员 3.有支付权限用户 4.子用户
		if (member.code.length == 12) { //第三级
			$("#payOrden").show();
			if ($("#versions").val() > 1) {
				$("#alipay").hide();
			}
		}
	}
};
$(function() {
	$.csBase.init(this);
	$.csOrden.bindLabel();
	$.csOrden.bindEvent();
	$.csOrden.loadClothing();
	$.csOrden.loadAlipay();
});