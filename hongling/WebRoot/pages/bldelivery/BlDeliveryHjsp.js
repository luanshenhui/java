jQuery.csBlDeliveryHList={
	divBlDeliveryH : "BlDeliveryH",
	bindEvent:function (){
		$.csDate.datePickerNull("blDeliverFromDate");
		$.csDate.datePickerNull("blDeliverToDate");
		$("#blCreateChangjiandanju").click($.csBlDeliveryHList.createChangjiandanju);
		$("#blCreateShangjiandanju").click($.csBlDeliveryHList.createShangjiandanju);
		$("#blCreateBaoguandanju").click($.csBlDeliveryHList.createBaoguandanju);
		$("#blExport").click($.csBlDeliveryHList.doExport);
		$("#blSearch").click(function(){$.csBlDeliveryHList.list(0);});
		$("#blExpressCom").click($.csBlDeliveryHList.openExpress);
	},
	
	/**
	 * 打开快递公司管理
	 */
	openExpress: function() {
		$.csCore.loadModal('../blexpresscom/list.htm',800,400,function(){$.csBlExpressComList.init();});
	},
	
	/**
	 * 批量导出发货明细
	 */
	doExport: function() {
		var param = $.csControl.getFormData('BlDeliveryHSearch');
		param = $.csControl.appendKeyValue(param,'from','houtai');
		// 判断是否有符合条件的记录
		var data = $.csCore.invoke($.csCore.buildServicePath("/servlet/bldelivery/checkDeliveryDetailExists"),param);
		if (data == "OK") {
			var url = $.csCore.buildServicePath("/servlet/bldelivery/exportDeliveryDetail?flag=0&param="+param);
			window.open(url);
		} else {
			$.csCore.alert($.csCore.getValue("Delivery_BatchExportNoData"));
		}
	},
	
	/**
	 * 打开物流信息
	 * @param yundanId 运单号
	 */
	openTrack: function(yundanId) {
		$.csCore.loadModal('../bldelivery/BlListTrack.htm',800,400,function(){$.csBlListTrack.init(yundanId);});
	},
	
	/**
	 * 生成厂检单据
	 */
	createChangjiandanju:function (){
		var param = $.csControl.getCheckedValue('chkRow');
		param = $.csControl.appendKeyValue("",'chkRow',param);
		if($.csControl.getCheckedValue('chkRow')==''){
			$.csCore.alert($.csCore.getValue("Delivery_SelectYunDan"));
		}
		else{
			var url = $.csCore.buildServicePath("/servlet/blorden/blexportinspection?chkRow=");
			url += $.csControl.getCheckedValue('chkRow');
			window.open(url);
		}
	},
	
	/**
	 * 生成商检单据
	 */
	createShangjiandanju:function (){
		var param = $.csControl.getCheckedValue('chkRow');
		param = $.csControl.appendKeyValue("",'chkRow',param);
		param = $.csControl.appendKeyValue(param,'multpleFlag','1.5');
		if($.csControl.getCheckedValue('chkRow')==''){
			$.csCore.alert($.csCore.getValue("Delivery_SelectYunDan"));
		}
		else{
			var url = $.csCore.buildServicePath("/servlet/blorden/blexportshangjian?formData=");
			window.open(url+param);
		}
	},
	
	/**
	 * 生成报关单据
	 */
	createBaoguandanju:function (){
		var param = $.csControl.getCheckedValue('chkRow');
		param = $.csControl.appendKeyValue("",'chkRow',param);
		param = $.csControl.appendKeyValue(param,'multpleFlag','1');
		if($.csControl.getCheckedValue('chkRow')==''){
			$.csCore.alert($.csCore.getValue("Delivery_SelectYunDan"));
		}
		else{
			var url = $.csCore.buildServicePath("/servlet/blorden/blexportshangjian?formData=");
			window.open(url+param);
		}
	},
	
	/**
	 * 导出发货明细
	 * @param deliveryId 发货单ID
	 */
	exportDeliveryDetail:function (deliveryId){
		var url = $.csCore.buildServicePath('/servlet/blorden/BlExportDelivery?deliveryid='+deliveryId);
		window.open(url);
	},
	
	/**
	 * 打开编辑发货单页面
	 * @param deliveryId 发货单ID
	 */
	openEdit:function(deliveryId,yundanId) {
		$.csCore.loadModal('../bldelivery/editYunDan.htm',300,80,function(){$.csBlEditYunDan.init(deliveryId,yundanId);});
	},
	
	list:function (pageIndex){
		var param = $.csControl.getFormData('BlDeliveryHSearch');
		param = $.csControl.appendKeyValue(param,'pageindex',pageIndex);
		param = $.csControl.appendKeyValue(param,'from','houtai');
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/bldeliver/GetBlDelivery'),param);
	    $.csCore.processList($.csBlDeliveryHList.divBlDeliveryH, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlDeliveryHList.divBlDeliveryH + "Pagination", data.count, PAGE_SIZE, $.csBlDeliveryHList.list);
	    }
	    $.csBlDeliveryHCommon.bindLabel();
	},
	init:function(){
		$.csBlDeliveryHList.bindEvent();
		$.csBlDeliveryHList.list(0);
	}
};
