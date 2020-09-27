jQuery.csDictPriceView={
	view:function (id){
		$.csCore.viewWithJSON('view_dictprice',$.csDictPriceView.getDictPriceByID(id));
	},
	getDictPriceByID:function(id){
		var param = $.csControl.appendKeyValue("","id",id);
		return  $.csCore.invoke($.csCore.buildServicePath('/service/dictprice/getdictpricebyid'),param);
	},
	init:function(id){
		$.csDictPriceView.view(id);
	}
};