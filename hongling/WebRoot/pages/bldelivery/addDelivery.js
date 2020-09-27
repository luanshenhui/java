jQuery.csAddDeliveryDetail={
	bindEvent:function (deliveryId){
		$("#btnSaveAddDeliveryDetail").click(function(){$.csAddDeliveryDetail.save(deliveryId);});
		$("#btnCancelAddDeliveryDetail").click($.csCore.close);
	},

	/**
	 * 提交发货申请
	 */
	save:function(deliveryId){
		// 得到所选行
		var addIDs = $.csControl.getCheckedValue('chkDeliveryOrden');
		
		// 判断是否已选择订单
		if (addIDs == null || addIDs == "") {
            $.csCore.alert($.csCore.getValue('Common_PleaseSelect', 'Delivery_ForAdd'));
            return false;
        }
		
		var param = $.csControl.appendKeyValue("","deliveryId",deliveryId);
		param = $.csControl.appendKeyValue(param,"ordenIds",addIDs);
		
		if($.csCore.invoke($.csCore.buildServicePath("/service/delivery/adddeliverydetail"),param)){
			$.csCore.alert($.csCore.getValue("Delivery_AddDetailSuccess"));
			$.csAddDeliveryDetail.list(deliveryId);
			$.csBlDeliveryDetailHList.deliveryDetailList(deliveryId);
			$.csCore.close();
		}
		$.csCore.close();
	},
	
	list:function (deliveryId){
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/getuserStroagedOrdens'),param);
		$.csCore.processList("AddDeliveryDetails", data);
		$.csBlDeliveryDetailHCommon.bindLabel();
	},
	
	init:function(deliveryId){
		$.csBlDeliveryDetailHCommon.bindLabel();
		$.csAddDeliveryDetail.bindEvent(deliveryId);
		$.csAddDeliveryDetail.list(deliveryId);
	}
};