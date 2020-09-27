jQuery.csBlDeliveryDetailHList={
	moduler : "BlDeliveryDetailH",
	bindEvent:function (deliveryId){
		$("#blLblStorage").click(function(){$.csBlDeliveryDetailHList.openStorage(deliveryId);});
		$("#blAddDeliveryDetail").click(function(){$.csBlDeliveryDetailHList.openAdd(deliveryId);});
		$("#btnLadeDelivery").click(function(){$.csBlDeliveryDetailHList.lade(deliveryId);});
		$("#btnSaveDelivery").click(function(){$.csBlDeliveryDetailHList.save(deliveryId);});
		$("#btnCancelDeliveryDetail").click($.csCore.close);
	},
	
	/**
	 * 打开已入库页面
	 * @param deliveryId
	 */
	openStorage: function(deliveryId) {
		$.csCore.loadModal('../bldelivery/addDelivery.htm',800,500,function(){$.csAddDeliveryDetail.init(deliveryId);});
	},
	
	/**
	 * 打开新增页面
	 * @param deliveryId
	 */
	openAdd: function(deliveryId) {
		$.csCore.loadModal('../bldelivery/addOtherDelivery.htm',400,300,function(){$.csAddOtherDelivery.init(deliveryId);});
	},
	
	/**
	 * 保存
	 * @param deliveryId
	 */
	save: function(deliveryId) {
		var deliveryMemo = $("#deliveryMemo").val(); 
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		param = $.csControl.appendKeyValue(param,"deliveryMemo",deliveryMemo);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/saveDeiveryByDeliveryId'),param);
		if (data == "OK") {
			$.csBlDeliveryHList.list(0);
			$.csCore.close();
		}
	},
	
	/**
	 * 删除发货明细
	 */
	deleteDeliveryDetail: function(ordenId,deliveryId,type) {
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csBlDeliveryDetailHList.confirmDeleteDeliveryDetail('" + deliveryId + "','"+ordenId+"','"+type+"')");
	},
	
	confirmDeleteDeliveryDetail: function(deliveryId, ordenId, type) {
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		param = $.csControl.appendKeyValue(param,"ordenId",ordenId);
		param = $.csControl.appendKeyValue(param,"type",type);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/deleteDeliveryDetailbyordenid'), param);
		if (data == "OK") {
			$.csBlDeliveryDetailHList.deliveryDetailList(deliveryId);
		}
	},
	
	/**
	 * 提货
	 */
	lade: function(deliveryId) {
		var deliveryMemo = $("#deliveryMemo").val();
		$.csCore.confirm($.csCore.getValue('Delivery_LadeConfirm'), "$.csBlDeliveryDetailHList.confirmLade('" + deliveryId + "','"+deliveryMemo+"')");
	},
	
	confirmLade: function(deliveryId,deliveryMemo) {
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		param = $.csControl.appendKeyValue(param,"deliveryMemo",deliveryMemo);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/ladeDeiveryByDeliveryId'),param);
		if (data == "OK") {
			$.csCore.alert($.csCore.getValue("Delivery_LadeSuccess"));
			$.csBlDeliveryHList.list(0);
			$.csCore.close();
		} else if (data == "failure"){
			$.csCore.close();
			$.csCore.alert($.csCore.getValue("Delivery_LadeFailure"));
		} else {
			$.csCore.close();
			$.csCore.alert($.csCore.getValue("Delivery_LadeFalut"));
		}
		
		if (data != "OK") {
			$.csCore.alert(data);
		}
		
		$.csCore.close();
	},
	/**
	 * 根据发货ID，得到发货明细
	 * @param deliveryId
	 */
	deliveryDetailList: function(deliveryId) {
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/getdeliverydetailbydeliveryid'),param);
		$.csCore.processList($.csBlDeliveryDetailHList.moduler, data);
		$.csBlDeliveryDetailHCommon.bindLabel();
		$.csBlDeliveryDetailHList.getDeliveryInfo(deliveryId);
	},
	
	/**
	 * 打开发货单明细
	 * @param deliveryId 发货ID
	 */
	openPost: function(deliveryId) {
		$.csCore.loadModal('../bldelivery/BlDeliveryDetailH.htm',850,400,function(){$.csBlDeliveryDetailHList.init(deliveryId);});
	},
	
	/**
	 * 根据发货单号得到发货单信息
	 * @param deliveryId 发货单号
	 */
	getDeliveryInfo: function(deliveryId) {
		var param = $.csControl.appendKeyValue("","id",deliveryId);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/getdeliverybyid'),param);
		// 设置deliveryId
		$("#deliveryid").val(deliveryId);
		
		// 设置发货人
		$("#username").html(data.pubMemberName);
		
		var deliveryAddress = ""; 
		if (data.addressLine2 != null) {
			deliveryAddress = data.addressLine2+data.addressLine1+data.city+data.countryName;
		} else {
			deliveryAddress = data.addressLine1+data.city+data.countryName;
		}
		if (deliveryAddress == 0 || deliveryAddress == "0") {
			deliveryAddress = "";
		}
		// 设置发货地址
		$("#deliveryAddress").html(deliveryAddress);
		
		// 设置发货时间
		$("#deliveryDate").html($.csDate.formatMillisecondDate(data.deliveryDate));
		
		// 初始化备注
		$("#deliveryMemo").val(data.memo);
		
		// 获取已入库且未申请发货的订单的数量
		var amountData = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/getstroagedOrdenAmount'),param);
		
		// 设置数量
		$("#amount").html('('+amountData+')');
	},
	/**
	 * 初始化
	 * @param deliveryId
	 */
	init:function(deliveryId){
		$.csBlDeliveryDetailHCommon.bindLabel();
		$.csBlDeliveryDetailHList.bindEvent(deliveryId);
		$.csBlDeliveryDetailHList.deliveryDetailList(deliveryId);
	}
};