jQuery.csDeliveryView={
	view:function (id){
		var delivery = $.csDeliveryCommon.getDeliveryByID(id);
		$.csCore.viewWithJSON('view_delivery',delivery);
		$('#_view_planDeliveryDate').html($.csDate.formatMillisecondDate(delivery.planDeliveryDate));
		$.csCore.addValueLine('view_delivery');
		$.csCore.processList('DeliveryDetails', delivery.ordens);
		$.csDeliveryCommon.bindLabel();
	},
	init:function(id){
		$.csDeliveryView.view(id);
	}
};