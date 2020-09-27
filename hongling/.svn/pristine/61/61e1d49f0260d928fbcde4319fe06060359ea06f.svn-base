jQuery.csFabricPost={
	bindEvent:function (){
		$("#categoryID").change($.csFabricPost.fillSeriesColorFlowerComposition);
		$("#btnSaveFabric").click($.csFabricPost.save);
		$("#btnCancelFabric").click($.csCore.close);
	},
	fillFabricSupplyCategory:function (){
	    $.csControl.fillOptions('fabricSupplyCategoryID',$.csCore.getDicts(DICT_CATEGORY_FABRIC_SUPPLY_CATEGORY), "ID" , "name", "");
	    $('#fabricSupplyCategoryID option:last').remove();
	},
	fillCategory:function (){
	    $.csControl.fillOptions('categoryID',$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabriccategorybytop')), "ID" , "name", "");
	    $.csFabricPost.fillSeriesColorFlowerComposition();
	},
	fillSeriesColorFlowerComposition:function (){
		$("#seriesID,#colorID,#flowerID,#compositionID").empty();

		var param = $.csControl.appendKeyValue('','categoryid',$('#categoryID').val());

		var dictsSeries = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getseriesbycategory'),param);
		$.csControl.fillOptions('seriesID',dictsSeries, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Series"));

		var dictsColor = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getcolorbycategory'),param);
		$.csControl.fillOptions('colorID',dictsColor, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Color"));

		var dictsFlower = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getflowerbycategory'),param);
		$.csControl.fillOptions('flowerID',dictsFlower, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Flower"));

		var dictsComposition = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getcompositionbycategory'),param);
		$.csControl.fillOptions('compositionID',dictsComposition, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Composition"));
	},
	fillIsStop:function (){
	    $.csControl.fillOptions('isStop',$.csCore.getDicts(DICT_CATEGORY_BOOL), "ID" , "name", "");
	},
	save:function (){
		if($.csFabricPost.validate()){
			//alert($.csControl.getFormData('form'));
		    if($.csCore.postData($.csCore.buildServicePath('/service/fabric/savefabric'), 'form')){
		    	$.csFabricList.list(0);
		    	$.csCore.close();
		    }
	    }
	},
	validate:function (){
		if($.csValidator.checkNull("code",$.csCore.getValue("Common_Required","Fabric_Code"))){
			return false;
		}
		if($.csValidator.checkNull("seriesID",$.csCore.getValue("Common_Required","Fabric_Series"))){
			return false;
		}
		if($.csValidator.checkNull("colorID",$.csCore.getValue("Common_Required","Fabric_Color"))){
			return false;
		}
		if($.csValidator.checkNull("flowerID",$.csCore.getValue("Common_Required","Fabric_Flower"))){
			return false;
		}
		if($.csValidator.checkNull("compositionID",$.csCore.getValue("Common_Required","Fabric_Composition"))){
			return false;
		}
		//判断设置顺序是否为正整数
		if($.csValidator.checkNotPositiveInteger($("#sequenceNo").val(),$.csCore.getValue("Common_PositiveInteger","Fabric_SequenceNo"))){
			return false;
		}
		return true;
	},
	init:function(id){
		$.csFabricCommon.bindLabel();
		$.csFabricPost.bindEvent();
		$('#form').resetForm();
		$.csFabricPost.fillFabricSupplyCategory();
		$.csFabricPost.fillCategory();
		$.csFabricPost.fillIsStop();

		if($.csValidator.isNull(id)){
			$.csFabricPost.fillSeriesColorFlowerComposition();
			$.csCore.getValue("Common_Add","Fabric_Moduler","#form h1");
		}else{
			$.csCore.getValue("Common_Edit","Fabric_Moduler","#form h1");
			var fabric = $.csFabricCommon.getFabricByID(id);
			//alert(JSON.stringify(fabric));
			$.updateWithJSON(fabric);
			$.csFabricPost.fillSeriesColorFlowerComposition();
			$.updateWithJSON(fabric);
		}
	}
};
