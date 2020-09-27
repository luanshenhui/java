jQuery.csOrdenPost = {
	bindEvent: function() {
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
		
		var clothing = $("input[name='clothingID']:checked").val();
		if(clothing ==1){
			var result_XF = $.csOrdenPost.checkEmbroidNull('3');
			var result_XK = $.csOrdenPost.checkEmbroidNull('2000');
			if(result_XF == false || result_XK == false){
				return false;
			}
		}else if(clothing ==2){
			var result_XF = $.csOrdenPost.checkEmbroidNull('3');
			var result_XK = $.csOrdenPost.checkEmbroidNull('2000');
			var result_MJ = $.csOrdenPost.checkEmbroidNull('4000');
			if(result_XF == false || result_XK == false || result_MJ == false){
				return false;
			}
		}else if(clothing ==4){
			var result_MJ = $.csOrdenPost.checkEmbroidNull('4000');
			var result_XK = $.csOrdenPost.checkEmbroidNull('2000');
			if(result_XK == false || result_MJ == false){
				return false;
			}
		}else if(clothing ==6){
			var result_XF = $.csOrdenPost.checkEmbroidNull('3');
			var result_MJ = $.csOrdenPost.checkEmbroidNull('4000');
			if(result_XF == false || result_MJ == false){
				return false;
			}
		}else{
			return $.csOrdenPost.checkEmbroidNull(clothing);
		}
		
		return true;
	},
	checkEmbroidNull : function(clothing){
	//  清除空行
		var embCount  = $('#category_embroid_' + clothing +" tr").length;
		var rowNum = 0;
		for(var i = 0 ; i < embCount ; i++){
			var selectDom = $('#category_embroid_' + clothing +" tr").eq(i-rowNum).find('select');
			var inputDom = $('#category_embroid_' + clothing +" tr").eq(i-rowNum).find('input');
			var selectColCount = selectDom.length;
			var inputColCount = inputDom.length;
			var isEmpty = true;
			for(var j=0;j<selectColCount;j++){
				if(selectDom.eq(j).val() ==undefined || selectDom.eq(j).val() == '-1' ){
					isEmpty = true;
				}else{
					isEmpty = false;
					break;
				}
			}
			for(var m =0 ;m<inputColCount;m++){
				if(!isEmpty){
					break;
				}
				if(inputDom.eq(m).val() == undefined || inputDom.eq(m).val() == ''){
					isEmpty = true;
				}else{
					isEmpty = false;
					break;
				}
			}
			if(isEmpty){
				$('#category_embroid_' + clothing +" tr").eq(i-rowNum).remove();
				rowNum ++;
			}
		}
		
		var selecteDoms = $("#category_embroid_"+clothing+ " select");
		for(var i =0; i<selecteDoms.length;i++){
			if(selecteDoms.eq(i).val() == '-1' || selecteDoms.eq(i).val() == undefined){
				$.csCore.alert($.csCore.getValue("Embroidery_Error"));
				return false;
			}
		}
		var inputDoms = $("#category_embroid_"+clothing+ " input");
		for(var i =0; i<inputDoms.length;i++){
			if(inputDoms.eq(i).val() == '' || selecteDoms.eq(i).val() == undefined){
				$.csCore.alert($.csCore.getValue("Embroidery_Error"));
				return false;
			}
		}
		//刺绣位置不能重复
		for(var i = 0 ; i < embCount ; i++){
			for(var j = 0 ; j < embCount ; j++){
				if(i != j && $("#category_label_"+clothing+"_Position_"+i).val() !=undefined
						&& $("#category_label_"+clothing+"_Position_"+j).val() !=undefined
						&& $("#category_label_"+clothing+"_Position_"+i).val() == $("#category_label_"+clothing+"_Position_"+j).val()){
					$.csCore.alert($.csCore.getValue("Orden_Embroidery_Error"));
					return false;
				}
			}
		}
		//刺绣长度判断
		/*for(var i = 0 ; i < embCount ; i++){
			var memo= $("#category_label_"+clothing+"_Position_"+i+" :selected").attr("memo");
			if(memo != null){
				var content = $(".category_textbox_"+clothing+"_Content_"+i).val();
				if($.csOrdenPost.checkLength(content)>memo){
					var error = $("#category_label_"+clothing+"_Position_"+i).find("option:selected").text()+"&nbsp;"+$.csCore.getValue("Orden_CheckEmbroideryLen").replace("*",memo);
					$.csCore.alert(error);
					return false;
				}
			}
		}*/
	},
	checkLength : function(s) {
		var l = 0;
		var a = s.split("");
		for (var i=0;i<a.length;i++) {
			if (a[i].charCodeAt(0)<299) {
				l++;
			} else {
				l+=2;
			}
		}
		return l;
	},
	buildTextID: function(id) {
		return "category_textbox_" + id;
	},
	generateClothing: function(clothingID,orden) {
		var clothing = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		var dom = "<ul>";
		for (var i = 0; i < clothing.length; i++) {
			if(clothing[i].ID == 5 || clothing[i].ID == 7 || clothing[i].ID == 90000 || clothing[i].ID == 95000 || clothing[i].ID == 98000){//礼服、女西服、女西裤
				continue;
			}
			dom += "<li><label><input type='radio' name='clothingID' value='" + clothing[i].ID + "' onclick='$.csOrdenPost.clothingChange(" + clothing[i].ID + ");'/> " + clothing[i].name + "</label></li>";
		}
		dom += "</ul>";
		$("#container_clothings").html(dom);
		if ($.csValidator.isNull(clothingID)) {
			clothingID = clothing[0].ID;
		}
		$("input[value='" + clothingID + "']").attr("checked", "checked");
		$.csOrdenPost.generateComponent(clothingID,null);
		$.csOrdenPost.generateEmbroid(clothingID,orden);
	},
	generateComponent: function(clothingID,orden) {
		$("#container_component").html("");
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		for (var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name + "<a onclick='$.csOrdenPost.addComponentRow(" + arr[i] + ")'>" + $("#addText").val()+ "</a></div>" + "<table id='category_" + arr[i] + "' class='list_result'></table>";
			$("#container_component").append(dom);
			$.csOrdenPost.addComponentRow(arr[i]);
		}
		if(orden != null){//工艺信息(orden切换大类保存工艺)
			$.csOrdenPost.loadOrdenProcess(orden);
		}
	},
	getComponentRowHTML: function(clothingID, index) {
		return "<tr index='" + index + "'>" + "<td><input type='text' id='text_" + clothingID + "_" + index + "' style='width:130px' class='textbox'/><span/></td>" + "<td onclick=$(this).parent().remove();$.csOrdenPost.removeStyle('','"+clothingID+"','"+ index++ +"',$(this)) style='width:30px'><a class='remove'></a></td>" + "</tr>";
	},
	addComponentRow: function(clothingID) {
		var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}
		$("#category_" + clothingID).append($.csOrdenPost.getComponentRowHTML(clothingID, parseInt(lastIndex) + 1));
//		$.csOrdenPost.autoCompleteDict(clothingID, parseInt(lastIndex) + 1);
		$.csOrdenPost.inputProces(clothingID, parseInt(lastIndex) + 1);
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
		    		$.csOrdenPost.checkEcode(data[0],clothingID,$(this), index);
					
					$("#"+ $(this).attr("id")).blur();
		    	}
			}
        });
		if(num==0){
			$.csOrdenPost.autoCompleteDict(clothingID, index);
		}
	},
	inputProcesLowerLevel : function(dictID, url, clothingID){
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
		    		
			    	if (!$.csValidator.isNull(data[0])) {
//						$("#component_textbox_" + dictID).attr("id", "component_" + data[0].ID);
						//获取款式号内容
						var parentID=[1374,2618,4639,3713,6602,90082];
						for(var i=0 ;i<=5 ;i++){
							if(dictID == parentID[i]){
							   //删除原有款式工艺
							   var index = $("#category_" + clothingID + " tr:last").attr("index");
							   for(var j=index; j>=0; j--){
							    	if($("#stylesProc_"+j).length>0){
							    		$("#stylesProc_" + j).parent().remove();
								    }
							    }
								/**********************************       验证款式工艺与输入工艺是否冲突         *********
								   * 
								 * ***********************************************/
							    
							    var trCount = $("#category_" + clothingID + " tr").length;
							    var codesStr = "";
							    var tempCodeStr = "";
							    //此处默认当前带款式号行数为最后一行
							    if(trCount>1){
								    for(var x = 0;x<trCount-1;x++){
				//					    codesStr += $("#category_" + clothingID + " tr").eq(x).children().eq(0).eq(0).first().children().eq(0).attr('value')+",";
									    tempCodeStr = $("#category_" + clothingID + " tr").eq(x).find('input:first').attr('value');
									    if($("#category_" + clothingID + " tr").length > 1){
									    codesStr +=tempCodeStr +",";
									    }
								    }
							    }
								var param = $.csControl.appendKeyValue('','dictID',data[0].ecode);//款式号
								param = $.csControl.appendKeyValue(param,'clothingID',clothingID);//服装分类
								param = $.csControl.appendKeyValue(param,'procInputs',codesStr);//已录入工艺
								var validateProc = $.csCore.invoke($.csCore.buildServicePath("/service/dict/validateStyleProc"),param);
								if(validateProc){
									$.csCore.alert("工艺冲突,不能读取");
								}
								if(!validateProc){
								    //添加当前款式工艺
								    var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
									param = $.csControl.appendKeyValue('','dictID',data[0].ecode);//款式号
									param = $.csControl.appendKeyValue(param,'lastIndex',lastIndex);//行数
									param = $.csControl.appendKeyValue(param,'clothingID',clothingID);//服装分类
								    var dicts = $.csCore.invoke($.csCore.buildServicePath("/service/dict/getstylenumbyid"),param);
								    $("#category_"+clothingID).append(dicts);
								    }
								}
							}
					}
		    	}
			}
        });
		if(num==0){
			$.csOrdenPost.autoCompleteLowerLevelDict(dictID, url, clothingID);
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
    		$.csOrdenPost.checkEcode(data,clothingID,$(this), index);
			});
	},
	autoCompleteLowerLevelDict: function(dictID, url, clothingID) {
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
				//获取款式号内容
				var parentID=[1374,2618,4639,3713,6602,90082];
				for(var i=0 ;i<=5 ;i++){
					if(dictID == parentID[i]){
					   //删除原有款式工艺
					   var index = $("#category_" + clothingID + " tr:last").attr("index");
					   for(var j=index; j>=0; j--){
					    	if($("#stylesProc_"+j).length>0){
					    		$("#stylesProc_" + j).parent().remove();
						    }
					    }
					     
					    
						/**********************************       验证款式工艺与输入工艺是否冲突         *********
						   * 
						 * ***********************************************/
					    
					    var trCount = $("#category_" + clothingID + " tr").length;
					    var codesStr = "";
					    var tempCodeStr = "";
					    //此处默认当前带款式号行数为最后一行
					    if(trCount>1){
						    for(var x = 0;x<trCount-1;x++){
		//					    codesStr += $("#category_" + clothingID + " tr").eq(x).children().eq(0).eq(0).first().children().eq(0).attr('value')+",";
							    tempCodeStr = $("#category_" + clothingID + " tr").eq(x).find('input:first').attr('value');
							    if($("#category_" + clothingID + " tr").length > 1){
							    	codesStr +=tempCodeStr +",";
							    }
						    }
					    }
						var param = $.csControl.appendKeyValue('','dictID',data.ecode);//款式号
						param = $.csControl.appendKeyValue(param,'clothingID',clothingID);//服装分类
						param = $.csControl.appendKeyValue(param,'procInputs',codesStr);//已录入工艺
						var validateProc = $.csCore.invoke($.csCore.buildServicePath("/service/dict/validateStyleProc"),param);
						if(validateProc){
							$.csCore.alert("工艺冲突,不能读取");
						}
						if(!validateProc){
						    //添加当前款式工艺
						    var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
							param = $.csControl.appendKeyValue('','dictID',data.ecode);//款式号
							param = $.csControl.appendKeyValue(param,'lastIndex',lastIndex);//行数
							param = $.csControl.appendKeyValue(param,'clothingID',clothingID);//服装分类
						    var dicts = $.csCore.invoke($.csCore.buildServicePath("/service/dict/getstylenumbyid"),param);
						    $("#category_"+clothingID).append(dicts);
						    }
						}
					}
			}
		}
		);
	},
	removeStyle : function(dictID,clothing,index,obj){//删除固化款式
	
		//删除原有款式工艺
		var parentID=[1374,2618,4639,3713,6602,90082];
		for(var i=0 ;i<=5 ;i++){
			if(dictID == ""){//新增时
				//删除目标的行数
				var newIndex = obj.parent().attr("index");
				
				//获得款式中工艺的最后 一条的Index(需要减去第一条index才是条数)
				var lastIndex = $("#category_" + clothing + " tr:last").attr("index");
				
				if(lastIndex>0 && Number(lastIndex)>Number(newIndex)){
					//获得款式工艺中开始查条的起点(应该是newIndex的下一行)
					var smallIndex = 1;
					for(var n=lastIndex; n>1; n--){
				    	if($("#stylesProc_" +n).length>0){
				    		smallIndex = n;
					    }
				    }
				   for(var j=lastIndex; j>1; j--){
					   var nIndex = smallIndex-1;
				    	if($("#stylesProc_"+j).length >0 && nIndex == newIndex){
//				    		$("#styles_"+clothing + "_" + j).parent().remove();
				    		$("#stylesProc_" + j).parent().remove();
					    }
				    }
				}
			}else{//编辑时
				if(dictID == parentID[i]){
					 for(var j=index; j>=0; j--){
						 $("#stylesProc_" + j).parent().remove();
					 }
				}
			}
		}
		
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
		var clothing = $("input[name='clothingID']:checked").val();
		if (clothing == 1 || clothing == 5) {//1西服+西裤     5 礼服+西裤
			if (clothingID == 2000 && data.parentID == 2224) {// 西裤
				$.csCore.alert($.csCore.getValue("Orden_PrecessType_XK"));
				returnValue = false;
				return returnValue;
			}
		}
		if (clothing == 2 || clothing == 6) {//2西服+西裤+马夹    6西服+马夹
			if (clothingID == 2000 && data.parentID == 2224) {// 西裤
				$.csCore.alert($.csCore.getValue("Orden_PrecessType_XK"));
				returnValue = false;
				return returnValue;
			} else if (clothingID == 4000 && data.parentID == 4992) {// 马夹
				$.csCore.alert($.csCore.getValue("Orden_PrecessType_MJ"));
				returnValue = false;
				return returnValue;
			}
		}
		if (clothing == 4) {//4马夹+西裤
			 if (clothingID == 4000 && data.parentID == 4992) {// 马夹
				$.csCore.alert($.csCore.getValue("Orden_PrecessType_MJ"));
				returnValue = false;
				return returnValue;
			}
		}
		if (clothing == 7) {//7女西服+女西裤
			 if (clothingID == 98000 && data.parentID == 98019) {// 女西裤
				$.csCore.alert($.csCore.getValue("Orden_PrecessType_XK"));
				returnValue = false;
				return returnValue;
			}
		}
		
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
			}
			obj.attr("disabled", "true");
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
	clothingChange: function(clothingID) {//切换服装大类
		var ordenID=$("#isAlipay").val();
		if ($.csValidator.isNull(ordenID)) {
			$.csOrdenPost.loadSize(clothingID, null);
			$.csOrdenPost.generateComponent(clothingID, null);
			$.csOrdenPost.generateEmbroid(clothingID,'');
			if(clothingID == 3000){
				$("#category_3000").html("<tr index='1'><td><input type='text'  disabled='disabled' id='component_3000_3028'  value='5000' style='width:130px' class='textbox'/> <span style='color: rgb(153, 153, 153);'>长袖</span></td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			}
		}else{
			var orden = $.csOrdenCommon.getOrdenByID(ordenID);
			$.csOrdenPost.loadSize(clothingID, orden);//尺寸信息(orden切换大类保存尺寸)
			$.csOrdenPost.generateComponent(clothingID, orden);//工艺信息(orden切换大类保存工艺)
			$.csOrdenPost.generateEmbroid(clothingID,orden);
			$.csOrdenPost.loadOrdenEmbroid(orden);//订单刺绣信息  赋值
			if(orden.clothingID != 3000 && clothingID == 3000){
				$("#category_3000").html("<tr index='1'><td><input type='text'  disabled='disabled' id='component_3000_3028'  value='5000' style='width:130px' class='textbox'/> <span style='color: rgb(153, 153, 153);'>长袖</span></td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			}
		}
//		$.csOrdenPost.generateComponent(clothingID);
//		$.csOrdenPost.generateEmbroid(clothingID,'');
	},
	loadSize: function(clothingID, orden) {
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid", clothingID));
		$.csCore.loadPage("container_size", "../size/size.jsp",
		function() {
			$.csSize.init(orden, true);
		});
	},
	loadOrdenEmbroid: function(orden){//订单刺绣信息  赋值
		if(orden.ordenDetails != null){
			for (var n=0; n<orden.ordenDetails.length;n++){
				if(orden.ordenDetails[n].emberoidery != null){
					for(var m=0; m<orden.ordenDetails[n].emberoidery.length;m++){
						if(orden.ordenDetails[n].emberoidery[m].location != null){
							$("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Position_"+m).val(orden.ordenDetails[n].emberoidery[m].location.ID);
						}
						if(orden.ordenDetails[n].emberoidery[m].color != null){
							$("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Color_"+m).val(orden.ordenDetails[n].emberoidery[m].color.ID);
						}
						if(orden.ordenDetails[n].emberoidery[m].font != null){
							$("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Font_"+m).val(orden.ordenDetails[n].emberoidery[m].font.ID);
						}
						 $(".category_textbox_"+orden.ordenDetails[n].singleClothingID+"_Content_"+m).val(orden.ordenDetails[n].emberoidery[m].content);
						 if(orden.ordenDetails[n].singleClothingID == 3000 || orden.ordenDetails[n].singleClothingID == 5000){
							 if(orden.ordenDetails[n].emberoidery[m].size != null){
								 $("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Size_"+m).val(orden.ordenDetails[n].emberoidery[m].size.ID);
							 }
						}
						if(orden.ordenDetails[n].singleClothingID == 5000){
							//不许录绣字大小的配件刺绣位置，特定这几个
							var arr = [82336,83028,83029,83030,83031,83032,83033];
							$.each(arr, function(i){
								if($("#category_label_5000_Position_"+m).val() == arr[i]){
									$("#category_label_5000_Size_"+m).attr("disabled",true);
								}
							});
						}
					}
				}
			}
		}
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
	generateEmbroid: function(clothingID,orden) {
		var dict = $.csCore.getDictByID(clothingID);
		var arr = new Array();
		arr = dict.extension.split(",");
		$("#container_embroid").html("");
		for (var i = 0; i < arr.length; i++) {
			var dt = $.csCore.getDictByID(arr[i]);
			dom = "<div class='list_search'>" + dt.name +"<a onclick='$.csOrdenPost.addEmbroidRow(" + arr[i] + ")'>" +$("#addText").val()+ "</a><input id='clothing"+arr[i]+"' style=' display: none;'/></div>" + "<table id='category_embroid_" + arr[i] + "' class='list_result'>" + $.csOrdenPost.getEmbroidRowHTML(arr[i],0) + "</table>";
			$("#container_embroid").append(dom);
			if(orden != '' && orden.ordenDetails != null){
				var num =0;
				for (var n=0; n<orden.ordenDetails.length;n++){
					if(orden.ordenDetails[n].singleClothingID == arr[i]){
						if(orden.ordenDetails[n].emberoidery != null && orden.ordenDetails[n].emberoidery.length >0){
							num++;
							for(var m=0; m<orden.ordenDetails[n].emberoidery.length;m++){
								if(m>0){
									$.csOrdenPost.addEmbroidRow(arr[i]);
								}
								$.csOrdenPost.fillEmbroidComposition(arr[i],m);
							}
						}else{
							num++;
							$.csOrdenPost.fillEmbroidComposition(arr[i],0);
						}
					}
				}
				if(num==0){
					$.csOrdenPost.fillEmbroidComposition(arr[i],0);
				}
			}else{
				$.csOrdenPost.fillEmbroidComposition(arr[i],0);
			}
//			$.csOrdenPost.fillEmbroidComposition(arr[i],0);
		}
	},
	addEmbroidRow: function(clothingID) {
		var lastIndex = $("#category_embroid_" + clothingID + " tr:last").attr("index");
		if (lastIndex == undefined) {
			lastIndex = 0;
		}else{
			lastIndex = parseInt(lastIndex)+1;
		}
		$("#category_embroid_" + clothingID).append($.csOrdenPost.getEmbroidRowHTML(clothingID, lastIndex));
		$.csOrdenPost.fillEmbroidComposition(clothingID, lastIndex);
		$.csOrdenPost.copyEmbroidComposition(clothingID, lastIndex);
		$("#clothing"+clothingID).val(lastIndex);
	},
	getEmbroidRowHTML: function(clothingID,index) {
		var size = "";
		var disabled ="";
//		if(index>0){
//			disabled ="disabled='disabled'";
//		}
		if (clothingID == 3000 || clothingID == 5000) {
			size = "<td ><span/><select id='category_label_" + clothingID + "_Size_"+index+"' style='width: 120px'/></td>";
		}
		var embroid = "<tr align='center' index='" + index + "'>" + "<td><span/><select id='category_label_" + clothingID + "_Position_"+index+"' style='width: 120px' onchange=$.csOrdenPost.changePosition('"+clothingID+"','"+index+"')/></td>" + "<td><span/><select id='category_label_" + clothingID + "_Color_"+index+"' style='width: 120px'/></td>" + "<td><span/><select id='category_label_" + clothingID + "_Font_"+index+"' style='width: 120px'/></td>" + "<td><span/><input type='text' id='category_textbox_" + clothingID + "_Content_"+index+"' style='width:120px;background-color: #131313; border: 1px solid #626061; color: #EAE9E9;height: 20px;line-height: 20px;' class='category_textbox_" + clothingID + "_Content_"+index+"'/></td>" + size +"<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>";
		return embroid;
	},
	fillEmbroidComposition: function(clothingID,index) {
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
//					$.csControl.fillOptions("category_label_" + clothingID + "_Position_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
					$.csOrdenPost.fillOptions("category_label_" + clothingID + "_Position_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
			} else {
				if (j == 3) {
					$("#category_label_" + clothingID + "_Position_"+index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
//					$.csControl.fillOptions("category_label_" + clothingID + "_Position_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
					$.csOrdenPost.fillOptions("category_label_" + clothingID + "_Position_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
				if (clothingID == 5000 && j == 4){
					$("#category_label_" + clothingID + "_Size_"+index).prev().html(dictsSeries[j].name + ":");
					var dicts = $.csCore.getDictsByParent(1, dictsSeries[j].ID);
					$.csControl.fillOptions("category_label_" + clothingID + "_Size_"+index, dicts, "CXID", "name", $("#pleaseSelect").val() + dictsSeries[j].name);
				}
			}
		}
	},
	copyEmbroidComposition : function(clothingID,index){
		$("#category_label_" + clothingID + "_Color_"+index).val($("#category_label_" + clothingID + "_Color_0").val());
		$("#category_label_" + clothingID + "_Font_"+index).val($("#category_label_" + clothingID + "_Font_0").val());
		if(clothingID == 3000 || clothingID == 5000){
			$("#category_label_" + clothingID + "_Size_"+index).val($("#category_label_" + clothingID + "_Size_0").val());
		}
		
	},
	setEmbroidValue : function(clothingID,type){
		var index = $("#clothing"+clothingID).val();
		for(var i=1;i<=index;i++){
			$("#category_label_" + clothingID + "_"+type+"_"+i).val($("#category_label_" + clothingID + "_"+type+"_0").val());
		}
	},
	changePosition : function(clothingID,index){
		var n=0;
		if(clothingID == 5000){
			//不许录绣字大小的配件刺绣位置，特定这几个
			var arr = [82336,83028,83029,83030,83031,83032,83033];
			$.each(arr, function(i){
				if($("#category_label_5000_Position_"+index).val() == arr[i]){
					$("#category_label_5000_Size_"+index).val(80978);
					$("#category_label_5000_Size_"+index).attr("disabled",true);
					n++;
				}
			});
		}
		if(clothingID == 5000 && n==0){
			$("#category_label_5000_Size_"+index).attr("disabled",false);
		}
	},
	fillOptions: function (select, datas, fieldValue, fieldText, firstHint) {
        select = $('#' + select).empty();
        if (firstHint != null && firstHint != "") {
            var optionFirst = "<option title='" + firstHint + "' value='-1'>" + firstHint + "</option>";
            select.append(optionFirst);
        };
        $.each(datas, function (i, data) {
    		if(data.ecode != null){
        		 var actionValue = "data.ID";
                 var actionText = "data." + fieldText;
                 var textTength = "data.memo";
                 var option = "<option title='" + eval(actionText) + "' value='" + eval(actionValue) + "' memo='"+eval(textTength)+"'>" + eval(actionText) + "</option>";
                 select.append(option);
    		}
        });
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
//			$('#fabric_result').html(inventory);
			if ($.csValidator.isNull(inventory) || inventory <= 0) {
				$('#autoContainer').html("<label style='color:red;'>"+$.csCore.getValue("Orden_FabricArrivedControl") + "</label><br />");
				$.csControl.fillRadios("autoContainer", $.csCore.getDicts(DICT_CATEGORY_ORDEN_AUTO), "autoID", "ID", "name");
			}
		}
	},
	getFabricInventory: function(code) {
		return $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabricinventory'), $.csControl.appendKeyValue("", "code", code));
	},
	setTempComponentid : function(component){//衬衣长短袖显示尺寸
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempcomponentid'), $.csControl.appendKeyValue("", "id",component));
	},
	
	/**
	 * 保存订单
	 * @returns {Boolean}
	 */
	save: function() {
		//非保存状态，不能提交订单
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
		var data = $.csCore.invoke($.csCore.buildServicePath("/service/orden/submitorden?type=1"), $.csControl.getFormData("form"));
		if(data.indexOf('ordenID') >= 0){
			var idAndErr = data.split("&");
			data = idAndErr[1];
		}
		$.csOrdenPost.saveOrSubmit(data,ordenID);

	},
	submitOrden : function() {
		$("#submitWait").hide();
		//非保存状态，不能提交订单
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
		
		/*if($('#fabricCode').val().substr(0, 3) != "MDT" && $('#fabricCode').val().substr(0, 3) != "SDT" ){
				var inventory = $.csOrdenPost.getFabricInventory($('#fabricCode').val());
				if ($.csValidator.isNull(inventory) || inventory <= 0) {
//					$.csCore.alert("面料不足！");
					$.csCore.alert($.csCore.getValue("Error_Ml"));
					return false;
				}
			}*/
		
		var ordenID = $("#ordenID").val();
		var isAlipay = $("#isPay").val();
		var member = $.csCore.getCurrentMember();
		if(member.statusID == 10043){
			$.csCore.alert($.csCore.getValue("CHECK_USERNO"));
			return false;
		}
		
		if((member.companyID == 1002 || member.companyID == 1003) && member.userStatus == 10050){
			$("#pay_srbj").hide();
			$("#shade").show();//显示遮罩层
			setTimeout(
				function(){
					var data = $.csCore.invoke(
	        		$.csCore.buildServicePath("/member/submitorden"), $.csControl.getFormData("form"));
					if(data.indexOf('ordenID') >= 0){
						var idAndErr = data.split("&");
						data = idAndErr[1];
					}
					$("#shade").hide();//隐藏遮罩层
					if (!$.csValidator.isNull(data)) {
			            if (data.toUpperCase() == "OK") {
			            	var payToCCB = $.csCore.invoke($.csCore.buildServicePath('/member/ordenpaytosr'));
			            	$("#alipay_submit").html(payToCCB);
//			            	$.csCore.invoke($.csCore.buildServicePath('/member/sendordendetail'));
			                $("#form").resetForm();
							$.csOrdenList.list(0);
			                $.csCore.close();
			            }else {
			            	$("#submitWait").show();
			            	$.csCore.alert(data);
			            }
			        }
			    },0.1);//延迟0.1毫秒提交(显示遮罩层)
		}else if(member.payTypeID == DICT_MEMBER_PAYTYPE_ONLINE && isAlipay != DICT_YES){//在线支付+判断是否已支付
			$("#pay_bj").show();
		}else{//非在线支付 或 在线支付已支付但提交失败
			$("#shade").show();//显示遮罩层
			
			setTimeout(
					function(){
						var data = $.csCore.invoke(
		        		$.csCore.buildServicePath("/service/orden/submitorden"), $.csControl.getFormData("form"));
						if(data.indexOf('ordenID') >= 0){
							var idAndErr = data.split("&");
							data = idAndErr[1];
						}
						$.csOrdenPost.saveOrSubmit(data,ordenID);
				    },0.1);//延迟0.1毫秒提交(显示遮罩层)
			
//		        var data = $.csCore.invoke(
//		        		$.csCore.buildServicePath("/service/orden/submitorden"), $.csControl.getFormData("form"));
//		        $.csOrdenPost.saveOrSubmit(data,ordenID);
		}
	},
	saveOrSubmit : function(data,ordenID){
        $("#shade").hide();//隐藏遮罩层
		if (!$.csValidator.isNull(data)) {
            if (data.toUpperCase() == "OK") {
                $("#form").resetForm();
                if (!$.csValidator.isNull(ordenID) && ordenID.length == 36) {
					$.csCustomerPost.listOrdens();
				} else {
					$.csOrdenList.list(0);
				}
                $.csCore.close();
            }else {
            	if("" == ordenID){//复制订单、快速下单
            		//面料价格未维护
            		if(data == $.csCore.getValue("Bl_Error_189") || data == $.csCore.getValue("Bl_Error_190")){
            			$("#submitWait").show();
    	            	$.csCore.alert(data);
            		}else{
            			$.csOrdenList.list(0);
    	            	$.csCore.close();
    	            	$.csCore.alert(data);
            		}
            	}else{//编辑
            		$("#submitWait").show();
            		$.csCore.alert(data);
            	}
            }
        }
	},
	ordenPay : function(type){
		if(type == 1){//支付宝
			$("#pay_bj").hide();
//			var param =  $.csControl.getFormData("form");
//			param = $.csControl.appendKeyValue(param,"type","1");
//			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
//			$("#alipay_submit").html(data);
			var param =  $.csControl.getFormData("form");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/alipay/submitorden'), param);
			if(data.indexOf('ordenID') >= 0){
				var idAndErr = data.split("&");
				data = idAndErr[1];
			}
			if(data.substr(0,2) == "OK"){
				$("#alipay_submit").html(data.substr(2,data.length-2));
			}else{
				$.csCore.alert(data);
			}
		}else if(type == 2){//paypail
			$("#pay_bj").hide();
			var param =  $.csControl.getFormData("form");
			param = $.csControl.appendKeyValue(param,"type","2");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
			$("#alipay_submit").html(data);
		}else{
			$("#pay_bj").hide();
		}
	},
	checkOrdenStatus : function(id){
		if(id != ""){
			var orden = $.csOrdenCommon.getOrdenByID(id);
			if(orden.statusID != 10035){//非保存状态，不能提交订单
	            $.csOrdenList.list(0);
	            $.csCore.close();
	            $.csCore.alert($.csCore.getValue("Bl_Error_18"));
			}
		}
	},
	init: function(id, isPost) {
		$("#form").resetForm();
		$.csOrdenPost.bindEvent();
		$.csOrdenPost.autoCompleteFabric();
		var clothingID = $.csControl.getRadioValue('clothingID');
		if ($.csValidator.isNull(id)) {
			$.csOrdenPost.generateClothing('','');
			$.csCore.loadPage("container_customer", "../customer/customer.jsp",
			function() {
				$.csCustomer.init();
			});
			$.csOrdenPost.loadSize(clothingID, null);
		} else {
			var orden = $.csOrdenCommon.getOrdenByID(id);
			if(orden.statusID != 10035 && !isPost){//非保存状态，不能提交订单
                $.csOrdenList.list(0);
                $.csCore.close();
                $.csCore.alert($.csCore.getValue("Bl_Error_18"));
			}
			$.csOrdenPost.generateClothing(orden.clothingID,orden);
			if ($.csValidator.isNull(orden.customer)) {
				$(".lblCustomer").hide();
			} else {
				$(".lblCustomer").show();
				$.csCore.loadPage("container_customer", "../customer/customer.jsp",
				function() {
					orden.customer.oldName=orden.customer.name;
					//客户单号
					orden.customer.customerOrdenID = orden.userordeNo;
					$.csCustomer.init(orden.customer);
				});
			}
			$.csOrdenPost.loadSize(orden.clothingID, orden);
			$.updateWithJSON(orden);
			if (orden.clothingID == 3000 && !$.csValidator.isNull(orden.components)) {
				var components = orden.components.split(",");
				$.each(components,
				function(i, component) {
					if(component == 3029) {
						$.csOrdenPost.setTempComponentid("3029");
					}else if(component == 3028) {
						$.csOrdenPost.setTempComponentid("3028");
					}
				});
			}
			if (isPost) {
				$('#ordenID').val('');
				$.csCore.getValue("Orden_Redo",null,"#form h1");
			} else {
				$.csCore.getValue("Common_Edit","Orden_Moduler","#form h1");
			}
			/*if (!$.csValidator.isNull(orden.components)) {
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
			}*/
//			alert(JSON.stringify(orden.ordenDetails));
			/*for (var n=0; n<orden.ordenDetails.length;n++){
				if(orden.ordenDetails[n].emberoidery != null){
					for(var m=0; m<orden.ordenDetails[n].emberoidery.length;m++){
						if(orden.ordenDetails[n].emberoidery[m].location != null){
							$("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Position_"+m).val(orden.ordenDetails[n].emberoidery[m].location.ID);
						}
						if(orden.ordenDetails[n].emberoidery[m].color != null){
							$("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Color_"+m).val(orden.ordenDetails[n].emberoidery[m].color.ID);
						}
						if(orden.ordenDetails[n].emberoidery[m].font != null){
							$("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Font_"+m).val(orden.ordenDetails[n].emberoidery[m].font.ID);
						}
						 $(".category_textbox_"+orden.ordenDetails[n].singleClothingID+"_Content_"+m).val(orden.ordenDetails[n].emberoidery[m].content);
						 if(orden.ordenDetails[n].singleClothingID == 3000){
							 if(orden.ordenDetails[n].emberoidery[m].size != null){
								 $("#category_label_"+orden.ordenDetails[n].singleClothingID+"_Size_"+m).val(orden.ordenDetails[n].emberoidery[m].size.ID);
							 }
						}
					}
				}
			}*/

			if (!$.csValidator.isNull(orden.sizeBodyTypeValues)) {
				// 选中订单保存的特体信息
				var bodyTypes = orden.sizeBodyTypeValues.split(",");
				$.each(bodyTypes,
				function(i, bodyType) {
					$.csControl.initSingleCheck(bodyType);
				});
			}
			$.csOrdenPost.loadOrdenProcess(orden);
			//款式
			if (!$.csValidator.isNull(orden.styleID) && orden.sizeCategoryID == DICT_SIZE_CATEGORY_NAKED && 
					(orden.clothingID == DICT_CLOTHING_SUIT2PCS || orden.clothingID == DICT_CLOTHING_ShangYi || orden.clothingID == DICT_CLOTHING_SUIT3PCS || orden.clothingID == DICT_CLOTHING_DaYi)) {
				$.csControl.initSingleCheck(orden.styleID);
			}
			$.csOrdenPost.loadOrdenEmbroid(orden);//订单刺绣信息  赋值

			$("#isAlipay").val(orden.ordenID);
			$("#isPay").val(orden.isAlipay);
		}
	},
	clearNoNum:function(obj) {  
	    obj.value = obj.value.replace(/[^\d.]/g, "");  
	    obj.value = obj.value.replace(/^\./g, "");  
	    obj.value = obj.value.replace(/\.{2,}/g, ".");  
	    obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");  
	}
};