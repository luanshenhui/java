jQuery.csTempEdit={
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
	generateClothing:function (clothingID){
		var clothing = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		var dom="<ul>";
		for(var i=0;i<clothing.length;i++){
			dom+="<li><label><input type='radio' name='clothingID' value='"+clothing[i].ID+"' onclick='$.csOrdenPost.clothingChange("+clothing[i].ID+");'/> "+clothing[i].name+"</label></li>";
		}
		dom+="</ul>";
		$("#container_clothings").html(dom);
		if($.csValidator.isNull(clothingID)){
			clothingID=clothing[0].ID;
		}
		$("input[value='"+clothingID+"']").attr("checked","checked");
		$.csOrdenPost.generateComponent(clothingID);
		$.csOrdenPost.generateEmbroid(clothingID);
	},
	generateComponent:function(clothingID){
		$("#container_component").html("");
		var dict=$.csCore.getDictByID(clothingID);
		var arr= new Array(); 
		arr=dict.extension.split(",");
		for(i=0;i<arr.length;i++){
			var dt=$.csCore.getDictByID(arr[i]);
			dom="<div class='list_search'>"+dt.name+"<a onclick='$.csOrdenPost.addComponentRow("+arr[i]+")'>"+$.csCore.getValue("Button_Add")+"</a></div>" +
					"<table id='category_"+arr[i]+"' class='list_result'></table>" ;
			$("#container_component").append(dom);
			$.csOrdenPost.addComponentRow(arr[i]);
		}
	},
	getComponentRowHTML:function(clothingID,index){
		return "<tr index='"+index+"'>" +
					"<td><input type='text' id='"+clothingID+"_"+index+"' style='width:130px' class='textbox'/><span/></td>" +
					"<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>" +
				"</tr>";
	},
	addComponentRow:function(clothingID){
		var lastIndex=$("#category_"+clothingID+" tr:last").attr("index");
		if(lastIndex==undefined){lastIndex=0;}
		$("#category_"+clothingID).append($.csOrdenPost.getComponentRowHTML(clothingID,parseInt(lastIndex)+1));
		$.csOrdenPost.autoCompleteDict(clothingID,parseInt(lastIndex)+1);
	},
	autoCompleteDict:function (clothingID,index){
		var url = $.csCore.buildServicePath('/service/orden/getcomponentbykeyword?id='+clothingID);
			$("#"+clothingID+"_"+index).autocomplete(url,{
			selectFirst : true, 
			multiple : false,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ID,
						result : row.ecode
					}
				});
			},
			formatItem : function(item) {
				return item.ecode + "(" + item.name + ")"; 
			}
		}).result(function(e,data){
			var error=0;
			 $("input[id^='component_']").each(function() {
			      if($(this).attr("id")=="component_"+clothingID+"_"+data.ID){
			    	  error++;
			      }
			    });
			 if(error<=1){ 
				 parentDict=$.csCore.getDictByID(data.parentID);
				 parentparentDict=$.csCore.getDictByID(parentDict.parentID);
				 var lowerLevelData=$.csCore.getDictsByParent(data.categoryID,data.ID);
				 if(parentDict.ecode!=null){
					 $(this).next().html(parentparentDict.name+parentDict.name+":"+data.name);
				 }else{
					 $(this).next().html(data.name);
				 }
				 $(this).attr("id","component_"+clothingID+"_"+data.ID);
				 if(lowerLevelData.length>0&&parentDict.statusID==null){
					 $(this).next().append("<input type='text' id='component_textbox_"+data.ID+"' style='width:150px' class='textbox'/>");
					 var url=$.csCore.buildServicePath('/service/dict/getdictbykeyword?parentID='+data.ID);
					 $.csOrdenPost.autoCompleteLowerLevelDict(data.ID,url);
					 $(this).attr("id","doNot_"+data.ID);
				 }else{
					 if(!lowerLevelData.length>0&&data.statusID==DICT_CUSTOMER_SPECIFIED){
						 $(this).next().append("<input type='text' id='category_textbox_"+data.ID+"' style='width:150px' class='textbox'/>");
					 }
				 }
	    	  }else{
	    		  alert($.csCore.getValue("Orden_Precess_Error"));
	    		  $(this).next().html("");
	    		  $(this).val("");
	    	  }
		});
	},
	autoCompleteLowerLevelDict:function(dictID,url){
	 $("#component_textbox_"+dictID).autocomplete(url, {
			multiple : false,
			mustMatch :true,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ID,
						result : row.ecode
					}
				});
			},
			formatItem : function(item) {
				return item.ecode + "(" + item.name + ")"; 
			}
		}).result(function(e,data){
			if(!$.csValidator.isNull(data)){
				$("#component_textbox_"+dictID).attr("id","component_"+data.ID);
			}
		});
		
	},
	clothingChange:function(clothingID){
		$.csOrdenPost.generateComponent(clothingID);
		$.csOrdenPost.loadSize(clothingID,null);
		$.csOrdenPost.generateComponent(clothingID);
		$.csOrdenPost.generateEmbroid(clothingID);
	},
	loadSize:function(clothingID,orden){
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'),$.csControl.appendKeyValue("","clothingid",clothingID));
		$.csCore.loadPage("container_size","../size/size.htm",function(){$.csSize.init(orden,true);});
	},
	loadOrdenProcess:function(orden){
		var dict=$.csCore.getDictByID(orden.clothingID);
		var arr= new Array(); 
		arr=dict.extension.split(",");
		for(i=0;i<arr.length;i++){
			$("#category_"+arr[i]).html("");
			var dt=$.csCore.getDictByID(arr[i]);
			var param = $.csControl.appendKeyValue('','ordenID',orden.ordenID);
			param=$.csControl.appendKeyValue(param,'clothingID',arr[i]);
			var data=$.csCore.invoke($.csCore.buildServicePath("/service/orden/getordenprocessbyclothingid"),param);
			for(j=0;j<data.length;j++){
				$.csOrdenPost.addComponentRow(arr[i]);
				var parentDict=$.csCore.getDictByID(data[j].parentID);
				var lowerLevelData=$.csCore.getDictsByParent(data[j].categoryID,parentDict.ID);
				 if(lowerLevelData.length>0&&parentDict.ecode!=null){
					 $("#component_"+arr[i]+"_"+(j+1)).val(parentDict.ecode)
					 $("#component_"+arr[i]+"_"+(j+1)).next().append(parentDict.name+"<input type='text' id='component_textbox_"+data[j].ID+"' style='width:150px' value='"+data[j].ecode+"' class='textbox'/>");
					 var url=$.csCore.buildServicePath('/service/dict/getdictbykeyword?parentID='+data[j].parentID);
					 $.csOrdenPost.autoCompleteLowerLevelDict(data[j].ID,url);
				 }else{
					 if(lowerLevelData.length>0&&data[j].statusID==DICT_CUSTOMER_SPECIFIED){
						 $("#component_"+arr[i]+"_"+(j+1)).val(data[j].ecode);
						 $("#component_"+arr[i]+"_"+(j+1)).next().append(data[j].name+"<input type='text' id='category_textbox_"+data[j].ID+"' value='"+data[j].memo+"' style='width:150px' class='textbox'/>");
					 }else{
						$("#component_"+arr[i]+"_"+(j+1)).val(data[j].ecode);
						$.csOrdenPost.autoCompleteDict(arr[i],(j+1));
						var parentName="";
						if(parentDict.ecode!=null){
							var parentName=parentDict.name+":";
						}
						$("#component_"+arr[i]+"_"+(j+1)).next().html(parentName+data[j].name);
					 }
					 $("#component_"+arr[i]+"_"+(j+1)).attr("id","component_"+arr[i]+"_"+data[j].ID);
				 }
			}
		}
	},
	generateEmbroid:function(clothingID){
		var dict=$.csCore.getDictByID(clothingID);
		var arr= new Array(); 
		arr=dict.extension.split(",");
		var clothing = $.csCore.getDictByID(clothingID);
		$("#container_embroid").html("");
		for(i=0;i<arr.length;i++){
			var dt=$.csCore.getDictByID(arr[i]);
			dom="<div class='list_search'>"+dt.name+"</div>" +
					"<table id='category_embroid_"+arr[i]+"' class='list_result'>"+$.csOrdenPost.getEmbroidRowHTML(arr[i])+"</table>" 
			$("#container_embroid").append(dom);
			$.csOrdenPost.fillEmbroidComposition(arr[i]);
		}
	},
	getEmbroidRowHTML:function(clothingID){
		return "<tr align='center'>" +
					"<td>"+$.csCore.getValue("Embroid_Position")+":<select id='category_label_"+clothingID+"_Position' style='width: 120px' /></td>"+
					"<td><span/><select id='category_label_"+clothingID+"_Color' style='width: 120px'/></td>"+
					"<td><span/><select id='category_label_"+clothingID+"_Font' style='width: 120px'/></td>"+
					"<td><span/><input type='text' id='category_textbox_"+clothingID+"_Content' style='width:120px;' class='textbox'/></td>"+
				"</tr>";
	},
	fillEmbroidComposition:function (clothingID){
		var param = $.csControl.appendKeyValue('','categoryid',clothingID);
		var dictsSeries = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getembroids'),param);
		for(j=0;j<dictsSeries.length;j++){
			if(j==0){
				$("#category_label_"+clothingID+"_Color").prev().html(dictsSeries[j].name+":");
				var dicts = $.csCore.getDictsByParent(1,dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_"+clothingID+"_Color",dicts, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Common_MetaKeywords")+dictsSeries[j].name);
			}
			if(j==1){
				$("#category_label_"+clothingID+"_Font").prev().html(dictsSeries[j].name+":");
				var dicts = $.csCore.getDictsByParent(1,dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_"+clothingID+"_Font",dicts, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Common_MetaKeywords")+dictsSeries[j].name);
			}
			if(j==2){
				$("#category_textbox_"+clothingID+"_Content").prev().html(dictsSeries[j].name+":");
				$("#category_textbox_"+clothingID+"_Content").attr("id","category_textbox_"+dictsSeries[j].ID);
			}
			if(j==3){
				$("#category_label_"+clothingID+"_Position").prev().html(dictsSeries[j].name+":");
				var dicts = $.csCore.getDictsByParent(1,dictsSeries[j].ID);
				$.csControl.fillOptions("category_label_"+clothingID+"_Position",dicts, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Common_MetaKeywords")+dictsSeries[j].name);
			}
		}
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
						value : row.code,
						result : row.code
					};
				});
			},
			formatItem : function(item) {
				return item.code + "(" + item.categoryName + ")"; 
			}
		}).result(function(e, data) {
			if(data.fabricSupplyCategoryID!=DICT_FABRIC_SUPPLY_CATEGORY_REDCOLLAR){
				if(data.fabricSupplyCategoryID!=DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_LARGE){
					$("#fabricCode").next().html("<input type='text' id='MXK103' style='width:150px;' class='textbox'/>(成份)");
				}
			}
			$('#autoContainer').html("");
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
		//alert($.csControl.getFormData("form"));
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
		$.csOrdenPost.autoCompleteFabric();
		var clothingID = $.csControl.getRadioValue('clothingID');
		if($.csValidator.isNull(id)){
			$.csOrdenPost.generateClothing();
			$.csCore.getValue("Common_Add","Orden_Moduler","#form h1");
			$.csCore.loadPage("container_customer","../customer/customer.jsp",function(){$.csCustomer.init();});
			$.csOrdenPost.loadSize(clothingID,null);
		}else{
			var orden = $.csOrdenCommon.getOrdenByID(id);
			$.csOrdenPost.generateClothing(orden.clothingID);
			if($.csValidator.isNull(orden.customer)){
				$(".lblCustomer").hide();
			}else{
				$(".lblCustomer").show();
				$.csCore.loadPage("container_customer","../customer/customer.jsp",function(){$.csCustomer.init(orden.customer);});
			}
			$.csOrdenPost.loadSize(orden.clothingID,orden);
			$.updateWithJSON(orden);
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
//					$('#' + $.csSize.buildPartID(key_value[0])).val(key_value[1]);
				});
			}
			if(!$.csValidator.isNull(orden.sizeBodyTypeValues)){
				var bodyTypes = orden.sizeBodyTypeValues.split(",");
				$.each(bodyTypes,function(i,bodyType){
					$.csControl.initSingleCheck(bodyType);
				});
			}
			$.csOrdenPost.loadOrdenProcess(orden);
		}
	}
};