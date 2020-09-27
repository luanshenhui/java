jQuery.csBlDeliveryDetailFList={
	moduler : "BlDeliveryDetailF",
	bindEvent:function (){
		$.csDate.datePickerNull("blDeliverFromDate");
		$.csDate.datePickerNull("blDeliverToDate");
		$("#blDetailBtnExportDelivery").click($.csBlDeliveryDetailFList.doExport);
		$("#blDetailBtnSearch").click(function(){$.csBlDeliveryDetailFList.list(0);});
	},
	list:function (pageIndex){
		var param = $.csControl.getFormData('BlDeliveryDetailFSearch');
		param = $.csControl.appendKeyValue(param,'pageindex',pageIndex);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/bldeliver/GetBlDelivery'),param);
		$.csCore.processList($.csBlDeliveryDetailFList.moduler, data);
		if (pageIndex == 0) {
			$.csCore.initPagination($.csBlDeliveryDetailFList.moduler + "Pagination", data.count, PAGE_SIZE, $.csBlDeliveryDetailFList.list);
		}
		$.csBlDeliveryDetailFCommon.bindLabel();
	},
	
	/**
	 * 导出发货明细
	 */
	doExport: function() {
		var param = $.csControl.getFormData('BlDeliveryDetailFSearch');
		param = $.csControl.appendKeyValue(param,'from','qiantai');
		// 判断是否有符合条件的记录
		var data = $.csCore.invoke($.csCore.buildServicePath("/servlet/bldelivery/checkDeliveryDetailExists"),param);
		
		if (data == "OK") {
			var url = $.csCore.buildServicePath("/servlet/bldelivery/exportDeliveryDetail?flag=1&param="+param);
			window.open(url);
		} else {
			$.csCore.alert($.csCore.getValue("Delivery_BatchExportNoData"));
		}
	},
	
	/**
	 * 撤销发货单
	 */
	cancleDeliveryDetail: function(deliveryId) {
		$.csCore.confirm($.csCore.getValue('Delivery_CancleConfirm'), "$.csBlDeliveryDetailFList.confirmCancleDeliveryDetail('" + deliveryId + "')");
	},
	confirmCancleDeliveryDetail: function(deliveryId) {
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/cancleDeiveryByDeliveryId'),param);
		if (data == "OK") {
			$.csCore.alert($.csCore.getValue("Delivery_CancleSuccess"));
			$.csBlDeliveryDetailFList.list(0);
			$.csCore.close();
		}
	},
	
	init:function(){
		$.csBlDeliveryDetailFCommon.bindLabel();
		$.csBlDeliveryDetailFList.bindEvent();
		$.csBlDeliveryDetailFList.list(0);
	}
}; 