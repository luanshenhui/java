$.csProcess = {
	inputProcess : function(clothingID) {
		// 工艺自动补全
		var xiLie ="";//配件工艺要符合所属系列
		if(clothingID == 5000){
			$("input[id^='component_5000_']").each(function(i) {
				if(i == 0){
					xiLie = $(this).attr("id").substr($(this).attr("id").lastIndexOf("_") + 1);
				}
			});
		}
		var data=sessionStorage.getItem(clothingID);
		if (data==null) {
			var data = $.csCore.invoke($.csCore.buildServicePath('/servlet/GetProductProcess?productId=' + clothingID+'&strType='+xiLie), '');
			sessionStorage.setItem(clothingID,JSON.stringify(data));
		}else{
			data=JSON.parse(data);
		}
		$.each(data, function(i, list) {
			 var index = $("#category_" + i + " tr:last").attr("index");
			 if(index == undefined){
				 index = 1;
			 }
			$.csProcess.bindAutoCompleteData(list, i, index);
		});
	},
	bindAutoCompleteData : function(list, id, index) {
		// 根据id绑定data
		$("#text_" + id + "_" + index).unautocomplete();
		$("#text_" + id + "_" + index).autocomplete(list, {
			minChars : 1, // 自动完成激活之前填入的最小字符
			width : 450, // 提示的宽度，溢出隐藏
			scrollHeight : 300, // 提示的高度，溢出显示滚动条
			selectFirst : true,// 默认选中第一个
			Default : true,// 当结果集大于默认高度时是否使用卷轴显示
			dataType : "json",
			formatItem : function(item) {
				return item.code + "(" + item.name + ")";
			},
			formatResult : function(row) {
				return row.code;
			},
		}).result(function(event, tempData) {
			if ($.csProcess.checkProcess(id, index, tempData)) {
				// 代码没有冲突
				$.csProcess.businessProcess(list, id, tempData, ++index, $(this));
			} else {
				// 代码有冲突
				$(this).next().html("");
				$(this).val("");
			}
		});
	},
	checkProcess : function(clothingID, index, tempData) {
		var returnValue = true;
		if (returnValue) {
			// 是否选择同一种工艺
			$("input[id^='doNot_']").each(function() {
				if ($(this).attr("id") == "doNot_" + tempData.id) {// 客户指定工艺
					$.csCore.alert($.csCore.getValue("Orden_Precess_Error"));
					returnValue = false;
					return returnValue;
				}
			});
		}
		if (returnValue) {
			// 是否选择同一种工艺
			$("input[id^='component_']").each(function() {
				if ($(this).attr("id") == "component_" + clothingID + "_" + tempData.id) {
					$.csCore.alert($.csCore.getValue("Orden_Precess_Error"));
					returnValue = false;
					return returnValue;
				}
			});
		}

		if (returnValue) {
			// 配件必须先录系列
			if (clothingID == 5000 && index == 1 && tempData.parentId != 5023) {
				$.csCore.alert($.csCore.getValue("Orden_CheckXiLei"));
				returnValue = false;
				return returnValue;
			}
		}

		if (returnValue) {
			// 判断工艺类型
			var clothing = $("input[name='clothingID']:checked").val();
			if (clothing == 1 || clothing == 5) {//1西服+西裤     5 礼服+西裤
				if (clothingID == 2000 && tempData.parentId == 2224) {// 西裤
					$.csCore.alert($.csCore.getValue("Orden_PrecessType_XK"));
					returnValue = false;
					return returnValue;
				}
			}
			if (clothing == 2 || clothing == 6) {//2西服+西裤+马夹    6西服+马夹
				if (clothingID == 2000 && tempData.parentId == 2224) {// 西裤
					$.csCore.alert($.csCore.getValue("Orden_PrecessType_XK"));
					returnValue = false;
					return returnValue;
				} else if (clothingID == 4000 && tempData.parentId == 4992) {// 马夹
					$.csCore.alert($.csCore.getValue("Orden_PrecessType_MJ"));
					returnValue = false;
					return returnValue;
				}
			}
			if (clothing == 4) {//4马夹+西裤
				 if (clothingID == 4000 && tempData.parentId == 4992) {// 马夹
					$.csCore.alert($.csCore.getValue("Orden_PrecessType_MJ"));
					returnValue = false;
					return returnValue;
				}
			}
			if (clothing == 7) {//7女西服+女西裤
				 if (clothingID == 98000 && tempData.parentId == 98019) {// 女西裤
					$.csCore.alert($.csCore.getValue("Orden_PrecessType_XK"));
					returnValue = false;
					return returnValue;
				}
			}
		}

		if (returnValue) {
			// 判断 单选和多选的工艺冲突
			var ids = "";
			$("input[id^='component_']").each(function() {
				var statusID=$(this).attr("status-id");
				var parentID=$(this).attr("parent-id");
				var thisID = $(this).attr("id").substr($(this).attr("id").lastIndexOf("_") + 1);
				ids += thisID + ",";
				if (parentID == tempData.parentId) {
					if (tempData.statusID==10001) {
						$.csCore.alert($.csCore.getValue("Orden_Precess_CheckTwo"));
						returnValue = false;
						return returnValue;
					}else if(tempData.statusID!=10008){
						var parentDict = $.csCore.getDictByID(tempData.parentId);
						if (parentDict.isSingleCheck == 10050) {
							$.csCore.alert($.csCore.getValue("Orden_Precess_CheckTwo"));
							returnValue = false;
							return returnValue;
						}else{
							// 同一上级可多选判断是否工艺冲突
							var url = $.csCore.buildServicePath("/service/orden/getdisabledbyother?ids=" + ids + "&id=" + tempData.id);
							var result = $.csCore.invoke(url);
							if (result == true) {
								$.csCore.alert($.csCore.getValue("Orden_Precess_Conflict"));
								result = false;
								return result;
							}
						}
					}
				}
			});
		}
		return returnValue;
	},
	businessProcess : function(list, clothingID, tempData, index, obj) {
		if (tempData.id == '3029') {
			$.csOrdenPost.setTempComponentid("3029");
		} else if (tempData.id == '3028') {
			$.csOrdenPost.setTempComponentid("3028");
		}
		obj.attr("disabled", "true");
		obj.attr("id", "component_" + clothingID + "_" + tempData.id);
		$("#component_" + clothingID + "_" + tempData.id).attr("parent-id",tempData.parentId);
		$("#component_" + clothingID + "_" + tempData.id).attr("status-id",tempData.statusID);
		
		obj.next().html("&nbsp;&nbsp;" + tempData.name);
		if (tempData.isDefault == 10050)
			obj.next().css("color", "#999999");
		obj.parent().parent().append("<td onclick='$(this).parent().remove()'style='width:30px'><a class='remove'></a></td>");
		obj.parent().parent().parent().append("<tr index='" + index + "'><td><input type='text' id='text_" + clothingID + "_" + index + "' style='width:80px' class='textbox'/><span/></td></tr>");
		$.csProcess.bindAutoCompleteData(list, clothingID, index);
		$("#text_" + clothingID + "_" + index).focus();

		var lowerData = $.csCore.invoke($.csCore.buildServicePath('/servlet/GetDictVOByParentId?parentID=' + tempData.id), '');
		if (lowerData.length > 0&&lowerData[0].statusID==10001) {
			obj.next().append("<input type='text' id='component_textbox_" + tempData.id + "' style='width:80px' class='textbox'/>");
			$.csProcess.bindAutoLowerCompleteData(lowerData,"#component_textbox_" + tempData.id,clothingID);
			obj.attr("id", "doNot_" + tempData.id);
			$("#component_textbox_" + tempData.id).focus();
		} else {
			if (!lowerData.length > 0 && tempData.statusID == DICT_CUSTOMER_SPECIFIED) {
				var doms = "";
				if (PRICE.indexOf(tempData.id) > -1) { // 价格,只允许输入数字和小数点
					if ($.browser.mozilla) {
						doms = " onkeypress= 'if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return   false;} '";
					} else {
						doms = " onkeypress= 'if((event.keyCode <48||event.keyCode> 57) && event.keyCode!=46 && event.keyCode!=8){return   false;} '";
					}
				}
				obj.next().append("<input type='text' id='category_textbox_" + tempData.id + "' style='width:80px' class='textbox' " + doms + "/>");
				$("#category_textbox_" + tempData.id).focus();
			}
		}
	},
	bindAutoLowerCompleteData:function(lowerData,lowerId,clothingID){
		$(lowerId).unautocomplete();
		$(lowerId).autocomplete(lowerData, {
			minChars : 1, // 自动完成激活之前填入的最小字符
			width : 150, // 提示的宽度，溢出隐藏
			scrollHeight : 300, // 提示的高度，溢出显示滚动条
			selectFirst : true,// 默认选中第一个
			Default : true,// 当结果集大于默认高度时是否使用卷轴显示
			dataType : "json",
			formatItem : function(item) {
				return item.code + "(" + item.name + ")";
			},
			formatResult : function(row) {
				return row.code;
			},
		}).result(function(event, tempData) {
			if (!$.csValidator.isNull(tempData)) {
				$(this).attr("id", "component_" + tempData.id);
				//获取款式号内容
				var parentID=[1374,2618,4639,3713,6602,90082,95031,98023];
				for(var i=0 ;i<=parentID.length ;i++){
					if(tempData.parentId == parentID[i]){
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
					   
//					   var hasEmpty = true;
//					   while(hasEmpty){
//						   var lineCount = $("#category_" + clothingID + " tr").length;
//						    for(var m=0 ;m<lineCount ;m++){
//							var trDom = $("#category_" + clothingID + " tr").eq(m);
//							if('' == trDom.find('td :first').val() ){
//								trDom.remove();
//							}
//						    }
//						    var lineCount2 = $("#category_" + clothingID + " tr").length;
//						    if(lineCount == lineCount2){
//							hasEmpty = false;
//						    }
//						}
					    
					    var trCount = $("#category_" + clothingID + " tr").length;
					    var codesStr = "";
					    var tempCodeStr = "";
					    //此处默认当前带款式号行数为最后一行
					    if(trCount>1){
						    for(var x = 0;x<trCount-1;x++){
							    tempCodeStr = $("#category_" + clothingID + " tr").eq(x).find('input:first').attr('value');
							    if($("#category_" + clothingID + " tr").length > 1){
								codesStr +=tempCodeStr +",";
							    }
						    }
					    }
						var param = $.csControl.appendKeyValue('','dictID',tempData.code);//款式号
						param = $.csControl.appendKeyValue(param,'clothingID',clothingID);//服装分类
						param = $.csControl.appendKeyValue(param,'procInputs',codesStr);//已录入工艺
						var validateProc = $.csCore.invoke($.csCore.buildServicePath("/service/dict/validateStyleProc"),param);
						if(validateProc){
							$.csCore.alert("工艺冲突,不能读取");
						}
						if(!validateProc){
						    //添加当前款式工艺
						    var lastIndex = $("#category_" + clothingID + " tr:last").attr("index");
							param = $.csControl.appendKeyValue('','dictID',tempData.code);//款式号
							param = $.csControl.appendKeyValue(param,'lastIndex',lastIndex);//行数
							param = $.csControl.appendKeyValue(param,'clothingID',clothingID);//服装分类
						    var dicts = $.csCore.invoke($.csCore.buildServicePath("/service/dict/getstylenumbyid"),param);
						    $(this).parent().parent().parent().after(dicts);
						   }
						}
					}
			}
		});
	}
}