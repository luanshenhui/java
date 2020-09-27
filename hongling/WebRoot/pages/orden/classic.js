jQuery.csClassic={
	bindLabel:function (){
		$.csCore.getValue("Button_SaveMyDesign",null,"#btnSaveSize");
	},
	bindEvent:function (){
		$("#btnSaveSize").click($.csClassic.doSaveComponent);
	},
	fillCategory:function(){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		if(datas != null && datas.length > 0){
			var clothing="<table border='1px'><tr>";
			for(var i=0;i<datas.length;i++){
				if(datas[i].ID != 5000){
					clothing+="<td  class='clothing_category_logo_"+datas[i].ID +"' onclick='$.csClassic.showProduct("+datas[i].ID +")'><h3 id='clothing_category_logo_text'>"+datas[i].name+"</h3></td>";
				}
			}
			clothing+="</tr></table>";
			$('#classic_category').html(clothing);
		}
	},
	showProduct:function(clothingID){
		if($.csValidator.isNull(clothingID)){
			clothingID = $.cookie('clothingid');
		}else{
			$.cookie('clothingid',clothingID);
			$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'),$.csControl.appendKeyValue("","clothingid",clothingID));
		}
		$("#classic_botton").hide();
		/*var fabric = $.csClassic.getTempFabricCode();*/
		var dict=$.csCore.getDictByID(clothingID);
		var singleClothings= dict.extension.split(",");
		var currentVersion = $.csCore.getCurrentVersion();
		var processNames="";
		$('#classic_product').html("");
		var ComponentPageSize = 6;
		var ComponentHeight = 150;
		for(var i=0;i<singleClothings.length;i++){
			var singleClothing = $.csCore.getDictByID(singleClothings[i]);
			var param = $.csControl.appendKeyValue('','singleClothingID',singleClothing.ID);
			var fixedStyles = $.csCore.invoke($.csCore.buildServicePath('/service/clothing/getfixedstyles'),param);
			if(fixedStyles.length>0){
				var domDiv="";
				domDiv+="<div id='orden_component"+ singleClothing.ID +"' class='component'>";
				domDiv+="<a class='prev_slide'></a>";
				domDiv+="<div class='slides_container'>";
				domDiv+="<div class='slide'>";
				var product_dict=$.csCore.getDictByID(fixedStyles[0].fixedID);
				if(currentVersion ==1){
					processNames = fixedStyles[0].processNames;
				}else{
					processNames = fixedStyles[0].processENNames;
				}
				if(clothingID<DICT_CLOTHING_ShangYi){
					domDiv+="<div class='item'><div id='"+fixedStyles[0].fixedID+"' onclick='$.csClassic.loadDetail("+clothingID+","+singleClothing.ID+","+fixedStyles[0].fixedID+")'><img title='"+processNames+"' src='../../process/component/classic/"+fixedStyles[0].fixedID+"_S.png'></div><div style='width:70px;text-align:center;'>"+product_dict.name+"</div></div>";
				}else{
					domDiv+="<div class='item'><div id='"+fixedStyles[0].fixedID+"' onmouseover='$.csClassic.divborder(1,"+fixedStyles[0].fixedID+")' onmouseout='$.csClassic.divborder(2,"+fixedStyles[0].fixedID+")' onclick='$.csClassic.loadProductDetail("+clothingID+","+fixedStyles[0].fixedID+")'><img title='"+processNames+"' src='../../process/component/classic/"+fixedStyles[0].fixedID+"_S.png'></div><div style='width:70px;text-align:center;'>"+product_dict.name+"</div></div>";
				}
				for(var j=1;j<fixedStyles.length;j++){
					if(currentVersion ==1){
						processNames = fixedStyles[j].processNames;
					}else{
						processNames = fixedStyles[j].processENNames;
					}
					product_dict=$.csCore.getDictByID(fixedStyles[j].fixedID);
					if(j%ComponentPageSize==0){
						domDiv+="</div>";
						domDiv+="<div class='slide'>";
						if(clothingID<DICT_CLOTHING_ShangYi){
							domDiv+="<div class='item'><div id='"+fixedStyles[j].fixedID+"' onclick='$.csClassic.loadDetail("+clothingID+","+singleClothing.ID+","+fixedStyles[j].fixedID+")'><img title='"+processNames+"' src='../../process/component/classic/"+fixedStyles[j].fixedID+"_S.png'></div><div style='width:70px;text-align:center;'>"+product_dict.name+"</div></div>";
						}else{
							domDiv+="<div class='item'><div id='"+fixedStyles[j].fixedID+"' onmouseover='$.csClassic.divborder(1,"+fixedStyles[j].fixedID+")' onmouseout='$.csClassic.divborder(2,"+fixedStyles[j].fixedID+")' onclick='$.csClassic.loadProductDetail("+clothingID+","+fixedStyles[j].fixedID+")'><img title='"+processNames+"' src='../../process/component/classic/"+fixedStyles[j].fixedID+"_S.png'></div><div style='width:70px;text-align:center;'>"+product_dict.name+"</div></div>";
						}
					}else{
						if(clothingID<DICT_CLOTHING_ShangYi){
							domDiv+="<div class='item'><div id='"+fixedStyles[j].fixedID+"' onclick='$.csClassic.loadDetail("+clothingID+","+singleClothing.ID+","+fixedStyles[j].fixedID+")'><img title='"+processNames+"' src='../../process/component/classic/"+fixedStyles[j].fixedID+"_S.png'></div><div style='width:70px;text-align:center;'>"+product_dict.name+"</div></div>";
						}else{
							domDiv+="<div class='item'><div id='"+fixedStyles[j].fixedID+"' onmouseover='$.csClassic.divborder(1,"+fixedStyles[j].fixedID+")' onmouseout='$.csClassic.divborder(2,"+fixedStyles[j].fixedID+")' onclick='$.csClassic.loadProductDetail("+clothingID+","+fixedStyles[j].fixedID+")'><img title='"+processNames+"' src='../../process/component/classic/"+fixedStyles[j].fixedID+"_S.png'></div><div style='width:70px;text-align:center;'>"+product_dict.name+"</div></div>";
						}
					}
				}
				domDiv+="</div>";
				domDiv+="</div>";
				domDiv+="<a class='next_slide'></a>";
				domDiv+="</div>";
				$("#classic_product").append(domDiv);
				$(".next_slide,.prev_slide,.slides_container div.slide").height(ComponentHeight);
				$('#orden_component'+ singleClothing.ID).slides({generatePagination :false});
			}
		}
		if(clothingID == DICT_CLOTHING_SUIT2PCS || clothingID == DICT_CLOTHING_SUIT3PCS){
			$("#classic_botton").show();
		}
	},
	loadProductDetail:function(clothingID,productID){
		if(clothingID<DICT_CLOTHING_ChenYi){
//			$.csOrden.loadMediumFabric("MBK052A");
			$.csOrden.loadMediumFabric("DBK052A");
		}
		if(clothingID==DICT_CLOTHING_ChenYi){
//			$.csOrden.loadMediumFabric("CAI025A");
			$.csOrden.loadMediumFabric("SAI025A");
		}
		if(clothingID==DICT_CLOTHING_MaJia){
//			$.csOrden.loadMediumFabric("MBL637A");
			$.csOrden.loadMediumFabric("DBL637A");
		}
		if(clothingID==DICT_CLOTHING_DaYi){
			$.csOrden.loadMediumFabric("MBL513A");
		}
		
		$.csOrden.loadAccordion('#p'+clothingID,clothingID);
		$.csOrden.loadMediumComponent(productID,DICT_VIEW_FRONT);
		this.removeClickByCategoryID(clothingID);
		$.csCore.close();
	},
	loadDetail:function(clothingID,singleClothingID,productID){
		$("#clothingID").val(clothingID);
		if($.csValidator.isNull($("#fixed_"+singleClothingID).val())){
			$("#"+productID).css("border","2px solid #FFAB00");
		}else{
			$("#"+$("#fixed_"+singleClothingID).val()).css("border","");
			$("#"+productID).css("border","2px solid #FFAB00");
		}
		$("#fixed_"+singleClothingID).val(productID);
		
	},
	doSaveComponent:function(){
		$.csOrden.loadMediumFabric("DBK052A");
		var clothingID = $("#clothingID").val();
		var productID = $("#fixed_3").val()+$("#fixed_2000").val();
		if(clothingID == DICT_CLOTHING_SUIT3PCS){
			productID += $("#fixed_4000").val();
		}
		$.csOrden.loadAccordion('#p'+clothingID,clothingID);
		$.csOrden.loadMediumComponent(productID,DICT_VIEW_FRONT);
		$.csOrden.loadMediumFabric("DBK052A");
		$.csClassic.removeClickByCategoryID(clothingID);
		$.csCore.close();
	},
	getTempFabricCode:function (){
		return $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempfabriccode'));
	},
	removeClickByCategoryID:function(clothingID){
		var dict=$.csCore.getDictByID(clothingID);
		var arr= new Array(); 
		arr=dict.extension.split(",");
		var dicts= new Array(); 
		if(arr.length>1){
			$.cookie("isClassic","true");
		}else{
			dicts=$.csCore.getDictsByParent(1,arr[0]);
			for(var j=0;j<dicts.length;j++){
				if(DICT_DESIGN_STYLE.indexOf(dicts[j].ID, 0)>-1){
					$("#p"+dicts[j].ID).css("display","none");
				}
			}
		}
	},
	divborder : function(num,productID){
		if(num == 2){
			$("#"+productID).css("border","");
		}
		if(num == 1){
			$("#"+productID).css("border","2px solid #FFAB00");
		}
	},
	init:function(){
		$.csClassic.bindLabel();
		$.csClassic.bindEvent();
		$.csClassic.fillCategory();
		//$.csClassic.showProduct();
	}
};