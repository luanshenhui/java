jQuery.csOrdenPost={
	bindEvent:function (){
		$("#btnSaveOrden").click($.csOrdenPost.save);
		$("#btnCancelOrden").click($.csCore.close);
		$("#fabricCode").blur($.csOrdenPost.fillOrdenAuto);
	},
	validate:function (){
		
		if($.csValidator.checkNull("fabricCode",$.csCore.getValue("Common_Required","Fabric_Moduler"))){
			return false;
		}
		return true;
	},
	buildTextID:function(id){
		return "category_textbox_"+ id;
	},
	generateClothing:function (){
		var clothing = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		var dom="<ul>";
		for(var i=0;i<clothing.length;i++){
			dom+="<li><label><input type='radio' name='clothingID' value='"+clothing[i].ID+"' onclick='$.csOrdenPost.clothingChange("+clothing[i].ID+");'/> "+clothing[i].name+"</label></li>";
		}
		dom+="</ul>";
		$("#container_clothings").html(dom);
		$("input[value='"+clothing[0].ID+"']").attr("checked","checked");
	},
	clothingChange:function(clothingID){
		$.csOrdenPost.generateComponent(clothingID);
		$.csOrdenPost.loadSize(clothingID);
	},
	generateComponent:function(clothingID){
		
		var clothing = $.csCore.getDictByID(clothingID);
		var singleClothings = clothing.extension.split(',');
		$("#container_component").html("");
		var componentCategorys = new Array();
		for(var i=0 ;i<singleClothings.length ;i++){
			var singleClothing = $.csCore.getDictByID(singleClothings[i]);
			var param = $.csControl.appendKeyValue("","singleclothingid",singleClothing.ID);
			
			var url = $.csCore.buildServicePath('/service/orden/getcomponentcategory');
			var categorys = $.csCore.invoke(url,param);

			$.each(categorys,function(i,item){
				componentCategorys.push(item);
			});
		}
		var dom = $.csOrdenPost.generateComponentUL(componentCategorys,0);
		$("#container_component").html(dom);
		$(".topnav").accordion();
	},
	getCategoryByParent:function(componentCategorys, parentID){
		var result =new Array();
		$.each(componentCategorys,function(i,item){
			if(item.pId == parentID){
				result.push(item);
			}
		});
		return result;
	},
	generateComponentUL:function(componentCategorys, parentID){
		var result = $.csOrdenPost.getCategoryByParent(componentCategorys, parentID);
		if(result.length>0){
			var ul = "<ul id='"+parentID+"'>";
			if(parentID == 0){
				ul = "<ul id='"+parentID+"' class='topnav'>";
			}
			$.each(result,function(i,item){
				var li= "<li>";
				var aClass = "";
				var a = "<a href='#' *class*>" + item.name + "</a>";
				if(item.code.length==12){
					li= "<li class='active'>";
				}
				li += a;
				var ulChild = $.csOrdenPost.generateComponentUL(componentCategorys,item.id);
				if(!$.csValidator.isNull(ulChild)){
					li += ulChild;
				}
				else{
					var param = $.csControl.appendKeyValue("","categoryid",item.id);
					var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getcomponentbycategoryid'),param);
					if(!$.csValidator.isNull(datas)){
						aClass=" class = 'label' ";
						li += "<span class='value'>" + datas + "</span>";
					}
				}
				li = li.replace('*class*',aClass);
				li += "</li>";
				ul += li;
			});
			return ul+"</ul>";
		}
		return "";
	},
	change:function(category){
		var selected = $('#' + category).val();
		//var first = $('#' + category + " option:first").val(); 
		var defaultValue = $('#' + category + " .yes").val(); 
		if(defaultValue != selected){
			$('#' + category).css("background","#265a06");
		}else{
			$('#' + category).css("background","#000");
		}
		var beforechange  = $('#' + category).attr("beforechange");
		if(!$.csValidator.isNull(beforechange)){
			$.csOrdenPost.changeAllow(beforechange,selected);
			$.csOrdenPost.changeDisable(beforechange,selected);
		}
		$('#' + category).attr("beforechange",$('#' + category).val());
	},
	changeDisable:function(beforechange,selected){
		var disableByMe = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getaffecteddisablebyme'),$.csControl.appendKeyValue("","id",beforechange));
		if(!$.csValidator.isNull(disableByMe)){
			$.each(disableByMe,function(i,dict){
				//加上
				if($.csValidator.isNull(dict.statusID)){
					//是分类
					var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getcomponentbycategoryid'),$.csControl.appendKeyValue("","categoryid",dict.ID));
					if(!csValidator.isNull(datas)){
						var li = "<li><a href='#' class='label'>"+dict.name+"</a><span class='value'>" + datas + "</span><li>";
						$('#' + dict.parentID).append(li);
					}
				}else{
					$("#category_label_" + dict.parentID).append("<option value='"+dict.ID+"'>"+dict.name +"["+ dict.ecode + "]</option");
				}
			});
			disableByMe = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getaffecteddisablebyme'),$.csControl.appendKeyValue("","id",selected));
			
			//删除
			$.each(disableByMe,function(i,dict){
				if($.csValidator.isNull(dict.statusID)){
					//是分类
					$("#category_label_" + dict.ID).parent().parent().remove();
				}else{
					$("select option[value='"+dict.ID+"']").remove();
				}
			});
		}
		
	},
	changeAllow:function(beforechange,selected){
		//删除与beforechange相关的，加上change后的相关的
		var affectedByMe = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getaffectedallowbyme'),$.csControl.appendKeyValue("","id",beforechange));
		if(!$.csValidator.isNull(affectedByMe)){
			$.each(affectedByMe,function(i,dict){
				$("select option[value='"+dict.ID+"']").remove();
			});

			affectedByMe = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getaffectedallowbyme'),$.csControl.appendKeyValue("","id",selected));
			//取得所有下拉框被选中的值
			var allSelected = $("select").find("option:selected");

			$.each(affectedByMe,function(i,dict){
				var affectedAllows = dict.affectedAllow.split("|");
				$.each(affectedAllows,function(m,affectedAllow){
					var affectedParts = affectedAllow.split(",");
					var b = true;
					$.each(affectedParts,function(j,part){
						if(!$.csOrdenPost.partIn(allSelected,part)){
							b = false;
						}
					});
					if(b){
						$("#category_label_" + dict.parentID).append("<option value='"+dict.ID+"'>"+dict.name +"["+ dict.ecode + "]</option");
					}
				});
			});
		}
	},
	partIn:function(allSelected,part){
		var b = false;
		$.each(allSelected,function(i,item){
			if(item.value == part){
				b = true;
				return false;
			}
		});
		return b;
	},
	initFilterComponent:function(){
		
	},
	loadSize:function(clothingID,orden){
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'),$.csControl.appendKeyValue("","clothingid",clothingID));
		$.csCore.loadPage("container_size","../size/size.htm",function(){$.csSize.init(orden);});
	},
	autoCompleteFabric:function (){
		var url = $.csCore.buildServicePath('/service/fabric/getfabricbykeyword');
			$("#fabricCode").autocomplete(url, {
			multiple : false,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ID,
						result : row.code
					};
				});
			},
			formatItem : function(item) {
				return item.code + "(" + item.categoryName + ")"; 
			}
		}).result(function(e, data) {
			$('#autoContainer').html('');
			var inventory = $.csOrdenPost.getFabricInventory(data.code);
			var hint = $.csCore.getValue('Fabric_Inventory') + ":" + inventory;
			$('#fabric_result').html(hint);
		});
	},
	fillOrdenAuto:function (){
		$('#fabric_result').html('');
		$('#autoContainer').html('');
		if(!$.csValidator.isNull($('#fabricCode').val())){
			var inventory = $.csOrdenPost.getFabricInventory($('#fabricCode').val());
			if($.csValidator.isNull(inventory) || inventory <=0 ){
				$('#autoContainer').html($.csCore.getValue("Orden_FabricArrivedControl") + "<br />");
				$.csControl.fillRadios("autoContainer",$.csCore.getDicts(DICT_CATEGORY_ORDEN_AUTO), "autoID","ID" , "name");
			}
		}
	},
	getFabricInventory:function(code){
		return $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabricinventory'),$.csControl.appendKeyValue("","code",code));
	},
	save:function (){
		if(!$(".lblCustomer").is(":hidden")) {
			if($.csCustomer.validate() == false){
				return false;
			}
		}
		if($.csOrdenPost.validate() == false){
			return false;
		}
		
		var ordenID = $("#ordenID").val();
		if($.csCore.postData($.csCore.buildServicePath("/service/orden/submitorden"), "form")){
			if(!$.csValidator.isNull(ordenID) && ordenID.length ==36){
				$.csCustomerPost.listOrdens();
			}else{
				$.csOrdenList.list(0);
			}
			$.csCore.close();
		}
	},
	init:function(id,isPost){
		$("#form").resetForm();
		$.csOrdenCommon.bindLabel();
		$.csOrdenPost.bindEvent();
		$.csOrdenPost.generateClothing();
		$.csOrdenPost.autoCompleteFabric();
		
		var clothingID = $.csControl.getRadioValue('clothingID');
		$.csOrdenPost.generateComponent(clothingID);
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","Orden_Moduler","form h1");
			
			$.csCore.loadPage("container_customer","../customer/customer.htm",function(){$.csCustomer.init();});
			
			$.csOrdenPost.loadSize(clothingID,null);
		}else{
			var orden = $.csOrdenCommon.getOrdenByID(id);
			if($.csValidator.isNull(orden.customer)){
				$(".lblCustomer").hide();
			}else{
				$(".lblCustomer").show();
				$.csCore.loadPage("container_customer","../customer/customer.htm",function(){$.csCustomer.init(orden.customer);});
			}
			$.updateWithJSON(orden);
			$.csOrdenPost.loadSize(clothingID,orden);
			if(isPost){
				$('#ordenID').val('');
				$.csCore.getValue("Orden_Redo",null,"#form h1");
			}else{
				$.csCore.getValue("Common_Edit","Orden_Moduler","#form h1");
			}
			if(!$.csValidator.isNull(orden.components)){
				var components = orden.components.split(",");
				$.each(components,function(i,component){
					$.csControl.initSingleCheck(component);
				});
			}
			if(!$.csValidator.isNull(orden.componentTexts)){
				var componentTexts =  orden.componentTexts.split(",");
				$.each(componentTexts,function(i,componentText){
					var key_value = componentText.split(":");
					$('#' + $.csOrdenPost.buildTextID(key_value[0])).val(key_value[1]);
				});
			}
			
			if(!$.csValidator.isNull(orden.sizePartValues)){
				var partValues =  orden.sizePartValues.split(",");
				$.each(partValues,function(i,partValue){
					var key_value = partValue.split(":");
					$('#' + $.csCsize.buildPartID(key_value[0])).val(key_value[1]);
				});
			}
			if(!$.csValidator.isNull(orden.sizeBodyTypeValues)){
				var bodyTypes = orden.sizeBodyTypeValues.split(",");
				$.each(bodyTypes,function(i,bodyType){
					$.csControl.initSingleCheck(bodyType);
				});
			}
		}
	}
};