jQuery.csAddOtherDelivery={
	/**
	 * 绑定事件
	 */
	bindEvent: function(deliveryId) {
		$("#btnSaveDeliveryPlus").click(function(){$.csAddOtherDelivery.save(deliveryId);});
		$("#btnCancelDeliveryPlus").click($.csCore.close);
	},
	
	/**
	 * 填充状态
	 */
	fillStatus:function (){
	    $.csControl.fillOptions('statusID',$.csCore.getDicts(DICT_CATEGORY_ORDEN_STATUS), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Delivery_OrdenStatus"));
	},
	
	/**
	 * 验证
	 */
	validate: function() {
		if($.csValidator.checkNull("ordenID",$.csCore.getValue("Common_Required","Orden_Code"))){
			return false;
		}
		return true;
	},
	
	/**
	 * 保存
	 */
	save: function(deliveryId) {
		if ($.csAddOtherDelivery.validate()) {
			if($.csCore.postData($.csCore.buildServicePath('/service/bldelivery/saveotherdelivery'), 'form')){
		    	$.csBlDeliveryDetailHList.deliveryDetailList(deliveryId);
		    	$.csCore.close();
		    }
		}
	},
	
	/**
	 * 初始化
	 */
	init: function(id) {
		$.csAddOtherDeliveryCommon.bindLabel();
		$.csAddOtherDelivery.bindEvent(id);
		$('#form').resetForm();
		// 绑定发货ID
		$("#deliveryID").val(id);
		// 填充订单状态
		$.csAddOtherDelivery.fillStatus();
	}
};

jQuery.csAddOtherDeliveryCommon={
	bindLabel: function() {
		$.csCore.getValue("Common_Add","Delivery_Details","#form h1");
		$.csCore.getValue("Orden_Code",null,".lblOrdenID");
		$.csCore.getValue("Common_Count",null,".lblAmount");
		$.csCore.getValue("Delivery_CompositionName",null,".lblFabricomPosition");
		$.csCore.getValue("Common_Status",null,".lblstatusID");
		
		// 新增、修改页面
		$.csCore.getValue("Button_Submit",null,"#btnSaveDeliveryPlus");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelDeliveryPlus");
	}	
};