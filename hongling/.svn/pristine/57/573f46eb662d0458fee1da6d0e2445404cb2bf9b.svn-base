jQuery.csBlEditYunDan={
	
	/**
	 * 绑定运单号
	 */
	bindLabel: function() {
		$.csCore.getValue("Delivery_TrackingNO",null,".lblYundanId");
		$.csCore.getValue("Button_Submit",null,"#btnSaveYundanId");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelYunId");
	},
	
	/**
	 * 绑定事件
	 */
	bindEvent: function() {
		$("#btnSaveYundanId").click($.csBlEditYunDan.save);
		$("#btnCancelYunId").click($.csCore.close);
	},
	
	/**
	 * 验证
	 */
	validate: function() {
		if($.csValidator.checkNull("yundanId",$.csCore.getValue("Common_Required","Delivery_TrackingNO"))){
			return false;
		}
		return true;
	},
	
	/**
	 * 保存
	 */
	save: function() {
		if ($.csBlEditYunDan.validate()) {
			if($.csCore.postData($.csCore.buildServicePath('/service/bldelivery/saveyundanId'), 'form')){
		    	$.csBlDeliveryHList.list(0);
		    	$.csCore.close();
		    }
		}
	},
	
	/**
	 * 初始化
	 */
	init: function(deliveryId, yundanId) {
		$.csBlEditYunDan.bindLabel();
		$.csBlEditYunDan.bindEvent();
		$('#form').resetForm();
		if (yundanId !=null || yundanId != "") {
			$("#yundanId").val(yundanId);
		}
		$("#deliveryId").val(deliveryId);
	}
};