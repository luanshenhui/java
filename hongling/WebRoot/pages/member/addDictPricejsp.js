jQuery.csAddDictPrice={
	bindEvent:function (code){
		$("#btnDictPrice").click(function(){$.csAddDictPrice.saveDicePrice(code);});
		$("#btnDictPriceCancel").click($.csCore.close);
	},
	saveDicePrice:function (code){
		if($.csAddDictPrice.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/member/savedictprices'), 'form_dictPrice')){
		    	$.csCore.close();
		    }
	    }
		// 刷新列表页面
		$.csDictPrice.list(0,code);
	},
	validate:function (){
		if($.csValidator.checkNull("addDictPrice_code",$.csCore.getValue("Common_Required","Fabric_Member"))){
			return false;
		}
		if($.csValidator.checkNull("addDictPrice_price",$.csCore.getValue("Common_Required","Cash_Discount"))){
			return false;
		}
		return true;
	},

	init:function(code){
		$.csAddDictPrice.bindEvent(code);
		$('#username').val(code);
	},
};