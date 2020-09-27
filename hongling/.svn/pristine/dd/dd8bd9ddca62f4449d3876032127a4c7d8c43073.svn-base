jQuery.csBlDiscount={
	bindEvent:function (memberId){
		$("#blBtnSaveDiscount").click(function(){$.csBlDiscount.save(memberId);});
		$("#blBtnCancelDiscount").click($.csCore.close);
	},
	save:function(memberId){
	    if($.csBlDiscount.validate(memberId)){
		    if($.csCore.postData($.csCore.buildServicePath('/service/bldiscount/SaveDiscount'), 'BlDiscountForm')){
		    	$.csBlDiscountList.list(memberId,0);
		    	$.csCore.close();
		    }
	   	}
	},
	validate:function (){
		if($.csValidator.checkNull("disClothingId",$.csCore.getValue("Common_Required","Orden_ClothingCategory"))){
			return false;
		}
		if($.csValidator.checkNull("fromNum",$.csCore.getValue("Common_Required","Cash_FromNum"))){
			return false;
		}
		if($.csValidator.checkNull("toNum",$.csCore.getValue("Common_Required","Cash_ToNum"))){
			return false;
		}
		if($.csValidator.checkNull("discountNum",$.csCore.getValue("Common_Required","Cash_DiscountNumOfHundred"))){
			return false;
		}
		return true;
	},
	fillClothing:function(){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/bldiscount/GetDiscountClothing'));
	    $.csControl.fillOptions('disClothingId',datas , "ID" , "name", $.csCore.getValue("Common_PleaseSelect", "Orden_ClothingCategory"));
	},
	init:function(memberId,id){
		$.csBlDiscount.fillClothing();
		$.csBlDiscountCommon.bindLabel();
		$.csBlDiscount.bindEvent(memberId);
		$("#memberId").val(memberId);
		var member=$.csCore.getMemberByID(memberId);
		var discount=$.csCore.getDiscountByID(id);
		$("#blUsername").val(member.username);
        $("#blUsername").attr('readonly',true);
        $("#blUsername").attr('disabled',true);
        $.updateWithJSON(discount);
	}
};