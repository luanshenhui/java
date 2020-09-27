jQuery.csBlDeliveryDetailView={
	moduler : "BlDeliveryDetailView",

	/**
	 * 打开查看页面
	 * @param deliveryId
	 */
	openView: function(deliveryId) {
		$.csCore.loadModal('../bldelivery/BlDeliveryDetailView.htm',800,500,function(){$.csBlDeliveryDetailView.init(deliveryId);});
	},

	/**
	 * 根据发货ID，得到发货明细
	 * @param deliveryId
	 */
	deliveryDetailList: function(deliveryId) {
		var param = $.csControl.appendKeyValue("","deliveryid",deliveryId);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/getdeliverydetailbydeliveryid'),param);
		$.csCore.processList($.csBlDeliveryDetailView.moduler, data);
		$.csBlDeliveryDetailViewCommon.bindLabel();
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
		
		// 设置备注
		$("#deliveryMemo").html(data.memo);
	},
	/**
	 * 初始化
	 * @param deliveryId
	 */
	init:function(deliveryId){
		$.csBlDeliveryDetailViewCommon.bindLabel();
		$.csBlDeliveryDetailView.deliveryDetailList(deliveryId);
		$.csBlDeliveryDetailView.getDeliveryInfo(deliveryId);
	}
};

jQuery.csBlDeliveryDetailViewCommon={
	bindLabel: function() {
		$("h1").html($.csCore.getValue("Delivery_Details"));
		$(".blLblUserName").html($.csCore.getValue("Member_Username"));
		$(".blLblDeliveryAddr").html($.csCore.getValue("Delivery_Address"));
		$(".blLblDeliveryDate").html($.csCore.getValue("Delivery_Date"));
		$(".blLblNumberView").html($.csCore.getValue("Common_Index"));
		$(".blLblOrdenIDView").html($.csCore.getValue("Fabric_ysddh"));
		$(".blLblAmountView").html($.csCore.getValue("Common_Count"));
		$(".blLblCompositionNameView").html($.csCore.getValue("Delivery_CompositionName"));
		$(".blLblClosingTypeView").html($.csCore.getValue("Delivery_ClosingType"));
		$(".blLblMemo").html($.csCore.getValue("Common_Memo"));
	}
};