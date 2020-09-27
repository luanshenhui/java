jQuery.csBlDealItem={
	bindEvent:function (){
		$("#blBtnSaveDealItem").click($.csBlDealItem.save);
		$("#blBtnCancelDealItem").click($.csCore.close);
	},
	fillBlIOFlags:function(){
		$.csControl.fillOptions('ioFlag',$.csCore.getDicts(DICT_CATEGORY_IOFLAG), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Cash_IOFlag"));
	},
	save:function (){
	    if($.csBlDealItem.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/blcash/SaveDealItem'), 'BlDealItemForm')){
			    $.csBlDealItemList.list(0);
		    	$.csCore.close();
		    }
	   	}
	},
	validate:function (){
		if($.csValidator.checkNull("name",$.csCore.getValue("Common_Required","Cash_DealItemName"))){
			return false;
		}
		if($.csValidator.checkNull("ioFlag",$.csCore.getValue("Common_Required","Cash_IOFlag"))){
			return false;
		}
		return true;
	},
	init:function(ID){
		$.csBlDealItemCommon.bindLabel();
		$.csBlDealItem.fillBlIOFlags();
		$.csBlDealItem.bindEvent();
		if($.csValidator.isNull(ID) || $.csValidator.isNull(ID.length)){
			$.csCore.getValue("Cash_AddDealItem",null,".form_template h1");
		} else {
			$.csCore.getValue("Cash_EditDealItem",null,".form_template h1");
			$("#ID").val(ID);
			var dealitem = $.csCore.getBlDealItemByID(ID);
			$.updateWithJSON(dealitem);
		}
	}
};